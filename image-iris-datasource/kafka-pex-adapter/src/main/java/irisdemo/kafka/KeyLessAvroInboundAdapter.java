package irisdemo.kafka;

import org.apache.avro.generic.GenericRecord;
import org.apache.kafka.clients.consumer.*;
import org.apache.kafka.clients.consumer.Consumer;
import org.apache.kafka.common.serialization.*;

import java.util.Collections;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Properties;

import com.intersystems.jdbc.IRISList;

import java.time.Duration;
import java.time.LocalDateTime;

public class KeyLessAvroInboundAdapter extends com.intersystems.enslib.pex.InboundAdapter {
	Thread consumerThread = null;
	boolean keepRunning = true;

	private Consumer<Object, GenericRecord> consumer = null;

	public static String TOPIC;
	public static String BOOTSTRAP_SERVERS;
	public static String GROUP_ID;
	public static String SCHEMA_REGISTRY;
	public static String KEY_DESERIALIZER_CLASS_CONFIG;
	public static boolean CALL_PROCESS_INPUT_UPON_NEW_DATA = false;
	public static String AUTO_OFFSET_RESET_CONFIG;
	public static String STORAGE_BASE_PACKAGE_NAME;

	private static Hashtable<String, String> schemaToClassNameMap = new Hashtable<String, String>();

	private Consumer<Object, GenericRecord> createConsumer() throws Exception {
		final Properties props = new Properties();

		// We want to drive the commits. We will only commit to Kafka if we have saved
		// the records in IRIS, not before.
		props.put("enable.auto.commit", Boolean.toString(false));
		props.put("max.poll.records", 500);
		props.put("max.poll.interval.ms", 300000);

		props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, BOOTSTRAP_SERVERS);
		props.put(ConsumerConfig.GROUP_ID_CONFIG, GROUP_ID);

		try {
			props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG,
					Class.forName(KEY_DESERIALIZER_CLASS_CONFIG).getName());
		} catch (ClassNotFoundException e) {
			this.LOGERROR("Invalid KEY deserializer class: " + KEY_DESERIALIZER_CLASS_CONFIG);
			throw e;
		}

		props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG,
				"io.confluent.kafka.serializers.KafkaAvroDeserializer");
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
		this.LOGINFO("OnInit - Creating Kafka consummer...");
		this.consumer = createConsumer();
		this.LOGINFO("Kafka consumer created.");
	}

	private String getClassNameForSchema(org.apache.avro.Schema schema) {
		String fullName = schema.getFullName();
		String className = null;

		className = schemaToClassNameMap.get(fullName);

		if (className == null) {
			String schemaPackage = STORAGE_BASE_PACKAGE_NAME + "."
					+ schema.getNamespace().replace('_', '.').replace("-", "");
			String schemaName = schema.getName().replace("_", " ").replace("-", "").replace(".", "");

			className = schemaPackage + "." + schemaName;
			schemaToClassNameMap.put(fullName, className);
		}

		return className;
	}

	@Override
	public void OnTask() throws Exception 
	{
		ConsumerRecords<Object, GenericRecord> consumerRecords;
		ConsumerRecord<Object, GenericRecord> record = null;
		GenericRecord data;
		long offset;
		int partition;

		try 
		{	
			IRISList list = new IRISList();
			
			consumerRecords = this.consumer.poll(Duration.ofMillis(1000));
		
			Iterator iterator = consumerRecords.iterator();

			while (iterator.hasNext())
			{
				record = (ConsumerRecord<Object, GenericRecord>) iterator.next();

				data = (GenericRecord) record.value();
				offset = record.offset();
				partition = record.partition();

				String className = getClassNameForSchema(data.getSchema());

				list.add(partition);
				list.add(offset);
				list.add(className);
				list.add(data.toString());
				BusinessHost.ProcessInput(list);
				list.clear();
				
				//LOGINFO("Pushed one object " + LocalDateTime.now());

			}

			// synchronous commit.
			consumer.commitSync();			
		}
		catch (Exception e)
		{
			LOGERROR("OnTask Exception: " + e.getMessage() + "\n" + e.getStackTrace().toString());
			throw e;
		}
	}

	@Override
	public void OnTearDown() throws Exception 
	{
		consumer.close();
	}

}
