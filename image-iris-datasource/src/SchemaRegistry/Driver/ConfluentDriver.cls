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
        Set topic=""

        For 
        {
            Set iSchema=0

            Set topic = $Order(arSchemaSubjects(topic))
            Quit:topic=""

            For 
            {
                Set schemaSubject = $Order(arSchemaSubjects(topic, schemaSubject))
                Quit:schemaSubject=""

                Set tSC = ..DownloadSchemaSubjectVersions(schemaSubject, .versions)
                Quit:$$$ISERR(tSC)

                //Taking only the last version
                Set version=$Order(versions(""), -1)
                Quit:version=""

                Set tSC = ..DownloadSchema(schemaSubject, version, .arSchema)
                Quit:$$$ISERR(tSC)

                Set iSchema=iSchema+1
                Merge pSchemas(topic, iSchema)=arSchema
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
        While iterator.%GetNext(.valueIndex, .value)
        {
            // See: https://www.confluent.io/blog/put-several-event-types-kafka-topic/

            /*
            io.confluent.kafka.serializers.subject.TopicNameStrategy (default): The subject name for message keys is <topic>-key, 
            and <topic>-value for message values. This means that the schemas of all messages in the topic must be compatible with each other.
            */
            If ..Config.SubjectNamingStrategy="TopicNameStrategy"
            {
                If $Piece(value,"-",*)="value"
                {
                    Set topic = $Piece(value, "-", 1, *-1)
                    Set schemaSubject=value
                    Set arSchemaSubjects(topic, schemaSubject)=""
                }
                ElseIf $Piece(value,"-",*)="key"
                {
                    // Not supporting key-based schema as of now
                }
            }
            /*
            io.confluent.kafka.serializers.subject.RecordNameStrategy: The subject name is the fully-qualified name of the Avro record 
            type of the message. Thus, the schema registry checks the compatibility for a particular record type, regardless of topic. 
            This setting allows any number of different event types in the same topic.
            */
            ElseIf ..Config.SubjectNamingStrategy="RecordNameStrategy"
            {
                Set arSchemaSubjects(..Config.Name,value)=""
            }
            /*
            io.confluent.kafka.serializers.subject.TopicRecordNameStrategy: The subject name is <topic>-<type>, where <topic> is the Kafka
            topic name, and <type> is the fully-qualified name of the Avro record type of the message. This setting also allows any number 
            of event types in the same topic, and further constrains the compatibility check to the current topic only.
            */
            ElseIf ..Config.SubjectNamingStrategy="TopicRecordNameStrategy"
            {
                //Not supported right now
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
