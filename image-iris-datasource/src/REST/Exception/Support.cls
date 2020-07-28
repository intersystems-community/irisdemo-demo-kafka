Class REST.Exception.Support
{

ClassMethod ThrowStatusExceptionIfError(pSC As %Status, pExceptionName As %String)
{
	If $System.Status.IsError(pSC) 
	{
		//Just in case this Status String came from another system and includes SOAP details
		Set tSOAPFaultString=$Piece($Piece($System.Status.GetErrorText(pSC),"faultstring=",2),$C(13)) 
		Set tSOAPFaultActor=$Piece($Piece($System.Status.GetErrorText(pSC),"faultactor=",2),$C(13)) 
		
		//Let's create a simple status exception first
		Set statusException = ##class(%Exception.StatusException).CreateFromStatus(pSC) 
		
		Set tLocation=$System
		
		If statusException.Location'[" => "
		{
			Set tLocation=$System_" => "_statusException.Location
		}
		
		If tSOAPFaultString="" 
		{ 
			Set tName=pExceptionName
		} 
		Else 
		{
			//If the developer hasn't given us a pExceptionName, I want an UNDEFINED to be raised
			Set tName=tSOAPFaultString //Original error on the other system is better
			Set tLocation=$System_" => "_tSOAPFaultActor //$System from the other system is better
		}
		
		Set myException = ##class(%Exception.General).%New(tName, tName, tLocation, , statusException)
		
		Throw myException
	}
}

ClassMethod ThrowSQLExceptionIfError(pSQLCODE As %Status, pMsg As %String, pExceptionName As %String)
{
	Quit:pSQLCODE>=0
	
	//Let's create a simple sql exception first
	Set sqlException = ##class(%Exception.SQL).CreateFromSQLCODE(pSQLCODE, pMsg) 
			
	Set myException = ##class(%Exception.General).%New(pExceptionName, pExceptionName, $System, , sqlException)
	
	Throw myException
}

/// This method is called on the include macro DEMOMACROS.inc by the macro of the same name
/// It must be used only inside a SOAP service to report a SOAP Fault based on an exception that
/// was captured by a Try/Catch block
ClassMethod SOAPFaultWithException(pException As %Exception.AbstractException)
{
		
	Set tLocation = pException.Location
	If tLocation = ""
	{
		Set tLocation = $System
	}
	
	If pException.%ClassName()="StatusException"	
	{ 
		Set f = ##class(%SOAP.WebService).MakeStatusFault(pException.Code, pException.Name, pException.AsStatus(), tLocation) 
	} 
	Else 
	{ 
		Set f = ##class(%SOAP.WebService).MakeFault(pException.Code, pException.Name, "", tLocation)	
	} 
	
	Do ##class(%SOAP.WebService).ReturnFault(f)
}

/// This will convert
ClassMethod ExceptionAsJSON(pException As %Exception.AbstractException) As %Library.DynamicObject
{
	Set o={}
	Set o.Name=pException.Name
	Set o.Code=pException.Code
	Set o.Location=pException.Location
	If o.Location=""
	{
		Set o.Location=$System
	}
	ElseIf o.Location'[" => "
	{
		Set o.Location=$System_" => "_o.Location
	}
	
	If pException.Data'=""
	{
		Set o.Data=pException.Data
	}
	
	If pException.InnerException'=""
	{
		Set o.InnerException=..ExceptionAsJSON(pException.InnerException)
	}
	
	Quit o
}

}
