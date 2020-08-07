#!/bin/bash

docker-compose stop iris-datasource
docker-compose rm -f iris-datasource
(cd ./image-iris-datasource && ./build.sh)
docker-compose up -d iris-datasource