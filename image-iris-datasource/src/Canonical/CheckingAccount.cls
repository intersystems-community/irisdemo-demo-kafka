Class Canonical.CheckingAccount Extends (%Persistent, SchemaNormalization.NormalizedData)
{

Property AccountNumber As %String [ Required ];

Property Balance As %Double [ InitialExpression = 0, Required ];

Property OpeningBalance As %Double [ InitialExpression = 0, Required ];

Property AccountOpenDate As %TimeStamp [ Required ];

Property Customer As Canonical.Customer(%JSONREFERENCE = "ID") [ Required ];

Index AccountNumberIndex On AccountNumber [ PrimaryKey ];

Storage Default
{
<Data name="CheckingAccountDefaultData">
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
<Value>AccountOpenDate</Value>
</Value>
<Value name="5">
<Value>AccountNumber</Value>
</Value>
<Value name="6">
<Value>Balance</Value>
</Value>
<Value name="7">
<Value>OpeningBalance</Value>
</Value>
<Value name="8">
<Value>Customer</Value>
</Value>
</Data>
<DataLocation>^Canonical.CheckingAccountD</DataLocation>
<DefaultData>CheckingAccountDefaultData</DefaultData>
<IdLocation>^Canonical.CheckingAccountD</IdLocation>
<IndexLocation>^Canonical.CheckingAccountI</IndexLocation>
<StreamLocation>^Canonical.CheckingAccountS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
