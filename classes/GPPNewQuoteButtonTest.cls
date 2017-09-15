/********************************************************************************************
Author : Birlasoft
Usage  : Test Class for GPPNewQuoteButton Controller Class
Edits  :    
        2014-03-20 : 
********************************************************************************************/

@isTest(SeeAllData=True)
public class GPPNewQuoteButtonTest 
{
    private static Id residentialCustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Residential Customer').getRecordTypeId();
    private static Id residentialRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Home Owner').getRecordTypeId(); 
    private static Id customerRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Customer').getRecordTypeId(); 

    static Account newAccount,partnerAccount;
    static Contact newContact,partnerContact1;
    static Opportunity newOpportunity;
    static User partnerUser;
    static Quote objQuote;
    private static Id proposalQuoteRecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Proposal Quote').getRecordTypeId();

    private static user getPartnerUser()
    {   
        Test.startTest();
        UserManagement.IS_TEST = true; 

        String postFix = String.valueOf(Datetime.now().getTime());

        
        partnerAccount = TestUtils.createAccount('TEST_BOOYAH', TestUtils.getPartnerRecordTypeId(), false);
        //make lease enabled partner
        partnerAccount.Lease2_0_Program_Partner__c = true;
        partnerAccount.Oracle_Vendor_Number__c = 'VN'+String.ValueOf(DateTime.Now().getTime()).substring(0, 10)+String.ValueOf(Math.random()).substring(0,10);
        partnerAccount.Oracle_Vendor_Site_Code__c  = 'VSC'+String.ValueOf(DateTime.Now().getTime()).substring(0, 10)+String.ValueOf(Math.random()).substring(0,10);
        partnerAccount.Oracle_Warehouse__c  = 'BWGUY'+String.ValueOf(DateTime.Now().getTime()).substring(0, 10)+String.ValueOf(Math.random()).substring(0,10);
        partnerAccount.Certified__c = true;
        
        //insert partnerAccount;
        list<Account> listAccount = new  list<Account>();
        listAccount.add(partnerAccount);
        
        newAccount = TestUtils.createAccount('TAcc' + postFix, TestUtils.getResidentialRecordTypeId(), false);
        newAccount.Partner_Account__c = partnerAccount.id;
        newAccount.Certified__c = true;
        //insert newAccount;
        listAccount.add(newAccount);
        
        insert listAccount;

        
        
        newContact = TestUtils.createContact('TCon1' + postFix, newAccount.Id, true);
        newOpportunity = TestUtils.createOpportunities(1, newAccount.id, newContact.Id, true).get(0);
        
        Partner objPartnet = new Partner();
        objPartnet.AccountFromId =partnerAccount.id;
        objPartnet.AccountToId =newAccount.id;
        objPartnet.Role ='Installer';
        //objPartnet.OpportunityId = newOpportunity.id;
        insert objPartnet;
        
                                             
        
        objQuote=new Quote(Name='TQuote1'+postFix, RecordTypeId=proposalQuoteRecordTypeId, OpportunityId=newOpportunity.ID);
        insert objQuote;

   /*
        partnerContact = TestUtils.createContact( 'PartnerConTest', partnerAccount.Id, false );
       // partnerContact.Business_Function__c='Lease';
        partnerContact1 = TestUtils.createContact( 'PartnerConTest1', partnerAccount.Id, false );
        //partnerContact1.Business_Function__c='Cash';
        partnerContact1.Email=System.now().getTime()+'test1@test.com';
        partnerContact1.Phone='999-888-7770';
        list<Contact> listConatc = new list<Contact>();
        listConatc.add(partnerContact);
        listConatc.add(partnerContact1);
        //insert partnerContact; 
        //insert partnerContact1;
        insert listConatc;*/
        Test.stopTest();

        partnerUser = TestUtils.createPartnerPortalUser( newContact, false );
        partnerUser.ContactId=newContact.ID;
        partnerUser.isActive=true;
        partnerUser.Quote_Creation_Allowed__c=true;
        partnerUser.Business_Function__c='Create Lease Quote';
        return partnerUser;

    }
    public static testMethod void testGPPNewQuoteButton() 
    {
        
        partnerUser = getPartnerUser();
        String postFix = String.valueOf(Datetime.now().getTime());


       
            /*
        Account acc=new Account(Name='AccGppVFTest',RecordTypeID=residentialCustomerRecordTypeId,Status__c='Active',Theater__c='North America'
        ,BillingStreet='1010 State Street Atherton',BillingCity='Atherton',BillingState='CA',BillingPostalCode='94025',BillingCountry='Unied States');
        Insert acc;*/

        /*


        Contact con1=new Contact(FirstName='Con1',LastName='GppVFTest',RecordTypeID=customerRecordTypeId,Email='amit.test@birlasoft.com',Primary__c=true,Role__c='Technical Buyer',Include_in_Lease_Doc__c=true,MailingStreet='1010 State Street',MailingCity='Atherton',MailingState='CA',MailingPostalCode='94025',MailingCountry='United States');
        insert con1;
 
        Opportunity opp=new Opportunity(Name='OppGppVFTest',RecordTypeID=residentialRecordTypeId,AccountID=partnerAccount.id,StageName='10% - Qualified Opportunity',CloseDate=System.Today());
        insert opp;
        
        Quote  newQuote = TestUtils.createQuotes( 1, 'Quick Quote Test ', opp.Id, false).get(0);

     //newQuote.Module_Oracle_Item_Number__c = item1.Id;
      newQuote.Module_Quantity__c = 32;
      newQuote.Date_Modified__c = System.today()+30;
      //newQuote.Contractors_License__c= 'Y';
      //newQuote.Lease_Partner__c='Y';
      newQuote.Doc_out_for_signature__c= false;
      newQuote.Quote_type__c = 'Residential Lease Quotation';
      newQuote.Account__c = partnerAccount.id;
      newQuote.Is_Locked__c = true;
      newQuote.Temp_Contact_1__c ='Test';
      newQuote.Temp_Contact_2__c='Test';
      insert newQuote;*/

        PageReference pageRef = Page.GPPNewQuoteButton;
        pageRef.getParameters().put('acc', newAccount.ID);
        pageRef.getParameters().put('opp', newOpportunity.ID);
        pageRef.getParameters().put('own', partnerUser.ID);
        
        objQuote=new Quote(Name='TQuote1'+postFix, RecordTypeId=proposalQuoteRecordTypeId, OpportunityId=newOpportunity.ID);
        insert objQuote;

        pageRef.getParameters().put('quoteid', objQuote.id);
        

                                    
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.standardController(newOpportunity);
        GPPNewQuoteButton controller = new GPPNewQuoteButton(sc);
        String nextPage;// = controller.NewQuoteInit().getUrl();

        // Verify that page fails without parameters
        //System.assertEquals('http://gpp.cloudapp.net:8180/dealers-portal/auth/authentication-ui.html', nextPage);
     
        // Instantiate a new controller with all parameters in the page
        //controller = new GPPNewQuoteButton();
        //nextPage = controller.NewQuoteInit().getUrl();
        controller.NewQuoteInit();
        controller.GPPInstallerSelectionInit();
        controller.getInstallPartners();
        controller.cancel();
        controller.ChangeSelection();
        controller.submit();
        
        
        //controller.CreateQuoteHeader(acc.id,'invalidID','invalidID');
        // Verify that the success page displays
        //System.assertEquals('/apex/success', nextPage);
        

        
    }
}