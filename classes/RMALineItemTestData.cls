@isTest
public class RMALineItemTestData {
    public Item__c item_1, item_2;
    public RMA_Line_Item__c line_item_1;

    public void createTestData_setItem() {
        item_1 = getNewItem('item_1', 'item_1');
        item_2 = getNewItem('item_2', 'item_2');
        insert new List <Item__c>{item_1, item_2};
        
        Account account_1 = getNewAccount('account_1');
        insert new List <Account>{account_1};
         
        Case case_1 = getNewCase('test', account_1.Id);
        insert new List <Case>{case_1}; 
        
        RMA__c rma_1 = new RMA__c(Case__c = case_1.Id, Attention_To__c = 'xyz', Attention_To_Email__c = 'xyz@sptest.com');
        insert new List <RMA__c>{rma_1}; 
        
        line_item_1 = new RMA_Line_Item__c(RMA__c = rma_1.Id, Name = 'item_1');
        insert new List <RMA_Line_Item__c>{line_item_1};
    }
    
    private static Item__c getNewItem(String name, String itemId) {
        Item__c item = new Item__c();
        item.Name = name;
        item.Item_ID__c = itemId;    // required
        return item;
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
    
    private static Case getNewCase(String subject, String accountId) {
        Case c = new Case();
        c.Subject = subject;
        c.AccountId = accountId;
        return c;    
    }

}