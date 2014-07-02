<cfcomponent>
<cfoutput>
<cffunction name="init" localmode="modern" output="no" returntype="any">
	<cfargument name="sharedStruct" type="struct" required="yes">
	<cfscript>
		</cfscript>
</cffunction>

<cffunction name="checkIfLoaded" localmode="modern" output="no" returntype="any">
	<cfscript>
	var db=request.zos.queryObject;
	if(isDefined('application.zcore.realestate') EQ false){
		application.zcore.realestate=structnew();
	}
	if(isDefined('application.zcore.realestate.search_criteria') EQ false){
		ts=structnew();
		db.sql="SELECT * FROM #db.table("search_criteria", request.zos.zcoreDatasource)#  ";
		qC=db.execute("qC"); 
		for(i=1;i LTE arraylen(qc.recordcount);i++){
			if(structkeyexists(ts,qc.mls_id[i]) EQ false){
				ts[qc.mls_id[i]]=structnew();	
			}
			if(structkeyexists(ts[qc.mls_id[i]],qc.search_criteria_type[i]) EQ false){
				ts[qc.mls_id[i]][qc.search_criteria_type[i]]=structnew();	
			}
			ts[qc.mls_id[i]][qc.search_criteria_type[i]][qc.search_criteria_value[i]]=qc.search_criteria_id[i];
		}
		application.zcore.realestate.search_criteria=ts;
	}
	</cfscript>
</cffunction>

<cffunction name="getCriteriaId" localmode="modern" output="no" returntype="any">
	<cfargument name="ts" type="struct" required="yes">
	<cfscript>
	var id=0;
	var t2=0;
	var qC=0;
	var db=request.zos.queryObject;
	checkIfLoaded();
	if(structkeyexists(application.zcore.realestate.search_criteria, ts.mls_id)){
		if(structkeyexists(application.zcore.realestate.search_criteria[ts.mls_id], ts.search_criteria_type)){	
			if(structkeyexists(application.zcore.realestate.search_criteria[ts.mls_id][ts.search_criteria_type],ts.value)){
				return application.zcore.realestate.search_criteria[ts.mls_id][ts.search_criteria_type][ts.value];
			}
		}
	}	
	db.sql="SELECT search_criteria_id FROM #db.table("search_criteria", request.zos.zcoreDatasource)# search_criteria 
	WHERE search_criteria_type=#db.param(ts.search_criteria_type)# and 
	search_criteria_value=#db.param(ts.value)# and 
	mls_id=#db.param(ts.mls_id)#";
	qC=db.execute("qC"); 
	if(qC.recordcount EQ 0){
		t2=StructNew();
		t2.table="search_criteria";
		t2.datasource=mlsdb;
		t2.struct.search_criteria_type=ts.search_criteria_type;
		t2.struct.mls_id=ts.mls_id;
		t2.struct.search_criteria_value=ts.value;
		id=application.zcore.functions.zInsert(t2);
		if(id EQ false){
			application.zcore.template.fail("Failed to create search_criteria. SQL Failed: #request.zos.arrQueryLog[arraylen(request.zos.arrQueryLog)-1]#");
		}
	}else{
		id=qC.search_criteria_id;	
	}
	application.zcore.realestate.search_criteria[ts.mls_id][ts.search_criteria_type][ts.value]=id;
	return id;
	</cfscript>
</cffunction>


<cffunction name="setMLS" localmode="modern" output="no" returntype="any">
	<cfargument name="mls_id" type="numeric" required="yes">
	<cfscript>
	this.mls_id=arguments.mls_id;
	if(request.zos.istestserver){
		variables.hqPhotoPath="#request.zos.sharedPath#mls-images/#this.mls_id#/";
	}else{
		variables.hqPhotoPath="#request.zos.sharedPath#mls-images/#this.mls_id#/";
	}
	</cfscript>
</cffunction>

