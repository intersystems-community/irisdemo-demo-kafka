#!/bin/bash

docker run --name iris-data-sink --rm --init -p 52773:52773 -p 51773:51773 intersystemsdc/irisdemo-demo-restm2:iris-data-sink-version-1.1.1
