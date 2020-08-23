Class corebanking.AllObjects Extends (%Persistent, SchemaNormalization.OriginalData) [ Inheritance = left, ProcedureBlock ]
{

Index ProcessingStatusIndex On %ProcessingStatus;

Storage Default
{
<Data name="AllObjectsDefaultData">
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
</Data>
<DataLocation>^corebanking.AllObjectsD</DataLocation>
<DefaultData>AllObjectsDefaultData</DefaultData>
<IdLocation>^corebanking.AllObjectsD</IdLocation>
<IndexLocation>^corebanking.AllObjectsI</IndexLocation>
<StreamLocation>^corebanking.AllObjectsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
