Class Original.V2.Address Extends (%SerialObject, %JSON.Adaptor, %XML.Adaptor)
{

Property state As %String [ Required ];

Property city As %String [ Required ];

Property street As %String [ Required ];

Property zip As %String [ Required ];

Storage Default
{
<Data name="AddressState">
<Value name="1">
<Value>state</Value>
</Value>
<Value name="2">
<Value>city</Value>
</Value>
<Value name="3">
<Value>street</Value>
</Value>
<Value name="4">
<Value>zip</Value>
</Value>
</Data>
<State>AddressState</State>
<StreamLocation>^Original.V2.AddressS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
