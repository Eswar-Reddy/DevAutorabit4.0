/*    Test Class for Trigger afterOppRoleInsertUpdateDelete on Opportunity_Role__c   */

public class TestCountOfSites {
    public static testMethod void  afterInsertUpdate() {

    Test.startTest();
        Site_Information_Form__c si = new Site_Information_Form__c();

        Set<Id> aid = new Set<Id>(); 
        si.Site_Name__c = 'sree';
        si.Site_Status__c = 'Active';

        Account a = [select Id from Account Limit 1];

        si.Account__c = a.Id;
        insert si;

        si.Site_City__c = 'bangalore';
        update si;

    /* START Reetan 11/30/2012    */
        Opportunity oppObj = new Opportunity();
         //   oppObj.RecordTypeId = componentsRecordTypeId;
            oppObj.Name = 'testOpp';
            oppObj.StageName = '01 – Assess Opportunity';
            oppObj.CloseDate = Date.today();    
            insert oppObj;
    /* END Reetan 11/30/2012     */
            
        Opportunity_Role__c oppRole = new Opportunity_Role__c();
            oppRole.Contract_Type__c = 'Test'; 
            oppRole.Opp_Name__c = oppObj.Id;    // Added Reetan 11/30/2012
            insert oppRole;
        
    Test.stopTest();
    }
}