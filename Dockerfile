# LICENSE CDDL 1.0 + GPL 2.0
#
# ORACLE DOCKERFILES PROJECT
# --------------------------
# This is the Dockerfile for GlassFish 4.1
# 
# REQUIRED BASE IMAGE TO BUILD THIS IMAGE
# ---------------------------------------
# Make sure you have oraclelinux:7.1 Docker image installed.
# Visit for more info: http://public-yum.oracle.com/docker-images/
#
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
# (1) jdk-8u40-linux-x64.rpm
#     Download from http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put all downloaded files in the same directory as this Dockerfile
# Run: 
#      $ sudo sh build.sh
#

# Pull base image.
FROM oraclelinux:7.1 

# Maintainer
# ----------
MAINTAINER Bruno Borges <bruno.borges@oracle.com>

# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------
ENV JAVA_RPM jdk-8u40-linux-x64.rpm
ENV GLASSFISH_PKG glassfish-4.1.zip
ENV POSTGRE_JDBC_PKG http://jdbc.postgresql.org/download/postgresql-9.3-1102.jdbc4.jar

# Install and configure Oracle JDK 8u40
# -------------------------------------
ADD $JAVA_RPM /root/
RUN rpm -i /root/$JAVA_RPM && rm /root/$JAVA_RPM
ENV JAVA_HOME /usr/java/default
ENV CONFIG_JVM_ARGS -Djava.security.egd=file:/dev/./urandom

# Setup required packages (unzip), filesystem, and oracle user
# ------------------------------------------------------------
# Enable this if behind proxy
# RUN sed -i -e '/^\[main\]/aproxy=http://proxy.com:80' /etc/yum.conf
RUN yum install -y unzip && yum clean all
RUN useradd -mU glassfish -b /opt/ && echo glassfish:glassfish | chpasswd
ADD $GLASSFISH_PKG /opt/glassfish/
RUN cd /opt/glassfish/ && unzip $GLASSFISH_PKG && rm $GLASSFISH_PKG
RUN curl $POSTGRE_JDBC_PKG -o /opt/glassfish/glassfish4/glassfish/lib/postgresql-9.3-1102.jdbc4.jar
ADD glassfish-start.sh /opt/glassfish/
RUN chown -R glassfish:glassfish /opt/glassfish/
RUN chmod +x /opt/glassfish/glassfish-start.sh

WORKDIR /opt/glassfish/glassfish4/bin

# User: admin / Pass: glassfish
RUN echo "admin;{SSHA256}80e0NeB6XBWXsIPa7pT54D9JZ5DR5hGQV1kN1OAsgJePNXY6Pl0EIw==;asadmin" > /opt/glassfish/glassfish4/glassfish/domains/domain1/config/admin-keyfile
RUN echo "AS_ADMIN_PASSWORD=glassfish" > pwdfile

# Default to admin/glassfish as user/pass
RUN \
  ./asadmin start-domain domain1 && \
  ./asadmin --user admin --passwordfile pwdfile --host localhost --port 4848 enable-secure-admin &&\
  ./asadmin --user admin --passwordfile pwdfile set "server.network-config.protocols.protocol.http-listener-2.security-enabled=false" && \
  ./asadmin stop-domain domain1

RUN echo "export PATH=$PATH:/opt/glassfish/glassfish4/bin" >> /opt/glassfish/.bashrc

# Default command to run on container boot
ENTRYPOINT ["/opt/glassfish/glassfish-start.sh"]
CMD ["glassfish"]
