#!/bin/bash

docker-compose exec broker /usr/bin/kafka-topics --create --bootstrap-server broker:9092 --replication-factor 1 --partitions 1 --topic testtopic