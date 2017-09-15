@IsTest
public with sharing class TestDealerUtility {

public TestDealerUtility() {
    TestALRCommon.CreateCustomSetting();
}
 
static Lead CreateLeadPlain(String CompanyName, String Source_System, String Lead_Inferred_Quality, String Lead_Data_Quality) {
        Lead l = TestALRCommon.CreateRawLead(CompanyName, Source_System, Lead_Inferred_Quality, Lead_Data_Quality);
        insert l;
        return l;
    }       

    
static Lead CreateLeadDealerAssigned(String CompanyName, String Source_System, String Lead_Inferred_Quality, String Lead_Data_Quality, Id DealerId) {
        Lead l = TestALRCommon.CreateRawLead(CompanyName, Source_System, Lead_Inferred_Quality, Lead_Data_Quality);
        l.Dealer_Locator_Selection__c = DealerId;
        insert l;
        return l;
    }       

static Opportunity CreateOpportunityWithGenericCampaign(String OppName) {

        Campaign c = new Campaign(Name ='Test', Type = 'Other');
        insert c;

        Account partner = TestALRCommon.CreateDealer('Partner1');
        
        Campaign_Partner__c cp  = new Campaign_Partner__c(Campaign__c = c.Id);
        cp.enabled__c = true;
        cp.Name = 'A';
        cp.Partner__c = partner.Id;
        insert cp;

                                                                                    
        RecordType RecordTypeOpportunity = [Select  r.Id, r.SobjectType, r.Name From RecordType r where sobjecttype ='Opportunity' and Name = 'Home Owner' LIMIT 1];
        Account a = TestALRCommon.CreateHomeOwnerAccount('Test100');
        Opportunity o = new Opportunity();
        o.RecordTypeId = RecordTypeOpportunity.Id;
        o.CampaignId = c.Id;
        o.AccountId = a.Id;
        o.Name = OppName;
        o.StageName = 'New Opportunity';
        o.Lead_Manufacturer__c = 'SunPower';
        o.CloseDate = System.Today();
        insert o;
        return o;                        
                                
    }    

static Opportunity CreateOpportunityWithPaidCampaign(String OppName) {

        Campaign c = new Campaign(Name ='Test', Type = 'Other', AssignRandomPartner__c = true);
        insert c;

        Account partner = TestALRCommon.CreateDealer('Partner1');
        
        Campaign_Partner__c cp  = new Campaign_Partner__c(Campaign__c = c.Id);
        cp.enabled__c = true;
        cp.Name = 'A';
        cp.Partner__c = partner.Id;
        insert cp;

                                                                                    
        RecordType RecordTypeOpportunity = [Select  r.Id, r.SobjectType, r.Name From RecordType r where sobjecttype ='Opportunity' and Name = 'Home Owner' LIMIT 1];
        Account a = TestALRCommon.CreateHomeOwnerAccount('Test100');
        Opportunity o = new Opportunity();
        o.RecordTypeId = RecordTypeOpportunity.Id;
        o.CampaignId = c.Id;
        o.AccountId = a.Id;
        o.Name = OppName;
        o.StageName = 'New Opportunity';
        o.Lead_Manufacturer__c = 'SunPower';
        o.CloseDate = System.Today();
        insert o;
        return o;                        
                                
    }    
    
static Opportunity CreateOpportunityWithAllianceCampaign(String OppName) {

        Campaign c = new Campaign(Name ='Test', Type = 'Alliance');
        insert c;

        Account partner = TestALRCommon.CreateDealer('Partner1');
        
        Campaign_Partner__c cp  = new Campaign_Partner__c(Campaign__c = c.Id);
        cp.enabled__c = true;
        cp.Name = 'A';
        cp.Partner__c = partner.Id;
        insert cp;

                                                                                    
        RecordType RecordTypeOpportunity = [Select  r.Id, r.SobjectType, r.Name From RecordType r where sobjecttype ='Opportunity' and Name = 'Home Owner' LIMIT 1];
        Account a = TestALRCommon.CreateHomeOwnerAccount('Test100');
        Opportunity o = new Opportunity();
        o.RecordTypeId = RecordTypeOpportunity.Id;
        o.CampaignId = c.Id;
        o.AccountId = a.Id;
        o.Name = OppName;
        o.StageName = 'New Opportunity';
        o.Lead_Manufacturer__c = 'SunPower';
        o.CloseDate = System.Today();
        insert o;
        return o;                        
                                
    }    
    
/*
static void CreateCustomSetting() {
        //Add the Custom Setting
        DealerGeneral__c dg = new DealerGeneral__c();
        dg.Email_Address_For_ALR_Alerts__c              = 'test@sunpowercorp.com';
        dg.Enable_ALR_Process__c                                = true;
        dg.Enforce_Agreement_Check_Dealer_Search__c     = false;
        dg.Google_Client_Id_Maps__c                             = '';
        dg.Google_Private_key_Maps__c                       = '';
        dg.Lead_Test_First_Name__c                          = 'SPWR Test';
        insert dg;
    
}
*/
    

    static testMethod void testGeneral() {
        //TestALRCommon.CreateCustomSetting();
        Id r = DealerUtility.GetResidentialRecordType();
        system.assert(r != null);
        test.startTest();
        Lead l = CreateLeadPlain('Company1', 'NotEloqua','None','None');
        
        DealerUtility.ScheduleLeadAutoAssgn();
        list<Lead> listLeads = new list<Lead>();
        listLeads.add(l);
        
        DealerUtility.ScheduleLeadAutoConvert(listLeads);
        
        GeocodeAsyncHandler.GeoInfo info = new GeocodeAsyncHandler.GeoInfo();
        info.Lat = 39.721956;
        info.Lon = -104.974382;
        info.State = 'CO';
        DealerUtility.ConvertLead(l, info);
        
        boolean b = DealerUtility.isDuplicateLead(l);
        //system.assert(b == true);
                
        List<Lead> listNewLeads = new List<Lead>();
        listNewLeads.add(l);
        
        DealerUtility.SetLeadAutoConvert(listNewLeads);
        
        DealerUtility.SendEmailAlert('No Subject', 'No body');
        test.stopTest();
/*
        l = CreateLeadPlain('Company2', 'Eloqua','Reject','None');
        system.debug('@@@@@TestDealerUtility.testGeneral; ' + l.status); //system.assert(l.status == 'SPAM');
        
        l = CreateLeadPlain('Company3', 'Eloqua','Accept','Qualified');
        system.debug('@@@@@TestDealerUtility.testGeneral; ' + l.status); //system.assert(l.status == 'Qualified');
        
        l = CreateLeadPlain('Company4', 'Eloqua','Accept','Disqualified');
        system.debug('@@@@@TestDealerUtility.testGeneral; ' + l.status); //system.assert(l.status == 'Disqualified');
        
        l = CreateLeadPlain('Company5', 'Eloqua','Accept','Undetermined');
        system.debug('@@@@@TestDealerUtility.testGeneral; ' + l.status); //system.assert(l.status == 'Awaiting Qualification Review');
        
        l = CreateLeadPlain('Company6', 'Eloqua','Review','Qualified');
        system.debug('@@@@@TestDealerUtility.testGeneral; ' + l.status); //system.assert(l.status == 'Awaiting Qualification Review');
        */
        
        
    }

    static testMethod void testCalculateTimelyUpdateOnAccount() {
       
        TestALRCommon.CreateDealer('TestName');
            
    }

    static testMethod void testTimelyDuration() {
        //TestALRCommon.CreateCustomSetting();
        //Get the user ID
        Id uId = UserInfo.getUserId();
    
        //Create an Account
        Account oAccount = new Account();
        oAccount.Name = 'Unit Test Account';
        oAccount.Opportunity_Recipient__c = uId;
        //oAccount.Type = 'Branded-Partner-Residential';
        //oAccount.sfdc_timely_updates__c = 0;
        oAccount.Opp_Convert_Rate__c = 0;
        oAccount.Contact_SLA__c = 5;
        oAccount.RSM_Discretionary_Adj__c = 0;
        oAccount.BillingStreet = '1391 Speer Blvd';
        oAccount.BillingCity = 'Denver';
        oAccount.BillingState = 'CO';
        oAccount.BillingPostalCode = '80204';
        oAccount.BillingCountry = 'United States';
        insert oAccount; 
          
        RecordType rt = [Select  r.Id, r.SobjectType, r.Name From RecordType r where sobjecttype ='Opportunity' and Name = 'Home Owner' LIMIT 1];
          
        //Create an Opportunity
        Opportunity oOpportunity = new Opportunity();
        oOpportunity.AccountId = oAccount.Id;
        oOpportunity.Name = 'Unit Test Opportuntiy';
        oOpportunity.OwnerId = uId;
        oOpportunity.CloseDate = System.Today() + 5;
        oOpportunity.StageName = 'Contacted';
        oOpportunity.Type = rt.id;
        insert oOpportunity;
       
        oOpportunity.StageName = 'Visit Completed';
        update oOpportunity;
        
        //OpportunityFieldHistory h = new OpportunityFieldHistory();
        //h.OpportunityId   = oOpportunity.Id;
        ////h.OldValue          = 'Contacted';
        ////h.NewValue          = 'Visit Completed';
        //h.Field                   = 'StageName';
        //insert h;
                                                
                                                
        //Fix once we get information from Tanya on how its suppose to work 
        //Opportunity o1 = [select sfdc_timely_updates__c from Opportunity where id = :oOpportunity.Id];
        //system.assert(o1.sfdc_timely_updates__c == 0);

        //Account a1 = [select sfdc_timely_updates__c from Account where id = :oAccount.Id];
        //system.assert(a1.sfdc_timely_updates__c == 0);
                
    }
    
    static testMethod void testGetTopDealers() {
        //1. Insert Accounts
        
        //RecordType PartnerRecordTypeAccount = [Select  r.Id, r.SobjectType, r.Name From RecordType r where sobjecttype ='Account' and Name= 'Partner' LIMIT 1];
        
        Account a = new Account();
        a.Name                                      = 'Really Bright Solar';
        a.Type                                      = 'Premier-Partner-Residential'; //PartnerRecordTypeAccount .Id;
        a.Dealer_Score_Total__c                 = 78;
        a.Dealer_Locator_Phone__c           = '888-888-8888';
        a.Phone                                     = '888-888-8888';
        a.BillingStreet                             = '150 Corona St';
        a.BillingCity                               = 'Denver';
        a.BillingState                              = 'CO';
        a.BillingCountry                            = 'USA';
        a.BillingPostalCode                         = '80218';
        a.website                                   = 'www.sunpowercorp.com';
        a.Oracle_Account_Number__c      = '123';
        a.Description                               = 'None';
        a.Partner_Facts__c                      = 'None';
        a.Status__c                                 = 'Active';
        a.Dealer_Locator_Opt_Out__c         = false;
        a.Lead_Flow_Opt_Out__c              = false;
        a.Alliance_Program_Partner__c       = true;
        insert a;
        
        Dealer_Assignment_Audit__c leadAssignment = DealerUtility.ConfigureDealerAssignmentAudit('Test', a.Id, null, 'test', 'none');
        system.assert(leadAssignment != null);
        
        //2. Insert CoverageArea__c
        CoverageArea__c ca = new CoverageArea__c();
        ca.Account__c                       = a.id;
        ca.Geolocation__Latitude__s     = 39.718887;
        ca.Geolocation__Longitude__s    = -104.974036;
        ca.Radius__c                            = 1000;
        insert ca;
        
        Business_Registration__c br = new Business_Registration__c();
        br.Name                 = a.billingstate;
        br.Account__c       = a.id;
        //br.Expires_On__c  = a.Contractors_Lic_Expiry__c;
        br.License_Number__c = '000000';
        br.Country__c           = a.billingCountry;
        br.State__c             = a.billingstate;
        insert br;
        
        //RecordType PartnerRecordTypeAgreement = [Select  r.Id, r.SobjectType, r.Name From RecordType r 
        //                                              where sobjecttype ='echosign_dev1__SIGN_Agreement__c' and Name = 'Partner Agreement' LIMIT 1];
                                                        
        //echosign_dev1__SIGN_Agreement__c ag = new echosign_dev1__SIGN_Agreement__c();
        
        //ag.Account__c                         = a.id;
        //ag.echosign_dev1__Status__c   = 'Signed';
        ////ag.Agreement_Type_2__c      = 'Partner Agreement';
        //ag.recordTypeId                       = PartnerRecordTypeAgreement.Id;
        //ag.Name                               = 'Lead Handling Policy Agreement';
        //insert ag;                                                                        
                                                                                                
        //3. 
        GeocodeAsyncHandler.GeoInfo info = new GeocodeAsyncHandler.GeoInfo();
        info.State  = 'CO';
        info.Lat        = 39.721956;
        info.Lon    = -104.974382;

        list<DealerResult> listDealerResults = DealerUtility.getTopDealers(39.721956, -104.974382, info, 'USA', 10);
        system.debug('@@@@@TestDealerUtility.testGetTopDealers; ' + listDealerResults.size()); //system.assert(listDealerResults.size() != 0);
    }    
}