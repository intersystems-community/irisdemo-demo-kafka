Class SchemaRegistry.Director
{

ClassMethod FormatColumn(pLabel As %String, pSize As %Integer) As %String
{
    Return $Reverse($Justify($Reverse(pLabel), pSize))
}

ClassMethod FormatRepeat(pStr As %String, pRepeatTimes As %Integer) As %String
{
    Set ret=""
    For i=1:1:pRepeatTimes Set ret=ret_pStr
    Return ret
}

ClassMethod DonwloadAndApplySchemas(pConfigName As %String) As %Status
{
    Set tSC = $$$OK
    Kill pVersions
    Try
    {
        Set tSC = ##class(SchemaRegistry.Config).GetDriver(pConfigName, .driverClass)
        Quit:$$$ISERR(tSC)
        
        Set tSC = $method(driverClass, "GetSchemas", .arSchemas)

        Set topic = ""
        For 
        {
            Set topic = $Order(arSchemas(topic))
            Quit:topic=""

            Set iSchema=""
            For
            {
                Set iSchema=$Order(arSchemas(topic, iSchema))
                Quit:iSchema=""

                Kill arSchema
                Merge arSchema=arSchemas(topic, iSchema)

                Set tSC = ##class(SchemaRegistry.SchemaGenerator).CreateOrReplaceClassTree(topic, .arSchema)
                Quit:$$$ISERR(tSC)
            }
        }
    }
    Catch (oException)
    {
        Set tSC = oException.AsStatus()
    }
    
    Quit tSC
}

}
