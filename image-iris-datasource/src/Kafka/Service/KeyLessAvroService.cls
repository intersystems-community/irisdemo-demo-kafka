/// This Kafka adapter will save the kafka messages on a global
/// The global name is defined based on the topic name
/// The subscript of the global can be:
/// 1 - The kafka message key if property UseKeyAsGlobalSubscript = 1
/// 2 - A sequential value if UseKeyAsGlobalSubscript = 0
/// 
/// It is very important to specify the correct deserializer for both the key and the value of the message.
/// 
/// If you are using kafka-console-producer to send test messages, beware that it serializes both
/// the key and the value using ByteArraySerializer. So pick ByteArrayDeserializer for both the
/// key and the value properties. On the other hand, if you are serializing the messages yourself and 
/// you know what serializers you are using, pick the right ones for your code.
Class Kafka.Service.KeyLessAvroService Extends Ens.BusinessService
{

Parameter ADAPTER = "Kafka.Adapter.KeyLessAvroInboundAdapter";

Property TargetConfigName As %String(MAXLEN = "");

Property DataSourceTableName As %String(MAXLEN = "");

Parameter SETTINGS = "TargetConfigName:Basic:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

/// This method will only be called if the adapter's CallProcessInputUponNewData = 1 and new data has arrived 
/// If you need to be notified about new data being arrived, you should just create your own business service
/// with the adapter Kafka.Adapter.SchemaLessInboundAdapter and implement your own OnProcessInput instead of
/// touching this class.
Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
    #Dim oStmtResult As %SQL.StatementResult
    
    Set tSC = $$$OK
    Try
    {
		Quit:..TargetConfigName=""

        If ..DataSourceTableName=""
        {
            Set tSC=..FindDataSourceTableName()
            Quit:$$$ISERR(tSC)
        }

        Set tSQL = "select %ID from "_..DataSourceTableName_" where %ProcessingStatus = 'PEND'"
        
        Set oStmtResult = ##class(%SQL.Statement).%ExecDirect(, tSQL)
        If oStmtResult.%SQLCODE'=0
        {
            Set tSC = $$$ERROR(5001,"Error trying to fetch data: "_oStmtResult.%Message)
            Quit
        }

        While oStmtResult.%Next()
        {
            Set id = oStmtResult.%GetData(1)
            Set obj = $classmethod(..Adapter.StorageClassName,"%OpenId",id)

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
        Set tSC = oException.AsStatus()
    }

	If $$$ISERR(tSC)
	{
		$$$LOGSTATUS(tSC)
	}
    
    Quit tSC
}

Method FindDataSourceTableName() As %Status
{
    Set oCompiledClass = ##class(%Dictionary.CompiledClass).%OpenId(..Adapter.StorageClassName,,.tSC)
    Quit:$$$ISERR(tSC) tSC

    Set ..DataSourceTableName = oCompiledClass.SqlSchemaName_"."_oCompiledClass.SqlTableName

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
