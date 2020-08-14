Class SchemaNormalization.NormalizedDataProjection Extends %Projection.AbstractProjection
{

/// This method is invoked when a class is compiled
ClassMethod CreateProjection(cls As %String, ByRef params) As %Status
{
    Set tSC = $$$OK
    Try 
    {
        // We don't do nothing when the basic OPCUA.DataSourceDef class definition is compiled
        Quit:cls="SchemaNormalization.NormalizedData"

        Set oClassDef = ##class(%Dictionary.ClassDefinition).%OpenId(cls)
        
        Set oRS = ##class(%ResultSet).%New()
        Set tSC = oRS.Prepare("select Name, Properties from %Dictionary.IndexDefinition where parent=? and PrimaryKey=1")
        Quit:$$$ISERR(tSC)

        Set tSC = oRS.Execute(cls)
        Quit:$$$ISERR(tSC)

        If oRS.Next()
        {
            Set tIndexName = oRS.GetData(1)
            Set tIndexParams = oRS.GetData(2)

            Set tSC = ..UpdateCanonicalUtilityFunctions(cls, tIndexName_"Open", tIndexParams)
            Quit:$$$ISERR(tSC)
        }
    }
    Catch (oException)
    {
        Set tSC = oException.AsStatus()
    }
    
    Quit tSC
}

ClassMethod UpdateCanonicalUtilityFunctions(pCanonicalClassName As %String, pOpenMethodName As %String, pMethodParameters As %String) As %Status
{
    Set tSC = $$$OK
    Try 
    {
        Set tUtilityFunctionClassName = $Piece(pCanonicalClassName, ".", 1, *-1)_".UtilityFunctions"
        Set tUtilityMethodName = $Piece(pCanonicalClassName, ".", *)

        Write !,"Adding or updating ##class("_tUtilityFunctionClassName_")."_tUtilityMethodName_"()..."

        Set oClassDef = ##class(%Dictionary.ClassDefinition).%OpenId(tUtilityFunctionClassName)
        If oClassDef=""
        {
            Set oClassDef = ##class(%Dictionary.ClassDefinition).%New()
            Set oClassDef.Name = tUtilityFunctionClassName
            Set oClassDef.Super="Ens.Rule.FunctionSet"
        }

        Set bMethodFound=0
        For i=1:1:oClassDef.Methods.Count()
        {
            Set oMethodDef = oClassDef.Methods.GetAt(i)
            If oMethodDef.Name=tUtilityMethodName Set bMethodFound=1 Quit
        }

        If 'bMethodFound
        {
            Set oMethodDef = ##class(%Dictionary.MethodDefinition).%New()
            Set oMethodDef.parent = oClassDef
        }

        Set oMethodDef.Name=tUtilityMethodName
        Set oMethodDef.ClassMethod=1
        //Set oMethodDef.CodeMode="expression"
        Set oMethodDef.ReturnType=pCanonicalClassName
        
        Set tFormalSpec=""
        For i=1:1:$Length(pMethodParameters,",")
        {
            Set $Piece(tFormalSpec,",",i)=$Piece(pMethodParameters,",",i)_"="""""
        }

        Set tFormalSpec=tFormalSpec_",&pSC=1"
        Set oMethodDef.FormalSpec=tFormalSpec

        Do oMethodDef.Implementation.Clear()
        Set tFirstParam=$Piece(pMethodParameters,",")
        //Do oMethodDef.Implementation.Write("$Select("_tFirstParam_"="""":##class("_pCanonicalClassName_").%New(), 1:##class("_pCanonicalClassName_")."_pOpenMethodName_"("_pMethodParameters_",,.pSC))")
        Do oMethodDef.Implementation.WriteLine(" If "_tFirstParam_"="""" {")
        Do oMethodDef.Implementation.WriteLine("   Return ##class("_pCanonicalClassName_").%New()")
        Do oMethodDef.Implementation.WriteLine(" } Else {")
        Do oMethodDef.Implementation.WriteLine("   Set obj=##class("_pCanonicalClassName_")."_pOpenMethodName_"("_pMethodParameters_")")
        Do oMethodDef.Implementation.WriteLine("   If obj="""" Return ##class("_pCanonicalClassName_").%New()")
        Do oMethodDef.Implementation.WriteLine("   Return obj")
        Do oMethodDef.Implementation.WriteLine(" }")

        Set tSC = oClassDef.%Save(1)
        Quit:$$$ISERR(tSC)
        
        Set tSC = $System.OBJ.Compile(tUtilityFunctionClassName,"cuk")

        
    }
    Catch (oException)
    {
        Set tSC = oException.AsStatus()
    }
    
    Quit tSC
}

/// This method is invoked when a class is 'uncompiled'
ClassMethod RemoveProjection(cls As %String, ByRef params, recompile As %Boolean) As %Status
{
    Set tSC = $$$OK
    Try 
    {
        Quit:cls="SchemaNormalization.NormalizedData"
        
        Set tUtilityFunctionClassName = $Piece(cls, ".", 1, *-1)_".UtilityFunctions"
        Set tUtilityMethodName = $Piece(cls, ".", *)

        Set oClassDef = ##class(%Dictionary.ClassDefinition).%OpenId(tUtilityFunctionClassName)

        If oClassDef=""
        {
            Write !,"Class ",tUtilityFunctionClassName," not found!"
            Quit
        }

        Set bMethodFound=0
        For i=1:1:oClassDef.Methods.Count()
        {
            Set oMethodDef = oClassDef.Methods.GetAt(i)
            If oMethodDef.Name=tUtilityMethodName 
            {
                Set bMethodFound=1
                Quit
            }
        }

        If bMethodFound
        {
            Write !,"Removing ##class("_tUtilityFunctionClassName_")."_tUtilityMethodName_"()..."
            Do oClassDef.Methods.RemoveAt(i)
            Set tSC = oClassDef.%Save()
            Quit:$$$ISERR(tSC)

            Set tSC = $System.OBJ.Compile(tUtilityFunctionClassName,"cuk")
        }

    } 
    Catch (oException)
    {
        Set tSC = oException.AsStatus()
    }
    
    QUIT tSC
}

}
