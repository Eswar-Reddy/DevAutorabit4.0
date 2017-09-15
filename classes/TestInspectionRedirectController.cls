/*****************************************************************
**Created by - Kapil Goutam
**Created On - June 05 2009
**Last Modified On- 
**Last Modifiled by- 
**Description- Test Class for class InspectionRedirectController
**************************************************************/
public class TestInspectionRedirectController {
    
    @isTest
    public static void Test_InspectionRedirect(){
        Case newCase = new Case();
        
        insert newCase;
        
        Account acc = new Account();
        acc.Name = 'Test Account-'+ String.valueOf(DateTime.Now());
        acc.Type ='Commercial';
        acc.BillingCity = 'san mateo';
        acc.BillingStreet = 'Concar drive';
        acc.BillingPostalCode ='94402';
        acc.BillingCountry = 'USA'; 
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'Test Contact-'+ String.valueOf(DateTime.Now());
        con.AccountId = acc.Id;
        insert con;
        
        //SP_Site__c site = new SP_Site__c();
        // insert site;
        
        Inspection__c inspection = new Inspection__c();
        inspection.Case__c = newCase.Id;
        //inspection.Contact__c = con.Id;
        inspection.Contact__c = UserInfo.getUserId();
        inspection.Partner_Contact__c = con.Id;
        //inspection.Site__c = site.Id;
        inspection.site_type__c = 'Residential';
        insert inspection;
        
        Apexpages.Standardcontroller controller = new ApexPages.Standardcontroller(inspection);
        ApexPages.currentPage().getParameters().put('CF00NQ0000000G2cO_lkid',newCase.id);
        InspectionRedirectController insRedirect = new InspectionRedirectController(controller);
        
        ApexPages.currentPage().getParameters().put('retURL', 'Edit');
        insRedirect = new InspectionRedirectController(controller);
        
        
        
        
        
        Inspection__c inspection3 = new Inspection__c();
        inspection3.Case__c = newCase.Id;
        //inspection.Contact__c = con.Id;
        inspection3.Contact__c = UserInfo.getUserId();
        inspection3.Partner_Contact__c = con.Id;
        //inspection.Site__c = site.Id;
        //inspection3.site_type__c = 'Residential';
        insert inspection3;
        
        Apexpages.Standardcontroller controller3 = new ApexPages.Standardcontroller(inspection3);
        ApexPages.currentPage().getParameters().put('CF00NQ0000000G2cO_lkid',newCase.id);
        ApexPages.currentPage().getParameters().put('CF00N80000003bZm6_lkid',null);
        InspectionRedirectController insRedirect3 = new InspectionRedirectController(controller3);
        
        ApexPages.currentPage().getParameters().put('retURL', 'Edit');
        insRedirect3 = new InspectionRedirectController(controller3);
        
        
        
        
        
        Inspection__c inspection1 = new Inspection__c();
        inspection1.Case__c = newCase.Id;
        //inspection1.Contact__c = con.Id;
        inspection1.Contact__c = UserInfo.getUserId();        
        inspection1.Partner_Contact__c = con.Id;
        //inspection1.Site__c = site.Id;
        inspection1.site_type__c = 'Commercial';
        insert inspection1;
        
        Apexpages.Standardcontroller controller1 = new ApexPages.Standardcontroller(inspection1);
        ApexPages.currentPage().getParameters().put('CF00NQ0000000G2cO_lkid',newCase.id);
        InspectionRedirectController insRedirect1 = new InspectionRedirectController(controller1);
        
        ApexPages.currentPage().getParameters().put('retURL', 'Edit');
        insRedirect1 = new InspectionRedirectController(controller1);
        
        Inspection__c inspection2 = new Inspection__c();
        inspection2.Case__c = newCase.Id;
        //inspection2.Contact__c = con.Id;
        inspection2.Contact__c = UserInfo.getUserId();
        inspection2.Partner_Contact__c = con.Id;
       // inspection2.Site__c = site.Id;    
        inspection2.site_type__c = null;  
        insert inspection2;
        
        Apexpages.Standardcontroller controller2 = new ApexPages.Standardcontroller(inspection2);
        ApexPages.currentPage().getParameters().put('id',inspection2.id);
        ApexPages.currentPage().getParameters().put('CF00NQ0000000G2cO_lkid',null);
        ApexPages.currentPage().getParameters().put('CF00N80000003bZm6_lkid',null);
        InspectionRedirectController insRedirect2 = new InspectionRedirectController(controller2);
        
        ApexPages.currentPage().getParameters().put('retURL', 'Edit');
        insRedirect2 = new InspectionRedirectController(controller2);
    }
}