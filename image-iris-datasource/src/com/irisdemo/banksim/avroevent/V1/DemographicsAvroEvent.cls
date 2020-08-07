Class com.irisdemo.banksim.avroevent.V1.DemographicsAvroEvent Extends (%Persistent, SchemaRegistry.SchemaGenerated) [ Inheritance = right, Not ProcedureBlock ]
{

Parameter SCHEMACONFIG = "ConfluentKafka";

Parameter SCHEMAID = 3;

Parameter SCHEMAIMPORTDATE = "2020-08-07 01:07:26";

Parameter SCHEMASIGNATURE = "EMNAE2FPS107NT7QVGV50ELA7F2HU88E";

Parameter SCHEMASUBJECT = "customer_demographics-value";

Parameter SCHEMAVERSION = 1;

Property account As %String [ Required ];

Property city As %String [ Required ];

Property eventDate As %TimeStamp [ Required ];

Property id As %BigInt [ Required ];

Property name As %String [ Required ];

Property phone As %String [ Required ];

Property state As %String [ Required ];

Storage Default
{
<Data name="DemographicsAvroEventDefaultData">
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
<Value>account</Value>
</Value>
<Value name="7">
<Value>city</Value>
</Value>
<Value name="8">
<Value>eventDate</Value>
</Value>
<Value name="9">
<Value>id</Value>
</Value>
<Value name="10">
<Value>name</Value>
</Value>
<Value name="11">
<Value>phone</Value>
</Value>
<Value name="12">
<Value>state</Value>
</Value>
</Data>
<DataLocation>^com.irisdeEE08.DemographicEC37D</DataLocation>
<DefaultData>DemographicsAvroEventDefaultData</DefaultData>
<IdLocation>^com.irisdeEE08.DemographicEC37D</IdLocation>
<IndexLocation>^com.irisdeEE08.DemographicEC37I</IndexLocation>
<StreamLocation>^com.irisdeEE08.DemographicEC37S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
