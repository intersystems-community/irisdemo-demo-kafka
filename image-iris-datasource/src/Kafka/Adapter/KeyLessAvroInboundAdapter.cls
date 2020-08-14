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

Property SchemaRegistryConfig As %String;

Property SchemaRegistryConfigObj As SchemaRegistry.Config;

Parameter SETTINGS = "SchemaRegistryConfig:Basic:selector?context={SchemaRegistry.Monitor.ContextSearch/Configs},KeyDeserializerClassName";

Method OnInit() As %Status
{
    Do ..AddRemoteSetting("SCHEMA_REGISTRY", ..SchemaRegistryConfigObj.EndPoint)
    Do ..AddRemoteSetting("CALL_PROCESS_INPUT_UPON_NEW_DATA", ..CallProcessInputUponNewData)
    Do ..AddRemoteSetting("KEY_DESERIALIZER_CLASS_CONFIG", ..KeyDeserializerClassName)
    Do ..AddRemoteSetting("STORAGE_BASE_PACKAGE_NAME", $Translate(..SchemaRegistryConfigObj.Name,"."))

	Quit ##super()
}

Method SchemaRegistryConfigSet(pSchemaRegistryConfigName As %String) As %Status
{
    Set tSC = $$$OK
    Set ..SchemaRegistryConfigObj = ##class(SchemaRegistry.Config).NameIndexOpen(pSchemaRegistryConfigName,,.tSC)
    Quit tSC
}

}
