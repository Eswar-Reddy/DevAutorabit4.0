@isTest
public class CreditRequestTest
{    
    static Account newAccount;
    static Contact newContact;
    static Opportunity newOpportunity;
    
    public static testMethod void TM1()
    {
        String postFix = String.valueOf(Datetime.now().getTime());
        
        newAccount = TestUtils.createAccount('TAcc' + postFix, TestUtils.getResidentialRecordTypeId(), true);
        newContact = TestUtils.createContact('TCon1' + postFix, newAccount.Id, true);
        newOpportunity = TestUtils.createOpportunities(1, newAccount.id, newContact.Id, true).get(0);
        
        PageReference pageRef = Page.CreditRequest;
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('id', newOpportunity.Id);
        CreditRequest controller = new CreditRequest(new ApexPages.StandardController(newOpportunity));
        controller.propMockVal = 1;
        controller.redirect();
    }//End Func TM1
    
    public static testMethod void TM2()
    {
        String postFix = String.valueOf(Datetime.now().getTime());
        
        newAccount = TestUtils.createAccount('TAcc' + postFix, TestUtils.getResidentialRecordTypeId(), true);
        newContact = TestUtils.createContact('TCon1' + postFix, newAccount.Id, true);
        newOpportunity = TestUtils.createOpportunities(1, newAccount.id, newContact.Id, true).get(0);
        
        PageReference pageRef = Page.CreditRequest;
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('id', newOpportunity.Id);
        CreditRequest controller = new CreditRequest(new ApexPages.StandardController(newOpportunity));
        controller.propMockVal = 2;
        controller.redirect();
    }//End Func TM2
    
    public static testMethod void TM3()
    {
        String postFix = String.valueOf(Datetime.now().getTime());
        
        newAccount = TestUtils.createAccount('TAcc' + postFix, TestUtils.getResidentialRecordTypeId(), true);
        newContact = TestUtils.createContact('TCon1' + postFix, newAccount.Id, true);
        newOpportunity = TestUtils.createOpportunities(1, newAccount.id, newContact.Id, true).get(0);
        
        PageReference pageRef = Page.CreditRequest;
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('id', newOpportunity.Id);
        CreditRequest controller = new CreditRequest(new ApexPages.StandardController(newOpportunity));
        controller.propMockVal = 3;
        controller.redirect();
    }//End Func TM3        
}//End Class CreditRequestTest