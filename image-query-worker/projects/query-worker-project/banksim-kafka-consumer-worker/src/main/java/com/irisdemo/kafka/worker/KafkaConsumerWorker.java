package com.irisdemo.kafka.worker;

import java.io.IOException;

import java.time.Duration;
import java.util.Arrays;
import java.util.Properties;
import java.util.Random;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ThreadLocalRandom;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;
import com.irisdemo.kafka.config.Config;

import com.irisdemo.kafka.config.Config;
import com.irisdemo.kafka.workersrv.IWorker;
import com.irisdemo.kafka.workersrv.AccumulatedMetrics;
import com.irisdemo.kafka.workersrv.WorkerSemaphore;

import io.confluent.kafka.serializers.AbstractKafkaSchemaSerDeConfig;

import org.apache.kafka.common.errors.SerializationException;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.clients.consumer.ConsumerRecords;

import org.apache.kafka.common.serialization.LongDeserializer;
import io.confluent.kafka.serializers.KafkaAvroDeserializer;

import com.irisdemo.banksim.avroevent.*;
import com.irisdemo.banksim.Simulator;

import org.apache.avro.generic.GenericData.Record;
import org.apache.avro.specific.*;

@Component("worker")
@Scope(value = ConfigurableBeanFactory.SCOPE_SINGLETON)
public class KafkaConsumerWorker implements IWorker {
	Logger logger = LoggerFactory.getLogger(KafkaConsumerWorker.class);

	@Autowired
	WorkerSemaphore workerSemaphore;

	@Autowired
	AccumulatedMetrics accumulatedMetrics;

	@Autowired
	Config config;

	protected KafkaConsumer consumer = null;

	protected final String transferTopic = "transfers";
	protected final String demographicsTopic = "customer_demographics";
	protected final String loanContractsTopic = "loan_contracts";

	public void closeKafkaConsumer() throws Exception {
		consumer.close();
		consumer = null;
	}

	public void initiateKafkaConsumer() throws Exception {

		logger.info("Initiating KAFKA Consumer");

		final Properties props = new Properties();
		props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, config.getKafkaBootstrapServersConfig());
		props.put(ConsumerConfig.GROUP_ID_CONFIG, "test");
		props.put(ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG, "false");
		//props.put(ConsumerConfig.AUTO_COMMIT_INTERVAL_MS_CONFIG, "50");
		props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, LongDeserializer.class);
		props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, KafkaAvroDeserializer.class);
		props.put(AbstractKafkaSchemaSerDeConfig.SCHEMA_REGISTRY_URL_CONFIG, config.getSchemaRegistryURLConfig());
		this.consumer = new KafkaConsumer(props);

		this.consumer.subscribe(Arrays.asList(transferTopic, demographicsTopic, loanContractsTopic));
	}

	public KafkaConsumer<Long, Record> generateKafkaConsumer(int threadNum) throws Exception {

		logger.info("Generating KAFKA Consumer");

		final Properties props = new Properties();
		props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, config.getKafkaBootstrapServersConfig());
		props.put(ConsumerConfig.GROUP_ID_CONFIG, "test");
		props.put(ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG, "false");
		props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, LongDeserializer.class);
		props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, KafkaAvroDeserializer.class);
		props.put(AbstractKafkaSchemaSerDeConfig.SCHEMA_REGISTRY_URL_CONFIG, config.getSchemaRegistryURLConfig());

		return new KafkaConsumer<Long, Record>(props);
	}

	@Async("workerExecutor")
	public CompletableFuture<Long> startOneConsumer(int threadNum)
			throws IOException, SerializationException, ClassNotFoundException {

		accumulatedMetrics.incrementNumberOfActiveQueryThreads();
		logger.info("Starting Consumer thread " + threadNum + "...");

		long recordNum = 0;
		double t0, t1, t2, t3, rowCount;
		int rowSizeInBytes;

		try {

			/*
			* Consumer is not a thread safe entity so it can not be shared between threads.
			* A new consumer needs to be created for each thread.
			*/
			//KafkaConsumer<Long, Record> consumer = generateKafkaConsumer(threadNum);
			//consumer.subscribe(Arrays.asList(transferTopic, demographicsTopic, loanContractsTopic));

			while (workerSemaphore.green()) {

				t0 = System.currentTimeMillis();

				t1 = System.currentTimeMillis();

				rowSizeInBytes = 0;
				rowCount = 0;

				t2 = System.currentTimeMillis();

				ConsumerRecords<Long, Record> records = consumer.poll(Duration.ofMillis(100));

				for (ConsumerRecord<Long, Record> record : records){
					rowCount++;
					rowSizeInBytes += record.toString().getBytes().length;
					logger.info("Key: " + record.key() + " - Value: " + record.value().toString());
					//System.out.printf("offset = %d, key = %l, value = %s%n",record.offset(), record.key(), record.value());
				}

				t3= System.currentTimeMillis();

				//rowCount is the number of things processed and rowSizeInBytes is the size of the data being processed
				accumulatedMetrics.addToStats(t3-t0, rowCount, rowSizeInBytes);

				//Have the Kafka Consumer Mark the last polled messages as consumed
				consumer.commitSync();

				if (config.getConsumptionTimeBetweenQueriesInMillis()>0)
				{
					Thread.sleep(config.getConsumptionTimeBetweenQueriesInMillis());
				}
			}
		} 
		catch (InterruptedException e) 
		{
			logger.warn("Thread has been interrupted. Maybe the master asked it to stop: " + e.getMessage());
		} 
		catch (SerializationException e) 
		{
			logger.warn("Ingestion worker #"+threadNum+" Threw a Serialization Exception: " + e.getMessage());
		} 
		catch(Exception e)
		{
			logger.error("Ingestion worker #"+threadNum+" crashed with the following error:" + e.getMessage());
		}
		finally{
			//consumer.close();
		}
		
		accumulatedMetrics.decrementNumberOfActiveQueryThreads();
		logger.info("Query worker #"+threadNum+" finished.");

		return CompletableFuture.completedFuture(recordNum);
	}
}
