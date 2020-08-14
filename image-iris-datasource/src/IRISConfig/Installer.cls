Include %occInclude

Class IRISConfig.Installer Extends IRISConfig.InstallerBase
{

ClassMethod LoadUSStates(pNamespace As %String) As %Status
{
	#Dim file As %File
	
	Set tLookupTableName="US_States_Code_To_Desc"
	
	Set tSC = $$$OK
	Try
	{
		ZN "APPINT"
		
		Set file = ##class(%File).%New("/tmp/us_states.json")
		Set tSC = file.Open("R")
		Quit:$$$ISERR(tSC)
				
		Set statesArray = ##class(%Library.DynamicArray).%FromJSON(file)
		If statesArray=""
		{
			Set tSC = $$$ERROR(5001,"Could not read JSON from file '"_pFileName_"'")
			Quit
		}
		
		Set iterator = statesArray.%GetIterator()

		Kill ^Ens.LookupTable(tLookupTableName)
		Set ^Ens.LookupTable(tLookupTableName)=$ListBuild($Horolog)
		
		While iterator.%GetNext(.key, .JSONObject)
		{
			Set ^Ens.LookupTable(tLookupTableName, JSONObject.Code)=JSONObject.State
		}
		
		Set ^IRISDemo.BS.LookupTable("PopulatedTables", tLookupTableName)=$ListBuild($H)
		
	}
	Catch (oException)
	{
		Set tSC = oException.AsStatus()
	}	
	
	ZN "%SYS"
	
	Quit tSC
}

ClassMethod ConfigSchemaRegistry(pNamespace As %String, pSchemaRegistryURL As %String) As %Status
{
	Set tSC = $$$OK
	Try
	{
		ZN "APPINT"
		
		Set tSC = ##class(SchemaRegistry.Config).Create("corebanking",pSchemaRegistryURL,"Confluent","RecordNameStrategy")

	}
	Catch (oException)
	{
		Set tSC = oException.AsStatus()
	}	
	
	ZN "%SYS"
	
	Quit tSC
}

ClassMethod DisableJournalForDatabase(pDatabaseName As %String) As %Status
{
	Set tSC = $$$OK
	Try
	{
		Set tSC = ##class(Config.Databases).Get(pDatabaseName, .v)
		Quit:$$$ISERR(tSC)

		Set tDatabaseDir = v("Directory")

		Set db=##Class(SYS.Database).%OpenId(tDatabaseDir)
		Set db.GlobalJournalState=2

		Set tSC = db.%Save()
	}
	Catch (oException)
	{
		Set tSC = oException.AsStatus()
	}	
		
	Quit tSC
}

ClassMethod SchemaKeyMapConfig(pNamespace As %String) As %Status
{
	#define CheckSQLCODE If SQLCODE<0 Set tSC = $$$ERROR(5001, %msg) Quit 

	Set tSC = $$$OK
	Try
	{
		Set tNS=$Namespace
		Set $Namespace=pNamespace
		
		Set oRS = ##class(%ResultSet).%New()
		Set tSC = oRS.Prepare("insert into SchemaNormalization.SchemaKeyMapConfig (OriginalSchemaClassName, DTLToNormalizedSchema, DTLToDeriveKey) values (?, ?, ?)")
		Quit:$$$ISERR(tSC)

		Set tSC = oRS.Execute("corebanking.com.irisdemo.banksim.avroevent.NewCustomerAvroEvent", "corebanking.com.irisdemo.banksim.avroevent.NewCustomerAvroEventDTL","corebanking.com.irisdemo.banksim.avroevent.NewCustomerAvroEventDTLKey")
		Quit:$$$ISERR(tSC)
		
		Set tSC = oRS.Execute("corebanking.com.irisdemo.banksim.avroevent.DemographicsAvroEvent", "corebanking.com.irisdemo.banksim.avroevent.DemographicsAvroEventDTL","corebanking.com.irisdemo.banksim.avroevent.DemographicsAvroEventDTLKey")
		Quit:$$$ISERR(tSC)

		Set tSC = oRS.Execute("corebanking.com.irisdemo.banksim.avroevent.LoanContractAvroEvent", "corebanking.com.irisdemo.banksim.avroevent.LoanContractAvroEventDTL","corebanking.com.irisdemo.banksim.avroevent.LoanContractAvroEventDTLKey")
		Quit:$$$ISERR(tSC)

		Set tSC = oRS.Execute("corebanking.com.irisdemo.banksim.avroevent.TransferAvroEvent", "corebanking.com.irisdemo.banksim.avroevent.TransferAvroEventDTL","corebanking.com.irisdemo.banksim.avroevent.TransferAvroEventDTLKey")
		Quit:$$$ISERR(tSC)
	}
	Catch (oException)
	{
		Set tSC = oException.AsStatus()
	}

	Set $Namespace=tNS
		
	Quit tSC
}

/// You can customize this to run code during docker build
XData Install [ XMLNamespace = INSTALLER ]
{
<Manifest>
	<Namespace Name="${Namespace}" Create="no">
		<IfDef Var="SourceDir">
            <Log Text="SourceDir defined - offline install from ${SourceDir}" Level="0"/>
            <Import File="${SourceDir}" Recurse="true"/>
        </IfDef>
	</Namespace>
	
	<Log Text="Loading US states data for demo..." Level="0"/>
	<Invoke Class="IRISConfig.Installer" Method="LoadUSStates" CheckStatus="true">
		<Arg name="pNamespace" Value="${Namespace}"/>
	</Invoke>
	
	<Log Text="Adding workflow role for demo..." Level="0"/>
	<Invoke Class="IRISConfig.Installer" Method="AddWFRole" CheckStatus="true">
		<Arg name="pNamespace" Value="${Namespace}"/>
		<Arg name="pRoleName" Value="Application Specialist"/>
	</Invoke>
		
	<Log Text="Adding workflow user for demo..." Level="0"/>
	<Invoke Class="IRISConfig.Installer" Method="AddWFUser" CheckStatus="true">
		<Arg name="pNamespace" Value="${Namespace}"/>
		<Arg name="pUserName" Value="SuperUser"/>
		<Arg name="pFullName" Value="Mr Anderson"/>
		<Arg name="pRoleName" Value="Application Specialist"/>
	</Invoke>
	
	<Log Text="Configuring schema registry entries for demo..." Level="0"/>
	<Invoke Class="IRISConfig.Installer" Method="ConfigSchemaRegistry" CheckStatus="true">
		<Arg name="pNamespace" Value="${Namespace}"/>
		<Arg name="SchemaRegistryURL" Value="http://schema-registry:8081"/>
	</Invoke>

	<Log Text="Disabling journal for demo..." Level="0"/>
	<Invoke Class="IRISConfig.Installer" Method="DisableJournalForDatabase" CheckStatus="true">
		<Arg name="pNamespace" Value="${Namespace}"/>
	</Invoke>

	<Log Text="Configuring Schema Key Map for demo..." Level="0"/>
	<Invoke Class="IRISConfig.Installer" Method="SchemaKeyMapConfig" CheckStatus="true">
		<Arg name="pNamespace" Value="${Namespace}"/>
	</Invoke>

	
</Manifest>
}

}
