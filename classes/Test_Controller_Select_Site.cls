/**********************************************************************
Class                   :   Test_Controller_Select_Site
Related Class           :   Controller_Select_Site
Created By              :   Appirio Offshore
Created On              :   Jan 07, 2010
Desciption              :   Test class for apex class for Controller_Select_Site.
************************************************************************/
@isTest
private class Test_Controller_Select_Site {
     public static Opportunity testOpp ;
     public static  PSR__c psr1;
     public static Quote quote1 ;
   
        public static PSR__c getpsr() {
            if (psr1 == null) {
                //PSR__c test data inserted
                    psr1 = new PSR__c();
                    psr1.opportunity__c = testOpp.ID;
                    insert psr1;
            }
            return psr1;
        }   
        
        public static Quote getquote(){ 
        
             if (quote1 == null ) {
                quote1 = new Quote();
                //quote1.Opportunity__c = testOpp.Id;
                quote1.Quote_Steps__c = '0. Awaiting Approval';
                quote1.Deadline_Type__c = 'Drop Dead';
                quote1.Proposal_Completed__c = System.now().addDays(10);
                //quote1.Proposal_Due_Current__c = System.today().addDays(7);
                quote1.Proposal_Due_Original__c = System.today().addDays(5);
                quote1.Quote_Expiration_Date__c = System.today().addDays(14);
                quote1.Name = testOpp.Name;
                quote1.OpportunityId = testOpp.id;
                insert quote1;
            }
            return quote1;
       }    
        
        public static Opportunity getOpp (){
            if (testOpp == null) {
            testOpp = new Opportunity();
            testOpp.Name = 'TestOpp';
            testOpp.CloseDate = System.today().addDays(14);
            testOpp.Sales_Steps__c = 'Shortlisted';
            testOpp.Contract_Type__c = 'Design';
            testOpp.Financing__c = 'PPA';
            testOpp.Business_Unit__c = 'Utility';
            testOpp.Region__c = 'New York';
            testOpp.StageName = 'Open';
            testOpp.Probability = 5;
            testOpp.Budgetary_Pricing_Agreed_On_Date__c = System.today();
            insert testOpp;
            }
           return testOpp;
        }           
            //Site_Information_Form__c test data inserted
        public static  List<Site_Information_Form__c> siteList = new List<Site_Information_Form__c>{};
                    
        
    static testMethod void Test_Controller_Select_Site(){                
                getOpp();
                getquote();
                getpsr();
               
                //Instance of Standard Controller passing the above instance of PSR
                ApexPages.StandardController stdController = new ApexPages.standardController(psr1);
                /*Instance of Controller_Select_Site passing the above instance of Standard 
                Controller to cover error message when no Quote is populated in PSR*/               
                Controller_Select_Site extension = new Controller_Select_Site(stdController); 
                
                
    }
    static testMethod void testController_Select_Site1(){
        getOpp();
        getquote();
        getpsr();
        Site_Information_Form__c testSite = new Site_Information_Form__c(Site_Name__c = 'Test Site ',Opportunity_del__c = testOpp.id,Site_City__c = 'tCity ',Site_Status__c = 'Active',Site_State__c = 'tState ',Site_Country__c = 'tCountry ');
        insert testSite;
        
        //PSR__c updated(Site__c is populated in PSR__c)
        psr1.Site__c = testSite.id;
        update psr1;
        
        //Instance of Standard Controller passing the above instance of PSR
        ApexPages.StandardController stdController = new ApexPages.standardController(psr1);
        //Instance of Controller_Select_Site passing the above instance of Standard Controller 
        //to cover error message when no Sites associated with Opportunity inserted above
        Controller_Select_Site extension = new Controller_Select_Site(stdController);
        // To cover the getter(else condition)
        Boolean bol = extension.renderTable;
        //  System.assertEquals(bol,false);   
       
              
        
    }
    static testMethod void testController_Select_Site2(){
        getOpp();
        getquote();
        getpsr();
      
      
           Site_Information_Form__c testSite = new Site_Information_Form__c(Site_Name__c = 'Test Site ',Opportunity_del__c = testOpp.id,Site_City__c = 'tCity ',Site_Status__c = 'Active',Site_State__c = 'tState ',Site_Country__c = 'tCountry ');
         
        insert testSite;
        
        //PSR__c updated(Site__c is populated in PSR__c)
        psr1.Site__c = testSite.id;
        update psr1;
        //Instance of Standard Controller passing the above instance of PSR
        ApexPages.StandardController stdController = new ApexPages.standardController(psr1);
        //Instance of Controller_Select_Site passing the above instance of Standard Controller
        Controller_Select_Site extension = new Controller_Select_Site(stdController);
        //Selected Site is associated with one of the object in   Site_Information_Form__c list 
        extension.selectedSiteOnPage = testSite.id;
        //returnToPSR method covered
        extension.returnToPSR();
        //Cancel method covered
        extension.Cancel();
        // To cover the getter(if condition)
        Boolean bol = extension.renderTable;
        System.assertEquals(bol,true);
                
    }
    }