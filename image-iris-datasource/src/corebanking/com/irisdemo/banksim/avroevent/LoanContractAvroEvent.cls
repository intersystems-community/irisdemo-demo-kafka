Class corebanking.com.irisdemo.banksim.avroevent.LoanContractAvroEvent Extends (corebanking.AllObjects, SchemaNormalization.OriginalData) [ Inheritance = left, ProcedureBlock ]
{

Parameter SCHEMAID = 4;

Parameter SCHEMAIMPORTDATE = "2020-08-10 23:49:13";

Parameter SCHEMASIGNATURE = "2CSH4DNRFIO15R1BM0E8BIGUFLE9A5G4";

Parameter SCHEMASUBJECT = "com.irisdemo.banksim.avroevent.LoanContractAvroEvent";

Parameter SCHEMAVERSION = 1;

Property account As %String [ Required ];

Property amount As %Double [ Required ];

Property contractId As %BigInt [ Required ];

Property customerId As %BigInt [ Required ];

Property eventDate As %TimeStamp [ Required ];

Property eventId As %BigInt [ Required ];

Storage Default
{
<Data name="LoanContractAvroEventDefaultData">
<Subscript>"LoanContractAvroEvent"</Subscript>
<Value name="1">
<Value>account</Value>
</Value>
<Value name="2">
<Value>amount</Value>
</Value>
<Value name="3">
<Value>contractId</Value>
</Value>
<Value name="4">
<Value>customerId</Value>
</Value>
<Value name="5">
<Value>eventDate</Value>
</Value>
<Value name="6">
<Value>eventId</Value>
</Value>
</Data>
<DefaultData>LoanContractAvroEventDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
