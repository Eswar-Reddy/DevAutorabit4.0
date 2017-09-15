/*** Util Class to create Purchase Order and Purchase Order Lines. Code is moved from Trigger to this Class.
Developed By: Birlasoft
***/
Public class UtilQuote
{
    Map<Id, Quote> mapQot =new Map<Id, Quote>(); //Holder for valid Quote for which PO/Line needs to be created
    Map<Id,Id> quotIdDWSTSIdMap = new Map<Id,Id>();//Holder for QuoteId and Dealer Warehouse Ship To Site created on HomeOwner
    Map<Id,Id> quotIdInstallerSTSIdMap = new Map<Id,Id>();//Holder for QuoteId and Installer Ship To Site created on HomeOwner
    List<Purchase_Order__c> lstPO = new List<Purchase_Order__c>();//Holder for Purchase Order
    List<Purchase_Order_Line__c> lstPOL = new List<Purchase_Order_Line__c>();//Holder for Purchase Order Lines
    List<LeasePayment__c> lstLP = new List<LeasePayment__c>();//Holder for Lease Payment

    // bill to site map for TPS Cash orders
    Map<Id, Id> btsTPSCash = new Map<Id, Id>();
    // account set to get bill to sites for TPS Cash orders
    Set<Id> tpsCustomerAccountIds = new Set<Id>();
    // quote set for TPS Cash orders
    Set<Id> tpsCashQuotes = new Set<Id>();
    // install partner map for TPS Cash orders (Quote Id, Default Ship to Site Id)
    Map<Id, Id> installationPartners = new Map<Id, Id>();

    String priceListName = ((Lease_2_1_PO_Creation__c.getInstance('Settings').Price_List_Name__c != null) ? Lease_2_1_PO_Creation__c.getInstance('Settings').Price_List_Name__c : ''); //Price list name to be considered, Custom Setting: Lease_2_1_PO_Creation__c

    Double doubOrgPer = ((Lease_2_1_PO_Creation__c.getInstance('Settings').Lease_Origination_Percentage__c != null) ? Lease_2_1_PO_Creation__c.getInstance('Settings').Lease_Origination_Percentage__c : 0);
    Double doubInstPer = ((Lease_2_1_PO_Creation__c.getInstance('Settings').Lease_Installation_Percentage__c != null) ? Lease_2_1_PO_Creation__c.getInstance('Settings').Lease_Installation_Percentage__c : 0);
    Double doubIntConPer = ((Lease_2_1_PO_Creation__c.getInstance('Settings').Lease_InterConnect_Percentage__c != null) ? Lease_2_1_PO_Creation__c.getInstance('Settings').Lease_InterConnect_Percentage__c : 0);
    Double doubSHPer = ((Lease_2_1_PO_Creation__c.getInstance('Settings').Safe_Harbour_Calculation__c != null) ? Lease_2_1_PO_Creation__c.getInstance('Settings').Safe_Harbour_Calculation__c : 0);

    List<Id> lstItemId = new List<Id>(); //Holds list of items related to Quote Lines
    //List<Id> lstQIds = new List<Id>(); //Valid quotes for PO Creation
    List<Id> lstAcc = new List<Id>(); //Quote's Related Account Id, Quote --> Opportunity --> AccountId
    //Start of code for case: 00381213
    List<Id> lstCustAcc = new List<Id>(); //Quote's Related Account Id, Quote --> Opportunity --> AccountId
    //End of code for case: 00381213
    Map<Id, List<Contact>> mapAccvsContacts = new Map<Id, List<Contact>>();//Holds Account vs It's related Contacts
    Map<Id, List<Id>> mapAccvsSTSite = new Map<Id, List<Id>>();//Holds Account vs It's related Ship to Site recordId
    Map<Id, List<Id>> mapAccvsBTSite = new Map<Id, List<Id>>();//Holds Account vs It's related Bill to Site recordId
    Map<String, Integer> mapQSvsPOCount = new Map<String, Integer>(); //Map of Quote Syummary Id avs its PO record Count

    Map<Id, AccountContactRole> mapShipCont = new Map<Id, AccountContactRole>();//Case 00754398: Oracle setup for order integration for NH Lease PO
    static final String SHIPPING_CONTACT = 'Shipping Contact';//Case 00754398: Oracle setup for order integration for NH Lease PO
    List<Id> lstQInstaller = new List<Id>();//Case 00754398: Oracle setup for order integration for NH Lease PO

    //New Code -- Sunpower TPO Phase 1 -- 20/10/2013
    FR_Record_Type__c frt1       = FR_Record_Type__c.getValues('FR RecordType Id');
    String purchaseOrderRTId = frt1.FR_PurchaseOrder_RT_Id__c;
    String leasePaymentRTId  = frt1.FR_LeasePayment_RT_Id__c;
    String devNHRecordTypeId = String.valueOf(SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(LeasePayment__c.SObjectType).get('NH_Lease_Payment'));
    String devNewRecordTypeId = String.valueOf(SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(LeasePayment__c.SObjectType).get('New_RecordType'));
    String CashRecordTypeId =  String.valueOf(SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(LeasePayment__c.SObjectType).get('TPS_Cash_Payment'));
    //cdevarapalli TPS Phase 2
    String tpsRecordTypeId = String.valueOf(SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(LeasePayment__c.SObjectType).get('TPS'));
    String loanRecordTypeId = String.valueOf(SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(LeasePayment__c.SObjectType).get('Loan'));

   //Sangita added for TPS Installer Partner Issue

    public Static Map<Id,Map<Id,String>> oppIdPartnerIdRoleMap = new Map<Id,Map<Id,String>>();
    public Static Map<Id,String> partnerIdRoleMap = new Map<Id,String>();
    public Static Map<String,Id> rolePartnerIdMap = new Map<String,Id>();

    //End New Code -- Sunpower TPO Phase 1 -- 20/10/2013
    String strDSRPOGroupEmail = '';
    Map<String, String> mapItemVsPL = new Map<String, String>();//Map of Item Id vs PL Id
    Map<String, String> mapItemVsPLI = new Map<String, String>();//Map of Item Id vs PLI Id
    Map<id, Price_List_Item__c> mapPLI = new map<Id, Price_List_Item__c>();


    //Map<ID,String> mapQuoteCountry=new Map<ID,String>(); //Holder for Quote ID & Country Domain.

    //Method to get default Ship To Site from Home Owner
    public void defaultSTS(){
        Set<Id> hoaccountIdSet = new Set<Id>();
        Set<Id> partnerAccountIdSet = new Set<Id>();
        Set<Id> hoInstallerIdSet = new Set<Id>();
        Set<Id> partnerDefdwSTSIdSet = new Set<Id>();
        Set<Id> installerDefdwSTSIdSet = new Set<Id>();

        for(Id qId: mapQot.KeySet()){
            Quote qot = mapQot.get(qId);
            hoaccountIdSet.add(qot.Opportunity.AccountId);
            partnerAccountIdSet.add(qot.Opportunity.Account.Partner_Account__c);
            if(qot.Installer__c != null && qot.Quote_type__c == 'Residential New Homes Lease Quotation')
                hoInstallerIdSet.add(qot.Installer__c);
            partnerDefdwSTSIdSet.add(qot.Opportunity.Account.Partner_Account__r.Default_Dealer_warehouse_Shipping_Site__c);
            installerDefdwSTSIdSet.add(qot.Installer__r.Default_Dealer_warehouse_Shipping_Site__c);
        }

        Map<Id,List<Ship_to_Site__c>> hoIdSTSMap = new Map<Id,List<Ship_to_Site__c>>();
        Map<Id,List<Ship_to_Site__c>> hoInstallerIdSTSIdMap = new Map<Id,List<Ship_to_Site__c>>();
        Map<Id,Ship_to_Site__c> hoIdSTSMapNew =new Map<Id,Ship_to_Site__c>();
        Map<Id,Ship_to_Site__c> partnerdwSTSMap = new Map<Id,Ship_to_Site__c>();
        Map<Id,Ship_to_Site__c> installerSTSMap = new Map<Id,Ship_to_Site__c>();
        List<Ship_to_Site__c> stsList= new List<Ship_to_Site__c>();
        List<Ship_to_Site__c> stsInsertList = new List<Ship_to_Site__c>();

        stsList=[select Id , Address1__c , Address2__c , Address3__c , Address_Unique_ID__c , City__c , Country__c, SiteID__c , State__c , Status__c , Type__c , Zip__c, Dealer_Account__c, Residential_Customer_Account__c from Ship_to_Site__c where Dealer_Account__c in :hoaccountIdSet or Dealer_Account__c  in :hoInstallerIdSet or Id in :partnerDefdwSTSIdSet or Id in :installerDefdwSTSIdSet];
        //Id DealerWarehouseRecordTypeId=[select Id from RecordType where SobjectType='Ship_to_Site__c' and isActive=true and DeveloperName='Dealer_Warehouse'].Id;
        Id DealerWarehouseRecordTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Ship_to_Site__c.SObjectType).get('Dealer_Warehouse');

        for(Ship_to_Site__c sts:stsList){
            if(hoaccountIdSet.contains(sts.Dealer_Account__c)){
                if(hoIdSTSMap.containsKey(sts.Dealer_Account__c)){
                    hoIdSTSMap.get(sts.Dealer_Account__c).add(sts);
                }
                else{
                    hoIdSTSMap.put(sts.Dealer_Account__c,new List<Ship_to_Site__c>{sts});
                }
            }
            else if(partnerDefdwSTSIdSet.contains(sts.Id)){
                partnerdwSTSMap.put(sts.Dealer_Account__c,sts);
            }
            else if(installerDefdwSTSIdSet.contains(sts.Id)){
                installerSTSMap.put(sts.Dealer_Account__c,sts);
            }
        }

        for(Id qId: mapQot.KeySet()){
            Quote qot = mapQot.get(qId);
            if(qot.Quote_type__c != 'Residential New Homes Lease Quotation'){
                if(qot.Opportunity.AccountId!=null && qot.Opportunity.Account.Partner_Account__r.Default_Dealer_warehouse_Shipping_Site__c==null){
                    quotIdDWSTSIdMap.put(qot.Opportunity.AccountId,null);
                }
                else if(qot.Opportunity.AccountId!=null && qot.Opportunity.Account.Partner_Account__r.Default_Dealer_warehouse_Shipping_Site__c!=null){
                    boolean foundSiteId=false;
                    if(hoIdSTSMap.containsKey(qot.Opportunity.AccountId)){
                        for(Ship_to_Site__c sts:hoIdSTSMap.get(qot.Opportunity.AccountId)){
                            if(sts.Type__c=='Dealer Warehouse' && partnerdwSTSMap.containsKey(qot.Opportunity.Account.Partner_Account__c) && sts.Address_Unique_ID__c ==partnerdwSTSMap.get(qot.Opportunity.Account.Partner_Account__c).Address_Unique_ID__c){
                                quotIdDWSTSIdMap.put(qot.Opportunity.AccountId,sts.Id);
                                foundSiteId=true;
                            }
                        }
                    }
                    if(foundSiteId==false && partnerdwSTSMap.containsKey(qot.Opportunity.Account.Partner_Account__c)){
                        Ship_to_Site__c sts = partnerdwSTSMap.get(qot.Opportunity.Account.Partner_Account__c);
                        stsInsertList.add(new Ship_to_Site__c(Address1__c=sts.Address1__c,Address2__c=sts.Address2__c,Address3__c=sts.Address3__c,City__c=sts.City__c,Country__c=sts.Country__c, Dealer_Account__c=qot.Opportunity.AccountId, Residential_Customer_Account__c =qot.Opportunity.AccountId, Status__c='Active', State__c=sts.State__c, Type__c='Dealer Warehouse',Zip__c=sts.Zip__c,RecordTypeId=DealerWarehouseRecordTypeId));
                    }
                }
            }
            else if(qot.Quote_type__c == 'Residential New Homes Lease Quotation'){
                if(qot.Installer__c != null && qot.Installer__r.Default_Dealer_warehouse_Shipping_Site__c==null){
                    quotIdInstallerSTSIdMap.put(qot.Opportunity.AccountId,null);
                }
                else if(qot.Installer__c != null && qot.Installer__r.Default_Dealer_warehouse_Shipping_Site__c!=null){
                    boolean foundSiteId = false;
                    if(hoIdSTSMap.containsKey(qot.Opportunity.AccountId)){
                        for(Ship_to_Site__c sts:hoIdSTSMap.get(qot.Opportunity.AccountId)){
                            if(sts.Type__c=='Dealer Warehouse' && installerSTSMap.containsKey(qot.Installer__c) && sts.Address_Unique_Id__c == installerSTSMap.get(qot.Installer__c).Address_Unique_Id__c){
                                quotIdInstallerSTSIdMap.put(qot.Opportunity.AccountId,sts.Id);
                                foundSiteId=true;
                            }
                        }
                    }
                    if(foundSiteId==false && installerSTSMap.containsKey(qot.Installer__c)){
                        Ship_to_Site__c sts = installerSTSMap.get(qot.Installer__c);
                        stsInsertList.add(new Ship_to_Site__c(Address1__c=sts.Address1__c,Address2__c=sts.Address2__c,Address3__c=sts.Address3__c,City__c=sts.City__c,Country__c=sts.Country__c, Dealer_Account__c=qot.Opportunity.AccountId, Residential_Customer_Account__c =qot.Opportunity.AccountId, Status__c='Active', State__c=sts.State__c, Type__c='Dealer Warehouse',Zip__c=sts.Zip__c,RecordTypeId=DealerWarehouseRecordTypeId));
                    }
                }
            }
        }

        if(!stsInsertList.isEmpty()){
            insert stsInsertList;

            for(Ship_to_Site__c sts:stsInsertList){
                hoIdSTSMapNew.put(sts.Dealer_Account__c,sts);
            }
        }

        for(Id qId: mapQot.KeySet()){
            Quote qot = mapQot.get(qId);
            if(qot.Opportunity.AccountId!=null && !quotIdDWSTSIdMap.containsKey(qot.Opportunity.AccountId) && qot.Quote_type__c != 'Residential New Homes Lease Quotation'){
                if(hoIdSTSMapNew.containsKey(qot.Opportunity.AccountId)){
                    quotIdDWSTSIdMap.put(qot.Opportunity.AccountId,hoIdSTSMapNew.get(qot.Opportunity.AccountId).Id);
                }
            }
            if(qot.Opportunity.AccountId!=null && !quotIdInstallerSTSIdMap.containsKey(qot.Opportunity.AccountId) && qot.Quote_type__c == 'Residential New Homes Lease Quotation'){
                if(hoIdSTSMapNew.containsKey(qot.Opportunity.AccountId)){
                    quotIdInstallerSTSIdMap.put(qot.Opportunity.AccountId,hoIdSTSMapNew.get(qot.Opportunity.AccountId).Id);
                }
            }
        }
        System.debug('quotIdDWSTSIdMap ----->'+quotIdDWSTSIdMap);
        System.debug('quotIdInstallerSTSIdMap ----->'+quotIdInstallerSTSIdMap);
    }

    Public void CreatePOLines(List<ID> lstQIDs)
    {
        system.debug('$$$Inside CreatePOLines '+lstQIds.size());
        InitializeQuote(lstQIDs);  //Method called to Initialize the required Lists & Maps.
        System.debug('$$$MapQuot in CreatePO '+mapqot.size());
        if(!mapQot.isEmpty())
        {
            //cdevarapalli Defaulting ShiptoSite to Default DealerWarehouse Shipping Site of the partner
            defaultSTS();

            for(Id qId: mapQot.KeySet())
            {
                System.debug('$$$qId'+qId);
                Quote qot = mapQot.get(qId);
                Id dwSTSId = null;
                if(quotIdDWSTSIdMap.containsKey(qot.Opportunity.AccountId))
                    dwSTSId=quotIdDWSTSIdMap.get(qot.Opportunity.AccountId);

                Id installerHOSTSId = null;
                if(quotIdInstallerSTSIdMap.containsKey(qot.Opportunity.AccountId))
                    installerHOSTSId=quotIdInstallerSTSIdMap.get(qot.Opportunity.AccountId);
                //Retrieving Country Domain : 15-May-2014
                //String country=(!mapQuoteCountry.isEmpty() && mapQuoteCountry.containsKey(qot.Id) && mapQuoteCountry.get(qot.Id)!=null)? mapQuoteCountry.get(qot.Id).right(2):'';
                //system.debug('$$$Country'+Country);

                // This If Condition is added by adithya to stop creating Duplicate records.
                /*        if(Trigger.oldMap != null && Trigger.oldMap.get(qot.Id) != null && qot.Lease_Doc_Signed__c <> Trigger.oldMap.get(qot.Id).Lease_Doc_Signed__c && qot.Lease_doc_Signed_Date__c == NULL) //New Code -- Sunpower TPO Phase 1 -- 20/10/2013
{*/
                System.debug('$$$mapQSvsPOCount'+mapQSvsPOCount.size());
                System.debug('$$$mapQSvsPOCount'+mapQSvsPOCount);
                if(mapQSvsPOCount.isEmpty() || (!mapQSvsPOCount.isEmpty() && mapQSvsPOCount.containsKey(qot.id) && mapQSvsPOCount.get(qot.id) == 0))//Create only One PO per Quote
                {
                    System.debug('-----------------------1');
                    // system.debug('**************old map***'+Trigger.oldMap.get(qot.Id).Lease_Doc_Signed__c);
                    //New Code -- Sunpower TPO Phase 1 -- 20/10/2013
                    if(qot.Account_Billing_Country__c != null && qot.Account_Billing_Country__c.equalsIgnoreCase('France')){
                        lstPO.add(new Purchase_Order__c(name= qot.Consolidated_Lease_Number__c,
                                                        Quote__c= qot.Id,
                                                        Dealer_Fees__c= qot.Dealer_Fees__c,
                                                        Projected_Install__c= null,
                                                        Opportunity__c= qot.OpportunityId,
                                                        Dealer_Account__c= qot.Opportunity.Account.Partner_Account__c,
                                                        End_Customer_Account__c= qot.Opportunity.AccountId,
                                                        TPO_Account__c = ((qot.Account_Billing_Country__c != null && qot.Account_Billing_Country__c.equalsIgnoreCase('France')) ? Label.TPO_Account_FR : null),
                                                        Lease_Number__c= qot.Consolidated_Lease_Number__c,
                                                        Lease__c= true,//(qot.Quote_Steps__c != null && qot.Quote_Steps__c == 'Lease') ? true : false,//qot.Opportunity.Account.Lease__c,
                                                        Oracle_Order_Type__c= 'SPEB RVAR Lease 2',
                                                        DSR_Po_Group_Email__c= strDSRPOGroupEmail,
                                                        Assigned_DSR__c= qot.Opportunity.Account.Partner_Account__r.Primary_PSR__c,
                                                        Assigned_RSM__c= qot.Opportunity.Account.Partner_Account__r.RSM__c,
                                                        Oracle_Vendor_Number__c= qot.Opportunity.Account.Partner_Account__r.Oracle_Vendor_Number__c,
                                                        Oracle_Vendor_Site_Code__c= qot.Opportunity.Account.Partner_Account__r.Oracle_Vendor_Site_Code__c,
                                                        currencyisocode = qot.currencyisocode,
                                                        Bill_to_Site__c=    ((qot.Opportunity.AccountId != null && !mapAccvsBTSite.isEmpty()   && mapAccvsBTSite.containsKey(qot.Opportunity.AccountId)   && mapAccvsBTSite.get(qot.Opportunity.AccountId) != null   && !mapAccvsBTSite.get(qot.Opportunity.AccountId).isEmpty()   && mapAccvsBTSite.get(qot.Opportunity.AccountId).size()>0)   ? mapAccvsBTSite.get(qot.Opportunity.AccountId)[0]      : null),
                                                        Ship_to_Site__c=    ((qot.Opportunity.AccountId != null && !mapAccvsSTSite.isEmpty()   && mapAccvsSTSite.containsKey(qot.Opportunity.AccountId)   && mapAccvsSTSite.get(qot.Opportunity.AccountId) != null   && !mapAccvsSTSite.get(qot.Opportunity.AccountId).isEmpty()   && mapAccvsSTSite.get(qot.Opportunity.AccountId).size()>0)   ? mapAccvsSTSite.get(qot.Opportunity.AccountId)[0]      : null),
                                                        Contact_Id__c=      ((qot.Opportunity.AccountId != null && !mapAccvsContacts.isEmpty() && mapAccvsContacts.containsKey(qot.Opportunity.AccountId) && mapAccvsContacts.get(qot.Opportunity.AccountId) != null && !mapAccvsContacts.get(qot.Opportunity.AccountId).isEmpty() && mapAccvsContacts.get(qot.Opportunity.AccountId).size()>0) ? mapAccvsContacts.get(qot.Opportunity.AccountId)[0].Id : null),
                                                        RecordTypeId =      ((qot.Account_Billing_Country__c != null && qot.Account_Billing_Country__c.equalsIgnoreCase('France')) ? purchaseOrderRTId : null),      //New Code -- Sunpower TPO Phase 1 -- 20/10/2013
                                                        Ship_To_Contact__c= ((qot.Opportunity.AccountId != null && !mapAccvsContacts.isEmpty() && mapAccvsContacts.containsKey(qot.Opportunity.AccountId) && mapAccvsContacts.get(qot.Opportunity.AccountId) != null && !mapAccvsContacts.get(qot.Opportunity.AccountId).isEmpty() && mapAccvsContacts.get(qot.Opportunity.AccountId).size()>0) ? mapAccvsContacts.get(qot.Opportunity.AccountId)[0].Id : null),
                                                        sales_type__C =      'Third Party Owner'));      //New Code -- For Order Integration Project    //New Code -- For Order Integration Project

                    }
                    //End New Code -- Sunpower TPO Phase 1 -- 20/10/2013
                    //Start New GPP Code for AUSTRALIA -- 30-May-2013:Birlasoft
                    else if(qot.Account_Billing_Country__c != null && qot.Account_Billing_Country__c.equalsIgnoreCase('Australia'))
                    {
                        System.debug('-----------------------3');
                        lstPO.add(new Purchase_Order__c(name= qot.Consolidated_Lease_Number__c,
                                                        Quote__c= qot.Id,
                                                        Dealer_Fees__c= (qot.Dealer_Fee_Installation_Partner_Total__c+ qot.Dealer_Fees_Sales_Partner_Total__c),      ///If Country Domain is AU the Dealer Fee=Install + Sales fee.
                                                        Projected_Install__c= null,
                                                        Opportunity__c= qot.OpportunityId,
                                                        Dealer_Account__c= qot.Opportunity.Account.Partner_Account__c,
                                                        End_Customer_Account__c= qot.Opportunity.AccountId,
                                                        TPO_Account__c = (Label.TPO_Account_AU!=null ? Label.TPO_Account_AU : null),
                                                        Lease_Number__c= qot.Consolidated_Lease_Number__c,
                                                        Lease__c= true,
                                                        Oracle_Order_Type__c= 'SPEB RVAR Lease 2',
                                                        DSR_Po_Group_Email__c= strDSRPOGroupEmail,
                                                        Assigned_DSR__c= qot.Opportunity.Account.Partner_Account__r.Primary_PSR__c,
                                                        Assigned_RSM__c= qot.Opportunity.Account.Partner_Account__r.RSM__c,
                                                        Oracle_Vendor_Number__c= (qot.Installer__c!=null ? qot.Installer__r.Oracle_Vendor_Number__c:null),
                                                        Oracle_Vendor_Site_Code__c=(qot.Installer__c!=null ? qot.Installer__r.Oracle_Vendor_Site_Code__c:null),
                                                        currencyisocode = qot.currencyisocode,
                                                        //For AU- Bill To Site same as TPO Account & Ship To Site same as Installer.: 29-May-2014: Birlasoft
                                                        Bill_to_Site__c=  (Label.TPO_Account_AU!=null && mapAccvsBTSite.containsKey(Label.TPO_Account_AU) ? mapAccvsBTSite.get(Label.TPO_Account_AU)[0] :null),
                                                        Ship_to_Site__c= (qot.Installer__c != null && !mapAccvsSTSite.isEmpty()   && mapAccvsSTSite.containsKey(qot.Installer__c) ? mapAccvsSTSite.get(qot.Installer__c)[0] : null),
                                                        Contact_Id__c=      ((qot.Opportunity.AccountId != null && !mapAccvsContacts.isEmpty() && mapAccvsContacts.containsKey(qot.Opportunity.AccountId) && mapAccvsContacts.get(qot.Opportunity.AccountId) != null && !mapAccvsContacts.get(qot.Opportunity.AccountId).isEmpty() && mapAccvsContacts.get(qot.Opportunity.AccountId).size()>0) ? mapAccvsContacts.get(qot.Opportunity.AccountId)[0].Id : null),
                                                        Ship_To_Contact__c= ((qot.Installer__c != null && !mapAccvsContacts.isEmpty() && mapAccvsContacts.containsKey(qot.Installer__c) && mapAccvsContacts.get(qot.Installer__c) != null && !mapAccvsContacts.get(qot.Installer__c).isEmpty() && mapAccvsContacts.get(qot.Installer__c).size()>0) ? mapAccvsContacts.get(qot.Installer__c)[0].Id : null),
                                                        sales_type__C =      'Third Party Owner',
                                                        installer__c = qot.Installer__c,
                                                        Financier__c = Label.FinancierPO_AU
                                                       )); //New Code -- For Order Integration Project
                    }
                    //END New Code New GPP Code for AUSTRALIA
                    //Start New Home Lease PO Code -- 15-July-2015
                    else if(qot.Account_Billing_Country__c != null && qot.Quote_type__c == 'Residential New Homes Lease Quotation')
                    {
                        System.debug('qot.Opportunity.AccountId ----->'+qot.Opportunity.AccountId);
                        System.debug('mapAccvsBTSite ----->'+mapAccvsBTSite);
                        if(mapAccvsBTSite.containsKey(qot.Opportunity.AccountId))
                            System.debug('mapAccvsBTSite.get(qot.Opportunity.AccountId)[0] ----->'+mapAccvsBTSite.get(qot.Opportunity.AccountId)[0]);
                        System.debug('dwsSTSId ----->'+dwSTSId);
                        System.debug('installerHOSTSId ----->'+installerHOSTSId);
                        System.debug('-----------------------4');
                        lstPO.add(new Purchase_Order__c(name= qot.Consolidated_Lease_Number__c,
                                                        Quote__c= qot.Id,
                                                        Dealer_Fees__c= qot.Dealer_Fees__c,
                                                        Projected_Install__c= null,
                                                        Opportunity__c= qot.OpportunityId,
                                                        //Dealer_Account__c= qot.Opportunity.Account.Partner_Account__c,          //sktemp
                                                        Dealer_Account__c = qot.Installer__c,                                     //NHL - Use the Installer partner as PO Dealer partner for Oracle Order header PartnerId
                                                        End_Customer_Account__c= qot.Opportunity.AccountId,
                                                        TPO_Account__c = ((qot.Account_Billing_Country__c != null && qot.Account_Billing_Country__c.equalsIgnoreCase('Australia') )? Label.TPO_Account_AU : null),
                                                        Lease_Number__c= qot.Consolidated_Lease_Number__c,
                                                        Lease__c= true,
                                                        Oracle_Order_Type__c= 'SPEB RVAR Lease 2',
                                                        DSR_Po_Group_Email__c= strDSRPOGroupEmail,
                                                        Assigned_DSR__c= qot.Opportunity.Account.Partner_Account__r.Primary_PSR__c,
                                                        Assigned_RSM__c= qot.Opportunity.Account.Partner_Account__r.RSM__c,
                                                        Oracle_Vendor_Number__c=  qot.NH_Community__r.Installer__r.Oracle_Vendor_Number__c,       //Set Vendor number   for NH Leases from the NH Community record's Partner
                                                        Oracle_Vendor_Site_Code__c= qot.NH_Community__r.Installer__r.Oracle_Vendor_Site_Code__c,  //Set Vendor sitecode for NH Leases from the NH Community record's Partner
                                                        currencyisocode = qot.currencyisocode,
                                                        Shipping_Method__c = Label.PurchaseOrderDefaultShippingMethod,
                                                        Bill_to_Site__c=    ((qot.Opportunity.AccountId != null && !mapAccvsBTSite.isEmpty()   && mapAccvsBTSite.containsKey(qot.Opportunity.AccountId)   && mapAccvsBTSite.get(qot.Opportunity.AccountId) != null   && !mapAccvsBTSite.get(qot.Opportunity.AccountId).isEmpty()   && mapAccvsBTSite.get(qot.Opportunity.AccountId).size()>0)   ? mapAccvsBTSite.get(qot.Opportunity.AccountId)[0]      : null),
                                                        Ship_to_Site__c=    (qot.Installer__c != null && installerHOSTSId!=null ? installerHOSTSId  : null),
                                                        Contact_Id__c=      ((qot.Opportunity.AccountId != null && !mapAccvsContacts.isEmpty() && mapAccvsContacts.containsKey(qot.Opportunity.AccountId) && mapAccvsContacts.get(qot.Opportunity.AccountId) != null && !mapAccvsContacts.get(qot.Opportunity.AccountId).isEmpty() && mapAccvsContacts.get(qot.Opportunity.AccountId).size()>0) ? mapAccvsContacts.get(qot.Opportunity.AccountId)[0].Id : null),
                                                        //Ship_To_Contact__c= ((qot.Installer__c != null && !mapAccvsContacts.isEmpty() && mapAccvsContacts.containsKey(qot.Installer__c) && mapAccvsContacts.get(qot.Installer__c) != null && !mapAccvsContacts.get(qot.Installer__c).isEmpty() && mapAccvsContacts.get(qot.Installer__c).size()>0) ? mapAccvsContacts.get(qot.Installer__c)[0].Id : null),
                                                        //Case 00754398: Oracle setup for order integration for NH Lease PO
                                                        Ship_To_Contact__c= ((!mapShipCont.isEmpty() && mapShipCont.get(qot.Installer__c).ContactId!=null) ? mapShipCont.get(qot.Installer__c).ContactId : null),
                                                        installer__c=       qot.Installer__c,
                                                        sales_type__c=      'NH Lease'     //Set Sales type to NH Lease for New homes Quotes,
                                                       ));
                    }

                    else{  //Will Run for NA & other country exccept France & Australia
                        System.debug('-----------------------2');

                        //sangita added for TPS bug
                        //query Oracle vendor# for Installer. For TPS POs, we should send Installer as the Dealer_account__c;
                        //get the AccountRoleMap
                        Account IPAcc;
                        if ((mapQot.get(qot.Id).Quote_type__c=='TPS Quote')){
                         rolePartnerIdMap = Dealerfee_cal_Utility_ModelBased.mPartnerRoleWithAccId;
                         IPAcc = [SELECT id, Oracle_Vendor_Number__c, Oracle_Vendor_Site_Code__c FROM Account WHERE id = :rolePartnerIdMap.get('IP')];
                        }
                        // check for TPS Cash quote to set values
                        Id btsId;
                        Id stsId;
                        if(qot.QuoteType__c == 'Cash' && String.isNotBlank(qot.Opportunity.Account.Partner_Account__r.NH_SSE_Type__c) && qot.Opportunity.Account.Partner_Account__r.NH_SSE_Type__c.contains('TPS')) {
                            btsId = btsTPSCash.get(qot.Opportunity.AccountId);
                            stsId = installationPartners.get(qot.Id);
                        } else {
                            btsId = mapAccvsBTSite.containsKey(qot.Opportunity.AccountId) && mapAccvsBTSite.get(qot.Opportunity.AccountId).size()>0 ? mapAccvsBTSite.get(qot.Opportunity.AccountId)[0] : null;
                            stsId = ((qot.Opportunity.AccountId != null && !mapAccvsSTSite.isEmpty()   && mapAccvsSTSite.containsKey(qot.Opportunity.AccountId)   && mapAccvsSTSite.get(qot.Opportunity.AccountId) != null   && !mapAccvsSTSite.get(qot.Opportunity.AccountId).isEmpty()   && mapAccvsSTSite.get(qot.Opportunity.AccountId).size()>0) ? ((dwSTSId!=null) ? dwSTSId : mapAccvsSTSite.get(qot.Opportunity.AccountId)[0]): null);
                        }
                        lstPO.add(new Purchase_Order__c(name= qot.Consolidated_Lease_Number__c,
                                                        Quote__c= qot.Id,
                                                        Dealer_Fees__c= (mapQot.get(qot.Id).Quote_type__c=='TPS Quote' ? qot.Total_Dealer_Fee__c : qot.Dealer_Fees__c),
                                                        Projected_Install__c= null,
                                                        Opportunity__c= qot.OpportunityId,
                                                        Dealer_Account__c= mapQot.get(qot.Id).Quote_type__c=='TPS Quote' ? IPAcc.Id:qot.Opportunity.Account.Partner_Account__c,
                                                        End_Customer_Account__c= qot.Opportunity.AccountId,
                                                        TPO_Account__c = ((qot.Account_Billing_Country__c != null && qot.Account_Billing_Country__c.equalsIgnoreCase('Australia') )? Label.TPO_Account_AU : null),
                                                        Lease_Number__c= qot.Consolidated_Lease_Number__c,
                                                        Lease__c=(mapQot.get(qot.Id).QuoteType__c=='Lease' ? true : false),//(qot.Quote_Steps__c != null && qot.Quote_Steps__c == 'Lease') ? true : false,//qot.Opportunity.Account.Lease__c,
                                                        Oracle_Order_Type__c= 'SPEB RVAR Lease 2',
                                                        DSR_Po_Group_Email__c= strDSRPOGroupEmail,
                                                        Assigned_DSR__c= qot.Opportunity.Account.Partner_Account__r.Primary_PSR__c,
                                                        Assigned_RSM__c= qot.Opportunity.Account.Partner_Account__r.RSM__c,
                                                        Oracle_Vendor_Number__c=   mapQot.get(qot.Id).Quote_type__c=='TPS Quote' ? IPAcc.Oracle_vendor_number__c:qot.Opportunity.Account.Partner_Account__r.Oracle_Vendor_Number__c,
                                                        Oracle_Vendor_Site_Code__c=  mapQot.get(qot.Id).Quote_type__c=='TPS Quote' ? IPAcc.Oracle_Vendor_Site_Code__c:qot.Opportunity.Account.Partner_Account__r.Oracle_Vendor_Site_Code__c,
                                                        currencyisocode = qot.currencyisocode,
                                                        Shipping_Method__c = Label.PurchaseOrderDefaultShippingMethod,
                                                        Bill_to_Site__c = btsId,
                                                        Ship_to_Site__c = stsId,
                                                        Contact_Id__c=      ((qot.Opportunity.AccountId != null && !mapAccvsContacts.isEmpty() && mapAccvsContacts.containsKey(qot.Opportunity.AccountId) && mapAccvsContacts.get(qot.Opportunity.AccountId) != null && !mapAccvsContacts.get(qot.Opportunity.AccountId).isEmpty() && mapAccvsContacts.get(qot.Opportunity.AccountId).size()>0) ? mapAccvsContacts.get(qot.Opportunity.AccountId)[0].Id : null),
                                                        Ship_To_Contact__c= ((qot.Opportunity.AccountId != null && !mapAccvsContacts.isEmpty() && mapAccvsContacts.containsKey(qot.Opportunity.AccountId) && mapAccvsContacts.get(qot.Opportunity.AccountId) != null && !mapAccvsContacts.get(qot.Opportunity.AccountId).isEmpty() && mapAccvsContacts.get(qot.Opportunity.AccountId).size()>0) ? mapAccvsContacts.get(qot.Opportunity.AccountId)[0].Id : null),
                                                        //sales_type__c = (mapQot.get(qot.Id).QuoteType__c=='Loan' ? 'Loan' : 'Lease'),
                                                        sales_type__c = (mapQot.get(qot.Id).QuoteType__c != null ? mapQot.get(qot.Id).QuoteType__c : ''), //Pivotal # 131605921 -> PO was being created with Lease even for Cash Quote
                                                        Financier__c = mapQot.get(qot.Id).QuoteType__c=='Loan' ? 'Mosaic' : 'ITC1'
                                                        ));     //New Code -- For Order Integration Project
                    }//New Code -- Sunpower TPO Phase 1 -- 20/10/2013
                }
            }//End For
            System.debug('$$$ lstPO '+lstPO.size());
            if(!lstPO.isEmpty())
            {
                try{
                    System.debug('STS-----'+lstPO[0].Ship_to_Site__c);
                    insert lstPO;
                    System.debug('------------------lstPO1'+lstPO);
                }
                catch(exception e)
                {
                    system.debug('Exception------1'+e.getmessage());
                }

                //Creating Lease Payment:13th June 2012
                //Updated By Rashmi to check duplicate on the Lease Payment
                System.debug('lstAcc is : '  + lstAcc);
                //Start of code for case: 00381213
                Map<Id,LeasePayment__c> mapLeasePmt = new Map<Id,LeasePayment__c>([SELECT id,name,Status__c,Quote__c,Opportunity__c,Account__c,Account__r.Multiple_Meters__c FROM LeasePayment__c WHERE Account__c=:lstCustAcc]);
                //End of code for case: 00381213
                System.debug('$$$ Existing LeasePayment '+mapLeasepmt.size());
                System.debug(' mapLeasePmt ids are : ' + mapLeasePmt.keyset());
                boolean bStatus = false;
                boolean multMetrs = false;
                Set<ID> setAccIds = new Set<ID>();
                Set<String> setLPStatus = new Set<String>();
                Map<Id,Id> mapLP_IdvsLP_Quo = new Map<Id,Id>();
                Map<Id,Id> mapLP_IdvsLP_Opp = new Map<Id,Id>();
                boolean blnProposalDesignReview = false;
                if(mapLeasePmt.isEmpty()) // Create LP if there are no existing lease Payments for the Account
                {
                    system.debug('****leasepaymentcreation1********');
                    for(Purchase_Order__c po : lstPO)
                    {
                        system.debug('****leasepaymentcreation2********');
                        //New Code -- Sunpower TPO Phase 1 -- 20/10/2013
                        if(!mapQot.isEmpty() && mapQot.get(po.Quote__c) != null){
                            if(mapQot.get(po.Quote__c).Account_Billing_Country__c != null && mapQot.get(po.Quote__c).Account_Billing_Country__c == 'France'){
                                system.debug('****leasepaymentcreation3********');
                                lstLP.add(new LeasePayment__c(name= mapQot.get(po.Quote__c).Opportunity.Account.Name,
                                                              Quote__c= po.Quote__c,
                                                              Opportunity__c= po.Opportunity__c,
                                                              Account__c= po.End_Customer_Account__c,
                                                              Partner_Account__c= po.Dealer_Account__c,
                                                              End_Customer_Account__c= po.End_Customer_Account__c,
                                                              Contact__c= po.Contact_Id__c,
                                                              RecordTypeId = ((mapQot.get(po.Quote__c).Account_Billing_Country__c != null && mapQot.get(po.Quote__c).Account_Billing_Country__c.equalsIgnoreCase('France')) ? leasePaymentRTId : null),   //New Code -- Sunpower TPO Phase 1 -- 20/10/2013
                                                              Date_Lease_Document_signed__c = Date.Today() // Case #00174030 - This field is used to further create LeaseScheduleSummary from LeasePayment
                                                              //Sales_order_number__c = mapQot.get(po.Quote__c).Opportunity.Account.Name,
                                                             ));
                            }

                            else{
                                //End New Code -- Sunpower TPO Phase 1 -- 20/10/2013
                                system.debug('****leasepaymentcreation4********');
                                blnProposalDesignReview = false;
                                if(mapQot.get(po.Quote__c).Agreements__r.size()>0)
                                    blnProposalDesignReview =  mapQot.get(po.Quote__c).Agreements__r.get(0).Proposal_Design_Review_Passed__c;
                                System.debug(LoggingLevel.ERROR,'----------devNHRecordTypeId'+devNHRecordTypeId);
                                System.debug('----------blnProposalDesignReview1'+ blnProposalDesignReview);

                                lstLP.add(new LeasePayment__c(name= mapQot.get(po.Quote__c).Opportunity.Account.Name,
                                                              Quote__c= po.Quote__c,
                                                              Opportunity__c= po.Opportunity__c,
                                                              Account__c= po.End_Customer_Account__c,
                                                              Partner_Account__c= po.Dealer_Account__c,
                                                              End_Customer_Account__c= po.End_Customer_Account__c,
                                                              Contact__c= po.Contact_Id__c,
                                                              Date_Lease_Document_signed__c = Date.Today() // Case #00174030 - This field is used to further create LeaseScheduleSummary from LeasePayment
                                                              //Sales_order_number__c = mapQot.get(po.Quote__c).Opportunity.Account.Name
                                                              //00478102 Origination Payment Process
                                                              //,RecordTypeId = (mapQot.get(po.Quote__c).Quote_type__c=='Residential New Homes Lease Quotation'?devNHRecordTypeId:devNewRecordTypeId)
                                                              //cdevarapalli TPS Phase 2
                                                              ,RecordTypeId = (mapQot.get(po.Quote__c).Quote_type__c=='Residential New Homes Lease Quotation'?devNHRecordTypeId:(mapQot.get(po.Quote__c).Quote_type__c=='TPS Quote'?tpsRecordTypeId:(mapQot.get(po.Quote__c).QuoteType__c=='Loan'?loanRecordTypeId:(mapQot.get(po.Quote__c).QuoteType__c=='Cash'?CashRecordTypeId:devNewRecordTypeId))))
                                                              ,Proposal_Design_Review_Passed__c = blnProposalDesignReview
                                                             ));
                                System.debug(LoggingLevel.ERROR,'----------devNHRecordTypeId'+devNHRecordTypeId);
                                System.debug(LoggingLevel.ERROR,'----------lstLP'+lstLP);
                                System.debug('----------blnProposalDesignReview2'+ blnProposalDesignReview);

                            }//New Code -- Sunpower TPO Phase 1 -- 20/10/2013
                        }
                    }//End for
                }
                else
                {
                    for(Id LId : mapLeasePmt.keySet())
                    {
                        setAccIds.add(mapLeasePmt.get(LId).Account__c);
                        mapLP_IdvsLP_Quo.put(mapLeasePmt.get(LId).Account__c,mapLeasePmt.get(LId).Quote__c);
                        mapLP_IdvsLP_Opp.put(mapLeasePmt.get(LId).Account__c,mapLeasePmt.get(LId).Opportunity__c);
                        System.debug('# status '+mapLeasePmt.get(LId).Status__c);
                        if(mapLeasePmt.get(LId).Status__c == null)
                            bStatus = true;
                        else
                            setLPStatus.add(mapLeasePmt.get(LId).Status__c);// updated by Rashmi on 20/09/2012 to allow duplicate LP when the earlier LP is not active.
                        if(mapLeasePmt.get(LId).Account__r.Multiple_Meters__c == true)
                            multMetrs = true;
                    }
                    for(Purchase_Order__c po : lstPO)
                    {
                        System.debug('\n#@ actAccId'+setAccIds.contains(po.End_Customer_Account__c)+'\n#@ poQuote'+po.Quote__c+'\n#@ LpQuote'+mapLP_IdvsLP_Quo.get(po.End_Customer_Account__c)+'\n#@ lpStatus'+setLPStatus+'\n#@ bstatus'+bStatus+'\n#@ mulMet'+multMetrs);
                        if(mapQot.get(po.Quote__c).Agreements__r.size()>0)
                            blnProposalDesignReview =  mapQot.get(po.Quote__c).Agreements__r.get(0).Proposal_Design_Review_Passed__c;
                        System.debug('----------blnProposalDesignReview3'+ blnProposalDesignReview);
                        //Modified by: Nikki - CS
                        //Added the new status 'Deceased - HO'
                        //case 00346789
                        if(setAccIds.contains(po.End_Customer_Account__c) && ((po.Quote__c != null && mapLP_IdvsLP_Quo.get(po.End_Customer_Account__c)!=null && po.Quote__c != mapLP_IdvsLP_Quo.get(po.End_Customer_Account__c) && multMetrs) || (po.Quote__c != null && mapLP_IdvsLP_Quo.get(po.End_Customer_Account__c)!=null && po.Quote__c != mapLP_IdvsLP_Quo.get(po.End_Customer_Account__c) &&(setLPStatus.contains('Transferred') ||setLPStatus.contains('Terminated') || setLPStatus.contains('Cancelled') || setLPStatus.contains('Cancellation with RMA') || setLPStatus.contains('Expired') || setLPStatus.contains('Duplicate'))&& !(setLPStatus.contains('Active') ||setLPStatus.contains('Pending Cancellation')|| setLPStatus.contains('Deceased HO') || bStatus)))) //Checking for Duplication
                        {
                            //New Code -- Sunpower TPO Phase 1 -- 20/10/2013
                            if(!mapQot.isEmpty() && mapQot.get(po.Quote__c) != null){
                                if(mapQot.get(po.Quote__c).Account_Billing_Country__c != null && mapQot.get(po.Quote__c).Account_Billing_Country__c == 'France'){
                                    lstLP.add(new LeasePayment__c(name= mapQot.get(po.Quote__c).Opportunity.Account.Name,
                                                                  Quote__c= po.Quote__c,
                                                                  Opportunity__c= po.Opportunity__c,
                                                                  Account__c= po.End_Customer_Account__c,
                                                                  Partner_Account__c= po.Dealer_Account__c,
                                                                  End_Customer_Account__c= po.End_Customer_Account__c,
                                                                  Contact__c= po.Contact_Id__c,
                                                                  RecordTypeId = ((mapQot.get(po.Quote__c).Account_Billing_Country__c != null && mapQot.get(po.Quote__c).Account_Billing_Country__c.equalsIgnoreCase('France')) ? leasePaymentRTId : null),     //New Code -- Sunpower TPO Phase 1 -- 20/10/2013
                                                                  Date_Lease_Document_signed__c = Date.Today() // Case #00174030 - This field is used to further create LeaseScheduleSummary from LeasePayment
                                                                  //Sales_order_number__c = mapQot.get(po.Quote__c).Opportunity.Account.Name
                                                                  , Proposal_Design_Review_Passed__c = blnProposalDesignReview
                                                                 ));
                                    System.debug('----------blnProposalDesignReview4'+ blnProposalDesignReview);



                                }
                                else{
                                    //End New Code -- Sunpower TPO Phase 1 -- 20/10/2013
                                    lstLP.add(new LeasePayment__c(name= mapQot.get(po.Quote__c).Opportunity.Account.Name,
                                                                  Quote__c= po.Quote__c,
                                                                  Opportunity__c= po.Opportunity__c,
                                                                  Account__c= po.End_Customer_Account__c,
                                                                  Partner_Account__c= po.Dealer_Account__c,
                                                                  End_Customer_Account__c= po.End_Customer_Account__c,
                                                                  Contact__c= po.Contact_Id__c,
                                                                  Date_Lease_Document_signed__c = Date.Today() // Case #00174030 - This field is used to further create LeaseScheduleSummary from LeasePayment
                                                                  //Sales_order_number__c = mapQot.get(po.Quote__c).Opportunity.Account.Name
                                                                 // ,Proposal_Design_Review_Passed__c = mapQot.get(po.Quote__c).Agreements__r.get(0).Proposal_Design_Review_Passed__c  //Commented Raee$ Case#00721931
                                                                  ,RecordTypeId = (mapQot.get(po.Quote__c).Quote_type__c=='Residential New Homes Lease Quotation'?devNHRecordTypeId:(mapQot.get(po.Quote__c).Quote_type__c=='TPS Quote'?tpsRecordTypeId:devNewRecordTypeId)) //JZAGUIRRE 9/22/15
                                                                  ,Proposal_Design_Review_Passed__c = blnProposalDesignReview // Added Raee$ Case#00721931
                                                                 ));
                                    System.debug('----------blnProposalDesignReview5'+ blnProposalDesignReview);
                                }//New Code -- Sunpower TPO Phase 1 -- 20/10/2013
                            }
                        }
                    }//End for
                }

                Map<String, Item__c> mapDefItems = new Map<String, Item__c>();
                for(Item__c itm: [SELECT i.Id ,i.Name, i.Long_Description__c, i.Item_ID__c, i.Description__c FROM Item__c i WHERE i.Long_Description__c LIKE '%PERFORMANCE GUARANTEE%' OR i.Long_Description__c LIKE '%MATERIAL REIMBURSEMENT%' OR i.Long_Description__c LIKE '%LEASE ORIGINATION%' OR  i.Long_Description__c LIKE '%LEASE INSTALLATION%' OR i.Long_Description__c LIKE '%LEASE INTERCONNECT%' OR i.Description__c LIKE '%PERFORMANCE GUARANTEE%' OR i.Description__c LIKE '%MATERIAL REIMBURSEMENT%' OR i.Description__c LIKE '%LEASE ORIGINATION%' OR i.Description__c LIKE '%LEASE INSTALLATION%' OR i.Description__c LIKE '%LEASE INTERCONNECT%' OR i.Description__c LIKE '%PAYMENT - TPO%' OR i.Description__c LIKE '%TPO - EDFOA SERVICE LINE%']) //Modified Code -- Sunpower TPO Phase 1 -- 20/10/2013
                {

                    //Modified by Adithya start due to NullPointerException while updating Agreement Record
                    //Modified Code -- Sunpower TPO Phase 1 -- 20/10/2013 -- to handle NullPointerException while updating Agreement Record
                    system.debug('****111********'+itm.Long_Description__c);
                    system.debug('******Description__c******'+itm.Description__c);

                    if(itm.Long_Description__c <> null)
                    {

                        if(itm.Long_Description__c.contains('PERFORMANCE GUARANTEE'))
                        {
                            mapDefItems.put('PERFORMANCE GUARANTEE', itm);
                        }

                        if(itm.Long_Description__c.contains('LEASE ORIGINATION'))
                        {
                            mapDefItems.put('LEASE ORIGINATION', itm);
                        }
                        if(itm.Long_Description__c.contains('LEASE INSTALLATION'))
                        {
                            mapDefItems.put('LEASE INSTALLATION', itm);
                        }
                        if(itm.Long_Description__c.contains('LEASE INTERCONNECT'))
                        {
                            mapDefItems.put('LEASE INTERCONNECT', itm);
                        }
                        //New Code -- Sunpower TPO Phase 1 -- 20/10/2013
                        if(itm.Long_Description__c.contains('PAYMENT - TPO'))
                        {
                            mapDefItems.put('PAYMENT - TPO', itm);
                        }
                    }
                    if(itm.Description__c <> NULL){
                        if(itm.Description__c.contains('PERFORMANCE GUARANTEE'))
                        {
                            mapDefItems.put('PERFORMANCE GUARANTEE', itm);
                        }
                        if(itm.Description__c.contains('AU PERFORMANCE GUARANTEE'))
                        {
                            mapDefItems.put('AU PERFORMANCE GUARANTEE', itm);
                        }
                        if(itm.Description__c.contains('LEASE ORIGINATION'))
                        {
                            mapDefItems.put('LEASE ORIGINATION', itm);
                        }
                        if(itm.Description__c.contains('LEASE INSTALLATION'))
                        {
                            mapDefItems.put('LEASE INSTALLATION', itm);
                        }
                        if(itm.Description__c.contains('LEASE INTERCONNECT'))
                        {
                            mapDefItems.put('LEASE INTERCONNECT', itm);
                        }
                        //New Code -- Sunpower TPO Phase 1 -- 20/10/2013
                        if(itm.Description__c.contains('PAYMENT - TPO'))
                        {
                            mapDefItems.put('PAYMENT - TPO', itm);
                        }
                    }
                }

                Integer runningPOLNum = 1; //Sequence Number of POL
                Double InstallerInvoiceFee=0.0,InstallerInterconnectFee=0.0;
                for(Purchase_Order__c po : lstPO)
                {System.debug('$$$ Partner Account'+(mapQot.get(po.Quote__c).Opportunity.Account.Partner_Account__c));
                 if(!mapDefItems.isEmpty() && !mapQot.isEmpty() && mapQot.get(po.Quote__c) != null)
                 {
                     system.debug('**********BT1 before insert*****'+ mapDefItems);
                     if(mapDefItems.containsKey('PERFORMANCE GUARANTEE') && mapQot.get(po.Quote__c).Account_Billing_Country__c != 'France' && mapQot.get(po.Quote__c).Account_Billing_Country__c!='Australia' && mapQOT.get(po.Quote__c).Spectrum_Partner_Quote__c == false && mapQOT.get(po.Quote__c).QuoteType__c!='Loan')  //PERFORMANCE GUARANTEE Addition
                         lstPOL.add(new Purchase_Order_Line__c(Order_Line_Number__c= String.valueOf(runningPOLNum ++),
                                                               Unit_Price__c= 0.0,
                                                               Quantity__c= 1,
                                                               Purchase_Order__c= po.Id,
                                                               Price__c= 0.0,
                                                               currencyisocode = po.currencyisocode,
                                                               Item_Number__c= mapDefItems.get('PERFORMANCE GUARANTEE').Name,
                                                               Item_ID__c= mapDefItems.get('PERFORMANCE GUARANTEE').Item_ID__c,
                                                               Item_Description__c= mapDefItems.get('PERFORMANCE GUARANTEE').Description__c,
                                                               Oracle_Item_ID__c= mapDefItems.get('PERFORMANCE GUARANTEE').Id,
                                                               Oracle_Warehouse__c= ((mapQot.containsKey(po.Quote__c)) ? (mapQot.get(po.Quote__c)).Opportunity.Account.Oracle_Warehouse_Derived__c : '')));
                     if(mapDefItems.containsKey('AU PERFORMANCE GUARANTEE') && mapQot.get(po.Quote__c).Account_Billing_Country__c == 'Australia' && mapQOT.get(po.Quote__c).Spectrum_Partner_Quote__c == false)  //PERFORMANCE GUARANTEE Addition For Australia
                         lstPOL.add(new Purchase_Order_Line__c(Order_Line_Number__c= String.valueOf(runningPOLNum ++),
                                                               Unit_Price__c= 0.0,
                                                               Quantity__c= 1,
                                                               Purchase_Order__c= po.Id,
                                                               Price__c= 0.0,
                                                               currencyisocode = po.currencyisocode,
                                                               Item_Number__c= mapDefItems.get('AU PERFORMANCE GUARANTEE').Name,
                                                               Item_ID__c= mapDefItems.get('AU PERFORMANCE GUARANTEE').Item_ID__c,
                                                               Item_Description__c= mapDefItems.get('AU PERFORMANCE GUARANTEE').Description__c,
                                                               Oracle_Item_ID__c= mapDefItems.get('AU PERFORMANCE GUARANTEE').Id,
                                                               Oracle_Warehouse__c= ((mapQot.containsKey(po.Quote__c)) ? (mapQot.get(po.Quote__c)).Opportunity.Account.Oracle_Warehouse_Derived__c : '')));

                     if((po.Dealer_Fees__c != null && po.Dealer_Fees__c > 0)||(mapQot.get(po.Quote__c).Account_Billing_Country__c=='Australia' && mapQot.get(po.Quote__c).Dealer_Fees_Sales_Partner_Total__c!=null && mapQot.get(po.Quote__c).Dealer_Fees_Sales_Partner_Total__c>0 && mapQot.get(po.Quote__c).Dealer_Fee_Installation_Partner_Total__c!=null && mapQot.get(po.Quote__c).Dealer_Fee_Installation_Partner_Total__c>0) || mapQot.get(po.Quote__c).Quote_type__c=='TPS Quote')
                     {
                         Decimal origFee = doubOrgPer * po.Dealer_Fees__c;
                         origFee = origFee.setScale( 0, System.RoundingMode.HALF_UP );
                         Decimal instFee = doubInstPer * po.Dealer_Fees__c;
                         instFee = instFee.setScale( 0, System.RoundingMode.HALF_UP );
                         Decimal interConFee = po.Dealer_Fees__c - origFee - instFee;

                         if(mapQot.get(po.Quote__c).Account_Billing_Country__c=='Australia')   //Checks if Australia Account.
                         {
                             ///Retrieves Percentage of fees for the seller from the CustomSettings
                             Double sellerOrigPer = ((Lease_2_1_PO_Creation__c.getInstance('SellerFeesAU').Lease_Origination_Percentage__c != null) ?  Lease_2_1_PO_Creation__c.getInstance('SellerFeesAU').Lease_Origination_Percentage__c : 0);
                             Double sellerInterPer = ((Lease_2_1_PO_Creation__c.getInstance('SellerFeesAU').Lease_InterConnect_Percentage__c != null) ? Lease_2_1_PO_Creation__c.getInstance('SellerFeesAU').Lease_InterConnect_Percentage__c : 0);
                             Double sellerInvoicePer = ((Lease_2_1_PO_Creation__c.getInstance('SellerFeesAU').Lease_Installation_Percentage__c != null) ? Lease_2_1_PO_Creation__c.getInstance('SellerFeesAU').Lease_Installation_Percentage__c : 0);
                             ///Retrieves Percentage of fees for the Installer from the CustomSettings
                             Double installerInvoicePer = ((Lease_2_1_PO_Creation__c.getInstance('InstallerFeesAU').Lease_Installation_Percentage__c != null) ? Lease_2_1_PO_Creation__c.getInstance('InstallerFeesAU').Lease_Installation_Percentage__c : 0);
                             Double installerInterPer=((Lease_2_1_PO_Creation__c.getInstance('InstallerFeesAU').Lease_InterConnect_Percentage__c != null) ? Lease_2_1_PO_Creation__c.getInstance('InstallerFeesAU').Lease_InterConnect_Percentage__c : 0);

                             ///Retrieving Seller & Installer Fees from Quote Records which is updated from GPP.
                             Decimal sellerFees=mapQot.get(po.Quote__c).Dealer_Fees_Sales_Partner_Total__c;
                             Decimal installerFees=mapQot.get(po.Quote__c).Dealer_Fee_Installation_Partner_Total__c;

                             ///Calculate Origination, Install & Interconnect Fees for AU Seller
                             origFee = sellerFees * sellerOrigPer;
                             instFee = sellerFees * sellerInvoicePer;
                             interConFee = sellerFees * sellerInterPer;
                             ///Calculate Install & Interconnect Fees for AU Installer
                             InstallerInvoiceFee = installerFees * installerInvoicePer;
                             InstallerInterconnectFee = installerFees * installerInterPer;
                         }

                         if(mapQot.get(po.Quote__c).QuoteType__c=='Cash' || mapQot.get(po.Quote__c).QuoteType__c=='Lease' || mapQot.get(po.Quote__c).QuoteType__c=='Loan'){
                             lstPOL.addAll(PrepPOLineItems.preparePOLines(mapQot,po,runningPOLNum));
                             runningPOLNum=PrepPOLineItems.runningPOLNumber;
                         }
                     }
                 }

                 List<Quote_Line__c> lstQLI = (mapQot.get(po.Quote__c)).Quote_Lines__r;
                 if(!lstQLI.isEmpty())
                 {
                     system.debug('**********before insert3*****'+ lstQLI);
                     for(Quote_Line__c qli : lstQLI)
                     {


                             Decimal dPrice = 0.0;
                             Decimal price = 0.0;
                             if(mapItemVsPLI.containsKey(qli.Item__r.Id) && mapItemVsPLI.get(qli.Item__r.Id) != null)
                             {
                                 dPrice = mapPLI.get((mapItemVsPLI.get(qli.Item__r.Id))).Manufacturing_cost__c ;
                                 if(qli.Quantity__c == null) //CS - R.R.A. - 16.JUNE.2015 - Consider null Quantity as 0
                                     qli.Quantity__c = 0;
                                 price = dPrice * qli.Quantity__c;
                             }
                             if((qli.Quantity__c == 0 || qli.Quantity__c == null)  && qli.Item__r.Description__c != '' && qli.Item__r.Description__c.startsWith('INVERTER'))
                             {
                             }
                             else if((qli.Quantity__c == 0 || qli.Quantity__c == null))
                             {
                             }
                             else
                             {
                                 if(mapQOT.get(po.Quote__c).Spectrum_Partner_Quote__c == true && (qli.Item__r.Description__c.contains('LEASE ORIGINATION') || qli.Item__r.Description__c.contains('LEASE INSTALLATION') || qli.Item__r.Description__c.contains('LEASE INTERCONNECT')))
                                 {
                                     dPrice = qli.Quantity__c * qli.Unit_Price__c;
                                     price = dPrice;
                                 }
                                 // Not creating Purchase Order line for AC Inverter Quote Line for ACPV by Ganesh Chedella
                                 if(!(Label.AC_Inverter_Item_Numbers != null && Label.AC_Inverter_Item_Numbers.contains(qli.Item__r.Name))){
                                    if(!qli.Item__r.Not_Shippable__c)
                                    lstPOL.add(new Purchase_Order_Line__c(Order_Line_Number__c= String.valueOf(runningPOLNum ++),
                                                                       Unit_Price__c= dPrice,
                                                                       Quantity__c= qli.Quantity__c,
                                                                       Price__c=price,
                                                                       currencyisocode = po.currencyisocode,
                                                                       Purchase_Order__c= po.Id,
                                                                       Item_Number__c= qli.Item__r.Name,
                                                                       Item_ID__c= qli.Item__r.Item_ID__c,
                                                                       Item_Description__c= qli.Item__r.Description__c,
                                                                       Oracle_Item_ID__c= qli.Item__c,
                                                                       Oracle_Warehouse__c= ((mapQot.containsKey(po.Quote__c)) ? (mapQot.get(po.Quote__c)).Opportunity.Account.Oracle_Warehouse_Derived__c : '')));
                                }


                             }

                     }//End For
                 }//End If
                 system.debug('**********before insert1*****'+ lstPOL);
                 system.debug('**********leasepaymentcreation9*****'+ lstLP);
                 if(!lstLP.isEmpty() && !Test.isRunningTest())//Creating LeasePayments
                     insert lstLP;
                 if(!lstPOL.isEmpty() && !Test.isRunningTest())//Creating PurchaseOrderLines
                     insert lstPOL;

                }//End For po
            }//End lstPO.isEmpty
        }//End If mapQot.isEmpty
    }
    Public void InitializeQuote(List<ID> lstQID)   //Initialises List & Maps
    {
        if(!lstQId.isEmpty())
        {
            for(AggregateResult agr : [SELECT p.Quote__c qs, Count(p.Id) tot
                                       FROM Purchase_Order__c p
                                       WHERE p.Quote__c IN : lstQId
                                       GROUP BY p.Quote__c])
                mapQSvsPOCount.put((String)agr.get('qs'), (Integer)agr.get('tot'));

            mapQot = new Map<Id, Quote>([SELECT q.NH_Community__c,q.Opportunity.AccountId, q.Opportunity.Account.Name, q.Quote_Steps__c,
                                         q.Opportunity.Account.Oracle_Warehouse_Derived__c, q.Quote_Summary__c,q.Progress_Payment__c,q.Final_payment__c,
                                         q.OpportunityId, q.Opportunity.Account.OwnerId, q.Opportunity.Account.Lease__c,
                                         q.Opportunity.Account.Partner_Account__r.Name, q.Opportunity.Account.Partner_Account__c,
                                         q.Opportunity.Account.Partner_Account__r.Oracle_Vendor_Number__c,
                                         q.Opportunity.Account.Partner_Account__r.Oracle_Vendor_Site_Code__c,
                                         q.Opportunity.Account.Partner_Account__r.Primary_PSR__c,
                                         q.Opportunity.Account.Partner_Account__r.RSM__c,
                                         q.Opportunity.Account.Partner_Account__r.Default_Dealer_warehouse_Shipping_Site__c,
                                         q.Opportunity.Account.Partner_Account__r.NH_SSE_Type__c,
                                         q.Installer__r.Default_Dealer_warehouse_Shipping_Site__c,
                                         q.NH_Community__r.Installer__r.Oracle_Vendor_Number__c,
                                         q.NH_Community__r.Installer__c,q.System_Model__c,
                                         q.NH_Community__r.Installer__r.Oracle_Vendor_Site_Code__c,
                                         q.Id, q.Final_Lease_Number__c, q.Dealer_Fees__c,q.Account_Billing_Country__c,
                                         q.Lease_Doc_Signed__c, q.Is_Locked__c,q.Consolidated_Lease_Number__c, q.Lease_doc_Signed_Date__c,q.System_Price__c,q.System_cost__c,
                                         q.currencyisocode,
                                         q.Opportunity.Account.Country_Domain__c,   //Added : Birlasoft: Check Country Domain
                                         q.Dealer_Fees_Sales_Partner_Total__c,
                                         q.Dealer_Fee_Installation_Partner_Total__c,
                                         q.Installer__c,
                                         q.Installer__r.Name,
                                         q.Installer__r.Oracle_Vendor_Number__c,
                                         q.Installer__r.Oracle_Vendor_Site_Code__c,
                                         q.Spectrum_Partner_Quote__c,
                                         q.Quote_type__c,
                                         q.Create_TPS_PO__c,
                                         q.Total_Dealer_Fee__c,
                                         q.TPS_Fee__c,
                                         q.DRIP_Fee__c,
                                         q.IP_Fee__c,
                                         q.Installation_Model__c,
                                         q.Installation_Model__r.Type__c,
                                         q.Installation_Model__r.partner__c,
                                         q.QuoteType__c,
                                         q.Total_Contract_Price__c,
                                         q.Cost_of_Financing__c,
                                         (SELECT Id, Name, Quote__c,
                                          Item__c,
                                          Item__r.Name,
                                          Item__r.Item_ID__c,
                                          Item__r.Description__c,
                                          Item__r.Not_Shippable__c,
                                          Quantity__c, Unit_Price__c
                                          FROM Quote_Lines__r),
                                         (SELECT Id,Quote__c,echosign_dev1__Status__c,recordtypeid,Proposal_Design_Review_Passed__c
                                          FROM Agreements__r where recordtype.Name='Lease Contract' and echosign_dev1__Status__c='Signed')
                                         FROM Quote q
                                         WHERE id IN : lstQId]);

            if(!mapQot.isEmpty())
            {
                for(Id qId: mapQot.KeySet())
                {
                    //mapQuoteCountry.put(qid,(mapQot.get(qId)).Opportunity.Account.Country_Domain__c); //Added : Birlasoft 15th May 2014
                    lstAcc.add((mapQot.get(qId)).Opportunity.AccountId);
                    //Start of code for case: 00381213
                    lstCustAcc.add((mapQot.get(qId)).Opportunity.AccountId);
                    //End of code for case: 00381213
                    lstAcc.add(mapQot.get(qId).Installer__c);
                    lstAcc.add(mapQot.get(qId).Opportunity.Account.Partner_Account__c);
                    lstQInstaller.add(mapQot.get(qId).Installer__c); //Case 00754398: Oracle setup for order integration for NH Lease PO
                    List<Quote_Line__c> lstQLILoc = (mapQot.get(qId)).Quote_Lines__r;
                    if(!lstQLILoc.isEmpty()) {
                        for(Quote_Line__c qli : lstQLILoc) {
                            lstItemId.add(qli.Item__c);
                        }
                    }
                    // get the account Id for TPS Cash customers
                    Quote q = mapQot.get(qId);
                    if(q.QuoteType__c == 'Cash' && String.isNotBlank(q.Opportunity.Account.Partner_Account__r.NH_SSE_Type__c) && q.Opportunity.Account.Partner_Account__r.NH_SSE_Type__c.contains('TPS')) {
                        tpsCustomerAccountIds.add(q.Opportunity.AccountId);
						tpsCashQuotes.add(q.Id);
                    }
                }
                // get the bill to sites for TPS Cash customers
                for(Bill_to_Site__c bts : [SELECT Id, Dealer_Account__c FROM Bill_to_Site__c WHERE Dealer_Account__c IN : tpsCustomerAccountIds ORDER BY CreatedDate]) {
                    btsTPSCash.put(bts.Dealer_Account__c, bts.Id);
                }

                //Case 00754398: Oracle setup for order integration for NH Lease PO - start
                for(AccountContactRole ac : [SELECT id, AccountId, ContactId FROM AccountContactRole WHERE Role =:SHIPPING_CONTACT AND AccountId IN :lstQInstaller]){
                    mapShipCont.put(ac.AccountId , ac);
                }
                lstAcc.add(Label.TPO_Account_AU);
                if(!lstAcc.isEmpty())//Fetch all related Contacts for Quote's Related Account also Account vs Ship to Site
                {
                    for(Account ac : [SELECT id,(SELECT id, Lastname, primary__c FROM Contacts where primary__c = true ORDER BY CreatedDate DESC) FROM Account WHERE id IN : lstAcc])
                        mapAccvsContacts.put(ac.id, ac.Contacts);
                    for(Ship_to_Site__c sts : [SELECT id, Residential_Customer_Account__c FROM Ship_to_Site__c WHERE Residential_Customer_Account__c IN : lstAcc AND Residential_Customer_Account__c != null AND isDeleted = false])
                    {
                        if(mapAccvsSTSite.containsKey(sts.Residential_Customer_Account__c))
                            mapAccvsSTSite.get(sts.Residential_Customer_Account__c).add(sts.Id);
                        else
                            mapAccvsSTSite.put(sts.Residential_Customer_Account__c, new List<Id>{sts.Id});
                    }
                    for(Bill_To_Site__c bts : [SELECT id, Dealer_Account__c FROM Bill_To_Site__c WHERE Dealer_Account__c IN : lstAcc AND Dealer_Account__c != null AND isDeleted = false])
                    {
                        if(mapAccvsBTSite.containsKey(bts.Dealer_Account__c))
                            mapAccvsBTSite.get(bts.Dealer_Account__c).add(bts.Id);
                        else
                            mapAccvsBTSite.put(bts.Dealer_Account__c, new List<Id>{bts.Id});
                    }
                }

                if(priceListName != null)
                {
                    Price_List__c pl = [SELECT id, DSR_Po_Group_Email__c FROM Price_List__c WHERE name =: priceListName];
                    strDSRPOGroupEmail = (pl != null && pl.Id != null) ? pl.DSR_Po_Group_Email__c : '';
                }

                for(Price_List_Item__c pli:[SELECT p.Price_List__r.System_Size__c,
                                            p.Price_List__r.Promotional_Discount_Item_Id__c,
                                            p.Price_List__r.Service_Credit_SMS_Item_ID__c,
                                            p.Price_List__r.Will_Call_Fee__c,
                                            p.Price_List__r.Shipping_Codes__c,
                                            p.Price_List__r.Expedite_Fee__c,
                                            p.Price_List__r.RecordTypeId,
                                            p.Price_List__r.Name,
                                            p.Price_List__r.Id,
                                            p.Item_ID__r.Item_Category_3__c,
                                            p.Item_ID__r.Item_Category_2__c,
                                            p.Item_ID__r.Item_Category_1__c,
                                            p.Item_ID__r.Product_Type__c,
                                            p.Item_ID__r.Line_Type__c,
                                            p.Item_ID__r.Item_ID__c,
                                            p.Item_ID__r.Description__c,
                                            p.Item_ID__r.Name,
                                            p.Item_ID__r.Id,
                                            p.Item_ID__c,
                                            p.Id,
                                            p.Safe_Harbor_ITEM__c,
                                            p.Disc_Item_ID__c,
                                            p.Quantity_1__c,
                                            p.Pricing_1__c,
                                            p.Effective_Start_Date__c,
                                            p.Effective_End_Date__c,
                                            p.Cost_of_System_Per_Panel__c,
                                            p.Cost_per_Panel_cell_SH__c,
                                            p.Manufacturing_cost__c
                                            FROM Price_List_Item__c p
                                            WHERE p.Price_List__r.Name =: priceListName AND
                                            p.Item_ID__c IN : lstItemId AND
                                            p.Effective_Start_Date__c <=: Date.Today() AND
                                            p.Effective_End_Date__c   >=: Date.Today()])
                {  mapPLI.put(pli.Id,pli);}
                for(Id pliId : mapPLI.keySet()){
                    mapItemVsPL.put( mapPLI.get(pliId).Item_ID__c, mapPLI.get(pliId).Price_List__r.Id);
                    mapItemVsPLI.put( mapPLI.get(pliId).Item_ID__c, mapPLI.get(pliId).Id);
                }

                // load the installation partners
                for(Residential_Project__c rp : [SELECT Id, Quote__c FROM Residential_Project__c WHERE Quote__c IN :tpsCashQuotes]) {
                    for(Alliance_Partner__c ap : [SELECT Partner_Account__r.Default_Dealer_warehouse_Shipping_Site__c FROM Alliance_Partner__c WHERE Residential_Project__c = :rp.Id AND Role__c = 'IP']) {
                        if(String.isNotBlank(ap.Partner_Account__r.Default_Dealer_warehouse_Shipping_Site__c)) {
                            installationPartners.put(rp.Quote__c, ap.Partner_Account__r.Default_Dealer_warehouse_Shipping_Site__c);
                        }
                    }
                }
            }
        }
    }//Initialize Method End

    public void CreateLeaseSchedule(Set<ID> lstQID)
    {
        Map<Id,Quote> quoteMap = new Map<Id, Quote>([select id, Maximum_Rated_Capacity_DC__c, currencyisocode, Spectrum_Partner_Quote__c, (select Guaranteed_Range_of_Annual_Production__c,id, Base__c, High__c, Low__c, Quote__c, Row_Number__c, Annual_SystemProduction_Guarantee_Year__c from Annual_Energy_Production__r order by Row_Number__c asc), (select id, Annual_Base__c, Annual_Fees__c, Annual_Sales_Tax__c, Annual_Termination_Amount__c, Annual_Total__c, Monthly_Base__c, Monthly_Base_Plus_Tax__c, Monthly_Fees__c, Monthly_Sales_Tax__c, Monthly_Total__c, Quote__c, Row_Number__c, Cost_Of_Lease_Per_KWH__c from Annual_Financials__r order by Row_Number__c asc),(SELECT Id, Year__c FROM Lease_Progress__r) from quote where id in : lstQID and Spectrum_Partner_Quote__c = true]);

        List<Lease_Schedule__c > lstLSch = new List<Lease_Schedule__c >();
        Integer count = 0;
        Set<Integer> createdYears =  new Set<Integer>();
        for(Quote qt : quoteMap.values()){
            for(Lease_Schedule__c ls : qt.Lease_Progress__r){
                createdYears.add(ls.Year__c.intValue());
            }
            for(Annual_Financial__c af : qt.Annual_Financials__r)
            {
                if(af.Row_Number__c == null || createdYears.contains(af.Row_Number__c.intValue()))
                    continue;
                Lease_Schedule__c objLS= new Lease_Schedule__c();
                count = Integer.valueof(af.Row_Number__c);
                objLS.Quote__c= af.quote__c;
                objLS.Year__c= af.Row_Number__c;
                objLS.Record_Count__c= af.Row_Number__c;
                objLS.Guarantee_Year__c= 'Year ' + count ;
                objLS.Annual_Lease_Payments_Year__c= String.valueof(count) ;
                objLS.System_Size_DC__c= qt.Maximum_Rated_Capacity_DC__c;
                objLS.Annual_Lease_Payment__c= (af.Annual_Base__c != null ? af.Annual_Base__c : 0.0); //+ (af.Annual_Sales_Tax__c != null ? af.Annual_Sales_Tax__c : 0.0); //+ (af.Annual_Fees__c != null ? af.Annual_Fees__c : 0.0);
                objLS.Base_Monthy_Payment__c= (af.Monthly_Base__c != null ? (af.Monthly_Base__c + 7.5) : 0.0); //+ (af.Monthly_Sales_Tax__c != null ? af.Monthly_Sales_Tax__c : 0.0);
                objLS.Estimated_Tax_on_Monthly_Payment__c= (af.Monthly_Sales_Tax__c != null ? af.Monthly_Sales_Tax__c : 0.0);
                objLS.Rate_Per_KWH__c= (af.Cost_Of_Lease_Per_KWH__c != null ? af.Cost_Of_Lease_Per_KWH__c : null);
                objLS.Cost_of_Lease_Per_kWh__c= (af.Cost_Of_Lease_Per_KWH__c != null ? af.Cost_Of_Lease_Per_KWH__c : null);
                objLS.Remaining_Lease_Value__c= (af.Annual_Termination_Amount__c != null ? af.Annual_Termination_Amount__c : 0.0);
                objLS.System_Production_Annual_Production__c= (qt.Annual_Energy_Production__r != null && qt.Annual_Energy_Production__r[count-1] != null && qt.Annual_Energy_Production__r[count-1].Base__c != null ? qt.Annual_Energy_Production__r[count-1].Base__c : 0.0);
                objLS.Guaranteed_Range_of_Annual_Production__c= (qt.Annual_Energy_Production__r != null && qt.Annual_Energy_Production__r[count-1] != null && qt.Annual_Energy_Production__r[count-1].Guaranteed_Range_of_Annual_Production__c != null ? qt.Annual_Energy_Production__r[count-1].Guaranteed_Range_of_Annual_Production__c : '');
                objLS.Monthly_Lease_Payment__c = (af.Monthly_Base_Plus_Tax__c == null ? 0.0 : (af.Monthly_Base_Plus_Tax__c)) + (af.Monthly_Fees__c == null ? 0.0 : af.Monthly_Fees__c);
                objLS.X105_of_S_P_A_P_1__c = (qt.Annual_Energy_Production__r != null && qt.Annual_Energy_Production__r[count-1] != null && qt.Annual_Energy_Production__r[count-1].High__c != null ? qt.Annual_Energy_Production__r[count-1].High__c.intValue() : 0.0);
                objLS.Estimated_Monthly_Payment_inclusive_of_T__c = (af.Monthly_Base__c == null ? 0.0 : (af.Monthly_Base__c)) + (af.Monthly_Fees__c == null ? 0.0 : af.Monthly_Fees__c);
                objLS.X95_of_S_P_A_P_1__c = (qt.Annual_Energy_Production__r != null && qt.Annual_Energy_Production__r[count-1] != null && qt.Annual_Energy_Production__r[count-1].Low__c != null ? qt.Annual_Energy_Production__r[count-1].Low__c.intValue() : 0.0);
                objLS.Est_Mthly_Paymt_includingTax_w_auto_ACH__c = (af.Monthly_Base__c == null ? 0.0 : (af.Monthly_Base__c));
                //        objLS.Approximate_Price_per_kWh__c= (annualEnergyMap.get(af.quote__c).AnnualPayBackRatePerKWH != null ? annualEnergyMap.get(af.quote__c).AnnualPayBackRatePerKWH : null);

                System.debug(LoggingLevel.error,'count : ' + count);
                System.debug(LoggingLevel.error,'qt.Annual_Energy_Production__r[count-1] : ' + qt.Annual_Energy_Production__r[count-1]);

                objLS.PeGu_Estimate__c=  (qt.Annual_Energy_Production__r != null && qt.Annual_Energy_Production__r[count-1] != null && qt.Annual_Energy_Production__r[count-1].Low__c != null ? qt.Annual_Energy_Production__r[count-1].Low__c : 0.0) + ' - ' + (qt.Annual_Energy_Production__r != null && qt.Annual_Energy_Production__r[count-1 ] != null && qt.Annual_Energy_Production__r[count-1].High__c != null ? qt.Annual_Energy_Production__r[count-1].High__c : 0.0);

                objLS.Annual_SystemProduction_Guarantee_Year__c =  qt.Annual_Energy_Production__r != null && qt.Annual_Energy_Production__r[count-1] != null && qt.Annual_Energy_Production__r[count-1].Annual_SystemProduction_Guarantee_Year__c != null ? qt.Annual_Energy_Production__r[count-1].Annual_SystemProduction_Guarantee_Year__c : null;

                objLS.currencyisocode = qt.currencyisocode;
                lstLSch.add(objLS);
            }
        }

        insert lstLSch;
    }
}//Util Class End