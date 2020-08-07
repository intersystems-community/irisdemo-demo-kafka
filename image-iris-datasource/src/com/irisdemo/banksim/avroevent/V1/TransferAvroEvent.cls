Class com.irisdemo.banksim.avroevent.V1.TransferAvroEvent Extends (%Persistent, SchemaRegistry.SchemaGenerated) [ Inheritance = right, Not ProcedureBlock ]
{

Parameter SCHEMACONFIG = "ConfluentKafka";

Parameter SCHEMAID = 2;

Parameter SCHEMAIMPORTDATE = "2020-08-07 01:07:26";

Parameter SCHEMASIGNATURE = "I0O434N3DVGD6NP9FI8VSNGVAFJ143LK";

Parameter SCHEMASUBJECT = "transfers-value";

Parameter SCHEMAVERSION = 1;

Property amount As %Double [ Required ];

Property eventDate As %TimeStamp [ Required ];

Property id As %BigInt [ Required ];

Property receivingAccount As %String [ Required ];

Property senderAccount As %String [ Required ];

Property transferType As %String [ Required ];

Storage Default
{
<Data name="TransferAvroEventDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>%SessionId</Value>
</Value>
<Value name="3">
<Value>%ProcessingStatus</Value>
</Value>
<Value name="4">
<Value>%ErrorMessage</Value>
</Value>
<Value name="5">
<Value>%DateReceived</Value>
</Value>
<Value name="6">
<Value>amount</Value>
</Value>
<Value name="7">
<Value>eventDate</Value>
</Value>
<Value name="8">
<Value>id</Value>
</Value>
<Value name="9">
<Value>receivingAccount</Value>
</Value>
<Value name="10">
<Value>senderAccount</Value>
</Value>
<Value name="11">
<Value>transferType</Value>
</Value>
</Data>
<DataLocation>^com.irisdeEE08.TransferAvr5E61D</DataLocation>
<DefaultData>TransferAvroEventDefaultData</DefaultData>
<IdLocation>^com.irisdeEE08.TransferAvr5E61D</IdLocation>
<IndexLocation>^com.irisdeEE08.TransferAvr5E61I</IndexLocation>
<StreamLocation>^com.irisdeEE08.TransferAvr5E61S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
