/***********************************************************************************************************************************************************
 Name: TestLeadDealerUtility 

 Revision History:
 
    Date            Updated By 
 ***********************************************************************************************************************************************************
  4-22-2015         Niket Chandane
  29.JUN.2015       MAM 
 
 */
 
 
@isTest
private class TestLeadDealerUtility {
    
    private static ID ResidentialRecordTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.SobjectType).get('Home_Owner');
     /* Paid Campaign and Dealer Assignemnt test*/
    static testMethod void lead_PaidCampaign_OneDealer() {
            
        TestALRCommon.CreateCustomSetting();
        
        User sysAdmin = TestClassFactory.testUser('System Administrator', 'test@test.com', 'rtestp');
        sysAdmin.Country = 'USA';
        sysAdmin.Division = 'Test';
        sysAdmin.SOX_Profile_was_approval_received__c = true;
        //insert sysAdmin;
        
        system.runAs(sysAdmin){
            
            list<ALR_Theaters__c> lstALR = new list<ALR_Theaters__c>();
            
            lstALR.add(TestClassFactory.testALRTheaterSetting());
            ALR_Theaters__c theater2 = TestClassFactory.testALRTheaterSetting();
            theater2.Name = 'Australia';
            lstALR.add(theater2);
            
            insert lstALR;
        }
        
        Campaign c = new Campaign(Name ='Test', Type = 'Other');
        c.AssignRandomPartner__c = TRUE;
        insert c;
        
        Account partner = TestALRCommon.Lead_CreateDealer('Partner1');
        partner.Opportunity_Recipient__c = UserInfo.getUserId();
        update partner;
        
        Campaign_Partner__c cp  = TestClassFactory.testCampaignPartner('A', c.Id, partner.Id, true, 'Standard');
        insert cp;
        
        //test.startTest(); //MAM 29.JUN.2015 fix
        Lead objLead = getLead('test@t.com','Test Company');
        insert objLead;
        
        CampaignMember objCampMember = new CampaignMember();
        objCampMember.CampaignId = c.id;
        objCampMember.LeadId = objLead.id;
        insert objCampMember;
        
        set<Id> leadsForALR = new Set<Id>();
        leadsForALR.add(objLead.Id);
        
        test.startTest(); //MAM 29.JUN.2015 fix
        LeadDealerUtility.futureLeadAutoConvert(leadsForALR);
        test.stopTest();
    }
    
    /* Paid Campaign and Dealer Assignemnt test*/
    static testMethod void lead_PaidCampaign_MoreDealer() {
            
        TestALRCommon.CreateCustomSetting();
        
        User sysAdmin = TestClassFactory.testUser('System Administrator', 'test@test.com', 'rtestp');
        sysAdmin.Country = 'USA';
        sysAdmin.Division = 'Test';
        sysAdmin.SOX_Profile_was_approval_received__c = true;
        //insert sysAdmin;
        
        system.runAs(sysAdmin){
            
            list<ALR_Theaters__c> lstALR = new list<ALR_Theaters__c>();
            
            lstALR.add(TestClassFactory.testALRTheaterSetting());
            ALR_Theaters__c theater2 = TestClassFactory.testALRTheaterSetting();
            theater2.Name = 'Australia';
            lstALR.add(theater2);
            
            insert lstALR;
        }
        
        Campaign c = new Campaign(Name ='Test', Type = 'Other');
        c.AssignRandomPartner__c = TRUE;
        insert c;
        
        list<Account> lstpartner = new list<Account>();
        
        Account partner = TestALRCommon.Lead_CreateDealer('Partner1');
        partner.Opportunity_Recipient__c = UserInfo.getUserId();
        lstpartner.add(partner);
        
        Account partner2 = TestALRCommon.Lead_CreateDealer('Partner2');
        partner2.Opportunity_Recipient__c = UserInfo.getUserId();
        partner2.Type = 'Master-Partner-Combo';
        lstpartner.add(partner2);
        
        Account partner3 = TestALRCommon.Lead_CreateDealer('Partner3');
        partner3.Opportunity_Recipient__c = UserInfo.getUserId();
        lstpartner.add(partner3);
        update lstpartner;
        
        list<Campaign_Partner__c> lstCampaignPartner = new List<Campaign_Partner__c>();
        
        Campaign_Partner__c cp  = TestClassFactory.testCampaignPartner('A', c.Id, partner.Id, true, 'Standard');
        
        lstCampaignPartner.add(cp);
        
        Campaign_Partner__c cp2  = TestClassFactory.testCampaignPartner('B', c.Id, partner2.Id, true, 'Standard');
        lstCampaignPartner.add(cp2);
        
        Campaign_Partner__c cp3  = TestClassFactory.testCampaignPartner('C', c.Id, partner3.Id, true, 'Standard');
        insert lstCampaignPartner;
        
        
        //test.startTest(); //MAM 29.JUN.2015 fix
        List<Lead> leads = new List<Lead>();
        Lead l1 = getLead('1@noemail.com', 'Test11');
        l1.Dealer_Locator_Selection__c = partner.Id;
        l1.Status = 'Disqualified';
        leads.add(l1);
        Lead l2 = getLead('2@noemail.com', 'Test22');
        l2.Dealer_Locator_Selection__c = partner.Id;
        l2.Status = 'Disqualified';
        leads.add(l2);
        Lead l3 = getLead('3@noemail.com', 'Test33');
        l3.Dealer_Locator_Selection__c = partner2.Id;
        l3.Status = 'Disqualified';
        leads.add(l3);
        
        Lead objLead = getLead('test@tabc.com','Test Company');
        leads.add(objLead);
        
        insert leads;
        
                // Create Dealer Assignment
        list<Lead_Dealer_Assignment_Audit__c> lstDealerAssignAudit = new list<Lead_Dealer_Assignment_Audit__c>();
        Lead_Dealer_Assignment_Audit__c ldaa = createLeadDealerAssignment(partner,c);
        ldaa.Lead__c = l1.Id;
        lstDealerAssignAudit.add(ldaa);
        Lead_Dealer_Assignment_Audit__c ldaa2 = createLeadDealerAssignment(partner2,c);
        ldaa2.Lead__c = l2.Id;
        lstDealerAssignAudit.add(ldaa2);
        Lead_Dealer_Assignment_Audit__c ldaa3 = createLeadDealerAssignment(partner3,c);
        ldaa3.Lead__c = l3.Id;
        lstDealerAssignAudit.add(ldaa3);
        
        upsert lstDealerAssignAudit;
        
        CampaignMember objCampMember = new CampaignMember();
        objCampMember.CampaignId = c.id;
        objCampMember.LeadId = objLead.id;
        insert objCampMember;
        
        set<Id> leadsForALR = new Set<Id>();
        leadsForALR.add(objLead.Id);
        
        test.startTest(); //MAM 29.JUN.2015 fix
        LeadDealerUtility.futureLeadAutoConvert(leadsForALR);
        test.stopTest();
    }
    
     /* Non Campaign and Dealer Assignemnt test*/
    
    static testMethod void lead_nonPaidCampaign() {
        TestALRCommon.CreateCustomSetting();
        
        User sysAdmin = TestClassFactory.testUser('System Administrator', 'test@test.com', 'rtestp');
        sysAdmin.Country = 'USA';
        sysAdmin.Division = 'Test';
        sysAdmin.SOX_Profile_was_approval_received__c = true;
        //insert sysAdmin;
        
        system.runAs(sysAdmin){
            
            list<ALR_Theaters__c> lstALR = new list<ALR_Theaters__c>();
            
            lstALR.add(TestClassFactory.testALRTheaterSetting());
            ALR_Theaters__c theater2 = TestClassFactory.testALRTheaterSetting();
            theater2.Name = 'Australia';
            lstALR.add(theater2);
            
            insert lstALR;
        }
        
        Campaign c = new Campaign(Name ='Test', Type = 'Other');
        c.AssignRandomPartner__c = false;
        insert c;
        
        Account partner = TestALRCommon.Lead_CreateDealer('Partner1');
        partner.Opportunity_Recipient__c = UserInfo.getUserId();
        update partner;
        
        Campaign_Partner__c cp  = TestClassFactory.testCampaignPartner('A', c.Id, partner.Id, true, 'Standard');
        insert cp;
        
        //test.startTest(); //MAM 29.JUN.2015 fix
        Lead objLead = getLead('test@t.com','Test Company');
        insert objLead;
        
        CampaignMember objCampMember = new CampaignMember();
        objCampMember.CampaignId = c.id;
        objCampMember.LeadId = objLead.id;
        insert objCampMember;
        
        set<Id> leadsForALR = new Set<Id>();
        leadsForALR.add(objLead.Id);
        
        test.startTest(); //MAM 29.JUN.2015 fix
        LeadDealerUtility.futureLeadAutoConvert(leadsForALR);
        test.stopTest();
     }
    
     /* Alliance Campaign and Dealer Assignemnt test*/
     static testMethod void lead_AllianceCampaign() {
        TestALRCommon.CreateCustomSetting();
        
        User sysAdmin = TestClassFactory.testUser('System Administrator', 'test@test.com', 'rtestp');
        sysAdmin.Country = 'USA';
        sysAdmin.Division = 'Test';
        sysAdmin.SOX_Profile_was_approval_received__c = true;
        //insert sysAdmin;
        
        system.runAs(sysAdmin){
            
            list<ALR_Theaters__c> lstALR = new list<ALR_Theaters__c>();
            
            lstALR.add(TestClassFactory.testALRTheaterSetting());
            ALR_Theaters__c theater2 = TestClassFactory.testALRTheaterSetting();
            theater2.Name = 'Australia';
            lstALR.add(theater2);
            
            insert lstALR;
        }
        
        Campaign c = new Campaign(Name ='Test', Type = 'Other');
        c.AssignRandomPartner__c = false;
        c.Type = 'Alliance';
        insert c;
        
        Account partner = TestALRCommon.Lead_CreateDealer('Partner1');
        partner.Opportunity_Recipient__c = UserInfo.getUserId();
        partner.Alliance_Program_Partner__c = true;
        update partner;
        
        Campaign_Partner__c cp  = TestClassFactory.testCampaignPartner('A', c.Id, partner.Id, true, 'Standard');
        insert cp;
        
        //test.startTest(); //MAM 29.JUN.2015 fix
        Lead objLead = getLead('test@t.com','Test Company');
        insert objLead;
        
        CampaignMember objCampMember = new CampaignMember();
        objCampMember.CampaignId = c.id;
        objCampMember.LeadId = objLead.id;
        insert objCampMember;
        
        set<Id> leadsForALR = new Set<Id>();
        leadsForALR.add(objLead.Id);
        
        test.startTest(); //MAM 29.JUN.2015 fix
        LeadDealerUtility.futureLeadAutoConvert(leadsForALR);
        test.stopTest();
    }
    
    /* No Campaign and Dealer Assignemnt test*/
    static testMethod void lead_noCampaign() {
        TestALRCommon.CreateCustomSetting();
        
        User sysAdmin = TestClassFactory.testUser('System Administrator', 'test@test.com', 'rtestp');
        sysAdmin.Country = 'USA';
        sysAdmin.Division = 'Test';
        sysAdmin.SOX_Profile_was_approval_received__c = true;
        //insert sysAdmin;
        
        system.runAs(sysAdmin){
            
            list<ALR_Theaters__c> lstALR = new list<ALR_Theaters__c>();
            
            lstALR.add(TestClassFactory.testALRTheaterSetting());
            ALR_Theaters__c theater2 = TestClassFactory.testALRTheaterSetting();
            theater2.Name = 'Australia';
            lstALR.add(theater2);
            
            insert lstALR;
        }
        
        Account partner = TestALRCommon.Lead_CreateDealer('Partner1');
        partner.Opportunity_Recipient__c = UserInfo.getUserId();
        partner.Additional_Opportunity_Email_Recipient__c = 'test@noemail.com';
        partner.Type = 'Master-Partner-Combo';
        update partner;
        
        //test.startTest(); //MAM 29.JUN.2015 fix
        Lead objLead = getLead('testnoCampaign@t.com','Test Company');
        insert objLead;
        
        set<Id> leadsForALR = new Set<Id>();
        leadsForALR.add(objLead.Id);
        
        test.startTest(); //MAM 29.JUN.2015 fix
        LeadDealerUtility.futureLeadAutoConvert(leadsForALR);
        LeadDealerUtility.CanUseFutureContext();
        LeadDealerUtility.getMaxFutureCallsAllowed();
        test.stopTest();
     }
    
    /* No Dealer Assignement Test*/
    static testMethod void lead_NoDealerAssigment() {
        TestALRCommon.CreateCustomSetting();
        
        User sysAdmin = TestClassFactory.testUser('System Administrator', 'test@test.com', 'rtestp');
        sysAdmin.Country = 'USA';
        sysAdmin.Division = 'Test';
        sysAdmin.SOX_Profile_was_approval_received__c = true;
        //insert sysAdmin;
        
        system.runAs(sysAdmin){
            
            list<ALR_Theaters__c> lstALR = new list<ALR_Theaters__c>();
            
            lstALR.add(TestClassFactory.testALRTheaterSetting());
            ALR_Theaters__c theater2 = TestClassFactory.testALRTheaterSetting();
            theater2.Name = 'Australia';
            lstALR.add(theater2);
            
            insert lstALR;
        }
        
        Account partner = TestALRCommon.CreateDealer('Partner1');
        partner.Opportunity_Recipient__c = UserInfo.getUserId();
        update partner;
        
        test.startTest();
        Lead objLead = getLead('testnoCampaign@t.com','Test Company');
        insert objLead;
        
        set<Id> leadsForALR = new Set<Id>();
        leadsForALR.add(objLead.Id);
        
        LeadDealerUtility.futureLeadAutoConvert(leadsForALR);
        test.stopTest();
     }
    
    /**************** SPD Dealer Assignement and Lead outside the USA *******************/
    static testMethod void lead_SPDDealerAssigment() {
        
        TestALRCommon.CreateCustomSetting();
        
        User sysAdmin = TestClassFactory.testUser('System Administrator', 'test@test.com', 'rtestp');
        sysAdmin.Country = 'USA';
        sysAdmin.Division = 'Test';
        sysAdmin.SOX_Profile_was_approval_received__c = true;
        //insert sysAdmin;
        
        system.runAs(sysAdmin){
            
            list<ALR_Theaters__c> lstALR = new list<ALR_Theaters__c>();
            
            lstALR.add(TestClassFactory.testALRTheaterSetting());
            ALR_Theaters__c theater2 = TestClassFactory.testALRTheaterSetting();
            theater2.Name = 'Australia';
            lstALR.add(theater2);
            
            insert lstALR;
        }
        
        test.startTest();
        list<Lead> lstLead = new list<Lead>();
        
        Lead objLead1 = getLead('testnoCampaign@t.com','Test Company1');
        objLead1.Dealer_Locator_Selection__c = system.label.SPDIds;
        lstLead.add(objLead1);
        
        Account partner = TestALRCommon.CreateDealer('Partner1');
        partner.Opportunity_Recipient__c = UserInfo.getUserId();
        update partner;
        
        Lead objLead2 = getLead('testAustralia@t.com','Test Company2');
        objLead2.Dealer_Name__c = partner.id; //system.label.SPDIds;
        objLead2.Theater__c = 'Australia';
        lstLead.add(objLead2);
        
        insert lstLead;
        
        set<Id> leadsForALR = new Set<Id>();
        leadsForALR.add(objLead1.Id);
        leadsForALR.add(objLead2.Id);
        
        LeadDealerUtility.futureLeadAutoConvert(leadsForALR);
        test.stopTest();
     }
    
    /**************** SPD Dealer Assignement and Lead outside the USA *******************/
    static testMethod void lead_FutureDealerAssigment() {
        
        TestALRCommon.CreateCustomSetting();
        
        User sysAdmin = TestClassFactory.testUser('System Administrator', 'test@test.com', 'rtestp');
        sysAdmin.Country = 'USA';
        sysAdmin.Division = 'Test';
        sysAdmin.SOX_Profile_was_approval_received__c = true;
        //insert sysAdmin;
        
        system.runAs(sysAdmin){
            
            list<ALR_Theaters__c> lstALR = new list<ALR_Theaters__c>();
            
            lstALR.add(TestClassFactory.testALRTheaterSetting());
            ALR_Theaters__c theater2 = TestClassFactory.testALRTheaterSetting();
            theater2.Name = 'Australia';
            lstALR.add(theater2);
            
            insert lstALR;
        }
        
        test.startTest();
        list<Lead> lstLead = new list<Lead>();
        
        Lead objLead1 = getLead('testnoCampaign@t.com','Test Company1');
        objLead1.Dealer_Name__c = system.label.SPDIds;
        lstLead.add(objLead1);
        
        Account partner = TestALRCommon.CreateDealer('Partner1');
        partner.Opportunity_Recipient__c = UserInfo.getUserId();
        update partner;
        
        Lead objLead2 = getLead('testAustralia@t.com','Test Company2');
        objLead2.Dealer_Name__c = partner.id; //system.label.SPDIds;
        objLead2.Theater__c = 'Australia';
        lstLead.add(objLead2);
        
        Lead objLead3 = getLead('testAustralia@t.com','Test Company2');
        objLead3.Dealer_Name__c = partner.id; //system.label.SPDIds;
        objLead3.Lead_Manufacturer__c = 'ABC';
        lstLead.add(objLead3);
        
        insert lstLead;
        
        set<Id> leadsForALR = new Set<Id>();
        leadsForALR.add(objLead1.Id);
        leadsForALR.add(objLead2.Id);
        
        LeadDealerUtility.futureLeadAutoConvertSPD(leadsForALR);
        ALRConfiguration.SendEmailAlert('TestSubject','Test Notification');
        //LeadDealerUtility.futureLeadAutoConvert(leadsForALR);
        test.stopTest();
     }
    
    private static Lead getLead(String Email,String CompanyName){
        Lead newLead = TestClassFactory.testLead('TestLastName',CompanyName, Email);
        newLead.Street = '2905 Inca St';
        newLead.City = 'Denver';
        newLead.State = 'CO';
        newLead.PostalCode = '80202';
        newLead.Country = 'United States';
        newLead.IsAutoConvert__c = FALSE;
        newLead.RecordTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Lead.SobjectType).get('Residential');
        newLead.Theater__c = 'North America';
        newLead.Status = 'Marketing Qualified';
        newLead.Lead_Manufacturer__c =  system.label.ALR_Lead_SunPower;
        return newLead;
    }
        
    private static Lead_Dealer_Assignment_Audit__c createLeadDealerAssignment(Account acc, Campaign cam)
    {
        Lead_Dealer_Assignment_Audit__c objDAA = new Lead_Dealer_Assignment_Audit__c();
        objDAA.Campaign__c = cam.id;
        objDAA.Dealer_Assigned__c = acc.id;
        objDAA.Assignment_Date__c = system.today();
        objDAA.ALR_Rule_Applied__c = 'Testing';
        objDAA.Name = 'Dealer Assigned 1';
        return objDAA;
    }
    
     /* Paid Campaign and Dealer Assignemnt test*/
    static testMethod void lead_PaidCampaign_ReassignmentOneDealer() {
            
        TestALRCommon.CreateCustomSetting();
        
        User sysAdmin = TestClassFactory.testUser('System Administrator', 'test@test.com', 'rtestp');
        sysAdmin.Country = 'USA';
        sysAdmin.Division = 'Test';
        sysAdmin.SOX_Profile_was_approval_received__c = true;
        //insert sysAdmin;
        
        system.runAs(sysAdmin){
            
            list<ALR_Theaters__c> lstALR = new list<ALR_Theaters__c>();
            
            lstALR.add(TestClassFactory.testALRTheaterSetting());
            ALR_Theaters__c theater2 = TestClassFactory.testALRTheaterSetting();
            theater2.Name = 'Australia';
            lstALR.add(theater2);
            
            insert lstALR;
        }
        
        Campaign c = new Campaign(Name ='Test', Type = 'Other');
        c.AssignRandomPartner__c = TRUE;
        insert c;
        
        Account partner = TestALRCommon.Lead_CreateDealer('Partner1');
        partner.Opportunity_Recipient__c = UserInfo.getUserId();
        update partner;
        
        Campaign_Partner__c cp  = TestClassFactory.testCampaignPartner('A', c.Id, partner.Id, true, 'Standard');
        insert cp;
        
        Lead objLead = getLead('test@t.com','Test Company');
        objLead.Status = 'Disqualified';
        insert objLead;
        
        CampaignMember objCampMember = new CampaignMember();
        objCampMember.CampaignId = c.id;
        objCampMember.LeadId = objLead.id;
        insert objCampMember;
        
        set<Id> leadsForALR = new Set<Id>();
        leadsForALR.add(objLead.Id);
        
        test.startTest();
        LeadDealerUtility.leadReassignment(leadsForALR);
        test.stopTest();
    }
    
    //Pre-qualification Testing
    static testMethod void lead_PreQual_OneDealer() {
            
        TestALRCommon.CreateCustomSetting();
        
        User sysAdmin = TestClassFactory.testUser('System Administrator', 'test@test.com', 'rtestp');
        sysAdmin.Country = 'USA';
        sysAdmin.Division = 'Test';
        sysAdmin.SOX_Profile_was_approval_received__c = true;
        //insert sysAdmin;
        
        system.runAs(sysAdmin){
            
            list<ALR_Theaters__c> lstALR = new list<ALR_Theaters__c>();
            
            lstALR.add(TestClassFactory.testALRTheaterSetting());
            ALR_Theaters__c theater2 = TestClassFactory.testALRTheaterSetting();
            theater2.Name = 'Australia';
            lstALR.add(theater2);
            
            insert lstALR;
        }
        
        Campaign c = new Campaign(Name ='Test', Type = 'Other');
        c.AssignRandomPartner__c = TRUE;
        c.Requires_Lead_Pre_Qualification__c = TRUE;
        insert c;
        
        Account partner = TestALRCommon.Lead_CreateDealer('Partner1');
        partner.Opportunity_Recipient__c = UserInfo.getUserId();
        update partner;
        
        Campaign_Partner__c cp  = TestClassFactory.testCampaignPartner('A', c.Id, partner.Id, true, 'Warm Transfer');
        insert cp;
        
        Lead objLead = getLead('test@t.com','Test Company');
        insert objLead;
        
        CampaignMember objCampMember = new CampaignMember();
        objCampMember.CampaignId = c.id;
        objCampMember.LeadId = objLead.id;
        insert objCampMember;
        
        set<Id> leadsForALR = new Set<Id>();
        leadsForALR.add(objLead.Id);
        
        test.startTest(); 
        LeadDealerUtility.futureLeadAutoConvert(leadsForALR);
        test.stopTest();
    }

