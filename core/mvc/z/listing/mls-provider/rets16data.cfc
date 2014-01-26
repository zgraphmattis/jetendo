<cfcomponent>
<cfoutput>
	<cfscript>
    variables.idxExclude=structnew();
variables.allfields=structnew();
    </cfscript>
	<cffunction name="findFieldsInDatabaseNotBeingOutput" localmode="modern" output="yes" returntype="any">
		<cfscript>
		var db=request.zos.queryObject;
		</cfscript>
    	not implemented - see rets7 for how to implement.
		<cfscript>application.zcore.functions.zabort();</cfscript>
	</cffunction>

    <cffunction name="getDetailCache1" localmode="modern" output="yes" returntype="string">
      <cfargument name="idx" type="struct" required="yes">
      <cfscript>
		var arrR=arraynew(1);
		var idxTemp2=structnew();
		//idxTemp2["rets16_property_id"]="property id:";
		idxTemp2["rets16_1"]="Property Type:";
		idxTemp2["rets16_10"]="Zip Code:";
		idxTemp2["rets16_100"]="Additional Furnished Info.:";
		idxTemp2["rets16_1000"]="Unit 7 - A Rent:";
		idxTemp2["rets16_1002"]="Unit 7 - B Rent:";
		idxTemp2["rets16_101"]="Furnished Info (Sold):";
		idxTemp2["rets16_1016"]="Unit 1 Hotel Room:";
		idxTemp2["rets16_1018"]="Unit 2 Hotel Room:";
		idxTemp2["rets16_102"]="## Garage Spaces:";
		idxTemp2["rets16_1020"]="Unit 3 Hotel Room:";
		idxTemp2["rets16_1022"]="Unit 4 Hotel Room:";
		idxTemp2["rets16_1024"]="Unit 1 Efficiency:";
		idxTemp2["rets16_1026"]="Unit 2 Efficiency:";
		idxTemp2["rets16_1028"]="Unit 3 Efficiency:";
		idxTemp2["rets16_103"]="Garage Description:";
		idxTemp2["rets16_1030"]="Unit 4 Efficiency:";
		idxTemp2["rets16_1032"]="Unit 1 ## of Beds:";
		idxTemp2["rets16_1034"]="Unit 2 ## of Beds:";
		idxTemp2["rets16_1036"]="Unit 3 ## of Beds:";
		idxTemp2["rets16_1038"]="Unit 4 ## of Beds:";
		idxTemp2["rets16_1040"]="Unit 1 ## of HBaths:";
		idxTemp2["rets16_1042"]="Unit 2 ## of HBaths:";
		idxTemp2["rets16_1044"]="Unit 3 ## of HBaths:";
		idxTemp2["rets16_1046"]="Unit 4 ## of HBaths:";
		idxTemp2["rets16_1048"]="Unit 1 Sq.Ft:";
		idxTemp2["rets16_1050"]="Unit 2 Sq.Ft:";
		idxTemp2["rets16_1052"]="Unit 3 Sq.Ft:";
		idxTemp2["rets16_1054"]="Unit 4 Sq.Ft:";
		idxTemp2["rets16_1056"]="Unit 1 Monthly Income:";
		idxTemp2["rets16_1058"]="Unit 2 Monthly Income:";
		idxTemp2["rets16_106"]="Geographic Area:";
		idxTemp2["rets16_1060"]="Unit 3 Monthly Income:";
		idxTemp2["rets16_1062"]="Unit 4 Monthly Income:";
		idxTemp2["rets16_1064"]="Unit 1 Furniture Info.:";
		idxTemp2["rets16_1066"]="Unit 2 Furniture Info.:";
		idxTemp2["rets16_1068"]="Unit 3 Furniture Info.:";
		idxTemp2["rets16_107"]="SqFt L.A. of Guest House:";
		idxTemp2["rets16_1070"]="Unit 4 Furniture Info.:";
		idxTemp2["rets16_1072"]="Unit 1 Lease Ends Info.:";
		idxTemp2["rets16_1074"]="Unit 2 Lease Ends Info.:";
		idxTemp2["rets16_1076"]="Unit 3 Lease Ends Info.:";
		idxTemp2["rets16_1078"]="Unit 4 Lease Ends Info.:";
		idxTemp2["rets16_108"]="Guest House Description:";
		idxTemp2["rets16_1080"]="Unit 1 ## of Units:";
		idxTemp2["rets16_1082"]="Unit 2 ## of Units:";
		idxTemp2["rets16_1084"]="Unit 3 ## of Units:";
		idxTemp2["rets16_1086"]="Unit 4 ## of Units:";
		idxTemp2["rets16_1088"]="Directions:";
		idxTemp2["rets16_109"]="Half Baths:";
		idxTemp2["rets16_11"]="Zip Code (Last 4 Digits):";
		idxTemp2["rets16_110"]="Heating Description:";
		idxTemp2["rets16_111"]="Type of Association:";
		//idxTemp2["rets16_113"]="I##:";
		//idxTemp2["rets16_114"]="Internet:";
		//idxTemp2["rets16_115"]="Internet Remarks:";
		idxTemp2["rets16_116"]="Interior Features:";
		idxTemp2["rets16_1223"]="Virtual Tour:";
		idxTemp2["rets16_123"]="Irrig:";
		idxTemp2["rets16_124"]="Irrig2:";
		idxTemp2["rets16_126"]="Kitchen Dimensions:";
		//idxTemp2["rets16_127"]="Agent License ##:";
		idxTemp2["rets16_129"]="SqFt Liv Area:";
		//idxTemp2["rets16_130"]="Last Transaction Code:";
		//idxTemp2["rets16_131"]="Last Transaction Date:";
		//idxTemp2["rets16_1329"]="Last Img Trans Date:";
		idxTemp2["rets16_1339"]="Legal Description:";
		//idxTemp2["rets16_134"]="List Broker Code:";
		//idxTemp2["rets16_136"]="List Agent Public Id:";
		idxTemp2["rets16_137"]="List Price:";
		//idxTemp2["rets16_14"]="Co-Listing Agent Name:";
		idxTemp2["rets16_140"]="Lot or Track##:";
		idxTemp2["rets16_141"]="Lot Description:";
		idxTemp2["rets16_1410"]="Housing-Older Persons Act:";
		idxTemp2["rets16_142"]="Low List Price:";
		idxTemp2["rets16_1424"]="Full Baths:";
		idxTemp2["rets16_1426"]="Half Baths:";
		idxTemp2["rets16_143"]="Living Room Dimensions:";
		idxTemp2["rets16_1430"]="Subdivision/Complex/Bldg.:";
		//idxTemp2["rets16_144"]="Listing Agent's Name:";
		idxTemp2["rets16_145"]="Approximate Lot Size:";
		idxTemp2["rets16_146"]="Listing Type:";
		idxTemp2["rets16_1465"]="Short Sale:";
		idxTemp2["rets16_147"]="Maintenance Includes:";
		idxTemp2["rets16_1473"]="REO:";
		//idxTemp2["rets16_1488"]="Address on Internet:";
		idxTemp2["rets16_1487"]="Address:";
		idxTemp2["rets16_149"]="Master Bedroom Dimensions:";
		idxTemp2["rets16_150"]="Municipal Code:";
		idxTemp2["rets16_152"]="Manufactured Home Miscell:";
		idxTemp2["rets16_157"]="MLS ##:";
		idxTemp2["rets16_158"]="Model Name:";
		idxTemp2["rets16_160"]="Membership Purch Rqd:";
		idxTemp2["rets16_161"]="Membership Purchase Fee:";
		idxTemp2["rets16_162"]="Master Bathroom Description:";
		idxTemp2["rets16_163"]="## Stories:";
		idxTemp2["rets16_164"]="Occupancy Information:";
		//idxTemp2["rets16_165"]="Office Name:";
		//idxTemp2["rets16_167"]="Listing Office Phone:";
		//idxTemp2["rets16_17"]="Unit Number:";
		idxTemp2["rets16_177"]="Parking Description:";
		idxTemp2["rets16_178"]="Parking Restrictions:";
		idxTemp2["rets16_179"]="Patio/Balcony Dimensions:";
		//idxTemp2["rets16_18"]="Agent Phone:";
		idxTemp2["rets16_180"]="Pet Restrictions:";
		idxTemp2["rets16_181"]="Pets Allowed:";
		//idxTemp2["rets16_183"]="Agent Alternate Phone:";
		//idxTemp2["rets16_188"]="Co-Agent Public Id:";
		idxTemp2["rets16_189"]="Pool Dimensions:";
		idxTemp2["rets16_19"]="Area:";
		idxTemp2["rets16_190"]="Parcel Number:";
		idxTemp2["rets16_191"]="Pool:";
		idxTemp2["rets16_192"]="Pool Description:";
		idxTemp2["rets16_193"]="Porch Dimensions:";
		idxTemp2["rets16_194"]="Possession Information:";
		//idxTemp2["rets16_195"]="IDX:";
		idxTemp2["rets16_2"]="5th Bedroom Dimensions:";
		idxTemp2["rets16_21"]="Assoc Fee Paid Per:";
		idxTemp2["rets16_211"]="Range Price:";
		idxTemp2["rets16_213"]="Record Delete Flag:";
		//idxTemp2["rets16_214"]="Remarks:";
		idxTemp2["rets16_216"]="Restrictions:";
		idxTemp2["rets16_219"]="Roof Description:";
		idxTemp2["rets16_22"]="Assumable:";
		idxTemp2["rets16_220"]="Rooms Description:";
		idxTemp2["rets16_227"]="Section:";
		idxTemp2["rets16_232"]="Property SqFt:";
		//idxTemp2["rets16_234"]="Showing Instructions:";
		idxTemp2["rets16_235"]="Subdivision Name:";
		idxTemp2["rets16_238"]="Spa:";
		idxTemp2["rets16_239"]="Special Information:";
		idxTemp2["rets16_241"]="Sprinkler Description:";
		//idxTemp2["rets16_246"]="Status:";
		//idxTemp2["rets16_247"]="Street Name:";
		//idxTemp2["rets16_248"]="Street Number:";
		//idxTemp2["rets16_249"]="Street Suffix:";
		idxTemp2["rets16_25"]="Bedrooms:";
		//idxTemp2["rets16_250"]="Map Coordinates:";
		idxTemp2["rets16_251"]="Style:";
		idxTemp2["rets16_254"]="Subdivision Information:";
		idxTemp2["rets16_258"]="Sewer Description:";
		idxTemp2["rets16_26"]="Bed2:";
		idxTemp2["rets16_260"]="Manufactured Home Size:";
		idxTemp2["rets16_261"]="Approx. Sqft Total Area:";
		idxTemp2["rets16_263"]="Tax Information:";
		idxTemp2["rets16_264"]="Folio Number:";
		idxTemp2["rets16_266"]="Total Mortgage:";
		idxTemp2["rets16_267"]="Township/Range:";
		idxTemp2["rets16_27"]="Bed3:";
		idxTemp2["rets16_274"]="Tax Amount:";
		idxTemp2["rets16_275"]="Tax Year:";
		idxTemp2["rets16_276"]="Type of Property:";
		idxTemp2["rets16_277"]="Un:";
		idxTemp2["rets16_28"]="2nd Bedroom Dimensions:";
		idxTemp2["rets16_283"]="Utility Room Dimension:";
		idxTemp2["rets16_285"]="View:";
		idxTemp2["rets16_289"]="Waterfront Frontage:";
		idxTemp2["rets16_29"]="3rd Bedroom Dimensions:";
		idxTemp2["rets16_290"]="Windows/Treatment:";
		idxTemp2["rets16_291"]="Water Description:";
		idxTemp2["rets16_294"]="Water Access:";
		idxTemp2["rets16_295"]="Waterfront Property (Y/N):";
		idxTemp2["rets16_296"]="Waterfront Description:";
		idxTemp2["rets16_30"]="4th Bedroom Dimensions:";
		idxTemp2["rets16_31"]="Bedroom Description:";
		idxTemp2["rets16_314"]="Year Built:";
		idxTemp2["rets16_315"]="Year Built Description:";
		idxTemp2["rets16_318"]="Zoning Information:";
		idxTemp2["rets16_319"]="Amenities:";
		idxTemp2["rets16_320"]="Application Fee:";
		idxTemp2["rets16_321"]="Approval Information:";
		idxTemp2["rets16_322"]="Balcony, Porch and/or Patio:";
		idxTemp2["rets16_325"]="Building Name/Number:";
		idxTemp2["rets16_326"]="Complex Name:";
		idxTemp2["rets16_327"]="Carport Description:";
		idxTemp2["rets16_328"]="Property Detached:";
		idxTemp2["rets16_329"]="Dining Description:";
		idxTemp2["rets16_331"]="Efficiency:";
		idxTemp2["rets16_332"]="Equipment/Appliances:";
		idxTemp2["rets16_333"]="Exterior Features:";
		idxTemp2["rets16_334"]="Front Exposure:";
		idxTemp2["rets16_335"]="Unit Floor Location:";
		idxTemp2["rets16_336"]="Floor Description:";
		idxTemp2["rets16_337"]="Garage Description:";
		idxTemp2["rets16_338"]="Type of Governing Bodies:";
		idxTemp2["rets16_341"]="Interior Features:";
		idxTemp2["rets16_342"]="Land Lease Amount:";
		idxTemp2["rets16_351"]="Minimum ## of Days for Lease:";
		idxTemp2["rets16_352"]="Main Living Area:";
		idxTemp2["rets16_353"]="Master Bathroom Description:";
		idxTemp2["rets16_354"]="##Times Leased/Year:";
		idxTemp2["rets16_355"]="Parking Description:";
		idxTemp2["rets16_356"]="Parking Space Number:";
		idxTemp2["rets16_360"]="Patio/Balcony Dimensions:";
		idxTemp2["rets16_361"]="Rec Lease/Month:";
		idxTemp2["rets16_362"]="Restrictions:";
		idxTemp2["rets16_364"]="Security Information:";
		//idxTemp2["rets16_365"]="Showing Instructions:";
		idxTemp2["rets16_366"]="Special Information:";
		idxTemp2["rets16_367"]="Style:";
		idxTemp2["rets16_368"]="Total Floors In Building:";
		idxTemp2["rets16_369"]="Terms Considered:";
		idxTemp2["rets16_370"]="Type of Property:";
		idxTemp2["rets16_372"]="Unit Design:";
		idxTemp2["rets16_373"]="Total ## of Units In Building:";
		idxTemp2["rets16_374"]="Total ## of Units In Complex:";
		idxTemp2["rets16_375"]="Unit View:";
		idxTemp2["rets16_376"]="Windows/Treatment:";
		idxTemp2["rets16_384"]="Exp Incl Acctg/Legal:";
		idxTemp2["rets16_385"]="Exp Incl Adv/Lic/Permit:";
		idxTemp2["rets16_387"]="County Land Code:";
		idxTemp2["rets16_389"]="Exp Incl Electric:";
		//idxTemp2["rets16_39"]="Board Identifier:";
		idxTemp2["rets16_390"]="Unit 1 Equipment:";
		idxTemp2["rets16_391"]="Unit 2 Equipment:";
		idxTemp2["rets16_392"]="Unit 3 Equipment:";
		idxTemp2["rets16_394"]="Exterior Features:";
		idxTemp2["rets16_395"]="Exp Incl Extermination:";
		idxTemp2["rets16_396"]="Unit 1 ## of FBaths:";
		idxTemp2["rets16_397"]="Unit 2 ## of FBaths:";
		idxTemp2["rets16_398"]="Unit 3 ## of FBaths:";
		idxTemp2["rets16_399"]="Unit 4 ## of FBaths:";
		idxTemp2["rets16_400"]="Floor Description:";
		idxTemp2["rets16_402"]="Gas Description:";
		idxTemp2["rets16_403"]="Exp Incl Gas/Oil:";
		idxTemp2["rets16_404"]="Gross Rent Income:";
		idxTemp2["rets16_407"]="Information Available:";
		idxTemp2["rets16_408"]="Exp Incl Insurance:";
		idxTemp2["rets16_737"]="## Employees:";
		idxTemp2["rets16_409"]="Exp Incl Janitor:";
		idxTemp2["rets16_410"]="Exp Incl Lawn Maintenance:";
		idxTemp2["rets16_412"]="Exp Incl Maint and Repair:";
		idxTemp2["rets16_413"]="Exp Incl Management:";
		idxTemp2["rets16_414"]="Exp Incl Miscellaneous:";
		idxTemp2["rets16_416"]="Net Operating Income:";
		idxTemp2["rets16_417"]="## Parking Spaces:";
		idxTemp2["rets16_419"]="Unit 1 Parking:";
		idxTemp2["rets16_420"]="Unit 2 Parking:";
		idxTemp2["rets16_421"]="Unit 3 Parking:";
		idxTemp2["rets16_422"]="Unit 4 Parking:";
		idxTemp2["rets16_424"]="Pool Description:";
		idxTemp2["rets16_425"]="Exp Incl Pool Service:";
		idxTemp2["rets16_426"]="Exp Incl Property Tax:";
		idxTemp2["rets16_427"]="Exp Incl Replace/Reserve:";
		idxTemp2["rets16_428"]="Exp Incl Retax:";
		idxTemp2["rets16_429"]="Rent Includes:";
		idxTemp2["rets16_430"]="Unit 1 Room Description:";
		idxTemp2["rets16_431"]="Unit 2 Room Description:";
		idxTemp2["rets16_432"]="Unit 3 Room Description:";
		idxTemp2["rets16_433"]="Unit 4 Room Description:";
		idxTemp2["rets16_434"]="Separate Meter:";
		idxTemp2["rets16_435"]="Special Information:";
		idxTemp2["rets16_437"]="Style:";
		idxTemp2["rets16_438"]="Property Type Information:";
		idxTemp2["rets16_439"]="Exp Incl Supplies:";
		idxTemp2["rets16_44"]="Cable Available:";
		idxTemp2["rets16_440"]="Sewer Description:";
		idxTemp2["rets16_441"]="Tax Information:";
		idxTemp2["rets16_442"]="Total Expenses:";
		idxTemp2["rets16_443"]="Exp Incl Trash:";
		idxTemp2["rets16_444"]="Terms Considered:";
		idxTemp2["rets16_445"]="Total Units:";
		idxTemp2["rets16_446"]="Type of Property:";
		idxTemp2["rets16_448"]="Exp Incl Water/Sewer:";
		idxTemp2["rets16_449"]="Windows/Treatment:";
		idxTemp2["rets16_45"]="## Ceiling Fans:";
		idxTemp2["rets16_450"]="Water Access:";
		idxTemp2["rets16_455"]="Total Acreage:";
		idxTemp2["rets16_456"]="Fee Description:";
		idxTemp2["rets16_460"]="Building Includes:";
		idxTemp2["rets16_461"]="Deed Restrictions:";
		idxTemp2["rets16_462"]="Development:";
		idxTemp2["rets16_463"]="Dock Information:";
		idxTemp2["rets16_464"]="Boat Dock Accommodates:";
		idxTemp2["rets16_465"]="Available Documents:";
		idxTemp2["rets16_466"]="Development Name:";
		idxTemp2["rets16_467"]="Elevation Above Sea Level:";
		idxTemp2["rets16_469"]="Fill Description:";
		//idxTemp2["rets16_47"]="Co-Agent Phone:";
		idxTemp2["rets16_470"]="For Lease:";
		idxTemp2["rets16_471"]="Ground Cover Description:";
		idxTemp2["rets16_472"]="Miscellaneous/Improvements:";
		idxTemp2["rets16_474"]="Location:";
		idxTemp2["rets16_475"]="Min. SF Living Area Requirement:";
		idxTemp2["rets16_477"]="## Parcels:";
		idxTemp2["rets16_478"]="On-Site Utilities:";
		idxTemp2["rets16_479"]="Price/Acre:";
		idxTemp2["rets16_481"]="Folio ## - 2nd Parcel:";
		idxTemp2["rets16_483"]="Price/SqFt:";
		idxTemp2["rets16_484"]="Rail Description:";
		//idxTemp2["rets16_486"]="Showing Instructions:";
		idxTemp2["rets16_487"]="Type of Soil:";
		idxTemp2["rets16_489"]="Special Information:";
		idxTemp2["rets16_491"]="Style of Property:";
		idxTemp2["rets16_492"]="Subdivision Information:";
		idxTemp2["rets16_493"]="Surface Description:";
		idxTemp2["rets16_494"]="Sewer Description:";
		idxTemp2["rets16_495"]="Type of Trees:";
		idxTemp2["rets16_496"]="Terms Available:";
		idxTemp2["rets16_498"]="Type of Property:";
		idxTemp2["rets16_499"]="Usage Description:";
		idxTemp2["rets16_50"]="Compass Point:";
		idxTemp2["rets16_500"]="Utilities Available:";
		idxTemp2["rets16_501"]="Water Description:";
		idxTemp2["rets16_502"]="Waterview Description:";
		idxTemp2["rets16_506"]="Property Description:";
		idxTemp2["rets16_507"]="Available Documents:";
		idxTemp2["rets16_508"]="Elevation Above Sea Level:";
		idxTemp2["rets16_509"]="Environmental Audit:";
		idxTemp2["rets16_510"]="Gross Operating Income:";
		idxTemp2["rets16_511"]="Ground Cover:";
		idxTemp2["rets16_512"]="Gross Scheduled Income:";
		idxTemp2["rets16_514"]="Insurance Expense:";
		idxTemp2["rets16_515"]="Jurisdiction:";
		idxTemp2["rets16_516"]="Land Improvements:";
		idxTemp2["rets16_517"]="Maximum Leasable Sqft:";
		idxTemp2["rets16_518"]="Location:";
		idxTemp2["rets16_519"]="Lot Description:";
		idxTemp2["rets16_520"]="Lot Sq Footage:";
		idxTemp2["rets16_521"]="Lot Depth:";
		idxTemp2["rets16_522"]="Lot Frontage:";
		idxTemp2["rets16_716"]="Type of Building:";
		idxTemp2["rets16_523"]="Listing Type:";
		idxTemp2["rets16_524"]="Miscellaneous Information:";
		idxTemp2["rets16_525"]="Other Expenses:";
		idxTemp2["rets16_526"]="On-Site Utilities:";
		idxTemp2["rets16_527"]="Other Income Expense:";
		idxTemp2["rets16_528"]="Ownership:";
		idxTemp2["rets16_529"]="Inc/Exp Statement Period:";
		idxTemp2["rets16_53"]="Construction Type:";
		idxTemp2["rets16_530"]="Price/Front Foot:";
		idxTemp2["rets16_531"]="Comprehensive Plan Use:";
		idxTemp2["rets16_747"]="Style of Business:";
		idxTemp2["rets16_532"]="Folio ## - 3rd Parcel:";
		idxTemp2["rets16_533"]="Real Estate Taxes:";
		//idxTemp2["rets16_536"]="Showing Instructions:";
		idxTemp2["rets16_537"]="Source of Expenses:";
		idxTemp2["rets16_538"]="Special Information:";
		idxTemp2["rets16_539"]="Style of Property:";
		idxTemp2["rets16_540"]="Sewer Description:";
		idxTemp2["rets16_541"]="Total Assumable Loans:";
		idxTemp2["rets16_542"]="Type of Trees:";
		idxTemp2["rets16_543"]="Terms Considered:";
		idxTemp2["rets16_544"]="Type of Property:";
		idxTemp2["rets16_738"]="## Seats:";
		idxTemp2["rets16_545"]="Usage:";
		idxTemp2["rets16_546"]="Utilities Available:";
		idxTemp2["rets16_547"]="Water Description:";
		idxTemp2["rets16_548"]="Water View:";
		idxTemp2["rets16_551"]="Additional Move In Cost:";
		idxTemp2["rets16_552"]="Amenities:";
		idxTemp2["rets16_554"]="Application Fee:";
		idxTemp2["rets16_555"]="Approval Information:";
		idxTemp2["rets16_56"]="Convertible Bedroom:";
		idxTemp2["rets16_561"]="Renewal Commission:";
		idxTemp2["rets16_562"]="Available Date:";
		idxTemp2["rets16_563"]="Design:";
		idxTemp2["rets16_564"]="Lease Term/Info:";
		idxTemp2["rets16_565"]="Listing Type:";
		idxTemp2["rets16_567"]="Minimum Lease Period:";
		idxTemp2["rets16_568"]="Miscellaneous:";
		idxTemp2["rets16_569"]="Model Name:";
		idxTemp2["rets16_57"]="Cooling Description:";
		idxTemp2["rets16_570"]="Move In Dollars:";
		idxTemp2["rets16_572"]="## Leases/Year:";
		idxTemp2["rets16_573"]="## Stories:";
		idxTemp2["rets16_574"]="Occupancy Information:";
		idxTemp2["rets16_575"]="Parking Description:";
		idxTemp2["rets16_576"]="Pool Description:";
		idxTemp2["rets16_577"]="Renewable Rental:";
		idxTemp2["rets16_578"]="Rent Period:";
		idxTemp2["rets16_579"]="Rental Deposit Includes:";
		idxTemp2["rets16_58"]="Cosa:";
		idxTemp2["rets16_580"]="Rental Payment Includes:";
		idxTemp2["rets16_581"]="Restrictions:";
		idxTemp2["rets16_582"]="Rooms Description:";
		idxTemp2["rets16_583"]="For Sale:";
		idxTemp2["rets16_584"]="Security Information:";
		idxTemp2["rets16_585"]="Showing Instructions:";
		idxTemp2["rets16_586"]="Style:";
		idxTemp2["rets16_587"]="Sewer Description:";
		idxTemp2["rets16_588"]="Type of Property:";
		idxTemp2["rets16_589"]="View:";
		idxTemp2["rets16_59"]="## Carport Spaces:";
		idxTemp2["rets16_590"]="Acreage Description:";
		idxTemp2["rets16_591"]="A/C Percentage:";
		idxTemp2["rets16_592"]="Accounting and Legal Expens:";
		idxTemp2["rets16_593"]="Advertising Expenses:";
		idxTemp2["rets16_594"]="Prop Type/Type of Building:";
		idxTemp2["rets16_595"]="Common Area Maint Includes:";
		idxTemp2["rets16_597"]="Common Area Maint. Amount:";
		idxTemp2["rets16_598"]="Ceiling Description:";
		idxTemp2["rets16_599"]="Column Description:";
		idxTemp2["rets16_60"]="Carport Description:";
		idxTemp2["rets16_600"]="Construction Type:";
		idxTemp2["rets16_601"]="Cooling Description:";
		idxTemp2["rets16_602"]="Deposit Information:";
		idxTemp2["rets16_603"]="Dock Height:";
		idxTemp2["rets16_604"]="Door Height:";
		idxTemp2["rets16_605"]="Eave Height:";
		idxTemp2["rets16_606"]="Electric Service:";
		idxTemp2["rets16_607"]="Expense Amount:";
		idxTemp2["rets16_608"]="Fire Protection:";
		idxTemp2["rets16_609"]="Floor Description:";
		idxTemp2["rets16_61"]="County:";
		idxTemp2["rets16_610"]="Heating Description:";
		idxTemp2["rets16_613"]="Improvement Height:";
		idxTemp2["rets16_615"]="Information Available:";
		idxTemp2["rets16_616"]="Lot Frontage:";
		idxTemp2["rets16_617"]="Location of Property:";
		idxTemp2["rets16_618"]="Lease Term/Info:";
		idxTemp2["rets16_62"]="Closing Date:";
		idxTemp2["rets16_620"]="Total Move In Dollars:";
		idxTemp2["rets16_621"]="Miles to Beach:";
		idxTemp2["rets16_622"]="Miles to Expressway:";
		idxTemp2["rets16_623"]="Miscellaneous Information:";
		idxTemp2["rets16_632"]="Miscellaneous Expense:";
		idxTemp2["rets16_634"]="Maintenance and Repairs Expense:";
		idxTemp2["rets16_638"]="Maximum Ceiling Height:";
		idxTemp2["rets16_641"]="## Bays:";
		idxTemp2["rets16_642"]="## Buildings:";
		idxTemp2["rets16_643"]="## Floors:";
		idxTemp2["rets16_644"]="## Loading Doors:";
		idxTemp2["rets16_645"]="## Meters:";
		idxTemp2["rets16_646"]="## Offices:";
		idxTemp2["rets16_647"]="## Tenants:";
		idxTemp2["rets16_648"]="## Toilets:";
		idxTemp2["rets16_649"]="Occupancy Percentage:";
		idxTemp2["rets16_650"]="Type of Ownership:";
		idxTemp2["rets16_651"]="## Parking Spaces:";
		idxTemp2["rets16_652"]="Parking Description:";
		idxTemp2["rets16_653"]="Property Description:";
		idxTemp2["rets16_654"]="Price/Unit:";
		idxTemp2["rets16_655"]="Road Frntg Description:";
		idxTemp2["rets16_656"]="Road Type Description:";
		idxTemp2["rets16_657"]="Reimbursable SqFt:";
		idxTemp2["rets16_658"]="Roof Description:";
		idxTemp2["rets16_659"]="Security Information:";
		idxTemp2["rets16_66"]="Den Dimensions:";
		idxTemp2["rets16_660"]="Service Expense:";
		idxTemp2["rets16_661"]="Special Information:";
		idxTemp2["rets16_662"]="Style of Property:";
		idxTemp2["rets16_663"]="Supply Expense:";
		idxTemp2["rets16_664"]="Sewer Description:";
		idxTemp2["rets16_665"]="Tax Amount:";
		idxTemp2["rets16_67"]="Design:";
		idxTemp2["rets16_671"]="## Units:";
		idxTemp2["rets16_673"]="Trash Expense:";
		idxTemp2["rets16_674"]="Terms Considered:";
		idxTemp2["rets16_675"]="Type of Property:";
		idxTemp2["rets16_677"]="Unit 1 ## of Baths:";
		idxTemp2["rets16_678"]="Unit 1 Furnished:";
		idxTemp2["rets16_68"]="Design Description:";
		idxTemp2["rets16_681"]="Unit 1 Rental Period A:";
		idxTemp2["rets16_682"]="Unit 1 Rental Period B:";
		idxTemp2["rets16_683"]="Unit 2 ## of Baths:";
		idxTemp2["rets16_684"]="Unit 2 Furnished:";
		idxTemp2["rets16_685"]="Unit 2 Rental Period A:";
		idxTemp2["rets16_686"]="Unit 2 Rental Period B:";
		idxTemp2["rets16_687"]="Unit 3 ## of Baths:";
		idxTemp2["rets16_688"]="Unit 3 Furnished:";
		idxTemp2["rets16_689"]="Unit 3 Rental Period A:";
		idxTemp2["rets16_69"]="Development Name:";
		idxTemp2["rets16_690"]="Unit 3 Rental Period B:";
		idxTemp2["rets16_691"]="Unit 4 ## of Baths:";
		idxTemp2["rets16_692"]="Unit 4 Furnished:";
		idxTemp2["rets16_693"]="Unit 4 Rental Period A:";
		idxTemp2["rets16_694"]="Unit 4 Rental Period B:";
		idxTemp2["rets16_695"]="Unit 5 ## of Baths:";
		idxTemp2["rets16_696"]="Unit 5 Furnished:";
		idxTemp2["rets16_697"]="Unit 5 Rental Period A:";
		idxTemp2["rets16_698"]="Unit 5 Rental Period B:";
		idxTemp2["rets16_699"]="Unit 6 ## of Baths:";
		idxTemp2["rets16_70"]="Dining Description:";
		idxTemp2["rets16_700"]="Unit 6 Furnished:";
		idxTemp2["rets16_701"]="Unit 6 Rental Period A:";
		idxTemp2["rets16_702"]="Unit 6 Rental Period B:";
		idxTemp2["rets16_703"]="Unit 7 ## of Baths:";
		idxTemp2["rets16_704"]="Unit 7 Furnished:";
		idxTemp2["rets16_705"]="Unit 7 Rental Period A:";
		idxTemp2["rets16_706"]="Unit 7 Rental Period B:";
		idxTemp2["rets16_707"]="Utility Expense:";
		idxTemp2["rets16_708"]="Vacancy Rate:";
		idxTemp2["rets16_709"]="Water Description:";
		idxTemp2["rets16_71"]="Dining Area Dimensions:";
		idxTemp2["rets16_713"]="Year Built Description:";
		idxTemp2["rets16_73"]="Compass Point:";
		idxTemp2["rets16_74"]="Days on Market:";
		idxTemp2["rets16_76"]="Dining Room Dimensions:";
		//idxTemp2["rets16_77"]="Agent Email Address:";
		idxTemp2["rets16_81"]="Equipment/Appliances:";
		idxTemp2["rets16_87"]="Exterior Features:";
		idxTemp2["rets16_881"]="Address:";
		idxTemp2["rets16_886"]="Elementary School:";
		idxTemp2["rets16_891"]="Middle School:";
		idxTemp2["rets16_893"]="Senior High School:";
		idxTemp2["rets16_894"]="## Interior Levels:";
		idxTemp2["rets16_895"]="Rent Status - April:";
		idxTemp2["rets16_896"]="Rent Status - August:";
		idxTemp2["rets16_897"]="Rent Status - December:";
		idxTemp2["rets16_898"]="Rent Status - February:";
		idxTemp2["rets16_899"]="Furn Annual Rent:";
		idxTemp2["rets16_90"]="Front Exposure:";
		idxTemp2["rets16_900"]="Furn Off-Season Rent:";
		idxTemp2["rets16_901"]="Furn Seasonal Rent:";
		idxTemp2["rets16_902"]="Rent Status - January:";
		idxTemp2["rets16_903"]="Rent Status - July:";
		idxTemp2["rets16_904"]="Rent Status - June:";
		idxTemp2["rets16_905"]="Rent Status - March:";
		idxTemp2["rets16_906"]="Rent Status - May:";
		idxTemp2["rets16_907"]="Rent Status - November:";
		idxTemp2["rets16_908"]="Rent Status - October:";
		idxTemp2["rets16_909"]="Rent Status - September:";
		idxTemp2["rets16_91"]="Office Fax Number:";
		idxTemp2["rets16_910"]="Unfurn Annual Rent:";
		idxTemp2["rets16_911"]="Unfurn Off-Season Rent:";
		idxTemp2["rets16_912"]="Unfurn Seasonal Rent:";
		idxTemp2["rets16_92"]="Full Bathrooms:";
		idxTemp2["rets16_922"]="City Name:";
		idxTemp2["rets16_924"]="State:";
		idxTemp2["rets16_93"]="Association Fee:";
		idxTemp2["rets16_94"]="Maintenance Fee Includes:";
		idxTemp2["rets16_948"]="Unit 1 Type:";
		idxTemp2["rets16_950"]="Unit 2 Type:";
		idxTemp2["rets16_952"]="Unit 3 Type:";
		idxTemp2["rets16_954"]="Unit 4 Type:";
		idxTemp2["rets16_956"]="Unit 5 Type:";
		idxTemp2["rets16_958"]="Unit 6 Type:";
		idxTemp2["rets16_96"]="Floor Description:";
		idxTemp2["rets16_960"]="Unit 7 Type:";
		idxTemp2["rets16_962"]="Unit 1 ## of Units:";
		idxTemp2["rets16_964"]="Unit 2 ## of Units:";
		idxTemp2["rets16_966"]="Unit 3 ## of Units:";
		idxTemp2["rets16_968"]="Unit 4 ## of Units:";
		idxTemp2["rets16_97"]="Florida Room Dimensions:";
		idxTemp2["rets16_970"]="Unit 5 ## of Units:";
		idxTemp2["rets16_972"]="Unit 6 ## of Units:";
		idxTemp2["rets16_974"]="Unit 7 ## of Units:";
		idxTemp2["rets16_976"]="Unit 1 - A Rent:";
		idxTemp2["rets16_978"]="Unit 1 - B Rent:";
		idxTemp2["rets16_98"]="Family Room Dimensions:";
		idxTemp2["rets16_980"]="Unit 2 - A Rent:";
		idxTemp2["rets16_982"]="Unit 2 - B Rent:";
		idxTemp2["rets16_984"]="Unit 3 - A Rent:";
		idxTemp2["rets16_986"]="Unit 3 - B Rent:";
		idxTemp2["rets16_988"]="Unit 4 - A Rent:";
		idxTemp2["rets16_99"]="Furnished Info (List):";
		idxTemp2["rets16_990"]="Unit 4 - B Rent:";
		idxTemp2["rets16_992"]="Unit 5 - A Rent:";
		idxTemp2["rets16_994"]="Unit 5 - B Rent:";
		idxTemp2["rets16_996"]="Unit 6 - A Rent:";
		idxTemp2["rets16_998"]="Unit 6 - B Rent:";
		//idxTemp2["rets16_sysid"]="sysid:";
		
		arrayappend(arrR, application.zcore.listingCom.getListingDetailRowOutput("Property Information", arguments.idx, variables.idxExclude, idxTemp2, variables.allFields));
		return arraytolist(arrR,'');
		
		</cfscript>
	</cffunction>
	<cffunction name="getDetailCache2" localmode="modern" output="yes" returntype="string">
        <cfargument name="idx" type="struct" required="yes">
        <cfscript>
		var arrR=arraynew(1);
		var idxTemp2=structnew();
		return arraytolist(arrR,'');
		
		
		
		</cfscript>
    </cffunction>
    <cffunction name="getDetailCache3" localmode="modern" output="yes" returntype="string">
        <cfargument name="idx" type="struct" required="yes">
        <cfscript>
		var arrR=arraynew(1);
		var idxTemp2=structnew();
		return arraytolist(arrR,'');
		</cfscript>
	</cffunction>
    </cfoutput>
</cfcomponent>