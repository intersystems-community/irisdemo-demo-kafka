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

Parameter SETTINGS = "-%remoteClassname,-%remoteSettings,-%gatewayExtraClasspaths,KafkaBrokerURL:Basic,Topic:Basic,GroupId:Basic,AutoOffsetResetConfig:Basic";

Method OnInit() As %Status
{
    Do ..AddRemoteSetting("TOPIC", ..Topic)
    Do ..AddRemoteSetting("BOOTSTRAP_SERVERS", ..KafkaBrokerURL)
    Do ..AddRemoteSetting("GROUP_ID", ..GroupId)
    Do ..AddRemoteSetting("AUTO_OFFSET_RESET_CONFIG", ..AutoOffsetResetConfig)
    Do ..AddRemoteSetting("CALL_INTERVAL", ..CallInterval)

	Quit ##super()
}

Method OnTask() As %Status
{
    Set tSC = ##super()
    
    Set ..BusinessHost.%WaitForNextCallInterval=0

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
