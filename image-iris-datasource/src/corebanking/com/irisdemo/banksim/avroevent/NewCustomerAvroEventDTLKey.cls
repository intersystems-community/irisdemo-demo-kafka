Class corebanking.com.irisdemo.banksim.avroevent.NewCustomerAvroEventDTLKey Extends Ens.DataTransformDTL [ DependsOn = (corebanking.com.irisdemo.banksim.avroevent.NewCustomerAvroEvent, Canonical.Customer) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='corebanking.com.irisdemo.banksim.avroevent.NewCustomerAvroEvent' targetClass='Canonical.Customer' create='new' language='objectscript' >
<assign value='source.customerId' property='target.CustomerID' action='set' />
</transform>
}

}
