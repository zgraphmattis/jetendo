<cfoutput>  
<cffunction name="OnError" localmode="modern" access="public" returntype="void" output="true" hint="Fires when an exception occures that is not caught by a try/catch.">
	<cfargument name="Exception" type="any" required="true" />
	<cfargument name="EventName" type="string" required="false" default="" />
	<cfscript>
	var cferror=0;
	var notifydev=0;
	var zErrorTempURL=0;
	var savedlistingfix=0;
	var cferror=0;
	var i=0;
	var funcname=0;
	var pos=0;
	var runtime=0;
	var freememory=0;
	var totalmemory=0;
	var maxmemory=0;
	var percentFreeAllocated=0;
	var cfquery=0;
	var quc=0;
	var developerflagged=0;
	var testserverflagged=0;
	var zallrequestvars=0;
	var supportedformats=0;
	currentMinute=timeformat(now(), "m");
	if(not structkeyexists(application, 'zErrorMinuteTime')){
		application.zErrorMinuteTime=currentMinute;
		application.zErrorMinuteCount=0;
	}
	if(currentMinute NEQ application.zErrorMinuteTime){
		application.zErrorMinuteCount=0;
		application.zErrorMinuteTime=currentMinute;
	}
	application.zErrorMinuteCount++;
	
	if(structkeyexists(form, 'zpassword')){
		form.zpassword='Password removed for security';
	}
	if(structkeyexists(form, 'z_tmppassword2')){
		form.z_tmppassword2='Password removed for security';
	}
	</cfscript>
	<cftry>
	<cfscript>
	request.zos.inOnErrorFunction=true;
	</cfscript>
	<cfif structkeyexists(form, 'zab')>
	<cfif structkeyexists(arguments.exception, 'message') and arguments.exception.message CONTAINS "timeout"><cfheader statuscode="500" statustext="Internal Server Error">timeout<cfabort></cfif>
	<cfsavecontent variable="theDump"><cfdump var="#exception#"></cfsavecontent>
	<cffile action="append" file="#request.zos.zcoreRootPrivatePath#_cache/error-log.txt" output="#now()# | #application.applicationname# | #arguments.eventName#: #arguments.exception.message#" addnewline="yes"><!--- #chr(10)##theDump# --->
	<cfabort>
	</cfif> 
	<cfscript>
	cferror=arguments.exception;
	</cfscript>
	<!-- Error Handler Forces All Tags Closed with this code below -->
	</table></table></table></table></table></table></table></table></table></table></div></div></div></div></div></div></div></div></div></div>
	<!-- Begin Error -->
	<hr style="clear:both;" />
	<table  style="border-spacing:0px; width:100%; "><tr><td style="padding:10px; background-color:##FFF !important;"><h1>Error in Application.cfc event: #arguments.eventName#</h1>
	<cfif structkeyexists(form, request.zos.urlRoutingParameter) EQ false>
	#cferror.message#
	<cfdump var="#cferror#">
	<cfelse>
	<cftry>
	<!--- to force an error to be logged even for a developer set: 
	request.zForceErrorEmail=true;
	--->
	
	<cfscript>
	if(isDefined('local') and structkeyexists(local, 'cferror')){
		variables._handleError(local.cferror);
	}else if(isDefined('local') and structkeyexists(local, 'cfcatch')){
		variables._handleError(local.cfcatch);
	}else if(isDefined('arguments') and structkeyexists(variables, 'cferror')){
		variables._handleError(arguments.cferror);
	}else if(isDefined('arguments') and structkeyexists(arguments, 'cfcatch')){
		variables._handleError(variables.cfcatch);
	}else if(structkeyexists(variables, 'cferror')){
		variables._handleError(variables.cferror);
	}else if(structkeyexists(variables, 'cfcatch')){
		variables._handleError(variables.cfcatch);
	}else{
		variables._handleError({});
	}
	if(isdefined('application.zcore.functions.zabort')){
		application.zcore.functions.zabort();
	}
	</cfscript>
	<cfcatch type="any">
	<cfif isDefined('arguments.exception.message') and arguments.exception.message CONTAINS "timeout">
	<cffile action="append" file="#expandpath('/zcorecachemapping/')#error-log.txt" output="#arguments.eventName#: #arguments.exception.message#" addnewline="yes">
	Script Timeout<cfabort>
	</cfif>
	<cfsavecontent variable="theError">
	<h2>Normal error handler failed.</h2>
	<cfdump var="#cfcatch#">
	
	<h2>The original error</h2>
	<cfdump var="#arguments.exception#">
	</cfsavecontent>
	#theError# 
	<cfif request.zos.isDeveloper EQ false>
	<cftry>
		<cfif application.zErrorMinuteCount LTE request.zos.errorEmailAlertsPerMinute>
			<cfmail from="#request.zos.developerEmailFrom#" to="#request.zos.developerEmailTo#" subject="#request.zos.cgi.http_host# has an error" type="html">
			#application.zcore.functions.zHTMLDoctype()#
			<head>
			<meta charset="utf-8" />
			<title>Error</title>
			</head>
			
			<body>
			<h1>Error in Application.cfc event: #arguments.eventName#</h1>
			<cfdump var="#cgi#">
			<br />
			<br />
			
			#theError#
			<cfif application.zErrorMinuteCount EQ request.zos.errorEmailAlertsPerMinute>
				<br /><br />Error alert limit threshold of #request.zos.errorEmailAlertsPerMinute# alerts per minute was reached.  Further errors are only visible in server manager.
			</cfif>
			</body>
			</html>
			</cfmail> 
		</cfif>
	<cfcatch type="any">
	<h2>Rethrew Error</h2>
	<cfrethrow>
	</cfcatch>
	</cftry>
	<cfelse>
	<h2>Rethrew Error</h2>
	<cfrethrow>
	</cfif>
	<cfabort>
	</cfcatch>
	</cftry>
	</cfif>
	<cfcatch type="any">
	<cfheader statuscode="500" statustext="Internal Server Error">
	<cfdump var="#cfcatch#">
	<cfdump var="#arguments#">
	<cfabort>
	</cfcatch>
	</cftry>
	<cfreturn />
