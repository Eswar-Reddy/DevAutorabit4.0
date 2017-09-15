/*   This is a Test Class For Trigger "UpdateTotalNumberOfCampaignMembers"    */


@isTest
private class TestUpdateTotalNumberOfCampaignMembers {
    static testMethod void updateCampaignMember() {
        
        Campaign lstCamp = new Campaign(); 
       //     lstCamp.RecordTypeId = 'Standard';
            lstCamp.Campaign_ID__c = 'Reetan';
            lstCamp.Name = 'Reetan';
       //     lstCamp.CurrencyIsoCode = 'EUR - Euro';
            insert lstCamp;    
            
        Lead Ld = new Lead();
            Ld.FirstName = 'Test';
            Ld.LastName = 'Commercial';
            Ld.Lead_Type__c='Commercial';
            Ld.Company = 'TEST Company A';
            Ld.Country = 'North America';
            Ld.Email = 'testEmail@test123.com';
            Ld.Phone = '09829098290';
            Ld.LeadSource = 'Web';      
            insert Ld;          
            
        Contact cont = new Contact();
            cont.FirstName = 'testContact';
            cont.LastName = 'testContact';
            cont.Email = 'testcheck@testing.com';
            cont.Phone = '123456';   
            insert cont;
            
        List<CampaignMember> lstCampMem = new List<CampaignMember>();

            CampaignMember CM1 = new CampaignMember();
                CM1.LeadId = Ld.Id;
                CM1.CampaignId = lstCamp.Id;
           //     CM1.ContactId = cont.Id;
                CM1.Status = 'Sent';
                lstCampMem.add(CM1);
    
               
            if(lstCampMem.size() > 0 && lstCampMem != null) {
                insert lstCampMem;
            }       
            
            if(lstCampMem.size() > 0 && lstCampMem != null) {
                delete lstCampMem;
            }   

    }    
}