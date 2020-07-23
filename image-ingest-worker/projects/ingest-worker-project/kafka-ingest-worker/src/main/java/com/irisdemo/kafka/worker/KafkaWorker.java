package com.irisdemo.kafka.worker;

import java.io.IOException;
import java.util.concurrent.CompletableFuture;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.HttpEntity;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.irisdemo.kafka.config.Config;
import com.irisdemo.kafka.workersrv.IWorker;
import com.irisdemo.kafka.workersrv.WorkerMetricsAccumulator;
import com.irisdemo.kafka.workersrv.WorkerSemaphore;

import io.confluent.kafka.serializers.AbstractKafkaSchemaSerDeConfig;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.common.serialization.StringSerializer;
import io.confluent.kafka.serializers.KafkaAvroSerializer;
import org.apache.kafka.common.errors.SerializationException;

import io.confluent.examples.clients.basicavro.Payment;

import java.util.Properties;

@Component("worker")
@Scope(value = ConfigurableBeanFactory.SCOPE_SINGLETON)
public class KafkaWorker implements IWorker 
{
	protected static Logger logger = LoggerFactory.getLogger(KafkaWorker.class);
	
    @Autowired
    protected WorkerSemaphore workerSemaphore;
    
    @Autowired 
    protected WorkerMetricsAccumulator accumulatedMetrics;
    
    @Autowired
    protected Config config;    
    
    @Autowired
	protected RandomDataGenerator randomDataGenerator;
	
	protected KafkaProducer<String, Payment> producer = null;

	protected static char[] prefixes = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};

	public void closeKafkaProducer() throws Exception
	{
		producer.close();
		producer = null;
	}

	public void initiateKafkaProducer() throws Exception
	{
		final Properties props = new Properties();
        props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, config.getKafkaBootstrapServersConfig());
        props.put(ProducerConfig.ACKS_CONFIG, "all");
        props.put(ProducerConfig.RETRIES_CONFIG, 0);
        props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class);
		props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, KafkaAvroSerializer.class);
		props.put(AbstractKafkaSchemaSerDeConfig.SCHEMA_REGISTRY_URL_CONFIG, config.getSchemaRegistryURLConfig());
		
		producer = new KafkaProducer<String, Payment>(props);
	}

	@Async("workerExecutor")
    public CompletableFuture<Long> startOneFeed(String nodePrefix, int threadNum) throws IOException, RestClientException
    {	
		long recordNum = 0;
		long batchSizeInBytes;

		ProducerRecord<String, Payment> record = null;
		long producerThrottlingInMillis = config.getProducerThrottlingInMillis();

		accumulatedMetrics.incrementNumberOfActiveIngestionThreads();

		String topic = config.getProducerTopic();

		logger.info("Ingestion worker #"+threadNum+" started. Sending messages to topic " + topic);

		randomDataGenerator.initializeRandomMapping();

		String schema = config.getSchemaVersion();
		try
		{
			int currentRecord = 0;
			int currentBatchSize;

			String threadPrefix = nodePrefix+prefixes[threadNum];
			
			Payment payment = new Payment();
			String orderId;

	    	while(workerSemaphore.green())
	    	{
	    		currentBatchSize = 0;
	    		batchSizeInBytes = 0;
	    		
	    		while(workerSemaphore.green())
	    		{
	    			if (currentBatchSize==config.getProducerFlushSize()) 
	    				break;

					//randomDataGenerator.populateJSONRequest(requestJSON, threadPrefix, schema, ++currentRecord);
				
					payment.setId(threadPrefix + recordNum++);
					payment.setAmount(Math.random()*1000d);
			
					record = new ProducerRecord<String, Payment>(topic, payment.getId().toString(), payment);
					producer.send(record);
					
					currentBatchSize++;
				}
				
				if(workerSemaphore.green())
				{
					producer.flush();

					accumulatedMetrics.addToStats(currentBatchSize, batchSizeInBytes);

					if (producerThrottlingInMillis>0)
						Thread.sleep(producerThrottlingInMillis);
				}
			}

		}
		catch (InterruptedException e) 
		{
			logger.warn("Thread has been interrupted. Maybe the master asked it to stop: " + e.getMessage());
		} 
		catch(Exception e)
		{
			logger.error("Ingestion worker #"+threadNum+" crashed with the following error:" + e.getMessage());
			logger.error("Schema Value is " + schema);
		}

		accumulatedMetrics.decrementNumberOfActiveIngestionThreads();

    	logger.info("Ingestion worker #"+threadNum+" finished.");
    	return CompletableFuture.completedFuture(recordNum);
	 }



	 @Override
	 public void resetDemo() throws Exception
	 {
		 //TODO
		 
		 //MAKE REST CALL TO IRIS, WHICH THEN EMPTIES & TRUNCATES TABLE TABLE
	
	}

	
}
