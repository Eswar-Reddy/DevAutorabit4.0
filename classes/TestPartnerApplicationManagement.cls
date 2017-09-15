/**************************************************
** PR- 01923
**Created By- Harsh Mathur
**Created On- May 21 2009
**Last Modified- Bharti Mehta
**Last Modified On-  Aug 09 2011 
**Desciption- Test class for controller PartnerApplicationManagement
*****************************************************/
@istest
private class TestPartnerApplicationManagement {
    @istest
    public static void Test_PartnerApplicationManagement(){
        
        Lead lead1 = new Lead();
        lead1.Status = 'Open';
        lead1.CurrencyIsoCode='USD';
        lead1.LeadSource='Web';
        lead1.SPWR_Industry_Type__c='Energy Developer';
        lead1.Business_Unit__c='RLC';
        lead1.Theater__c='Europe';
        lead1.LastName='Soral';
        lead1.Email = 'testlead@gmail.com';
        insert lead1;
        
        
        Partner_Application__c partner = new Partner_Application__c();
        partner.Zip__c = '90049';
        partner.Company_Name__c = 'Test Company'+string.valueOf(DateTime.now());
        insert partner;
        
        Partner_Application__c partnerapp2 = new Partner_Application__c(Id=partner.Id);
        partnerapp2.Zip__c = '90071';
        partnerapp2.Lead__c = lead1.Id;
        update partnerapp2;
        
        List<Partner_Application__c> partnerList = new List<Partner_Application__c>();
        List<Partner_Application__c> oldpartnerList = new List<Partner_Application__c>();
        partnerList.add(partner);
        oldpartnerList.add(partnerapp2);
       
        
        
    }
    
    //madhuri
    
    @istest
    public static void Test_PartnerApplicationManagement1(){
        
        Territory territory1 = [select id,name,ParentTerritoryId from Territory where ParentTerritoryId != null limit 1];
        UserTerritory uterritory = [select id,territoryID from UserTerritory where territoryID =: territory1.id limit 1];
        
        Partner_Application__c partner = new Partner_Application__c();
        partner.Zip__c = '12345';
        partner.Company_Name__c = 'Test Company'+string.valueOf(DateTime.now());
        partner.Partner_Application_Type__c = 'Commercial';
        partner.territory__c = territory1.name ;
        partner.Country__c = 'USA';
        insert partner;
        
        List<Partner_Application__c> partnerList = new List<Partner_Application__c>();       
        partnerList.add(partner);
        PartnerApplicationManagement.setFields(partnerList);
        
        partner.statusSetFromApprovalProcess__c = true;
        partner.Status__c = 'Approved';
        update partner;
        
     
    }
    
}