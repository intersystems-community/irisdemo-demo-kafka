Class DataSink.DataCollect.Service Extends Ens.BusinessService
{

Parameter ADAPTER = "Ens.InboundAdapter";

Property OriginalDataSource As %String(MAXLEN = "");

Property OriginalDataSourceTableName As %String;

Property TargetConfigName As %String(MAXLEN = "");

Parameter SETTINGS = "-PoolSize,OriginalDataSource:Basic:selector?context={DataSink.ContextSearch/DataSources},TargetConfigName:Basic:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
    #Dim oStmtResult As %SQL.StatementResult
    
    Set tSC = $$$OK
    Try
    {
        If ..OriginalDataSourceTableName=""
        {
            Set tSC=..FindDataSourceTableName()
            Quit:$$$ISERR(tSC)
        }

        Set tSQL = "select ID from "_..OriginalDataSourceTableName_" where %ProcessingStatus = 'PEND'"
        $$$TRACE(tSQL)
        
        Set oStmtResult = ##class(%SQL.Statement).%ExecDirect(, tSQL)
        If oStmtResult.%SQLCODE'=0
        {
            Set tSC = $$$ERROR(5001,"Error trying to fetch data: "_oStmtResult.%Message)
            Quit
        }

        While oStmtResult.%Next()
        {
            Set id = oStmtResult.%GetData(1)
            Set obj = $classmethod(..OriginalDataSource,"%OpenId",id)

            Set ..%SessionId=""
            Do ..ForceSessionId()

            Set tSC = ..SendRequestAsync(..TargetConfigName, obj)
            Quit:$$$ISERR(tSC)

            Set obj.%ProcessingStatus="PROC"
            Set obj.%SessionId=..%SessionId
            Set tSC = obj.%Save()
            Quit:$$$ISERR(tSC)

            
        }
        
    }
    Catch (oException)
    {
        $$$TRACE("An exception just occurred.")
        Set tSC = oException.AsStatus()
    }
    
    Quit tSC
}

Method FindDataSourceTableName() As %Status
{
    Set oCompiledClass = ##class(%Dictionary.CompiledClass).%OpenId(..OriginalDataSource,,.tSC)
    Quit:$$$ISERR(tSC) tSC

    Set ..OriginalDataSourceTableName = oCompiledClass.SqlSchemaName_"."_oCompiledClass.SqlTableName

    Quit $$$OK
}

ClassMethod OnGetConnections(Output pArray As %String, pItem As Ens.Config.Item)
{
    Do ##super(.pArray,pItem)
    If pItem.GetModifiedSetting("TargetConfigName",.tValue) 
    {
        Set pArray(tValue)=""
    }
}

}
