Class SchemaRegistry.Driver.DriverAPI Extends %RegisteredObject [ Abstract ]
{

Property Config As SchemaRegistry.Config;

Property Request As %Net.HttpRequest;

/// Called by SchemaRegistry.Config when it is time to use a driver with a configuration
ClassMethod Create(pConfig As SchemaRegistry.Config, Output pDriver As SchemaRegistry.Driver.DriverAPI) As %Status [ Final ]
{
    Set tSC = $$$OK
    Set pDriver = ""
    Try
    {
        Set pDriver = ..%New()
        Set pDriver.Request = ##class(%Net.HttpRequest).%New()
        Set pDriver.Config = pConfig

        Set tSchemaRegistryURL=$ZConvert(pConfig.EndPoint,"L")
        Set tSchemaRegistryURL=$Replace(tSchemaRegistryURL,"http://","")
        Set tSchemaRegistryURL=$Replace(tSchemaRegistryURL,"https://","")

        Set pDriver.Request.Server=$Piece(tSchemaRegistryURL,":",1)
        Set pDriver.Request.Port=$Piece(tSchemaRegistryURL,":",2)
    }
    Catch (oException)
    {
        Set tSC = oException.AsStatus()
    }

    Quit tSC
}

Method SendGet(pResource As %String, Output pData) [ Final, Private ]
{
    Set tSC = $$$OK
    Set pData = ""
    Try
    {
        Set tSC = ..Request.Get(pResource)
        Quit:$$$ISERR(tSC)

        If ..Request.HttpResponse.StatusLine["200 OK"
        {
            Set pData = ..Request.HttpResponse.Data
        }
        Else
        {
            Set tSC = $$$ERROR(5001, "SendGet to "_pResource_" returned "_..Request.HttpResponse.StatusLine)
        }
    }
    Catch (oException)
    {
        Set tSC = oException.AsStatus()
    }
    
    Quit tSC
}

/// All we need is that the driver implements this method and returns the schema to us in the expected format
Method GetSchemas(Output pSchema) As %Status [ Abstract ]
{
}

}
