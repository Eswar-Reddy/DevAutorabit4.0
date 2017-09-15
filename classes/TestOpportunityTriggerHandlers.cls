/*************************
* Test Class Cases for Account Handlers
* 2/2/2015
* Crystal, Praveen
* **********************/

@IsTest (SeeAllData=true)
public class TestOpportunityTriggerHandlers {
    
    static testMethod void testOpportunityTrigger() {
       
                
        list<Account> listInstallerAccount = [Select id from Account where recordtypeid=:SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.SobjectType).get('Partner') AND Theater__c='North America' limit 2]; 
        User objUser1 = [Select Id,Contact.Account.Theater__c,Contact.Account.Territory__c from User where Profile.Name = 'Partner Executive' AND isActive=true limit 1];
        User objUser = [Select Id,Contact.Account.Theater__c,Contact.Account.Territory__c from User where Profile.id ='00e80000001SqIlAAK' AND isActive=true limit 1];                
        
        Account acct = TestClassFactory.CreateDealer('TestDealerPartner', 'North America');
        
        Account a = TestClassFactory.testAccount('TestResiAccount1', TestClassFactory.retrieveRecordTypeID('Account', 'Residential Customer'));
        a.Partner_Account__c = acct.Id;
        a.OwnerId = objUser1.Id;
        insert a;
        
        Contact objContact= TestClassFactory.testContact('TEstlastName', 'testfakie@noemail.com', TestClassFactory.retrieveRecordTypeID('Contact', 'Customer'));
        objContact.AccountId = acct.Id;
        objContact.primary__c = true;                
        insert objContact;

        Opportunity oppObj = TestClassFactory.testOpportunity('testOpp'+String.valueOf(System.today()), 'New Opportunity', Date.today(), TestClassFactory.retrieveRecordTypeID('Opportunity', 'Home Owner'));
		oppObj.AccountId = a.Id;        
        oppObj.Lead_Manufacturer__c ='SunPower';
        oppObj.Is_Excluded_From_SLA_Score__c = true;
        oppObj.Partner_Account_Id__c =acct.id;
        oppObj.Amount=300;
        oppObj.Primary_Contact__c = objContact.Id;
        oppObj.OwnerId = objUser.id;
        oppObj.Primary_Contact__c = objContact.id;
        oppObj.Customer_Satisfaction_Survey_opt_in__c = true;
        oppObj.Opportunity_CreatedDate_Text__c = null;
        oppObj.Installer__c = listInstallerAccount.get(0).id;

        Test.startTest();

        insert oppObj;

        Opportunity_Role__c OpportunityRole= new Opportunity_Role__c();
        OpportunityRole.Amount__c = 300;
        OpportunityRole.Opp_Name__c = oppObj.id;
        
        insert OpportunityRole;
        
        List<Opportunity> oppstoupdate = new List<Opportunity>();
        Date dt = System.today() - 31;
        List<Opportunity> oppsForComparison = new List<Opportunity>([SELECT Id, PartnerAccountId, Send_Mail__c, CreatedDate 
                                                                     FROM Opportunity o WHERE DAY_ONLY(CreatedDate) =: dt 
                                                                     AND PartnerAccountID != null LIMIT 10]);
        Opportunity referenceOpp;
        for(Opportunity o : oppsForComparison) {
             if(System.today().daysBetween(o.CreatedDate.date()) == -31) {
                 referenceOpp = o;
                 break;
             }
         }
        if(referenceOpp!= null){
            referenceOpp.Send_Mail__c = true;
            oppsToUpdate.add(referenceOpp);
        }
        
        oppObj.Amount=301;
        oppObj.OwnerId = userinfo.getUserId();
        oppObj.Partner_Account_Id__c = '0018000000v6FpPAAU';
        oppObj.Installer__c = listInstallerAccount.get(1).id;
        oppObj.Design_Photo__c ='Test';
        oppObj.StageName = 'Contacted';
        oppsToUpdate.add(oppObj);
        
        
        update oppsToUpdate;

        DealerUtility.CalculateTimelyUpdateOnOpportunity(oppsToUpdate);
            
        Test.stopTest();
    }
}