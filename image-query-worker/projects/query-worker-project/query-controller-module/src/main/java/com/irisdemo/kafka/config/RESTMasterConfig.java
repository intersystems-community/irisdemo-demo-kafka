package com.irisdemo.kafka.config;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class RESTMasterConfig 
{

	/* 
	GENERAL CONFIGURATION 
	*/
	public String kafkaBootstrapServersConfig;
	public String schemaRegistryURLConfig;
	public String avroSchema;
	
	/* 
	CONSUMPTION CONFIGURATION 
	*/
	public int consumptionNumThreadsPerWorker;
	public int consumptionTimeBetweenQueriesInMillis;
	public int consumptionNumOfKeysToFetch;
}
