Class Kafka.Service.KeyLessAvroService Extends Ens.BusinessService
{

Parameter ADAPTER = "Kafka.Adapter.KeyLessAvroInboundAdapter";

Property DisableTransactionSupport As %Boolean [ InitialExpression = 1 ];

Parameter SETTINGS = "DisableTransactionSupport";

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject, pHint As %String) As %Status
{
    Set tSC = $$$OK
    Try 
    {   
        Set tPartition = $ListGet(pInput, 1)
        Set tOffSet = $ListGet(pInput, 2)

        // Skip message that has been processed already. 
        // This may happen if we are restarting consumption of a topic and the first set of messages on a 
        // batch returned by poll() have been processed on the previous run without being committed to the broker
        // because of an unpredictable event. So we will just ignore this offset and keep going until
        // we get an offset value that we have processed. The offset is only meaningful when accompanied byt its
        // partition number. Typically, we will have only one partition to mantain message ordering guarantees.
        // But it is also possible to mantain message ordering guarantees when using multiple parititions and using 
        // a message key to split the data in the partitions. So we are making sure we are storing the offset under
        // its partition number just in case.
        If ..Adapter.KafkaOffsetAlreadyCommitted(tPartition, tOffSet)
        {
            $$$LOGINFO("Skipping offset "_tOffSet_" from partition "_tPartition_" because it has been processed already")
            Quit
        }

        Set tClassName = $ListGet(pInput, 3)
        Set tJSON = $ListGet(pInput, 4)
        
        // We need to start a transaction in order to make sure we are saving the object as 
        // well as recording the last offset read from the partition as a single unit of work
        TStart:'..DisableTransactionSupport
        
        Set tSC = $classmethod(tClassName, "ParseJSONAndSave", tJSON)
        Quit:$$$ISERR(tSC)

        Do ..Adapter.CommitKafkaOffset(tPartition, tOffSet)

        TCommit:'..DisableTransactionSupport
    } 
    Catch (oException)
    {
        Set tSC = oException.AsStatus()
    }
    
    If $TLevel>0
    {
        // If we are here, it is because we open the transaction, but we did not commit
        // That is because of an error so we must rollback
        TRollback
    }

    If $$$ISERR(tSC)
    {
        $$$LOGSTATUS(tSC)
    }

    Quit tSC
}

}
