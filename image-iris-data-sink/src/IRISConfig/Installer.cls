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
	
	<Log Text="Loading US states data..." Level="0"/>
	<Invoke Class="IRISConfig.Installer" Method="LoadUSStates" CheckStatus="true">
		<Arg name="pNamespace" Value="${Namespace}"/>
	</Invoke>
		
	<Invoke Class="IRISConfig.Installer" Method="AddWFRole" CheckStatus="true">
		<Arg name="pNamespace" Value="${Namespace}"/>
		<Arg name="pRoleName" Value="Application Specialist"/>
	</Invoke>
		
	<Invoke Class="IRISConfig.Installer" Method="AddWFUser" CheckStatus="true">
		<Arg name="pNamespace" Value="${Namespace}"/>
		<Arg name="pUserName" Value="SuperUser"/>
		<Arg name="pFullName" Value="Mr Anderson"/>
		<Arg name="pRoleName" Value="Application Specialist"/>
	</Invoke>
	
</Manifest>
}
}