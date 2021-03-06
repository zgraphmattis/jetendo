<cfcomponent implements="zcorerootmapping.interface.databaseVersion">
<cfoutput>
<cffunction name="getChangedTableArray" localmode="modern" access="public" returntype="array">
	<cfscript>
	arr1=[];
	return arr1;
	</cfscript>
</cffunction>

<cffunction name="executeUpgrade" localmode="modern" access="public" returntype="boolean">
	<cfargument name="dbUpgradeCom" type="component" required="yes">
	<cfscript>	
	siteBackupCom=createobject("component", "zcorerootmapping.mvc.z.server-manager.tasks.controller.site-backup");
	ts=siteBackupCom.getExcludedTableStruct();


	if(!arguments.dbUpgradeCom.executeQuery(this.datasource, "ALTER TABLE `city_memory`  
		ADD COLUMN `city_updated_datetime` DATETIME NOT NULL, 
		ADD COLUMN `city_deleted` CHAR(1) DEFAULT '0'   NOT NULL")){
		return false;
	}
	if(!arguments.dbUpgradeCom.executeQuery(this.datasource, "ALTER TABLE `city_distance_memory`  
		ADD COLUMN `city_distance_updated_datetime` DATETIME NOT NULL, 
		ADD COLUMN `city_distance_deleted` CHAR(1) DEFAULT '0'   NOT NULL")){
		return false;
	}
	if(!arguments.dbUpgradeCom.executeQuery(this.datasource, "ALTER TABLE `listing_memory` 
		ADD COLUMN `listing_deleted` CHAR(1) DEFAULT '0'   NOT NULL")){
		return false;
	}
	for(i in application.zcore.tableColumns){
		c=application.zcore.tableColumns[i];
		sql="";
		table=listgetat(i, 2, '.');
		if(structkeyexists(ts, table)){
			continue;
		}
		if(table EQ "city_distance_safe_update"){
			continue;
		}
		if(not structkeyexists(c, '#table#_updated_datetime')){
			sql="ALTER TABLE `#table#`  ADD COLUMN `#table#_updated_datetime` DATETIME NOT NULL ";
			if(not structkeyexists(c, '#table#_deleted')){
				sql&=", ADD COLUMN `#table#_deleted` CHAR(1) DEFAULT '0'   NOT NULL  ";
			}
		}else{
			if(not structkeyexists(c, '#table#_deleted')){
				sql="ALTER TABLE `#table#`   ADD COLUMN `#table#_deleted` CHAR(1) DEFAULT '0'   NOT NULL  ";
			}
		}
		if(sql NEQ ""){
			if(!arguments.dbUpgradeCom.executeQuery(this.datasource, sql)){
				return false;
			}
		}
	}
	if(!arguments.dbUpgradeCom.executeQuery(this.datasource, "ALTER TABLE `city_distance_safe_update`  
		ADD COLUMN `city_distance_updated_datetime` DATETIME NOT NULL, 
		ADD COLUMN `city_distance_deleted` CHAR(1) DEFAULT '0'   NOT NULL")){
		return false;
	}
	return true;
	</cfscript>
</cffunction>
</cfoutput>
</cfcomponent>