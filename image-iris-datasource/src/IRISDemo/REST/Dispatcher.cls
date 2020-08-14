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
	<Route Url="/data/:pClassName/:pID" Method="get" Call="Get" />
</Routes>
}

/// Example http://127.0.0.1:10001/csp/appint/rest/data/corebanking.com.irisdemo.banksim.avroevent.NewCustomerAvroEvent/2
ClassMethod Get(pClassName As %String, pID As %String) As %Status
{
	Set ^t(pClassName)=pID

	Set status = $$$OK
	Try
	{
		Set %response.Status = ..#HTTP200OK
		Set %response.ContentType=..#CONTENTTYPEJSON
		
		Set obj = $classmethod(pClassName, "%OpenId", pID)
		
		If obj="" $$$ThrowNotFoundException("Id "_pID_" not found on "_pClassName)

		Do obj.%JSONExport()
	}
	Catch (oException)
	{
		Do ..ErrorHandling(oException)
	}

	Quit $$$OK
}

}
