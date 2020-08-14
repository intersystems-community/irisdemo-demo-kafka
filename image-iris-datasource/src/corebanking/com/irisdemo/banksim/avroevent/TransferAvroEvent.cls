Class corebanking.com.irisdemo.banksim.avroevent.TransferAvroEvent Extends (corebanking.AllObjects, SchemaNormalization.OriginalData) [ Inheritance = left, ProcedureBlock ]
{

Parameter SCHEMAID = 3;

Parameter SCHEMAIMPORTDATE = "2020-08-13 15:54:18";

Parameter SCHEMASIGNATURE = "P7LH1QLEFT2TQFOJ8NOBJ0HCT1G1SDIA";

Parameter SCHEMASUBJECT = "com.irisdemo.banksim.avroevent.TransferAvroEvent";

Parameter SCHEMAVERSION = 1;

Property amount As %Double [ Required ];

Property customerAccount As %String [ Required ];

Property customerId As %BigInt [ Required ];

Property eventDate As %TimeStamp [ Required ];

Property eventId As %BigInt [ Required ];

Property otherAccount As %String [ Required ];

Property reference As %String [ Required ];

Property transferType As %String [ Required ];

Storage Default
{
<Data name="TransferAvroEventDefaultData">
<Subscript>"TransferAvroEvent"</Subscript>
<Value name="1">
<Value>amount</Value>
</Value>
<Value name="2">
<Value>customerAccount</Value>
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
<Value>otherAccount</Value>
</Value>
<Value name="7">
<Value>reference</Value>
</Value>
<Value name="8">
<Value>transferType</Value>
</Value>
</Data>
<DefaultData>TransferAvroEventDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
