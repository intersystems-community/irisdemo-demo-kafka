/// What to do when there is no initial offset in Kafka or if the current offset does not exist any more on the server (e.g. because that data has been deleted):
/// 
/// earliest: automatically reset the offset to the earliest offset
/// latest: automatically reset the offset to the latest offset
/// none: throw exception to the consumer if no previous offset is found for the consumer's group
Class Kafka.Datatype.AutoOffsetResetOptions Extends %String
{

Parameter VALUELIST = ",earliest,latest,none";

}
