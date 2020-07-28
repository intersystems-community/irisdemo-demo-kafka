Class Original.V1.Address Extends (%SerialObject, %JSON.Adaptor, %XML.Adaptor)
{

Property state As %String [ Required ];

Property city As %String [ Required ];

Property street As %String [ Required ];

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
</Data>
<State>AddressState</State>
<StreamLocation>^Original.V1.AddressS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
