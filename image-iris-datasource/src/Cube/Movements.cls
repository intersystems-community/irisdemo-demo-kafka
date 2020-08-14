/// 
Class Cube.Movements Extends %DeepSee.CubeDefinition [ DependsOn = Canonical.CheckingAccountMov, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="Movements" displayName="Checking Account Movements" disabled="false" abstract="false" sourceClass="Canonical.CheckingAccountMov" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="MovementDate" disabled="false" hasAll="false" allCaption="All MovementDate" allDisplayName="MovementDate" sourceProperty="MovementDate" type="time" calendar="gregorian" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="MovementDate" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="MovementType" disabled="false" hasAll="false" allCaption="All MovementType" allDisplayName="MovementType" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="MovementType" disabled="false" sourceProperty="MovementType" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" >
      </level>
    </hierarchy>
  </dimension>
</cube>
}

Parameter DOMAIN;

}
