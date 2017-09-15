@isTest(SeeAllData=true)
public class TestLoanQuote {
    public static List<Contact> lstCustomerContact;
    public static Account customerAccount;
    public static List<Opportunity> lstCustomerOpportunity;
    public static String tpsPartnerUserId;
    public static String dripPartnerUserId;
    public static String ipPartnerUserId;
    public static String tpsContactId;
    public static String dripContactId;
    public static String ipContactId;
    public static String LoanAccountId;
    public static String DRIPAccountId;
    public static String IPAccountId;
    public static List<User> lstPartnerUser;
    public static List<Account> lstPartner;
    public static List<Contact> lstContact;
    
    static{
        //Setting Flags to Skip Triggers
        UserManagement.IS_TEST= true;           
        SFDCSpecialUtilities.isRunningTest=true;
        List<Account> lstAccs=new List<Account>();
        List<Contact> lstCons=new List<Contact>();
        
        
        
        CustomerAccount = TestUtils.createAccount( 'TestLoanCustomerAcct', TestUtils.getResidentialRecordTypeId(), false );
        CustomerAccount.BillingState = 'CA';
        CustomerAccount.BillingCountry= 'United States';
        insert CustomerAccount;
        
        lstCustomerContact = new List<Contact>();
        lstCustomerContact.add(TestUtils.createContact('TesetLoanCustomerContact', CustomerAccount.Id, true));
        
        
        Schema.DescribeSObjectResult accSchema = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> AccountRecordTypeInfo = accSchema.getRecordTypeInfosByName();
        Id idPartnerRecordId = AccountRecordTypeInfo.get('Partner').getRecordTypeId();
        
        lstPartner = new List<Account> ();
        
        Account tpsAcc = TestClassFactory.testAccount('TestLoanXXXTPSXXXTQ',idPartnerRecordId);
        tpsAcc.NH_SSE_Type__c = 'TPS';
        lstPartner.add(tpsAcc);
        lstPartner.add(TestClassFactory.testAccount('TestLoanXXXDRIPXXXTQ',idPartnerRecordId));
        lstPartner.add(TestClassFactory.testAccount('TestLoanXXXIPXXXTQ',idPartnerRecordId));
        
        insert lstPartner;
        
        
        List<Fee_Distribution__c> fdList = new List<Fee_Distribution__c> ();
        
        for (Account a : lstPartner){
            if (a.Name.contains('TPS')){
                LoanAccountId=a.Id;
                fdList.addAll(fCreateTPSFeeDistribution(A, 'TPS', 'Loan'));
                customerAccount.Partner_Account__c=a.Id;
            }
            else if (a.Name.contains('DRIP')){
                DRIPAccountId=a.Id;
                fdList.addAll(fCreateDRIPandIPFeeDistribution (A,'DRIP','Loan',4350,0));
            }
            else {
                IPAccountId=a.Id;
                fdList.addAll(fCreateDRIPandIPFeeDistribution (A,'IP','Loan',0,.9));
            }
        }
        
        upsert customerAccount;
        
        upsert fdList;
        
        Schema.DescribeSObjectResult conSchema = Schema.SObjectType.Contact; 
        Map<String,Schema.RecordTypeInfo> ContactRecordTypeInfo = conSchema.getRecordTypeInfosByName();
        Id idPartnerContactRecordId = ContactRecordTypeInfo.get('Partner').getRecordTypeId();
        
        lstContact = new List<Contact> ();
        
        for ( account a : lstPartner){
            Contact contemp = TestClassFactory.testContact(a.name,a.name+'@'+ a.name+'.com',idPartnerContactRecordId);
            contemp.accountId = a.Id;
            lstContact.add(contemp);
        }
        
        insert lstContact;
        
        lstpartnerUser = new List<User>();
        Integer num =10;
        
        for(Contact con:lstContact){
            if(con.AccountId==loanAccountId)
                tpsContactId=con.Id;
            if(con.AccountId==DRIPAccountId)
                dripContactId=con.Id;
            if(con.AccountId==IPAccountId)
                ipContactId=con.Id;
            User partnerUser= TestUtils.createPartnerPortalUser(con, false);
            partnerUser.Quote_Creation_Allowed__c=true;
            partnerUser.Lease_doc_creation_allowed__c=true;
            partnerUser.CommunityNickname =String.valueOf(num)+partnerUser.CommunityNickname.subString(0,5);
            partnerUser.username='testloanxxxtps'+String.valueOf(num)+'@testloanquote.com';
            lstpartnerUser.add(partnerUser);
            num++;
        }
        
        insert lstpartnerUser;
        
        
        for(User u:lstpartnerUser){
            if(u.ContactId==TPSContactId){
                tpsPartnerUserId=u.Id;
            }
            else if(u.ContactId==DRIPContactId){
                dripPartnerUserId=u.Id;
            }
            else if(u.ContactId==IPContactId){
                ipPartnerUserId=u.Id;
            }
        }
    }
    
    
    //Test Loan Quote creation
    public static testMethod void TestLoanQuote1(){
        
        test.startTest();
        Limits.getQueries();
        
        lstCustomerOpportunity= TestUtils.createOpportunities( 1, CustomerAccount.Id, lstCustomerContact[0].Id, false );
        lstCustomerOpportunity[0].OwnerId=tpsPartnerUserId;
        insert lstCustomerOpportunity;
 
        Item__c item = new Item__c();
        item.Name='5123456346';
        item.Item_Category_3__c='327';
        item.Item_ID__c='5123456346';
        item.Status__c='Active';
        insert item;
        
        Quote caLoanQuoteAuto = TestUtils.createQuotes(1, 'CALoanQuoteAuto', lstCustomerOpportunity[0].id, false)[0];
        caLoanQuoteAuto.Account__c=customerAccount.Id;
        caLoanQuoteAuto.OpportunityId=lstCustomerOpportunity[0].Id;
        caLoanQuoteAuto.ContactID=lstCustomerContact[0].Id;
        caLoanQuoteAuto.System_Cost__c=25000.00;
        caLoanQuoteAuto.Module_Oracle_Item_Number__c=item.Id;
        caLoanQuoteAuto.Module_Quantity__c =16;
        caLoanQuoteAuto.Dealer_Fees__c =13000;
        caLoanQuoteAuto.QuoteType__c ='Loan';
        upsert caLoanQuoteAuto;
		
        Installation_Model__c iMIndAuto = new Installation_Model__c(Name='Indirect Auto',Financing_Option__c ='Loan',Type__c ='Auto',Partner__c='Indirect');
        insert iMIndAuto;
        
        POLineFeeSetup__c origPolfs = new POLineFeeSetup__c(MileStone__c ='Origination',Percentage__c=20,Model__c=iMIndAuto.Id,Item__c = item.Id,Value_From__c = 'Dealer_Fees__c');
        insert origPolfs;
        
        caLoanQuoteAuto.Lease_doc_Signed_Date__c=Date.today();
        caLoanQuoteAuto.Lease_Doc_Signed__c=true;
        caLoanQuoteAuto.Installation_Model__c = iMIndAuto.Id;
        caLoanQuoteAuto.Is_Locked__c=true;
        try {
            update caLoanQuoteAuto;
        }
        catch(Exception e){}

        test.stopTest();
    }
	
