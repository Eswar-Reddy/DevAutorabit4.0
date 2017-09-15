@isTest
public class SPCommunityRecordHistoryUtil_Test {

    private static testMethod void account_created() {
        Account a_1 = getNewAccount('a_1');    
        insert new List <Account>{a_1};
    
        List <SObject> sobjList = new List <SObject>();
        SObject sobj = Schema.getGlobalDescribe().get('AccountHistory').newSObject();

        List <SPCommunityRecordHistoryUtil.TestData> tdList = new List <SPCommunityRecordHistoryUtil.TestData>();
        SPCommunityRecordHistoryUtil.TestData td = new SPCommunityRecordHistoryUtil.TestData();

        sobj.put('Field', 'created');
        td.historySobj = sobj;
        tdList.add(td);        
        SPCommunityRecordHistoryUtil.History history = SPCommunityRecordHistoryUtil.getHistory(a_1.Id, tdList);
        
        system.assertEquals(1, history.items.size());
        system.assertEquals(true, history.items[0].action.contains('Created'));
    }

    private static testMethod void account_createdOn_updatedOn() {
        Account a_1 = getNewAccount('a_1');    
        insert new List <Account>{a_1};
    
        List <SObject> sobjList = new List <SObject>();
        SObject sobj_1 = Schema.getGlobalDescribe().get('AccountHistory').newSObject();
        SObject sobj_2 = Schema.getGlobalDescribe().get('AccountHistory').newSObject();

        List <SPCommunityRecordHistoryUtil.TestData> tdList = new List <SPCommunityRecordHistoryUtil.TestData>();
        SPCommunityRecordHistoryUtil.TestData td_1 = new SPCommunityRecordHistoryUtil.TestData();
        SPCommunityRecordHistoryUtil.TestData td_2 = new SPCommunityRecordHistoryUtil.TestData();

        DateTime createdOn = Datetime.newInstance(2008, 12, 1, 12, 30, 2);
        DateTime updatedOn = createdOn.addDays(10);
        
        sobj_1.put('Field', 'created');
        td_1.historySobj = sobj_1;
        td_1.createdOn = createdOn;
        
        sobj_2.put('Field', 'Name');
        td_2.historySobj = sobj_2;
        td_2.updatedOn = updatedOn;
        td_2.oldValue = 'Test_1';
        td_2.newValue = 'Test_2';

        // it is sorted list. create comes in bottom last.
        tdList.add(td_2);        
        tdList.add(td_1);        
        
        SPCommunityRecordHistoryUtil.History history = SPCommunityRecordHistoryUtil.getHistory(a_1.Id, tdList);
        
        system.assertEquals(2, history.items.size());
        system.assertEquals(createdOn, history.createdOn);
        system.assertEquals(updatedOn, history.updatedOn);
    }

    private static testMethod void account_fieldValue_change() {
        Account a_1 = getNewAccount('a_1');    
        insert new List <Account>{a_1};
    
        List <SObject> sobjList = new List <SObject>();
        SObject sobj = Schema.getGlobalDescribe().get('AccountHistory').newSObject();

        List <SPCommunityRecordHistoryUtil.TestData> tdList = new List <SPCommunityRecordHistoryUtil.TestData>();
        SPCommunityRecordHistoryUtil.TestData td = new SPCommunityRecordHistoryUtil.TestData();

        sobj.put('Field', 'Industry');
        td.historySobj = sobj;
        td.oldValue = 'Test_1';
        td.newValue = 'Test_2';
        tdList.add(td);        
        SPCommunityRecordHistoryUtil.History history = SPCommunityRecordHistoryUtil.getHistory(a_1.Id, tdList);
        
        system.assertEquals(1, history.items.size());
        system.assertEquals(true, history.items[0].action.contains('Industry'));
        system.assertEquals(true, history.items[0].action.contains('Test_1'));
        system.assertEquals(true, history.items[0].action.contains('Test_2'));
    }

    private static testMethod void account_fieldValue_set() {
        Account a_1 = getNewAccount('a_1');    
        insert new List <Account>{a_1};
    
        List <SObject> sobjList = new List <SObject>();
        SObject sobj = Schema.getGlobalDescribe().get('AccountHistory').newSObject();

        List <SPCommunityRecordHistoryUtil.TestData> tdList = new List <SPCommunityRecordHistoryUtil.TestData>();
        SPCommunityRecordHistoryUtil.TestData td = new SPCommunityRecordHistoryUtil.TestData();

        sobj.put('Field', 'Industry');
        td.historySobj = sobj;
        td.oldValue = null;
        td.newValue = 'Test_2';
        tdList.add(td);        
        SPCommunityRecordHistoryUtil.History history = SPCommunityRecordHistoryUtil.getHistory(a_1.Id, tdList);
        
        system.assertEquals(1, history.items.size());
        system.assertEquals(true, history.items[0].action.contains('Industry'));
        system.assertEquals(false, history.items[0].action.contains('Test_1'));
        system.assertEquals(true, history.items[0].action.contains('Test_2'));
    }

