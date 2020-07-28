Class SchemaRegistry.Config Extends %Persistent
{

Property Name As %String [ Required ];

Property EndPoint As %String(MAXLEN = "") [ Required ];

Property DriverName As %String [ Required ];

Property ValueSchemaSuffix As %String;

Property KeySchemaSuffix As %String;

Index NameIndex On Name [ Unique ];

ClassMethod Create(pName As %String, pEndPoint As %String, pDriverName As %String) As %Status
{
    Set obj=..%New()
    Set obj.Name=pName
    Set obj.EndPoint=pEndPoint
    Set obj.DriverName=pDriverName
    Quit obj.%Save()
}

ClassMethod GetDriver(pConfigName As %String, Output pDriver As SchemaRegistry.Driver.DriverAPI) As %Status
{
    Set tSC = $$$OK
    Set pDriver=""
    Try
    {
        Set obj = ..NameIndexOpen(pConfigName,,.tSC)
        Quit:$$$ISERR(tSC)

        Set tDriverClassName="SchemaRegistry.Driver."_obj.DriverName_"Driver"
        Set tSC = $classmethod(tDriverClassName,"Create", obj, .pDriver)
        Quit:$$$ISERR(tSC)
        
    }
    Catch (oException)
    {
        Set tSC = oException.AsStatus()
    }
    Quit tSC
}

}
