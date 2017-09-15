public with sharing class AccountServices {
    public static final String ORACLE_SALESPERSON = 'No Sales Credit';
    public static final String ORACLE_PRICE_LIST = 'Zero Price List - USD';
    public static final String ORACLE_PRIMARY = 'Y';
    public static final String ORACLE_STATUS = 'Active';

    public static void createShipBillTos( Map<Id, Account> newAccountsMap, Map<Id, Account> oldAccountsMap )
    {
        List<Account> shippingAccounts = new List<Account>();
        List<Account> billingAccounts = new List<Account>();


        for ( Account newAccount : newAccountsMap.values() )
        {
            //if Trigger.Old is null, just set the old value to blank
            Account oldAccount = (oldAccountsMap == null ) ? new Account() : oldAccountsMap.get(newAccount.Id);


            System.debug ( oldAccount );
            System.debug ( newAccount );


            if ( requiresUpdatedShipTos( newAccount, oldAccount ) )
            {
                shippingAccounts.add( newAccount );
            }
            if ( requiresUpdatedBillTos( newAccount, oldAccount ) )
            {
                billingAccounts.add( newAccount );
            }
        }


        if ( !billingAccounts.isEmpty() )
        {

            Map<Id, Bill_To_Site__c> accountId2BillTo = getOldBillTos( billingAccounts );


            createBillTos( billingAccounts, accountId2BillTo );
        }


        if ( !shippingAccounts.isEmpty() )
        {

            Map<Id, Ship_to_Site__c> accountId2ShipTo = getOldShipTos( shippingAccounts );


            createShipTos( shippingAccounts, accountId2ShipTo );
        }
    }




    public static Map<Id, Bill_To_Site__c> getOldBillTos( List<Account> accountsWithAddresses )
    {
        Map<Id, Bill_To_Site__c> accountId2BillTo = new Map<Id, Bill_To_Site__c>();


        for( Bill_To_Site__c billTo : [SELECT Id, Dealer_Account__c, Oracle_Primary__c FROM Bill_To_Site__c WHERE Dealer_Account__c IN :accountsWithAddresses ])
        {
            accountId2BillTo.put( billTo.Dealer_Account__c, billTo );
        }


        return accountId2BillTo;


    }


    public static Map<Id, Ship_to_Site__c> getOldShipTos( List<Account> accountsWithAddresses )
    {
        Map<Id, Ship_to_Site__c> accountId2ShipTo = new Map<Id, Ship_to_Site__c>();


        for( Ship_to_Site__c shipTo : [SELECT Id, Dealer_Account__c, Oracle_Primary__c FROM Ship_to_Site__c WHERE Dealer_Account__c IN :accountsWithAddresses ] )
        {
            accountId2ShipTo.put( shipTo.Dealer_Account__c, shipTo );
        }


        return accountId2ShipTo;


    }


    public static Boolean requiresUpdatedShipTos( Account newAccount, Account oldAccount )
    {
        System.debug ( newAccount );
        System.debug ( oldAccount );



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


    public static Boolean requiresUpdatedBillTos( Account newAccount, Account oldAccount )
    {
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


    public static void createShipTos( List<Account> accounts, Map<Id, Ship_to_Site__c> accountId2ShipTo )
    {
        List<Ship_to_Site__c> shipTos = new List<Ship_to_Site__c>();


        for ( Account account : accounts )
        {
            Ship_to_Site__c newShipTo;
            if ( accountId2ShipTo.containsKey( account.Id ) )
            {
                newShipTo = accountId2ShipTo.get( account.Id );
                newShipTo = createShipToSite( newShipTo, account );
            }
            else

            {
                newShipTo = createShipToSite( new Ship_to_Site__c(), account );
            }
            shipTos.add( newShipTo );
        }


        if ( !shipTos.isEmpty() )
        {
            try{
                    upsert shipTos;
            }catch(Exception e){
                system.debug('upsert shipTosForUpdate error: ' + e);
            }
        }

    }




    public static void createBillTos( List<Account> accounts, Map<Id, Bill_To_Site__c> accountId2BillTo )
    {
        List<Bill_To_Site__c> billTos = new List<Bill_To_Site__c>();


        for ( Account account : accounts )
        {
            Bill_To_Site__c newBillTo;
            if ( accountId2BillTo.containsKey( account.Id ) )
            {
                newBillTo = accountId2BillTo.get( account.Id );
                newBillTo = createBillToSite( newBillTo, account );
            }
            else

            {
                newBillTo = createBillToSite( new Bill_To_Site__c(), account );
            }

            billTos.add( newBillTo );
        }


        if ( !billTos.isEmpty() )
        {
            try{
                upsert billTos;
            }catch(Exception e){
                    system.debug('upsert billTosForUpdate error: ' + e);
                }
        }
    }


    public static Bill_To_Site__c createBillToSite( Bill_To_Site__c billToSite, Account account )
    {
        if ( billToSite.Dealer_Account__c == null )
        {
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


    public static Ship_to_Site__c createShipToSite( Ship_to_Site__c shipToSite, Account account )
    {
        if ( shipToSite.Dealer_Account__c == null )
        {
            shipToSite.Dealer_Account__c = account.Id;
        }


        shipToSite.Residential_Customer_Account__c = account.Id;
        shipToSite.Address1__c = account.ShippingStreet;
        shipToSite.Oracle_County__c = account.Oracle_Shipping_County__c;
        shipToSite.City__c = account.ShippingCity;
        shipToSite.State__c = account.ShippingState;
        shipToSite.Zip__c = account.ShippingPostalCode;
        shipToSite.Country__c = account.ShippingCountry;
        shipToSite.Oracle_Salesperson__c = ORACLE_SALESPERSON;
        shipToSite.Status__c = ORACLE_STATUS;
        shipToSite.Oracle_Primary__c = ORACLE_PRIMARY;


        return shipToSite;
    }

    public static void createOriginationDocumentsForAccounts(List<Account> accounts){
        Set<String> countries = Pluck.strings('ShippingCountry', accounts);
        Map<String, Origination_Document__c> docMap = new Map<String, Origination_Document__c>();

        List<IDD_Junction__c> juncs = [SELECT   Id, 
                                                Installation_Model__c, 
                                                Installation_Model__r.Country__c, 
                                                Installation_Model__r.Financing_Option__c, 
                                                Invoice_Document_Data__c, 
                                                Invoice_Document_Data__r.Not_Required_For_Approval__c, 
                                                Invoice_Document_Data__r.Location__c, 
                                                Invoice_Document_Data__r.Name, 
                                                Invoice_Document_Data__r.Sharing_Type__c, 
                                                Document_Owner__c, 
                                                State__c, 
                                                Invoice_Type__c, 
                                                System_Type__c 
                                                FROM IDD_Junction__c 
                                                WHERE Installation_Model__r.Country__c IN: countries AND Invoice_Type__c = 'Origination'];


        Set<String> origDocSet = new Set<String>();
        List<Origination_Document__c> origDocs = [SELECT Id, Documents_in_File__c, Account__c FROM Origination_Document__c WHERE Account__c IN :Accounts];
        for (Origination_Document__c od : origDocs){
            origDocSet.add(od.Account__c + '-' + od.Documents_in_File__c);
        }

        for(Account a : accounts){
            for(IDD_Junction__c junc : juncs){
                if(junc.Installation_Model__r.Country__c == a.ShippingCountry && !origDocSet.contains(a.Id + '-' + junc.Invoice_Document_Data__r.Name)){
                    if(junc.State__c != NULL && a.ShippingState != NULL && a.ShippingCountry == 'United States' && junc.State__c.contains(a.ShippingState)){
                        Origination_Document__c doc = new Origination_Document__c();
                        doc.Documents_in_File__c = junc.Invoice_Document_Data__r.Name;
                        doc.Account__c = a.Id;
                        doc.Name = junc.Invoice_Document_Data__r.Name;
                        doc.Not_Required_for_Approval__c = junc.Invoice_Document_Data__r.Not_Required_for_Approval__c;
                        doc.Invoice_Type__c = junc.Invoice_Type__c;
                        docMap.put(String.valueOf(a.Id)+String.valueOf(junc.Invoice_Document_Data__c), doc);
                    }else if(a.ShippingCountry != 'United States'){
                        Origination_Document__c doc = new Origination_Document__c();
                        doc.Documents_in_File__c = junc.Invoice_Document_Data__r.Name;
                        doc.Account__c = a.Id;
                        doc.Name = junc.Invoice_Document_Data__r.Name;
                        doc.Not_Required_for_Approval__c = junc.Invoice_Document_Data__r.Not_Required_for_Approval__c;
                        doc.Invoice_Type__c = junc.Invoice_Type__c;
                        docMap.put(String.valueOf(a.Id)+String.valueOf(junc.Invoice_Document_Data__c), doc);
                    }
                }
            }
        }
        insert docMap.values();
    }
}