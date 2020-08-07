Class IRISDemo.Production Extends IRISDemo.BaseProduction
{

XData ProductionDefinition
{
<Production Name="IRISDemo.Production" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="Customer Normalization Process" Category="" ClassName="IRISDemo.BP.Customer.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="AlertOnError">1</Setting>
  </Item>
  <Item Name="Trace Operation" Category="" ClassName="IRISDemo.BO.Trace.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Application Specialist" Category="" ClassName="EnsLib.Workflow.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="AutoCreateRole">1</Setting>
  </Item>
  <Item Name="Ens.Alert" Category="" ClassName="EnsLib.EMail.AlertOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Kafka Schema Less Input" Category="" ClassName="Kafka.Service.SchemaLessService" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="%gatewayPort">55555</Setting>
    <Setting Target="Adapter" Name="GroupId">iris</Setting>
    <Setting Target="Adapter" Name="KafkaBrokerURL">http://broker:9092</Setting>
    <Setting Target="Adapter" Name="Topic">iris.testtopic</Setting>
    <Setting Target="Adapter" Name="UseKeyAsGlobalSubscript">1</Setting>
    <Setting Target="Adapter" Name="StoreKeyWithData">1</Setting>
    <Setting Target="Adapter" Name="KeyDeserializerClassName">org.apache.kafka.common.serialization.ByteArrayDeserializer</Setting>
    <Setting Target="Adapter" Name="ValueDeserializerClassName">org.apache.kafka.common.serialization.ByteArrayDeserializer</Setting>
  </Item>
  <Item Name="Java Gateway" Category="" ClassName="EnsLib.JavaGateway.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Kafka Transfers Service" Category="" ClassName="Kafka.Service.KeyLessAvroService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="%gatewayPort">55555</Setting>
    <Setting Target="Adapter" Name="GroupId">iris.transfers</Setting>
    <Setting Target="Adapter" Name="KafkaBrokerURL">http://broker:9092</Setting>
    <Setting Target="Adapter" Name="SchemaRegistryURL">http://schema-registry:8081</Setting>
    <Setting Target="Adapter" Name="Topic">transfers</Setting>
    <Setting Target="Adapter" Name="AutoOffsetResetConfig">earliest</Setting>
    <Setting Target="Adapter" Name="StorageClassName">com.irisdemo.banksim.avroevent.V1.TransferAvroEvent</Setting>
    <Setting Target="Host" Name="TargetConfigName">Trace Operation</Setting>
    <Setting Target="Adapter" Name="CallProcessInputUponNewData">1</Setting>
  </Item>
  <Item Name="Schema Registry Service" Category="" ClassName="SchemaRegistry.Monitor.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="ConfigName">ConfluentKafka</Setting>
    <Setting Target="Adapter" Name="CallInterval">60</Setting>
  </Item>
  <Item Name="Kafka Loan Contracts Service" Category="" ClassName="Kafka.Service.KeyLessAvroService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="StorageClassName">com.irisdemo.banksim.avroevent.V1.LoanContractAvroEvent</Setting>
    <Setting Target="Adapter" Name="SchemaRegistryURL">http://schema-registry:8081</Setting>
    <Setting Target="Adapter" Name="KafkaBrokerURL">http://broker:9092</Setting>
    <Setting Target="Adapter" Name="Topic">loan_contracts</Setting>
    <Setting Target="Adapter" Name="GroupId">iris.loan.contracts</Setting>
    <Setting Target="Adapter" Name="AutoOffsetResetConfig">earliest</Setting>
    <Setting Target="Adapter" Name="%gatewayPort">55555</Setting>
    <Setting Target="Host" Name="TargetConfigName">Trace Operation</Setting>
    <Setting Target="Adapter" Name="CallProcessInputUponNewData">1</Setting>
  </Item>
  <Item Name="Kafka Customer Demographics Service" Category="" ClassName="Kafka.Service.KeyLessAvroService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="KafkaBrokerURL">http://broker:9092</Setting>
    <Setting Target="Adapter" Name="SchemaRegistryURL">http://schema-registry:8081</Setting>
    <Setting Target="Adapter" Name="GroupId">iris.customer.demographics</Setting>
    <Setting Target="Adapter" Name="Topic">customer_demographics</Setting>
    <Setting Target="Adapter" Name="AutoOffsetResetConfig">earliest</Setting>
    <Setting Target="Adapter" Name="StorageClassName">com.irisdemo.banksim.avroevent.V1.DemographicsAvroEvent</Setting>
    <Setting Target="Adapter" Name="%gatewayPort">55555</Setting>
    <Setting Target="Host" Name="TargetConfigName">Trace Operation</Setting>
    <Setting Target="Adapter" Name="CallProcessInputUponNewData">1</Setting>
  </Item>
</Production>
}

}
