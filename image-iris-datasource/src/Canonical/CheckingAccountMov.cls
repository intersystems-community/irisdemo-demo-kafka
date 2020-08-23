Class Canonical.CheckingAccountMov Extends (%Persistent, SchemaNormalization.NormalizedData)
{

Property Amount As %Double [ Required ];

Property MovementDate As %TimeStamp [ Required ];

Property TransferId As %BigInt [ Required ];

Property OtherAccount As CheckingAccount [ Required ];

Property Account As CheckingAccount [ Required ];

Property RollingBalance As %Double;

Property MovementType As %String [ Required ];

Property LoanContract As Canonical.LoanContract;

Property Reference As %String;

Index ReferenceIndex On Reference;

Index AccountIndex On (Account, MovementDate);

Index TransferIdIndex On TransferId [ PrimaryKey ];

Storage Default
{
<Data name="CheckingAccountMovDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>%SessionId</Value>
</Value>
<Value name="3">
<Value>%VersionDateTime</Value>
</Value>
<Value name="4">
<Value>TransferId</Value>
</Value>
<Value name="5">
<Value>OtherAccount</Value>
</Value>
<Value name="6">
<Value>Account</Value>
</Value>
<Value name="7">
<Value>RollingBalance</Value>
</Value>
<Value name="8">
<Value>MovementType</Value>
</Value>
<Value name="9">
<Value>LoanContract</Value>
</Value>
<Value name="10">
<Value>Reference</Value>
</Value>
<Value name="11">
<Value>Amount</Value>
</Value>
<Value name="12">
<Value>MovementDate</Value>
</Value>
</Data>
<DataLocation>^Canonical.CheckingAccountMovD</DataLocation>
<DefaultData>CheckingAccountMovDefaultData</DefaultData>
<IdLocation>^Canonical.CheckingAccountMovD</IdLocation>
<IndexLocation>^Canonical.CheckingAccountMovI</IndexLocation>
<StreamLocation>^Canonical.CheckingAccountMovS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
