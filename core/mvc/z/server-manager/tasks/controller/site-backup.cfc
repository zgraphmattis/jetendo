<cfcomponent>
<!--- It took 4 minutes 20 to backup entire test server - 2.6gb compressed
TODO: figure out why site backup doesn't get compressed.
 --->
<cfoutput>

<cffunction name="downloadSite" localmode="modern" access="private">
	<cfargument name="site_id" type="string" required="yes">
	<cfargument name="domainPath" type="string" required="yes">
	<cfscript>
	var fp=request.zos.backupDirectory&"site-archives/"&arguments.domainPath&'.tar.gz';
	header name="Content-Disposition" value="attachment; filename=#getfilefrompath(fp)#" charset="utf-8";
	content type="application/binary" deletefile="no" file="#fp#";
	application.zcore.functions.zabort();
	</cfscript>
</cffunction>

<cffunction name="downloadSiteUpload" localmode="modern" access="private">
	<cfargument name="site_id" type="string" required="yes">
	<cfargument name="domainPath" type="string" required="yes">
	<cfscript>
	var fp=request.zos.backupDirectory&"site-archives/"&arguments.domainPath&'-zupload.tar.gz';
	header name="Content-Disposition" value="attachment; filename=#getfilefrompath(fp)#" charset="utf-8";
	content type="application/binary" deletefile="no" file="#fp#";
	application.zcore.functions.zabort();
	</cfscript>
</cffunction>


<cffunction name="downloadGlobal" localmode="modern" access="private">
	<cfscript>
	var fp=request.zos.backupDirectory&"global-database.tar.gz";
	header name="Content-Disposition" value="attachment; filename=#getfilefrompath(fp)#" charset="utf-8";
	content type="application/binary" deletefile="no" file="#fp#";
	application.zcore.functions.zabort();
	</cfscript>
</cffunction>

<cffunction name="getCreateTriggerSQLFromStruct" localmode="modern" output="no" access="public">
	<cfargument name="schema" type="string" required="yes">
	<cfargument name="row" type="struct" required="yes"> 
	<cfscript>
	return { 
		dropTriggerSQL: "DROP TRIGGER IF EXISTS `"&arguments.row.trigger&"`", 
		createTriggerSQL: "CREATE TRIGGER `"&arguments.row.table&"_auto_inc` "&arguments.row.timing&" "&arguments.row.event&" ON `"&arguments.row.table&"` FOR EACH ROW "&arguments.row.statement&";"
	};
	</cfscript>
</cffunction>

<cffunction name="generateSchemaBackup" localmode="modern" output="no" access="public">
	<cfargument name="datasource" type="string" required="yes">
	<cfargument name="dsStruct" type="struct" required="yes">
	<cfscript>
	var db=request.zos.noVerifyQueryObject;
	var i2=arguments.datasource;
	var arrSchema=[];
	var qT=0;
	var i=0;
	var n=0;
	var qC=0;
	var tempStruct=0;
	var row=0; 
	setting requesttimeout="5000";
	db.sql="SHOW TABLES IN `"&i2&"`";
	qT=db.execute("qT");
	for(local.row in qT){
		n=local.row["Tables_in_"&i2];
		arrayAppend(arrSchema, "drop table if exists `"&n&"`;");
		db.sql="show create table `"&i2&"`.`"&n&"`";
		qC=db.execute("qC"); 
		arrayAppend(arrSchema, qC["Create Table"]&";");
	} 
	db.sql="SHOW TRIGGERS FROM "&i2;
	qT=db.execute("qT");  
	for(row in qT){
		local.curTrigger=this.getCreateTriggerSQLFromStruct(i2, row);
		arrayAppend(arrSchema, local.curTrigger.dropTriggerSQL);
		arrayAppend(arrSchema, local.curTrigger.createTriggerSQL); 
	} 
	
	tempStruct=structnew();
	tempStruct.fieldStruct=structnew();
	tempStruct.keyStruct=structnew();
	tempStruct.tableStruct=structnew();
	for(n in arguments.dsStruct.globalTableStruct[i2]){
		tempStruct.tableStruct[i2&"."&n]=arguments.dsStruct.tableStruct[i2&"."&n];
		tempStruct.triggerStruct[i2&"."&n]=arguments.dsStruct.triggerStruct[i2&"."&n];
		tempStruct.keyStruct[i2&"."&n]=arguments.dsStruct.keyStruct[i2&"."&n];
		tempStruct.fieldStruct[i2&"."&n]=arguments.dsStruct.fieldStruct[i2&"."&n];
	}
	for(n in arguments.dsStruct.siteTableStruct[i2]){
		tempStruct.tableStruct[i2&"."&n]=arguments.dsStruct.tableStruct[i2&"."&n];
		tempStruct.triggerStruct[i2&"."&n]=arguments.dsStruct.triggerStruct[i2&"."&n];
		tempStruct.keyStruct[i2&"."&n]=arguments.dsStruct.keyStruct[i2&"."&n];
		tempStruct.fieldStruct[i2&"."&n]=arguments.dsStruct.fieldStruct[i2&"."&n];
	} 
	return { sql: arrayToList(arrSchema, chr(10)), struct: tempStruct };
	</cfscript>