    public static testMethod void TestLoanQuote2(){
        
        test.startTest();
        Limits.getQueries();
        
        lstCustomerOpportunity= TestUtils.createOpportunities( 1, CustomerAccount.Id, lstCustomerContact[0].Id, false );
        lstCustomerOpportunity[0].OwnerId=tpsPartnerUserId;
        insert lstCustomerOpportunity;
 
        Item__c item = new Item__c();
        item.Name='5123456346';
        item.Item_Category_3__c='327';
        item.Item_ID__c='5123456346';
        item.Status__c='Active';
        insert item;
        
        Quote caLoanQuoteManual = TestUtils.createQuotes(1, 'CALoanQuoteManual', lstCustomerOpportunity[0].id, false)[0];
        CALoanQuoteManual.Account__c=customerAccount.Id;
        CALoanQuoteManual.OpportunityId=lstCustomerOpportunity[0].Id;
        CALoanQuoteManual.ContactID=lstCustomerContact[0].Id;
        CALoanQuoteManual.System_Cost__c=25000.00;
        CALoanQuoteManual.Module_Oracle_Item_Number__c=item.Id;
        CALoanQuoteManual.Module_Quantity__c =16;
        CALoanQuoteManual.Dealer_Fees__c =13000;
        CALoanQuoteManual.QuoteType__c ='Loan';
        upsert CALoanQuoteManual;
        
        Installation_Model__c iMSPDManual = new Installation_Model__c(Name='SPD Manual',Financing_Option__c ='Loan',Type__c ='Manual',Partner__c='SPD',Roles__c='DRIP;IP');
        insert iMSPDManual;
        
        POLineFeeSetup__c origPolfs = new POLineFeeSetup__c(MileStone__c ='Origination',Percentage__c=20,Model__c=iMSPDManual.Id,Item__c = item.Id,Value_From__c = 'Dealer_Fees__c',Partner_Role__c='TPS');
        insert origPolfs;
        
        CALoanQuoteManual.Lease_doc_Signed_Date__c=Date.today();
        CALoanQuoteManual.Installation_Model__c = iMSPDManual.Id;
        CALoanQuoteManual.Is_Locked__c=true;
        try {
            update CALoanQuoteManual;
        }
        catch(Exception e){}
        
        System.debug('CreatePOUtil----->'+CreatePOUtil.checkPOCreation(CALoanQuoteManual.Id,'TPS'));
        
        //Create Quote API Custom Setting
           insert fCreateQuoteFeesFieldsAPI();

      // Skipping the validation for OppTeamMember delete.
       OpportunityTeamMember_Trigger_Utility.bUIcheck = false;   
        
        List<OpportunityTeamMember> optyTMList = new List<OpportunityTeamMember>();
        
        OpportunityTeamMember dripOptyTM = new OpportunityTeamMember(TeamMemberRole='DRIP',OpportunityId=lstCustomerOpportunity[0].Id,UserId=dripPartnerUserId);
        insert dripOptyTM;
        System.debug('CreatePOUtil----->'+CreatePOUtil.checkPOCreation(CALoanQuoteManual.Id,'TPS'));
        delete dripOptyTM;
        
        OpportunityTeamMember ipOptyTM =new OpportunityTeamMember(TeamMemberRole='IP',OpportunityId=lstCustomerOpportunity[0].Id,UserId=ipPartnerUserId);
        insert ipOptyTM;
        System.debug('CreatePOUtil----->'+CreatePOUtil.checkPOCreation(CALoanQuoteManual.Id,'TPS'));
        delete ipOptyTM;
        
        optyTMList.add(new OpportunityTeamMember(TeamMemberRole='DRIP',OpportunityId=lstCustomerOpportunity[0].Id,UserId=dripPartnerUserId));
        optyTMList.add(new OpportunityTeamMember(TeamMemberRole='IP',OpportunityId=lstCustomerOpportunity[0].Id,UserId=ipPartnerUserId));
        insert optyTMList;
        
        CreatePOUtil.checkPOCreation(CALoanQuoteManual.Id,'TPS');
        
        test.stopTest();
    }
    
