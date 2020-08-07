Class com.irisdemo.banksim.avroevent.V1.LoanContractAvroEvent Extends (%Persistent, SchemaRegistry.SchemaGenerated) [ Inheritance = right, Not ProcedureBlock ]
{

Parameter SCHEMACONFIG = "ConfluentKafka";

Parameter SCHEMAID = 1;

Parameter SCHEMAIMPORTDATE = "2020-08-07 01:07:26";

Parameter SCHEMASIGNATURE = "4LK843JQ584AE5OVDA9AAK8AD8GBAF21";

Parameter SCHEMASUBJECT = "loan_contracts-value";

Parameter SCHEMAVERSION = 1;

Property account As %String [ Required ];

Property amount As %Double [ Required ];

Property eventDate As %TimeStamp [ Required ];

Property id As %BigInt [ Required ];

Storage Default
{
<Data name="LoanContractAvroEventDefaultData">
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
<Value>amount</Value>
</Value>
<Value name="8">
<Value>eventDate</Value>
</Value>
<Value name="9">
<Value>id</Value>
</Value>
</Data>
<DataLocation>^com.irisdeEE08.LoanContracAFCAD</DataLocation>
<DefaultData>LoanContractAvroEventDefaultData</DefaultData>
<IdLocation>^com.irisdeEE08.LoanContracAFCAD</IdLocation>
<IndexLocation>^com.irisdeEE08.LoanContracAFCAI</IndexLocation>
<StreamLocation>^com.irisdeEE08.LoanContracAFCAS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
