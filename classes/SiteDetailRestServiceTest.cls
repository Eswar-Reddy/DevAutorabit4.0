@isTest

public class SiteDetailRestServiceTest{

static testMethod void MySiteResourceDoGet() {



Account account = TestClassFactory.testAccount('Test Account1', TestClassFactory.retrieveRecordTypeID('Account', 'Standard'));
insert account;
Site_Information_Form__c  siteObjectTest=new Site_Information_Form__c ();
siteObjectTest.Account__c=account.Id;
siteObjectTest.Job_Number__c='123';
siteObjectTest.Land_size_ha__c=324;
siteObjectTest.Site_Address__c='CA';
siteObjectTest.Site_City__c='SanJose';

insert siteObjectTest;

System.debug('siteObjectTest Insert :: '+siteObjectTest);

SiteInfoSettings__c setting = new SiteInfoSettings__c();
setting.Name= 'Account__r.Name';
setting.FieldApiname__c= 'Account__r.Name';
setting.Json_Name__c= 'Account__r.Name';
setting.sObject_Name__c='Site_Information_Form__c';
insert setting;

SiteInfoSettings__c settingSecond = new SiteInfoSettings__c();
settingSecond.Name='Job_Number__c';
settingSecond.FieldApiname__c='Job_Number__c';
settingSecond.Json_Name__c='Job_Number__c';
settingSecond.sObject_Name__c='Site_Information_Form__c';
insert settingSecond;


Site_Information_Form__c  siteObjectTestreturn=[SELECT Name,Job_Number__c,Account__r.Name FROM Site_Information_Form__c WHERE Job_Number__c='123' LIMIT 1  ]; 

System.debug('siteObjectTestreturn afer Query ::: '+siteObjectTestreturn);
String name=String.valueOf(siteObjectTestreturn.Name);
System.debug('SFID ::'+name);
String jobNumber=String.valueOf(siteObjectTestreturn.Job_Number__c);

RestRequest req = new RestRequest(); 
RestResponse res = new RestResponse();
req.requestURI ='https://'+System.URL.getSalesforceBaseUrl().getHost()+'/services/apexrest/SitetestInfo/';   
req.addParameter('SIFID',name);
req.httpMethod = 'GET';
RestContext.request = req;
RestContext.response = res;
Map<String, Object> resSiteDetails;
Object siteDetailsMap;

Map <String,String> responseMap=new Map <String,String>();

Test.startTest();
          REST_SiteDetailsRestService.getAllSiteInfo(); 
Test.stopTest();
        
resSiteDetails = (Map<String, Object>)JSON.deserializeUntyped(res.responseBody.toString());

siteDetailsMap=resSiteDetails.get('SiteDetails');


Map<String, Object>siteDetailsMapFinal = (Map<String, Object>)siteDetailsMap;
System.debug('res.responseBody :: '+resSiteDetails + '   siteDetailsMap ::  ' +siteDetailsMap + '   ::: siteDetailsMapFinal ::  '+siteDetailsMapFinal.get('Projected_Dev_Stage_end_of_this_Year__c'));
 

System.assertEquals(String.valueOf(siteDetailsMapFinal.get('Job_Number__c')),jobNumber,'Working');



}

}