    public static List <Fee_Distribution__c> fCreateTPSFeeDistribution(Account A, String sPartnerRole, String sDealType){
        
        List<Fee_Distribution__c> lstFD = new List<Fee_Distribution__c> ();   
        lstFD.add( new Fee_Distribution__c(Partner_Name__c = A.Id,Partner_Role__c = sPartnerRole,Deal_Type__c = sDealType,Fixed_Fee__c = 0,Selling_Price_Min__c = 1.66,Selling_Price_Max__c = 6.9,Commision__c = .8,Rank__c = '1',Split_Percentage__c=50,State__c='CA'));
             
        return lstFD;  
    }
    
    public static List <Fee_Distribution__c> fCreateDRIPandIPFeeDistribution (Account A, String sPartnerRole, String sDealType,Integer iFixedFee,decimal iCommission){
        
        List<Fee_Distribution__c> lstFD = new List<Fee_Distribution__c> ();
        lstFD.add(new Fee_Distribution__c(Partner_Name__c = A.Id,Partner_Role__c = sPartnerRole,Deal_Type__c = sDealType,Fixed_Fee__c = iFixedFee,Selling_Price_Min__c = 0,Selling_Price_Max__c = 0, Commision__c = iCommission,Rank__c = '1',Split_Percentage__c=50,State__c='CA'));   

        return lstFD;
    }
    
   public static List<Quote_Fees_Fields_API__c> fCreateQuoteFeesFieldsAPI(){
          List<Quote_Fees_Fields_API__c> lstQuoteAPItemp = new List<Quote_Fees_Fields_API__c>();
          	if(Quote_Fees_Fields_API__c.getInstance('Opportunity Owner') == null)
          lstQuoteAPItemp.add(new Quote_Fees_Fields_API__c(Name = 'Opportunity Owner', Field_API_Name__c = 'TPS_Fee__c'));
          	if(Quote_Fees_Fields_API__c.getInstance('IP') == null)
          lstQuoteAPItemp.add(new Quote_Fees_Fields_API__c(Name = 'IP', Field_API_Name__c = 'IP_Fee__c'));
          if(Quote_Fees_Fields_API__c.getInstance('DRIP') == null) 
          	lstQuoteAPItemp.add(new Quote_Fees_Fields_API__c(Name = 'DRIP', Field_API_Name__c = 'DRIP_Fee__c'));
       return lstQuoteAPItemp;
    } 
}