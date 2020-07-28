Class REST.Exception.Base Extends %Exception.StatusException
{

Parameter HTTPStatus As %String = "400 Bad Request";

Parameter LogError As %Boolean = 0;

}
