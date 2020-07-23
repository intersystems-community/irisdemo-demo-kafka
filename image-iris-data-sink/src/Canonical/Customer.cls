Class Canonical.Customer Extends (%Persistent, DataSink.CanonicalData)
{

Property AccountId As %String [ Required ];

Property FullName As %String [ Required ];

Property DateOfBirth As %Date [ Required ];

Property Address As Address;

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
<Value>%DataSourceName</Value>
</Value>
<Value name="4">
<Value>%DTL</Value>
</Value>
<Value name="5">
<Value>%VersionDateTime</Value>
</Value>
<Value name="6">
<Value>AccountId</Value>
</Value>
<Value name="7">
<Value>Address</Value>
</Value>
<Value name="8">
<Value>DateOfBirth</Value>
</Value>
<Value name="9">
<Value>FullName</Value>
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