    private static testMethod void account_fieldValue_delete() {
        Account a_1 = getNewAccount('a_1');    
        insert new List <Account>{a_1};
    
        List <SObject> sobjList = new List <SObject>();
        SObject sobj = Schema.getGlobalDescribe().get('AccountHistory').newSObject();

        List <SPCommunityRecordHistoryUtil.TestData> tdList = new List <SPCommunityRecordHistoryUtil.TestData>();
        SPCommunityRecordHistoryUtil.TestData td = new SPCommunityRecordHistoryUtil.TestData();

        sobj.put('Field', 'Industry');
        td.historySobj = sobj;
        td.oldValue = 'Test_1';
        td.newValue = null;
        tdList.add(td);        
        SPCommunityRecordHistoryUtil.History history = SPCommunityRecordHistoryUtil.getHistory(a_1.Id, tdList);
        
        system.assertEquals(1, history.items.size());
        system.assertEquals(true, history.items[0].action.contains('Industry'));
        system.assertEquals(true, history.items[0].action.contains('Test_1'));
        system.assertEquals(false, history.items[0].action.contains('Test_2'));
    }

    private static testMethod void account_longText_change() {
        Account a_1 = getNewAccount('a_1');    
        insert new List <Account>{a_1};
    
        List <SObject> sobjList = new List <SObject>();
        SObject sobj = Schema.getGlobalDescribe().get('AccountHistory').newSObject();

        List <SPCommunityRecordHistoryUtil.TestData> tdList = new List <SPCommunityRecordHistoryUtil.TestData>();
        SPCommunityRecordHistoryUtil.TestData td = new SPCommunityRecordHistoryUtil.TestData();

        sobj.put('Field', 'Description');
        td.historySobj = sobj;
        // long text, multi picklist fields. old and new are nulls
        td.oldValue = null;
        td.newValue = null;
        tdList.add(td);        
        SPCommunityRecordHistoryUtil.History history = SPCommunityRecordHistoryUtil.getHistory(a_1.Id, tdList);
        
        system.assertEquals(1, history.items.size());
        system.assertEquals(true, history.items[0].action.contains('Description'));
    }

    private static testMethod void account_owner() {
        Account a_1 = getNewAccount('a_1');    
        insert new List <Account>{a_1};
    
        List <SObject> sobjList = new List <SObject>();
        SObject sobj = Schema.getGlobalDescribe().get('AccountHistory').newSObject();

        List <SPCommunityRecordHistoryUtil.TestData> tdList = new List <SPCommunityRecordHistoryUtil.TestData>();
        SPCommunityRecordHistoryUtil.TestData td = new SPCommunityRecordHistoryUtil.TestData();

        sobj.put('Field', 'Owner');
        td.historySobj = sobj;
        tdList.add(td);        
        SPCommunityRecordHistoryUtil.History history = SPCommunityRecordHistoryUtil.getHistory(a_1.Id, tdList);
        
        system.assertEquals(1, history.items.size());
        system.assertEquals(true, history.items[0].action.contains('Owner'));
    }

    private static testMethod void opportunity_closedate_set() {
        Account a_1 = getNewAccount('a_1');    
        insert new List <Account>{a_1};
        Opportunity oppty_1 = getNewOpportunity('oppty_1', a_1.Id);
        insert new List <Opportunity>{oppty_1};
    
        List <SObject> sobjList = new List <SObject>();
        SObject sobj = Schema.getGlobalDescribe().get('OpportunityFieldHistory').newSObject();

        List <SPCommunityRecordHistoryUtil.TestData> tdList = new List <SPCommunityRecordHistoryUtil.TestData>();
        SPCommunityRecordHistoryUtil.TestData td = new SPCommunityRecordHistoryUtil.TestData();

        sobj.put('Field', 'CloseDate');
        td.historySobj = sobj;
        td.oldValue = null;
        td.newValue = system.today();
        tdList.add(td);        
        SPCommunityRecordHistoryUtil.History history = SPCommunityRecordHistoryUtil.getHistory(oppty_1.Id, tdList);
        
        system.assertEquals(1, history.items.size());
        system.assertEquals(true, history.items[0].action.contains('Close Date'));
    }

