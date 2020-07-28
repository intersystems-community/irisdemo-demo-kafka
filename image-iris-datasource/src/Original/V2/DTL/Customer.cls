Class Original.V2.DTL.Customer Extends Ens.DataTransformDTL [ DependsOn = (Original.V2.Customer, Canonical.Customer) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='Original.V2.Customer' targetClass='Canonical.Customer' create='new' language='objectscript' >
<assign value='source."account_id"' property='target.AccountId' action='set' />
<assign value='source.dob' property='target.DateOfBirth' action='set' />
<assign value='source.fullName' property='target.FullName' action='set' />
<assign value='source.address.zip' property='target.Address.Zip' action='set' />
<assign value='source.address.state' property='target.Address.State' action='set' />
<assign value='source.address.city' property='target.Address.City' action='set' />
<assign value='source.address.street' property='target.Address.Street' action='set' />
<assign value='..Lookup("US_States_Code_To_Desc",source.address.state)' property='target.Address.StateDescription' action='set' />
<assign value='source.%SessionId' property='target.%SessionId' action='set' />
<assign value='source.%DataSourceName' property='target.%DataSourceName' action='set' />
</transform>
}

}
