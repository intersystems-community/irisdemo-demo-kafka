Class corebanking.com.irisdemo.banksim.avroevent.LoanContractAvroEventDTLKey Extends Ens.DataTransformDTL [ DependsOn = (corebanking.com.irisdemo.banksim.avroevent.LoanContractAvroEvent, Canonical.LoanContract) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='corebanking.com.irisdemo.banksim.avroevent.LoanContractAvroEvent' targetClass='Canonical.LoanContract' create='new' language='objectscript' >
<assign value='source.contractId' property='target.ContractID' action='set' />
</transform>
}

}
