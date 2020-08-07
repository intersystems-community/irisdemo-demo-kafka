FROM intersystemsdc/irisdemo-base-java:latest

LABEL maintainer="Amir Samary <amir.samary@intersystems.com>"

# Defaul Java options - You can override this when running the container
ENV JAVA_OPTS=-Xmx1024M

# Default configuration. Should be replaced on docker run or docker-compose.yml file
ENV MASTER_SPEEDTEST_TITLE=InterSystems IRIS Kafka Demo with AVRO and Schema Evolution
ENV PRODUCER_THROTTLING=10
ENV START_CONSUMERS=false
ENV PRODUCER_FLUSH_SIZE=1000
ENV PRODUCER_THREADS_PER_WORKER=1
ENV KAFKA_BOOTSTRAP_SERVERS_CONFIG=http://broker:29092
ENV KAFKA_SCHEMA_REGISTRY_URL_CONFIG=http://schema-registry:8081
ENV BANKSIM_NUM_DAYS=30
ENV BANKSIM_NUM_EVENTS=5000000
ENV BANKSIM_NUM_CUSTOMERS=100000

ADD ./projects/app.jar /app/

HEALTHCHECK --interval=5s --timeout=3s \
  CMD curl -f http://localhost:8080/master/test || exit 1