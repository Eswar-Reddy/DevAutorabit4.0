public class TestPartnerAppsRejection
{ 
    @isTest
    public static void test_method()
    {
       Lead lead = New Lead();
       lead.Company = 'LeadCompany';
       lead.Lead_Type__c ='Residential';
       lead.Status = 'Open';
       lead.Lead_Manufacturer__c='SunPower';
       lead.LeadSource ='Web';
       lead.LastName = 'TestLead';
       lead.Email = 'testlead@gmail.com';
       insert lead;
       
       Partner_Application__c partnerApps = new Partner_Application__c();
       partnerApps.Company_Name__c = 'TestCompany';
       partnerApps.Lead__c =lead.Id;
       Insert partnerApps;
             
       String strFieldType = ApexPages.CurrentPage().getParameters().put('Id',partnerApps.Id); 
       ApexPages.StandardController sController = new ApexPages.StandardController(partnerApps); 
       PartnerAppsRejection controller = new PartnerAppsRejection(sController);
       List<SelectOption> emailTemplates = new List<SelectOption>();
       emailTemplates = Controller.getTamplate();             
    
       if(emailTemplates != null && emailTemplates.size() >0)
       {         
          controller.selectedTamplate = emailTemplates.get(1).getValue();
       }       
       controller.Save();      
       }
}