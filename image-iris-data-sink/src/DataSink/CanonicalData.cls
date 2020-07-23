Class DataSink.CanonicalData Extends REST.JSONRequest [ Abstract, NoExtent ]
{

Property %SessionId As %String [ Required ];

Property %DataSourceName As %String [ Required ];

Property %DTL As %String [ Required ];

Property %VersionDateTime As %TimeStamp [ InitialExpression = {$ZDateTime($ZTimeStamp,3)}, Required ];

}
