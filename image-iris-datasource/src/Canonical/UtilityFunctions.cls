Class Canonical.UtilityFunctions Extends Ens.Rule.FunctionSet
{

ClassMethod CheckingAccount(AccountNumber = "", ByRef pSC = 1) As Canonical.CheckingAccount
{
 If AccountNumber="" {
   Return ##class(Canonical.CheckingAccount).%New()
 } Else {
   Set obj=##class(Canonical.CheckingAccount).AccountNumberIndexOpen(AccountNumber)
   If obj="" Return ##class(Canonical.CheckingAccount).%New()
   Return obj
 }
}

ClassMethod CheckingAccountMov(TransferId = "", ByRef pSC = 1) As Canonical.CheckingAccountMov
{
 If TransferId="" {
   Return ##class(Canonical.CheckingAccountMov).%New()
 } Else {
   Set obj=##class(Canonical.CheckingAccountMov).TransferIdIndexOpen(TransferId)
   If obj="" Return ##class(Canonical.CheckingAccountMov).%New()
   Return obj
 }
}

ClassMethod Customer(CustomerID = "", ByRef pSC = 1) As Canonical.Customer
{
 If CustomerID="" {
   Return ##class(Canonical.Customer).%New()
 } Else {
   Set obj=##class(Canonical.Customer).CustomerIDIndexOpen(CustomerID)
   If obj="" Return ##class(Canonical.Customer).%New()
   Return obj
 }
}

ClassMethod LoanContract(ContractID = "", ByRef pSC = 1) As Canonical.LoanContract
{
 If ContractID="" {
   Return ##class(Canonical.LoanContract).%New()
 } Else {
   Set obj=##class(Canonical.LoanContract).ContractIDIndexOpen(ContractID)
   If obj="" Return ##class(Canonical.LoanContract).%New()
   Return obj
 }
}

}
