Include %PMML

Class IRISDemo.BO.Trace.Operation Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method OnMessage(pRequest As %Library.Persistent, Output pResponse As %Library.Persistent) As %Status
{
	Quit $$$OK
}

}
