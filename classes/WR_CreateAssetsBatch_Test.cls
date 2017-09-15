/* Test functionality of WR_CreateAssetsBatch batch class 

  @Author Anjali Khandelwal
*/
@isTest
private class WR_CreateAssetsBatch_Test {

    static testMethod void testWR_CreateAssetsBatch() {
        Account acct = getEUItalyPartnerAccount();
        User test_user =getPartnerPortalUser(acct); 
        System.runAs(test_user){ 
        
              
            acct = test_user.Contact.Account;
            Date edt = System.today();
            
            
            //Insert List of customer in database
            Account customer1 = new Account(Name='DummyCustomerAcc1',CurrencyIsoCode='EUR',Theater__c='Europe',BillingCity='testCity',BillingCountry='Italy',BillingStreet='testStreet',BillingPostalCode='testZipCode',Country_Domain__c = 'combo-it');
            insert customer1;
            //test.startTest();
            List<Warranty_Registration__c> wrList = new List<Warranty_Registration__c>();
            Warranty_Registration__c wrc_test1;
            wrc_test1 = new Warranty_Registration__c(Delivery_Date__c=edt,Partner_SFDC_ID__c=acct.Id,Customer_SFDC_ID__c=customer1.Id,status__c = 'Draft');    
            wrList.add(wrc_test1);
            wrc_test1 = new Warranty_Registration__c(Delivery_Date__c=edt,Partner_SFDC_ID__c=acct.Id,Customer_SFDC_ID__c=customer1.Id,status__c = 'Completed');    
            wrList.add(wrc_test1);
            insert wrList;
            Set<Id> wrIds = new Set<Id>();
            for(Warranty_Registration__c wr : wrList){
                wrIds.adD(wr.Id);
            }
            Test.startTest();
            createTestData(wrList);
            
            
            WR_CreateAssetsBatch job = new WR_CreateAssetsBatch(wrIds);
            ID batchprocessid = Database.executeBatch(job);
            //Database.executeBatch(job,200);
            Test.stopTest();
            
            //Staging data will be deleted for completed warranty
            List<WR_StagingSelection__c> stagingList = new List<WR_StagingSelection__c>();
            for(WR_StagingSelection__c staging : [Select id from WR_StagingSelection__c where Warranty_Registration__c =: wrList[1].Id]){
                stagingList.add(staging);
            }
            system.assertEquals(stagingList.size(),0);
            
            //converted_to_asset__c will be true for completed warranty
            //Asset will be created for completed warranty
            for(WR_Line_Item__c lineItem : [Select id, AssetID__c, Wr_FDS_Product__r.converted_to_asset__c from WR_Line_Item__c where Warranty_Registration__c =: wrList[1].Id]){
                system.assert(lineItem.AssetID__c != null);
                system.assertEquals(lineItem.Wr_FDS_Product__r.converted_to_asset__c, true);
            }
            
            //converted_to_asset__c will be false for drafted warranty
            //Asset will be deleted for drafted warranty
            for(WR_Line_Item__c lineItem : [Select id, AssetID__c, Wr_FDS_Product__r.converted_to_asset__c from WR_Line_Item__c where Warranty_Registration__c =: wrList[0].Id]){
                system.assert(lineItem.AssetID__c == null);
                system.assertEquals(lineItem.Wr_FDS_Product__r.converted_to_asset__c, false);
            }
        }
    }
    
