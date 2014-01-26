<cfcomponent>
<cfoutput>
<cffunction name="index" localmode="modern" access="remote" returntype="any">
<cfscript>
var perpage=0;
var ts3=0;
var randcount=0;
var theScript=0;
var i=0;
var propertyDataCom=0;
var qC=0;
var mapQuery=0;
var returnStruct=0;
var propDisplayCom=0;
var mapCom=0;
var ts2=0;
var perpageDefault=0;
var tempSearchFormAction=0;
var ms=0;
var mapStageStruct=0;
var ts=0;
var propertyHTML=0;
var db=request.zos.queryObject;
Request.zPageDebugDisabled=true;
application.zcore.template.setTemplate("zcorerootmapping.templates.plain",true,true);
form.content_id=application.zcore.functions.zso(form, 'content_id',true);
db.sql="select * from 
#request.zos.queryObject.table("content", request.zos.zcoreDatasource)# content, 
#request.zos.queryObject.table("mls_saved_search", request.zos.zcoreDatasource)# mls_saved_search 
where mls_saved_search.mls_saved_search_id = content.content_saved_search_id and 
mls_saved_search.site_id = content.site_id and 
content_for_sale <> #db.param('2')# and 
content_id = #db.param(form.content_id)# and 
mls_saved_search.site_id=#db.param(request.zos.globals.id)#";
qC=db.execute("qC");

application.zcore.functions.zquerytostruct(qc, form);
if(qC.recordcount EQ 0 or form.content_show_map NEQ 1){
	application.zcore.functions.zabort();	
}

propertyHTML="";
propertyDataCom = CreateObject("component", "zcorerootmapping.mvc.z.listing.controller.propertyData");
ts = StructNew();
form.zindex=1;
ts.offset = 0;
perpageDefault=10;
perpage=form.search_result_limit;
perpage=max(1,min(perpage,100));
ts.perpage = perpage;
ts.distance = 30; // in miles
ts.disableCount=true;
ts.searchCriteria=structnew();
request.zos.listing.functions.zMLSSetSearchStruct(ts.searchcriteria, form);

form.searchId=application.zcore.status.getNewId();
application.zcore.status.setStatus(form.searchid,false,ts.searchcriteria);
if(form.content_show_map EQ 1){
    writeoutput('<script type="text/javascript">/* <![CDATA[ */ zMLSSearchFormName="contentSearchHiddenForm"; /* ]]> */</script>');
    ts2=StructNew();
    ts2.name="contentSearchHiddenForm";
    ts2.ajax=false;
    ts2.debug=false;
    ts2.action=application.zcore.functions.zURLAppend(request.zos.listing.functions.getSearchFormLink(), "searchaction=search&searchId=#form.searchid#");
    tempSearchFormAction=ts2.action;
    ts2.onLoadCallback="loadMLSResults";
    ts2.method="post";
    ts2.ignoreOldRequests=true;
    ts2.successMessage=false;
    ts2.onChangeCallback="getMLSCount";
    application.zcore.functions.zForm(ts2);
	
        ts3=structnew();
        ts3.name="search_map_long_blocks";
        application.zcore.functions.zinput_hidden(ts3);
        ts3=structnew();
        ts3.name="search_map_lat_blocks";
        application.zcore.functions.zinput_hidden(ts3);
        ts3=structnew();
        ts3.name="zforcemapresults";
        application.zcore.functions.zinput_hidden(ts3);
    
    for(i in ts.searchCriteria){
        ts3=structnew();
        ts3.name=lcase(i);
        form[i]=ts.searchCriteria[i];
        application.zcore.functions.zinput_hidden(ts3);
    }
    application.zcore.functions.zEndForm();
}
if(structkeyexists(form, 'debugsearchresults') and form.debugsearchresults){
ts.debug=true;
}
propertyHTML="";
if(isDefined('request.zForceHideContentProperties') EQ false){ 
    returnStruct = propertyDataCom.getProperties(ts);
    structdelete(variables,'ts'); 
    if(returnStruct.count NEQ 0){	
        propDisplayCom = CreateObject("component", "zcorerootmapping.mvc.z.listing.controller.propertyDisplay");
        
    }
}
randcount=randrange(5,10);
</cfscript>
    <div id="mapContentDivId" style="width:100%; float:left;"></div>
	<cfscript>
	mapStageStruct=StructNew();
	mapStageStruct.width=380;
	mapStageStruct.height=300;
	mapStageStruct.fullscreen.width=380;
	mapStageStruct.fullscreen.height=300;
	mapQuery=returnStruct;
	//hideMapControls=true;
	request.zOverrideMapDivId="mapContentDivId"
	
		ms={
			mapQuery=mapQuery,
			propertyDataCom=propertyDataCom,
			mapStageStruct=mapStageStruct
		}
		mapCom=createobject("component","zcorerootmapping.mvc.z.listing.controller.map");
		mapCom.index(ms);
		</cfscript>
<cfsavecontent variable="theScript">
<style type="text/css">
body{ overflow:hidden; background:none !important; background-color:transparent !important;}
##zlsMapLegendDiv{display:none;}
</style>
<script type="text/javascript">
/* <![CDATA[ */ 
zArrDeferredFunctions.push(function(){ 
	zMapArrLoadFunctions.push(function(){
		zMapCoorUpdateV3(true, "contentSearchHiddenForm");
	}); 
	document.body.onmouseover=function(){
		var myOptions = {
			draggable: false,
			scrollwheel:false
		}
		mapObjV3.setOptions(myOptions);
	} 
}); 
/* ]]> */
</script></cfsavecontent>
<cfscript>
application.zcore.template.appendTag("scripts",theScript);
</cfscript>
</cffunction>
</cfoutput>
</cfcomponent>