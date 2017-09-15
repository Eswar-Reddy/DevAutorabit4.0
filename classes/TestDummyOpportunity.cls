@IsTest(SeeAllData=true)
public class TestDummyOpportunity{

public static testMethod void  afterInsertUpdate(){
    Opportunity opp = new Opportunity();
    Account ac = [select Id from Account Limit 1];
                        //opp.AccountId = accList[0].id;
                        opp.AccountId = ac.Id;
                        opp.Name = 'testOpp';
                        opp.CloseDate = System.today().addDays(14);
                        opp.Sales_Steps__c = 'Shortlisted';
                        opp.Contract_Type__c = 'Design';
                        opp.Financing__c = 'PPA';
                        opp.Business_Unit__c = 'Utility';
                        opp.Region__c = 'New York';
                        opp.StageName = 'Open';
                        opp.Probability = 5;
                        opp.Budgetary_Pricing_Agreed_On_Date__c = System.today();
                        insert opp;
                        delete opp;
                        
}
}