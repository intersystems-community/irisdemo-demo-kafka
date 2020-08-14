Class SchemaNormalization.SchemaKeyMapConfig Extends %Persistent
{

Property OriginalSchemaClassName As %String(MAXLEN = "") [ Required ];

/// The DTL must be created with its "Create" attribute equals to "existing" 
Property DTLToNormalizedSchema As %String(MAXLEN = "") [ Required ];

/// Must always be created with its Create attribute set to "new"
Property DTLToDeriveKey As %String(MAXLEN = "");

Index OriginalSchemaClassNameIndex On OriginalSchemaClassName [ Unique ];

/// Business Process SchemaNormalization.Process will hold a cache of key maps in memory and call this method
/// often to create or open 
Method CreateOrUpdateNormalizedObject(pOriginalObject As SchemaNormalization.OriginalData, Output pNormalizedObject As SchemaNormalization.NormalizedData) As %Status
{
    Set tSC = $$$OK
    Try 
    {
        // Is this object already on the database and needs updating (due to a workflow reprocessing or
        // because we are collapsing events)
        Set tSC = $classmethod(..DTLToDeriveKey, "Transform", pOriginalObject, .pNormalizedKeyObject)
        Quit:$$$ISERR(tSC)

        // Now we can use the computed key to find an object like this on disk. This will return the 
        // object on disk or the same object if it is a new key
        Set tSC = pNormalizedKeyObject.FindMe(.pNormalizedObject)
        Quit:$$$ISERR(tSC)

        // Whatever that is, we will update it with the data from the event
        Set tSC = $classmethod(..DTLToNormalizedSchema, "Transform", pOriginalObject, .pNormalizedObject)

    } 
    Catch (oException)
    {
        Set tSC = oException.AsStatus()
    }

    Quit tSC
}

Storage Default
{
<Data name="SchemaKeyMapConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OriginalSchemaClassName</Value>
</Value>
<Value name="3">
<Value>DTLToNormalizedSchema</Value>
</Value>
<Value name="4">
<Value>DTLToDeriveKey</Value>
</Value>
</Data>
<DataLocation>^SchemaNorm9536.SchemaKeyMa1813D</DataLocation>
<DefaultData>SchemaKeyMapConfigDefaultData</DefaultData>
<IdLocation>^SchemaNorm9536.SchemaKeyMa1813D</IdLocation>
<IndexLocation>^SchemaNorm9536.SchemaKeyMa1813I</IndexLocation>
<StreamLocation>^SchemaNorm9536.SchemaKeyMa1813S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
