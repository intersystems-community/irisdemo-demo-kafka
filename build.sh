#!/bin/bash
VERSION=`cat ./VERSION`
DOCKER_TAG="version-${VERSION}"

source ./buildtools.sh

# funtion build_java_project will add a line with the full image name of each image built
# But we need to start with an empty file:
rm -f ./images_built

###############################################################
# IRIS Data Source Image
###############################################################
# (cd ./image-iris-datasource && ./build.sh)

###############################################################
# Master Image
###############################################################
build_java_project "image-master"

###############################################################
# Ingestion Worker Images
###############################################################
build_java_project "image-ingest-worker"

###############################################################
# Query Worker Images
###############################################################
# build_java_project "image-query-worker"

###############################################################
# UI Image
###############################################################
UI_IMAGE_NAME=intersystemsdc/irisdemo-demo-kafka:ui-${DOCKER_TAG}
docker build -t $UI_IMAGE_NAME ./image-ui
# This  image was not built with the function build_java_project(). So we will
# add the full image name ourselves.
echo $UI_IMAGE_NAME >> ./images_built


# It is necessary to build the application this way as well so it can be run standalone, without dockers.
# (cd ./image-ui && npm install)

