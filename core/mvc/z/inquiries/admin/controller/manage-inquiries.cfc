<cfcomponent>
<cfoutput> 
<cffunction name="init" localmode="modern" access="private" roles="member">
	<cfscript> 
	var db=request.zos.queryObject;
	var hCom=0;
	form.zPageId=application.zcore.functions.zso(form, 'zPageId');
	if(request.cgi_script_name CONTAINS "/z/inquiries/admin/manage-inquiries/"){
		hCom=createobject("component", "zcorerootmapping.com.app.inquiriesFunctions");
		hCom.displayHeader();
	}
	variables.isReservationSystem=false;
	</cfscript>
</cffunction>

<cffunction name="changeStatus" localmode="modern" access="remote" roles="member">
	<cfscript>
	var db=request.zos.queryObject;
	var qIn=0;
	variables.init();
	db.sql="UPDATE #db.table("inquiries", request.zos.zcoreDatasource)# inquiries 
	SET inquiries_status_id= #db.param(form.inquiries_status_id)# 
	WHERE inquiries_id= #db.param(form.inquiries_id)# and 
	site_id = #db.param(request.zos.globals.id)#";
	qIn=db.execute("qIn");
	application.zcore.status.setStatus(request.zsid,'Status Updated');
	application.zcore.functions.zRedirect('/z/inquiries/admin/manage-inquiries/index?zPageId=#form.zPageId#&zsid=#request.zsid#');
	</cfscript>
</cffunction>

<cffunction name="delete" localmode="modern" access="remote" roles="member">
	<cfscript>
	var db=request.zos.queryObject;
	var qCheck=0;
	variables.init();
	db.sql="SELECT * from #db.table("inquiries", request.zos.zcoreDatasource)# inquiries 
	WHERE inquiries_id=#db.param(form.inquiries_id)# and 
	site_id = #db.param(request.zos.globals.id)#";
	qCheck=db.execute("qCheck");
	if(qCheck.recordcount EQ 0){
		application.zcore.status.setStatus(Request.zsid, 'Inquiry no longer exists', false,true);
		application.zcore.functions.zRedirect('/z/inquiries/admin/manage-inquiries/index?zsid=#request.zsid#&zPageId=#form.zPageId#');
	}
	</cfscript>
	<cfif structkeyexists(form, 'confirm')>
		<cfscript>
		form.site_id=request.zos.globals.id;
		application.zcore.functions.zDeleteRecord('inquiries','inquiries_id,site_id',request.zos.zcoreDatasource);
		application.zcore.status.setStatus(Request.zsid, 'Inquiry deleted');
		application.zcore.functions.zRedirect('/z/inquiries/admin/manage-inquiries/index?zsid=#request.zsid#&zPageId=#form.zPageId#');
		</cfscript>
		<cfelse>
		<div style="font-size:14px; font-weight:bold; text-align:center; "> Are you sure you want to delete this inquiry?<br />
			<br />
			#qCheck.inquiries_first_name# #qCheck.inquiries_last_name# (#qcheck.inquiries_email#)<br />
			<br />
			<a href="/z/inquiries/admin/manage-inquiries/delete?confirm=1&amp;inquiries_id=#form.inquiries_id#&amp;zPageId=#form.zPageId#">Yes</a>&nbsp;&nbsp;&nbsp;
			<a href="/z/inquiries/admin/manage-inquiries/index?zPageId=#form.zPageId#">No</a> </div>
	</cfif>
</cffunction>

