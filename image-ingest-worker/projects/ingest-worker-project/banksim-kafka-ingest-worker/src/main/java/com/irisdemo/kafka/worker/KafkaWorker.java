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
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.common.serialization.StringSerializer;

import org.apache.kafka.common.serialization.LongSerializer;
import org.apache.kafka.common.serialization.StringSerializer;
import io.confluent.kafka.serializers.KafkaAvroSerializer;

import com.irisdemo.banksim.avroevent.*;
import com.irisdemo.banksim.Simulator;
import com.irisdemo.banksim.event.Event;
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
	
	protected KafkaProducer<Long, com.irisdemo.banksim.avroevent.TransferEvent> transfersProducer = null;
	protected KafkaProducer<Long, com.irisdemo.banksim.avroevent.DemographicsEvent> demographicsProducer = null;
	protected KafkaProducer<Long, com.irisdemo.banksim.avroevent.LoanContractEvent> loanContractsProducer = null;

	protected final String transferTopic = "transfers";
	protected final String demographicsTopic = "customer_demographics";
	protected final String loanContractsTopic = "loan_contracts";

	protected static char[] prefixes = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};

	public void closeKafkaProducer() throws Exception
	{
		transfersProducer.close();
		demographicsProducer.close();
		loanContractsProducer.close();
		transfersProducer=null;
		demographicsProducer=null;
		loanContractsProducer=null;

	}

	public void initiateKafkaProducer() throws Exception
	{
		final Properties transfersProducerProps = new Properties();
        transfersProducerProps.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, config.getKafkaBootstrapServersConfig());
        transfersProducerProps.put(ProducerConfig.ACKS_CONFIG, "all");
        transfersProducerProps.put(ProducerConfig.RETRIES_CONFIG, 0);
        transfersProducerProps.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, LongSerializer.class);
		transfersProducerProps.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, KafkaAvroSerializer.class);
		transfersProducerProps.put(AbstractKafkaSchemaSerDeConfig.SCHEMA_REGISTRY_URL_CONFIG, config.getSchemaRegistryURLConfig());
		this.transfersProducer = new KafkaProducer<Long, com.irisdemo.banksim.avroevent.TransferEvent>(transfersProducerProps);

		final Properties customerDemographicsProducerProps = new Properties();
        customerDemographicsProducerProps.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, config.getKafkaBootstrapServersConfig());
        customerDemographicsProducerProps.put(ProducerConfig.ACKS_CONFIG, "all");
        customerDemographicsProducerProps.put(ProducerConfig.RETRIES_CONFIG, 0);
        customerDemographicsProducerProps.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, LongSerializer.class);
		customerDemographicsProducerProps.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, KafkaAvroSerializer.class);
		customerDemographicsProducerProps.put(AbstractKafkaSchemaSerDeConfig.SCHEMA_REGISTRY_URL_CONFIG, config.getSchemaRegistryURLConfig());
		this.demographicsProducer = new KafkaProducer<Long, com.irisdemo.banksim.avroevent.DemographicsEvent>(customerDemographicsProducerProps);

		final Properties loanContractsProducerProps = new Properties();
        loanContractsProducerProps.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, config.getKafkaBootstrapServersConfig());
        loanContractsProducerProps.put(ProducerConfig.ACKS_CONFIG, "all");
        loanContractsProducerProps.put(ProducerConfig.RETRIES_CONFIG, 0);
        loanContractsProducerProps.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, LongSerializer.class);
		loanContractsProducerProps.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, KafkaAvroSerializer.class);
		loanContractsProducerProps.put(AbstractKafkaSchemaSerDeConfig.SCHEMA_REGISTRY_URL_CONFIG, config.getSchemaRegistryURLConfig());
		this.loanContractsProducer = new KafkaProducer<Long, com.irisdemo.banksim.avroevent.LoanContractEvent>(loanContractsProducerProps);
		
	}

	@Async("workerExecutor")
    public CompletableFuture<Long> startOneFeed(String nodePrefix, int threadNum) throws IOException
    {	
		long recordNum = 0;
		long batchSizeInBytes;

		Event event = null;
		SpecificRecordBase avroEvent;
		
		//ProducerRecord<Long,SpecificRecordBase> record = null;
		
		ProducerRecord<Long, com.irisdemo.banksim.avroevent.TransferEvent> transfersRecord = null;
		ProducerRecord<Long, com.irisdemo.banksim.avroevent.DemographicsEvent> demographicsRecord = null;
		ProducerRecord<Long, com.irisdemo.banksim.avroevent.LoanContractEvent> loanContractsRecord = null;
		

		long producerThrottlingInMillis = config.getProducerThrottlingInMillis();

		accumulatedMetrics.incrementNumberOfActiveIngestionThreads();

		logger.info("Ingestion worker #"+threadNum+" started. Sending messages to topics... ");

		// amountDays, amountEvents, amountCustomers
		Simulator simulator = new Simulator(30, 5000000, 50000);
		
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
					event = simulator.next();
					avroEvent = event.getAvroEvent();

					if (event == null) 
					{
						break;
					}
					else if (avroEvent instanceof com.irisdemo.banksim.avroevent.TransferEvent)
					{
						transfersRecord = new ProducerRecord<Long, com.irisdemo.banksim.avroevent.TransferEvent>(transferTopic, Long.valueOf(event.getId()), (com.irisdemo.banksim.avroevent.TransferEvent)avroEvent);
						transfersProducer.send(transfersRecord);
					}
					else if (avroEvent instanceof com.irisdemo.banksim.avroevent.DemographicsEvent)
					{
						demographicsRecord = new ProducerRecord<Long, com.irisdemo.banksim.avroevent.DemographicsEvent>(demographicsTopic, Long.valueOf(event.getId()), (com.irisdemo.banksim.avroevent.DemographicsEvent)avroEvent);
						demographicsProducer.send(demographicsRecord);
					}
					else if (avroEvent instanceof com.irisdemo.banksim.avroevent.LoanContractEvent)
					{
						loanContractsRecord = new ProducerRecord<Long, com.irisdemo.banksim.avroevent.LoanContractEvent>(loanContractsTopic, Long.valueOf(event.getId()), (com.irisdemo.banksim.avroevent.LoanContractEvent)avroEvent);
						loanContractsProducer.send(loanContractsRecord);
					}
					
					currentBatchSize++;
				}
				
				if(workerSemaphore.green())
				{
					// Not really caring too much about the fact that there may be producers with fewer records than others. Just flushing everyting.
					transfersProducer.flush();
					demographicsProducer.flush();
					loanContractsProducer.flush();

					accumulatedMetrics.addToStats(currentBatchSize, batchSizeInBytes);

					if (producerThrottlingInMillis>0)
						Thread.sleep(producerThrottlingInMillis);
				}

				if (event == null) break;
			}

		}
		catch (InterruptedException e) 
		{
			logger.warn("Thread has been interrupted. Maybe the master asked it to stop: " + e.getMessage());
		} 
		catch(Exception e)
		{
			logger.error("Ingestion worker #"+threadNum+" crashed with the following error:" + e.getMessage());
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
