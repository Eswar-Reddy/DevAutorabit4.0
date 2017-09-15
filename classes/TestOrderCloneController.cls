/* This test class for OrderCloneController */

@isTest 
private with sharing class TestOrderCloneController {
    
    @isTest
    public static void TestOrderCloneController1(){
        Account acct = getPartnerAccount();
        User u =getPartnerPortalUser(acct);
        acct = u.Contact.Account;
        if(acct.Oracle_Operating_Unit__c == null || acct.Oracle_Operating_Unit__c == ''){
            acct.Oracle_Operating_Unit__c = 'SPCN OU'; 
            update acct;
        }
        
        
        System.runAs(u){       
            List<Item__c> listOracleItems = createOracleItems();
            Purchase_Order__c purchaseOrder  = createPO(acct);
            List<Purchase_Order_Line__c> polineItemsList = createPOLineItems(purchaseOrder, listOracleItems);
            ApexPages.currentPage().getParameters().put('id', purchaseOrder.Id);         
            OrderCloneController cloneInstance = new OrderCloneController();    
            Id testId = cloneInstance.insertPurchaseOrder();
            cloneInstance.insertPurchaseOrderLine(purchaseOrder.Id);
            cloneInstance.ClonePurchaseOrder();
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
        acct.Oracle_Operating_Unit__c = 'SPCN OU';
        acct.Online_Order_Access__c = true;
        acct.Oracle_Account_Number__c = 'test-12345';
        acct.BillingCity = 'san mateo';
      acct.BillingStreet = 'Concar drive';
      acct.BillingPostalCode ='94402';
      acct.BillingCountry = 'USA'; 
        insert acct;
        setDealerShippingSite(acct);
        setDealerBillingSite(acct);
        return acct;                     
    }
    
     private static User getPartnerPortalUser(Account acct){
        User user = null;
        for(User u:[select id,Name,contactId,Contact.AccountID, Contact.Account.AccountNumber,Contact.Account.Name,Contact.Account.ShippingStreet,Contact.Account.ShippingState,Contact.Account.ShippingCity,Contact.Account.ShippingCountry,Contact.Account.Oracle_Operating_Unit__c,Contact.Account.ShippingPostalCode, Contact.Account.Oracle_Account_Number__c from User where (Profile.Name = 'Partner Executive' or Profile.Name = 'EU Partner Executive' )and isActive = true and ContactID != null LIMIT 1]){
            user =u;
        }
        if(user != null) return user;
        if(acct == null){
            acct =  getPartnerAccount();
        }
        Contact cont = new Contact(AccountID = acct.id,FirstName='testconbyPO2',LastName='testconbyPO2');
        cont.Email ='te@test.com';
        cont.Authorized_to_Order__c = true;
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
        return user;
        
    }
    
    private static List<Item__c> createOracleItems(){
        List<Item__c> lstItems = new List<Item__c>();
        for(integer i=0;i<5;i++){
            Item__c testItem = new Item__c();
            testItem.Name = 'OracleItemId'+i;
            testItem.CurrencyIsoCode = 'USD';
            testItem.Description__c = 'test description'+i;
            testItem.Long_Description__c = 'test long description'+i;
            testItem.Item_ID__c = 'testdesignitem'+i;
            testItem.active__c = true;
            lstItems.add(testItem);           
        }  
        if(lstItems != null && lstItems.size()>0)
            insert lstItems; 
       return lstItems ;   
    }
    
     //creating purchase order line items
    private static List<Purchase_Order_Line__c> createPOLineItems(Purchase_Order__c po,List<Item__c> listOracleItems){  
        List<Purchase_Order_Line__c> poLineItemList = new List<Purchase_Order_Line__c>();
        for(integer i=0;i<5;i++){
            Purchase_Order_Line__c pLine1 = new Purchase_Order_Line__c();
            pLine1.Purchase_Order__c = po.ID;
            pLine1.Item_Description__c = 'test item smartpack'+i;
            pLine1.Item_ID__c = 'testid'+i;
            pLine1.Oracle_Item_Id__c = listOracleItems.get(i).ID;
            pLine1.Price__c = 5;
            pLine1.Quantity__c = 5;
            pLine1.Unit_Price__c = 5;           
            pLine1.Quantity_per_Box__c = 2;
            pLine1.Order_Line_Number__c = '1.0';
            pLine1.CurrencyIsoCode = 'USD';
            pLine1.SmartPack_Item__c = true;
            poLineItemList.add(pLine1);         
        }
        for(integer i=0;i<5;i++){
            Purchase_Order_Line__c pLine1 = new Purchase_Order_Line__c();
            pLine1.Purchase_Order__c = po.ID;
            pLine1.Item_Description__c = 'test item alacarte'+i;
            pLine1.Item_ID__c = 'testid'+i;
            pLine1.Oracle_Item_Id__c = listOracleItems.get(i).ID;
            pLine1.Price__c = 5;
            pLine1.Quantity__c = 5;
            pLine1.Unit_Price__c = 5;       
            pLine1.Quantity_per_Box__c = 2;
            pLine1.Order_Line_Number__c = '1.0';
            pLine1.CurrencyIsoCode = 'USD';
            pLine1.SmartPack_Item__c = false;
            poLineItemList.add(pLine1);
        }
        if(poLineItemList != null && poLineItemList.size()>0)   
            insert poLineItemList;
        return poLineItemList;          
    }   
    
     private static Purchase_Order__c createPO(Account acct){
        Purchase_Order__c po = new Purchase_Order__c();
        po.Dealer_Account__c = acct.ID;
        Ship_to_Site__c shToSite = setDealerShippingSite(acct);
        Bill_to_Site__c billToSite = setDealerBillingSite(acct);            
        po.Ship_to_Site__c = shToSite.ID;
        po.Ship_to_Site__r = shToSite;
        po.Bill_to_Site__c = billToSite.ID;
        po.Bill_to_Site__r = billToSite;          
        po.Requested_Delivery_Date__c = System.today();         
        insert po;
        createPOLineItems(po);
        return po;
    }

     private static Ship_to_Site__c setDealerShippingSite(Account acct){
        Ship_to_Site__c shipSite = new Ship_to_Site__c();
        shipSite.Dealer_Account__c = acct.ID;
        shipSite.Address1__c ='Test Address1';
        shipSite.Address2__c ='Test Address2';
        shipSite.Address3__c ='Test Address3';
        shipSite.City__c ='Jaipur';
        shipSite.State__c='Rajasthan';
        shipSite.Country__c  ='India';
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
        List<Purchase_Order_Line__c> lineItemsList = new List<Purchase_Order_Line__c>();
        for(integer i=0;i<5;i++){
            Purchase_Order_Line__c pLine1 = new Purchase_Order_Line__c();
            pLine1.Purchase_Order__c = po.ID;
            pLine1.Item_Description__c = 'test item'+i;
            pLine1.Item_ID__c = 'testid'+i;
            pLine1.Price__c = 5;
            pLine1.Quantity__c = 5;
            pLine1.Unit_Price__c = 5;
            pLine1.SmartPack_Item__c = false;
            pLine1.Quantity_per_Box__c = 2;
            pLine1.Order_Line_Number__c = '1.0';
            pLine1.CurrencyIsoCode = 'USD';
            lineItemsList.add(pLine1);
        }   
        insert lineItemsList;
    }
}