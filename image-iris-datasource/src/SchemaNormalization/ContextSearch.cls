Include Ensemble

Class SchemaNormalization.ContextSearch Extends Ens.ContextSearch
{

ClassMethod Schemas(Output pCaption As %String, Output pTopResults, Output pResults, ByRef pParms As %String, pSearchKey As %String = "") As %Status
{
	Kill pResults  Set tSC=$$$OK

	Try 
    {
        Set oRS = ##class(%ResultSet).%New("%Dictionary.ClassDefinitionQuery:SubclassOf")

        Set tSC = oRS.Execute("SchemaNormalization.OriginalData")
        Quit:$$$ISERR(tSC)

        For i=1:1 
        {
            Quit:'oRS.Next()

            Set pResults(i)=oRS.GetData(1)
        }
	} 
    Catch 
    {
		Set tSC = $$$SystemError
	}
	Quit tSC
}

}