    private static testMethod void opportunity_amount_set() {
        Account a_1 = getNewAccount('a_1');    
        insert new List <Account>{a_1};
        Opportunity oppty_1 = getNewOpportunity('oppty_1', a_1.Id);
        insert new List <Opportunity>{oppty_1};
    
        List <SObject> sobjList = new List <SObject>();
        SObject sobj = Schema.getGlobalDescribe().get('OpportunityFieldHistory').newSObject();

        List <SPCommunityRecordHistoryUtil.TestData> tdList = new List <SPCommunityRecordHistoryUtil.TestData>();
        SPCommunityRecordHistoryUtil.TestData td = new SPCommunityRecordHistoryUtil.TestData();

        sobj.put('Field', 'Amount');
        td.historySobj = sobj;
        td.oldValue = null;
        td.newValue = 10000;
        tdList.add(td);        
        SPCommunityRecordHistoryUtil.History history = SPCommunityRecordHistoryUtil.getHistory(oppty_1.Id, tdList);
        
        system.assertEquals(1, history.items.size());
        system.assertEquals(true, history.items[0].action.contains('Amount'));
    }

    private static testMethod void case_closedatetime_set() {
        Account a_1 = getNewAccount('a_1');    
        insert new List <Account>{a_1};
        Case c_1 = getNewCase('c_1', a_1.Id);
        insert new List <Case>{c_1};
    
        List <SObject> sobjList = new List <SObject>();
        SObject sobj = Schema.getGlobalDescribe().get('CaseHistory').newSObject();

        List <SPCommunityRecordHistoryUtil.TestData> tdList = new List <SPCommunityRecordHistoryUtil.TestData>();
        SPCommunityRecordHistoryUtil.TestData td = new SPCommunityRecordHistoryUtil.TestData();

        sobj.put('Field', 'ClosedDate');
        td.historySobj = sobj;
        td.oldValue = null;
        td.newValue = Datetime.newInstance(2008, 12, 1, 12, 30, 2);
        tdList.add(td);        
        SPCommunityRecordHistoryUtil.History history = SPCommunityRecordHistoryUtil.getHistory(c_1.Id, tdList);
        
        system.assertEquals(1, history.items.size());
        // label comes as Closed Date but in case object you see label as Date/Time Closed
        system.assertEquals(true, history.items[0].action.contains('Closed Date'));
    }

    private static testMethod void case_lookupFeild_change() {
        Account a_1 = getNewAccount('a_1');    
        Account a_2 = getNewAccount('a_2');    
        insert new List <Account>{a_1, a_2};
        Case c_1 = getNewCase('c_1', a_1.Id);
        insert new List <Case>{c_1};
    
        List <SObject> sobjList = new List <SObject>();
        SObject sobj = Schema.getGlobalDescribe().get('CaseHistory').newSObject();

        List <SPCommunityRecordHistoryUtil.TestData> tdList = new List <SPCommunityRecordHistoryUtil.TestData>();
        SPCommunityRecordHistoryUtil.TestData td = new SPCommunityRecordHistoryUtil.TestData();

        sobj.put('Field', 'AccountId');
        td.historySobj = sobj;
        td.oldValue = a_1.Id;
        td.newValue = a_2.Id;
        tdList.add(td);        
        SPCommunityRecordHistoryUtil.History history = SPCommunityRecordHistoryUtil.getHistory(c_1.Id, tdList);
        
        // salesforce does not display this row that has ids. instead it displays row with related record names
        system.assertEquals(0, history.items.size());
    }

    private static Account getNewAccount(String name) {
        Account a = new Account();
        a.Name = name; 
        a.BillingStreet = '100 XYZ Plaza';
        a.BillingCity = 'Sunnyvale';
        a.BillingState = 'CA';
        a.BillingCountry = 'United States'; 
        a.BillingPostalCode = '94086';     
        return a;    
    }
    
    private static Opportunity getNewOpportunity(String name, String accountId) {
        Opportunity oppty = new Opportunity();
        oppty.Name = name;
        oppty.AccountId = accountId;
        oppty.StageName = '20% - Opportunity Contacted';    // avoid null pointer exception
        oppty.CloseDate = System.today();    // required
        return oppty;    
    
    }
    
    private static Case getNewCase(String subject, String accountId) {
        Case c = new Case();
        c.Subject = subject;
        c.AccountId = accountId;
        return c;
    }

}