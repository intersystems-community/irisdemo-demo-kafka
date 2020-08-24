Class IRISDemo.Production Extends IRISDemo.BaseProduction
{

XData ProductionDefinition
{
<Production Name="IRISDemo.Production" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="Schema Normalization Process" Category="" ClassName="SchemaNormalization.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="AlertOnError">1</Setting>
  </Item>
  <Item Name="Trace Operation" Category="" ClassName="IRISDemo.BO.Trace.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Application Specialist" Category="" ClassName="EnsLib.Workflow.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="AutoCreateRole">1</Setting>
  </Item>
  <Item Name="Ens.Alert" Category="" ClassName="EnsLib.EMail.AlertOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Java Gateway" Category="" ClassName="EnsLib.JavaGateway.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Schema Registry Service" Category="" ClassName="SchemaRegistry.Monitor.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="ConfigName">corebanking</Setting>
    <Setting Target="Adapter" Name="CallInterval">60</Setting>
  </Item>
  <Item Name="Core Banking Kafka Events" Category="" ClassName="Kafka.Service.KeyLessAvroService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="%gatewayPort">55555</Setting>
    <Setting Target="Adapter" Name="AutoOffsetResetConfig">earliest</Setting>
    <Setting Target="Adapter" Name="KafkaBrokerURL">http://broker:9092</Setting> 
    <Setting Target="Adapter" Name="SchemaRegistryConfig">corebanking</Setting>
    <Setting Target="Adapter" Name="Topic">core-banking-system-events</Setting>
    <Setting Target="Host" Name="ThrottleDelay">300</Setting>
  </Item>
  <Item Name="Core Banking Normalization Service" Category="" ClassName="SchemaNormalization.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SchemaRegistryConfig">corebanking</Setting>
    <Setting Target="Host" Name="TargetConfigName">Schema Normalization Process</Setting>
    <Setting Target="Host" Name="BatchSize">1000</Setting>
    <Setting Target="Adapter" Name="CallInterval">0.1</Setting>
  </Item>
</Production>
}

}