<cffunction name="getListingTypeWithCode" localmode="modern" output="no" returntype="struct">
	<cfargument name="code" type="string" required="yes">
	<cfscript>
	var ts=0;
	if(structkeyexists(request.zos.listing.mlsStruct[this.mls_id].sharedStruct.lookupStruct.propertyTypeCode, arguments.code)){
			return request.zos.listing.mlsStruct[this.mls_id].sharedStruct.lookupStruct.propertyType[request.zos.listing.mlsStruct[this.mls_id].sharedStruct.lookupStruct.propertyTypeCode[arguments.code]];
	}else{
		ts=structnew();
		ts.code="0";
		ts.id="0";
		ts.name="Real Estate";
		ts.seo="Real Estate";
		return ts;	
	}
	</cfscript>
</cffunction>

<cffunction name="getListingTypeWithId" localmode="modern" output="no" returntype="struct">
	<cfargument name="listing_type_id" type="string" required="yes">
	<cfscript>
	var ts=0;
	if(structkeyexists(request.zos.listing.mlsStruct[this.mls_id].sharedStruct.lookupStruct.propertyType, arguments.listing_type_id)){
			return request.zos.listing.mlsStruct[this.mls_id].sharedStruct.lookupStruct.propertyType[arguments.listing_type_id];
	}else{
		ts=structnew();
		ts.code="0";
		ts.id="0";
		ts.name="Real Estate";
		ts.seo="Real Estate";
		return ts;	
	}
	</cfscript>
</cffunction>

<cffunction name="baseGetDetails" localmode="modern" output="no" returntype="any">
	<cfargument name="query" type="query" required="yes">
	<cfargument name="row" type="numeric" required="no" default="#1#">
	<cfargument name="fulldetails" type="boolean" required="no" default="#false#">
	<cfscript>
	var arrI=0;
	var arrA=0;
	var arrB=0;
	var tmp=0;
	var i=0;
	var arrNewList=0;
	var argType=0;
	var argList=0;
	var argDelimiter=0;
	var i4=0;
	var idx=structnew();
	loop query="arguments.query" startrow="#arguments.row#" endrow="#arguments.row#"{
		structappend(idx, arguments.query, true);
	}
	idx["listingHasMap"]=0;
	if(arguments.query.listing_latitude[arguments.row] NEQ '' and arguments.query.listing_longitude[arguments.row] NEQ '' and arguments.query.listing_latitude[arguments.row] NEQ '0' and arguments.query.listing_longitude[arguments.row] NEQ '0' and abs(arguments.query.listing_latitude[arguments.row]) LTE 180 and abs(arguments.query.listing_longitude[arguments.row]) LTE 180){
		idx["listingHasMap"]=1;
	}
	if(structkeyexists(request.zos.listing.cityNameStruct,arguments.query.listing_city[arguments.row])){
		idx["cityName"]=request.zos.listing.cityNameStruct[arguments.query.listing_city[arguments.row]];
	}else{
		idx["cityName"]="";
	}
	if(arguments.query.listing_square_feet[arguments.row] NEQ 0 and arguments.query.listing_price[arguments.row] GTE 999){
		idx["pricepersqft"]=round(arguments.query.listing_price[arguments.row]/arguments.query.listing_square_feet[arguments.row]);
	}else if(arguments.query.listing_lot_square_feet[arguments.row] NEQ 0 and arguments.query.listing_price[arguments.row] GTE 999){
		idx["pricepersqft"]=round(arguments.query.listing_price[arguments.row]/arguments.query.listing_lot_square_feet[arguments.row]);
	}else{
		idx["pricepersqft"]="";	
	}
	if(structkeyexists(this,'sysidfield')){
		idx["sysidfield"]=arguments.query[this.sysidfield][arguments.row];
	}else{
		idx["sysidfield"]="";
	}
	if(structkeyexists(this,'sysidfield2')){
		idx["sysidfield2"]=arguments.query[this.sysidfield2][arguments.row];
	}else{
		idx["sysidfield2"]="";
	}
	
	arrNewList=["liststatus","status","style","view","frontage","tenure","parking","region","condition"];
	for(i4=1;i4 LTE arraylen(arrNewList);i4++){
		argtype=arrNewList[i4];
		if(argtype EQ "status"){
			arglist=arguments.query["listing_status"][arguments.row];
		}else{
			arglist=arguments.query["listing_"&argtype][arguments.row];
		}
		argdelimiter=",";
		arrA=listtoarray(arglist, argdelimiter);
		arrB=[];
		tmp="";
		i=0;
		for(i=1;i LTE arraylen(arrA);i++){
			if(structkeyexists(request.zos.listing.listingLookupStruct[argtype].value, arrA[i])){
				tmp=request.zos.listing.listingLookupStruct[argtype].value[arrA[i]];
				if(tmp NEQ ""){
					arrayappend(arrB, tmp);	
				}
			}
		}
		idx["listing"&arrNewList[i4]]=arraytolist(arrB,", ");
	}
	
	
	idx["listingPropertyType"]="Real Estate";
	if(arguments.query.listing_type_id[arguments.row] NEQ 0){
		idx["listingPropertyType"]=application.zcore.functions.zFirstLetterCaps(application.zcore.listingCom.listingLookupValue("listing_type",arguments.query.listing_type_id[arguments.row]));
	}
	arrI=listtoarray(arguments.query.listing_id[arguments.row],"-");
	idx.urlMlsId=application.zcore.listingCom.getURLIdForMLS(arrI[1]);
	if(arraylen(arrI) EQ 2){
		idx.urlMLSPId=arrI[2];
	}else{
		idx.urlMLSPId="";
	}
	return idx;
	</cfscript>
