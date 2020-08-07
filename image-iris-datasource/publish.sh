#!/bin/bash

docker-compose exec broker /usr/bin/kafka-console-producer --bootstrap-server broker:9092 --topic testtopic --property parse.key=true --property key.separator=: