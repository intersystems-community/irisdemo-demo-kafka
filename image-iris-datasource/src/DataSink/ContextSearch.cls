Class DataSink.ContextSearch Extends %ZEN.Portal.ContextSearch
{

ClassMethod DataSources(Output pCaption As %String, Output pTopResults, Output pResults, ByRef pParms As %String, pSearchKey As %String = "") As %Status
{
		Set pParms("class")="DataSink.OriginalData"
		Quit ##class(Ens.ContextSearch).SubclassOf(.pCaption, .pTopResults, .pResults, .pParms, .pSearchKey)
}

}
