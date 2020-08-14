Class Canonical.Customer Extends (%Persistent, SchemaNormalization.NormalizedData)
{

Property AsOf As %TimeStamp [ Required ];

Property CustomerID As %BigInt [ Required ];

Property PhoneNumber As %String [ Required ];

Property FullName As %String [ Required ];

Property Address As Address;

Property CheckingAccount As CheckingAccount;

Index CustomerIDIndex On CustomerID [ PrimaryKey ];

Storage Default
{
<Data name="CustomerDefaultData">
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
<Value>PhoneNumber</Value>
</Value>
<Value name="5">
<Value>FullName</Value>
</Value>
<Value name="6">
<Value>Address</Value>
</Value>
<Value name="7">
<Value>CheckingAccount</Value>
</Value>
<Value name="8">
<Value>AsOf</Value>
</Value>
<Value name="9">
<Value>CustomerID</Value>
</Value>
</Data>
<DataLocation>^Canonical.CustomerD</DataLocation>
<DefaultData>CustomerDefaultData</DefaultData>
<IdLocation>^Canonical.CustomerD</IdLocation>
<IndexLocation>^Canonical.CustomerI</IndexLocation>
<StreamLocation>^Canonical.CustomerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