</cffunction>

<cffunction name="getCityName" localmode="modern" output="no" returntype="string">
	<cfargument name="listing_city_id" type="string" required="yes">
	<cfscript>    
	if(structkeyexists(request.zos.listing.cityNameStruct,arguments.listing_city_id)){
		return request.zos.listing.cityNameStruct[arguments.listing_city_id];
	}else{
		return "";	
	}
	</cfscript>
</cffunction>

<cffunction name="baseProcessImport" localmode="modern" output="yes" returntype="any">
	<cfscript>
	var r2=0;
	var db=request.zos.queryObject;
	var r3=0;
	var r4=0;
	var r5=0;
	var db2=request.zos.noVerifyQueryObject;
	var values=0;
	if(arraylen(request.zos.importMlsStruct[this.mls_id].arrImportListingRows) EQ 0) return;
	values=arraytolist(request.zos.importMlsStruct[this.mls_id].arrImportListingRows);
	db2.sql=request.zos.listing.mlsStruct[this.mls_id].sharedStruct.lookupStruct.listingsql&(values);
	r2=db2.execute("r2"); 
	
	db2.sql=request.zos.listing.mlsStruct[this.mls_id].sharedStruct.lookupStruct.listingramsql&(values);
	r3=db2.execute("r3"); 
	
	db2.sql=request.zos.listing.mlsStruct[this.mls_id].sharedStruct.lookupStruct.listingdatasql&(arraytolist(request.zos.importMlsStruct[this.mls_id].arrImportListingDataRows));
	r4=db2.execute("r4"); 
	
	 db2.sql=request.zos.listing.mlsStruct[this.mls_id].sharedStruct.lookupStruct.listingtrackSQL&(arraytolist(request.zos.importMlsStruct[this.mls_id].arrImportListingTrackRows));
	 r5=db2.execute("r5");
	request.zos.importMlsStruct[this.mls_id].arrImportListingRows=arraynew(1);
	request.zos.importMlsStruct[this.mls_id].arrImportListingDataRows=arraynew(1);
	request.zos.importMlsStruct[this.mls_id].arrImportListingTrackRows=arraynew(1);
	</cfscript>
</cffunction>

<cffunction name="initImport" localmode="modern" output="no" returntype="any">
	<cfargument name="resource" type="string" required="yes">
	<cfargument name="sharedStruct" type="struct" required="yes">
	<cfscript>
	request.zos.importMlsStruct[this.mls_id].arrImportListingRows=arraynew(1);
	request.zos.importMlsStruct[this.mls_id].arrImportListingDataRows=arraynew(1);
	request.zos.importMlsStruct[this.mls_id].arrImportListingTrackRows=arraynew(1);
	</cfscript>
