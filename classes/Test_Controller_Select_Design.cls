/**********************************************************************************
Class                   :   Test_Controller_Select_Design
Related Class           :   Controller_Select_Design
Created By              :   Appirio Offshore
Created On              :   Feb 24, 2010
Last Modified			:	Aug 08, 2011
Desciption              :   Test class for apex class for Controller_Select_Design.
***********************************************************************************/
@isTest
private class Test_Controller_Select_Design {
    
     static testMethod void testController_Select_Site(){
        
                //variable for record type id of "Proposal Design"
                String recordTypeIdDesign;
                
                //querying record type id for "Proposal Design"
                List<RecordType> lstRecordTypes = [Select r.SobjectType, r.Name, r.Id, r.DeveloperName From RecordType r where r.Name = 'Proposal Design' and SobjectType ='Design__c' limit 1];
                if(lstRecordTypes != null && lstRecordTypes.size() > 0){
                    recordTypeIdDesign = lstRecordTypes.get(0).Id;
                }
                
                
                //Account test data inserted
                Account testAccount = new Account();
                testAccount.Name = 'Test Acc'+String.valueOf(DateTime.now());
                testAccount.BillingState = 'BillingState';
                testAccount.BillingCity = 'Jind';
                testAccount.BillingCountry = 'India';
                testAccount.BillingStreet = 'Rohtak Road';
                testAccount.BillingPostalCode = '126102';
                testAccount.Online_Order_Access__c = false;
                insert testAccount;
                
                //Opportunity test data inserted
                Opportunity testOpp = new Opportunity();
                testOpp.Name = 'TestOpp';
                testOpp.AccountId = testAccount.Id;
                testOpp.CloseDate = System.today().addDays(14);
                testOpp.Sales_Steps__c = 'Shortlisted';
                testOpp.Contract_Type__c = 'Design';
                testOpp.Financing__c = 'PPA';
                testOpp.Business_Unit__c = 'Utility';
                testOpp.Region__c = 'New York';
                testOpp.StageName = 'Open';
                testOpp.Probability = 5;
                testOpp.Budgetary_Pricing_Agreed_On_Date__c = System.today();
                //testOpp.Country_Manager_Signature_Date__c = System.date();
                insert testOpp;
                
                //inserting site
                Site_Information_Form__c site = new Site_Information_Form__c(Site_Name__c = 'Test Site ',Opportunity_del__c = testOpp.id, Account__c = testAccount.Id, Site_City__c = 'tCity ', Site_Status__c = 'Active', Site_State__c = 'tState ',Site_Country__c = 'tCountry ');
                insert site;
                
                //PSR__c test data inserted
                PSR__c psr1 = new PSR__c();
                psr1.site__c = site.Id;
                insert psr1;
                
                //insert design
                Design__c testDesign1 = new Design__c();
                testDesign1.PSR__c = psr1.Id;
                testDesign1.site__c = site.Id;
                testDesign1.RecordTypeId = recordTypeIdDesign;
                testDesign1.opportunity__c = testOpp.Id;
                testDesign1.Revision_Letter__c = 'A';
                //testDesign.Proposal_Designer__c = 
                testDesign1.Date_Design_Completed__c = System.today().addMonths(1);
                testDesign1.Status__c = 'Not Started';
                
                insert testDesign1;
                //Instance of Standard Controller passing the above instance of PSR
                ApexPages.StandardController stdController = new ApexPages.standardController(psr1);
                
                //instance of controller
                Controller_Select_Design controller = new Controller_Select_Design(stdController); 
                controller.selectedDesignOnPage = testDesign1.Id;
                controller.returnToPSR();
                controller.cancel();
            
     }
     
