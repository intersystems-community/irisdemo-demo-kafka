Class SchemaRegistry.Monitor.Service Extends Ens.BusinessService
{

Parameter ADAPTER = "Ens.InboundAdapter";

Property SchemaRegistryURL As %String(MAXLEN = "");

Method OnProcessInput(pInput As %RegisteredObject, pOutput As %RegisteredObject, pHint As %String) As %Status
{
    Set tSC = $$$OK
    Try
    {
        Set httprequest=##class(%Net.HttpRequest).%New()
        Set httprequest.Server=$Piece(..SchemaRegistryURL,":")
        Set httprequest.Port=$Piece(..SchemaRegistryURL,":",2)
        Do httprequest.Get("/subjects/")
        Do httprequest.HttpResponse.OutputToDevice()
        Do httprequest.Get("/cache/")
        Do httprequest.HttpResponse.OutputToDevice()
    }
    Catch (oException)
    {
        Set tSC = oException.AsStatus()
    }

    Quit tSC
}

}
