Class corebanking.com.irisdemo.banksim.avroevent.DemographicsAvroEventDTL Extends Ens.DataTransformDTL [ DependsOn = (corebanking.com.irisdemo.banksim.avroevent.DemographicsAvroEvent, Canonical.Customer) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='corebanking.com.irisdemo.banksim.avroevent.DemographicsAvroEvent' targetClass='Canonical.Customer' create='existing' language='objectscript' >
<assign value='source.name' property='target.FullName' action='set' />
<assign value='source.address.city' property='target.Address.City' action='set' />
<assign value='source.address.state' property='target.Address.State' action='set' />
<assign value='..Lookup("US_States_Code_To_Desc",source.address.state)' property='target.Address.StateDescription' action='set' />
<assign value='source.eventDate' property='target.AsOf' action='set' />
<assign value='source.address.phone' property='target.PhoneNumber' action='set' />
<assign value='source.customerId' property='target.CustomerID' action='set' />
</transform>
}

}
