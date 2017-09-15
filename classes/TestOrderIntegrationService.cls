@isTest
public class TestOrderIntegrationService{
    @isTest
    public static void OrderIntegrationServiceTest(){
        
        Account acct = getPartnerAccount();
        User u = getPartnerPortalUser(acct);
        acct = u.Contact.Account;
        Ship_to_Site__c shToSite = setDealerShippingSite(acct);
        Bill_to_Site__c billToSite = setDealerBillingSite(acct);
        System.runAs(u){
            SunPower_Design__c sunDesign = getDesignObjectWithItems(acct);
            if(sunDesign == null) return;
            Purchase_Order__c pur = new Purchase_Order__c();
            pur.Dealer_Account__c = acct.ID;
            //Ship_to_Site__c shToSite = setDealerShippingSite(acct);
            //Bill_to_Site__c billToSite = setDealerBillingSite(acct);            
            pur.Ship_to_Site__c = shToSite.ID;
            pur.Ship_to_Site__r = shToSite;
            pur.Bill_to_Site__c = billToSite.ID;
            pur.Bill_to_Site__r = billToSite;
            pur.Name = 'testpo';
            Opportunity opp = createOpp(acct,u);
            pur.Opportunity__c = opp.ID;
            pur.Opportunity__r = opp;
            pur.Requested_Delivery_Date__c = System.today();    
            pur.Order_Status__c = 'Submitted';
            insert new Lease_2_1_PO_Creation__c(Name='Lease_2_1_Bypass', Lease_2_1_Test_Method_Bypass__c= true );
            insert pur;
            createPOLineItems(pur);
            Test.startTest();
            OrderIntegrationService.GetNewOrders();
            Test.stopTest();
        }
    }
    
    private static Account getPartnerAccount(){
        String recType ='';
        for(RecordType r:[select id,Name from RecordType where sObjectType ='Account' and name ='Partner' LIMIT 1])
             recType = r.ID;
             
        Account acct = new Account(name='test'+String.valueOf(DateTime.now().getTime()),recordTypeID=recType);
        acct.ShippingCity = 'Jaipur';
        acct.ShippingStreet = 'Durgapura';
        acct.ShippingCountry = 'India';
        acct.ShippingState='Rajasthan';
        acct.ShippingPostalCode ='302018';
        acct.BillingCity = 'Jaipur';
        acct.BillingStreet = 'Durgapura';
        acct.BillingCountry = 'India';
        acct.BillingState='Rajasthan';
        acct.BillingPostalCode ='302018';
        acct.Online_Order_Access__c = true;
        acct.Oracle_Account_Number__c = 'testxx12345';
        
        insert acct;
        setDealerShippingSite(acct);
        setDealerBillingSite(acct);
        return acct;                     
    }
    
