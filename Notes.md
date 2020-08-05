Start it with:

docker-compose up


Wait for the broker and the other pieces to start.

Here is where you will find things:

UI: http://localhost:10000

Control Center: http://localhost:9021

Where is the broker: http://localhost:9092

Schema Registry: http://localhost:8081

http://localhost:8081/subjects/customer_demographics-value/versions/1

https://docs.confluent.io/current/schema-registry/schema_registry_tutorial.html


The demo relies on an unreleased version of irisdemo-base-irisint:version-1.8.0. This version of
the irisint base image is based on IRIS 2020.4.0ETL.130.0 which includes the code for Java ETL that
supports creating IRIS classes based on Avro Schema provided by Dan Pasco.

I have a branch on irisdemo-base-irisint called "etl-avro-support" that I am using to build version-1.8.0.

The problem with working with an unreleased version of IRIS is that I must probably use the same version of
jar libraries that come with them. So I have generated a new version of mavenc: version-1.4.0 that brings
these new versions of jar files. It is then important to build first irisint before building mavenc.

Kafka Cluster started based on docmer-comopose.yml file from:
- https://github.com/confluentinc/cp-all-in-one/blob/5.5.1-post/cp-all-in-one/docker-compose.yml

Kafka Control Center can be found at:
- http://localhost:9021

Tutorial: https://docs.confluent.io/current/schema-registry/schema_registry_tutorial.html

Vailable SerDes:
- https://docs.confluent.io/current/streams/developer-guide/datatypes.html