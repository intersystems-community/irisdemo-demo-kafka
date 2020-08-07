#!/bin/bash

(cd ./kafka-pex-adapter && ./build.sh)

VERSION=`cat ../VERSION`
DOCKER_TAG="version-${VERSION}"

IMAGE_NAME=intersystemsdc/irisdemo-demo-kafka:iris-datasource-${DOCKER_TAG}
docker build -t $IMAGE_NAME ./

echo $IMAGE_NAME >> ../images_built
