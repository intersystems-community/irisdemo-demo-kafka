Class SchemaNormalization.NormalizedData Extends REST.JSONRequest [ Abstract, NoExtent ]
{

Property %SessionId As %String [ Required ];

Property %VersionDateTime As %TimeStamp [ InitialExpression = {$ZDateTime($ZTimeStamp,3)}, Required ];

Projection NormalizedDataProjection As SchemaNormalization.NormalizedDataProjection;

Method FindMe(Output pObjectLikeMe As SchemaNormalization.NormalizedData) As %Status [ CodeMode = objectgenerator ]
{
    Set tSC = $$$OK
    Try
    {
        Quit:%class.Name="SchemaNormalization.NormalizedData"

        Do %code.WriteLine("#dim tSC as %Status = $$$OK")

        Do %code.WriteLine(" try {")

        Set oRS = ##class(%ResultSet).%New()
        Set tSC = oRS.Prepare("select Name, Properties, IdKey from %Dictionary.IndexDefinition where parent=? and (IdKey=1 or PrimaryKey=1)")
        Quit:$$$ISERR(tSC)

        Set tSC = oRS.Execute(%class.Name)
        Quit:$$$ISERR(tSC)

        If oRS.Next()
        {
            Set tIndexName = oRS.GetData(1)
            Set tIndexParams = oRS.GetData(2)
            Set bIsIdKey = oRS.GetData(3)

            If bIsIdKey
            {    
                Set tSC = $$$ERROR(5001,"IdKey is not allowed on normalized canonical model")
                Quit
            }

            Do %code.Write("  Set pObjectLikeMe = .."_tIndexName_"Open(")    
            
            For i=1:1:$Length(tIndexParams,",")
            {
                Set tParamName=$Piece(tIndexParams,",", i)
                If i=1
                {
                    Do %code.Write(".."_tParamName)
                }
                Else 
                {
                    Do %code.Write(",.."_tParamName)
                }
            }

            Do %code.WriteLine(")")
            Do %code.WriteLine("  Quit:pObjectLikeMe'=""""")
            Do %code.WriteLine("  Set pObjectLikeMe=$this")
        }
        Else 
        {
            Write !,"WARNING: This class has no data driven Primary Key. It can only be used to store events. Not to collapse events. You will not be able to reference individual objects of this class from your DTLs."
        }
        

        Do %code.WriteLine(" } catch (e) {")
        Do %code.WriteLine(" Set tSC = e.AsStatus()")
        Do %code.WriteLine(" }")

        Do %code.WriteLine(" Quit tSC")
    }
    Catch (oException)
    {
        Set tSC = oException.AsStatus()
    }

    Quit tSC
}

Method GetObjectDump() As %String
{
    Set file = ##class(%File).%New(##class(%File).TempFilename())
    Do file.Open("WNS")
    Use file.Name
    ZWrite $this
    Use 0
    Do file.Close()
    Do file.Open("R") 
    Do file.Rewind()

    Set ret=""
    While 'file.AtEnd
    {
        Set ret=ret_file.Read()
    }
    
    Quit "<pre>"_ret_"</pre>"
}

}
