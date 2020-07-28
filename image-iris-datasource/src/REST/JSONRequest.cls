Class REST.JSONRequest Extends (%Persistent, Ens.Util.MessageBodyMethods, %JSON.Adaptor)
{

Parameter %JSONIGNOREINVALIDFIELD As BOOLEAN = 1;

Method %GetContentType() As %String
{
	Quit "text/html"
}

Method %ShowContents(pZenOutput As %Boolean = 0)
{
    &html<
    <style>
        pre {outline: 1px solid #ccc; padding: 5px; margin: 5px; }
        .string { color: green; }
        .number { color: darkorange; }
        .boolean { color: blue; }
        .null { color: magenta; }
        .key { color: #d75f00; }
    </style>
    >
    Write "<script language=""javascript"">"

	Set tWriter = ##class(%JSON.Formatter).%New()
	Set tWriter.Indent = 1
    Do ..%JSONExportToString(.jsonString)
    Write "request = "
    Do tWriter.Format(jsonString)

    &js<
        function output(inp) {
            document.body.appendChild(document.createElement('pre')).innerHTML = inp;
        }

        function syntaxHighlight(json) {
            json = json.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
            return json.replace(/("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, function (match) {
                var cls = 'number';
                if (/^"/.test(match)) {
                    if (/:$/.test(match)) {
                        cls = 'key';
                    } else {
                        cls = 'string';
                    }
                } else if (/true|false/.test(match)) {
                    cls = 'boolean';
                } else if (/null/.test(match)) {
                    cls = 'null';
                }
                return '<span class="' + cls + '">' + match + '</span>';
            });
        }

        var str = JSON.stringify(request, null, 4);

        output(syntaxHighlight(str));

    >
    Write "</script>"
}

Storage Default
{
<Data name="JSONRequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^REST.JSONRequestD</DataLocation>
<DefaultData>JSONRequestDefaultData</DefaultData>
<IdLocation>^REST.JSONRequestD</IdLocation>
<IndexLocation>^REST.JSONRequestI</IndexLocation>
<StreamLocation>^REST.JSONRequestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
