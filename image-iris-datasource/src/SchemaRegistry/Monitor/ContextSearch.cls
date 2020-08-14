Include Ensemble

Class SchemaRegistry.Monitor.ContextSearch Extends Ens.ContextSearch
{

ClassMethod Configs(Output pCaption As %String, Output pTopResults, Output pResults, ByRef pParms As %String, pSearchKey As %String = "") As %Status
{
	Kill pResults  Set tSC=$$$OK

	Try 
    {
        Set oRS = ##class(%ResultSet).%New()
        Set tSC = oRS.Prepare("select Name from SchemaRegistry.Config order by Name")
        Quit:$$$ISERR(tSC)

        Set tSC = oRS.Execute()
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
