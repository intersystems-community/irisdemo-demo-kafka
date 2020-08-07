package com.irisdemo.kafka.config;

import org.springframework.stereotype.*;

import java.io.IOException;

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
	GENERAL CONFIGURATION 
	*/
	private boolean startConsumers;
	private String title;
	private int maxTimeToRunInSeconds = 300;
	private int numberOfActiveIngestionThreads;
	private String kafkaBootstrapServersConfig;
	private String schemaRegistryURLConfig;

	/* 
	PRODUCER CONFIGURATION 
	*/
	private int producerFlushSize;
	private int producerThreadsPerWorker;
	private long producerThrottlingInMillis;
	private int bankSimDays;
	private int bankSimNumEvents;
	private int bankSimNumCustomers;

	/* 
	CONSUMPTION CONFIGURATION 
	*/
	private String consumptionJDBCURL;
	private String consumptionJDBCUserName;
	private String consumptionJDBCPassword;
	private int consumptionNumThreadsPerWorker;
	private int consumptionTimeBetweenQueriesInMillis;
	private String queryStatement;
	private String queryByIdStatement;
	private int consumptionNumOfKeysToFetch;




	public int getConsumptionNumOfKeysToFetch()
	{
		return consumptionNumOfKeysToFetch;
	}

	public int getNumberOfActiveIngestionThreads()
	{
		return this.numberOfActiveIngestionThreads;
	}

	public void setNumberOfActiveIngestionThreads(int numberOfActiveIngestionThreads)
	{
		this.numberOfActiveIngestionThreads = numberOfActiveIngestionThreads;
	}

	public int getMaxTimeToRunInSeconds()
	{
		return maxTimeToRunInSeconds;
	}

	public void setMaxTimeToRunInSeconds(int maxTimeToRunInSeconds)
	{
		this.maxTimeToRunInSeconds=maxTimeToRunInSeconds;
	}

	@Value( "${PRODUCER_THROTTLING:10}" )
	public void setProducerThrottlingInMillis(long val)
	{
		logger.info("Setting producer throttling in Millis to " + val + "ms.");
		this.producerThrottlingInMillis=val;
	}

	public long getProducerThrottlingInMillis()
	{
		return this.producerThrottlingInMillis;
	}

	@Value( "${MASTER_SPEEDTEST_TITLE:IRIS Speed Test}" )
	public void setTitle(String title)
	{
		logger.info("Setting MASTER_SPEEDTEST_TITLE = " + title);
		this.title=title;
	}

	public String getTitle()
	{
		return this.title;
	}

	public int getProducerThreadsPerWorker() 
	{
		return producerThreadsPerWorker;
	}

	@Value( "${PRODUCER_THREADS_PER_WORKER:10}" )
	public void setProducerThreadsPerWorker(int value) 
	{
		logger.info("Setting producer Threads Per Worker = " + value);
		producerThreadsPerWorker=value;
	}

	public int getProducerFlushSize() 
	{
		return producerFlushSize;
	}

	@Value( "${PRODUCER_FLUSH_SIZE:1000}" )
	public void setProducerFlushSize(int value) 
	{
		logger.info("Setting producer flush size = " + value);
		producerFlushSize=value;
	}

	@Value( "${BANKSIM_NUM_DAYS:30}" )
	public void setBankSimDays(int bankSimDays) {
		logger.info("Setting Bank Simulation Number of Days = " + bankSimDays);
		this.bankSimDays = bankSimDays;
	}

	public int getBankSimDays() 
	{
		return bankSimDays;
	}

	@Value( "${BANKSIM_NUM_EVENTS:5000000}" )
	public void setBankSimNumEvents(int bankSimNumEvents) {
		logger.info("Setting Bank Simulation Number of Events = " + bankSimNumEvents);
		this.bankSimNumEvents = bankSimNumEvents;
	}

	public int getBankSimNumEvents() 
	{
		return bankSimNumEvents;
	}

	@Value( "${BANKSIM_NUM_CUSTOMERS:10000}" )
	public void setBankSimNumCustomers(int bankSimNumCustomers) {
		logger.info("Setting Bank Simulation Number of Customers = " + bankSimNumCustomers);
		this.bankSimNumCustomers = bankSimNumCustomers;
	}

	public int getBankSimNumCustomers() 
	{
		return bankSimNumCustomers;
	}
	public boolean getStartConsumers() {
		return startConsumers;
	}
	
	@Value( "${START_CONSUMERS:true}" )
	public void setStartConsumers(boolean startConsumers) {
		logger.info("Setting START_CONSUMERS = " + startConsumers);
		this.startConsumers = startConsumers;
	}

	public String getSchemaRegistryURLConfig() {
		return schemaRegistryURLConfig;
	}

	@Value( "${KAFKA_SCHEMA_REGISTRY_URL_CONFIG}" )
	public void setSchemaRegistryURLConfig(String schemaRegistryURLConfig) {
		logger.info("Setting KAFKA_SCHEMA_REGISTRY_URL_CONFIG = " + schemaRegistryURLConfig);
		this.schemaRegistryURLConfig = schemaRegistryURLConfig;
	}

	public String getKafkaBootstrapServersConfig() {
		return kafkaBootstrapServersConfig;
	}

	@Value( "${KAFKA_BOOTSTRAP_SERVERS_CONFIG}" )
	public void setKafkaBootstrapServersConfig(String kafkaBootstrapServersConfig) {
		logger.info("Setting KAFKA_BOOTSTRAP_SERVERS_CONFIG = " + kafkaBootstrapServersConfig);
		this.kafkaBootstrapServersConfig = kafkaBootstrapServersConfig;
	}

	public String getConsumptionJDBCURL() {
		return consumptionJDBCURL;
	}
	
	@Value( "${CONSUMER_JDBC_URL}" )
	public void setConsumptionJDBCURL(String consumptionJDBCURL) {
		logger.info("Setting CONSUMER_JDBC_URL = " + consumptionJDBCURL);
		this.consumptionJDBCURL = consumptionJDBCURL;
	}

	public String getConsumptionJDBCUserName() {
		return consumptionJDBCUserName;
	}
	
	@Value( "${CONSUMER_JDBC_USERNAME}" )
	public void setConsumptionJDBCUserName(String consumptionJDBCUserName) {
		logger.info("Setting CONSUMER_JDBC_USERNAME = " + consumptionJDBCUserName);
		this.consumptionJDBCUserName = consumptionJDBCUserName;
	}

	public String getConsumptionJDBCPassword() {
		return consumptionJDBCPassword;
	}
	
	@Value( "${CONSUMER_JDBC_PASSWORD}" )
	public void setConsumptionJDBCPassword(String consumptionJDBCPassword) {
		logger.info("Setting CONSUMER_JDBC_PASSWORD = " + consumptionJDBCPassword);
		this.consumptionJDBCPassword = consumptionJDBCPassword;
	}

	public int getConsumptionNumThreadsPerWorker() {
		return consumptionNumThreadsPerWorker;
	}
	
	@Value( "${CONSUMER_THREADS_PER_WORKER:10}" )
	public void setConsumptionNumThreadsPerWorker(int consumptionNumThreadsPerWorker) {
		logger.info("Setting CONSUMER_THREADS_PER_WORKER= " + consumptionNumThreadsPerWorker);
		this.consumptionNumThreadsPerWorker = consumptionNumThreadsPerWorker;
	}

	public int getConsumptionTimeBetweenQueriesInMillis() {
		return consumptionTimeBetweenQueriesInMillis;
	}
	
	@Value( "${CONSUMER_TIME_BETWEEN_QUERIES_IN_MILLIS:0}" )
	public void setConsumptionTimeBetweenQueriesInMillis(int consumptionTimeBetweenQueriesInMillis) {
		logger.info("Setting CONSUMER_TIME_BETWEEN_QUERIES_IN_MILLIS = " + consumptionTimeBetweenQueriesInMillis);
		this.consumptionTimeBetweenQueriesInMillis = consumptionTimeBetweenQueriesInMillis;
	}

}