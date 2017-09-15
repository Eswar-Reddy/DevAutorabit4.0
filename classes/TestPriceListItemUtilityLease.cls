/* This test class for PriceListItemUtilityLease */
//BLUEWOLF

@isTest
private without sharing class TestPriceListItemUtilityLease {

@isTest
    public static void testPriceListUtilFunctions1(){
        Account acct = getPartnerAccount();
        User u =getPartnerPortalUser(acct);
        acct = u.Contact.Account;
        if(acct.Oracle_Operating_Unit__c == null || acct.Oracle_Operating_Unit__c == ''){
            acct.Oracle_Operating_Unit__c = 'SPCN OU';
            update acct;
        }
        System.runAs(u){
            PriceListItemUtilityLease utilityInstance = PriceListItemUtilityLease.newInstance();
            Price_List__c fee = PriceListItemUtilityLease.getExpediteFeeForPriceList(acct.ID);
            ApexPages.Standardsetcontroller setCon2 = PriceListItemUtilityLease.getPriceListForDealer2AlaCarte(acct.ID);
            ApexPages.Standardsetcontroller setCon3 = PriceListItemUtilityLease.getPriceListForDealer2_FilterType2AlaCarte(acct.ID, 'BoS','test');
            ApexPages.Standardsetcontroller setCon4 = PriceListItemUtilityLease.getPriceListForDealer2_FilterType2AlaCarte(acct.ID, null,'');
            PriceListItemUtilityLease.getPriceListForDealer2AlaCarteAndBOS(acct.ID);
            PriceListItemUtilityLease.getContactsInMap(acct.id);
            PriceListItemUtilityLease.getTermsDocumentsID(acct);
        }
    }

@isTest
    public static void testPriceListUtilFunctions2(){
        Account acct = getPartnerAccount();
        User u =getPartnerPortalUser(acct);
        acct = u.Contact.Account;
        if(acct.Oracle_Operating_Unit__c == null || acct.Oracle_Operating_Unit__c == ''){
            acct.Oracle_Operating_Unit__c = 'SPCN OU';
            update acct;
        }
        //creating oracle items list
        List<Item__c> listOracleItems = createOracleItems();
        SunPower_Design__c spDesign = createSPDesign(acct,listOracleItems);
        List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper> selProductItems = createWrapperList();
        Purchase_Order__c purchaseOrder  = createPO(acct);

        Price_List__c priceList = null;
        for(Price_List__c p : [Select p.Will_Call_Fee__c, p.Shipping_Codes__c, p.RecordTypeId, p.Packaged_System_Item_ID__c, p.Oracle_Operating_Unit__c, p.Name, p.Id, p.Expedite_Fee__c, p.CurrencyIsoCode From Price_List__c p where p.Oracle_Operating_Unit__c like 'SPCN OU' LIMIT 1])
                priceList = p;
        if(priceList == null){
            priceList = new Price_List__c();
            priceList.CurrencyIsoCode = 'USD';
            priceList.Oracle_Operating_Unit__c = 'SPCN OU';
            priceList.Packaged_System_Item_ID__c = '104268';
            priceList.DSR_PO_Group_Email__c ='test@test.com';
            insert priceList;
        }
        //creating price list items for above price list and oracle items and sun power design
        List<Price_List_Item__c> lstSmartPackPriceListItems = createPriceListItemsforDesign(priceList,spDesign,listOracleItems);
        //creating price list items of both types SMART PACK and ALA CARTE
        List<Price_List_Item__c> lstBothTypesPriceListItems = createPriceListItems(priceList,listOracleItems);
        //calling setDesignItemswithPrice method of PriceListItemUtilityLeaseLease
        SunPower_Design__c design = PriceListItemUtilityLease.setDesignItemswithPrice(spDesign.ID, acct.ID, selProductItems, purchaseOrder, acct, false);
        update purchaseOrder;

        //creating purchase order line items of both types (smartpack and non-smartpack)
        List<Purchase_Order_Line__c> polineItemsList = createPOLineItems(purchaseOrder, listOracleItems);
        List<Purchase_Order_Line__c> polineItemsList1 = returnPOLineItems(purchaseOrder, listOracleItems);
        //update oracle items
        if(listOracleItems!= null && listOracleItems.size() > 0){
                listOracleItems[0].Active__c = false;
                update listOracleItems;
        }
        //update SMART PACK price list items
        if(lstSmartPackPriceListItems != null && lstSmartPackPriceListItems.size()>0){
            for(Price_List_Item__c pItem :lstSmartPackPriceListItems){
                pItem.Pricing_1__c = 200;
                pItem.Pricing_2__c = 500;
                PItem.Pricing_3__c = 700;
            }
            //lstSmartPackPriceListItems[5].Effective_End_Date__c = System.today().addMonths(-1);
            update lstSmartPackPriceListItems;
        }
        //update Ala-Carte and Smart pack price list items
        if(lstBothTypesPriceListItems != null && lstBothTypesPriceListItems.size()>0){
            for(Price_List_Item__c pItem :lstBothTypesPriceListItems){
                if(pItem.Type_1__c == 'Ala Carte')
                    pItem.Effective_End_Date__c = System.today().addMonths(-1);
                else{
                    pItem.Pricing_1__c = 200;
                    pItem.Pricing_2__c = 500;
                    PItem.Pricing_3__c = 700;
                }
            }
            //updating price of Ala-Carte item
            lstBothTypesPriceListItems[7].Pricing_1__c = 250;
            lstBothTypesPriceListItems[7].Effective_End_Date__c = System.today().addMonths(2);
            //lstAlaCartePriceItemsList[5].Effective_End_Date__c = System.today().addMonths(-1);
            update lstBothTypesPriceListItems;
        }
        Map<String,String> testMap = new Map<String,String>();
        testMap.put('test','test');
        //calling method updatePOLineItems of PriceListItemUtilityLeaseLease
        PriceListItemUtilityLease.updatePOLineItems(polineItemsList, 'SPCN OU', true, purchaseOrder, false);
        PriceListItemUtilityLease.getShippingMethods(priceList);
        PriceListItemUtilityLease.fillWrapperRestFields(selProductItems);
        PriceListItemUtilityLease.getSortedList(polineItemsList);
        Date dt = PriceListItemUtilityLease.getNextWorkingDate(System.today(), 15);
        PriceListItemUtilityLease.updateLineNumbersForOrder(polineItemsList);
        PriceListItemUtilityLease.calculateOrderPrice(purchaseOrder,selProductItems,'110372');
        if(polineItemsList.size()>0 && selProductItems.size()>0)
            PriceListItemUtilityLease.copyItemToWrapper(purchaseOrder, polineItemsList.get(0), selProductItems.get(0));
        PriceListItemUtilityLease.synchQuantity(selProductItems, '10',  ';', '~');
        PriceListItemUtilityLease.insertListAndUpdateWrapper(purchaseOrder,polineItemsList1,selProductItems);
        PriceListItemUtilityLease.getCategories(purchaseOrder, testMap,false);
        purchaseOrder.SunPower_Design__c = null;
        update purchaseOrder;
        PriceListItemUtilityLease.getCategories(purchaseOrder, testMap,false);
        //polineItemsList1[0].Child_ID__c = 'test';
        //PriceListItemUtilityLease.insertListAndUpdateWrapper(purchaseOrder,polineItemsList1,selProductItems);
    }

    //create price list items
    private static List<Price_List_Item__c> createPriceListItems(Price_List__c priceList, List<Item__c> listOracleItems){
        //Set record type
        Map<String,ID> recTypes = new Map<String,ID>();
        List<Price_List_Item__c> lstItems = new List<Price_List_Item__c> ();
         for (RecordType rec : [Select id,name,developerName from RecordType where sObjectType='Price_List_Item__c']){
            recTypes.put(rec.developerName,rec.ID);
        }
        String rec ='EU';
        for(integer i = 0 ; i < listOracleItems.size() ; i++){
            Price_List_Item__c p = new Price_List_Item__c();
            p.Price_List__c = priceList.ID;
            p.Effective_End_Date__c =Date.Today().addMonths(2);
            p.Effective_Start_Date__c = Date.Today().addMonths(-1);
            p.Name = 'For Testing Purpose';
            p.Item_ID__c = listOracleItems.get(i).ID;
            p.Pricing_1__c = 100 + i;
            p.Pricing_2__c = 200 + i;
            p.Pricing_3__c = 300 + i;
            p.RecordTypeID = recTypes.get(rec);
            p.Quantity_1__c = 1 + i;
            p.Quantity_2__c = 5 + i;
            p.Type_1__c = 'Smart Pack';
            p.Type_2__c = 'In-Roof';
            p.Type_3_Criteria__c = 'Fronius';
            lstItems.add(p);
            rec =(rec=='EU')?'NA' :'EU';
        }
        for(integer i = 0 ; i < listOracleItems.size() ; i++){
            Price_List_Item__c p = new Price_List_Item__c();
            p.Price_List__c = priceList.ID;
            p.Effective_End_Date__c =Date.Today().addMonths(2);
            p.Effective_Start_Date__c = Date.Today().addMonths(-1);
            p.Name = 'For Testing Purpose';
            p.Item_ID__c = listOracleItems.get(i).ID;
            p.Pricing_1__c = 100 + i;
            p.RecordTypeID = recTypes.get(rec);
            p.Quantity_1__c = 1 + i;
            p.Quantity_2__c = 5 + i;
            p.Type_1__c = 'Ala Carte';
            lstItems.add(p);
            rec =(rec=='EU')?'NA' :'EU';
        }
        if(lstItems != null && lstItems.size()>0)
            insert lstItems;
        return lstItems;
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
            pLine1.Item_Type__c = PriceListItemUtilityLease.SMARTPACK_POITEMTYPE;
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
            pLine1.Item_Type__c = PriceListItemUtilityLease.ALACARTE_POITEMTYPE;
            poLineItemList.add(pLine1);
        }
        if(poLineItemList != null && poLineItemList.size()>0)
            insert poLineItemList;
        return poLineItemList;
    }

    //returing purchase order line items w/o creating
    private static List<Purchase_Order_Line__c> returnPOLineItems(Purchase_Order__c po,List<Item__c> listOracleItems){
        List<Purchase_Order_Line__c> poLineItemList1 = new List<Purchase_Order_Line__c>();
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
            pLine1.Item_Type__c = PriceListItemUtilityLease.SMARTPACK_POITEMTYPE;
            poLineItemList1.add(pLine1);
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
            pLine1.Item_Type__c = PriceListItemUtilityLease.ALACARTE_POITEMTYPE;
            pLine1.Child_ID__c = 'test';
            poLineItemList1.add(pLine1);
        }
        //if(poLineItemList != null && poLineItemList.size()>0)
           // insert poLineItemList;
        return poLineItemList1;
    }

    private static List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper> createWrapperList(){
        List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper> wrapperList = new List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper>();
        LeaseOrderWizardController.PurchaseOrderLineItemWrapper wrapperItem0 = new LeaseOrderWizardController.PurchaseOrderLineItemWrapper('test','test','test','test','5.0','USD',5.0,5.0,true,true);
        LeaseOrderWizardController.PurchaseOrderLineItemWrapper wrapperItem1 = new LeaseOrderWizardController.PurchaseOrderLineItemWrapper('test1','test1','test1','test1','5.0','USD',5.0,5.0,true,true);
        LeaseOrderWizardController.PurchaseOrderLineItemWrapper wrapperItem2 = new LeaseOrderWizardController.PurchaseOrderLineItemWrapper('test2','test2','test2','test2','5.0','USD',5.0,5.0,true,true);
        wrapperList.add(wrapperItem0);
        wrapperList.add(wrapperItem1);
        wrapperList.add(wrapperItem2);
        return wrapperList;
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

    Private static void createPOLineItems(Purchase_Order__c po){
        List<Purchase_Order_Line__c> lineItemsList = new List<Purchase_Order_Line__c>();
        for(integer i=0;i<5;i++){
            Purchase_Order_Line__c pLine1 = new Purchase_Order_Line__c();
            pLine1.Purchase_Order__c = po.ID;
            pLine1.Item_Description__c = 'test item'+i;
            pLine1.Item_ID__c = 'testid'+i;
            pLine1.Price__c = 5;
            pLine1.Quantity__c = 5;
            pLine1.Unit_Price__c = 5;
            pLine1.Item_Type__c = PriceListItemUtilityLease.ALACARTE_POITEMTYPE;
            pLine1.Quantity_per_Box__c = 2;
            pLine1.Order_Line_Number__c = '1.0';
            pLine1.CurrencyIsoCode = 'USD';
            lineItemsList.add(pLine1);
        }
        insert lineItemsList;
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

    private static User getPartnerPortalUser(Account acct){
        User user = null;
        for(User u:[select id,Name,contactId,Contact.AccountID, Contact.Account.AccountNumber,Contact.Account.Name,Contact.Account.ShippingStreet,Contact.Account.ShippingState,Contact.Account.ShippingCity,Contact.Account.ShippingCountry,Contact.Account.Oracle_Operating_Unit__c,Contact.Account.ShippingPostalCode, Contact.Account.Oracle_Account_Number__c from User where (Profile.Name = 'Partner Executive' or Profile.Name = 'EU Partner Executive' ) and ContactID != null and isActive =true LIMIT 1]){
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

    private static SunPower_Design__c createSPDesign(Account acct,List<Item__c> lstOracleItems){
        SunPower_Design__c desObj = new SunPower_Design__c();
        desObj.SmartMount__c = true;
        desObj.Name='DES-123';
        desObj.Purchase_Order_Number__c ='TEST-123';
        desObj.system_size__c=25.0;
        //desObj.EU_Mounting_Type__c = 'On-Roof';
        //desObj.EU_Inverter_Type__c = 'Fronius';
        insert desObj;

        List<SunPower_Design_Item__c> desItem = new List<SunPower_Design_Item__c>();

        Item__c testItemModule = new Item__c();
        testItemModule.Name = 'OracleItemId';
        testItemModule.CurrencyIsoCode = 'USD';
        testItemModule.Description__c = 'test description';
        testItemModule.Long_Description__c = 'test long description';
        testItemModule.Item_ID__c = 'testdesignitemModule';
        insert testItemModule;
        //creating one module type design item
        SunPower_Design_Item__c sModule = new SunPower_Design_Item__c(sunPower_Design__c = desObj.id);
        sModule.Oracle_Item_ID__c = testItemModule.ID;
        sModule.name ='test ' ;
        sModule.Component_Type__c ='Module';
        sModule.Description__c ='Test Item Description';
        sModule.Is_Smart_Pack_Item__c =true;
        sModule.Item_ID__c = '111';
        sModule.Quantity__c =20 ;
        desItem.add(sModule);

        for(integer i=0;i<5;i++){
            SunPower_Design_Item__c s1 = new SunPower_Design_Item__c(sunPower_Design__c = desObj.id);
            s1.Oracle_Item_ID__c = lstOracleItems.get(i).ID;
            s1.name ='test ' + (i+100);
            s1.Component_Type__c ='Inverter';
            s1.Description__c ='Test Item '+i+'Description';
            s1.Is_Smart_Pack_Item__c =true;
            s1.Item_ID__c = '111'+(i+100);
            s1.Quantity__c =20 + i;
            desItem.add(s1);
        }
        if(desItem != null && desItem.size()>0)
            insert desItem;

        return desObj;
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

    /* Util function just creating Price List Item */
    private static List<Price_List_Item__c> createPriceListItemsforDesign(Price_List__c priceList,SunPower_Design__c spDesign,List<Item__c> lstOracleItems){
        //Set record type
        Map<String,ID> recTypes = new Map<String,ID>();
        List<Price_List_Item__c> lstItems = new List<Price_List_Item__c> ();
         for (RecordType rec : [Select id,name,developerName from RecordType where sObjectType='Price_List_Item__c']){
            recTypes.put(rec.developerName,rec.ID);
            //recTypes.put(rec.Name,rec.ID);
        }
        integer i=0;
        String rec ='EU';
        //for(SunPower_Design_Item__c item:[Select s.SunPower_Design__r.EU_Mounting_Type__c,s.SunPower_Design__r.EU_Inverter_Type__c,s.SunPower_Design__r.SmartMount__c,s.SunPower_Design__r.DealerAccount__c, s.SunPower_Design__r.Purchase_Order_Number__c, s.SunPower_Design__r.Design_Notes__c, s.SunPower_Design__r.system_size__c, s.SunPower_Design__r.Name, s.SunPower_Design__c, s.Quantity__c, s.Name, s.Item_ID__c, s.Is_Smart_Pack_Item__c, s.Id, s.Description__c, s.Component_Type__c From SunPower_Design_Item__c s where SunPower_Design__c ='a02T0000001wyJr' order by Is_Smart_Pack_Item__c desc]){
        for(SunPower_Design_Item__c item:[Select s.Oracle_Item_Id__c, s.SunPower_Design__r.EU_Mounting_Type__c,s.SunPower_Design__r.EU_Inverter_Type__c,s.SunPower_Design__r.SmartMount__c,s.SunPower_Design__r.DealerAccount__c, s.SunPower_Design__r.Purchase_Order_Number__c, s.SunPower_Design__r.Design_Notes__c, s.SunPower_Design__r.system_size__c, s.SunPower_Design__r.Name, s.SunPower_Design__c, s.Quantity__c, s.Name, s.Item_ID__c, s.Is_Smart_Pack_Item__c, s.Id, s.Description__c, s.Component_Type__c From SunPower_Design_Item__c s where SunPower_Design__c =:spDesign.ID order by Is_Smart_Pack_Item__c desc]){
            Price_List_Item__c p = new Price_List_Item__c();
            p.Price_List__c = priceList.ID;
            //p.Description__c = item.Description__c;
            p.Effective_End_Date__c =Date.Today().addMonths(2);
            p.Effective_Start_Date__c = Date.Today().addMonths(-1);
            p.Name = 'For Testing Purpose';
            p.Item_ID__c = item.Oracle_Item_ID__c;
            p.Pricing_1__c = 100 + i;
            p.Pricing_2__c = 200 + i;
            p.Pricing_3__c = 300 + i;
            p.RecordTypeID = recTypes.get(rec);
            p.Quantity_1__c = 1 + i;
            p.Quantity_2__c = 5 + i;
            p.Type_1__c = 'Smart Pack';
            p.Type_2__c = item.SunPower_Design__r.EU_Mounting_Type__c;
            p.Type_3_Criteria__c = item.SunPower_Design__r.EU_Inverter_Type__c;
            if(p.Price_List__c != null)
                lstItems.add(p);
            rec =(rec=='EU')?'NA' :'EU';
            i = i + 1;
        }
        System.debug('*********value of i********'+i);
        if(lstItems != null && lstItems.size()>0)
           insert lstItems;
        return  lstItems;
    }

     private static Opportunity createOpp(Account acct,User u){
        Opportunity opp = new Opportunity();
        opp.AccountId = acct.ID;
        opp.Account = acct;
        opp.Name = 'testOpp';
        opp.StageName = 'won';
        opp.ownerId = u.Id;
        opp.Probability = 10;
        opp.Reason_Won_Lost__c = 'Test';
        opp.CloseDate = System.today();
        insert opp;
        return opp;
    }


    @isTest
    public static void testPriceListUtilFunctions3(){

        Account acct = getPartnerAccount();
        User u =getPartnerPortalUser(acct);
        acct = u.Contact.Account;
        acct.BillingCity = 'Jaipur';
        acct.BillingStreet = 'Durgapura';
        acct.BillingCountry = 'India';
        acct.BillingState='Rajasthan';
        acct.BillingPostalCode ='302018';
        acct.ShippingCity = 'Jaipur';
        acct.ShippingStreet = 'Durgapura';
        acct.ShippingCountry = 'India';
        acct.ShippingState='Rajasthan';
        acct.ShippingPostalCode ='302018';
        if(acct.Oracle_Operating_Unit__c == null || acct.Oracle_Operating_Unit__c == ''){
            acct.Oracle_Operating_Unit__c = 'SPCN OU';
            update acct;
        }
        System.runAs(u){


            PriceListItemUtilityLease utilityInstance = PriceListItemUtilityLease.newInstance();

            Opportunity opp = createOpp(acct,u);
            Boolean bol = PriceListItemUtilityLease.isBillingShippingAddressSame(opp);
            String str = PriceListItemUtilityLease.getFormmatedOppBillingAddress(opp);
            str = PriceListItemUtilityLease.getFormmatedOppShippingAddress(opp);
            Set<String> testAccType = PriceListItemUtilityLease.getValidNAAccountType();
            List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper> pWrapList = new List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper>();
            LeaseOrderWizardController.PurchaseOrderLineItemWrapper pWrap = new LeaseOrderWizardController.PurchaseOrderLineItemWrapper('','','','','',true,true);
            pWrapList.add(pWrap);
            LeaseOrderWizardController.PurchaseOrderLineItemWrapper pWrap1 = new LeaseOrderWizardController.PurchaseOrderLineItemWrapper('','','','','',true,true);
            pWrapList.add(pWrap1);
            PriceListItemUtilityLease.addNewDisconnectItem(pWrap);
            //PriceListItemUtilityLease.fillWrapperRestFields(pWrapList);
            //PriceListItemUtilityLease.getShippingMethods(priceList);
            //Price_List__c fee = PriceListItemUtilityLease.getExpediteFeeForPriceList(acct.ID);
            //ApexPages.Standardsetcontroller setCon2 = PriceListItemUtilityLease.getPriceListForDealer2AlaCarte(acct.ID);
            //ApexPages.Standardsetcontroller setCon3 = PriceListItemUtilityLease.getPriceListForDealer2_FilterType2AlaCarte(acct.ID, 'BoS');
            //ApexPages.Standardsetcontroller setCon4 = PriceListItemUtilityLease.getPriceListForDealer2_FilterType2AlaCarte(acct.ID, null);
            //PriceListItemUtilityLease.getPriceListForDealer2AlaCarteAndBOS(acct.ID);
        }
    }

    @isTest
    public static void testPriceListUtilFunctions4(){
        Account acct = getPartnerAccount();
        User u =getPartnerPortalUser(acct);
        acct = u.Contact.Account;
        if(acct.Oracle_Operating_Unit__c == null || acct.Oracle_Operating_Unit__c == ''){
            acct.Oracle_Operating_Unit__c = 'SPCN OU';
            update acct;
        }

        SunPower_Design__c desObj = new SunPower_Design__c();
        desObj.SmartMount__c = true;
        desObj.Name='DES-123';
        desObj.Purchase_Order_Number__c ='TEST-123';
        desObj.system_size__c=25.0;
        insert desObj;

        //creating oracle items list
        List<Item__c> listOracleItems = createOracleItems();
        //SunPower_Design__c spDesign = createSPDesign(acct,listOracleItems);
        SunPower_Design__c spDesign = desObj;
        List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper> selProductItems = createWrapperList();
        Purchase_Order__c purchaseOrder  = createPO(acct);

        Price_List__c priceList = null;
        for(Price_List__c p : [Select p.Will_Call_Fee__c, p.Shipping_Codes__c, p.RecordTypeId, p.Packaged_System_Item_ID__c, p.Oracle_Operating_Unit__c, p.Name, p.Id, p.Expedite_Fee__c, p.CurrencyIsoCode From Price_List__c p where p.Oracle_Operating_Unit__c like 'SPCN OU' LIMIT 1])
                priceList = p;
        if(priceList == null){
            priceList = new Price_List__c();
            priceList.CurrencyIsoCode = 'USD';
            priceList.Oracle_Operating_Unit__c = 'SPCN OU';
            priceList.Packaged_System_Item_ID__c = '104268';
            priceList.DSR_PO_Group_Email__c ='test@test.com';
            insert priceList;
        }
        //creating price list items for above price list and oracle items and sun power design
        List<Price_List_Item__c> lstSmartPackPriceListItems = createPriceListItemsforDesign(priceList,spDesign,listOracleItems);
        //creating price list items of both types SMART PACK and ALA CARTE
        List<Price_List_Item__c> lstBothTypesPriceListItems = createPriceListItems(priceList,listOracleItems);
        //calling setDesignItemswithPrice method of PriceListItemUtilityLease
        SunPower_Design__c design = PriceListItemUtilityLease.setDesignItemswithPrice(spDesign.ID, acct.ID, selProductItems, purchaseOrder, acct, false);
        update purchaseOrder;

        //creating purchase order line items of both types (smartpack and non-smartpack)
        List<Purchase_Order_Line__c> polineItemsList = createPOLineItems(purchaseOrder, listOracleItems);
        List<Purchase_Order_Line__c> polineItemsList1 = returnPOLineItems(purchaseOrder, listOracleItems);
        //update oracle items
        if(listOracleItems!= null && listOracleItems.size() > 0){
                listOracleItems[0].Active__c = false;
                update listOracleItems;
        }
        //update SMART PACK price list items
        if(lstSmartPackPriceListItems != null && lstSmartPackPriceListItems.size()>0){
            for(Price_List_Item__c pItem :lstSmartPackPriceListItems){
                pItem.Pricing_1__c = 200;
                pItem.Pricing_2__c = 500;
                PItem.Pricing_3__c = 700;
            }
            //lstSmartPackPriceListItems[5].Effective_End_Date__c = System.today().addMonths(-1);
            update lstSmartPackPriceListItems;
        }
        //update Ala-Carte and Smart pack price list items
        if(lstBothTypesPriceListItems != null && lstBothTypesPriceListItems.size()>0){
            for(Price_List_Item__c pItem :lstBothTypesPriceListItems){
                if(pItem.Type_1__c == 'Ala Carte')
                    pItem.Effective_End_Date__c = System.today().addMonths(-1);
                else{
                    pItem.Pricing_1__c = 200;
                    pItem.Pricing_2__c = 500;
                    PItem.Pricing_3__c = 700;
                }
            }
            //updating price of Ala-Carte item
            lstBothTypesPriceListItems[7].Pricing_1__c = 250;
            lstBothTypesPriceListItems[7].Effective_End_Date__c = System.today().addMonths(2);
            //lstAlaCartePriceItemsList[5].Effective_End_Date__c = System.today().addMonths(-1);
            update lstBothTypesPriceListItems;
        }
        Map<String,String> testMap = new Map<String,String>();
        testMap.put('test','test');
        //calling method updatePOLineItems of PriceListItemUtilityLease
        PriceListItemUtilityLease.updatePOLineItems(polineItemsList, 'SPCN OU', true, purchaseOrder, false);
        PriceListItemUtilityLease.getShippingMethods(priceList);
        PriceListItemUtilityLease.fillWrapperRestFields(selProductItems);
        PriceListItemUtilityLease.getSortedList(polineItemsList);
        Date dt = PriceListItemUtilityLease.getNextWorkingDate(System.today(), 15);
        PriceListItemUtilityLease.updateLineNumbersForOrder(polineItemsList);
        PriceListItemUtilityLease.calculateOrderPrice(purchaseOrder,selProductItems,'110372');
        if(polineItemsList.size()>0 && selProductItems.size()>0)
            PriceListItemUtilityLease.copyItemToWrapper(purchaseOrder, polineItemsList.get(0), selProductItems.get(0));
        PriceListItemUtilityLease.synchQuantity(selProductItems, '10',  ';', '~');
        PriceListItemUtilityLease.insertListAndUpdateWrapper(purchaseOrder,polineItemsList1,selProductItems);
        PriceListItemUtilityLease.getCategories(purchaseOrder, testMap,false);
        purchaseOrder.SunPower_Design__c = null;
        update purchaseOrder;
        PriceListItemUtilityLease.getCategories(purchaseOrder, testMap,false);
        //polineItemsList1[0].Child_ID__c = 'test';
        //PriceListItemUtilityLease.insertListAndUpdateWrapper(purchaseOrder,polineItemsList1,selProductItems);
    }

    @isTest
    public static void testPriceListUtilPromotionalDiscFuncs1(){
        Account acct = getPartnerAccount();
        User u =getPartnerPortalUser(acct);
        acct = u.Contact.Account;
       /* if(acct.Oracle_Operating_Unit__c == null || acct.Oracle_Operating_Unit__c == ''){
            acct.Oracle_Operating_Unit__c = 'SPCN OU';
            update acct;
        }*/
        acct.Oracle_Operating_Unit__c = 'SPCN OU';
            update acct;

        SunPower_Design__c desObj = new SunPower_Design__c();
        desObj.SmartMount__c = true;
        desObj.Name='DES-123';
        desObj.Purchase_Order_Number__c ='TEST-123';
        desObj.system_size__c=25.0;
        //desObj.Oracle_Item_Id__c = '12345';
        insert desObj;

        List<Item__c> listOracleItems = createOracleItems();


        SunPower_Design_Item__c s = new SunPower_Design_Item__c();
        s.Oracle_Item_Id__c = listOracleItems.get(0).ID;
       // s.Item_Description__c  ='test';
        s.SunPower_Design__c = desObj.ID;
        s.Quantity__c  =2;
        s.Name  ='test';
        s.Is_Smart_Pack_Item__c= true;

        s.Component_Type__c ='Module';

        insert s;
        //creating oracle items list

        //SunPower_Design__c spDesign = createSPDesign(acct,listOracleItems);
        SunPower_Design__c spDesign = desObj;
        List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper> selProductItems = createWrapperList();
        Purchase_Order__c purchaseOrder  = createPO(acct);

        Price_List__c priceList = null;
        if(priceList == null){
            priceList = new Price_List__c();
            priceList.CurrencyIsoCode = 'USD';
            priceList.Oracle_Operating_Unit__c = 'SPCN OU';
            priceList.Packaged_System_Item_ID__c = '104268';
            priceList.DSR_PO_Group_Email__c ='test@test.com';


            insert priceList;
        }

        //creating price list items for above price list and oracle items and sun power design
        List<Price_List_Item__c> lstSmartPackPriceListItems = createPriceListItemsforDesign(priceList,spDesign,listOracleItems);
        List<Price_List_Item__c> plitem = new List<Price_List_Item__c>();//[Select id from  Price_List_Item__c where Price_List__c =: priceList.ID]);

        Price_List_Item__c pli = new Price_List_Item__c();
        pli.Price_List__c = priceList.Id;
        pli.Item_ID__c = listOracleItems.get(0).ID;
        pli.Effective_Start_Date__c = Date.TOday().AddDays(-3);
        pli.Effective_End_Date__c = Date.Today().AddDays(5);
        //pli.Is_Active__c = 'true';
        pli.Type_1__c = 'Smart Pack';

        update plitem;
        SunPower_Design__c design = PriceListItemUtilityLease.setDesignItemswithPrice(spDesign.ID, acct.ID, selProductItems, purchaseOrder, acct, false);
    }

	static testMethod void testInsertListAndUpdateWrapperLineNumber()
	{
		final Integer NUM_ORDER_LINES = 10;

		Purchase_Order__c testOrder = new Purchase_Order__c();
		testOrder.Name = 'Test Order';
		insert testOrder;

		List<Item__c> testItems = new List<Item__c>();
		for( Integer index = 0; index < NUM_ORDER_LINES; index++ )
		{
			Item__c newItem = new Item__c();
			newItem.Name = 'TEST ITEM ' + index;
			newItem.Item_Id__c = String.valueOf( index ) + System.now().getTime();
			testItems.add( newItem );
		}
		insert testItems;

		List<Purchase_Order_Line__c> testPurchaseOrderLines = new List<Purchase_Order_Line__c>();
		for( Item__c anItem : testItems )
		{
			Purchase_Order_Line__c newLine = new Purchase_Order_Line__c();
			newLine.Purchase_Order__c = testOrder.Id;
			newLine.Oracle_Item_ID__c = anItem.Id;
			testPurchaseOrderLines.add( newLine );
		}

		List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper> testWrappers = new List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper>();
		for( Purchase_Order_Line__c purchaseOrderLine : testPurchaseOrderLines )
		{
			LeaseOrderWizardController.PurchaseOrderLineItemWrapper newWrapper = new LeaseOrderWizardController.PurchaseOrderLineItemWrapper();
			newWrapper.oracleItemIDRef = purchaseOrderLine.Oracle_Item_ID__c;
			testWrappers.add( newWrapper );
		}

		Test.startTest();

			PriceListItemUtilityLease.insertListAndUpdateWrapper( testOrder, testPurchaseOrderLines, testWrappers );

		Test.stopTest();

		Integer currentNumber = 0;
		for( LeaseOrderWizardController.PurchaseOrderLineItemWrapper aWrapper : testWrappers )
		{
			System.assert( Integer.valueOf( aWrapper.lineNumber ) > currentNumber, aWrapper.lineNumber + ' is not greater than ' + currentNumber );
			currentNumber = Integer.valueOf( aWrapper.lineNumber );
		}
	}
}