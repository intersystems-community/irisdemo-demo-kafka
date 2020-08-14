Class corebanking.com.irisdemo.banksim.avroevent.TransferAvroEventDTL Extends Ens.DataTransformDTL [ DependsOn = (corebanking.com.irisdemo.banksim.avroevent.TransferAvroEvent, Canonical.CheckingAccountMov) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='corebanking.com.irisdemo.banksim.avroevent.TransferAvroEvent' targetClass='Canonical.CheckingAccountMov' create='existing' language='objectscript' >
<assign value='source.amount' property='target.Amount' action='set' />
<assign value='source.eventDate' property='target.MovementDate' action='set' />
<assign value='##class(Canonical.UtilityFunctions).CheckingAccount(source.otherAccount,.tSC)' property='target.OtherAccount' action='set' />
<assign value='source.eventId' property='target.TransferId' action='set' />
<assign value='##class(Canonical.UtilityFunctions).CheckingAccount(source.customerAccount,.tSC)' property='target.Account' action='set' />
<assign value='source.transferType' property='target.MovementType' action='set' />
<assign value='source.reference' property='target.Reference' action='set' />
<assign value='target.Account.Balance+source.amount' property='target.Account.Balance' action='set' />
<assign value='target.Account.Balance' property='target.AccountBalance' action='set' />
<switch >
<case condition='source.transferType="LOAN_PAYMENT_OUT"' >
<annotation>If this customer is paying an installment for a loan, we want this entry to reference that loan contract</annotation>
<assign value='##class(Canonical.UtilityFunctions).LoanContract($Piece(source.reference,"#",2))' property='target.LoanContract' action='set' />
</case>
<case condition='source.transferType["BANK_LOAN"' >
<assign value='##class(Canonical.UtilityFunctions).LoanContract($Piece(source.reference,"#",2))' property='target.LoanContract' action='set' >
<annotation>If it is a BANK_LOAN_IN or BANK_LOAN_OUT, we just want to keep a reference to the loan contract.</annotation>
</assign>
</case>
<case condition='source.transferType="LOAN_PAYMENT_IN"' >
<annotation>Only the bank gets a LOAN_PAYMENT_IN. So we will not just apply the change to the bank&#39;s account, but we will also update the contract to reflect the amount paid.</annotation>
<assign value='##class(Canonical.UtilityFunctions).LoanContract($Piece(source.reference,"#",2))' property='target.LoanContract' action='set' />
<assign value='target.LoanContract.AmountPaid+source.amount' property='target.LoanContract.AmountPaid' action='set' />
</case>
</switch>
</transform>
}

}
