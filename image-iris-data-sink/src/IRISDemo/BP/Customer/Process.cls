/// 
Class IRISDemo.BP.Customer.Process Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='DataSink.OriginalData' response='Ens.Response' height='2000' width='2000' >
<context>
<property name='NormalizedData' type='%Persistent' instantiate='0' />
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

<assign name="Get Transformation Class" property="context.Transformation" value='$parameter(request,"%DTL")' action="set" xpos='200' ypos='450' />
<if name='Normalize?' condition='context.Transformation&apos;=""' xpos='200' ypos='250' xend='200' yend='500' >
<true>
<while name='Try to normalize' condition='context.Action="Normalize"' xpos='470' ypos='400' xend='200' yend='800' >
<scope xpos='200' ypos='250' xend='200' yend='700' >
<code name='Transform' xpos='200' ypos='350' >
<![CDATA[ 
	











	/*
	 If I use a <transform> activity with indirection (@$parameter(request,"%DTL")), and 
	 assign the returned object to the context, and an error is produced when the context is
	 saved because the returned object has, say, missing properties, IRIS will only see this error
	 too late and the scope we defined will not be able to help us to deal with this fault.
	 
	 So, in order to avoid this bug, we need to call the transformation from a <code> activity instead.
	 And try to save the returned object before assigning it to the context and returning. If we can't
	 save it, we must assign the error to the status variable and leave the context alone. This way
	 the <scope> will capture the problem and take us to the <catchall> activity. 
	*/ 
	
	Set status = $classmethod(context.Transformation, "Transform", request, .normalizedRequest)
	If $$$ISERR(status) Quit
	
	Set normalizedRequest.%DTL=context.Transformation
	Set normalizedRequest.%SessionId = process.%SessionId

	Set status = normalizedRequest.%Save()
	If $$$ISERR(status) Quit
	
	Set context.NormalizedData=normalizedRequest
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
</false>
</if>
</catchall>
</faulthandlers>
</scope>
</while>
</true>
<false>
<assign name="Use same message" property="context.NormalizedData" value="request" action="set" xpos='200' ypos='400' />
</false>
</if>
<call name='Trace' target='Trace Operation' async='1' xpos='200' ypos='600' >
<request type='DataSink.CanonicalData' >
<assign property="callrequest" value="context.NormalizedData" action="set" />
</request>
</call>
</sequence>
</process>
}

}
