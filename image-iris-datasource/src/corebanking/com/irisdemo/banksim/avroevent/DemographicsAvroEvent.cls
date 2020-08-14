Class corebanking.com.irisdemo.banksim.avroevent.DemographicsAvroEvent Extends (corebanking.AllObjects, SchemaNormalization.OriginalData) [ Inheritance = left, ProcedureBlock ]
{

Parameter SCHEMAID = 2;

Parameter SCHEMAIMPORTDATE = "2020-08-10 23:49:13";

Parameter SCHEMASIGNATURE = "7GND8C06CC5KJU73T2IHG96DGVILV4RK";

Parameter SCHEMASUBJECT = "com.irisdemo.banksim.avroevent.DemographicsAvroEvent";

Parameter SCHEMAVERSION = 1;

Property address As corebanking.com.irisdemo.banksim.avroevent.mailingaddress [ Required ];

Property customerId As %BigInt [ Required ];

Property eventDate As %TimeStamp [ Required ];

Property eventId As %BigInt [ Required ];

Property name As %String [ Required ];

Storage Default
{
<Data name="DemographicsAvroEventDefaultData">
<Subscript>"DemographicsAvroEvent"</Subscript>
<Value name="1">
<Value>address</Value>
</Value>
<Value name="2">
<Value>customerId</Value>
</Value>
<Value name="3">
<Value>eventDate</Value>
</Value>
<Value name="4">
<Value>eventId</Value>
</Value>
<Value name="5">
<Value>name</Value>
</Value>
</Data>
<DefaultData>DemographicsAvroEventDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
