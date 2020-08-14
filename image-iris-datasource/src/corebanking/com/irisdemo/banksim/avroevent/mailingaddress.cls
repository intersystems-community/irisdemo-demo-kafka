Class corebanking.com.irisdemo.banksim.avroevent.mailingaddress Extends (%SerialObject, REST.JSONRequest) [ Inheritance = left, ProcedureBlock ]
{

Property city As %String [ Required ];

Property phone As %String [ Required ];

Property state As %String [ Required ];

Storage Default
{
<Data name="mailingaddressState">
<Value name="1">
<Value>city</Value>
</Value>
<Value name="2">
<Value>phone</Value>
</Value>
<Value name="3">
<Value>state</Value>
</Value>
</Data>
<State>mailingaddressState</State>
<StreamLocation>^corebankingC5E4.mailingaddressS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
