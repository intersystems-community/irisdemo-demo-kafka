package irisdemo.kafka;

import org.apache.avro.generic.GenericRecord;
import org.apache.kafka.clients.consumer.*;
import org.apache.kafka.clients.consumer.Consumer;
import org.apache.kafka.common.serialization.*;
import java.util.Collections;
import java.util.Properties;
import java.time.Duration;
import java.time.LocalDateTime;

public class KeyLessAvroInboundAdapter extends com.intersystems.enslib.pex.InboundAdapter implements Runnable
{
	Thread consumerThread = null;
	boolean keepRunning = true;

	private Consumer<Object,GenericRecord> consumer;

	public static String TOPIC;
	public static String BOOTSTRAP_SERVERS;
	public static String GROUP_ID;
	public static String SCHEMA_REGISTRY;
	public static String KEY_DESERIALIZER_CLASS_CONFIG;
	public static boolean CALL_PROCESS_INPUT_UPON_NEW_DATA = false;
	public static String AUTO_OFFSET_RESET_CONFIG;
	public static String STORAGE_CLASS_NAME;
	public static int CALL_INTERVAL = 5;

	// Used inside run() method
	private static boolean succesfulDeserializationOfBatch = true;
	private static Exception thrownExceptionDuringDeserialization;
	private boolean newDataHasArrived = true;

	private Consumer<Object, GenericRecord> createConsumer() throws Exception
	{
		final Properties props = new Properties();

		props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, BOOTSTRAP_SERVERS);
		props.put(ConsumerConfig.GROUP_ID_CONFIG, GROUP_ID);

		try
		{
			props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, Class.forName(KEY_DESERIALIZER_CLASS_CONFIG).getName());
		}
		catch (ClassNotFoundException e)
		{
			this.LOGERROR("Invalid KEY deserializer class: " +  KEY_DESERIALIZER_CLASS_CONFIG);
			throw e;
		}

		props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, "io.confluent.kafka.serializers.KafkaAvroDeserializer");
		props.put("schema.registry.url", SCHEMA_REGISTRY);
		props.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, AUTO_OFFSET_RESET_CONFIG);

		// Create the consumer using props.
		final Consumer<Object, GenericRecord> consumer = new KafkaConsumer<>(props);
      
		// Subscribe to the topic.
		consumer.subscribe(Collections.singletonList(TOPIC));      
		
		return consumer;
	}
	

	@Override
	public void OnInit() throws Exception 
	{
		this.consumer = createConsumer();
		startConsumerThread();
	}
	
	public void startConsumerThread()
	{
		consumerThread = new Thread(this, "Kafka Consumer Thread");
		consumerThread.start();
	}

	@Override
	public void run() 
	{
		LOGINFO("Starting consumer thread.");
		LOGINFO("KEY_DESERIALIZER_CLASS_CONFIG: " + KEY_DESERIALIZER_CLASS_CONFIG);	

		ConsumerRecords<Object, GenericRecord> consumerRecords;

		while (keepRunning) 
		{
			try
			{
				consumerRecords = consumer.poll(Duration.ofMillis(1000));
				//LOGINFO("Returned " + consumerRecords.count() + " records.");

				succesfulDeserializationOfBatch = true;

				//BusinessHost.irisHandle.iris.tStart();

				consumerRecords.forEach(record -> 
				{
					newDataHasArrived = true;
					BusinessHost.irisHandle.iris.classMethodObject(STORAGE_CLASS_NAME, "ParseJSONAndSave", record.value().toString());
					//LOGINFO("Pushed one object " + LocalDateTime.now());
				});
			}
			catch (Exception e)
			{
				keepRunning = false;
				succesfulDeserializationOfBatch = false;
				thrownExceptionDuringDeserialization = e;
			}

			if (succesfulDeserializationOfBatch)
			{
				//BusinessHost.irisHandle.iris.tCommit();
				consumer.commitSync();
			}
			else
			{
				//BusinessHost.irisHandle.iris.tRollback();
				//LOGINFO("Rolling back inserted records in IRIS.");
				break;
			}
		}

		if (thrownExceptionDuringDeserialization!=null)
			LOGERROR(thrownExceptionDuringDeserialization.getMessage()+"\n"+thrownExceptionDuringDeserialization.getStackTrace().toString());					

		LOGINFO("Consumer thread finished.");
	}

	public void stopConsumerThread()
	{
		LOGINFO("Stopping consumer thread.");
		keepRunning = false;
		try
		{
			consumerThread.join();
		}
		catch (InterruptedException e)
		{}

		consumer.close();
	}

	@Override
	public void OnTask() throws Exception 
	{
		if (CALL_PROCESS_INPUT_UPON_NEW_DATA && this.newDataHasArrived)
		{
			BusinessHost.ProcessInput("");
			newDataHasArrived = false;
		}

		// We must sleep here. If we let the sleep happen on the IRIS side
		// our child thread will not be able to save objects on IRIS fast enough 
		// because the java side will be trying to READ over the connection to know when 
		// to wake up and while this is happening, the child thread can not WRITE over
		// the connection to save objects.
		Thread.sleep(CALL_INTERVAL*1000);

	}

	@Override
	public void OnTearDown() throws Exception 
	{
		stopConsumerThread();
	}

}
