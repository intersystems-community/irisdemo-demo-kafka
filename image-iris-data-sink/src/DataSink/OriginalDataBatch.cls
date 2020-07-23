Class DataSink.OriginalDataBatch Extends (%Persistent, %JSON.Adaptor) [ Abstract, NoExtent ]
{

Parameter %JSONIGNOREINVALIDFIELD As BOOLEAN = 1;

Property %DateReceived As %TimeStamp(%JSONINCLUDE = "none") [ InitialExpression = {$ZDateTime($ZTimeStamp, 3)}, Required ];

Storage Default
{
<Data name="OriginalDataBatchDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>%DTL</Value>
</Value>
<Value name="3">
<Value>%ProcessStatus</Value>
</Value>
<Value name="4">
<Value>%ErrorMessage</Value>
</Value>
<Value name="5">
<Value>%DateReceived</Value>
</Value>
</Data>
<DataLocation>^DataSink.OriginalDataBatchD</DataLocation>
<DefaultData>OriginalDataBatchDefaultData</DefaultData>
<IdLocation>^DataSink.OriginalDataBatchD</IdLocation>
<IndexLocation>^DataSink.OriginalDataBatchI</IndexLocation>
<StreamLocation>^DataSink.OriginalDataBatchS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
