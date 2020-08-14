Class Canonical.LoanContract Extends (%Persistent, SchemaNormalization.NormalizedData)
{

Property Customer As Customer [ Required ];

Property DepositAccount As CheckingAccount [ Required ];

Property LoanAmount As %Double [ Required ];

Property AmountPaid As %Double [ InitialExpression = 0, Required ];

Property ContractDate As %TimeStamp [ Required ];

Property ContractID As %BigInt [ Required ];

Index ContractIDIndex On ContractID [ PrimaryKey ];

Storage Default
{
<Data name="LoanContractDefaultData">
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
<Value>LoanAmount</Value>
</Value>
<Value name="5">
<Value>AmountPaid</Value>
</Value>
<Value name="6">
<Value>ContractDate</Value>
</Value>
<Value name="7">
<Value>ContractID</Value>
</Value>
<Value name="8">
<Value>Customer</Value>
</Value>
<Value name="9">
<Value>DepositAccount</Value>
</Value>
</Data>
<DataLocation>^Canonical.LoanContractD</DataLocation>
<DefaultData>LoanContractDefaultData</DefaultData>
<IdLocation>^Canonical.LoanContractD</IdLocation>
<IndexLocation>^Canonical.LoanContractI</IndexLocation>
<StreamLocation>^Canonical.LoanContractS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
