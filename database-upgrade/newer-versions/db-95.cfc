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
	if(!arguments.dbUpgradeCom.executeQuery(this.datasource, "ALTER TABLE `paypal_ipn_log`   
  ADD COLUMN `paypal_ipn_log_processed` CHAR(1) DEFAULT '0'  NOT NULL AFTER `paypal_ipn_log_deleted`")){
		return false;
	}  
	return true;
	</cfscript>
</cffunction>
</cfoutput>
</cfcomponent>