</cffunction>
<cffunction name="_zTempEscape" returntype="any" output="false">
	<cfargument name="string" type="string" required="yes">
	<cfreturn replace(replace(arguments.string, "\", "\\", "ALL"), "'", "''", "ALL")>
</cffunction>
<cffunction name="_zTempErrorHandlerDump" output="true" returntype="any">
	<cfargument name="varName" type="any" required="yes">
	<cfargument name="label" type="string" required="no" default="">
	<cfargument name="nodumpcode" type="boolean" required="no" default="#false#">
	<cfargument name="hideKeys" type="string" required="no" default="">
    <cftry>
	<cfdump var="#arguments.varName#" hide="#arguments.hideKeys#" showudfs="no" format="html" label="#arguments.label#">
    <cfcatch type="any"></cfcatch>
    </cftry>
</cffunction>

<cffunction name="_handleError">
	<cfargument name="cferror" type="struct" required="yes">
	 <cfscript>
	var percentAllocated=0;
	var newStackTrace=0;
	var p1=0;
	var endTag=0;
	var p2=0;
	var notifyDev	=0;
	var zErrorTempURL	=0;
	var savedListingFix	=0;
	var zErrorTempURL	=0;
	var i	=0;
	var funcname	=0;
	var pos	=0;
	var runtime	=0;
	var freeMemory	=0;
	var totalMemory	=0;
	var maxMemory	=0;
	var saveSQL=0;
	var qInsertError=0;
	var qid=0;
	var newId=0;
	var developerFlagged	=0;
	var percentFreeAllocated=0;
	var quc	=0;
	var cfquery	=0;
	var testServerFlagged=0;
	var zAllRequestVars=0;
	if(isDefined('request.zos') and isDefined('Server.#request.zos.zcoremapping#.runningScriptStruct') and isDefined('request.zos.runningScriptIndex')){
		structdelete(Server[request.zos.zcoremapping].runningScriptStruct,'r'&request.zos.runningScriptIndex);
	}
	if(structkeyexists(request,'cgi_script_name') EQ false){
		request.cgi_script_name=cgi.SCRIPT_NAME;	
	} 
	if(isDefined('request.zos') EQ false){
		request.zos=structnew();
	}
	 if(isDefined('request.zos.zcoremapping') EQ false){
		 request.zos.zcoremapping="";
	 }
	if(isDefined('request.zos.CGI') EQ false){
		request.zos.CGI=duplicate(cgi);
	}
	if(isDefined('request.zos.alternatesecureport') and request.zos.CGI.SERVER_PORT EQ request.zos.alternatesecureport){
		request.zos.CGI.SERVER_PORT=443;
	}else{
		request.zos.CGI.SERVER_PORT=80;
	}
	request.zRequestData=getHTTPRequestData();
				
	if(isdefined('request.zRequestData.headers.remote_addr')){
		request.zOS.CGI.remote_addr=request.zRequestData.headers.remote_addr;
	}
	if(isdefined('request.zRequestData.headers.http_host')){
		request.zOS.CGI.http_host=request.zRequestData.headers.http_host;
	}else{
		request.zOS.CGI.http_host=cgi.HTTP_HOST;
	}
	</cfscript>
	<cfif isDefined('arguments.cferror') EQ false and isDefined('arguments.cfcatch')>
		<cfscript>
		arguments.cferror=arguments.cfcatch;
		arguments.cferror.rootcause=duplicate(arguments.cfcatch);
		</cfscript>
	</cfif>
	<cfif isDefined('error') EQ false and isDefined('variables.catch')>
		<cfscript>
		variables.error=evaluate('variables.catch');
		variables.error.rootcause=duplicate(evaluate('variables.catch'));
		</cfscript>
	</cfif>
	<cftry>
	<cfheader statuscode="500" statustext="Internal Server Error">
	<cfcatch type="any">
	<!--- already output headers! ---->
	</cfcatch>
	</cftry>
	<cfif findnocase('[PLM=0] GET', request.cgi_script_name) NEQ 0>
		Access Denied<cfabort>
	</cfif>

<cfset notifyDev=true>
<cfsavecontent variable="zErrorTempURL"><cfif request.zos.CGI.SERVER_PORT EQ "80">http://<cfelse>https://</cfif>#listgetat(request.zOS.CGI.http_host,1,":")#<cfif structkeyexists(request.zos, 'originalURL')>#request.zos.originalURL#<cfelseif structkeyexists(form, '_zsa3_path')>#form._zsa3_path#?#replace(CGI.QUERY_STRING,"_zsa3_path=","_zsa3_pathdisabled=","all")#<cfelse>#request.cgi_script_name#<cfif structkeyexists(request.zos, 'CGI') and request.zos.cgi.query_string NEQ "">?#request.zos.cgi.query_string#<cfelseif CGI.QUERY_STRING NEQ "">?#CGI.QUERY_STRING#</cfif></cfif></cfsavecontent>

<cfsavecontent variable="zAllRequestVars">
<cfif isDefined('arguments.cferror.message') and (arguments.cferror.message CONTAINS 'This message is usually caused by a problem in the expressions structure' or arguments.cferror.message CONTAINS 'Your expression might be missing an ending "##" ')>
<b>You probably are missing one side of an expression.  This is commonly a missing brace { }, parentheses ( ) pound sign ## or some other part of one of your expressions.</b>
<br><br>
</cfif>
<cfscript>
savedListingFix=replaceNoCase(replaceNocase(replaceNoCase(replaceNocase(zErrorTempURL,'/"/property/saved-property','/property/saved-property'),'/%22/property/saved-property/','/property/saved-property'),'/""/property/saved-property','/property/saved-property'),'/%22%22/property/saved-property/','/property/saved-property');
</cfscript>
<cfif savedListingFix NEQ zErrorTempURL>
	<script type="text/javascript">
	/* <![CDATA[ */ window.location.href='#savedListingFix#'; /* ]]> */
	</script>
	<cfabort>
</cfif>
<cfscript>
local.curMessage="";
if(isdefined('arguments.cferror.message') and arguments.cferror.message EQ ""){
	if(isdefined('arguments.cferror.detail')){
		local.curMessage=arguments.cferror.detail;
	}
}else{
	local.curMessage=arguments.cferror.message;
}
</cfscript> 
<cfif isDefined('Request.zOS.customError')>
	#local.curMessage#
	<cfif findnocase("The filename, directory name, or volume label syntax is incorrect null", local.curMessage) NEQ 0>
		<cfset notifyDev=false>
	</cfif>
<cfelse>
	<table cellpadding="5" cellspacing="0" border="0" class="table-list" width="100%"><tr><td><span class="medium">CFML Error</span></td></tr></table>
	<table cellpadding="20" cellspacing="0" border="0" width="100%" class="table-list"><tr><td style="padding:20px;">
	<cfif local.curMessage CONTAINS "Implicit Variable Access Detected">
		Implicit Variable Access Detected
	<cfelse>
		<cfif isDefined('request.zos.prependedErrorContent')>#request.zos.prependedErrorContent#</cfif>#local.curMessage#    
	</cfif>
	</td></tr></table>
</cfif> 

<cfif isDefined('request.zArrErrorMessages')>
	<table cellpadding="5" cellspacing="0" border="0" class="table-list" width="100%"><tr><td><span class="medium">#request.zos.zcoremapping# Additional Error Messages</span></td></tr></table>
	<table cellpadding="20" cellspacing="0" border="0" width="100%" class="table-shadow"><tr><td>
    These error messages should help isolate your problem:<br /><br />
	#arraytolist(request.zArrErrorMessages,"<br />")#
    </td></tr></table>
</cfif>
<cfif isDefined('arguments.cferror')>
    <cfif structkeyexists(arguments.cferror,'rootcause') EQ false>
    	<cfset arguments.cferror.rootcause=structnew()>
	<cfif structkeyexists(arguments.cferror,'tagcontext') >
        <cfset arguments.cferror.rootcause.tagcontext=arguments.cferror.tagcontext>
	<cfelse>
        <cfset arguments.cferror.rootcause.tagcontext=[]>
	</cfif>
    </cfif>
    
    <cfif structkeyexists(arguments.cferror, 'stacktrace')>
		<cfscript>
        endTag="<!-- JetendoCustomErrorEnd -->";
        p1=find("<!-- JetendoCustomError -->", arguments.cferror.stacktrace);
        p2=find(endTag, arguments.cferror.stacktrace);
        newStackTrace=arguments.cferror.stacktrace;
        if(p1 NEQ 0 and p2 NEQ 0){
            newStackTrace=removeChars(newStackTrace, p1, (p2+len(endTag))-p1);
        }
        </cfscript>
    </cfif>
<table cellpadding="20" cellspacing="0" border="0" class="table-white" width="100%">
	<tr><td>
<table cellpadding="2" cellspacing="0" border="0" class="tiny">
	<tr><td class="normal-bold" colspan="4">
	Line Numbers <!--- (Click file to debug compilation errors visually) --->
	</td></tr>
	<cfif ArrayLen(arguments.cferror.rootcause.tagcontext) EQ 0>
	<tr>
	<td>Unknown</td>
	<td><!--- <a href="#Request.zOS.globals.serverDomain#/apps/apps/validateCF.cfm?filePath=#urlencodedformat(cgi.PATH_TRANSLATED)#" target="_blank" style="text-decoration:underline;"> --->#cgi.PATH_TRANSLATED#<!--- </a> ---></td>
	<td>&nbsp;</td></tr>
	</cfif>
	<cfloop from="1" to="#ArrayLen(arguments.cferror.rootcause.tagcontext)#" index="i">
    <cfif isDefined('newStackTrace') or i NEQ 1>
        <cftry>
			<cfscript>
            funcname="";
            pos=find("$func",arguments.cferror.rootcause.tagcontext[i].raw_trace);
            if(pos neq 0){
                pos2=find(".",arguments.cferror.rootcause.tagcontext[i].raw_trace,pos);
                funcname=lcase(mid(arguments.cferror.rootcause.tagcontext[i].raw_trace,pos+5,(pos2-pos)-5))&'()';
            }
            </cfscript>
            <cfif funcname NEQ 'fail()' or (replace(right(arguments.cferror.rootcause.tagcontext[i].template,len('#request.zos.zcoremapping#\com\zos\template.cfc')),'\','/','all') NEQ '#request.zos.zcoremapping#/com/zos/template.cfc' and replace(right(arguments.cferror.rootcause.tagcontext[i].template,len('#request.zos.zcoremapping#/com/zos/return.cfc')),"\","/","all") NEQ '#request.zos.zcoremapping#/com/zos/return.cfc')>
            <tr>
            <td>#arguments.cferror.rootcause.tagcontext[i].line#</td>
            <td>#arguments.cferror.rootcause.tagcontext[i].template#</td>
            <td>#funcname#</td>
            <td>#arguments.cferror.rootcause.tagcontext[i].id#</td></tr>
            </cfif>
            <cfcatch type="any">
            </cfcatch>
        </cftry>
    </cfif>
	</cfloop>
	</table>
	</td></tr>
<tr id="zErrorRepostErrorId"><td>
<h2>Re-visit url with posted form variables</h2>
<p>Warning: all data will be re-submitted.  There may be duplicate database errors or other undesirable conditions.  Make sure you want to do this. This is added as a convenience to help reproduce errors more quickly that had posted values that don't fit in the URL.</p>
<cfscript>
arrURL=[];
arrForm=[];
totalLength=0;
for(i in form){
	if(isSimpleValue(form[i]) and i NEQ "zFPE" and i NEQ request.zos.urlRoutingParameter){
		currentLength=len(form[i]);
		totalLength+=currentLength;
		if(totalLength GT 1200 or currentLength GT 100){
			arrayAppend(arrForm, '<input type="hidden" name="#i#" value="#htmleditformat(form[i])#" />');
		}else{
			arrayAppend(arrURL, i&"="&urlencodedformat(form[i]));
		}
	}
}
</cfscript>
<form action="#request.zos.currentHostName##request.zos.originalURL#?#arrayToList(arrURL, '&')#" target="_blank" method="post">
#arrayToList(arrForm, chr(10))#
<input type="submit" name="submit1" value="Submit" />
</form>
</td></tr></table>
<cfif isDefined('arguments.cferror.rootcause.sql')>
<table cellpadding="20" cellspacing="0" border="0" class="table-list" width="100%">
<tr>
<td><b>The following SQL statement generated an error:</b><br><br>
#arguments.cferror.rootcause.sql#</td>
</tr>
</table>
</cfif>
    <cfif isDefined('newStackTrace')>
	<table cellpadding="5" cellspacing="0" border="0" class="table-list" width="100%"><tr><td><span class="medium">Java Stacktrace</span></td></tr></table>
<table cellpadding="20" cellspacing="0" border="0" class="table-white" width="100%">
	<tr><td style="line-height:18px; font-size:11px;">#replace(newStackTrace, '	at ','<br />at ', 'all')#
    </td></tr></table>
    </cfif>
</cfif>
<table cellpadding="5" cellspacing="0" border="0" class="small" width="100%">
		<tr>
		<td>
If a non-developer visits this page, they will see the error template and the error will be logged in the Server Manager.<br><br>
All components, functions, queries were removed from the variable output below.<br><br>

<cfscript>
StructDelete(request, 'cfdumpinited');
</cfscript>

<cfif StructCount(form) NEQ 0>
	<h2>FORM Variables</h2>
	<cfscript>
	for(i in form){
		if(isSimpleValue(form[i])){
			writeoutput(i&": "&form[i]&"<br />");
		}else{
			echo(i&":");
			writedump(form[i]);
			echo("<br>");
		}
	}
	</cfscript>
	<br><br>
</cfif>
 	<cfset developerFlagged=false>
 <cfif isDefined('request.zos.globals.serverId')>
 <cfquery name="quc" datasource="#request.zos.zcoreDatasource#">
 SELECT * from user where user_active = '1' 
 <cfif isDefined('session.zos.user.id')>
 and user_id = '#session.zos.user.id#' 
 </cfif>
 and user_updated_ip = '#request.zos.cgi.remote_addr#' and 
 user_ip_blocked = '0' 
 and user_intranet_administrator='1' and 
 site_id = '#request.zos.globals.serverId#' 
 </cfquery>
 <cfif quc.recordcount NEQ 0>
 	<cfset developerFlagged=true>
 </cfif>
 </cfif>
 <cfif isDefined('request.zos.isDeveloper')>
 	<cfset developerFlagged=request.zos.isDeveloper>
 </cfif>
 
 
<cfset testServerFlagged=false>
<cfif isDefined('request.zos.testDomain') EQ false>
	<cfdump var="#arguments.cferror#">
    <cfabort>
</cfif>
<cfif request.zOS.CGI.http_host contains '.'&request.zos.testDomain>
	<!--- now allowing test server to show debug always --->
<!--- 	<cfset StructInsert(request.zos.adminIpStruct, request.zos.cgi.remote_addr,false,true)> --->
	<cfset developerFlagged=true>
    <cfset testServerFlagged=true>
</cfif><!---  --->
<cfif cgi.HTTP_USER_AGENT contains 'railo' or cgi.HTTP_USER_AGENT EQ 'CFSCHEDULE' or cgi.HTTP_USER_AGENT EQ 'Coldfusion'>
 	<cfset developerFlagged=false>
</cfif>

<cfif isDefined('request.zautoformsql')>
<h2>Request.zAutoFormSQL</h2>
<cfdump var="#request.zautoformsql#"><br><br>
</cfif>
<cfif isDefined('cookie') and StructCount(cookie) NEQ 0>
<h2>COOKIE Variables</h2>
<cfscript>
for(i in cookie){
	writeoutput(i&": "&cookie[i]&"<br />");
}
</cfscript>
	<br><br>
</cfif>

<cfscript>
if(isDefined('application.zcore.abusiveIPStruct')){
	if(isDefined('arguments.cferror.message') and arguments.cferror.message CONTAINS 'run into a timeout'){
		for(i in application.zcore.abusiveIPStruct){
			writeoutput(structcount(application.zcore.abusiveIPStruct[i])&' ips in abusiveIPStruct<br />');
		}
		//writedump(application.zcore.abusiveIPStruct);
	}
}
if(isDefined('request.zos.arrRunTime')){
	writeoutput('<h2>Script Run Time Measurements</h2>');
	arrayprepend(request.zos.arrRunTime, {time:request.zos.startTime, name:'Application.cfc onCoreRequest Start'});
	for(i=2;i LTE arraylen(request.zos.arrRunTime);i++){
		writeoutput(((request.zos.arrRunTime[i].time-request.zos.arrRunTime[i-1].time)/1000000000)&' seconds | '&request.zos.arrRunTime[i].name&'<br />');	
	}
	echo('<br /><br />');
}
</cfscript>
<cfif isDefined('CGI')>
<h2>CGI Variables</h2>
<cfscript>
if(isDefined('request.zos.cgi')){
	for(i in request.zos.cgi){
		writeoutput(i&": "&request.zos.cgi[i]&"<br />");
	}
}else{
	for(i in cgi){
		writeoutput(i&": "&cgi[i]&"<br />");
	}
}
</cfscript>
	<br><br>
</cfif>
</td>
</tr>
</table></td></tr></table>
</cfsavecontent>

<cfif structkeyexists(form,'zFPE')><!---  and not request.zos.istestserver> --->
	<cfset developerFlagged=false>
</cfif>
<cfset zAllRequestVars = rereplacenocase(zAllRequestVars, '<script language="JavaScript">(.*)</script>', '', "ALL")>
<cfset zAllRequestVars = rereplacenocase(zAllRequestVars, '<style>(.*)</style>', '', "ALL")>
<cfset zAllRequestVars = replace(zAllRequestVars, chr(10), "", "ALL")>
<cfset zAllRequestVars = replace(zAllRequestVars, chr(13), "", "ALL")>

<cfscript>
newId=0;
</cfscript>

<cfif structkeyexists(request.zos,'adminIpStruct') EQ false or (isDefined('request.zForceErrorEmail') EQ false and structkeyexists(request.zos.adminIpStruct, request.zos.cgi.remote_addr) and request.zos.adminIpStruct[request.zos.cgi.remote_addr] EQ false and (isDefined('Request.zOS.globals.debugEnabled') EQ false or Request.zOS.globals.debugEnabled) and developerFlagged)>
	#application.zcore.functions.zHTMLDoctype()#
	<head><title>Development Error</title>
		<link href="/z/a/stylesheets/style.css" rel="stylesheet" type="text/css">
	</head>
	<body><!--- 
	<table cellpadding="10" cellspacing="0" border="0" class="small" width="100%">
	<tr class="table-white"><td><span class="tiny">Development Error</span></td></tr>
	</table> --->
		
		#zAllRequestVars#
	<script type="text/javascript">
	/* <![CDATA[ */
	var d=document.getElementById("zErrorRepostErrorId");
	if(typeof d != "undefined" && d != null){
		d.style.display="none";
	}
	/* ]]> */
	</script>
	</body>
	</html>
	<cfset request.developerError = true>
<cfelseif structkeyexists(request, 'zForceErrorEmail') or request.cgi_script_name DOES NOT CONTAIN '/errors/script.cfm'>
	<cfif notifyDev>
    	<cfsavecontent variable="saveSQL">
        INSERT INTO log SET
        log_host = '#variables._zTempEscape(request.zOS.CGI.http_host)#', 
        log_status = 'New', 
        log_type = 'error', 
        log_datetime = '#DateFormat(now(), "yyyy-mm-dd")# #TimeFormat(now(), "HH:mm:ss")#',
        log_title = '#variables._zTempEscape(zErrorTempURL)#',
        log_ip = '#variables._zTempEscape(request.zos.cgi.remote_addr)#', 
	log_user_agent='#variables._zTempEscape(request.zos.cgi.http_user_agent)#',
        log_message = '#variables._zTempEscape(zAllRequestVars)#' 
        </cfsavecontent>
        <cftry>
        <cfquery name="qInsertError" datasource="#Request.zOS.globals.serverDatasource#">
        #preserveSingleQuotes(saveSQL)#
        </cfquery>
        <cfquery name="qId" datasource="#Request.zOS.globals.serverDatasource#">
        SELECT last_insert_id() as id
        </cfquery>
        <cfscript>
		newId=qId.id;
		</cfscript>
        <cfcatch type="any"></cfcatch>
        </cftry>
    </cfif>
    
	<!--- true EQ server ip | false EQ user ip --->
	<cfif not structkeyexists(request, 'zForceErrorEmail') and structkeyexists(request.zos,'adminIpStruct') and (structkeyexists(request.zos.adminIpStruct, request.zos.cgi.remote_addr) and request.zos.adminIpStruct[request.zos.cgi.remote_addr])>
		<cfmail to="#Request.zOS.developerEmailTo#" from="#request.zos.developerEmailFrom#" subject="Connection Failure: #request.zOS.CGI.http_host# : CRITICAL PRIORITY" type="html">
		#application.zcore.functions.zHTMLDoctype()#
		<head><title>Connection Failure</title>
		<link href="<cfif testServerFlagged>#request.zOS.zcoreTestAdminDomain#<cfelse>#request.zOS.zcoreAdminDomain#</cfif>/z/a/stylesheets/style.css" rel="stylesheet" type="text/css" />
		</head>
		<body>
		<span class="medium">Connection Failure: #request.zos.CGI.HTTP_HOST#</span><br><br>
		Connection Failures result from the server trying to CFHTTP to a page on our server that generated an error.  It's extremely important to address these issues ASAP.<br><br>
		<cfif newId NEQ "0" and newID NEQ "">
			<a href="<cfif testServerFlagged>#request.zOS.zcoreTestAdminDomain#<cfelse>#request.zOS.zcoreAdminDomain#</cfif>/z/server-manager/admin/log/index?action=view&log_id=#newId#">Click here</a> to view detailed information on this error.<br><br>
		<cfelse>
			Failed to save error in database. Dumping to email instead:<br>
			
			log_host = '#(request.zos.CGI.HTTP_HOST)#'<br>
			log_datetime = '#DateFormat(now(), "yyyy-mm-dd")# #TimeFormat(now(), "HH:mm:ss")#'<br>
			log_title = '#(zErrorTempURL)#'<br>
			log_ip = '#(request.zos.cgi.remote_addr)#'<br>
			log_user_agent='#(request.zos.cgi.http_user_agent)#'<br>
			log_message = <br>
			#(zAllRequestVars)#<br>
		</cfif>
		You will have to login using an account with Server Administrator access..<br><br>
		User's IP: #request.zos.cgi.remote_addr# 
		
		</body>
		</html>
		</cfmail>CFMXConnectionFailure<cfabort>
	<cfelseif structkeyexists(request, 'zForceErrorEmail') or notifyDev>
		<cfif application.zErrorMinuteCount LTE request.zos.errorEmailAlertsPerMinute>
			<cfmail to="#request.zos.developerEmailTo#" from="#request.zos.developerEmailFrom#" subject="#request.zos.CGI.HTTP_HOST# has an error" type="html">
			#application.zcore.functions.zHTMLDoctype()#
			<head><title>Error</title>
			<link href="<cfif testServerFlagged>#request.zOS.zcoreTestAdminDomain#<cfelse>#request.zOS.zcoreAdminDomain#</cfif>/z/a/stylesheets/style.css" rel="stylesheet" type="text/css" />
			</head>
			<body>
			<span class="medium">Error on #request.zos.CGI.HTTP_HOST#</span><br><br>
			<cfif newID NEQ "" and newID NEQ "0">
				<a href="<cfif testServerFlagged>#request.zOS.zcoreTestAdminDomain#<cfelse>#request.zOS.zcoreAdminDomain#</cfif>/z/server-manager/admin/log/index?action=view&log_id=#newId#">Click here</a> to view detailed information on this error.<br><br>
			<cfelse>
				Failed to save error. Dumping to email instead:<br>
				
				log_host = '#request.zos.CGI.HTTP_HOST#'<br>
				log_datetime = '#DateFormat(now(), "yyyy-mm-dd")# #TimeFormat(now(), "HH:mm:ss")#'<br>
				log_title = '#zErrorTempURL#'<br>
				log_ip = '#(request.zos.cgi.remote_addr)#'<br>
				log_user_agent='#(request.zos.cgi.http_user_agent)#',
				log_message = <br>
				#(zAllRequestVars)#<br>
		    
			</cfif>
				You will have to login using an account with Server Administrator access..<br><br>
				User's IP: #request.zos.cgi.remote_addr#
				<cfif application.zErrorMinuteCount EQ request.zos.errorEmailAlertsPerMinute>
					<br /><br />Error alert limit threshold of #request.zos.errorEmailAlertsPerMinute# alerts per minute was reached.  Further errors are only visible in server manager.
				</cfif>
			</body>
			</html>
			</cfmail>
		</cfif>
	</cfif>
</cfif>
<cfif isDefined('request.zForceErrorEmail') or isDefined('request.developerError') EQ false>
#application.zcore.functions.zHTMLDoctype()#
<head>
<title>Sorry, this page has generated an error.</title>
<meta charset="utf-8" />
<META HTTP-EQUIV=Refresh CONTENT="25; URL=<cfif isDefined('Request.zOS.globals.domain')>#Request.zOS.globals.domain#<cfelse>http://#request.zos.CGI.HTTP_HOST#</cfif>">
<style type="text/css">
<!--
.style1 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 14pt;
	font-weight: bold;
}
.style2 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10pt;
}
-->
</style>
</head>
<body>
<p class="style1">Sorry, this page has generated an error.</p>
<p class="style2"><strong>The webmaster has been notified and will fix the problem as soon as possible.<br><br>

Click your browser's back button and try again or <cfif isDefined('Request.zOS.globals.domain')><a href="#Request.zOS.globals.domain#">click here</a><cfelse><a href="http://#request.zos.CGI.HTTP_HOST#">click here</a></cfif> to go to the home page.<br><br></strong></p>
</body>
</html>
</cfif>
</cffunction>
</cfoutput>