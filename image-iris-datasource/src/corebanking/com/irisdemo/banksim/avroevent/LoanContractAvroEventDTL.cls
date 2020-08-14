Class corebanking.com.irisdemo.banksim.avroevent.LoanContractAvroEventDTL Extends Ens.DataTransformDTL [ DependsOn = (corebanking.com.irisdemo.banksim.avroevent.LoanContractAvroEvent, Canonical.LoanContract) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='corebanking.com.irisdemo.banksim.avroevent.LoanContractAvroEvent' targetClass='Canonical.LoanContract' create='existing' language='objectscript' >
<assign value='source.eventDate' property='target.ContractDate' action='set' />
<assign value='source.amount' property='target.LoanAmount' action='set' />
<assign value='##class(Canonical.UtilityFunctions).CheckingAccount(source.account,.tSC)' property='target.DepositAccount' action='set' />
<assign value='##class(Canonical.UtilityFunctions).Customer(source.customerId,.tSC)' property='target.Customer' action='set' />
<assign value='source.contractId' property='target.ContractID' action='set' />
</transform>
}

}
