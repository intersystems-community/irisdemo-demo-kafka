Class corebanking.com.irisdemo.banksim.avroevent.TransferAvroEventDTLKey Extends Ens.DataTransformDTL [ DependsOn = (corebanking.com.irisdemo.banksim.avroevent.TransferAvroEvent, Canonical.CheckingAccountMov) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='corebanking.com.irisdemo.banksim.avroevent.TransferAvroEvent' targetClass='Canonical.CheckingAccountMov' create='new' language='objectscript' >
<assign value='source.eventId' property='target.TransferId' action='set' />
</transform>
}

}
