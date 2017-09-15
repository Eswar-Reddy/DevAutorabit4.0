@isTest
private class REST_DesignItemsTest {
	
	public static String RestURL = '/services/apexrest/RESTDesignItems/v1';
	
	 static testmethod void testRest_DesignItemGet(){
	 	test.startTest();
	 	
	 	Restrequest req = new Restrequest();
	 	Restresponse res = new Restresponse();
	 	
	 	SunPower_Design__c objSunPwrDesign = createSunPower_Design('Test','SmartPack','EUR','Test','SMA',3.00,'On-Roof');
	 	insert objSunPwrDesign;
	 	
	 	SunPower_Design_Item__c objDesignItem = createSunPower_DesignItem(objSunPwrDesign.Id);
	 	insert objDesignItem;
	 	
	 	req.requestURI = RestURL;
	 	req.httpMethod = 'GET';
	 	req.addParameter('DId', objSunPwrDesign.Id);
	 	RestContext.request = req;
        RestContext.response = res;
	 	
	 	Test.setMock(HttpCalloutMock.class, new REST_DesignItemsMockHttpResponse());           
        REST_DesignItems.getDesign();
	 	
	 	test.stopTest();
	 }
	 
	 static testmethod void testRest_DesignItemPost(){
	 	test.startTest();
	 	
	 	Restrequest req = new Restrequest();
	 	Restresponse res = new Restresponse();
	 	
	 	
	 	SunPower_Design__c objSunPwrDesign = createSunPower_Design('Test','SmartPack','EUR','Test','SMA',3.00,'On-Roof');
	 	insert objSunPwrDesign;
	 	
	 	SunPower_Design_Item__c objDesignItem = createSunPower_DesignItem(objSunPwrDesign.Id);
	 	insert objDesignItem;
	 	
	 	String objDesign='{'+
		  '\"ObjectType\": \"SunPower_Design_Item__c\",'+
		  '\"ObjectList\": ['+
		    '{'+
		      '\"Name\":\"Test\",'+
		      '\"Item_Description__c\":\"testing\",' +
		      '\"Description__c\":\"Test\",' +
		      '\"Component_Type__c\":\"SMA\",'+
		      '\"Is_Smart_Pack_Item__c\":true,'+
		      '\"Id\":\"'+ objDesignItem.Id +'\",'+
		      '\"SunPower_Design__c\":\"'+ objSunPwrDesign.Id +'\"'+
		      '}'+
		  ']'+
		'}';
	 	
	 	req.requestBody = Blob.valueof(objDesign);
        req.requestURI = RestURL;
	 	req.httpMethod = 'POST';
	 	RestContext.request = req;
        RestContext.response = res;
	 	
	 	Test.setMock(HttpCalloutMock.class, new REST_DesignItemsMockHttpResponse());           
        REST_DesignItems.updateRecords();
	 	
	 	test.stopTest();
	 }
	 
	 public static SunPower_Design__c createSunPower_Design(String Name,String Source, String CurrencyIsoCode, String DesignNotes, 
	 														String EUInverterType, Decimal size, String EU_Mounting_Type){
		SunPower_Design__c objNewSunPowerDesign = new SunPower_Design__c();
		objNewSunPowerDesign.Name = Name ;
		objNewSunPowerDesign.System_Source__c = Source;
		objNewSunPowerDesign.CurrencyIsoCode = CurrencyIsoCode;
		objNewSunPowerDesign.Design_Notes__c = DesignNotes;
		objNewSunPowerDesign.EU_Inverter_Type__c = EUInverterType;
		objNewSunPowerDesign.system_size__c = size;
		objNewSunPowerDesign.EU_Mounting_Type__c = EU_Mounting_Type;
		
		return objNewSunPowerDesign;
	}
	
	public static SunPower_Design_Item__c createSunPower_DesignItem(String strDesignId)
	{
		SunPower_Design_Item__c objNewSunPowerDesignItem = new SunPower_Design_Item__c();
		objNewSunPowerDesignItem.SunPower_Design__c = strDesignId;
		objNewSunPowerDesignItem.Quantity__c = 32;
		objNewSunPowerDesignItem.Component_Type__c = 'Module';
		return objNewSunPowerDesignItem;
	}
}