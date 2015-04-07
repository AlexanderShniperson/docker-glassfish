#!/bin/bash
IMAGE_NAME=glassfish:4.1
JAVA_VERSION="8u40"
JAVA_PKG="jdk-${JAVA_VERSION}-linux-x64.rpm"
#JAVA_PKG_MD5="e4b51683e1f69e502e6fdd23e54ca0f2"

# Validate Java Package
echo "====================="

if [ ! -e $JAVA_PKG ]
then
  echo "Download the Oracle JDK ${JAVA_VERSION} RPM for 64 bit and"
  echo "drop the file $JAVA_PKG in this folder before"
  echo "building this image!"
  exit
fi

#MD5="$JAVA_PKG_MD5  $JAVA_PKG"
#MD5_CHECK="`md5sum $JAVA_PKG`"

#if [ "$MD5" != "$MD5_CHECK" ]
#then
#  echo "MD5 for $JAVA_PKG does not match! Download again!"
#  exit
#fi

docker build -t $IMAGE_NAME .

echo ""
echo "====================="
echo "Installing glassfish service to run under SystemD"
cp ./glassfish.service /etc/systemd/system/
systemctl enable /etc/systemd/system/glassfish.service
echo "Ready."

echo ""
echo "GlassFish Docker Container is ready to be used. To start, run 'systemctl start glassfish'"
