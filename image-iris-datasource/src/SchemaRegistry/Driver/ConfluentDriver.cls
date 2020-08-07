Class SchemaRegistry.Driver.ConfluentDriver Extends DriverAPI
{

Method GetSchemas(Output pSchemas) As %Status
{
    Set tSC = $$$OK
    Try
    {
        Set tSC = ..DownloadSchemaSubjects(.arSchemaSubjects)
        Quit:$$$ISERR(tSC)

        Set schemaSubject = ""
        Set iSchema=0

        For 
        {
            Set schemaSubject = $Order(arSchemaSubjects(schemaSubject))
            Quit:schemaSubject=""

            Set tSC = ..DownloadSchemaSubjectVersions(schemaSubject, .versions)
            Quit:$$$ISERR(tSC)

            Set version=""
            For
            {
                Set version=$Order(versions(version))
                Quit:version=""

                Set tSC = ..DownloadSchema(schemaSubject, version, .arSchema)
                Quit:$$$ISERR(tSC)

                Set iSchema=iSchema+1
                Merge pSchemas(iSchema)=arSchema
            }            
        }
    }
    Catch (oException)
    {
        Set tSC = oException.AsStatus()
    }

    Quit tSC
}

Method DownloadSchemaSubjects(Output arSchemaSubjects) As %Status [ Private ]
{
    Set tSC = $$$OK
    Kill arTopics
    Try
    {
        Set tSC = ..SendGet("/subjects/", .response)
        Quit:$$$ISERR(tSC)

        Set topicsArray = [].%FromJSON(response)
        Set iterator = topicsArray.%GetIterator()
        While iterator.%GetNext(.key, .value)
        {
            If $Extract(value,*-$Length(..Config.ValueSchemaSuffix)+1,*)=..Config.ValueSchemaSuffix 
            {
                Set topic = $Piece(value, "-", 1, *-1)
                Set schemaSubject = value

                Set arSchemaSubjects(schemaSubject)=""
            }
            ElseIf $Extract(value,*-$Length(..Config.KeySchemaSuffix)+1,*)=..Config.KeySchemaSuffix 
            {
                // Key schemas are not supported for now
            }
            Else
            {
                // Why would we ever care about a topic without a schema?
            }
        }
    }
    Catch (oException)
    {
        Set tSC = oException.AsStatus()
    }
    
    Quit tSC
}

Method DownloadSchemaSubjectVersions(pSchemaSubject As %String, Output pVersions) As %Status [ Private ]
{
    Set tSC = $$$OK
    Kill pVersions
    Try
    {
        Set tSC = ..SendGet("/subjects/"_pSchemaSubject_"/versions/", .versionsResponse)
        Quit:$$$ISERR(tSC)

        Set versionArray = [].%FromJSON(versionsResponse)
        Set versionIterator = versionArray.%GetIterator()
        While versionIterator.%GetNext(.versionKey, .versionValue)
        {
            Set pVersions(versionValue)=""
        }
    }
    Catch (oException)
    {
        Set tSC = oException.AsStatus()
    }
    
    Quit tSC
}

Method DownloadSchema(pSubject As %String, pVersion As %Integer, Output pSchema) As %Status [ Private ]
{
    Set tSC = $$$OK
    Kill pSchema
    Try
    {
        Set tSC = ..SendGet("/subjects/"_pSubject_"/versions/"_pVersion, .response)
        Quit:$$$ISERR(tSC)

        Set schemaObj={}.%FromJSON(response)

        Set pSchema("subject")=schemaObj.subject
        Set pSchema("version")=schemaObj.version
        Set pSchema("id")=schemaObj.id
        Set pSchema("signature")=$System.Encryption.Base32HexEncode($System.Encryption.SHA1Hash(schemaObj.schema))
        Set pSchema("schema")=schemaObj.schema
    }
    Catch (oException)
    {
        Set tSC = oException.AsStatus()
    }
    
    Quit tSC
}

}
