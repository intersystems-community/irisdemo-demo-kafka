package com.irisdemo.kafka.config;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class RESTWorkerConfig 
{
	public String workerNodePrefix;
	public RESTMasterConfig config;
}
