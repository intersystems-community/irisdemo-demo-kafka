/// This Kafka adapter will just save the kafka messages on a global
/// The global name is defined based on the topic name
/// The subscript of the global can be:
/// 1 - The kafka message key if property UseKeyAsGlobalSubscript = 1
/// 2 - A sequential value if UseKeyAsGlobalSubscript = 0
/// 
/// It is very important to specify the correct deserializer for both the key and the value of the message.
/// 
/// If you are using kafka-console-producer to send test messages, beware that it serializes both
/// the key and the value using ByteArraySerializer. So pick ByteArrayDeserializer for both the
/// key and the value properties. On the other hand, if you are serializing the messages yourself and 
/// you know what serializers you are using, pick the right ones for your code.
/// 
/// TODO: We still need to implement a way to indicate if we want to listen only for new
/// messages, start from the beginning of the stream or from the last key we stopped.
/// I think the broker keeps track of the last offset for us so we don't have to. We
/// just need to let it know of our preference when we start consuming
Class Kafka.Adapter.SchemaLessInboundAdapter Extends Common
{

Property %remoteClassname As %String [ InitialExpression = "irisdemo.kafka.SchemaLessInboundAdapter" ];

Property KeyDeserializerClassName As Kafka.Datatype.Deserializer [ InitialExpression = "org.apache.kafka.common.serialization.LongDeserializer", Required ];

Property ValueDeserializerClassName As Kafka.Datatype.Deserializer [ InitialExpression = "org.apache.kafka.common.serialization.StringDeserializer", Required ];

Property UseKeyAsGlobalSubscript As %Boolean [ InitialExpression = 0, Required ];

/// Only valid if UseKeyAsGlobalSubscript is false and the data is being saved on the global
/// under an incremental counter. In this case, there is the option of saving the key with the data as a $List or
/// just saving the data as a simple value (no $List is needed).
Property StoreKeyWithData As %Boolean [ InitialExpression = 0, Required ];

/// Data will always be saved directly on the global named after the topic. 
/// You can optionally configure the adapter to call your Business Process ProcessInput() method
/// to let you know that new data has arrived. That call will be done on every CallInterval IF new data
/// has arrived.
Property CallProcessInputUponNewData As %Boolean [ InitialExpression = 0 ];

Parameter SETTINGS = "KeyDeserializerClassName:Basic,ValueDeserializerClassName:Basic,UseKeyAsGlobalSubscript,StoreKeyWithData";

Method OnInit() As %Status
{
    Do ..AddRemoteSetting("CALL_PROCESS_INPUT_UPON_NEW_DATA", ..CallProcessInputUponNewData)

    Do ..AddRemoteSetting("KEY_DESERIALIZER_CLASS_CONFIG", ..KeyDeserializerClassName)
    Do ..AddRemoteSetting("VALUE_DESERIALIZER_CLASS_CONFIG", ..ValueDeserializerClassName)
    
    Set tTopicGlobal=$Translate(..Topic, "-_", ".")
    Do ..AddRemoteSetting("TOPIC_GLOBAL", tTopicGlobal)
    
    Do ..AddRemoteSetting("USE_KEY_AS_GLOBAL_SUBSCRIPT", ..UseKeyAsGlobalSubscript)
    
    Do ..AddRemoteSetting("STORE_KEY_WITH_DATA", ..StoreKeyWithData)

	Quit ##super()
}

}