<cffunction name="showAllFeedback" localmode="modern" access="remote" roles="member">
	<cfscript>
	var db=request.zos.queryObject;
	var qFeedback=0;
	var searchNav=0;
	var searchStruct=0;
	var qFeedbackCount=0;
	variables.init();
	if(structkeyexists(request.zos.userSession.groupAccess, "administrator") EQ false and structkeyexists(request.zos.userSession.groupAccess, "homeowner") eq false and structkeyexists(request.zos.userSession.groupAccess, "manager") eq false){
		application.zcore.status.setStatus(request.zsid,"Access denied.");
		application.zcore.functions.zRedirect("/member/?zsid=#request.zsid#");	
	}
	form.zPageId3=application.zcore.functions.zso(form, 'zPageId3');
	form.zIndex = application.zcore.status.getField(form.zPageId3, "zIndex", 1, true);
	application.zcore.functions.zStatusHandler(request.zsid);
	</cfscript>
	<h2>All Feedback</h2>
	<table  style="width:100%; border-spacing:0px;" class="table-white">
		<form action="/z/inquiries/admin/manage-inquiries/showAllFeedback" method="get" id="owner_lookup_form">
			<tr>
				<td>Type a name or phrase
					<input type="text" name="searchtext" value="#application.zcore.functions.zso(form, 'searchtext')#" size="20" maxchars="10" />
					<button type="submit" name="searchForm" value="Search">Search</button>
					<button type="button" name="searchForm2" value="Clear" onclick="window.location.href='/z/inquiries/admin/manage-inquiries/showallfeedback';">Clear</button>
					<input type="hidden" name="zIndex" value="1" />
					<input type="hidden" name="zPageId3" value="#form.zPageId3#" /></td>
			</tr>
		</form>
	</table>
	<cfsavecontent variable="db.sql"> 
	SELECT count(inquiries.inquiries_id) count 
	from #db.table("inquiries", request.zos.zcoreDatasource)# inquiries, 
	#db.table("inquiries_feedback", request.zos.zcoreDatasource)# inquiries_feedback
	WHERE 
	inquiries.inquiries_id = inquiries_feedback.inquiries_id and
	<cfif trim(application.zcore.functions.zso(form, 'searchtext')) NEQ ''>
		(inquiries_feedback_comments LIKE #db.param('%#form.searchtext#%')# or 
		inquiries_feedback_subject LIKE #db.param('%#form.searchtext#%')# or 
		concat(inquiries_first_name,#db.param(' ')#,inquiries_last_name) LIKE #db.param('%#form.searchtext#%')# or 
		inquiries_email LIKE #db.param('%#form.searchtext#%')#) and
	</cfif>
	inquiries.site_id = #db.param(request.zos.globals.id)# and 
	inquiries_feedback.site_id = inquiries.site_id </cfsavecontent>
	<cfscript>
	qFeedbackCount=db.execute("qFeedbackCount");
	</cfscript>
	<cfsavecontent variable="db.sql"> 
	SELECT * from #db.table("inquiries", request.zos.zcoreDatasource)# inquiries, 
	#db.table("inquiries_feedback", request.zos.zcoreDatasource)# inquiries_feedback 
	LEFT JOIN #db.table("user", request.zos.zcoreDatasource)# user ON 
	user.user_id = inquiries_feedback.user_id and 
	user.site_id = #db.trustedSQL(application.zcore.functions.zGetSiteIdTypeSQL("inquiries_feedback.user_id_siteIDType"))# WHERE 
	inquiries.inquiries_id = inquiries_feedback.inquiries_id and
	<cfif trim(application.zcore.functions.zso(form, 'searchtext')) NEQ ''>
		(inquiries_feedback_comments LIKE #db.param('%#form.searchtext#%')# or 
		inquiries_feedback_subject LIKE #db.param('%#form.searchtext#%')# or 
		concat(inquiries_first_name,#db.param(' ')#,inquiries_last_name) LIKE #db.param('%#form.searchtext#%')# or 
		inquiries_email LIKE #db.param('%#form.searchtext#%')#) and
	</cfif>
	inquiries.site_id = #db.param(request.zos.globals.id)# and 
	inquiries_feedback.site_id = inquiries.site_id 
	ORDER BY inquiries_feedback_datetime DESC 
	LIMIT #db.param((form.zIndex-1)*10)#,#db.param(10)# </cfsavecontent>
	<cfscript>
	qFeedback=db.execute("qFeedback");
	</cfscript>
	<cfif qFeedBack.recordcount NEQ 0>
		<hr />
		<cfscript>
		searchStruct = StructNew();
		searchStruct.count = qFeedbackCount.count;
		searchStruct.index = form.zIndex;
		searchStruct.showString = "Results ";
		searchStruct.url = "/z/inquiries/admin/manage-inquiries/index?zPageId=#form.zPageId#";
		searchStruct.indexName = "zIndex";
		searchStruct.buttons = 5;
		searchStruct.perpage = 10;
		if(searchStruct.count LTE searchStruct.perpage){
			searchNav="";
		}else{
			searchNav = '<table class="table-list" style="width:100%; border-spacing:0px;" ><tr><td style="padding:0px;">'&application.zcore.functions.zSearchResultsNav(searchStruct)&'</td></tr></table>';
		}
		</cfscript>
		#searchNav#<br />
		<table style="width:100%; border-spacing:0px;">
			<cfloop query="qFeedback">
				<cfif qFeedback.inquiries_feedback_subject NEQ ''>
					<tr>
						<td style="border:1px solid ##999999; background-color:##EFEFEF; ">#qFeedback.inquiries_feedback_subject#</td>
					</tr>
				</cfif>
				<cfif qFeedback.inquiries_feedback_comments NEQ ''>
					<tr>
						<td style=" border:1px solid ##999999;">#application.zcore.functions.zParagraphFormat(qFeedback.inquiries_feedback_comments)#</td>
					</tr>
				</cfif>
				<tr>
					<td style="border:1px solid ##999999; border-top:0px; ">By
						<cfif qFeedback.user_email EQ "">
							Unknown User
						<cfelse>
							<a href="mailto:#qFeedback.user_email#">#qFeedback.user_first_name# #qFeedback.user_last_name#</a>
						</cfif>
						on #DateFormat(qFeedback.inquiries_feedback_datetime, 'm/d/yyyy')&' at '&TimeFormat(qFeedback.inquiries_feedback_datetime, 'h:mm tt')# | 
						<a href="/z/inquiries/admin/feedback/view?inquiries_id=#qFeedback.inquiries_id#">View Lead</a> | 
						<a href="/z/inquiries/admin/feedback/deleteFeedback?inquiries_feedback_id=#qFeedback.inquiries_feedback_id#&amp;inquiries_id=#qFeedback.inquiries_id#">Delete</a></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</cfloop>
		</table>
		#searchNav#
	</cfif>
</cffunction>

<cffunction name="view" localmode="modern" access="remote" roles="member">
	<cfscript>
	var db=request.zos.queryObject;
	var qinquiry=0;
	var userGroupCom=0;
	var homeownerid=0;
	var excpt=0;
	var cfcatch=0;
	var viewIncludeCom=0;
	variables.init();
	</cfscript>
	<cfsavecontent variable="db.sql"> 
	SELECT * FROM (#db.table("inquiries", request.zos.zcoreDatasource)# inquiries, 
	#db.table("inquiries_status", request.zos.zcoreDatasource)# inquiries_status) 
	LEFT JOIN #db.table("inquiries_type", request.zos.zcoreDatasource)# inquiries_type ON 
	inquiries.inquiries_type_id = inquiries_type.inquiries_type_id and 
	inquiries_type.site_id IN (#db.param(0)#,#db.param(request.zos.globals.id)#) and 
	inquiries_type.site_id = #db.trustedSQL(application.zcore.functions.zGetSiteIdTypeSQL("inquiries.inquiries_type_id_siteIDType"))# 
	LEFT JOIN #db.table("user", request.zos.zcoreDatasource)# user ON 
	user.user_id = inquiries.user_id and user.site_id = #db.trustedSQL(application.zcore.functions.zGetSiteIdTypeSQL("inquiries.user_id_siteIDType"))# 
	WHERE inquiries.site_id = #db.param(request.zos.globals.id)# and 	
	inquiries.inquiries_status_id = inquiries_status.inquiries_status_id and 
	(( inquiries_id = #db.param(form.inquiries_id)# and 
	inquiries_parent_id = #db.param(0)# ) or 
	(inquiries_parent_id = #db.param(form.inquiries_id)# ))
	<cfif structkeyexists(request.zos.userSession.groupAccess, "administrator") EQ false and structkeyexists(request.zos.userSession.groupAccess, "homeowner") eq false and structkeyexists(request.zos.userSession.groupAccess, "manager") eq false>
		AND inquiries.user_id = #db.param(session.zOS.user.id)# and 
		user_id_siteIDType=#db.param(application.zcore.user.getSiteIdTypeFromLoggedOnUser())#
	</cfif>
	</cfsavecontent>
	<cfscript>
	qinquiry=db.execute("qinquiry");
	if(qinquiry.recordcount EQ 0){		
		request.zsid = application.zcore.status.setStatus(Request.zsid, "This inquiry doesn't exist.", false,true);
		application.zcore.functions.zRedirect("/z/inquiries/admin/manage-inquiries/index?zPageId=#form.zPageId#&zsid="&request.zsid);
	}
	userGroupCom = CreateObject("component","zcorerootmapping.com.user.user_group_admin");
	try{
		homeownerid=userGroupCom.getGroupId('homeowner',request.zos.globals.id);
	}catch(Any excpt){
		homeownerid=0;
	}
	</cfscript>
	<cfloop query="qinquiry">
		<h2 style="display:inline;">Inquiry Information</h2>
		| <a href="/z/inquiries/admin/inquiry/edit?inquiries_id=#qinquiry.inquiries_id#&amp;zPageId=#form.zPageId#">Edit</a>
		<cfif session.zos.user.group_id NEQ homeownerid>
			| <a href="/z/inquiries/admin/assign/select?inquiries_id=#qinquiry.inquiries_id#&amp;zPageId=#form.zPageId#">Assign Lead</a>
		</cfif>
		<cfif qinquiry.inquiries_reservation EQ 1>
			| <a href="/z/rental/admin/reservations/cancel?inquiries_id=#qinquiry.inquiries_id#">Cancel Reservation</a>
		</cfif>
		<br />
		<br />
		<cfscript>
		viewIncludeCom=createobject("component", "zcorerootmapping.com.app.inquiriesFunctions");
		viewIncludeCom.getViewInclude(qinquiry);
        </cfscript>
	</cfloop>
</cffunction>

<cffunction name="index" localmode="modern" access="remote" roles="member">
	<cfscript>
	var db=request.zos.queryObject;
	var qSortCom=0;
	var qInquiriesFirst=0;
	var qInquiriesLast=0;
	var inquiryFirstDate=0;
	var qinquiriesNew=0;
	var qStatus=0;
	var statusName=0;
	var qinquiries=0;
	var qinquiriesActive=0;
	var searchStruct=0;
	var searchNav=0;
	var qMember=0;
	var arrId=0;
	variables.init();
	if(structkeyexists(form, 'leadcontactfilter')){
		session.leadcontactfilter=form.leadcontactfilter;		
	}else if(isDefined('session.leadcontactfilter') EQ false){
		session.leadcontactfilter='all';
	}
	if(structkeyexists(form, 'grouping')){
		session.leademailgrouping=form.grouping;
	}else if(isDefined('session.leademailgrouping') EQ false){
		session.leademailgrouping='1';
	}
	if(structkeyexists(form, 'viewspam')){
		session.leadviewspam=form.viewspam;
	}else if(not structkeyexists(session, 'leadviewspam')){
		session.leadviewspam=0;	
	}
	qSortCom = CreateObject("component","zcorerootmapping.com.display.querySort");
	form.zPageId = qSortCom.init("zPageId");
	if(structkeyexists(form, 'zIndex')){
		 application.zcore.status.setField(form.zPageId, "zIndex", form.zIndex);
	}else{
		form.zIndex = application.zcore.status.getField(form.zPageId, "zIndex", 1, true);
	}
	application.zcore.functions.zStatusHandler(request.zsid);
	application.zcore.functions.zStatusHandler(form.zPageId,true);
	</cfscript>
	<cfsavecontent variable="db.sql"> select min(inquiries_datetime) as inquiries_datetime 
	from #db.table("inquiries", request.zos.zcoreDatasource)# inquiries 
	where site_id = #db.param(request.zos.globals.id)# and 
	inquiries.inquiries_status_id <> #db.param(0)# and 
	inquiries_parent_id = #db.param(0)#
	<cfif variables.isReservationSystem>
		and inquiries_reservation_status=#db.param(0)#
	</cfif>
	<cfif structkeyexists(request.zos.userSession.groupAccess, "administrator") EQ false and structkeyexists(request.zos.userSession.groupAccess, "homeowner") eq false and structkeyexists(request.zos.userSession.groupAccess, "manager") eq false>
		AND user_id = #db.param(session.zOS.user.id)# and 
		user_id_siteIDType=#db.param(application.zcore.user.getSiteIdTypeFromLoggedOnUser())#
	</cfif>
	<cfif application.zcore.functions.zso(session, 'agentuserid') NEQ ''>
		and inquiries.user_id = #db.param(session.agentuserid)# and 
		user_id_siteIDType = #db.param(session.agentusersiteidtype)#
	</cfif>
	</cfsavecontent>
	<cfscript>
	qinquiriesFirst=db.execute("qinquiriesFirst");
	</cfscript>
	<cfsavecontent variable="db.sql"> 
	select max(inquiries_datetime) as inquiries_datetime 
	from #db.table("inquiries", request.zos.zcoreDatasource)# inquiries 
	where site_id = #db.param(request.zos.globals.id)# and 
	inquiries.inquiries_status_id <> #db.param(0)#
	<cfif variables.isReservationSystem>
		and inquiries_reservation_status=#db.param(0)#
	</cfif>
	and inquiries_parent_id = #db.param(0)#
	<cfif structkeyexists(request.zos.userSession.groupAccess, "administrator") EQ false and structkeyexists(request.zos.userSession.groupAccess, "homeowner") eq false and structkeyexists(request.zos.userSession.groupAccess, "manager") eq false>
		AND user_id = #db.param(session.zOS.user.id)# and 
		user_id_siteIDType=#db.param(application.zcore.user.getSiteIdTypeFromLoggedOnUser())#
	</cfif>
	<cfif application.zcore.functions.zso(session, 'agentuserid') NEQ ''>
		and inquiries.user_id = #db.param(session.agentuserid)# and 
		user_id_siteIDType = #db.param(session.agentusersiteidtype)#
	</cfif>
	</cfsavecontent>
	<cfscript>
	qinquiriesLast=db.execute("qinquiriesLast");
	</cfscript>
	<cfif qinquiriesLast.inquiries_datetime EQ "" or  qinquiriesLast.recordcount EQ 0>
		There are currently no active leads.
	<cfelse>
		<cfscript>
		if(isnull(qinquiriesFirst.inquiries_datetime) EQ false and isdate(qinquiriesFirst.inquiries_datetime)){
			inquiryFirstDate=qinquiriesFirst.inquiries_datetime;
		}else{
			inquiryFirstDate=dateFormat(now(), "yyyy-mm-dd")&" 00:00:00";
		}
		form.inquiries_end_date = application.zcore.functions.zGetDateSelect("inquiries_end_date");
		form.inquiries_start_date = application.zcore.functions.zGetDateSelect("inquiries_start_date");
		
		if(form.inquiries_start_date EQ false or form.inquiries_end_date EQ false){
			form.inquiries_start_date = dateformat(dateadd("d", -30, now()), "yyyy-mm-dd");
			form.inquiries_end_date = dateFormat(now(), "yyyy-mm-dd");
		}
		if(datediff("d",form.inquiries_start_date, inquiryFirstDate) GT 0){
				form.inquiries_start_date=inquiryFirstDate;
		}
		if(dateCompare(form.inquiries_start_date, form.inquiries_end_date) EQ 1){
			form.inquiries_end_date = form.inquiries_start_date;
		}
		</cfscript>
		<cfsavecontent variable="db.sql"> 
		SELECT count(inquiries_id) as count 
		from #db.table("inquiries", request.zos.zcoreDatasource)# inquiries
		WHERE inquiries.inquiries_status_id = #db.param('1')# and 
		site_id = #db.param(request.zos.globals.id)# and 
		inquiries.inquiries_status_id <> #db.param(0)#
		<cfif variables.isReservationSystem>
			and inquiries_reservation_status=#db.param(0)#
		</cfif>
		and inquiries_parent_id = #db.param(0)#
		<cfif structkeyexists(request.zos.userSession.groupAccess, "administrator") EQ false and structkeyexists(request.zos.userSession.groupAccess, "homeowner") eq false and structkeyexists(request.zos.userSession.groupAccess, "manager") eq false>
			AND user_id = #db.param(session.zOS.user.id)# and 
			user_id_siteIDType=#db.param(application.zcore.user.getSiteIdTypeFromLoggedOnUser())#
		</cfif>
		<cfif application.zcore.functions.zso(session, 'agentuserid') NEQ ''>
			and inquiries.user_id = #db.param(session.agentuserid)# and 
			user_id_siteIDType = #db.param(session.agentusersiteidtype)#
		</cfif>
		</cfsavecontent>
		<cfscript>
		qinquiriesNew=db.execute("qinquiriesNew");
		db.sql="SELECT * from #db.table("inquiries_status", request.zos.zcoreDatasource)# inquiries_status ";
		qstatus=db.execute("qstatus");
		statusName=structnew();
		loop query="qstatus"{
			statusName[qstatus.inquiries_status_id]=qstatus.inquiries_status_name;
		}
		</cfscript>
		<cfsavecontent variable="db.sql"> SELECT *, 
		inquiries_id maxid, inquiries_datetime maxdatetime, #db.param('1')# inquiryCount
		FROM (#db.table("inquiries", request.zos.zcoreDatasource)# inquiries)
		LEFT JOIN #db.table("inquiries_type", request.zos.zcoreDatasource)# inquiries_type ON 
		inquiries.inquiries_type_id = inquiries_type.inquiries_type_id and 
		inquiries_type.site_id IN (#db.param(0)#,#db.param(request.zos.globals.id)#) and 
		inquiries_type.site_id = #db.trustedSQL(application.zcore.functions.zGetSiteIdTypeSQL("inquiries.inquiries_type_id_siteIDType"))# 
		LEFT JOIN #db.table("user", request.zos.zcoreDatasource)# user ON 
		user.user_id = inquiries.user_id and 
		user.site_id = #db.trustedSQL(application.zcore.functions.zGetSiteIdTypeSQL("inquiries.user_id_siteIDType"))# WHERE  
		inquiries.site_id = #db.param(request.zos.globals.id)# and 
		inquiries.inquiries_status_id <> #db.param(0)#
		<cfif variables.isReservationSystem>
			and inquiries_reservation_status=#db.param(0)#
		</cfif>
		and inquiries_parent_id = #db.param(0)#
		<cfif structkeyexists(request.zos.userSession.groupAccess, "administrator") EQ false and structkeyexists(request.zos.userSession.groupAccess, "homeowner") eq false and structkeyexists(request.zos.userSession.groupAccess, "manager") eq false>
			AND inquiries.user_id = #db.param(session.zOS.user.id)# and 
			user_id_siteIDType=#db.param(application.zcore.user.getSiteIdTypeFromLoggedOnUser())#
		</cfif>
		<cfif application.zcore.functions.zso(session, 'agentuserid') NEQ ''>
			and inquiries.user_id = #db.param(session.agentuserid)# and 
			user_id_siteIDType = #db.param(session.agentusersiteidtype)#
		</cfif>
		<cfif structkeyexists(form, 'searchOn') EQ false>
			<cfif session.leadcontactfilter NEQ 'allclosed'>
				and inquiries.inquiries_status_id NOT IN (#db.param('4')#,#db.param('5')#)
			<cfelse>
				and inquiries.inquiries_status_id IN (#db.param('4')#,#db.param('5')#)
			</cfif>
			<cfelse>
			<cfif application.zcore.functions.zso(form, 'searchType',true) EQ 0>
				<cfif form.inquiries_start_date EQ false>
					and (inquiries_datetime >= #db.param(dateformat(dateadd("d", -14, now()), "yyyy-mm-dd")&' 00:00:00')# and 
					inquiries_datetime <= #db.param(dateformat(now(), "yyyy-mm-dd")&' 23:59:59')#)
				<cfelse>
					and (inquiries_datetime >= #db.param(dateformat(form.inquiries_start_date, "yyyy-mm-dd")&' 00:00:00')# and 
					inquiries_datetime <= #db.param(dateformat(form.inquiries_end_date, "yyyy-mm-dd")&' 23:59:59')#)
				</cfif>
			<cfelse>
				<cfif form.inquiries_start_date EQ false>
					and (inquiries_start_date >= #db.param(dateformat(dateadd("d", -14, now()), "yyyy-mm-dd")&' 00:00:00')# and 
					inquiries_end_date <= #db.param(dateformat(now(), "yyyy-mm-dd")&' 23:59:59')#)
				<cfelse>
					and (inquiries_start_date >= #db.param(dateformat(form.inquiries_start_date, "yyyy-mm-dd")&' 00:00:00')# and 
					inquiries_end_date <= #db.param(dateformat(form.inquiries_end_date, "yyyy-mm-dd")&' 23:59:59')#)
				</cfif>
			</cfif>
			<cfif application.zcore.functions.zso(form, 'inquiries_name') NEQ "">
				and concat(inquiries_first_name, #db.param(" ")#, inquiries_last_name) LIKE #db.param('%#form.inquiries_name#%')#
			</cfif>
		</cfif>
		<cfif session.leadviewspam EQ "0">
			and inquiries.inquiries_spam =#db.param(0)#
		</cfif>
		<cfif session.leadcontactfilter EQ 'new'>
			and inquiries.inquiries_status_id ='1'
		<cfelseif session.leadcontactfilter EQ 'email'>
			and inquiries_phone1 =#db.param('')# and inquiries_phone_time=#db.param('')#
		<cfelseif session.leadcontactfilter EQ 'phone'>
			and inquiries_phone1 <>#db.param('')# and inquiries_phone_time=#db.param('')#
		<cfelseif session.leadcontactfilter EQ 'forced'>
			and inquiries_phone_time<>#db.param('')#
		</cfif>
		<cfif session.leademailgrouping EQ '1'>
			and inquiries_primary = #db.param('1')#
		</cfif>
		<cfif qsortcom.getorderby(false) NEQ ''>
			ORDER BY #qsortcom.getorderby(false)# inquiries_id ASC
		<cfelse>
			ORDER BY maxdatetime DESC
		</cfif>
		<cfif structkeyexists(form, 'searchOn')>
			LIMIT #db.param(max(0,(form.zIndex-1))*10)#,#db.param(10)#
			<cfelse>
			LIMIT #db.param(max(0,(form.zIndex-1))*30)#,#db.param(30)#
		</cfif>
		</cfsavecontent>
		<cfscript>
		qinquiries=db.execute("qinquiries");
		</cfscript>
		<cfsavecontent variable="db.sql"> SELECT count(
		<cfif session.leademailgrouping EQ '1'>
			DISTINCT
		</cfif>
		inquiries.inquiries_email) count 
		from #db.table("inquiries", request.zos.zcoreDatasource)# inquiries
		WHERE inquiries.site_id = #db.param(request.zos.globals.id)# and 
		inquiries.inquiries_status_id <> #db.param(0)#
		<cfif variables.isReservationSystem>
			and inquiries_reservation_status=#db.param(0)#
		</cfif>
		and inquiries_parent_id = #db.param(0)#
		<cfif structkeyexists(request.zos.userSession.groupAccess, "administrator") EQ false and structkeyexists(request.zos.userSession.groupAccess, "homeowner") eq false and structkeyexists(request.zos.userSession.groupAccess, "manager") eq false>
			AND inquiries.user_id = #db.param(session.zOS.user.id)# and 
			user_id_siteIDType=#db.param(application.zcore.user.getSiteIdTypeFromLoggedOnUser())#
		</cfif>
		<cfif application.zcore.functions.zso(session, 'agentuserid') NEQ ''>
			and inquiries.user_id = #db.param(session.agentuserid)# and 
			user_id_siteIDType = #db.param(session.agentusersiteidtype)#
		</cfif>
		<cfif structkeyexists(form, 'searchOn') EQ false>
			<cfif session.leadcontactfilter NEQ 'allclosed'>
				and inquiries.inquiries_status_id NOT IN (#db.param('4')#,#db.param('5')#)
			<cfelse>
				and inquiries.inquiries_status_id IN (#db.param('4')#,#db.param('5')#)
			</cfif>
		<cfelse>
			<cfif application.zcore.functions.zso(form, 'searchType',true) EQ 0>
				<cfif form.inquiries_start_date EQ false>
					and (DATE_FORMAT(inquiries_datetime,#db.param("%Y-%m-%d")#) >= #db.param(dateformat(dateadd("d", -14, now()), "yyyy-mm-dd")&' 00:00:00')# and 
					DATE_FORMAT(inquiries_datetime,#db.param("%Y-%m-%d")#) <= #db.param(dateformat(now(), "yyyy-mm-dd")&' 23:59:59')#)
				<cfelse>
					and (DATE_FORMAT(inquiries_datetime,#db.param("%Y-%m-%d")#) >= #db.param(dateformat(form.inquiries_start_date, "yyyy-mm-dd"))# and 
					DATE_FORMAT(inquiries_datetime,#db.param("%Y-%m-%d")#) <= #db.param(dateformat(form.inquiries_end_date, "yyyy-mm-dd"))#)
				</cfif>
			<cfelse>
				<cfif form.inquiries_start_date EQ false>
					and (DATE_FORMAT(inquiries_start_date,#db.param("%Y-%m-%d")#) >= #db.param(dateformat(now(), "yyyy-mm-dd"))# and 
					DATE_FORMAT(inquiries_end_date,#db.param("%Y-%m-%d")#) <= #db.param(dateformat(form.inquiries_end_date, "yyyy-mm-dd"))#)
				<cfelse>
					and (DATE_FORMAT(inquiries_start_date,#db.param("%Y-%m-%d")#) >= #db.param(dateformat(form.inquiries_start_date, "yyyy-mm-dd"))# and 
					DATE_FORMAT(inquiries_end_date,#db.param("%Y-%m-%d")#) <= #db.param(dateformat(form.inquiries_end_date, "yyyy-mm-dd"))#)
				</cfif>
			</cfif>
			<cfif application.zcore.functions.zso(form, 'inquiries_name') NEQ "">
				and concat(inquiries_first_name, #db.param(" ")#, inquiries_last_name) LIKE #db.param('%#form.inquiries_name#%')#
			</cfif>
		</cfif>
		<cfif session.leadviewspam EQ "0">
			and inquiries.inquiries_spam =#db.param(0)#
		</cfif>
		<cfif session.leadcontactfilter EQ 'new'>
			and inquiries.inquiries_status_id =#db.param('1')#
		<cfelseif session.leadcontactfilter EQ 'email'>
			and inquiries_phone1 =#db.param('')# and inquiries_phone_time=#db.param('')#
		<cfelseif session.leadcontactfilter EQ 'phone'>
			and inquiries_phone1 <>#db.param('')# and inquiries_phone_time=#db.param('')#
		<cfelseif session.leadcontactfilter EQ 'forced'>
			and inquiries_phone_time<>#db.param('')#
		</cfif>
		<cfif session.leademailgrouping EQ '1'>
			and inquiries_primary = #db.param('1')#
		</cfif>
		</cfsavecontent>
		<cfscript>
		qinquiriesActive=db.execute("qinquiriesActive");
		</cfscript>
		<h2 style="display:inline; ">Search Leads | </h2>
		<a href="/z/inquiries/admin/search-engine-keyword-report/index">Search Engine Keyword Inquiry Search <strong style="color:##FF0000;">(NEW)</strong></a><br />
		<br />
		<table style="border-spacing:0px; width:100%;" class="table-list">
			<form action="/z/inquiries/admin/manage-inquiries/index?search=true" method="post">
				<input type="hidden" name="searchOn" value="true" />
				<tr>
					<th colspan="<cfif variables.isReservationSystem>5<cfelse>4</cfif>">Search all leads by date received or name.</th>
				</tr>
				<tr>
					<td>Name:
						<input type="text" name="inquiries_name" value="#application.zcore.functions.zso(form, 'inquiries_name')#" /></td>
					<td>Start:#application.zcore.functions.zDateSelect("inquiries_start_date", "inquiries_start_date", year(inquiryFirstDate), year(now()))#</td>
					<td>End:#application.zcore.functions.zDateSelect("inquiries_end_date", "inquiries_end_date", year(inquiryFirstDate), year(now()))#</td>
					<cfif variables.isReservationSystem>
						<td><input type="radio" name="searchtype" value="0" <cfif application.zcore.functions.zso(form, 'searchtype',true) EQ 0>checked="checked"</cfif> style="background:none; border:none;" />
							Received Date<br  />
							<input type="radio" name="searchtype" value="1" <cfif application.zcore.functions.zso(form, 'searchtype',true) EQ 1>checked="checked"</cfif> style="background:none; border:none;" />
							Proposed Occupancy.</td>
					</cfif>
					<td><button type="submit" name="submitForm">Search</button></td>
				</tr>
			</form>
		</table>
		<hr />
		<cfif structkeyexists(form, 'searchOn')>
			<h2 style="display:inline; ">Search Results | </h2>
			<a href="/z/inquiries/admin/manage-inquiries/index">Back to Active Leads</a><br />
			<br />
			<script type="text/javascript">
			/* <![CDATA[ */
			function loadExport(){
				var et=document.getElementById("exporttype1");	
				var et2=document.getElementById("exporttype2");	
				var exporttype="0";
				if(et.checked){
					exporttype="1";
				}else if(et2.checked){
					exporttype="2";
				}
				var format="html";
				et=document.getElementById("exportformat1");	
				if(et.checked){
					format="csv";	
				}
				window.open("/z/inquiries/admin/export?searchType=#urlencodedformat(application.zcore.functions.zso(form, 'searchType',true))#&inquiries_name=#urlencodedformat(application.zcore.functions.zso(form, 'inquiries_name'))#&inquiries_start_date=#urlencodedformat(dateformat(form.inquiries_start_date,'yyyy-mm-dd'))#&inquiries_end_date=#urlencodedformat(dateformat(form.inquiries_end_date,'yyyy-mm-dd'))#&format="+format+"&exporttype="+exporttype);
			}
			/* ]]> */
			</script>
			<button type="button" name="submit11" onclick="loadExport();">Export Search Results</button>
			| Export Options | Format:
			<input type="radio" name="exportformat" id="exportformat1" value="1" <cfif application.zcore.functions.zso(form, 'exporttype',false,0) EQ 1>checked="checked"</cfif> style="vertical-align:middle; background:none; border:none;" />
			CSV
			<input type="radio" name="exportformat" value="0" <cfif application.zcore.functions.zso(form, 'exporttype',false,0) EQ 0>checked="checked"</cfif> style="vertical-align:middle; background:none; border:none;" />
			HTML 
			| 
			Filter:
			<input type="radio" name="exporttype" id="exporttype1" value="1" <cfif application.zcore.functions.zso(form, 'exporttype',false,0) EQ 1>checked="checked"</cfif> style="vertical-align:middle; background:none; border:none;" />
			Unique Emails Only
			<input type="radio" name="exporttype" id="exporttype2" value="2" <cfif application.zcore.functions.zso(form, 'exporttype',false,0) EQ 2>checked="checked"</cfif> style="vertical-align:middle; background:none; border:none;" />
			Unique Phone Numbers Only
			<input type="radio" name="exporttype" value="0" <cfif application.zcore.functions.zso(form, 'exporttype',false,0) EQ 0>checked="checked"</cfif> style="vertical-align:middle; background:none; border:none;" />
			Export All Results <br />
			<br />
		</cfif>
		Show:
		<cfif session.leadcontactfilter NEQ 'all'>
			<a href="/z/inquiries/admin/manage-inquiries/index?leadcontactfilter=all&amp;zPageId=#form.zPageId#">All Active</a>
		<cfelse>
			<strong>All Active</strong>
		</cfif>
		|
		<cfif session.leadcontactfilter NEQ 'new'>
			<a href="/z/inquiries/admin/manage-inquiries/index?leadcontactfilter=new&amp;zPageId=#form.zPageId#">New</a>
		<cfelse>
			<strong>New</strong>
		</cfif>
		|
		<cfif session.leadcontactfilter NEQ 'email'>
			<a href="/z/inquiries/admin/manage-inquiries/index?leadcontactfilter=email&amp;zPageId=#form.zPageId#">Email Only</a>
		<cfelse>
			<strong>Email Only</strong>
		</cfif>
		|
		<cfif session.leadcontactfilter NEQ 'phone'>
			<a href="/z/inquiries/admin/manage-inquiries/index?leadcontactfilter=phone&amp;zPageId=#form.zPageId#">Phone + Email</a>
		<cfelse>
			<strong>Phone + Email</strong>
		</cfif>
		|
		<cfif session.leadcontactfilter NEQ 'forced'>
			<a href="/z/inquiries/admin/manage-inquiries/index?leadcontactfilter=forced&amp;zPageId=#form.zPageId#">Forced Leads</a>
		<cfelse>
			<strong>Forced Leads</strong>
		</cfif>
		|
		<cfif session.leadcontactfilter NEQ 'allclosed'>
			<a href="/z/inquiries/admin/manage-inquiries/index?leadcontactfilter=allclosed&amp;zPageId=#form.zPageId#">All Closed</a>
		<cfelse>
			<strong>All Closed</strong>
		</cfif>
		| <strong>Group By Email:</strong>
		<cfif session.leademailgrouping NEQ '1'>
			<a href="/z/inquiries/admin/manage-inquiries/index?grouping=1&amp;zPageId=#form.zPageId#">Enable</a>
		<cfelse>
			<a href="/z/inquiries/admin/manage-inquiries/index?grouping=0&amp;zPageId=#form.zPageId#">Disable</a>
		</cfif>
		<cfif qsortcom.getorderby(false) NEQ ''>
			| <a href="/z/inquiries/admin/manage-inquiries/index">Clear Sorting</a>
		</cfif>
		 |  <strong>Spam:</strong> 
		<cfif session.leadviewspam NEQ '1'>
			<a href="/z/inquiries/admin/manage-inquiries/index?viewspam=1&amp;zPageId=#form.zPageId#">View</a>
		 <cfelse>
			<a href="/z/inquiries/admin/manage-inquiries/index?viewspam=0&amp;zPageId=#form.zPageId#">Hide</a>
		 </cfif>
		<br />
		<br />
		<cfscript>
		searchStruct = StructNew();
		searchStruct.count = qinquiriesActive.count;
		searchStruct.index = form.zIndex;
		searchStruct.showString = "Results ";
		searchStruct.url = "/z/inquiries/admin/manage-inquiries/index?zPageId=#form.zPageId#&searchtext="&application.zcore.functions.zso(form, 'searchtext');
		searchStruct.indexName = "zIndex";
		searchStruct.buttons = 5;
		if(structkeyexists(form, 'searchOn')){		
			searchStruct.perpage = 10;
		}else{
			searchStruct.perpage = 50;
		}
		if(searchStruct.count LTE searchStruct.perpage){
			searchNav="";
		}else{
			searchNav = '<table class="table-list" style="width:100%; border-spacing:0px;" >		
		<tr><td style="padding:0px;">'&application.zcore.functions.zSearchResultsNav(searchStruct)&'</td></tr></table>';
		}
		</cfscript>
		#searchNav#
		<table class="table-list" style="width:100%; border-spacing:0px;" >
			<tr>
				<th><a href="#qSortCom.getColumnURL("inquiries_first_name", "/z/inquiries/admin/manage-inquiries/index")#" style="text-decoration:underline;">First</a> 
				#qSortCom.getColumnIcon("inquiries_first_name")# / 
				<a href="#qSortCom.getColumnURL("inquiries_last_name", "/z/inquiries/admin/manage-inquiries/index")#" style="text-decoration:underline;">Last</a> 
				#qSortCom.getColumnIcon("inquiries_last_name")# Name</th>
				<th>Phone</th>
				<th style="width:310px;">Status</th>
				<th>Received</th>
				<cfif variables.isReservationSystem>
					<th>Start</th>
					<th>End</th>
				<cfelse>
					<th>Type</th>
				</cfif>
				<th>Admin</th>
			</tr>
			<cfsavecontent variable="db.sql"> SELECT * FROM #db.table("user", request.zos.zcoreDatasource)# user 
			WHERE user_id = #db.param(session.zos.user.id)# and #db.trustedSQL(application.zcore.user.getUserSiteWhereSQL("user"))# and 
			user_server_administrator=#db.param('0')# </cfsavecontent>
			<cfscript>
			qMember=db.execute("qMember");
			</cfscript>
			<cfset arrId=ArrayNew(1)>
			<cfloop query="qinquiries">
				<cfscript>
				local.inquiries_status_name = statusName[qinquiries.inquiries_status_id];
				ArrayAppend(arrId,qinquiries.inquiries_id);
				</cfscript>
				<tr <cfif qinquiries.inquiries_status_id EQ 1 or qinquiries.inquiries_status_id EQ 2><cfif qinquiries.currentrow mod 2 EQ 0>class="row1"<cfelse>class="row2"</cfif><cfelse><cfif qinquiries.currentrow mod 2 EQ 0>class="row2"<cfelse>class="row1"</cfif></cfif>>
					<td><a href="/z/inquiries/admin/feedback/view?inquiries_id=#qinquiries.inquiries_id#&amp;zPageId=#form.zPageId#">#qinquiries.inquiries_first_name# #qinquiries.inquiries_last_name#</a></td>
					<td>#qinquiries.inquiries_phone1#&nbsp;</td>
					<td style="width:310px;">
						<cfif qinquiries.inquiries_assign_email NEQ ''>
							Assigned to
							<cfif structkeyexists(qinquiries, 'inquiries_assign_name') and qinquiries.inquiries_assign_name neq ''>
								#qinquiries.inquiries_assign_name#,
							</cfif>
							<a href="mailto:#qinquiries.inquiries_assign_email#">#qinquiries.inquiries_assign_email#</a>
							<cfif qinquiries.inquiries_status_id EQ 3>
								, Contacted
							</cfif>
						<cfelse>
							<cfif qinquiries.user_id NEQ 0>
								#replace(local.inquiries_status_name, 'Assigned', 'Assigned to #qinquiries.user_first_name# #qinquiries.user_last_name#')#
							<cfelse>
								#local.inquiries_status_name#
							</cfif>
						</cfif>
						<cfif qinquiries.inquiries_spam EQ 1>, <strong>Marked as Spam</strong></cfif>
						</td>
					<td>#DateFormat(qinquiries.inquiries_datetime, "m/d/yy")# #TimeFormat(qinquiries.inquiries_datetime, "h:mm tt")#</td>
					<cfif variables.isReservationSystem>
						<td>#DateFormat(qinquiries.inquiries_start_date,'m/d/yy')# </td>
						<td>#DateFormat(qinquiries.inquiries_end_date,'m/d/yy')#</td>
					<cfelse>
						<td><cfif (qinquiries.inquiries_type_name) EQ ''>
								#qinquiries.inquiries_type_other#
							<cfelse>
								#(qinquiries.inquiries_type_name)#
							</cfif>
							<cfif trim(qinquiries.inquiries_phone_time) NEQ ''>
								/ <strong>Forced</strong>
							</cfif>
							&nbsp;</td>
					</cfif>
					<td><a href="/z/inquiries/admin/feedback/view?inquiries_id=#qinquiries.inquiries_id#&amp;zPageId=#form.zPageId#">View</a> | <a href="/z/inquiries/admin/inquiry/edit?inquiries_id=#qinquiries.inquiries_id#&amp;zPageId=#form.zPageId#">Edit</a>
						<cfif structkeyexists(request.zos.userSession.groupAccess, "administrator") or structkeyexists(request.zos.userSession.groupAccess, "homeowner") or structkeyexists(request.zos.userSession.groupAccess, "manager")>
							<cfif qinquiries.inquiries_status_id NEQ 4 and qinquiries.inquiries_status_id NEQ 5>
								| <a href="/z/inquiries/admin/assign/select?inquiries_id=#qinquiries.inquiries_id#&amp;zPageId=#form.zPageId#">
								<cfif qinquiries.user_id NEQ 0 or qinquiries.inquiries_assign_email NEQ "">
									Re-
								</cfif>
								Assign</a>
							</cfif>
						</cfif></td>
				</tr>
			</cfloop>
		</table>
		#searchNav#
	</cfif>
</cffunction>
</cfoutput>
</cfcomponent>
