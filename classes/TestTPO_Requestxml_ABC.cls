/*** Class added in Sunpower TPO Phase 1 -- 20/10/2013, to cover TPO_Requestxml_ABC Class ***/
//@isTest(seealldata=true)
public class TestTPO_Requestxml_ABC
{/*

    static testMethod void TestTPO_Requestxml_ABC(){
        Account newAccount;
        newAccount = TestUtils.createAccount('QuickQuote ACCOUNT 1', TestUtils.getResidentialRecordTypeId() , false);
        newAccount.Oracle_County__c ='Hautes-Alpes';
        insert newAccount;
        
        Item__c newItem = new Item__c(Item_ID__c = '1234124123123x',Product_Type__c= 'testtype',Item_Category_3__c='222');
        insert newItem;
        
        Opportunity newOpportunity;
        Quote newQuote;
        newOpportunity = [Select Id from Opportunity Where name='Test Class DO NOT TOUCH'];
        newQuote = TestUtils.createQuotes( 1, 'Quick Quote Test ', newOpportunity.Id, false).get(0);
        newQuote.Total_Yr_1_Production__c = 0.0;
        newQuote.Modules_Per_String_Roof1__c = 2;
        newQuote.Module_Oracle_Item_Number__c = newItem.ID;
        
        insert newQuote;
        
        
        
        Attachment newAttachment;
        newAttachment = TestUtils.createAttachments(1, 'ABC Request XML' ,false).get(0);
        newAttachment.parentId = newQuote.id;
        insert newAttachment;
        
              
        TPO_Requestxml_ABC reqABC = new TPO_Requestxml_ABC();
        reqABC.accountId = newAccount.id;
        reqABC.quoteId = newQuote.id;
      //  reqABC.generateABCXml(reqABC.quoteId,reqABC.accountId, 0.0, 0.0, 0.0);
        reqABC.generateABCXml(reqABC.quoteId,reqABC.accountId, 8900.0, 0.029, 2.0);
        
        
       
       
    }
    
    static testMethod void TestTPO_Requestxml_ABC2(){
        Account newAccount;
        newAccount = TestUtils.createAccount('QuickQuote ACCOUNT 1', TestUtils.getResidentialRecordTypeId() , false);
        newAccount.Oracle_County__c ='Hautes-Alpes';
        insert newAccount;
        
        Item__c newItem = new Item__c(Item_ID__c = '1234124123123x',Product_Type__c= 'testtype',Item_Category_3__c='WHITE B SNO2');
        insert newItem;
        
        Opportunity newOpportunity;
        Quote newQuote;
        newOpportunity = [Select Id from Opportunity Where name='Test Class DO NOT TOUCH'];
        newQuote = TestUtils.createQuotes( 1, 'Quick Quote Test ', newOpportunity.Id, false).get(0);
        newQuote.Total_Yr_1_Production__c = 0.0;
        newQuote.Modules_Per_String_Roof1__c = 2;
        newQuote.Module_Oracle_Item_Number__c = newItem.ID;
        
        insert newQuote;
        
        
        
        Attachment newAttachment;
        newAttachment = TestUtils.createAttachments(1, 'ABC Request XML' ,false).get(0);
        newAttachment.parentId = newQuote.id;
        insert newAttachment;
        
        TPO_Requestxml_ABC reqABC = new TPO_Requestxml_ABC();
        reqABC.accountId = newAccount.id;
        reqABC.quoteId = newQuote.id;
      //  reqABC.generateABCXml(reqABC.quoteId,reqABC.accountId, 0.0, 0.0, 0.0);
        reqABC.generateABCXml(reqABC.quoteId,reqABC.accountId, 0.0, null,null );
        
        
       
    }
    */
    }