</cffunction>

<!--- sites with their own database need ALL data backed up - not just siteIdTables --->
<cffunction name="index" localmode="modern" access="remote">
	<cfscript>
	var d3=0;
	var n=0;
	var g=0;
	var arrD=0;
	var curDomainOriginal=0; 
	var a242=0;
	var appIdStruct=0;
	var curDomain=0;
	var output=0;
	var qC=0;
	var i2=0;
	var qSites=0;
	var curDSStruct=0;
	var qSites2=0;
	var curTableStruct=0;
	var arr7z2=0;
	var row=0;
	var limitSQL=0;
	var i3=0;
	var x1=0;
	var tempStruct=0;
	var arrDatasource=0;
	var a241=0;
	var d=0;
	var qs=0;
	var backupDatabaseStruct=0;
	var dbauth=0;
	var qT=0;
	var schemaData=0;
	var ds=0;
	var db2=0;
	var i=0;
	var arr7z=0;
	var arrSchema=0;
	var qd=0;
	var d2=0;
	var outfileOptions=0;
	var db=request.zos.noVerifyQueryObject;
	setting requesttimeout="5000";
	
	variables.tempPathName="-temp";
	local.backupGlobal=1;
	form.createNew=application.zcore.functions.zso(form, 'createNew', false, 0);
	form.backupType=application.zcore.functions.zso(form, 'backupType');
	if(form.backupType EQ 1 or form.backupType EQ 2){
		variables.tempPathName="";
		local.backupGlobal=0;
	}else if(form.backupType EQ "" or form.backupType EQ 3){
		local.backupGlobal=1;
	}
	form.sid=application.zcore.functions.zso(form, 'sid', true, 0);
	
	if(form.createNew EQ 0 and form.backupType EQ 3){
		if(fileexists(request.zos.backupDirectory&"global-database.tar")){
			variables.downloadGlobal();
		}
	}
	request.ignoreSlowScript=true;
	backupDatabaseStruct=structnew();
	for(i=1;i LTE arraylen(application.zcore.arrGlobalDatasources);i++){
		backupDatabaseStruct[application.zcore.arrGlobalDatasources[i]]=0; 
	}
	local.siteSQL="";
	if(form.sid NEQ 0){
		local.siteSQL=" and site.site_id='"&application.zcore.functions.zescape(form.sid)&"'";	
	}
	
	db.sql="select * from #db.table("site", request.zos.zcoredatasource)# site 
	where site_active='1' 
	#local.siteSQL# ";
	qs=db.execute("qs"); 
	local.sitePathStruct={};
	local.sitePathMySQLStruct={};
	local.siteRestoreStruct={};
	for(local.row in qs){
		curDomainOriginal=replace(replace(local.row.site_short_domain,"www.",""),"."&request.zos.testDomain,"");
		curDomain=replace(curDomainOriginal, ".", "_", "all");
		local.tempPath=request.zos.backupDirectory&"site-archives#variables.tempPathName#/"&curDomain&"/";
		if(form.createNew EQ 0){
			if(form.backupType EQ 1){
				if(fileexists(request.zos.backupDirectory&"site-archives#variables.tempPathname#/"&curDomainOriginal&'.tar')){
					variables.downloadSite(form.sid, curDomainOriginal);
				}
			}
		}
		if(form.backupType EQ 2){
			local.tempPathUpload=request.zos.backupDirectory&'site-archives#variables.tempPathName#/'&curDomainOriginal&'-zupload.tar.gz';
			if(form.createNew EQ 1 or not fileexists(local.tempPathUpload)){
				application.zcore.functions.zdeletefile(local.tempPathUpload);
				// isTarred=application.zcore.functions.zTarZipFilePath("myTarball.tar.gz", "/opt/jetendo/sites/", "/opt/jetendo/sites/basicdemo_farbeyondcode_com/", 20);
				//('/bin/tar', '-cvzf  "#local.tempPathUpload#" -C "#request.zos.installPath#sites/#curDomain#/zupload/" * ', 3600);
			}
			variables.downloadSiteUpload(form.sid, curDomainOriginal);
		}
		if(variables.tempPathName EQ ""){
			application.zcore.functions.zdeletedirectory(local.tempPath);
		}
		local.sitePathStruct[local.row.site_id]=local.tempPath;
		local.sitePathMySQLStruct[local.row.site_id]=request.zos.mysqlBackupDirectory&"site-archives#variables.tempPathName#/"&curDomain&"/";
		application.zcore.functions.zcreatedirectory(local.tempPath);
		application.zcore.functions.zcreatedirectory(local.tempPath&"database/");
		local.siteRestoreStruct[local.row.site_id]=[];
		application.zcore.functions.zwritefile(local.tempPath&"globals.json", serializeJSON(local.row));
	}
	
	db.sql="SELECT site_id, site_datasource FROM `#request.zos.zcoreDatasource#`.`site`  site
	WHERE site_active='1' AND
	site_id <> -1 AND 
	site_datasource<>'' 
	#local.siteSQL#
	GROUP BY site_datasource";
	qSites=db.execute("qSites");
	for(local.row in qSites){
		if(not structkeyexists(backupDatabaseStruct, local.row.site_datasource)){
			if(not structkeyexists(request.zos.excludeDatasourcesFromBackup, local.row.site_datasource)){
				backupDatabaseStruct[local.row.site_datasource]=local.row.site_id;
			}
		}
	}
	arrDatasource=structkeyarray(backupDatabaseStruct);
	curDSStruct=structnew();
	for(x1=1;x1 LTE arraylen(arrDatasource);x1++){
		ds=arrDatasource[x1];
		if(not structkeyexists(request.zos.excludeDatasourcesFromBackup, ds) and structkeyexists(backupDatabaseStruct, ds)){
			curDSStruct=application.zcore.functions.zGetDatabaseStructure(ds, curDSStruct);
		}
	}
	
	d=arraynew(1);
	d2=arraynew(1);
	d3=arraynew(1);
	dbauth=' --host="hostdevmachine" --user="devadmin" --password="3292hay"';
	if(variables.tempPathName NEQ ""){
		application.zcore.functions.zDeleteDirectory("#request.zos.backupDirectory#site-archives-old/");
		application.zcore.functions.zDeleteDirectory("#request.zos.backupDirectory#site-archives#variables.tempPathName#/");
		application.zcore.functions.zcreatedirectory("#request.zos.backupDirectory#site-archives#variables.tempPathName#/");
	}
	if(local.backupGlobal EQ 1){
		application.zcore.functions.zDeleteDirectory("#request.zos.backupDirectory#database-global-backup/");
		application.zcore.functions.zcreatedirectory("#request.zos.backupDirectory#database-global-backup/");
		application.zcore.functions.zDeleteDirectory("#request.zos.backupDirectory#database-schema/");
	}
	application.zcore.functions.zcreatedirectory("#request.zos.backupDirectory#database-schema/");
	outfileOptions="FIELDS TERMINATED BY '\t' ENCLOSED BY '""' ESCAPED BY '\\' LINES TERMINATED BY '\n' ";
	if(request.zos.istestserver){
		limitSQL="";
		limitSQL=" LIMIT 0,10"; // comment to test all data
	}else{
		limitSQL="";	
	}
	
	arrayClear(request.zos.arrQueryLog);
	
	local.zeroSiteIdTableBackupCacheStruct={};
	
	for(i2 in backupDatabaseStruct){
		local.schemaStruct=this.generateSchemaBackup(i2, curDSStruct);
		application.zcore.functions.zwritefile(request.zos.backupDirectory&"database-schema/"&i2&".sql", local.schemaStruct.sql);
		application.zcore.functions.zwritefile(request.zos.backupDirectory&"database-schema/"&i2&".json", local.schemaStruct.struct); 
	}
	for(i2 in curDSStruct.globalTableStruct){
		if(i2 EQ request.zos.zcoreDatasource){
			continue; // this is a structure only database - skip it
		}
		local.curSiteId=backupDatabaseStruct[i2];
		if(local.curSiteId NEQ 0){
			application.zcore.functions.zcreatedirectory(local.sitePathStruct[local.curSiteId]&"database/"&i2&"/");
		}else if(local.backupGlobal EQ 1){
			application.zcore.functions.zcreatedirectory("#request.zos.backupDirectory#database-global-backup/"&i2&"/");
		}
		for(n in curDSStruct.globalTableStruct[i2]){
			if(structkeyexists(request.zos.backupStructureOnlyTables, i2&"."&n)){
				continue;	
			}
			local.tempColumnList="`"&arrayToList(curDSStruct.fieldArrayStruct[i2&"."&n], "`, `")&"`";
			if(left(n, len(request.zos.ramtableprefix)) NEQ request.zos.ramtableprefix){
				if(local.curSiteId NEQ 0){
					db.sql="select #local.tempColumnList# from `"&i2&"`.`"&n&"`"&limitSQL&" 
					into outfile '#local.sitePathMySQLStruct[local.curSiteId]#database/"&i2&"/"&n&".tsv' #outfileOptions#;";
					db.execute("qd");
					
					local.sql="truncate table `"&i2&"`.`"&n&"`;";
					arrayappend(local.siteRestoreStruct[local.curSiteId], local.sql);
					local.sql="load data infile '/ZIMPORTPATH/database/"&i2&"/"&n&".tsv' 
					into table `"&i2&"`.`"&n&"` #outfileOptions# (#local.tempColumnList#);";
					arrayappend(local.siteRestoreStruct[local.curSiteId], local.sql);
				}else if(local.backupGlobal EQ 1){
					db.sql="select #local.tempColumnList# from `"&i2&"`.`"&n&"`"&limitSQL&" 
					into outfile '#request.zos.mysqlBackupDirectory#database-global-backup/"&i2&"/"&n&".tsv' #outfileOptions#;";
					db.execute("qd");
					
					local.sql="truncate table `"&i2&"`.`"&n&"`;";
					arrayappend(d3, local.sql);
					local.sql="load data infile '/ZIMPORTPATH/database-global-backup/"&i2&"/"&n&".tsv' 
					into table `"&i2&"`.`"&n&"` #outfileOptions# (#local.tempColumnList#);";
					arrayappend(d3, local.sql);
				}
			}
		}
	}
	
	for(i2 in curDSStruct.siteTableStruct){
		local.curSiteId=backupDatabaseStruct[i2];
		for(n in curDSStruct.siteTableStruct[i2]){
			if(structkeyexists(request.zos.backupStructureOnlyTables, i2&"."&n)){
				continue;	
			}
			db.sql="select site_id from #db.table(n, i2)# site";
			if(form.sid NEQ 0){
				db.sql&=" where site_id in (#db.param(0)#, #db.param(form.sid)#) ";
			}
			db.sql&=" group by site.site_id";
			qs=db.execute("qs"); 
			if(qs.recordcount NEQ 0){
				local.tempColumnList="`"&arrayToList(curDSStruct.fieldArrayStruct[i2&"."&n], "`, `")&"`";
				for(g=1;g LTE qs.recordcount;g++){
					if(qs.site_id[g] NEQ 0 and not structkeyexists(local.sitePathStruct, qs.site_id[g])){
						continue; // inactive site_id
					}
					if(qs.site_id[g] NEQ 0 and not directoryexists(local.sitePathStruct[qs.site_id[g]]&"database/"&i2&"/")){
						application.zcore.functions.zcreatedirectory(local.sitePathStruct[qs.site_id[g]]&"database/"&i2&"/");
					}
					if(qs.site_id[g] EQ 0){
						 if(local.backupGlobal EQ 1 and local.curSiteId EQ 0  and not structkeyexists(local.zeroSiteIdTableBackupCacheStruct, i2&"."&n)){
							local.zeroSiteIdTableBackupCacheStruct[i2&"."&n]=true;
							application.zcore.functions.zcreatedirectory("#request.zos.backupDirectory#database-global-backup/"&i2&"/");
							db.sql="select #local.tempColumnList# from `"&i2&"`.`"&n&"` where site_id ='0' "&limitSQL&" 
							into outfile '#request.zos.mysqlBackupDirectory#database-global-backup/"&i2&"/"&n&".tsv' #outfileOptions#;";
							qd=db.execute("qd");
							local.sql="delete from `"&i2&"`.`"&n&"` WHERE site_id = '0';";
							arrayappend(d3, local.sql);
							local.sql="load data infile '/ZIMPORTPATH/database-global-backup/"&i2&"/"&n&".tsv' into table `"&i2&"`.`"&n&"` #outfileOptions# (#local.tempColumnList#);";
							arrayappend(d3, local.sql);
						}
					}else{
						db.sql="select #local.tempColumnList# from `"&i2&"`.`"&n&"` where site_id ='"&qs.site_id[g]&"' "&limitSQL&" 
						into outfile '#local.sitePathMySQLStruct[qs.site_id[g]]#database/"&i2&"/"&n&".tsv' #outfileOptions#;";
						qd=db.execute("qd");
						local.sql="load data infile '/ZIMPORTPATH/database/"&i2&"/"&n&".tsv' into table `"&i2&"`.`"&n&"` #outfileOptions# (#local.tempColumnList#);";
						arrayappend(local.siteRestoreStruct[qs.site_id[g]], local.sql);
					}
				}
			}
		}
	}
	if(local.backupGlobal EQ 1){
		for(i=1;i LTE arraylen(d3);i++){
			d3[i]=replace(replace(d3[i], chr(10), " ", "all"), chr(13), "", "all");
		}
		application.zcore.functions.zwritefile(request.zos.backupDirectory&"restore-global-database.sql", arraytolist(d3, chr(10)));
	}
	for(i2 in local.siteRestoreStruct){
		for(i=1;i LTE arraylen(local.siteRestoreStruct[i2]);i++){
			local.siteRestoreStruct[i2][i]=replace(replace(local.siteRestoreStruct[i2][i], chr(10), " ", "all"), chr(13), "", "all");
		}
		application.zcore.functions.zwritefile(local.sitePathStruct[i2]&"restore-site-database.sql", arraytolist(local.siteRestoreStruct[i2], chr(10)));
	}
	
	
	
	db.sql="select site.*, group_concat(app_x_site.app_id SEPARATOR #db.param(',')#) appidlist 
	from `#request.zos.zcoreDatasource#`.`site` 
	left join #db.table("app_x_site", request.zos.zcoreDatasource)# app_x_site ON 
	app_x_site.site_id = site.site_id 
	WHERE site_active=#db.param('1')# AND 
	site.site_id <> #db.param(request.zos.globals.serverid)# 
	#local.siteSQL#
	GROUP BY site.site_id ";
	qSites2=db.execute("qSites2");
	
	
	
	for(row in qSites2){
		arr7z=arraynew(1);
		arrD=listtoarray(row.appidlist,',');
		appIdStruct=structnew();
		for(i=1;i LTE arraylen(arrD);i++){
			appIdStruct[arrD[i]]=true;
		}
		curDomainOriginal=replace(replace(row.site_short_domain,"www.",""),"."&request.zos.testDomain,"");
		curDomain=replace(curDomainOriginal, ".", "_", "all");
		curTableStruct=structnew();
		curTableStruct[request.zos.zcoreDatasource]=true;
		if(structkeyexists(appIdStruct, 11)){
			// has listing app
			curTableStruct[request.zos.zcoreDatasource]=true;
			curTableStruct[request.zos.zcoreDatasource]=true;
		}
		if(structkeyexists(appIdStruct, 13)){
			// has rental app
			curTableStruct[request.zos.zcoreDatasource]=true;
		}
		if(row.site_datasource NEQ ""){
			curTableStruct[row.site_datasource]=true;
		}
		for(i2 in curTableStruct){
			arrayappend(arr7z, '"database-schema/#i2#.sql" ');
			arrayappend(arr7z, '"database-schema/#i2#.json" ');
		}
		if(local.backupGlobal EQ 1){
			application.zcore.functions.zdeletefile(request.zos.backupDirectory&'site-archives#variables.tempPathName#/'&curDomainOriginal&'-zupload.tar.gz');
			// isTarred=application.zcore.functions.zTarZipFilePath("myTarball.tar.gz", "/opt/jetendo/sites/", "/opt/jetendo/sites/basicdemo_farbeyondcode_com/", 20);
			//('/bin/tar', '-cvzf  "#request.zos.backupDirectory#site-archives#variables.tempPathName#/#curDomainOriginal#-zupload.tar.gz" -C "#request.zos.installPath#sites/#curDomain#/zupload/" * ', 3600);
		}
		application.zcore.functions.zDeleteFile(request.zos.backupDirectory&'site-archives#variables.tempPathName#/'&curDomainOriginal&'.tar.gz');
		
		// isTarred=application.zcore.functions.zTarZipFilePath("myTarball.tar.gz", "/opt/jetendo/sites/", "/opt/jetendo/sites/basicdemo_farbeyondcode_com/", 20);
		//('/bin/tar', '-cvzf  "#request.zos.backupDirectory#site-archives#variables.tempPathName#/#curDomainOriginal#.tar.gz"  -C "#request.zos.backupDirectory#" #arraytolist(arr7z, " ")# -C "#request.zos.backupDirectory#site-archives#variables.tempPathName#/#curDomain#/"  restore-site-database.sql database globals.json -C "#request.zos.installPath#/sites/" --exclude=zupload --transform "s/^#curDomain#/files/" #curDomain#', 3600);
		application.zcore.functions.zDeleteDirectory(request.zos.backupDirectory&'site-archives#variables.tempPathName#/#curDomain#/');
		if(request.zos.istestserver){
			break; // uncomment for faster debugging of backup script.
		}
	}
	if(local.backupGlobal EQ 1){
		application.zcore.functions.zDeleteFile("#request.zos.backupDirectory#global-database.tar.gz");
		
		// isTarred=application.zcore.functions.zTarZipFilePath("myTarball.tar.gz", "/opt/jetendo/sites/", "/opt/jetendo/sites/basicdemo_farbeyondcode_com/", 20);
		//('/bin/tar', '-cvzf  "#request.zos.backupDirectory#global-database.tar.gz" -C "#request.zos.backupDirectory#" restore-global-database.sql database-global-backup/ database-schema/', 3600);
		application.zcore.functions.zDeleteDirectory("#request.zos.backupDirectory#database-schema/");
		application.zcore.functions.zDeleteDirectory("#request.zos.backupDirectory#database-global-backup/");
		application.zcore.functions.zDeleteFile("#request.zos.backupDirectory#restore-global-database.sql");
	}
	if(variables.tempPathName NEQ ""){
		if(directoryexists("#request.zos.backupDirectory#site-archives/")){
			directoryRename("#request.zos.backupDirectory#site-archives/", "#request.zos.backupDirectory#site-archives-old/");
		}
		directoryRename("#request.zos.backupDirectory#site-archives#variables.tempPathName#/", "#request.zos.backupDirectory#site-archives/");
		application.zcore.functions.zDeleteDirectory("#request.zos.backupDirectory#site-archives-old/");
	}
	
	if(form.backupType EQ 1){
		variables.downloadSite(form.sid, curDomainOriginal);
	}else if(form.backupType EQ 3){
		variables.downloadGlobal();
	}else{
		writeoutput('Done');
	}
	</cfscript>
</cffunction>
</cfoutput>
</cfcomponent>