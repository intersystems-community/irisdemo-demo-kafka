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
Class SchemaNormalization.Service Extends Ens.BusinessService
{

Parameter ADAPTER = "Ens.InboundAdapter";

Property TargetConfigName As %String(MAXLEN = "");

Property SchemaRegistryConfig As %String;

Property SchemaRegistryConfigObj As SchemaRegistry.Config;

/// How many messages to process on every Call Interval. The idea is to give time to IRIS to check if
/// the business service neest to be stopped. If we just let the query run with whatever is in the database
/// the query may try to process a lot of data at once and freeze the production
Property BatchSize As %Integer [ InitialExpression = 5000 ];

Parameter SETTINGS = "BatchSize:Basic,SchemaRegistryConfig:Basic:selector?context={SchemaRegistry.Monitor.ContextSearch/Configs},TargetConfigName:Basic:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

Method SchemaRegistryConfigSet(pSchemaRegistryConfigName As %String) As %Status
{
    Set tSC = $$$OK
    Set ..SchemaRegistryConfigObj = ##class(SchemaRegistry.Config).NameIndexOpen(pSchemaRegistryConfigName,,.tSC)
    Quit tSC
}

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

        Set tDataSourceTableName=..SchemaRegistryConfigObj.GetDataSourceTableName()
        Set tDataSourceClassName=..SchemaRegistryConfigObj.GetDataSourceClassName()

        Set tSQL = "select %ID from "_tDataSourceTableName_" where %ProcessingStatus = 'PEND'"
        
        Set oStmtResult = ##class(%SQL.Statement).%ExecDirect(, tSQL)
        If oStmtResult.%SQLCODE'=0
        {
            Set tSC = $$$ERROR(5001,"Error trying to fetch data: "_oStmtResult.%Message)
            Quit
        }

        For i=1:1
        {
            Quit:'oStmtResult.%Next()
            Quit:i=..BatchSize

            Set id = oStmtResult.%GetData(1)
            Set obj = $classmethod(tDataSourceClassName,"%OpenId",id)

            Set ..%SessionId=""
            Do ..ForceSessionId()

            Set obj.%ProcessingStatus="PROC"
            Set obj.%SessionId=..%SessionId

            // I am pushing the data to the business process on a synchronous call
            // because if the process fails and a human workflow starts, we can't let the
            // other messages be processed. We could partition by customer ID and allow for parallel 
            // processing though. But for now, all I can do is just to stop pushing messages and wait.
            // Waiting here will also block the PEX adapter from pulling new messages from Kafka which is not
            // bad. It wouldn't make a difference to bring all these messages in if we can't process them.
            Set tSC = ..SendRequestSync(..TargetConfigName, obj)
            Quit:$$$ISERR(tSC)            
        }
        
    }
    Catch (oException)
    {
        Set tSC = oException.AsStatus()
    }
    
    Quit tSC
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
