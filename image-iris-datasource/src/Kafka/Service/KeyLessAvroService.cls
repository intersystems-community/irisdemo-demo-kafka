/// This Kafka adapter will save the kafka messages on a global
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
Class Kafka.Service.KeyLessAvroService Extends Ens.BusinessService
{

Parameter ADAPTER = "Kafka.Adapter.KeyLessAvroInboundAdapter";

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject, pHint As %String) As %Status
{
    Set tClassName = $ListGet(pInput, 1)
    Set tJSON = $ListGet(pInput, 2)
    Quit $classmethod(tClassName, "ParseJSONAndSave", tJSON)
}

}
