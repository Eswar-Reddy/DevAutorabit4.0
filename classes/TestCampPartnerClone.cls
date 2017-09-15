@isTest
public class TestCampPartnerClone  
{
 static testMethod void Test_CampPartnerClone (){
   String recType1 = [SELECT id FROM recordtype WHERE name='Partner' and Sobjecttype = 'Account' limit 1].id;
   Campaign  objalliance =  new Campaign(Name='TestAllianceCampNA' ,IsActive=true,AssignRandomPartner__c=false);
   insert objalliance;
 
     Campaign CloneCamp = objalliance.clone(false,true);
     insert CloneCamp ;
    
     Account objP = new Account(Name = 'test1111',Opportunity_Close_Rate__c=6, recordtypeId=recType1,BillingStreet='Adriatic Way', BillingCity='Santa Clara', BillingState='CA', BillingPostalCode='95051', BillingCountry='United States',Theater__c ='North America',Phone='1234567895',Type='Elite-Partner-Combo');
     Insert objP;
     Campaign_Partner__c objAllianePartner = new Campaign_Partner__c(Name='test1',Disable_Date__c=date.today(),Enable_Date__c=date.today(),Campaign__c=objalliance.Id, Partner__c=objP.Id, Enabled__c=true);
     insert objAllianePartner;
     List<Campaign_Partner__c> CampPartnersNew = new List<Campaign_Partner__c>();
     Campaign_Partner__c newCP = objAllianePartner.clone(false,true);
     newCP.Campaign__c = CloneCamp.id;
     CampPartnersNew.add(newCP);
     insert CampPartnersNew;
     
     PageReference p = new PageReference('/apex/CloneCamapignWPartner');
     Test.setCurrentPage(p);
     
     ApexPages.currentPage().getParameters().put('Id', objalliance.Id);
     
     ApexPages.StandardController sc = new ApexPages.StandardController(objalliance);

     CampPartnerClone campCon = new CampPartnerClone(sc);
     campCon.CloneCamp();
     
  }
}