# GlassFish 4.1 Docker image

This is a Dockerfile for [GlassFish Open Source Edition](http://www.glassfish.org) for version 4.1. The purpose of this Docker container is to facilitate the setup of development and integration testing environments for developers.

## Based on Oracle Linux 7 Base Docker Image
For more information and documentation, read the [Docker Images from Oracle Linux](http://public-yum.oracle.com/docker-images) page.

## How to build

1. Checkout the GitHub glassfish/dockerfiles repository

	$ git checkout https://github.com/AlexanderShniperson/docker-glassfish.git glassfish-docker
	
	$ cd glassfish-docker

2. [Download](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) and drop the Oracle JDK 8u40 RPM 64bit file **jdk-8u40-linux-x64.rpm** in this folder

	Linux x64       135.6 MB        jdk-8u40-linux-x64.rpm

2.1 [Download](http://dlc-cdn.sun.com/glassfish/4.1/release/glassfish-4.1.zip) and drop the file glassfish-4.1.zip in this folder

3. Execute the build script as root

	$ sudo sh build.sh

## Default Username and Password
The image and the default domain are built with the following credentials:

 * Username: admin
 * Password: glassfish

## Booting up GlassFish on Docker

At terminal run:
	$ systemctl start glassfish

This script will automagically start default **domain1** and the container will be daemonized.

## Deploying Java EE Applications

You can use the GlassFish Maven Plugin or the Web Console to deploy applications to the remote servers running on Docker containers.

## Dockerfile Source
All source is on the [glassfish/docker GitHub repository](https://github.com/glassfish/docker).

If you find any issues, please report through the [GitHub Issues page](https://github.com/glassfish/docker/issues).

## License
For the scripts and files hosted in the GitHub [glassfish/dockerfiles](https://github.com/glassfish/docker/) repository required to build the Docker image are, unless otherwise noted, released under the Common Development and Distribution License (CDDL) 1.0 and GNU Public License 2.0 licenses.

