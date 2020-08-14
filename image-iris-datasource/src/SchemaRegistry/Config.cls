/// All tables generated from schemas on the schema registry will have the same parent table wich
/// will be named <Config.Name>.All.
Class SchemaRegistry.Config Extends %Persistent
{

Property Name As %String [ Required ];

Property EndPoint As %String(MAXLEN = "") [ Required ];

Property DriverName As %String [ Required ];

Property SubjectNamingStrategy As %String(VALUELIST = ",TopicNameStrategy,RecordNameStrategy,TopicRecordNameStrategy") [ InitialExpression = "RecordNameStrategy", Required ];

Index NameIndex On Name [ Unique ];

Method GetDataSourceTableName() As %String
{
    Set tSC = $$$OK
    Set tBaseClassName=..Name_".AllObjects"
    Set oCompiledClass = ##class(%Dictionary.CompiledClass).%OpenId(tBaseClassName,,.tSC)
    If $$$ISERR(tSC) Throw ##class(%Exception.General).%New("Base class '"_tBaseClassName_"' for schema configuration '"_..Name_"' does not exist.")

    Quit oCompiledClass.SqlSchemaName_"."_oCompiledClass.SqlTableName
}

Method GetDataSourceClassName() As %String
{
    Set tSC = $$$OK
    Set tBaseClassName=..Name_".AllObjects"
    Set oCompiledClass = ##class(%Dictionary.CompiledClass).%OpenId(tBaseClassName,,.tSC)
    If $$$ISERR(tSC) Throw ##class(%Exception.General).%New("Base class '"_tBaseClassName_"' for schema configuration '"_..Name_"' does not exist.")

    Quit tBaseClassName
}

ClassMethod Create(pName As %String, pEndPoint As %String, pDriverName As %String, pSubjectNamingStrategy As %String) As %Status
{
    Set obj=..%New()
    Set obj.Name=pName
    Set obj.EndPoint=pEndPoint
    Set obj.DriverName=pDriverName
    Set obj.SubjectNamingStrategy=pSubjectNamingStrategy
    Quit obj.%Save()
}

ClassMethod GetDriver(pConfigName As %String, Output pDriver As SchemaRegistry.Driver.DriverAPI) As %Status
{
    Set tSC = $$$OK
    Set pDriver=""
    Try
    {
        Set obj = ..NameIndexOpen(pConfigName,,.tSC)
        Quit:$$$ISERR(tSC)

        Set tDriverClassName="SchemaRegistry.Driver."_obj.DriverName_"Driver"
        Set tSC = $classmethod(tDriverClassName,"Create", obj, .pDriver)
        Quit:$$$ISERR(tSC)
        
    }
    Catch (oException)
    {
        Set tSC = oException.AsStatus()
    }
    Quit tSC
}

Storage Default
{
<Data name="ConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>EndPoint</Value>
</Value>
<Value name="4">
<Value>DriverName</Value>
</Value>
<Value name="5">
<Value>SubjectNamingStrategy</Value>
</Value>
</Data>
<DataLocation>^SchemaRegistry.ConfigD</DataLocation>
<DefaultData>ConfigDefaultData</DefaultData>
<IdLocation>^SchemaRegistry.ConfigD</IdLocation>
<IndexLocation>^SchemaRegistry.ConfigI</IndexLocation>
<StreamLocation>^SchemaRegistry.ConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
