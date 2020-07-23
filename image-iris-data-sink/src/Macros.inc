ROUTINE Macros [Type=INC]

#define ThrowStatusExceptionIfError(%Status, %Name)	Do ##class(REST.Exception.Support).ThrowStatusExceptionIfError(%Status, %Name)

#define ThrowSQLExceptionIfError(%Name)	If SQLCODE<0 Do ##class(REST.Exception.Support).ThrowSQLExceptionIfError(SQLCODE, %msg, %Name)

#define ThrowSQLExceptionIfResultError(%oSQLResultStatement, %Name)	If %oSQLResultStatement.%SQLCODE<0 Do ##class(REST.Exception.Support).ThrowSQLExceptionIfError(%oSQLResultStatement.%SQLCODE, %oSQLResultStatement.%Message, %Name)

#define ThrowException(%Name,%message) Set e = ##class(%Exception.General).%New(%Name, %Name,,%message) Throw e

#define ExceptionAsJSON(%exception) ##class(REST.Exception.Support).ExceptionAsJSON(%exception)

#define ThrowBadRequestException(%message) Throw ##class(REST.Exception.BadRequest).%New(%message)

#define ThrowBadRequestExceptionIfError(%status, %Name) If $System.Status.IsError(%status) Set ex=##class(REST.Exception.BadRequest).CreateFromStatus(%status) Set ex.Name=%Name Throw ex

#define ThrowNotFoundException(%message) Throw ##class(REST.Exception.NotFound).%New(%message)