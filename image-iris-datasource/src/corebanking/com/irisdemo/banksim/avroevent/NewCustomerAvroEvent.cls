Class corebanking.com.irisdemo.banksim.avroevent.NewCustomerAvroEvent Extends (corebanking.AllObjects, SchemaNormalization.OriginalData) [ Inheritance = left, ProcedureBlock ]
{

Parameter SCHEMAID = 1;

Parameter SCHEMAIMPORTDATE = "2020-08-10 23:49:14";

Parameter SCHEMASIGNATURE = "FB7L2886SO3H94L0N1PFC144TSD5NT1B";

Parameter SCHEMASUBJECT = "com.irisdemo.banksim.avroevent.NewCustomerAvroEvent";

Parameter SCHEMAVERSION = 1;

Property accountNumber As %String [ Required ];

Property address As corebanking.com.irisdemo.banksim.avroevent.mailingaddress [ Required ];

Property customerId As %BigInt [ Required ];

Property eventDate As %TimeStamp [ Required ];

Property eventId As %BigInt [ Required ];

Property initialAmount As %Double [ Required ];

Property name As %String [ Required ];

Storage Default
{
<Data name="NewCustomerAvroEventDefaultData">
<Subscript>"NewCustomerAvroEvent"</Subscript>
<Value name="1">
<Value>accountNumber</Value>
</Value>
<Value name="2">
<Value>address</Value>
</Value>
<Value name="3">
<Value>customerId</Value>
</Value>
<Value name="4">
<Value>eventDate</Value>
</Value>
<Value name="5">
<Value>eventId</Value>
</Value>
<Value name="6">
<Value>initialAmount</Value>
</Value>
<Value name="7">
<Value>name</Value>
</Value>
</Data>
<DefaultData>NewCustomerAvroEventDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
