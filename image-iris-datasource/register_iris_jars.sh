#!/bin/bash

# I created this script in order to extract the InterSystems jar files from the iris docker container
# and register them on my local maven so that I can 

# To run this script, make sure docker-compose up is run first.

rm -rf ./irislib
mkdir ./irislib

docker cp iris-datasource:/usr/irissys/dev/java/lib/JDK18/intersystems-jdbc-3.2.0.jar ./irislib/
docker cp iris-datasource:/usr/irissys/dev/java/lib/JDK18/intersystems-xep-3.2.0.jar ./irislib/
docker cp iris-datasource:/usr/irissys/dev/java/lib/JDK18/intersystems-utils-3.2.0.jar ./irislib/

mvn install:install-file -Dfile=./irislib/intersystems-jdbc-3.2.0.jar \
-DgroupId=com.intersystems \
-DartifactId=intersystems-jdbc \
-Dversion=3.2.0 \
-Dpackaging=jar \
-DcreateChecksum=true

mvn install:install-file -Dfile=./irislib/intersystems-xep-3.2.0.jar \
-DgroupId=com.intersystems \
-DartifactId=intersystems-xep \
-Dversion=3.2.0 \
-Dpackaging=jar \
-DcreateChecksum=true

mvn install:install-file -Dfile=./irislib/intersystems-utils-3.2.0.jar \
-DgroupId=com.intersystems \
-DartifactId=intersystems-utils \
-Dversion=3.2.0 \
-Dpackaging=jar \
-DcreateChecksum=true
