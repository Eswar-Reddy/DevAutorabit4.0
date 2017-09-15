public without sharing class AccountServices2 {
    public static final String ORACLE_SALESPERSON = 'No Sales Credit';
    public static final String ORACLE_PRICE_LIST = 'Zero Price List - USD';
    public static final String ORACLE_PRIMARY = 'Y';
    public static final String ORACLE_STATUS = 'Active';
    public static Id partnerRecordTypeId = AccountHandlerUtilities.PartnerRecTypeId;

    static Map<Id, Bill_To_Site__c> accountId2BillTo;
    static Map<Id, Ship_to_Site__c> accountId2ShipTo;

    //Entry for qualification and processing
    public static void createShipBillTos( Map<Id, Account> newAccountsMap, Map<Id, Account> oldAccountsMap) {
        List<Account> shippingAccounts = new List<Account>();
        List<Account> billingAccounts = new List<Account>();
        Set<Account> newAcctsForBilling = new Set<Account>();
        Set<Account> newAcctsForShipping = new Set<Account>();
        accountId2BillTo = new Map<Id, Bill_To_Site__c>();
        accountId2ShipTo = new Map<Id, Ship_To_Site__c>();

        for(Account newAccount : newAccountsMap.values()) {
            if(oldAccountsMap == null) {
                newAcctsForShipping.add(newAccount);

                // don't create bill to site for builders if the partner account has a parent - this is for new homes
                if(newAccount.RecordTypeId != partnerRecordTypeId) {
                    newAcctsForBilling.add(newAccount);
                } else if(String.isBlank(newAccount.ParentId)) {
                    newAcctsForBilling.add(newAccount);
                } else if(newAccount.Type != 'Builder') {
                    newAcctsForBilling.add(newAccount);
                }

            } else {
                Account oldAccount = oldAccountsMap.get(newAccount.Id);

                if(requiresUpdatedShipTos(newAccount, oldAccount)) {
                    shippingAccounts.add( newAccount );
                }
                if(requiresUpdatedBillTos(newAccount, oldAccount)) {
                    // don't create bill to site for builders if the partner account has a parent - this is for new homes
                    if(newAccount.RecordTypeId != partnerRecordTypeId) {
                        billingAccounts.add(newAccount);
                    } else if(String.isBlank(newAccount.ParentId)) {
                        billingAccounts.add(newAccount);
                    } else if(newAccount.Type != 'Builder') {
                        billingAccounts.add(newAccount);
                    }
                }
            }
            if(!newAcctsForBilling.isEmpty()) {
                createNewBillTos(newAcctsForBilling);
            }
            if(!newAcctsForShipping.isEmpty()) {
                createNewShipTos(newAcctsForShipping);
            }
            if(!billingAccounts.isEmpty()) {
                accountId2BillTo = getOldBillTos(billingAccounts);
                updateBillTos(billingAccounts, accountId2BillTo);
            }
            
            if(!shippingAccounts.isEmpty()) {
                accountId2ShipTo = getOldShipTos( shippingAccounts );
                updateShipTos(shippingAccounts, accountId2ShipTo);
            }
        }
    }
    
    public static Map<Id, Bill_To_Site__c> getOldBillTos(List<Account> accountsWithAddresses) {        
        for(Bill_To_Site__c billTo : [SELECT Id, Dealer_Account__c, Oracle_Primary__c FROM Bill_To_Site__c WHERE Dealer_Account__c IN: accountsWithAddresses]) {
            accountId2BillTo.put( billTo.Dealer_Account__c, billTo);
        }
        return accountId2BillTo;
    }
    
    public static Map<Id, Ship_to_Site__c> getOldShipTos(List<Account> accountsWithAddresses) {
        for( Ship_to_Site__c shipTo : [SELECT Id, Dealer_Account__c, Oracle_Primary__c 
                                       FROM Ship_to_Site__c WHERE Dealer_Account__c IN: accountsWithAddresses]) {
                                           System.debug(LoggingLevel.ERROR,'-----shipTo'+shipTo.Id);
                                           accountId2ShipTo.put(shipTo.Dealer_Account__c, shipTo);
                                       }
        return accountId2ShipTo;
    }
    
    public static Boolean requiresUpdatedShipTos(Account newAccount, Account oldAccount) {
        
        Boolean shippingChanged =   (newAccount.ShippingStreet != oldAccount.ShippingStreet
                                     || newAccount.ShippingCity != oldAccount.ShippingCity
                                     || newAccount.ShippingState != oldAccount.ShippingState
                                     || newAccount.ShippingPostalCode != oldAccount.ShippingPostalCode
                                     || newAccount.Oracle_Shipping_County__c != oldAccount.Oracle_Shipping_County__c
                                     || newAccount.ShippingCountry != oldAccount.ShippingCountry);
        
        Boolean hasOracleCountyField;                                    
        
        if(newAccount.ShippingCountry != null && newAccount.ShippingCountry != '' && newAccount.ShippingCountry != Label.Australia)                                    
            hasOracleCountyField =  (newAccount.Oracle_Shipping_County__c != '' && newAccount.Oracle_Shipping_County__c != null);
        
        else
            hasOracleCountyField = true; 
        
        return shippingChanged && hasOracleCountyField;
    }
    
    public static Boolean requiresUpdatedBillTos(Account newAccount, Account oldAccount) {
        Boolean billingChanged =    (newAccount.BillingStreet != oldAccount.BillingStreet
                                     || newAccount.BillingCity != oldAccount.BillingCity
                                     || newAccount.BillingState != oldAccount.BillingState
                                     || newAccount.Oracle_County__c != oldAccount.Oracle_County__c
                                     || newAccount.BillingPostalCode != oldAccount.BillingPostalCode
                                     || newAccount.BillingCountry != oldAccount.BillingCountry);
        
        Boolean hasOracleCountyField;                                    
        
        if(newAccount.BillingCountry != null && newAccount.BillingCountry != '' && newAccount.BillingCountry != Label.Australia)                                  
            hasOracleCountyField =  (newAccount.Oracle_County__c != '' && newAccount.Oracle_County__c != null);
        else
            hasOracleCountyField = true; 
        
        return billingChanged && hasOracleCountyField;
    }
    
    public static void updateShipTos(List<Account> accounts, Map<Id, Ship_to_Site__c> shipToAccounts) {
        List<Ship_to_Site__c> shipTosForUpdate = new List<Ship_to_Site__c>();
        
        System.debug(LoggingLevel.ERROR,'------------shipToAccounts'+shipToAccounts);
        
        for (Account account : accounts) {
            Ship_to_Site__c updatedShipTo;
            
            if(shipToAccounts.containsKey(account.Id)) {
                updatedShipTo = shipToAccounts.get(account.Id);
                updatedShipTo = createShipToSite(updatedShipTo, account);
                System.debug(LoggingLevel.ERROR,'------------updatedShipTo'+updatedShipTo);
            } else {
                updatedShipTo = createShipToSite(new Ship_To_Site__c(), account);
            }
            shipTosForUpdate.add(updatedShipTo);
        }
        System.debug(LoggingLevel.ERROR,'------------shipTosForUpdate'+shipTosForUpdate);
        if(!shipTosForUpdate.isEmpty()) {
            try {
         		upsert shipTosForUpdate;
            }
            catch (Exception e) {
                system.debug('upsert shipTosForUpdate error: ' + e);
            }
        }
    }
    
    public static void createNewShipTos(Set<Account> accounts) {
        List<Ship_To_Site__c> shipTosForInsert = new List<Ship_To_Site__c>();
        for(Account account : accounts) {
            
            Ship_To_Site__c newShipto = createShipToSite(new Ship_To_Site__c(), account);
            shipTosForInsert.add(newShipTo);
        }
        if(!shipTosForInsert.isEmpty()) {
            try{
            	insert shipTosForInsert;	
            }Catch(Exception e){
                
            }
        }
    }
    public static void updateBillTos(List<Account> accounts, Map<Id, Bill_To_Site__c> billToAccounts) {
        List<Bill_To_Site__c> updatedBillTos = new List<Bill_To_Site__c>();
        for (Account account : accounts) {
            Bill_To_Site__c newBillTo;
            if(accountId2BillTo.containsKey(account.Id)) {
                newBillTo = accountId2BillTo.get( account.Id );
                newBillTo = createBillToSite(newBillTo, account);
            } else {
                newBillTo = createBillToSite(new Bill_To_Site__c(), account);
            }
            updatedBillTos.add(newBillTo);
        }
        
        if(!updatedBillTos.isEmpty()) {
            try{
            	upsert updatedBillTos;
            }Catch(Exception e){
                
            }
        }
    }
    
    public static void createNewBillTos(Set<Account> accounts) {
        List<Bill_To_Site__c> newBillTos = new List<Bill_To_Site__c>();
        for (Account account : accounts) {
            Bill_To_Site__c newBillTo = createBillToSite(new Bill_To_Site__c(), account);
            
            newBillTos.add(newBillTo);
        }
        
        if(!newBillTos.isEmpty()) {
            insert newBillTos;
        }
    }
    
    public static Bill_To_Site__c createBillToSite(Bill_To_Site__c billToSite, Account account) {
        if(billToSite.Dealer_Account__c == null) {
            billToSite.Dealer_Account__c = account.Id;
        }
        billToSite.Address1__c = account.BillingStreet;
        billToSite.Oracle_County__c = account.Oracle_County__c;
        billToSite.City__c = account.BillingCity;
        billToSite.State__c = account.BillingState;
        billToSite.Zip__c = account.BillingPostalCode;
        billToSite.Country__c = account.BillingCountry;
        billToSite.Oracle_Salesperson__c = ORACLE_SALESPERSON;
        billToSite.Oracle_Price_List__c = ORACLE_PRICE_LIST;
        billToSite.Oracle_Primary__c = ORACLE_PRIMARY;
        
        return billToSite;
    }
    
    public static Ship_to_Site__c createShipToSite(Ship_to_Site__c shipToSite, Account account) {
        if(shipToSite.Dealer_Account__c == null) {
            shipToSite.Dealer_Account__c = account.Id;
        }
        shipToSite.Residential_Customer_Account__c = account.Id;
        if(account.ShippingStreet == null || account.ShippingStreet == ''
          || account.ShippingCity == null || account.ShippingCity == ''
          || account.ShippingState == null || account.ShippingState == ''
          || account.ShippingPostalCode == null || account.ShippingPostalCode == '') {
              shipToSite.Address1__c = account.BillingStreet;
              shipToSite.City__c = account.BillingCity;
              shipToSite.State__c = account.BillingState;
              shipToSite.Zip__c = account.BillingPostalCode;
          } else {
              shipToSite.Address1__c = account.ShippingStreet;
              shipToSite.City__c = account.ShippingCity;
              shipToSite.State__c = account.ShippingState;
              shipToSite.Zip__c = account.ShippingPostalCode;
          }
        shipToSite.Oracle_County__c = account.Oracle_County__c;
        shipToSite.Oracle_Salesperson__c = ORACLE_SALESPERSON;
        shipToSite.Status__c = ORACLE_STATUS;
        shipToSite.Oracle_Primary__c = ORACLE_PRIMARY;
        
        return shipToSite;
    }
}