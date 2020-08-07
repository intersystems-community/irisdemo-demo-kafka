/// This Kafka adapter works with Avro payloads and ignores the key. It uses the schema
/// of the Avro payload to automatically create the IRIS classes to hold the data.
/// When pulling data from Kafka, the adapter will be saving the data directly on the class's
/// global storage.
/// 
/// The storage class will have its package name matching the avro's namespace and its
/// class name matching the avro's root schema name. The class will be %Persistent.
/// Any referenced sub-schema will be creaded under the same package and will be a %SerialObject.
/// 
/// TODO: We still need to implement a way to indicate if we want to listen only for new
/// messages, start from the beginning of the stream or from the last key we stopped.
/// I think the broker keeps track of the last offset for us so we don't have to. We
/// just need to let it know of our preference when we start consuming.
Class Kafka.Adapter.KeyLessAvroInboundAdapter Extends Common
{

Property %remoteClassname As %String [ InitialExpression = "irisdemo.kafka.KeyLessAvroInboundAdapter" ];

Property KeyDeserializerClassName As Kafka.Datatype.Deserializer [ InitialExpression = "org.apache.kafka.common.serialization.ByteArrayDeserializer", Required ];

Property SchemaRegistryURL As %String(MAXLEN = "") [ InitialExpression = "http://localhost:8081" ];

Property StorageClassName As %String(MAXLEN = "");

/// Data will always be saved directly on the global storage of the class for the avro schema
/// You can optionally configure the adapter to call your Business Process ProcessInput() method
/// to let you know that new data has arrived. That call will be done on every CallInterval IF new data
/// has arrived.
Property CallProcessInputUponNewData As %Boolean [ InitialExpression = 0 ];

Parameter SETTINGS = "StorageClassName:Basic:selector?context={SchemaRegistry.Monitor.ContextSearch/Schemas},SchemaRegistryURL:Basic,CallProcessInputUponNewData,KeyDeserializerClassName";

Method OnInit() As %Status
{
    Do ..AddRemoteSetting("SCHEMA_REGISTRY", ..SchemaRegistryURL)
    Do ..AddRemoteSetting("CALL_PROCESS_INPUT_UPON_NEW_DATA", ..CallProcessInputUponNewData)
    Do ..AddRemoteSetting("KEY_DESERIALIZER_CLASS_CONFIG", ..KeyDeserializerClassName)
    Do ..AddRemoteSetting("STORAGE_CLASS_NAME", ..StorageClassName)

	Quit ##super()
}

}
