/// 
Class Cube.Loans Extends %DeepSee.CubeDefinition [ DependsOn = Canonical.LoanContract, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="Loans" displayName="Loans" disabled="false" abstract="false" sourceClass="Canonical.LoanContract" namedFactNums="true" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="ContractDate" disabled="false" hasAll="false" allCaption="All ContractDate" allDisplayName="ContractDate" sourceProperty="ContractDate" type="time" calendar="gregorian" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="ContractMonth" disabled="false" timeFunction="MonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="2">
      </level>
      <level name="ContractDay" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="4">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="PaidOut" disabled="false" hasAll="false" allCaption="All AmountPaid" allDisplayName="AmountPaid" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="AmountPaid" disabled="false" sourceExpression="%source.AmountPaid&gt;=%source.LoanAmount" list="false" rangeExpression="1:Paid Out;0:Active;" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="3">
      </level>
    </hierarchy>
  </dimension>
  <measure name="AmountPaid" disabled="false" sourceProperty="AmountPaid" aggregate="SUM" type="number" hidden="false" searchable="false" factNumber="1">
  </measure>
  <measure name="LoanAmount" disabled="false" sourceProperty="LoanAmount" aggregate="SUM" type="number" hidden="false" searchable="false" factNumber="2">
  </measure>
  <listing name="Listing" disabled="false" listingType="table" fieldList="ContractID,ContractDate,LoanAmount,AmountPaid,Customer-&gt;FullName AS &quot;Customer Name&quot;,Customer-&gt;Address_State AS &quot;Customer State&quot;,Customer-&gt;Address_City AS &quot;Customer City&quot;,DepositAccount-&gt;AccountNumber AS &quot;Customer Account&quot;">
  </listing>
</cube>
}

Parameter DOMAIN;

}
