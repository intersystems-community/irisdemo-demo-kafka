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
	WORKER CONFIGURATION COMING FROM THE MASTER
	*/

	private String masterHostName;
	private String masterPort;
	private String thisHostName;
	private int thisServerPort;
	private String workerNodePrefix;
	
	/* 
	GENERAL CONFIGURATION 
	*/
	private String kafkaBootstrapServersConfig;
	private String schemaRegistryURLConfig;
	private String avroSchema;

	/* 
	PRODUCER CONFIGURATION 
	*/	
	private int producerFlushSize;
	private int producerThreadsPerWorker;
	private long producerThrottlingInMillis;
	private String producerTopic;
	private int bankSimDays;
	private int bankSimNumEvents;
	private int bankSimNumCustomers;
		
	public void setProducerThrottlingInMillis(long producerThrottlingInMillis)
	{
		this.producerThrottlingInMillis=producerThrottlingInMillis;
	}

	public long getProducerThrottlingInMillis()
	{
		return this.producerThrottlingInMillis;
	}

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

	public void setThisServerPort(int thisServerPort) {
		logger.info("This server port is " + thisServerPort);
		this.thisServerPort = thisServerPort;
	}

	public int getThisServerPort() {
		return this.thisServerPort;
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
	
	public int getProducerThreadsPerWorker() 
	{
		return producerThreadsPerWorker;
	}
	
	public void setProducerThreadsPerWorker(int value) 
	{
		logger.info("Setting Producer Threads Per Worker = " + value);
		this.producerThreadsPerWorker=value;
	}

	public void setBankSimDays(int bankSimDays) {
		logger.info("Setting Bank Simulation Number of Days = " + bankSimDays);
		this.bankSimDays = bankSimDays;
	}

	public int getBankSimDays() 
	{
		return bankSimDays;
	}

	public void setBankSimNumEvents(int bankSimNumEvents) {
		logger.info("Setting Bank Simulation Number of Events = " + bankSimNumEvents);
		this.bankSimNumEvents = bankSimNumEvents;
	}

	public int getBankSimNumEvents() 
	{
		return bankSimNumEvents;
	}

	public void setBankSimNumCustomers(int bankSimNumCustomers) {
		logger.info("Setting Bank Simulation Number of Customers = " + bankSimNumCustomers);
		this.bankSimNumCustomers = bankSimNumCustomers;
	}

	public int getBankSimNumCustomers() 
	{
		return bankSimNumCustomers;
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
	
	public int getProducerFlushSize() 
	{
		return producerFlushSize;
	}

	public void setProducerFlushSize(int value) 
	{
		logger.info("Setting producer flush size = " + value);
		this.producerFlushSize=value;
	}

}