Include Ensemble

/// 
Class SchemaNormalization.Process Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='SchemaNormalization.OriginalData' response='Ens.Response' height='2000' width='2000' >
<context>
<property name='NormalizedData' type='SchemaNormalization.NormalizedData' instantiate='0' />
<property name='Action' type='%String' initialexpression='"Normalize"' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='Message' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='2500' />
</parameters>
</property>

<property name='Transformation' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='500' />
</parameters>
</property>

</context>
<sequence xend='200' yend='700' >

	<while name='Try to normalize' condition='context.Action="Normalize"' xpos='470' ypos='400' xend='200' yend='800' >
	<scope xpos='200' ypos='250' xend='200' yend='700' >
	<code name='Normalize' xpos='200' ypos='350' >
	<![CDATA[ 
		
		Set schemaKeyMapConfig = ##class(SchemaNormalization.SchemaKeyMapConfig).OriginalSchemaClassNameIndexOpen(request.%ClassName(1))
		If schemaKeyMapConfig=""
		{
			Set status = $$$ERROR(5001,"Schema key map config entry for '"_request.%ClassName(1)_"' not found.")
			Quit
		}

		Set status = schemaKeyMapConfig.CreateOrUpdateNormalizedObject(request, .normalizedRequest)
		If $$$ISERR(status) Quit
		
		Set normalizedRequest.%SessionId = process.%SessionId

		Set status = normalizedRequest.%Save()
		If $$$ISERR(status) 
		{
			Set tObjectDump=normalizedRequest.GetObjectDump()
			$$$LOGERROR(tObjectDump)

			Set status2 = request.ChangeStatus("ERR")
			If $$$ISERR(status2) Set status = $System.Status.AppendStatus(status, status2)
			Quit
		}
		
		Set context.NormalizedData=normalizedRequest

		Set status = request.ChangeStatus("DONE")
	]]>
	</code>
	<assign name="Done" property="context.Action" value="&quot;Done&quot;" action="set" xpos='200' ypos='450' />
	<faulthandlers>
	<catchall name='Normalization error' xpos='200' ypos='550' xend='200' yend='1200' >
	<trace name='Normalization problem' value='"Normalization problem"' xpos='200' ypos='250' />
	<assign name="Compose Message" property="context.Message" value="&quot;The following problem occurred when trying to process session &quot;_process.%SessionId_&quot;: &quot;_$System.Status.GetOneStatusText(..%Context.%LastError)" action="set" xpos='200' ypos='350' />
	<alert value='context.Message' xpos='200' ypos='450' />
	<call name='New Workflow Task' target='Application Specialist' async='1' xpos='200' ypos='550' >
	<annotation><![CDATA[Human Intervention Required
	Sending request to an Application Specialist]]></annotation>
	<request type='EnsLib.Workflow.TaskRequest' >
	<assign property="callrequest.%Actions" value="&quot;Retry,Discard&quot;" action="set" />
	<assign property="callrequest.%Subject" value="&quot;Normalization Problem&quot;" action="set" />
	<assign property="callrequest.%Message" value="context.Message" action="set" />
	</request>
	<response type='EnsLib.Workflow.TaskResponse' >
	<assign property="context.Action" value="callresponse.%Action" action="set" />
	</response>
	</call>
	<sync name='Wait for human intervention' calls='New Workflow Task' type='all' xpos='200' ypos='650' />
	<if name='Retry?' condition='context.Action="Retry"' xpos='200' ypos='750' xend='200' yend='1100' >
	<true>
	<trace name='Specialist asked to retry' value='"Specialist asked to retry"' xpos='470' ypos='900' />
	<assign name="Retry normalization" property="context.Action" value="&quot;Normalize&quot;" action="set" xpos='470' ypos='1000' />
	</true>
	<false>
	<trace name='Specialist asked to discard' value='"Specialist asked to discard"' xpos='200' ypos='900' />
	<assign name='Discarding' property='status' value='request.ChangeStatus("DISC")'/>
	</false>
	</if>
	</catchall>
	</faulthandlers>
	</scope>
	</while>

	<call name='Trace' target='Trace Operation' async='1' xpos='200' ypos='600' >
		<request type='SchemaNormalization.NormalizedData' >
			<assign property="callrequest" value="context.NormalizedData" action="set" />
		</request>
	</call>
</sequence>
</process>
}

}
