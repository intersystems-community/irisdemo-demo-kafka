Class Original.V2.CustomerBatch Extends (%Persistent, DataSink.OriginalDataBatch)
{

Property customers As list Of Customer;

Storage Default
{
<Data name="CustomerBatchDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>customers</Value>
</Value>
<Value name="3">
<Value>%DateReceived</Value>
</Value>
</Data>
<DataLocation>^Original.V2.CustomerBatchD</DataLocation>
<DefaultData>CustomerBatchDefaultData</DefaultData>
<IdLocation>^Original.V2.CustomerBatchD</IdLocation>
<IndexLocation>^Original.V2.CustomerBatchI</IndexLocation>
<StreamLocation>^Original.V2.CustomerBatchS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
