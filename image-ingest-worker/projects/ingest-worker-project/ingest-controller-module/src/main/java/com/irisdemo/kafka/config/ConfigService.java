package com.irisdemo.kafka.config;

import org.springframework.stereotype.Service;

import java.net.ConnectException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.boot.web.servlet.context.ServletWebServerInitializedEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.context.annotation.Scope;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

@Service
@Scope(value = ConfigurableBeanFactory.SCOPE_SINGLETON)
public class ConfigService implements ApplicationListener<ServletWebServerInitializedEvent>
{
    @Autowired
    Config config;
    
    @Autowired
    RestTemplate restTemplate;
    
    Logger logger = LoggerFactory.getLogger(ConfigService.class);
    
	@Override
	public void onApplicationEvent(final ServletWebServerInitializedEvent event)
	{
		config.setThisServerPort(event.getWebServer().getPort());
		
		try 
		{
			registerWithMasterAndGetConfig();
		} 
		catch (Exception e) {
			logger.error(e.getMessage());
			System.exit(1);
		}
	}

    public void registerWithMasterAndGetConfig() throws Exception
    {
    	String registrationUrl = "http://" + config.getMasterHostName()+":"+config.getMasterPort()+"/master/ingestworker/register/" + config.getThisHostName() + ":" + config.getThisServerPort();
    	
		logger.info("Registering with " + registrationUrl);
		
		boolean retry = true;
		int retryCount = 0;

		do 
		{	
			try
			{    			
				RESTWorkerConfig workerConfig = restTemplate.getForObject(registrationUrl, RESTWorkerConfig.class);

				config.setWorkerNodePrefix(workerConfig.workerNodePrefix);
				config.setAvroSchema(workerConfig.config.avroSchema);

				config.setKafkaBootstrapServersConfig(workerConfig.config.kafkaBootstrapServersConfig);
				config.setSchemaRegistryURLConfig(workerConfig.config.schemaRegistryURLConfig);
				
				config.setProducerFlushSize(workerConfig.config.producerFlushSize);
				config.setProducerThreadsPerWorker(workerConfig.config.producerThreadsPerWorker);
				config.setProducerThrottlingInMillis(workerConfig.config.producerThrottlingInMillis);

				config.setBankSimDays(workerConfig.config.bankSimDays);
				config.setBankSimNumEvents(workerConfig.config.bankSimNumEvents);
				config.setBankSimNumCustomers(workerConfig.config.bankSimNumCustomers);
				
				logger.info("Registration successful. Configuration data received and stored.");

				//We did it! No need for retrying
				retry = false;
			}
			catch (Exception restException)
			{
				// Wait for 1 second an try again
				if (retryCount<15)
				{
					logger.info("Count not register with master. Retrying in 1 second...");
					Thread.sleep(1000);
				}
				else
				{
					logger.info("Worker on " + config.getThisHostName() + " is not responding. Marking worker as unavailablebecause of: " + restException.getMessage());
					retry = false;
				}
			}
		} 
		while (retry);
	} 
}