/*********************************************************************
    Name  : TestPopulateCampaignOnLead
    Author: Appirio Offshore (Anuradha)
    Date  : May 07,2011
    Related Case: 00062997 
    Description:This is a Test Class For Trigger "PopulateCampaignOnLead".
*********************************************************************/
@isTest
private class TestPopulateCampaignOnLead {
    
    
    static testMethod void test1 () {
        //Lead insert
        Lead testLead = new Lead(); 
        testLead.FirstName = 'Test';
        testLead.LastName = 'Commercial';
        testLead.Lead_Type__c='Commercial';
        testLead.Company = 'TEST Company A';
        testLead.Country = 'North America';
        testLead.Email = 'testEmail@test123.com';
        testLead.Phone = '09829098290';
        testLead.LeadSource = 'Web';
        testLead.Rating='';
        insert testLead;
    
        // CampaignMember insert
        List<Campaign> campList = [select id from Campaign limit 2];
        List<CampaignMember> cmList = new List<CampaignMember>();
        CampaignMember cm1 = new CampaignMember();
        cm1.LeadId = testLead.Id;
        cm1.CampaignId = campList[0].Id;
        cm1.Status = 'Sent';
        cmList.add(cm1);
        
        CampaignMember cm2 = new CampaignMember();
        cm2.LeadId = testLead.Id;
        cm2.CampaignId = campList[1].Id;
        cm2.Status = 'Responded';
        cmList.add(cm2);
        if(cmList.size() > 0 && cmList != null)
            insert cmList;

        Lead leadAfterCMInsert = [select id, campaign_on_lead__c from Lead where id = :testLead.Id];
        System.assert(leadAfterCMInsert.campaign_on_lead__c);
        
        if(cmList.size() > 0 && cmList != null)
            delete cmList;
        Lead leadAfterCMDelete = [select id, campaign_on_lead__c from Lead where id = :testLead.Id];
        System.assert(!leadAfterCMDelete.campaign_on_lead__c);   
    }
    
    static testMethod void test2(){
        
        UserRole internalRole = [select Id from UserRole where PortalType = 'None' Limit 1];
        
        UserManagement.IS_TEST = true;
        
        User U = TestUtils.createUser ('System Administrator',false);
        U.UserRoleId = internalRole.Id;
        U.ByPassValidation__c = false;
        insert U;
        
        Util.currentUser=U;
        
        System.runAs(U){
            //Lead insert
            Lead testLead = new Lead(); 
            testLead.FirstName = 'Test2';
            testLead.LastName = 'Commercial2';
            testLead.Lead_Type__c='Commercial';
            testLead.Company = 'TEST Company A2';
            testLead.Country = 'North America';
            testLead.Email = 'testEmail2@test1232.com';
            testLead.Phone = '19829098292';
            testLead.LeadSource = 'Web';
            testLead.Business_Unit__c ='NA Commercial';
            testLead.RecordTypeId=Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Systems').getRecordTypeId();
            testLead.Rating='A';
            insert testLead;
                       
            List<Campaign> campList = [select id from Campaign limit 2];
            CampaignMember cm1 = new CampaignMember();
            cm1.LeadId = testLead.Id;
            cm1.CampaignId = campList[1].Id;
            cm1.Status = 'Responded';
            insert cm1;
        }
    }
}