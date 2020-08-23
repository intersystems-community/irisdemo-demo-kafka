/* Copyright (c) 2020 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

Class Kafka.Adapter.Common Extends EnsLib.PEX.InboundAdapter
{

Property %gatewayExtraClasspaths As %String [ InitialExpression = "/kafka/kafka-pex-adapter.jar" ];

Property Topic As %String;

Property KafkaBrokerURL As %String(MAXLEN = "");

/// Make sure that every kafka business service on your production uses a different GroupID!
Property GroupId As %String [ InitialExpression = "iris" ];

/// When a consumer joins a consumer group it will fetch the last committed offset so it will restart 
/// to read from 5, 6, 7 if before crashing it committed the latest offset (so 4). The earliest and latest 
/// values for the auto.offset.reset property is used when a consumer starts but there is no committed offset
/// for the assigned partition. In this case you can chose if you want to re-read all the messages from the 
/// beginning (earliest) or just after the last one (latest).
Property AutoOffsetResetConfig As Kafka.Datatype.AutoOffsetResetOptions [ InitialExpression = "none", Required ];

/// Data will always be saved directly on the global storage of the class for the avro schema
/// You can optionally configure the adapter to call your Business Process ProcessInput() method
/// to let you know that new data has arrived. That call will be done on every CallInterval IF new data
/// has arrived.
Property CallProcessInputUponNewData As %Boolean [ InitialExpression = 0 ];

Parameter SETTINGS = "-%remoteClassname,-%remoteSettings,-%gatewayExtraClasspaths,KafkaBrokerURL:Basic,Topic:Basic,GroupId:Basic,AutoOffsetResetConfig:Basic";

Method OnInit() As %Status
{
    $$$LOGINFO("Common.OnInit()")

    Do ..AddRemoteSetting("TOPIC", ..Topic)
    Do ..AddRemoteSetting("BOOTSTRAP_SERVERS", ..KafkaBrokerURL)
    Do ..AddRemoteSetting("GROUP_ID", ..GroupId)
    Do ..AddRemoteSetting("AUTO_OFFSET_RESET_CONFIG", ..AutoOffsetResetConfig)
    Do ..AddRemoteSetting("CALL_INTERVAL", ..CallInterval)

	Quit ##super()
}

Method KafkaOffsetAlreadyCommitted(pPartition As %Integer, pOffSet As %BigInt) As %Boolean
{
    Return $Get($$$EnsStaticAppData(..BusinessHost.%ConfigName,"adapter.kafkaparam","LastOffSet",pPartition),-1)>=pOffSet
}

Method CommitKafkaOffset(pPartition As %Integer, pOffSet As %BigInt)
{
    Set $$$EnsStaticAppData(..BusinessHost.%ConfigName,"adapter.kafkaparam","LastOffSet", pPartition)=pOffSet
}

Method OnTask() As %Status
{
    Set tSC = ##super()
    
    If '$$$ISERR(tSC)
    {
        Set ..BusinessHost.%WaitForNextCallInterval=0
    }
    Else 
    {
        Set ..BusinessHost.%WaitForNextCallInterval=1
    }
    

    Quit tSC
}

Method AddRemoteSetting(pKey As %String, pValue As %String)
{
    If ..%remoteSettings=""
    {
        Set ..%remoteSettings=pKey_"="_pValue
    }
    Else
    {
        Set ..%remoteSettings=..%remoteSettings_$C(13,10)_pKey_"="_pValue
    }
}

}
