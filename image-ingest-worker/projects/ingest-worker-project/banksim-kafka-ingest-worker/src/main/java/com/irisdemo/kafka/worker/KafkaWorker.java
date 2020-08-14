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

import com.irisdemo.kafka.config.Config;
import com.irisdemo.kafka.workersrv.IWorker;
import com.irisdemo.kafka.workersrv.WorkerMetricsAccumulator;
import com.irisdemo.kafka.workersrv.WorkerSemaphore;

import io.confluent.kafka.serializers.AbstractKafkaSchemaSerDeConfig;

import org.apache.kafka.common.errors.SerializationException;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.Producer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.common.serialization.StringSerializer;

import org.apache.kafka.common.serialization.LongSerializer;
import org.apache.kafka.common.serialization.StringSerializer;
import io.confluent.kafka.serializers.KafkaAvroSerializer;

import com.irisdemo.banksim.avroevent.*;
import com.irisdemo.banksim.Simulator;
import org.apache.avro.specific.*;


import java.util.Properties;
import java.util.Collections;

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
    	
	//protected KafkaProducer<LongSerializer, KafkaAvroSerializer> producer = null;
	
	protected KafkaProducer producer = null;

	/*
	protected final String transferTopic = "transfers";
	protected final String demographicsTopic = "customer_demographics";
	protected final String loanContractsTopic = "loan_contracts";
	protected final String newCustomerTopic = "new_customer";
	*/

	// To guarantee message sequencing
	protected final String transferTopic = "core-banking-system-events";
	protected final String demographicsTopic = "core-banking-system-events";
	protected final String loanContractsTopic = "core-banking-system-events";
	protected final String newCustomerTopic = "core-banking-system-events";

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
        props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, LongSerializer.class);
		props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, KafkaAvroSerializer.class);
		props.put(AbstractKafkaSchemaSerDeConfig.KEY_SUBJECT_NAME_STRATEGY, "io.confluent.kafka.serializers.subject.RecordNameStrategy");
		props.put(AbstractKafkaSchemaSerDeConfig.VALUE_SUBJECT_NAME_STRATEGY, "io.confluent.kafka.serializers.subject.RecordNameStrategy");
		props.put(AbstractKafkaSchemaSerDeConfig.SCHEMA_REGISTRY_URL_CONFIG, config.getSchemaRegistryURLConfig());
		this.producer = new KafkaProducer(props);
	}

	@Async("workerExecutor")
    public CompletableFuture<Long> startOneFeed(String nodePrefix, int threadNum) throws IOException
    {	
		long recordNum = 0;
		long batchSizeInBytes;

		SpecificRecordBase avroEvent = null;
				
		ProducerRecord<Long, TransferAvroEvent> transfersRecord = null;
		ProducerRecord<Long, DemographicsAvroEvent> demographicsRecord = null;
		ProducerRecord<Long, LoanContractAvroEvent> loanContractsRecord = null;
		ProducerRecord<Long, NewCustomerAvroEvent> newCustomerRecord = null;
		
		long producerThrottlingInMillis = config.getProducerThrottlingInMillis();

		accumulatedMetrics.incrementNumberOfActiveIngestionThreads();

		logger.info("Ingestion worker #"+threadNum+" started. Sending messages to topics... ");

		// amountDays, amountEvents, amountCustomers
		logger.info("Creating simulator with amountDays="+config.getBankSimDays()+", maxNumberOfEvents="+config.getBankSimNumEvents()+", amountCustomers="+config.getBankSimNumCustomers()+".");
		Simulator simulator = new Simulator(config.getBankSimDays(), config.getBankSimNumEvents(), config.getBankSimNumCustomers());
		//Simulator simulator = new Simulator(30, 5000000, 50000);
		
		try
		{
			int currentRecord = 0;
			int currentBatchSize;
			
	    	while(workerSemaphore.green())
	    	{
	    		currentBatchSize = 0;
	    		batchSizeInBytes = 0;
	    		
	    		while(workerSemaphore.green())
	    		{
	    			if (currentBatchSize==config.getProducerFlushSize()) 
	    				break;

					//randomDataGenerator.populateJSONRequest(requestJSON, threadPrefix, schema, ++currentRecord);
					avroEvent = simulator.nextAvroEvent();

					if (avroEvent == null) 
					{
						logger.warn("Simulation stopped. No more events returned.");
						break;
					}
					else if (avroEvent instanceof TransferAvroEvent)
					{
						transfersRecord = new ProducerRecord<Long, TransferAvroEvent>(transferTopic, (Long)avroEvent.get("customerId"), (TransferAvroEvent)avroEvent);
						producer.send(transfersRecord);
					}
					else if (avroEvent instanceof DemographicsAvroEvent)
					{
						demographicsRecord = new ProducerRecord<Long, DemographicsAvroEvent>(demographicsTopic, (Long)avroEvent.get("customerId"), (DemographicsAvroEvent)avroEvent);
						producer.send(demographicsRecord);
					}
					else if (avroEvent instanceof LoanContractAvroEvent)
					{
						loanContractsRecord = new ProducerRecord<Long, LoanContractAvroEvent>(loanContractsTopic, (Long)avroEvent.get("customerId"), (LoanContractAvroEvent)avroEvent);
						producer.send(loanContractsRecord);
					}
					else if (avroEvent instanceof NewCustomerAvroEvent)
					{
						newCustomerRecord = new ProducerRecord<Long, NewCustomerAvroEvent>(newCustomerTopic, (Long)avroEvent.get("customerId"), (NewCustomerAvroEvent)avroEvent);
						producer.send(newCustomerRecord);
					}
					
					currentBatchSize++;
				}
				
				if(workerSemaphore.green())
				{
					producer.flush();
					accumulatedMetrics.addToStats(currentBatchSize, batchSizeInBytes);

					if (producerThrottlingInMillis>0)
						Thread.sleep(producerThrottlingInMillis);
				}

				if (avroEvent == null) break;
			}

		}
		catch (InterruptedException e) 
		{
			logger.warn("Thread has been interrupted. Maybe the master asked it to stop: " + e.getMessage());
		} 
		catch(Exception e)
		{
			logger.error("Ingestion worker #"+threadNum+" crashed.", e);
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
