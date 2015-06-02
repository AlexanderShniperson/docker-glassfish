#!/bin/bash

SHUTDOWN=0
trap "SHUTDOWN=1" HUP INT QUIT KILL TERM

set -e

hostIP="$(hostname -i)"
export hostIP
export LANG=ru_RU.UTF-8
mkdir -p /opt/glassfish/applications
chown -R glassfish:glassfish /opt/glassfish
su glassfish <<EOSU
echo "hostIP=${hostIP}"
./asadmin start-domain domain1
find /opt/glassfish/applications/ -name "*-ds.xml" -exec echo "Installing ds resources from " {} \; -exec ./asadmin --user admin --passwordfile ./pwdfile --echo=true --interactive=false add-resources  {} \; -exec echo "Done installing " {} \;
find /opt/glassfish/applications/ -name "*.war" -exec echo "Installing application " {} \; -exec ./asadmin --user admin --passwordfile ./pwdfile deploy {} \; -exec echo "Done deploying " {} \;
EOSU
echo "Startup done"

if [ "$1" == "glassfish" ]; then
  echo "[CTRL + C to exit] or run 'docker stop <container>'"
  while ((SHUTDOWN != 1))
  do
     sleep 1
  done
  echo "Stopping glassfish "
  su glassfish -c "./asadmin stop-domain domain1"
  echo "Stopped $0"
else
   exec "$1"
fi