//Pre-qualification Testing
    static testMethod void NewHomes_OneDealer() {
            
        TestALRCommon.CreateCustomSetting();
        
        User sysAdmin = TestClassFactory.testUser('System Administrator', 'test@test.com', 'rtestp');
        sysAdmin.Country = 'USA';
        sysAdmin.Division = 'Test';
        sysAdmin.SOX_Profile_was_approval_received__c = true;
        //insert sysAdmin;
        
        system.runAs(sysAdmin){
            
            list<ALR_Theaters__c> lstALR = new list<ALR_Theaters__c>();
            
            lstALR.add(TestClassFactory.testALRTheaterSetting());
            ALR_Theaters__c theater2 = TestClassFactory.testALRTheaterSetting();
            theater2.Name = 'Australia';
            lstALR.add(theater2);
            
            insert lstALR;
        }
        
        
        Account partner = TestALRCommon.Lead_CreateDealer('Partner1');
        partner.Opportunity_Recipient__c = UserInfo.getUserId();
        update partner;
        
        NH_Community__c community = TestClassFactory.testNHCommunity(partner.Id);
        insert community;
        
        Campaign c = new Campaign(Name ='Test', Type = 'Other');
        c.Requires_Lead_Pre_Qualification__c = TRUE;
        c.NH_Community__c = community.Id;
        c.Five9__Five9list__c = 'testlist123';
        insert c;
        
        
        Campaign_Partner__c cp  = TestClassFactory.testCampaignPartner('A', c.Id, partner.Id, true, 'Standard');
        insert cp;
        
        Lead objLead = getLead('test@t.com','Test Company');
        insert objLead;
        
        CampaignMember objCampMember = new CampaignMember();
        objCampMember.CampaignId = c.id;
        objCampMember.LeadId = objLead.id;
        insert objCampMember;
        
        set<Id> leadsForALR = new Set<Id>();
        leadsForALR.add(objLead.Id);
        
        test.startTest(); 
        LeadDealerUtility.futureLeadAutoConvert(leadsForALR);
        test.stopTest();
    } 
    
    static testMethod void AllianceCampaign_ReassignmentOneDealer() {
            
        TestALRCommon.CreateCustomSetting();
        
        User sysAdmin = TestClassFactory.testUser('System Administrator', 'test@test.com', 'rtestp');
        sysAdmin.Country = 'USA';
        sysAdmin.Division = 'Test';
        sysAdmin.SOX_Profile_was_approval_received__c = true;
        //insert sysAdmin;
        
        system.runAs(sysAdmin){
            
            list<ALR_Theaters__c> lstALR = new list<ALR_Theaters__c>();
            
            lstALR.add(TestClassFactory.testALRTheaterSetting());
            ALR_Theaters__c theater2 = TestClassFactory.testALRTheaterSetting();
            theater2.Name = 'Australia';
            lstALR.add(theater2);
            
            insert lstALR;
        }
        
        Campaign c = new Campaign(Name ='Test', Type = 'Alliance', RecordTypeId = TestClassFactory.retrieveRecordTypeID('Campaign', 'Alliance'));
        insert c;
        
        Account partner = TestALRCommon.Lead_CreateDealer('Partner1');
        partner.Opportunity_Recipient__c = UserInfo.getUserId();
        partner.Alliance_Program_Partner__c = true;
        update partner;
        
        Campaign_Partner__c cp  = TestClassFactory.testCampaignPartner('A', c.Id, partner.Id, true, 'Standard');
        insert cp;
        
        Lead objLead = getLead('test@t.com','Test Company');
        objLead.Status = 'Disqualified';
        insert objLead;
        
        CampaignMember objCampMember = new CampaignMember();
        objCampMember.CampaignId = c.id;
        objCampMember.LeadId = objLead.id;
        insert objCampMember;
        
        set<Id> leadsForALR = new Set<Id>();
        leadsForALR.add(objLead.Id);
        
        test.startTest();
        LeadDealerUtility.leadReassignment(leadsForALR);
        test.stopTest();
    }
    
    static testMethod void NONPaid_AlreadySelected_Reassignment() {
            
        TestALRCommon.CreateCustomSetting();
        
        User sysAdmin = TestClassFactory.testUser('System Administrator', 'test@test.com', 'rtestp');
        sysAdmin.Country = 'USA';
        sysAdmin.Division = 'Test';
        sysAdmin.SOX_Profile_was_approval_received__c = true;
        //insert sysAdmin;
        
        system.runAs(sysAdmin){
            
            list<ALR_Theaters__c> lstALR = new list<ALR_Theaters__c>();
            
            lstALR.add(TestClassFactory.testALRTheaterSetting());
            ALR_Theaters__c theater2 = TestClassFactory.testALRTheaterSetting();
            theater2.Name = 'Australia';
            lstALR.add(theater2);
            
            insert lstALR;
        }
        
        Campaign c = new Campaign(Name ='Test', Type = 'Other');
        insert c;
        
        List<Account> accs = new List<Account>();
        Account partner = TestALRCommon.Lead_CreateDealer('Partner1');
        partner.Opportunity_Recipient__c = UserInfo.getUserId();
        accs.add(partner);
        
        Account partner2 = TestALRCommon.Lead_CreateDealer('Partner2');
        partner2.Opportunity_Recipient__c = UserInfo.getUserId();
        accs.add(partner2);
        
        update accs;
        
        List<Campaign_Partner__c> cps = new List<Campaign_Partner__c>();
        Campaign_Partner__c cp  = TestClassFactory.testCampaignPartner('A', c.Id, partner.Id, true, 'Standard');
        cps.add(cp);
        
        Campaign_Partner__c cp2 = TestClassFactory.testCampaignPartner('B', c.Id, partner2.Id, true, 'Standard');
        cps.add(cp2);
        
        insert cps;
        
        Lead objLead = getLead('test@t.com','Test Company');
        objLead.Status = 'Disqualified';
        objLead.Dealer_Assignment_Date__c = System.now();
        objLead.Dealer_Locator_Selection__c = partner.Id;
        insert objLead;
        
        CampaignMember objCampMember = new CampaignMember();
        objCampMember.CampaignId = c.id;
        objCampMember.LeadId = objLead.id;
        insert objCampMember;
        
        Lead_Dealer_Assignment_Audit__c audit = createLeadDealerAssignment(partner, c);
        audit.Lead__c = objLead.Id;
        insert audit;
        
        set<Id> leadsForALR = new Set<Id>();
        leadsForALR.add(objLead.Id);
        
        test.startTest();
        LeadDealerUtility.leadReassignment(leadsForALR);
        test.stopTest();
    }
    
    static testMethod void NONPaid_PreSelected_Reassignment() {
            
        TestALRCommon.CreateCustomSetting();
        
        User sysAdmin = TestClassFactory.testUser('System Administrator', 'test@test.com', 'rtestp');
        sysAdmin.Country = 'USA';
        sysAdmin.Division = 'Test';
        sysAdmin.SOX_Profile_was_approval_received__c = true;
        //insert sysAdmin;
        
        system.runAs(sysAdmin){
            
            list<ALR_Theaters__c> lstALR = new list<ALR_Theaters__c>();
            
            lstALR.add(TestClassFactory.testALRTheaterSetting());
            ALR_Theaters__c theater2 = TestClassFactory.testALRTheaterSetting();
            theater2.Name = 'Australia';
            lstALR.add(theater2);
            
            insert lstALR;
        }
        
        Campaign c = new Campaign(Name ='Test', Type = 'Other');
        insert c;
        
        List<Account> accs = new List<Account>();
        Account partner = TestALRCommon.Lead_CreateDealer('Partner1');
        partner.Opportunity_Recipient__c = UserInfo.getUserId();
        accs.add(partner);
        
        Account partner2 = TestALRCommon.Lead_CreateDealer('Partner2');
        partner2.Opportunity_Recipient__c = UserInfo.getUserId();
        accs.add(partner2);
        
        update accs;
        
        List<Campaign_Partner__c> cps = new List<Campaign_Partner__c>();
        Campaign_Partner__c cp  = TestClassFactory.testCampaignPartner('A', c.Id, partner.Id, true, 'Standard');
        cps.add(cp);
        
        Campaign_Partner__c cp2 = TestClassFactory.testCampaignPartner('B', c.Id, partner2.Id, true, 'Warm Transfer');
        cps.add(cp2);
        
        insert cps;
        
        Lead objLead = getLead('test@t.com','Test Company');
        objLead.Status = 'Disqualified';
        objLead.Dealer_Assignment_Date__c = System.now();
        objLead.Dealer_Locator_Selection__c = partner2.Id;
        insert objLead;
        
        CampaignMember objCampMember = new CampaignMember();
        objCampMember.CampaignId = c.id;
        objCampMember.LeadId = objLead.id;
        insert objCampMember;
        
        Lead_Dealer_Assignment_Audit__c audit = createLeadDealerAssignment(partner, c);
        audit.Lead__c = objLead.Id;
        insert audit;
        
        set<Id> leadsForALR = new Set<Id>();
        leadsForALR.add(objLead.Id);
        
        test.startTest();
        LeadDealerUtility.leadReassignment(leadsForALR);
        test.stopTest();
    }
    
    static testMethod void Reassignlead_noCampaign() {
        TestALRCommon.CreateCustomSetting();
        
        User sysAdmin = TestClassFactory.testUser('System Administrator', 'test@test.com', 'rtestp');
        sysAdmin.Country = 'USA';
        sysAdmin.Division = 'Test';
        sysAdmin.SOX_Profile_was_approval_received__c = true;
        //insert sysAdmin;
        
        system.runAs(sysAdmin){
            
            list<ALR_Theaters__c> lstALR = new list<ALR_Theaters__c>();
            
            lstALR.add(TestClassFactory.testALRTheaterSetting());
            ALR_Theaters__c theater2 = TestClassFactory.testALRTheaterSetting();
            theater2.Name = 'Australia';
            lstALR.add(theater2);
            
            insert lstALR;
        }
        
        Account partner = TestALRCommon.Lead_CreateDealer('Partner1');
        partner.Opportunity_Recipient__c = UserInfo.getUserId();
        update partner;
        
        //test.startTest(); //MAM 29.JUN.2015 fix
        Lead objLead = getLead('testnoCampaign@t.com','Test Company');
        insert objLead;
        
        set<Id> leadsForALR = new Set<Id>();
        leadsForALR.add(objLead.Id);
        
        test.startTest(); //MAM 29.JUN.2015 fix
        LeadDealerUtility.leadReassignment(leadsForALR);
        test.stopTest();
     }
    
    static testMethod void Reassignlead_noDealers() {
        TestALRCommon.CreateCustomSetting();
        
        User sysAdmin = TestClassFactory.testUser('System Administrator', 'test@test.com', 'rtestp');
        sysAdmin.Country = 'USA';
        sysAdmin.Division = 'Test';
        sysAdmin.SOX_Profile_was_approval_received__c = true;
        //insert sysAdmin;
        
        system.runAs(sysAdmin){
            
            list<ALR_Theaters__c> lstALR = new list<ALR_Theaters__c>();
            
            lstALR.add(TestClassFactory.testALRTheaterSetting());
            ALR_Theaters__c theater2 = TestClassFactory.testALRTheaterSetting();
            theater2.Name = 'Australia';
            lstALR.add(theater2);
            
            insert lstALR;
        }
        
        //test.startTest(); //MAM 29.JUN.2015 fix
        Lead objLead = getLead('testnoCampaign@t.com','Test Company');
        insert objLead;
        
        set<Id> leadsForALR = new Set<Id>();
        leadsForALR.add(objLead.Id);
        
        test.startTest(); //MAM 29.JUN.2015 fix
        LeadDealerUtility.leadReassignment(leadsForALR);
        test.stopTest();
     }
    
    static testMethod void NONPaid_AlreadySelected_ReassignmentTwoDealer() {
            
        TestALRCommon.CreateCustomSetting();
        
        User sysAdmin = TestClassFactory.testUser('System Administrator', 'test@test.com', 'rtestp');
        sysAdmin.Country = 'USA';
        sysAdmin.Division = 'Test';
        sysAdmin.SOX_Profile_was_approval_received__c = true;
        //insert sysAdmin;
        
        system.runAs(sysAdmin){
            
            list<ALR_Theaters__c> lstALR = new list<ALR_Theaters__c>();
            
            lstALR.add(TestClassFactory.testALRTheaterSetting());
            ALR_Theaters__c theater2 = TestClassFactory.testALRTheaterSetting();
            theater2.Name = 'Australia';
            lstALR.add(theater2);
            
            insert lstALR;
        }
        
        Campaign c = new Campaign(Name ='Test', Type = 'Other');
        insert c;
        
        List<Account> accs = new List<Account>();
        Account partner = TestALRCommon.Lead_CreateDealer('Partner1');
        partner.Opportunity_Recipient__c = UserInfo.getUserId();
        accs.add(partner);
        
        Account partner2 = TestALRCommon.Lead_CreateDealer('Partner2');
        partner2.Opportunity_Recipient__c = UserInfo.getUserId();
        partner2.Type = 'Master-Partner-Combo';
        accs.add(partner2);
        
        update accs;
        
        List<Campaign_Partner__c> cps = new List<Campaign_Partner__c>();
        Campaign_Partner__c cp  = TestClassFactory.testCampaignPartner('A', c.Id, partner.Id, true, 'Standard');
        cps.add(cp);
        
        Campaign_Partner__c cp2 = TestClassFactory.testCampaignPartner('B', c.Id, partner2.Id, true, 'Standard');
        cps.add(cp2);
        
        insert cps;
        
        List<lead> leads = new List<Lead>();
        Lead objLead = getLead('test@t.com','Test Company');
        objLead.Status = 'Disqualified';
        leads.add(objLead);
        
        Lead lead2 = getLead('test2@t.com', 'TestCo2');
        lead2.Status = 'Disqualified';
        leads.add(lead2);
        
        insert leads;
        
        Lead_Dealer_Assignment_Audit__c audit = createLeadDealerAssignment(partner, c);
        audit.Lead__c = lead2.Id;
        insert audit;
        
        CampaignMember objCampMember = new CampaignMember();
        objCampMember.CampaignId = c.id;
        objCampMember.LeadId = objLead.id;
        insert objCampMember;
        
        set<Id> leadsForALR = new Set<Id>();
        leadsForALR.add(objLead.Id);
        
        test.startTest();
        LeadDealerUtility.leadReassignment(leadsForALR);
        test.stopTest();
    }
    
    static testMethod void Preselected_lead_FutureDealerAssigment() {
        
        TestALRCommon.CreateCustomSetting();
        
        User sysAdmin = TestClassFactory.testUser('System Administrator', 'test@test.com', 'rtestp');
        sysAdmin.Country = 'USA';
        sysAdmin.Division = 'Test';
        sysAdmin.SOX_Profile_was_approval_received__c = true;
        //insert sysAdmin;
        
        system.runAs(sysAdmin){
            
            list<ALR_Theaters__c> lstALR = new list<ALR_Theaters__c>();
            
            lstALR.add(TestClassFactory.testALRTheaterSetting());
            ALR_Theaters__c theater2 = TestClassFactory.testALRTheaterSetting();
            theater2.Name = 'Australia';
            lstALR.add(theater2);
            
            insert lstALR;
        }

        Account partner = TestALRCommon.CreateDealer('Partner1');
        partner.Opportunity_Recipient__c = UserInfo.getUserId();
        update partner;
       
        Lead objLead1 = getLead('testnoCampaign@t.com','Test Company1');
        objLead1.Dealer_Name__c = partner.Id;
        objLead1.Status = 'Disqualified';
        insert objLead1;
        
        test.startTest();
        set<Id> leadsForALR = new Set<Id>();
        leadsForALR.add(objLead1.Id);
        
        LeadDealerUtility.leadReassignment(leadsForALR);

        test.stopTest();
     }
    
    
    static testmethod void ExceptionHandletest()
    {
        test.startTest();
        try{
            LeadDealerUtility.getLeadGeoInfo(null);
        }catch(Exception ex)
        {
            
        }
        test.stopTest();
    }
}