    private static User getPartnerPortalUser(Account acct){
        User user = null;
        for(User u:[select id,Name,contactId,Contact.AccountID, Contact.Account.Id,Contact.Account.AccountNumber,Contact.Account.Name,Contact.Account.ShippingStreet,Contact.Account.ShippingState,Contact.Account.ShippingCity,Contact.Account.ShippingCountry,Contact.Account.ShippingPostalCode,Contact.Account.Oracle_Operating_Unit__c, Contact.Account.Oracle_Account_Number__c from User where (Profile.Name = 'Partner Delegated Administrator') and ContactID != null and Contact.Authorized_to_Order__c = true and Contact.Account.Online_Order_Access__c = true and Contact.Account.ShippingCountry != null and Contact.Account.ShippingCity != null and Contact.Account.ShippingStreet != null and Contact.Account.ShippingState != null and Contact.Account.ShippingPostalCode != null and isActive=true LIMIT 1]){
            user =u;
        }
        if(user != null) return user;
        if(acct == null){
            acct =  getPartnerAccount();
        }
        Contact cont = new Contact(AccountID = acct.id,FirstName='testconbyPO2',LastName='testconbyPO2');
        cont.Email ='te@test.com';
        cont.Authorized_to_Order__c = true;
        cont.Primary__c = true;
        cont.RecordTypeID = util.GetRecordTypeIdsByDeveloperName(Contact.SObjectType).get('Partner'); //MAM 19.MAY.2015 Get Contact Partner RecordTypeId
        insert cont;        
        
        String username ='testconbyPO2@world.com';
        user = new User(LastName = 'Hello222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
        user.ContactId = cont.Id;
        user.Username = username;
        user.Alias = 'yoo';
        user.CommunityNickname = username.subString(0,7);
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.Email = cont.Email;
        user.LocaleSidKey = 'en_US';     
        List<Profile> lstProfile = [select Id from Profile where Name = 'Partner Executive'];
        if(lstProfile.Size()>0){
            user.ProfileId = lstProfile[0].Id;
            insert user;
        }
        if(user.Id != null)
            for(User u:[select id,Name,contactId,Contact.AccountID, Contact.Account.AccountNumber,Contact.Account.Name,Contact.Account.ShippingStreet,Contact.Account.ShippingState,Contact.Account.ShippingCity,Contact.Account.ShippingCountry,Contact.Account.ShippingPostalCode,Contact.Account.Oracle_Operating_Unit__c, Contact.Account.Oracle_Account_Number__c from User where id =:user.ID LIMIT 1])
                user = u; 
        return user;
        
    }
    
    private static Ship_to_Site__c setDealerShippingSite(Account acct){
        Ship_to_Site__c shipSite = new Ship_to_Site__c();
        shipSite.Dealer_Account__c = acct.ID;
        shipSite.Address1__c ='Test Address1';
        shipSite.Address2__c ='Test Address2';
        shipSite.Address3__c ='Test Address3';
        shipSite.City__c ='Jaipur';
        shipSite.State__c='Rajasthan';
        shipSite.Country__c ='India';
        shipSite.Contact_First_Name__c='Con FirName';
        shipSite.Contact_Last_Name__c='Con LastName';
        shipSite.Zip__c='302018';
        insert shipSite;
        return shipSite;
    }
    
    private static Bill_to_Site__c setDealerBillingSite(Account acct){
        Bill_To_Site__c billToSite = new Bill_To_Site__c();
        billToSite.Dealer_Account__c = acct.ID;
        billToSite.Address1__c ='Test Address1';
        billToSite.Address2__c ='Test Address2';
        billToSite.Address3__c ='Test Address3';
        billToSite.City__c ='Jaipur';
        billToSite.State__c='Rajasthan';
        billToSite.Country__c ='India';
        /*billToSite.Contact_First_Name__c='Con FirName';
        billToSite.Contact_Last_Name__c='Con LastName';*/
        billToSite.Zip__c='302018';
        billToSite.Site_ID__c = String.valueOf(DateTime.now().getTime());
        insert billToSite;
        return billToSite;
    }
    
    private static void createPOLineItems(Purchase_Order__c po){    
        for(integer i=0;i<5;i++){
            Item__c testItem = new Item__c();
            testItem.Name = 'OracleItemId'+i;
            testItem.CurrencyIsoCode = 'USD';
            testItem.Description__c = 'test description'+i;
            testItem.Long_Description__c = 'test long description'+i;
            testItem.Item_ID__c = 'testdesignitem'+i;
            testItem.active__c = true;
            insert testItem;
            
            Purchase_Order_Line__c pLine1 = new Purchase_Order_Line__c();
            pLine1.Purchase_Order__c = po.ID;
            pLine1.Oracle_Item_ID__c = testItem.ID;
            pLine1.Item_Description__c = 'test item'+i;
            pLine1.Item_ID__c = 'testid'+i;
            pLine1.Price__c = 5;
            pLine1.Quantity__c = 5;
            pLine1.Unit_Price__c = 5;
            pLine1.SmartPack_Item__c = false;
            pLine1.Quantity_per_Box__c = 2;
            pLine1.Order_Line_Number__c = '1.0';
            pLine1.CurrencyIsoCode = 'USD';
            insert pLine1;
        }           
    }  
    
        private static SunPower_Design__c getDesignObjectWithItems(Account acct){
        SunPower_Design__c desObj = null;
        if(desObj == null){
            desObj = new SunPower_Design__c();
            desObj.SmartMount__c = true;
            desObj.DealerAccount__c= acct.id;
            desObj.Name='DES-123';
            desObj.Purchase_Order_Number__c ='TEST-123';
            desObj.system_size__c=25.0;
            insert desObj;
            List<SunPower_Design_Item__c> desItem = new List<SunPower_Design_Item__c>(); 
            for(integer i=0;i<5;i++){
                SunPower_Design_Item__c s1 = new SunPower_Design_Item__c(sunPower_Design__c = desObj.id);
                s1.Component_Type__c ='inverter - A';
                s1.Description__c ='Test Item '+i+'Description';
                s1.Is_Smart_Pack_Item__c =true;
                s1.Item_ID__c = '111'+(i+100);
                s1.Quantity__c =20 + i;
                desItem.add(s1);
            }
            if(desItem != null && desItem.size()>0)
                insert desItem;                     
        }
        return desObj;
    }
    
    private static Opportunity createOpp(Account acct,User u){
        Opportunity opp = new Opportunity();
        opp.AccountId = acct.ID;
        opp.Name = 'testOpp';
        opp.StageName = 'won';
        opp.ownerId = u.Id;
        opp.Probability =10;
        opp.CloseDate = System.today();
        opp.Reason_Won_Lost__c = 'Best Economics';
        insert opp;
        return opp;
    }
    
}