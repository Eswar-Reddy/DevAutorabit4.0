@isTest
private class homewonerdesignControllerTest{
    
    public static Account accAccount;
    public static Contact conContact;
    public static Opportunity opp;
    
    static{
         accAccount = new Account(Name = 'homewonerdesignControllerTest',
            Phone = '4567865432',            
            BillingStreet = '77 Rio Roble', 
            BillingCity = 'San Jose',
            BillingState = 'CA', 
            BillingPostalCode = '95134', 
            BillingCountry = 'United States', 
            Type = 'Elite-Partner-Residential', 
            Theater__c = 'North America',
            Chatter_Group_Name__c = 'Sample CG1',
            Status__c = 'Active',            
            Website = 'http://www.biggsun.com');
        insert accAccount;
        
        conContact = new Contact(AccountId = accAccount.Id,
            LastName = 'hodControllerTest',
            FirstName = 'FirstName',
            Email = 'hodtest@test.com');
        insert conContact;
        
        opp = new Opportunity( Name = 'Test BiggSunOpp', 
            StageName = 'New Opportunity',
            Lead_Manufacturer__c = 'SunPower',
            Primary_Contact__c = conContact.Id,
            Dealer_Assignment_Date__c = System.today()+1,
            CloseDate = System.today(),
            Design_Status__c='Design Sent to Customer',
            AccountId = accAccount.Id);        
            insert opp;  
            
            opp.Design_Photo__c='RTA';
            update opp;
            
    }
    static testmethod void testhomewonerdesignController1(){
        
        PageReference pageRef = Page.homeownerdesign;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('oid', opp.Id);
        ApexPages.currentPage().getParameters().put('on',opp.Opportunity_Number__c);

        homewonerdesignController hodctrl1 = new homewonerdesignController();
        hodctrl1.authenticateOpportunityID();
        hodctrl1.getOppty();
        hodctrl1.getItems();
        hodctrl1.getString();
        hodctrl1.response='Yes';
        hodctrl1.responseToggle();
        hodctrl1.saveOppty();
        
        opp.Design_Photo__c='RTA2';
        opp.Customer_Response_Comments__c=null;
        update opp;
        homewonerdesignController hodctrl2 = new homewonerdesignController();
        
        hodctrl2.response='No';
        hodctrl2.responseToggle();
        hodctrl2.saveOppty();
        homewonerdesignController hodctrl3 = new homewonerdesignController();

        hodctrl3.response='No';
        hodctrl3.opdesign.Customer_Response_Comments__c='Hello';
        hodctrl3.saveOppty();
    }
    
    static testmethod void testhomewonerdesignController2(){
        
        Opportunity opp2 = new Opportunity( Name = 'Test BiggSunOpp2', 
            StageName = 'New Opportunity2',
            Lead_Manufacturer__c = 'SunPower',
            Primary_Contact__c = conContact.Id,
            Dealer_Assignment_Date__c = System.today()+1,
            CloseDate = System.today(),
            Design_Status__c='',
            Customer_Response_Comments__c='Test Comments',
            AccountId = accAccount.Id);        
            insert opp2;
            
            opp2.Design_Photo__c='RTA2';
            update opp2;
            
            
        PageReference pageRef2 = Page.homeownerdesign;
        Test.setCurrentPage(pageRef2);

        ApexPages.currentPage().getParameters().put('oid', opp2.Id);
        ApexPages.currentPage().getParameters().put('on',opp2.Opportunity_Number__c);

        homewonerdesignController hodctrlNoCR = new homewonerdesignController();
        hodctrlNoCR.response='No';
        hodctrlNoCR.opdesign.Customer_Response_Comments__c='Hello2';
        hodctrlNoCR.saveOppty();
        
    }
    
    static testmethod void testhomewonerdesignController3(){
        
        Opportunity opp3 = new Opportunity( Name = 'Test BiggSunOpp3', 
            StageName = 'New Opportunity2',
            Lead_Manufacturer__c = 'SunPower',
            Primary_Contact__c = conContact.Id,
            Dealer_Assignment_Date__c = System.today()+1,
            CloseDate = System.today(),
            Design_Status__c='Final Design Approved',
            AccountId = accAccount.Id);        
            insert opp3;
            
            opp3.Design_Photo__c='RTA3';
            update opp3;
            
        PageReference pageRef = Page.homeownerdesign;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('oid', opp3.Id);
        ApexPages.currentPage().getParameters().put('on',opp3.Opportunity_Number__c);

        homewonerdesignController hodctrl = new homewonerdesignController();
    }
    
    static testmethod void testhomewonerdesignController4(){
        
        Opportunity opp4 = new Opportunity( Name = 'Test BiggSunOpp4', 
            StageName = 'New Opportunity4',
            Lead_Manufacturer__c = 'SunPower',
            Primary_Contact__c = conContact.Id,
            Dealer_Assignment_Date__c = System.today()+1,
            CloseDate = System.today(),
            Design_Status__c='Customer Declined Design',
            AccountId = accAccount.Id);        
            insert opp4;
            
            opp4.Design_Photo__c='RTA4';
            update opp4;
            
        PageReference pageRef = Page.homeownerdesign;
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('oid', opp4.Id);
        ApexPages.currentPage().getParameters().put('on',opp4.Opportunity_Number__c);

        homewonerdesignController hodctrl = new homewonerdesignController();
    }
    
}