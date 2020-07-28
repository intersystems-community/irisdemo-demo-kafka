Class Original.V2.Customer Extends (%Persistent, DataSink.OriginalData)
{

Parameter %DTL = "Original.V2.DTL.Customer";

Property "account_id" As %String [ Required ];

Property fullName As %String [ Required ];

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
<Value>fullName</Value>
</Value>
<Value name="9">
<Value>%SessionId</Value>
</Value>
<Value name="10">
<Value>%DataSourceName</Value>
</Value>
</Data>
<DataLocation>^Original.V2.CustomerD</DataLocation>
<DefaultData>CustomerDefaultData</DefaultData>
<IdLocation>^Original.V2.CustomerD</IdLocation>
<IndexLocation>^Original.V2.CustomerI</IndexLocation>
<StreamLocation>^Original.V2.CustomerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
