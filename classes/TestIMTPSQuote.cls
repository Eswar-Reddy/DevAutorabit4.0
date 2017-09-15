//TPS Test Class with IM
@isTest(SeeAllData=true)
public class TestIMTPSQuote {
    
    public static List<Quote> lstQuotes;
    public static List<Contact> lstCustomerContact;
    public static Account customerAccount;
    public static List<Opportunity> lstCustomerOpportunity;
    public static String tpsPartnerUserId;
    public static String dripPartnerUserId;
    public static String ipPartnerUserId;
    public static String tpsContactId;
    public static String dripContactId;
    public static String ipContactId;
    public static String TPSAccountId;
    public static String DRIPAccountId;
    public static String IPAccountId;
    public static List<User> lstPartnerUser;
    public static List<Account> lstPartner;
    public static List<Contact> lstContact;
    public static Installation_Model__c iM;
    
    static{
        //Setting Flags to Skip Triggers
        UserManagement.IS_TEST= true;           
        SFDCSpecialUtilities.isRunningTest=true;
        List<Account> lstAccs=new List<Account>();
        List<Contact> lstCons=new List<Contact>();
        
        
        
        CustomerAccount = TestUtils.createAccount( 'CustomerAcct', TestUtils.getResidentialRecordTypeId(), false );
        CustomerAccount.BillingState = 'NY';
        CustomerAccount.BillingCountry= 'United States';
        insert CustomerAccount;
        
        lstCustomerContact = new List<Contact>();
        lstCustomerContact.add(TestUtils.createContact('CustomerContact', CustomerAccount.Id, true));
        
        
        Schema.DescribeSObjectResult accSchema = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> AccountRecordTypeInfo = accSchema.getRecordTypeInfosByName();
        Id idPartnerRecordId = AccountRecordTypeInfo.get('Partner').getRecordTypeId();
        
        lstPartner = new List<Account> ();
        
        Account acctemp = TestClassFactory.testAccount('XXXTPSXXXTQ',idPartnerRecordId);
        acctemp.NH_SSE_Type__c = 'TPS';
        lstPartner.add(acctemp);
        lstPartner.add(TestClassFactory.testAccount('XXXDRIPXXXTQ',idPartnerRecordId));
        lstPartner.add(TestClassFactory.testAccount('XXXIPXXXTQ',idPartnerRecordId));
        
        insert lstPartner;
        
        List<Fee_Distribution__c> fdList = new List<Fee_Distribution__c> ();
        
        for (Account a : lstPartner){
            if (a.Name.contains('TPS')){
                TPSAccountId=a.Id;
                fdList.addAll(fCreateTPSFeeDistribution (A, 'TPS', 'Lease'));
                customerAccount.Partner_Account__c=a.Id;
            }
            else if (a.Name.contains('DRIP')){
                DRIPAccountId=a.Id;
                fdList.addAll(fCreateDRIPandIPFeeDistribution (A,'DRIP','Lease',4350,0));
            }
            else {
                IPAccountId=a.Id;
                fdList.addAll(fCreateDRIPandIPFeeDistribution (A,'IP','Lease',0,.9));
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
            if(con.AccountId==TPSAccountId)
                tpsContactId=con.Id;
            if(con.AccountId==DRIPAccountId)
                dripContactId=con.Id;
            if(con.AccountId==IPAccountId)
                ipContactId=con.Id;
            User partnerUser= TestUtils.createPartnerPortalUser(con, false);
            partnerUser.Quote_Creation_Allowed__c=true;
            partnerUser.Lease_doc_creation_allowed__c=true;
            partnerUser.CommunityNickname =String.valueOf(num)+partnerUser.CommunityNickname.subString(0,5);
            partnerUser.username='xxxtps'+String.valueOf(num)+'@testtpsquote.com';
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
        
        iM = [select Id from Installation_Model__c where Partner__c = 'TPS' limit 1];
    }
    
    //Test TPS Quote creation
    public static testMethod void TestTPSQuote1(){
        
        lstCustomerOpportunity= TestUtils.createOpportunities( 1, CustomerAccount.Id, lstCustomerContact[0].Id, false );
        lstCustomerOpportunity[0].OwnerId=tpsPartnerUserId;
        insert lstCustomerOpportunity;
        
        Item__c item = new Item__c();
        item.Name='5123456346';
        item.Item_Category_3__c='327';
        item.Item_ID__c='5123456346';
        item.Status__c='Active';
        insert item;
        
        //// Quote Creation
        lstQuotes = TestUtils.createQuotes(1, 'NYLeaseQuote', lstCustomerOpportunity[0].id, false);
        lstQuotes[0].Account__c=customerAccount.Id;
        lstQuotes[0].OpportunityId=lstCustomerOpportunity[0].Id;
        lstQuotes[0].ContactID=lstCustomerContact[0].Id;
        lstQuotes[0].System_Cost__c=25000.00;
        lstQuotes[0].Module_Oracle_Item_Number__c=item.Id;
        lstQuotes[0].Module_Quantity__c =16;
        lstQuotes[0].Dealer_Fees__c =13000;
        lstQuotes[0].QuoteType__c ='Lease';
        lstQuotes[0].Quote_type__c='TPS Quote';
        upsert lstQuotes;
        
        test.startTest();
        Limits.getQueries();
        
        lstQuotes[0].Lease_Doc_Signed__c=true;
        lstQuotes[0].Is_Locked__c=true;
        update lstQuotes;
        
        echosign_dev1__SIGN_Agreement__c eds= new echosign_dev1__SIGN_Agreement__c();
        eds.Opportunity__c=lstCustomerOpportunity[0].Id;
        eds.echosign_dev1__Status__c='Signed';
        eds.Quote__c=lstQuotes[0].Id;
        eds.Name='Lease Contract';
        eds.Agreement_Name__c='Lease Contract';
        insert eds;
        
        try{
            lstQuotes[0].Installation_Model__c=iM.Id;
            update lstQuotes;
        }catch(Exception e){
            System.debug('----->'+e.getMessage());
        }
        
        List<OpportunityTeamMember> optyTMList = new List<OpportunityTeamMember>();
        optyTMList.add(new OpportunityTeamMember(TeamMemberRole='DRIP',OpportunityId=lstCustomerOpportunity[0].Id,UserId=dripPartnerUserId));
        optyTMList.add(new OpportunityTeamMember(TeamMemberRole='IP',OpportunityId=lstCustomerOpportunity[0].Id,UserId=ipPartnerUserId));
        insert optyTMList;
        
        try{
            lstQuotes[0].Installation_Model__c=iM.Id;
            update lstQuotes;
        }catch(Exception e){
            System.debug('----->'+e.getMessage());
        }
        
        test.stopTest();
    }
    
    
    public static List <Fee_Distribution__c> fCreateTPSFeeDistribution(Account A, String sPartnerRole, String sDealType){
        List<Fee_Distribution__c> lstFD = new List<Fee_Distribution__c> ();
        lstFD.add(  new Fee_Distribution__c(Partner_Name__c = A.Id,Partner_Role__c = sPartnerRole,Deal_Type__c = sDealType,Fixed_Fee__c = 0,Selling_Price_Min__c = 3.9,Selling_Price_Max__c = 4.15,Commision__c = .5,Rank__c = '1'));    
        return lstFD;  
    }
    
    public static List <Fee_Distribution__c> fCreateDRIPandIPFeeDistribution (Account A, String sPartnerRole, String sDealType,Integer iFixedFee,decimal iCommission){
        List<Fee_Distribution__c> lstFD = new List<Fee_Distribution__c> ();
        lstFD.add(new Fee_Distribution__c(Partner_Name__c = A.Id,Partner_Role__c = sPartnerRole,Deal_Type__c = sDealType,Fixed_Fee__c = iFixedFee,Selling_Price_Min__c = 0,Selling_Price_Max__c = 0, Commision__c = iCommission,Rank__c = '1'));   
        return lstFD;
    }
}