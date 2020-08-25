/// 
Class Cube.Movements Extends %DeepSee.CubeDefinition [ DependsOn = Canonical.CheckingAccountMov, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="Movements" displayName="Checking Account Movements" disabled="false" abstract="false" sourceClass="Canonical.CheckingAccountMov" namedFactNums="true" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="MovementDate" disabled="false" hasAll="false" allCaption="All MovementDate" allDisplayName="MovementDate" sourceProperty="MovementDate" type="time" calendar="gregorian" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="MovMonth" displayName="MovMonth" disabled="false" timeFunction="MonthNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="4">
      </level>
      <level name="MovDay" displayName="MovDay" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="5">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="MovementType" disabled="false" hasAll="false" allCaption="All MovementType" allDisplayName="MovementType" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="MovementType" disabled="false" sourceProperty="MovementType" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="3">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Loan" displayName="Loan" disabled="false" hasAll="false" allCaption="All LoanContract" allDisplayName="LoanContract" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="RefLoan" displayName="References Loan" disabled="false" sourceExpression="%source.LoanContract&apos;=0" list="false" rangeExpression="0:No;1:Yes;" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="6">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="AccountNumber" disabled="false" hasAll="false" allCaption="All AccountNumber" allDisplayName="AccountNumber" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="AccountNumber" disabled="false" sourceProperty="Account.AccountNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="7">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Customer" disabled="false" hasAll="false" allCaption="All City" allDisplayName="City" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="State" disabled="false" sourceProperty="Account.Customer.Address.StateDescription" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="8">
      </level>
      <level name="City" disabled="false" sourceProperty="Account.Customer.Address.City" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="9">
      </level>
    </hierarchy>
  </dimension>
  <measure name="Amount" disabled="false" sourceProperty="Amount" aggregate="SUM" type="number" hidden="false" searchable="false" factNumber="1">
  </measure>
  <measure name="RollingBalance" disabled="false" sourceProperty="RollingBalance" aggregate="SUM" type="number" hidden="false" searchable="false" factNumber="2">
  </measure>
</cube>
}

Parameter DOMAIN;

}
