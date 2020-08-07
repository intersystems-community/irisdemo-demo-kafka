package com.irisdemo.kafka.config;

import org.springframework.stereotype.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.*;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;

@Component
@Scope(value = ConfigurableBeanFactory.SCOPE_SINGLETON)
public class Config 
{
	Logger logger = LoggerFactory.getLogger(Config.class);
	
	/*
	WORKER CONFIGURATION
	*/
	private String masterHostName;
	private String masterPort;
	private String thisHostName;
	private int thisServerPort;
	private String workerNodePrefix;
	
	/* 
	GENERAL CONFIGURATION THAT WILL BE COMING FROM THE MASTER
	*/
	private boolean startConsumers;

	/* 
	GENERAL CONFIGURATION 
	*/
	private String kafkaBootstrapServersConfig;
	private String schemaRegistryURLConfig;
	private String avroSchema;

	/* 
	PRODUCER CONFIGURATION 
	*/	
	//private int consumerFlushSize;
	//private int consumerThreadsPerWorker;
	//private long consumerThrottlingInMillis;
	//private String consumerTopic;

	/*
	PREVIOSLY EXISITNG CONFIGS
	*/
	private int consumptionNumThreadsPerWorker;
	private int consumptionTimeBetweenQueriesInMillis;
	private int consumptionNumOfKeysToFetch;

	public void setWorkerNodePrefix(String workerNodePrefix)
	{
		this.workerNodePrefix=workerNodePrefix;
	}
	
	public String getWorkerNodePrefix()
	{
		return this.workerNodePrefix;
	}
	
	@Value( "${HOSTNAME}" )
	public void setThisHostName(String thisHostName) {
		logger.info("This hostname is " + thisHostName);
		this.thisHostName = thisHostName;
	}

	public String getThisHostName() {
		return thisHostName;
	}

	public String getMasterHostName() {
		return masterHostName;
	}
		
	@Value( "${MASTER_HOSTNAME}" )
	public void setMasterHostName(String masterHostName) {
		logger.info("Setting MASTER_HOSTNAME = " + masterHostName);
		this.masterHostName = masterHostName;
	}

	public String getMasterPort() {
		return masterPort;
	}
		
	@Value( "${MASTER_PORT:80}" )
	public void setMasterPort(String masterPort) {
		logger.info("Setting MASTER_PORT = " + masterPort);
		this.masterPort = masterPort;
	}

	public void setThisServerPort(int thisServerPort) {
		logger.info("This server port is " + thisServerPort);
		this.thisServerPort = thisServerPort;
	}

	public int getThisServerPort() {
		return this.thisServerPort;
	}

	public void setConsumptionNumOfKeysToFetch(int consumptionNumOfKeysToFetch) {
		logger.info("Number of keys to fetch: " + consumptionNumOfKeysToFetch);
		this.consumptionNumOfKeysToFetch = consumptionNumOfKeysToFetch;
	}

	public int getConsumptionNumOfKeysToFetch() {
		return this.consumptionNumOfKeysToFetch;
	}

	public boolean getStartConsumers() {
		return startConsumers;
	}
	
	public void setStartConsumers(boolean startConsumers) {
		logger.info("Setting START_CONSUMERS = " + startConsumers);
		this.startConsumers = startConsumers;
	}

	public int getConsumptionNumThreadsPerWorker() {
		return consumptionNumThreadsPerWorker;
	}
	
	public void setConsumptionNumThreadsPerWorker(int consumptionNumThreadsPerWorker) {
		logger.info("Setting CONSUMER_THREADS_PER_WORKER = " + consumptionNumThreadsPerWorker);
		this.consumptionNumThreadsPerWorker = consumptionNumThreadsPerWorker;
	}

	public int getConsumptionTimeBetweenQueriesInMillis() {
		return consumptionTimeBetweenQueriesInMillis;
	}
	
	public void setConsumptionTimeBetweenQueriesInMillis(int consumptionTimeBetweenQueriesInMillis) {
		logger.info("Setting CONSUMER_TIME_BETWEEN_QUERIES_IN_MILLIS = " + consumptionTimeBetweenQueriesInMillis);
		this.consumptionTimeBetweenQueriesInMillis = consumptionTimeBetweenQueriesInMillis;
	}

	public void setSchemaRegistryURLConfig(String schemaRegistryURLConfig)
	{
		logger.info("Got Kafka schema registry = " + schemaRegistryURLConfig);
		this.schemaRegistryURLConfig = schemaRegistryURLConfig;
	}

	public String getSchemaRegistryURLConfig()
	{
		return schemaRegistryURLConfig;
	}

	public void setKafkaBootstrapServersConfig(String kafkaBootstrapServersConfig)
	{
		logger.info("Got Kafka endpoint = " + kafkaBootstrapServersConfig);
		this.kafkaBootstrapServersConfig = kafkaBootstrapServersConfig;
	}

	public String getKafkaBootstrapServersConfig()
	{
		return kafkaBootstrapServersConfig;
	}

	public void setAvroSchema(String avroSchema)
	{
		logger.info("Got avro schema = " + avroSchema);
		this.avroSchema = avroSchema;
	}

	public String getAvroSchema()
	{
		return avroSchema;
	}

}