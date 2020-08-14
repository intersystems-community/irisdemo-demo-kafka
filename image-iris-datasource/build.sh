#!/bin/bash

source ../buildtools.sh

# cd ./kafka-pex-adapter
# ./build.sh
# go_up_tree_and_exit_if_error "kafka-pex-adapter could not be built"
# cd ..

VERSION=`cat ../VERSION`
DOCKER_TAG="version-${VERSION}"

IMAGE_NAME=intersystemsdc/irisdemo-demo-kafka:iris-datasource-${DOCKER_TAG}
docker build -t $IMAGE_NAME ./
go_up_tree_and_exit_if_error "IRIS Image could not be built"

echo $IMAGE_NAME >> ../images_built
