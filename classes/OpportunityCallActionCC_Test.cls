@IsTest
public class OpportunityCallActionCC_Test {
    
    public static testMethod void testOpportunityCallActionCC(){
        
        Test.startTest();
        
        Opportunity o = new Opportunity();
        o.Name = 'Sample Opportunity 1';
        o.StageName = 'New Opportunity';
        o.CloseDate = date.today() + 2;
        o.Call_Outcome__c = 'Scheduled Appointment';
        insert o;
        
        ApexPages.StandardController controller = new ApexPages.StandardController(o);
        
        OpportunityCallActionCC ocacc = new OpportunityCallActionCC(controller);
        ocacc.updateOpp();
        
        //Submit Without Existing Description
        ocacc.submit();
        ocacc.o.Call_Outcome__c = 'Scheduled Appointment';        
        
        //Submit With Existing Description
        ocacc.submit();
        
        //Submit With NULL Call Outcome
        ocacc.submit();
        ocacc.cancel();
        
        Test.stopTest();
    }
}