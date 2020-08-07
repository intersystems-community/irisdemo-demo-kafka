Class Kafka.Service.SchemaLessService Extends Ens.BusinessService
{

Parameter ADAPTER = "Kafka.Adapter.SchemaLessInboundAdapter";

/// This method will only be called if the adapter's CallProcessInputUponNewData = 1 and new data has arrived in the global
/// If you need to be notified about new data being arrived, you should just create your own business service
/// with the adapter Kafka.Adapter.SchemaLessInboundAdapter and implement your own OnProcessInput instead of
/// touching this class.
Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject, ByRef pHint As %String) As %Status
{
	Quit $$$OK
}

}
