@isTest
private class TestPSRManagement{

    @isTest
    private static void checkPSRManagement(){
        //Create Opportunity
        Opportunity opp =new Opportunity();
        opp.name = 'TestOppPSR';  
        opp.StageName= 'Binding Offer';
        opp.Closedate = System.today(); 
        opp.Business_Unit__c = 'UPP Intl';
        opp.country__c='United States';
        insert opp;
        
        //Create Site
        Site_Information_Form__c site =new Site_Information_Form__c();   
        site.Site_Status__c='Active';
        site.opportunity_del__c = opp.ID;
        insert site;
        
        //Create Quote    
        Quote quote = new Quote();
        quote.Name = 'TestQuote';            
        quote.opportunityid =opp.id;
        quote.Quote_Steps__c = 'Array Layout';    
        insert quote;      
            
        //Create PSR record
        PSR__c psr = new PSR__c();
        psr.Quote__c = quote.ID;
        psr.site__c = site.ID;  
        psr.opportunity__c = opp.ID; 
        psr.Array_Layout__c = false;
        psr.Product_Type__c = 'T-10';
        psr.Module_Type__c = 'SunPower 230';    
        psr.Requested_System_Size__c = 1000.00;
        psr.Site_Survey_SubContractor__c=false;
        insert psr;
        
        //Send PSR
        ApexPages.StandardController std = new ApexPages.StandardController(psr);
        controller_Send_PSR sendPSR = new controller_Send_PSR(std);
        PageReference pg = sendPSR.sendPSRAction();
        
       
        //Update PSR  
        psr.Site_Survey_SubContractor__c =true; 
        psr.Array_Layout__c = true;
        psr.Single_Line_based_on_Design__c=true;
        
       // psr.Design_Urgent_Request__c = true;  
        psr.PM_Cost__c = true;
        psr.Single_Line_based_on_Design__c = true;
        psr.Project_Manager__c = userInfo.getUserID();
        psr.Estimate_Reviewer__c = userInfo.getUserID();
        
        update psr;
        
        psr.Site_Survey_Due__c=Date.newInstance(1990,12,02);
        psr.Array_Layout_Due__c=Date.newInstance(2000,02,02);
        psr.Electrical_Support_Due__c=Date.newInstance(2011,12,02);
        psr.Cost_Estimate_Due__c=Date.newInstance(2020,12,11);
        update psr;
        
        psr.Kickoff_Meeting_Date__c=Date.newInstance(2070,12,02);
        psr.Site__c =site.id;
        psr.Site_Surveyor__c=UserInfo.getUserId();
        update psr; 
        
        psr.Array_Layout__c =true;
        psr.Design_Urgent_Request__c=true;
        update psr;
        
        Design__c design = new Design__c();
        design.psr__c =psr.id;
        design.site__c=site.id;
        insert design;
        
        Single_Line__c single = new Single_Line__c();
        single.psr__c=psr.id;
        single.design__c=design.id;
        single.site__c=site.id;
        single.status__c='Active';
        insert single;
        
        //test.startTest();
        final Integer QUOTE_STEP_PSR_COMPLETE=15;
        psr.Design__c=design.id;
        psr.Electrical_Engineer__c=UserInfo.getUserId();
        psr.Estimate_Urgent_Request__c=true;
        psr.Estimator__c=UserInfo.getUserId();
        psr.Quote__c =quote.id;
       // psr.quote_steps__c=15;
        update psr;
        
        //creating Task
        
        Task task = new Task();
        
        task.Task_Type__c = 'Site Audit';
        task.PSR_ID__c = psr.id;
        task.Subject = site.Site_Name__c;      
        task.WhatID = site.id;
        insert task;
        
        //Creating Products
        
        Product2 product = new Product2();
        product.name='Product1';
        product.CurrencyIsoCode='USD';
        insert product;
        
        psr.PV_Module_Type__c=product.id;
        psr.Mounting_System__c=product.id;
        //update psr; 
        
        psr.Site_Survey_Urgent_Request__c=true;
        psr.Site_Survey_Completed__c=Date.newInstance(2011,08,23);
        psr.Array_Layout_Completed__c=Date.newInstance(2011,08,23);
        psr.Electrical_Support_Completed__c=Date.newInstance(2012,08,25);
        psr.Cost_Estimate_Completed__c=Date.newInstance(2011,10,25); 
        
      //  psr.Site_Survey_SubContractor__c=true;
        psr.PM_Cost__c=true;
        psr.Single_Line_based_on_Design__c=true;
        psr.Array_Layout__c =true;
       // psr.Site_Survey_Standard__c=true;
        update psr;   
        //test.stopTest();
    }
}