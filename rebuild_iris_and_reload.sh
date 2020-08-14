#!/bin/bash

source ./buildtools.sh

echo "Stopping the iris container..."
docker-compose stop iris-datasource
exit_if_error "Could not stop iris-datasource"

echo "Deleting the iris container..."
docker-compose rm -f iris-datasource
exit_if_error "Could not delete iris-datasource"

echo "Rebuilding..."
cd ./image-iris-datasource
./build.sh
exit_if_error "Could not build image-iris-datasource"

echo "Restarting the iris container..."
docker-compose up -d iris-datasource