Class SchemaRegistry.Monitor.Service Extends Ens.BusinessService
{

Parameter ADAPTER = "Ens.InboundAdapter";

Property ConfigName As %String;

Parameter SETTINGS = "ConfigName:Basic:selector?context={SchemaRegistry.Monitor.ContextSearch/Configs}";

Method OnProcessInput(pInput As %RegisteredObject, pOutput As %RegisteredObject, pHint As %String) As %Status
{
    Set tSC = $$$OK
    Try
    {
        Set tSC = ##class(SchemaRegistry.Director).DonwloadAndApplySchemas(..ConfigName)
    }
    Catch (oException)
    {
        Set tSC = oException.AsStatus()
    }

    Quit tSC
}

}
