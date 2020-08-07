Class SchemaRegistry.SchemaGenerated Extends (%Persistent, REST.JSONRequest) [ Abstract ]
{

Parameter %JSONIGNOREINVALIDFIELD As BOOLEAN = 1;

Parameter %DTL As %String;

Property %SessionId As %String(%JSONINCLUDE = "none");

Property %ProcessingStatus As %String(%JSONINCLUDE = "none", DISPLAYLIST = ",Pending,Processing,Done,Error,Discarded", VALUELIST = ",PEND,PROC,DONE,ERR,DISC") [ InitialExpression = "PEND", Required ];

Property %ErrorMessage As %String(%JSONINCLUDE = "none", MAXLEN = "");

Property %DateReceived As %TimeStamp(%JSONINCLUDE = "none") [ InitialExpression = {$ZDateTime($ZTimeStamp, 3)}, Required ];

ClassMethod ParseJSONAndSave(pJSONString As %String) As %Status
{
    Set tSC = $$$OK
    Try 
    {    
        Quit:pJSONString=""
        
        Set obj = ..%New()
        Set tSC = obj.%JSONImport(pJSONString)
        Quit:$$$ISERR(tSC)

        Set tSC = obj.%Save()
    } 
    Catch (oException)
    {
        Set tSC = oException.AsStatus()
    }

    Quit tSC
}

Storage Default
{
<Data name="SchemaGeneratedDefaultData">
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
<DataLocation>^SchemaRegi5534.SchemaGener6DEFD</DataLocation>
<DefaultData>SchemaGeneratedDefaultData</DefaultData>
<IdLocation>^SchemaRegi5534.SchemaGener6DEFD</IdLocation>
<IndexLocation>^SchemaRegi5534.SchemaGener6DEFI</IndexLocation>
<StreamLocation>^SchemaRegi5534.SchemaGener6DEFS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
