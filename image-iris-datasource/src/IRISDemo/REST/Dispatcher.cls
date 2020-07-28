Include Macros

/// As per the documentation on https://docs.intersystems.com/latest/csp/docbook/DocBook.UI.Page.cls?KEY=EREST_service, one
/// should not use EnsLib.REST.Service to create REST business services with IRIS Interoperability. We should use %CSP.REST instead.
/// So, this dispatcher class will serve as an example of how to create a rest service that is calling a business service while
/// a better way of doing it is not available.
Class IRISDemo.REST.Dispatcher Extends (%CSP.REST, REST.Base)
{

Parameter HandleCorsRequest = 1;

Parameter UseSession = 1;

Parameter CONVERTINPUTSTREAM = 1;

Parameter CHARSET = "utf-8";

XData UrlMap
{
<Routes>
	<Route Url="/v1/:id" Method="get" Call="GetV1" />
	<Route Url="/v2/:id" Method="get" Call="GetV2" />
	<Route Url="/canonical/:id" Method="get" Call="GetCanonical" />
	<Route Url="/v1" Method="post" Call="CreateV1" />
	<Route Url="/v1/batch" Method="post" Call="CreateV1Batch" />
	<Route Url="/v2" Method="post" Call="CreateV2" />
	<Route Url="/v2/batch" Method="post" Call="CreateV2Batch" />
</Routes>
}

ClassMethod GetV1(id) As %Status
{
	Quit ..Get("V1", id)
}

ClassMethod GetV2(id) As %Status
{
	Quit ..Get("V2", id)
}

ClassMethod GetCanonical(id) As %Status
{
	Quit ..Get("", id)
}

ClassMethod CreateV1() As %Status
{
	Quit ..Create("V1")
}

ClassMethod CreateV2() As %Status
{
	Quit ..Create("V2")
}

ClassMethod CreateV1Batch() As %Status
{
	Quit ..Create("V1", 1)
}

ClassMethod CreateV2Batch() As %Status
{
	Quit ..Create("V2", 1)
}

ClassMethod Create(pVersion As %String, pBatchMode As %Boolean = 0) As %Status
{
	Set status = $$$OK
	Try
	{
		// Configuring response type to JSON
		Set %response.ContentType=..#CONTENTTYPEJSON
		Set %response.Status = ..#HTTP200OK
		
		Set response = {}
		
		// Instantiating the right class for the version
		If pBatchMode
		{
			Set tClassName="Original."_pVersion_".CustomerBatch"
		}
		Else 
		{
			Set tClassName="Original."_pVersion_".Customer"
		}
		
		Set original = $classmethod(tClassName, "%New")

		// Importing the JSON into the instance
		Set status = original.%JSONImport(%request.Content)
		$$$ThrowBadRequestExceptionIfError(status, "JSONImportException")
		
		// Saving to disk
		Set status = original.%Save()
		$$$ThrowStatusExceptionIfError(status, "SaveObjectException")

		Do ..ReportHTTPStatusCreated(original.%Id())
	}
	Catch (oException)
	{
		Do ..ErrorHandling(oException)
	}

	Quit $$$OK
}

ClassMethod Get(pVersion As %String, pID As %String) As %Status
{
	Set status = $$$OK
	Try
	{
		Set %response.Status = ..#HTTP200OK
		Set %response.ContentType=..#CONTENTTYPEJSON

		If pVersion'=""
		{
			Set tClassName="Original."_pVersion_".Customer"
		}
		Else
		{
			Set tClassName="Canonical.Customer"
		}
		
		Set obj = $classmethod(tClassName, "%OpenId", pID)
		
		If obj="" $$$ThrowNotFoundException("Customer with id "_pID_" not found")

		Do obj.%JSONExport()
	}
	Catch (oException)
	{
		Do ..ErrorHandling(oException)
	}

	Quit $$$OK
}

}
