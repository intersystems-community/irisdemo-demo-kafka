Class IRISDemo.Production Extends IRISDemo.BaseProduction
{

XData ProductionDefinition
{
<Production Name="IRISDemo.Production" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="Customer v1 Original Data" Category="" ClassName="DataSink.DataCollect.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="OriginalDataSource">Original.V1.Customer</Setting>
    <Setting Target="Host" Name="TargetConfigName">Customer Normalization Process</Setting>
  </Item>
  <Item Name="Customer Normalization Process" Category="" ClassName="IRISDemo.BP.Customer.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="AlertOnError">1</Setting>
  </Item>
  <Item Name="Customer v2 Original Data" Category="" ClassName="DataSink.DataCollect.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="OriginalDataSource">Original.V2.Customer</Setting>
    <Setting Target="Host" Name="TargetConfigName">Customer Normalization Process</Setting>
  </Item>
  <Item Name="Trace Operation" Category="" ClassName="IRISDemo.BO.Trace.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Application Specialist" Category="" ClassName="EnsLib.Workflow.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="AutoCreateRole">1</Setting>
  </Item>
  <Item Name="Ens.Alert" Category="" ClassName="EnsLib.EMail.AlertOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