     static testMethod void testController_Select_Site2(){
             	
               Test.startTest();	
               //variable for record type id of "Proposal Design"
                String recordTypeIdDesign;
                
                //querying record type id for "Proposal Design"
                List<RecordType> lstRecordTypes = [Select r.SobjectType, r.Name, r.Id, r.DeveloperName From RecordType r where r.Name = 'Proposal Design' and SobjectType ='Design__c' limit 1];
                if(lstRecordTypes != null && lstRecordTypes.size() > 0){
                    recordTypeIdDesign = lstRecordTypes.get(0).Id;
                }
                
                
                //Account test data inserted
                Account testAccount = new Account();
                testAccount.Name = 'Test Acc'+String.valueOf(DateTime.now());
                testAccount.BillingState = 'BillingState';
                testAccount.BillingCity = 'Jind';
                testAccount.BillingCountry = 'India';
                testAccount.BillingStreet = 'Rohtak Road';
                testAccount.BillingPostalCode = '126102';
                testAccount.Online_Order_Access__c = false;
                insert testAccount;
                
                //Opportunity test data inserted
                Opportunity testOpp = new Opportunity();
                testOpp.Name = 'TestOpp';
                testOpp.AccountId = testAccount.Id;
                testOpp.CloseDate = System.today().addDays(14);
                testOpp.Sales_Steps__c = 'Shortlisted';
                testOpp.Contract_Type__c = 'Design';
                testOpp.Financing__c = 'PPA';
                testOpp.Business_Unit__c = 'Utility';
                testOpp.Region__c = 'New York';
                testOpp.StageName = 'Open';
                testOpp.Probability = 5;
                testOpp.Budgetary_Pricing_Agreed_On_Date__c = System.today();
                //testOpp.Country_Manager_Signature_Date__c = System.date();
                insert testOpp;
                
                //inserting site
                Site_Information_Form__c site = new Site_Information_Form__c(Site_Name__c = 'Test Site ',Opportunity_del__c = testOpp.id, Account__c = testAccount.Id, Site_City__c = 'tCity ', Site_Status__c = 'Active', Site_State__c = 'tState ',Site_Country__c = 'tCountry ');
                insert site;
                
                //PSR__c test data inserted
                PSR__c psr1 = new PSR__c();
                psr1.site__c = site.Id;
                insert psr1;
                
                //insert design2
                Design__c testDesign2 = new Design__c();
                testDesign2.PSR__c = psr1.Id;
                testDesign2.site__c = site.Id;
                testDesign2.RecordTypeId = recordTypeIdDesign;
                testDesign2.opportunity__c = testOpp.Id;
                testDesign2.Revision_Letter__c = 'A';
                //testDesign.Proposal_Designer__c = 
                testDesign2.Date_Design_Completed__c = System.today().addMonths(2);
                testDesign2.Status__c = 'Not Started';
                
                insert testDesign2; 
                
                psr1.design__c = testDesign2.Id;
                psr1.PM_Cost__c = true;
                update psr1;
                
                PageReference pageRef = Page.Select_Design;
        		Test.setCurrentPage(pageRef);
        		
        		ApexPages.currentPage().getParameters().put('id',psr1.Id);
                
                //Instance of Standard Controller passing the above instance of PSR
                ApexPages.StandardController stdController = new ApexPages.standardController(psr1);
                //instance of controller
                Controller_Select_Design controller = new Controller_Select_Design(stdController); 
                controller.selectedDesignOnPage = testDesign2.Id;
				System.assertEquals(true,controller.renderTable);                
                controller.returnToPSR();
                controller.cancel();
                controller.removeDesign();
				
				//PSR__c test data inserted with site null
                PSR__c psr2 = new PSR__c();
                insert psr2;
                
                //Instance of Standard Controller passing the above instance of PSR
                ApexPages.StandardController stdController2 = new ApexPages.standardController(psr2);
                //instance of controller
                Controller_Select_Design controller2 = new Controller_Select_Design(stdController2); 
                controller.selectedDesignOnPage = testDesign2.Id;
                
                //PSR__c test data inserted
                PSR__c psr3 = new PSR__c();
                psr3.site__c = site.Id;
                psr3.Array_Layout_Revision__c = true;
                insert psr3;
                
                //Instance of Standard Controller passing the above instance of PSR
                ApexPages.StandardController stdController3 = new ApexPages.standardController(psr3);
                //instance of controller
                Controller_Select_Design controller3 = new Controller_Select_Design(stdController3); 
                controller.selectedDesignOnPage = testDesign2.Id;
                
                //PSR__c test data inserted
                PSR__c psr4 = new PSR__c();
                psr4.site__c = site.Id;
                psr4.Array_Layout__c = true;
                insert psr4;
                
                //Instance of Standard Controller passing the above instance of PSR
                ApexPages.StandardController stdController4 = new ApexPages.standardController(psr4);
                //instance of controller
                Controller_Select_Design controller4 = new Controller_Select_Design(stdController4); 
                controller.selectedDesignOnPage = testDesign2.Id;
                                
                Test.stopTest();
            
     }          
}