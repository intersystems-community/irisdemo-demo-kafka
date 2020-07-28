#!/bin/bash
VERSION=`cat ../VERSION`
DOCKER_TAG="version-${VERSION}"

UI_IMAGE_NAME=intersystemsdc/irisdemo-demo-kafka:iris-datasource-${DOCKER_TAG}
docker build -t $UI_IMAGE_NAME ./