    //Create Partner Portal user
     private static User getPartnerPortalUser(Account acct){
        User user = null;   
           
        if(acct == null){
            acct =  getEUItalyPartnerAccount();
        }
        Contact cont = new Contact(AccountID = acct.id,FirstName='testconbyPO2',LastName='testconbyPO2');
        cont.Email ='te@test.com';
        cont.Authorized_to_Order__c = true;
        cont.RecordTypeID = util.GetRecordTypeIdsByDeveloperName(Contact.SObjectType).get('Partner'); //MAM 19.MAY.2015 Get Contact Partner RecordTypeId
        insert cont;
                
       // User user = [Select id from user where id =: userInfo.getUserId()];  
        String username ='anjalitest@test1.com';      
        user = new User(LastName = 'Hello222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
        user.ContactId = cont.Id;
        user.Username = username;
        user.Alias = 'anjali';
        user.CommunityNickname = username.subString(0,7);
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US'; 
        user.Email = cont.Email;
        user.LocaleSidKey = 'en_US';    
        user.Edit_Partner_Users__c = true;
        List<Profile> lstProfile = [select Id from Profile where Name = 'EU Partner Delegated Administrator'];
        if(lstProfile.Size()>0){
            user.ProfileId = lstProfile[0].Id;
            insert user;
        }
        if(user.Id != null)
          for(User u:[select id,Name,contactId,Contact.AccountID, Contact.Account.AccountNumber,Contact.Account.CurrencyIsoCode,Contact.Account.Name,Contact.Account.Country_Domain__c,Contact.Account.Theater__c,Contact.Account.ShippingStreet,Contact.Account.ShippingState,Contact.Account.ShippingCity,Contact.Account.ShippingCountry,Contact.Account.ShippingPostalCode,Contact.Account.Oracle_Operating_Unit__c, Contact.Account.Oracle_Account_Number__c from User where id =:user.ID LIMIT 1])
            user = u; 
        return user;
        
    }
    
    static void createTestData(List<Warranty_Registration__c> wrList){
      
         // creating Customer Account 
        Account customer = new Account(); 
        customer.Name = 'testCustomer';
        customer.BillingCity = 'jaipur';
        customer.BillingState = 'Rajasthan';
        customer.BillingPostalCode = '302021';
        customer.BillingCountry = 'India';
        customer.BillingStreet = 'test streat1';
        customer.Status__c = 'Active';
        customer.Type = 'Home Owner';
        insert customer; 
        // create Item
         Item__c item =  new Item__c();
         item.Description__c = 'PVM, testDesc';
         item.Item_ID__c = 'testItem_ID';
         insert item;
         
        // create Asset
         Asset asset =  new Asset();
         asset.AccountId = customer.id;
         asset.SerialNumber = 'G20J01297002-test'; 
         asset.Name = 'SPR-225-WHT-I N';
         asset.Item__c = item.Id;
         insert asset;
         // WR_FDS_Products
         
         List<WR_FDS_Product__c> products = new List<WR_FDS_Product__c>();
         WR_FDS_Product__c product;
         for(Integer i = 0;i< 5 ;i++){
             product = new WR_FDS_Product__c();
             product.Serial_Number__c = 'G20J01297002-testClsDummy'+i;
             product.Dealer_Name__c = 'test dealer name';
             product.Packing_Slip__c = 'TEST-59011801';
             product.Product_Name__c = 'testDesc';
             product.Converted_To_Asset__c = false;
             products.add(product);
         }
         products[0].Converted_To_Asset__c = true;
         products[1].Converted_To_Asset__c = true;
         products[4].Converted_To_Asset__c = true;
         insert products; 
         
         
         List<WR_Line_Item__c> lstWrLnItem = new List<WR_Line_Item__c>(); 
         WR_Line_Item__c wrLnItem1 = new WR_Line_Item__c(WR_FDS_Product__c = products.get(0).Id,Warranty_Registration__c = wrList[0].Id, AssetID__c = asset.Id);
         lstWrLnItem.add(wrLnItem1);
         wrLnItem1 = new WR_Line_Item__c(WR_FDS_Product__c = products.get(1).Id,Warranty_Registration__c = wrList[0].Id);
         lstWrLnItem.add(wrLnItem1);
         wrLnItem1 = new WR_Line_Item__c(WR_FDS_Product__c = products.get(2).Id,Warranty_Registration__c = wrList[1].Id);
         lstWrLnItem.add(wrLnItem1);
         wrLnItem1 = new WR_Line_Item__c(WR_FDS_Product__c = products.get(3).Id,Warranty_Registration__c = wrList[1].Id);
         lstWrLnItem.add(wrLnItem1);
         wrLnItem1 = new WR_Line_Item__c(WR_FDS_Product__c = products.get(4).Id,Warranty_Registration__c = wrList[0].Id);
         lstWrLnItem.add(wrLnItem1);
         insert lstWrLnItem;
         
         List<WR_StagingSelection__c> stagingList = new List<WR_StagingSelection__c>();
         WR_StagingSelection__c staging = new WR_StagingSelection__c(Warranty_Registration__c = wrList[0].Id);
         stagingList.adD(staging);
         staging = new WR_StagingSelection__c(Warranty_Registration__c = wrList[1].Id);
         stagingList.adD(staging);
         insert stagingList;   
         
    }
    
    /*
        Create Partner Account(Customer) of Italy
    */
    private static Account getEUItalyPartnerAccount(){
        String recType ='';
        for(RecordType r:[select id,Name from RecordType where sObjectType ='Account' and name ='Partner' LIMIT 1])
             recType = r.ID;             
        Account acct = new Account(name='test2'+String.valueOf(DateTime.now().getTime()),recordTypeID=recType);
        acct.ShippingCity = 'Jaipur';
        acct.ShippingStreet = 'Sitapura';
        acct.ShippingCountry = 'Italy';
        acct.ShippingState='Rajasthan';
        acct.ShippingPostalCode ='302020';
        acct.BillingCity = 'Jaipur';
        acct.BillingStreet = 'Sitapura';
        acct.BillingCountry = 'Italy';
        acct.BillingState='Rajasthan';
        acct.BillingPostalCode ='302020';
        acct.Online_Order_Access__c = true;
        acct.Oracle_Account_Number__c = 'test_oracle2';
        acct.Theater__c = 'Europe';
        acct.CurrencyIsoCode='EUR';
        acct.Country_Domain__c = 'combo-it';
        acct.Territory__c = 'Italy';
        acct.Type = 'Partner';
        //acct.OwnerId = WR_Opportunity_Assigned_Owner__c.getInstance('OpportunityOwner').Opportunity_Owner_ID__c; 
        insert acct;
        return acct;                     
    }            
}