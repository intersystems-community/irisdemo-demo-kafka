Class Canonical.Address Extends (%SerialObject, REST.JSONRequest)
{

Property State As %String [ Required ];

Property StateDescription As %String [ Required ];

Property City As %String [ Required ];

Property Street As %String [ Required ];

Property Zip As %String;

Storage Default
{
<Data name="AddressState">
<Value name="1">
<Value>State</Value>
</Value>
<Value name="2">
<Value>StateDescription</Value>
</Value>
<Value name="3">
<Value>City</Value>
</Value>
<Value name="4">
<Value>Street</Value>
</Value>
<Value name="5">
<Value>Zip</Value>
</Value>
</Data>
<State>AddressState</State>
<StreamLocation>^Canonical.AddressS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