</cffunction>

<cffunction name="getImportFilePath" localmode="modern" output="no" returntype="any">
	<cfargument name="ss" type="struct" required="yes">
	<cfscript>
	var path=request.zos.sharedPath&"mls-data/"&arguments.ss.qMLS.mls_id[arguments.ss.query_row]&"/"&arguments.ss.qMLS.mls_file[arguments.ss.query_row];
	//var path=arguments.ss.qMLS.mls_path[arguments.ss.query_row]&arguments.ss.qMLS.mls_file[arguments.ss.query_row];
	if(fileexists(path)){
		return replace(path, request.zos.sharedPath, "");
	}else{
		return false;	
	}
	</cfscript>
</cffunction>

<cffunction name="baseGetLatLong" localmode="modern" output="no" returntype="any">
	<cfargument name="address" type="string" required="yes">
	<cfargument name="state" type="string" required="yes">
	<cfargument name="zip" type="string" required="yes">
	<cfargument name="listing_id" type="string" required="yes">
	<cfscript>
	var db=request.zos.queryObject;
	var rs=structnew();
	rs.latitude="";
	rs.longitude="";
	rs.accuracy="";
	// Note: this table stores city name in listing_coordinates_address, but the feeds don't pass it into this function.
	db.sql="SELECT * FROM #db.table("listing_coordinates", request.zos.zcoreDatasource)# listing_coordinates 
	WHERE listing_id = #db.param(arguments.listing_id)# and 
	listing_coordinates_zip = #db.param(arguments.zip)# and 
	listing_coordinates_latitude<>#db.param('')# and 
	listing_coordinates_status=#db.param('OK')# and 
	listing_coordinates_accuracy=#db.param('ROOFTOP')# ";
	//listing_coordinates_address = #db.param(arguments.address)# and 
	qD=db.execute("qD");
	if(qD.recordcount NEQ 0){
		rs.latitude=qD.listing_coordinates_latitude;
		rs.longitude=qD.listing_coordinates_longitude;
		rs.accuracy=qD.listing_coordinates_accuracy;
	}
	return rs;
	</cfscript>
</cffunction>

