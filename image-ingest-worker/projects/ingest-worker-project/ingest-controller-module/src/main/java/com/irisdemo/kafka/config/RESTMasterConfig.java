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
	PRODUCER CONFIGURATION 
	*/	
	public int producerFlushSize;
	public int producerThreadsPerWorker;
	public long producerThrottlingInMillis;
	public int bankSimDays;
	public int bankSimNumEvents;
	public int bankSimNumCustomers;


}
