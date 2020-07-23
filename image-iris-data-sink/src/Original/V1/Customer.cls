Class Original.V1.Customer Extends (%Persistent, DataSink.OriginalData)
{

Parameter %DTL = "Original.V1.DTL.Customer";

Property "account_id" As %String [ Required ];

Property name As %String [ Required ];

Property dob As %Date [ Required ];

Property address As Address;

Storage Default
{
<Data name="CustomerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>%ProcessingStatus</Value>
</Value>
<Value name="3">
<Value>%ErrorMessage</Value>
</Value>
<Value name="4">
<Value>%DateReceived</Value>
</Value>
<Value name="5">
<Value>address</Value>
</Value>
<Value name="6">
<Value>account_id</Value>
</Value>
<Value name="7">
<Value>dob</Value>
</Value>
<Value name="8">
<Value>name</Value>
</Value>
<Value name="9">
<Value>%SessionId</Value>
</Value>
<Value name="10">
<Value>%DataSourceName</Value>
</Value>
</Data>
<DataLocation>^Original.V1.CustomerD</DataLocation>
<DefaultData>CustomerDefaultData</DefaultData>
<IdLocation>^Original.V1.CustomerD</IdLocation>
<IndexLocation>^Original.V1.CustomerI</IndexLocation>
<StreamLocation>^Original.V1.CustomerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
