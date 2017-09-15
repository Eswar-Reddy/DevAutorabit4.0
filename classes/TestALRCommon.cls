@IsTest
public with sharing class TestALRCommon {

public static void CreateCustomSetting() {
      //Add the Custom Setting
      DealerGeneral__c dg = DealerGeneral__c.getInstance( UserInfo.getOrganizationId() );
      
      if (dg.id == null)
      {    
          dg = new DealerGeneral__c();
        dg.Email_Address_For_ALR_Alerts__c         = 'test@sunpowercorp.com';
      dg.Enable_ALR_Process__c                 = true;
      dg.Enforce_Agreement_Check_Dealer_Search__c   = false;
      dg.Google_Client_Id_Maps__c               = '';
      dg.Google_Private_key_Maps__c             = '';
      dg.Lead_Test_First_Name__c               = 'SPWR Test';
      dg.Default_Owner_of_Opportunities_Id__c      = UserInfo.getUserId();
      dg.Enable_ALR_Dealer_Scoring__c            = true;
          insert dg;
    }
    else
      {    
          dg = new DealerGeneral__c();
        dg.Email_Address_For_ALR_Alerts__c         = 'test@sunpowercorp.com';
      dg.Enable_ALR_Process__c                 = true;
      dg.Enforce_Agreement_Check_Dealer_Search__c   = false;
      dg.Google_Client_Id_Maps__c               = '';
      dg.Google_Private_key_Maps__c             = '';
      dg.Lead_Test_First_Name__c               = 'SPWR Test';
      dg.Default_Owner_of_Opportunities_Id__c      = UserInfo.getUserId();
      dg.Enable_ALR_Dealer_Scoring__c            = true;      
          update dg;
    }
    

}
public static Lead CreateRawLead(String CompanyName, String Source_System, String Lead_Inferred_Quality, String Lead_Data_Quality) {
    Lead l = new Lead();
    Id ResidentialRecordTypeId = DealerUtility.GetResidentialRecordType();
    l.RecordTypeId = ResidentialRecordTypeId;
    l.FirstName   = 'First';
    l.LastName   = 'Last'; 
    l.Company     = CompanyName;
    l.Email       = 'noreply@sunpowercorp.com';
    l.street      = '151 Corona St' ;
    l.city        = 'Denver';
    l.state      = 'CO';
    l.postalcode   = '80218';
    l.country      = 'USA';
    l.Lat__c       = 39.721956;
    l.Log__c     = -104.974382;
    l.LeadSource  = 'Web';
    l.Source_System__c        = Source_System;
    l.Lead_Inferred_Quality__c   = Lead_Inferred_Quality;
    l.Lead_Data_Quality__c     = Lead_Data_Quality;  
    l.Status = 'Open';  
    l.Theater__c = 'North America';
    l.IsAutoConvert__c = false;
    return l;
  }      

	public static Account CreateDealer(String DealerName) 
	{
        //RecordType PartnerRecordTypeAccount = [Select r.Id, r.SobjectType, r.Name From RecordType r where sobjecttype ='Account' and Name= 'Partner' LIMIT 1];

      //Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
       
        //User u = new User(LastName = DealerName ,FirstName = DealerName,Email='testAdmin2@testorg.com', ProfileId = p.Id);
        
        Account a = new Account();
        a.Name                     = DealerName; //'Really Bright Solar';
        a.Type                     = 'Premier-Partner-Residential'; //PartnerRecordTypeAccount .Id;
            
        a.Dealer_Score_Total__c         = 78;
        a.Dealer_Locator_Phone__c       = '888-888-8888';
        a.Phone                   = '888-888-8888';
        a.BillingStreet                  = '150 Corona St';
        a.BillingCity                    = 'Denver';
        a.BillingState                     = 'CO';
        a.BillingCountry                   = 'USA';
        a.BillingPostalCode               = '80218';
        a.website                         = 'www.sunpowercorp.com';
        a.Oracle_Account_Number__c     = '123';
        a.Description                 = 'None';
        a.Partner_Facts__c             = 'None';
        a.Status__c                 = 'Active';
        a.Dealer_Locator_Opt_Out__c     = false;
        a.Lead_Flow_Opt_Out__c        = false;
        a.Alliance_Program_Partner__c     = true;
        a.Geolocation__Latitude__s       = 39.718887;
        a.Geolocation__Longitude__s     = -104.974036;
    //a.Opportunity_Recipient__c      = u.id;
        insert a;
        
        Dealer_Assignment_Audit__c leadAssignment = DealerUtility.ConfigureDealerAssignmentAudit('Test2', a.Id, null, 'test', 'none');
        system.assert(leadAssignment != null);
        
        //2. Insert CoverageArea__c
        CoverageArea__c ca = new CoverageArea__c();
        ca.Account__c             = a.id;
        ca.Geolocation__Latitude__s   = 39.718887;
        ca.Geolocation__Longitude__s   = -104.974036;
        ca.Radius__c               = 1000;
        insert ca;
        
    Business_Registration__c br = new Business_Registration__c();
    br.Name         = a.billingstate;
    br.Account__c     = a.id;
    //br.Expires_On__c   = a.Contractors_Lic_Expiry__c;
    br.License_Number__c = '000000';
    br.Country__c       = a.billingCountry;
    br.State__c       = a.billingstate;
       insert br;        
        return a;
}

	public static Account Lead_CreateDealer(String DealerName) 
	{
        Account a = new Account();
        a.Name                     = DealerName; //'Really Bright Solar';
        a.Type                     = 'Premier-Partner-Residential'; //PartnerRecordTypeAccount .Id;
        a.Dealer_Score_Total__c         = 78;
        a.Dealer_Locator_Phone__c       = '888-888-8888';
        a.Phone                   = '888-888-8888';
        a.BillingStreet                  = '150 Corona St';
        a.BillingCity                    = 'Denver';
        a.BillingState                     = 'CO';
        a.BillingCountry                   = 'United States';
        a.BillingPostalCode               = '80218';
        a.website                         = 'www.sunpowercorp.com';
        a.Oracle_Account_Number__c     = '123';
        a.Description                 = 'None';
        a.Partner_Facts__c             = 'None';
        a.Status__c                 = 'Active';
        a.Dealer_Locator_Opt_Out__c     = false;
        a.Lead_Flow_Opt_Out__c        = false;
        a.Alliance_Program_Partner__c     = true;
        a.Geolocation__Latitude__s       = 39.718887;
        a.Geolocation__Longitude__s     = -104.974036;
        insert a;
        
        Dealer_Assignment_Audit__c leadAssignment = DealerUtility.ConfigureDealerAssignmentAudit('Test2', a.Id, null, 'test', 'none');
        system.assert(leadAssignment != null);
        
        //2. Insert CoverageArea__c
        CoverageArea__c ca = new CoverageArea__c();
        ca.Account__c             = a.id;
        ca.Geolocation__Latitude__s   = 39.718887;
        ca.Geolocation__Longitude__s   = -104.974036;
        ca.Radius__c               = 1000;
        insert ca;
        
	    Business_Registration__c br = new Business_Registration__c();
	    br.Name         = a.billingstate;
	    br.Account__c     = a.id;
	    br.License_Number__c = '000000';
	    br.Country__c       = a.billingCountry;
	    br.State__c       = a.billingstate;
	    insert br;        
	    
	    return a;
	}

public static Account CreateHomeOwnerAccount(String accountName) {
       RecordType PartnerRecordTypeAccount = [Select r.Id, r.SobjectType, r.Name From RecordType r where sobjecttype ='Account' and Name= 'Partner' LIMIT 1];
       
        Account a = new Account();
        a.Name                     = accountName; //'Really Bright Solar';
        a.Type                     = 'Home Owner';
            
        //a.Dealer_Score_Total__c         = 78;
        //a.Dealer_Locator_Phone__c       = '888-888-8888';
        a.Phone                   = '888-888-8888';
        a.BillingStreet                  = '150 Corona St';
        a.BillingCity                    = 'Denver';
        a.BillingState                     = 'CO';
        a.BillingCountry                   = 'USA';
        a.BillingPostalCode               = '80218';
        a.website                         = 'www.sunpowercorp.com';
        a.Oracle_Account_Number__c     = '123';
        a.Description                 = 'None';
        a.Partner_Facts__c             = 'None';
        a.Status__c                 = 'Active';
        a.Dealer_Locator_Opt_Out__c     = false;
        a.Lead_Flow_Opt_Out__c        = false;
        //a.Alliance_Program_Partner__c     = true;
        a.Geolocation__Latitude__s       = 39.718887;
        a.Geolocation__Longitude__s     = -104.974036;

        insert a;
                
        return a;
}
}