<cffunction name="baseInitImport" localmode="modern" output="no" returntype="any">
	<cfargument name="sharedStruct" type="struct" required="yes">
	<cfscript>
	var i=0;
	var qP=0;
	var db=application.zcore.db.newQuery();
	var db2=request.zos.noVerifyQueryObject;
	var ts=structnew();
	var ts2=0;
	var orsql=0;
	var qlookup=0;
	var listingcolumns="listing_id,listing_acreage,listing_baths,listing_halfbaths,listing_beds,listing_city,listing_county,listing_frontage,listing_frontage_name,listing_price,listing_status,listing_state,listing_type_id,listing_sub_type_id,listing_style,listing_view,listing_lot_square_feet,listing_square_feet,listing_subdivision,listing_year_built,listing_office,listing_agent,listing_latitude,listing_longitude,listing_pool,listing_photocount,listing_coded_features,listing_updated_datetime,listing_primary,listing_mls_id,listing_condoname,listing_address,listing_zip,listing_condition,listing_parking,listing_region,listing_tenure,listing_liststatus";
	var listingdatacolumns="listing_id,listing_data_remarks,listing_data_address,listing_data_zip,listing_data_detailcache1,listing_data_detailcache2,listing_data_detailcache3";
	var listingtrackcolumns="listing_track_id,listing_id,listing_track_price,listing_track_price_change,listing_track_hash,listing_track_deleted,listing_track_datetime,listing_track_updated_datetime,listing_track_processed_datetime";
	
	ts.lookupStruct=StructNew();
	ts.lookupStruct.arrlistingtrackcolumns=listToArray(listingtrackcolumns);
	ts.lookupStruct.arrlistingcolumns=listToArray(listingcolumns);
	ts.lookupStruct.arrlistingdatacolumns=listToArray(listingdatacolumns);
	ts.lookupStruct.listingtracksql="REPLACE INTO #db2.table("listing_track", request.zos.zcoreDatasource)#  (#listingtrackcolumns#) values";
	ts.lookupStruct.listingsql="REPLACE INTO #db2.table("listing", request.zos.zcoreDatasource)#  (#listingcolumns#) values";
	ts.lookupStruct.listingramsql="REPLACE INTO #db2.table("#request.zos.ramtableprefix#listing", request.zos.zcoreDatasource)#  (#listingcolumns#) values";
	ts.lookupStruct.listingdatasql="REPLACE INTO #db2.table("listing_data", request.zos.zcoreDatasource)#  (#listingdatacolumns#) values";
	request.zos.importMlsStruct[this.mls_id].arrImportListingRows=arraynew(1);
	request.zos.importMlsStruct[this.mls_id].arrImportListingDataRows=arraynew(1);
	request.zos.importMlsStruct[this.mls_id].arrImportListingTrackRows=arraynew(1);
	ts.lookupStruct.statusStr=structnew();    
	ts.lookupStruct.statusStr["for sale"]=1;
	ts.lookupStruct.statusStr["foreclosure"]=2;
	ts.lookupStruct.statusStr["short sale"]=3;
	ts.lookupStruct.statusStr["bank owned"]=4;
	ts.lookupStruct.statusStr["new construction"]=5;
	//ts.lookupStruct.statusStr["for lease"]=6;
	ts.lookupStruct.statusStr["for rent"]=7;
	ts.lookupStruct.statusStr["pre construction"]=8;
	ts.lookupStruct.statusStr["model home"]=9;
	ts.lookupStruct.statusStr["pre-foreclosure"]=10;
	ts.lookupStruct.statusStr["auction"]=11;
	ts.lookupStruct.statusStr["remodeled"]=12;
	ts.lookupStruct.statusStr["hud"]=13;
	ts.lookupStruct.statusStr["relo company"]=14;
	ts.lookupStruct.liststatusStr=structnew();    
	ts.lookupStruct.liststatusStr["active"]=1;
	ts.lookupStruct.liststatusStr["incomplete"]=2;
	ts.lookupStruct.liststatusStr["withdrawn"]=3;
	ts.lookupStruct.liststatusStr["active continue to show"]=4;
	ts.lookupStruct.liststatusStr["temporarily withdrawn"]=5;
	ts.lookupStruct.liststatusStr["incomplete"]=6;
	ts.lookupStruct.liststatusStr["pending"]=7;
	ts.lookupStruct.liststatusStr["expired"]=8;
	ts.lookupStruct.liststatusStr["sold"]=9;
	ts.lookupStruct.liststatusStr["expired continue to show"]=10;
	ts.lookupStruct.liststatusStr["expired pending"]=11;
	ts.lookupStruct.liststatusStr["leased"]=12;
	ts.lookupStruct.liststatusStr["lease option"]=13;
	ts.lookupStruct.liststatusStr["rented"]=14;
	ts.lookupStruct.liststatusStr["incoming"]=15;
	ts.lookupStruct.liststatusStr["contingent"]=16;
	ts.lookupStruct.liststatusStr["deleted"]=17;
	ts.lookupStruct.liststatusStr["cancelled"]=18;
	
	ts.lookupStruct.propertyTypeCode=structnew();
	ts.lookupStruct.propertyType=structnew();
	db.sql="SELECT * FROM #db.table("listing_type", request.zos.zcoreDatasource)# listing_type 
	WHERE mls_id_list LIKE #db.trustedSQL("'%,#this.mls_id#,%'")#";
	qP=db.execute("qP"); 
	loop query="qP"{
		ts2=structnew();
		ts2.id=qP.listing_type_id;
		ts2.code=qP.listing_type_code;
		ts2.name=qP.listing_type_name;
		ts2.seo=qP.listing_type_seo;
		ts.lookupStruct.propertyType[qP.listing_type_id]=ts;
		ts.lookupStruct.propertyTypeCode[qP.listing_type_code]=qP.listing_type_id;
	}
	ts.listingLookupStruct=structnew();
	orsql="";
	if(this.mls_provider EQ "rets7"){
		orsql=" or listing_lookup_mls_provider = 'far' ";	
	}
	db.sql="SELECT listing_lookup_value,listing_lookup_id,listing_lookup_type,listing_lookup_oldid  
	FROM #db.table("listing_lookup", request.zos.zcoreDatasource)# listing_lookup 
	WHERE (listing_lookup_mls_provider = #db.param(this.mls_provider)# 
	#db.trustedSQL(orsql)#) 
	ORDER BY listing_lookup_type";
	qLookup=db.execute("qLookup");
	ts.listingLookupStruct["status"]=structnew();
	ts.listingLookupStruct["status"].value=structnew();
	ts.listingLookupStruct["status"].id=structnew();
	for(i in ts.lookupStruct.statusStr){
		ts.listingLookupStruct["status"].value[ts.lookupStruct.statusStr[i]]=i;
		ts.listingLookupStruct["status"].id[i]=ts.lookupStruct.statusStr[i];
	}
	ts.listingLookupStruct["liststatus"]=structnew();
	ts.listingLookupStruct["liststatus"].value=structnew();
	ts.listingLookupStruct["liststatus"].id=structnew();
	for(i in ts.lookupStruct.liststatusStr){
		ts.listingLookupStruct["liststatus"].value[ts.lookupStruct.liststatusStr[i]]=i;
		ts.listingLookupStruct["liststatus"].id[i]=ts.lookupStruct.liststatusStr[i];
	}
	loop query="qLookup"{
		if(structkeyexists(ts.listingLookupStruct,qLookup.listing_lookup_type) EQ false){
			ts.listingLookupStruct[qLookup.listing_lookup_type]=structnew();
			ts.listingLookupStruct[qLookup.listing_lookup_type].value=structnew();
			ts.listingLookupStruct[qLookup.listing_lookup_type].id=structnew();
		}
		ts.listingLookupStruct[qLookup.listing_lookup_type].value[qLookup.listing_lookup_id]=qLookup.listing_lookup_value;
		ts.listingLookupStruct[qLookup.listing_lookup_type].id[qLookup.listing_lookup_oldid]=qLookup.listing_lookup_id;
	}
	structappend(arguments.sharedStruct, ts, true);
	</cfscript>
</cffunction>

<cffunction name="listingLookupNewId" localmode="modern" output="no" returntype="any">
	<cfargument name="type" type="string" required="yes">
	<cfargument name="oldid" type="string" required="yes">
	<cfargument name="defaultValue" type="string" required="no" default="">
	<cfscript>
	arguments.oldid=replace(arguments.oldid,'"','','all');
        if(structkeyexists(request.zos.listing.mlsStruct[this.mls_id].sharedStruct.listingLookupStruct,arguments.type) and structkeyexists(request.zos.listing.mlsStruct[this.mls_id].sharedStruct.listingLookupStruct[arguments.type].id,arguments.oldid)){
            return request.zos.listing.mlsStruct[this.mls_id].sharedStruct.listingLookupStruct[arguments.type].id[arguments.oldid];
        }else{
            return arguments.defaultValue;
        }
        </cfscript>
</cffunction>

<cffunction name="listingLookupValue" localmode="modern" output="no" returntype="any">
	<cfargument name="type" type="string" required="yes">
	<cfargument name="id" type="string" required="yes">
	<cfargument name="defaultValue" type="string" required="no" default="">
	<cfscript>
        if(structkeyexists(request.zos.listing.mlsStruct[this.mls_id].sharedStruct.listingLookupStruct,arguments.type) and structkeyexists(request.zos.listing.mlsStruct[this.mls_id].sharedStruct.listingLookupStruct[arguments.type].value,arguments.id)){
            return request.zos.listing.mlsStruct[this.mls_id].sharedStruct.listingLookupStruct[arguments.type].value[arguments.id];
        }else{
            return arguments.defaultValue;
        }
        </cfscript>
</cffunction>

<!--- 
	ts=structnew();
	ts.field=remarks;
	ts.yearbuiltfield=yearbuilt;
	ts.foreclosureField=foreclosure;
	mlsProviderCom.processRawStatus(ts);
	 --->
<cffunction name="processRawStatus" localmode="modern" output="no" returntype="struct">
	<cfargument name="ss" type="struct" required="yes">
	<cfscript>
	var statusStruct=structnew();
	var ts=structnew();
	ts.field="";
	ts.yearbuiltfield="";
	ts.foreclosureField="";
	structappend(arguments.ss,ts,false);
	if(arguments.ss.foreclosureField NEQ ""){
		if(arguments.ss.foreclosureField EQ 1){
			statusStruct[request.zos.listing.mlsStruct[this.mls_id].sharedStruct.lookupStruct.statusStr["foreclosure"]]=true;
		}
	}
	if(arguments.ss.field CONTAINS "remodeled"){
		statusStruct[request.zos.listing.mlsStruct[this.mls_id].sharedStruct.lookupStruct.statusStr["remodeled"]]=true;
	}
	if(arguments.ss.field CONTAINS "model home"){
		statusStruct[request.zos.listing.mlsStruct[this.mls_id].sharedStruct.lookupStruct.statusStr["model home"]]=true;
	}
	if(refindnocase("not ^.* bank owned", arguments.ss.field) EQ 0 and arguments.ss.field CONTAINS "bank owned"){
		statusStruct[request.zos.listing.mlsStruct[this.mls_id].sharedStruct.lookupStruct.statusStr["bank owned"]]=true;
	}
	if(arguments.ss.field CONTAINS "new construction"){
		statusStruct[request.zos.listing.mlsStruct[this.mls_id].sharedStruct.lookupStruct.statusStr["new construction"]]=true;
	}
	if(arguments.ss.field CONTAINS "pre construction"){
		statusStruct[request.zos.listing.mlsStruct[this.mls_id].sharedStruct.lookupStruct.statusStr["pre construction"]]=true;
	}
	if(arguments.ss.field CONTAINS "auction" and arguments.ss.field DOES NOT CONTAIN "auction house"){
		statusStruct[request.zos.listing.mlsStruct[this.mls_id].sharedStruct.lookupStruct.statusStr["auction"]]=true;
	}
	if(arguments.ss.field CONTAINS " lease" or (arguments.ss.field CONTAINS "lease " and arguments.ss.field DOES NOT CONTAIN "elease" and arguments.ss.field DOES NOT CONTAIN "please")){
		statusStruct[request.zos.listing.mlsStruct[this.mls_id].sharedStruct.lookupStruct.statusStr["for rent"]]=true;
	}else if(arguments.ss.field DOES NOT CONTAIN "not for rent" and arguments.ss.field CONTAINS "for rent"){
		statusStruct[request.zos.listing.mlsStruct[this.mls_id].sharedStruct.lookupStruct.statusStr["for rent"]]=true;
	}else{
		statusStruct[request.zos.listing.mlsStruct[this.mls_id].sharedStruct.lookupStruct.statusStr["for sale"]]=true;
	}
	if(arguments.ss.yearbuiltfield GTE year(dateadd("m",-6,now())) and arguments.ss.yearbuiltfield LTE year(dateadd("m",6,now()))){
		statusStruct[request.zos.listing.mlsStruct[this.mls_id].sharedStruct.lookupStruct.statusStr["new construction"]]=true;
	}
	return statusStruct;
        </cfscript>
</cffunction>

<cffunction name="deleteListings" localmode="modern" output="no" returntype="any">
	<cfargument name="idlist" type="string" required="yes">
	<cfscript>
	//var db=request.zos.queryObject;
	</cfscript>
</cffunction>
</cfoutput>
</cfcomponent>
