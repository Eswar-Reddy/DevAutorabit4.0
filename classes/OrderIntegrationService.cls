global without sharing class OrderIntegrationService {
    
    global static Map<Id,RecordType> rt = new Map<Id,RecordType>([select id,name from RecordType where sObjectType = 'Account']);   
    global static String toFakeId = Datetime.now().format('MMddyyyyHHmmssSS'); // Case 00754398
    
    global class OrderList {
        
        Webservice List<Order> orders {get; set;}
        
        // Case 00754398: added parameter for Installer Contact Mapping
        public OrderList(List<Purchase_Order__c> allNonSynPOs, Map<Id, List<Schema.Contact>> accountContactMap, Map<Id, List<Bill_To_Site__c>> accountBillToMap, Map<Id, List<Ship_To_Site__c>> accountShipToMap, Map<Id,Id> InstallerContactMap, Map<Id, Ship_To_Site__c> tpsCashSTS){
            
            this.orders = new List<Order>();
            
            for(Purchase_Order__c PO :allNonSynPOs){
                this.orders.add(new Order(po, accountContactMap, accountBillToMap, accountShipToMap, InstallerContactMap, tpsCashSTS));
            }                
        }
        
    }
    
    global class Order {
        
        Webservice OrderHeader orderHeader {get; set;} 
        Webservice AccountList accountList {get; set;}
        
        public Order(Purchase_Order__c PO, Map<Id, List<schema.Contact>> accountContactMap, Map<Id, List<Bill_To_Site__c>> accountBillToMap, Map<Id, List<Ship_To_Site__c>> accountShipToMap, Map<Id,Id> InstallerContactMap, Map<Id, Ship_To_Site__c> tpsCashSTS){
            
            this.orderHeader = new OrderHeader(PO, accountBillToMap, InstallerContactMap);           
            
            this.accountList = new AccountList(PO, accountContactMap, accountBillToMap, accountShipToMap, tpsCashSTS);
            
        }
    }
    
    global class OrderHeader {
        
        //All Purchase Order Variables
        Webservice string OrderId {get; set;}
        Webservice String OrderStatus {get; set;}
        Webservice String PONumber {get; set;}
        Webservice String PrimaryPSREmail {get; set;}
        Webservice String OracleOrderNumber {get; set;} 
        Webservice String ShipToSiteID {get; set;}
        Webservice String BillToSiteID {get; set;}
        Webservice String ShipToContactID {get; set;}
        Webservice String BillToContactID {get; set;}
        Webservice String HomeownerId {get; set;}    
        Webservice String PartnerId {get; set;}       
        Webservice String ThirdPartyOwnerId {get; set;}
        Webservice String ShippingMethod {get; set;}
        Webservice String SpecialInstructions {get; set;}
        Webservice String IsTaxibleOrder {get; set;}
        Webservice String CurrencyISOCode {get; set;}
        Webservice Date RequestedDeliveryDate {get; set;}
        Webservice String DeliveryCharges {get; set;}
        Webservice String IsSmartPack {get; set;}              
        Webservice String SmartPackMountingType {get; set;}
        Webservice String SmartPackInverterType {get; set;}        
        Webservice String OracleVendorNumber {get; set;}
        Webservice String OracleVendorSiteCode {get; set;}
        Webservice String LeaseNumber {get; set;}
        //Webservice String FinancierName {get; set;}
        Webservice DateTime LastModifiedDate {get; set;}
        Webservice String LastUpdatedBy {get; set;}
        Webservice String SalesType {get; set;}
        webservice String ChannelType {get; set;}
        Webservice String PaymentType {get; set;}
        Webservice String TransactionStatus {get; set;}
        Webservice String TaxIdentifier {get; set;}
        Webservice String OkToShip {get;set;}//Ok To Ship
        Webservice Decimal NumberOfSystems{get;set;}//sangita added for cash redesign
        Webservice String RackingOptOut{get;set;}//sangita added for cash redesign
        Webservice String MonitoringOptOut{get;set;}//sangita added for cash redesign
        //All Purchase order variable ends
        
        Webservice List<OrderLineList> allLineItem {get; set;}        
        
        // Case 00754398: added parameter for Installer Contact Mapping
        public OrderHeader(Purchase_Order__c PO, Map<Id, List<Bill_To_Site__c>> accountBillToMap, Map<Id,Id> InstallerContactMap){
            this.OrderId = PO.id;
            this.OrderStatus = PO.Order_Status__c;
            this.PONumber = PO.Name;
            this.PrimaryPSREmail = PO.Primary_PSR_Email__c;
            this.OracleOrderNumber = PO.Oracle_Order_Number__c;           
            this.ShipToSiteID = PO.Ship_to_Site__c; 
            
            if(PO.TPO_Account__c != null){
                //this.BillToSiteID = PO.Bill_to_Site__c;
                if(accountBillToMap.get(PO.TPO_Account__c).size() > 0)
                    this.BillToSiteID = accountBillToMap.get(PO.TPO_Account__c).get(0).id;
            }
            else{
                this.BillToSiteID = PO.Bill_to_Site__c;
            }
            //Case 00754398: set installer contact with fake id as shipping contact for NH
            if(PO.Sales_Type__c=='NH Lease') 
                this.ShipToContactID = InstallerContactMap.get(PO.Installer__c) == null ? '': InstallerContactMap.get(PO.Installer__c) + toFakeId; //fake id; 
            else
            this.ShipToContactID = PO.Ship_To_Contact__c;
            this.BillToContactID = PO.Bill_To_Contact__c;
            this.HomeownerId = PO.End_Customer_Account__c;
            if(PO.Dealer_Account__r.Billingcountry != 'Australia')
                this.PartnerId = PO.Dealer_Account__c;
            else
                this.PartnerId = PO.Installer__c;                       
            this.ThirdPartyOwnerId = PO.TPO_Account__c;
            this.ShippingMethod = PO.Shipping_Method__c;
            this.SpecialInstructions = PO.Special_Instructions__c;
            this.IsTaxibleOrder = String.valueOf(PO.Is_Taxible_Order__c);
            this.CurrencyISOCode = PO.CurrencyIsoCode;
            this.RequestedDeliveryDate = PO.Requested_Delivery_Date__c;
            this.DeliveryCharges = PO.Delivery_Charges__c != null ? String.valueOf(PO.Delivery_Charges__c) : '';
            this.IsSmartPack = PO.SmartPack_Flag__c;
            this.SmartPackMountingType = PO.SmartPack_Mounting_Type__c;
            this.SmartPackInverterType = PO.SmartPack_Inverter_Type__c; 
            this.OracleVendorNumber = PO.Oracle_Vendor_Number__c;
            this.OracleVendorSiteCode = PO.Oracle_Vendor_Site_Code__c;
            this.LeaseNumber = PO.Lease_Number__c;
            //            this.FinancierName = PO.Financier__c;
            this.LastModifiedDate = PO.LastModifiedDate;
            this.LastUpdatedBy = PO.LastModifiedById;

            if(PO.Sales_Type__c != 'Third Party Owner' && PO.Sales_Type__c != 'Lease' && PO.Sales_Type__c != 'NH Lease' && PO.sales_type__c != 'Loan'){
                if(PO.Sales_Type__c == 'Cash' && String.isNotBlank(PO.Dealer_Account__r.NH_SSE_Type__c) && PO.Dealer_Account__r.NH_SSE_Type__c.contains('TPS')){
                    PO.Sales_Type__c = 'SPD';
                }
                else{
                    PO.Sales_Type__c = 'Purchase';
                }
            }
            this.SalesType = PO.Sales_Type__c;
			
            if (PO.Dealer_Account__r.Name.contains('SunPower')||PO.Dealer_Account__r.Name.contains('SPD')||PO.Dealer_Account__r.Name.contains('SPWR')){
                this.channeltype='SPD';
            }
            else{
                if(String.isNotBlank(PO.Dealer_Account__r.NH_SSE_Type__c) && PO.Dealer_Account__r.NH_SSE_Type__c.contains('TPS')){
                    this.ChannelType = 'RVAR';
                }
                else{
                  this.ChannelType = 'Residential';
                }
            }
            
            this.PaymentType = PO.Payment_Type__c;
            this.TransactionStatus = 'CREATE';//create or update
            this.TaxIdentifier = PO.Tax_Identifier__c != null && PO.Tax_Identifier__c != '' ? String.valueOf(PO.Tax_Identifier__c) : '';
            this.allLineItem = new List<OrderLineList>();
            this.OkToShip = PO.Ok_To_Ship__c;//Ok To Ship
            this.NumberOfSystems = PO.number_of_systems__c;//sangita added for cash redesign
            this.RackingOptOut= PO.Racking_Opt_Out__c?'Y':'N';//sangita added for cash redesign //updated monitoring and racking logic 5/31
            this.MonitoringOptOut = PO.Monitoring_Opt_Out__c ? 'Y' : 'N';
            
            for(Purchase_Order_Line__c POItem : PO.Purchase_Order_Lines__r){
                this.allLineItem.add(new OrderLineList(POItem));
            }
            
        }
        
    }
    
    global class OrderLineList {
        Webservice String OrderId {get; set;}
        Webservice String OrderLineId {get; set;}
        Webservice String OrderLineNumber {get; set;}
        Webservice String ItemID {get; set;}
        Webservice String Quantity {get; set;}
        Webservice String UnitPrice {get; set;}
        Webservice String OracleLineType {get; set;}
        Webservice String SmartPackItem {get; set;}
        Webservice String ItemType {get; set;}
        Webservice Date RequestedDeliveryDate {get; set;}
        Webservice DateTime LastModifiedDate {get; set;}
        Webservice String LastUpdatedBy {get; set;}
        Webservice String OracleVendorNumber {get; set;}
        Webservice String OracleVendorSiteCode {get; set;}
        Webservice String VendorRole {get; set;}        
        
        public OrderLineList(Purchase_Order_Line__c POItem){
            this.OrderId = POItem.Purchase_Order__c;
            this.OrderLineId = POItem.id;
            this.OrderLineNumber = POItem.Order_Line_Number__c != null ? POItem.Order_Line_Number__c : '';
            this.ItemID = POItem.Oracle_Item_ID__r.Name != null ? POItem.Oracle_Item_ID__r.Name : '';
            this.Quantity = POItem.Quantity__c != null ? String.valueOf(POItem.Quantity__c) : '';
            this.UnitPrice = POItem.Unit_Price__c != null ? String.valueOf(POItem.Unit_Price__c) : '';
            this.OracleLineType = POItem.Oracle_Line_Type__c != null ? POItem.Oracle_Line_Type__c : '';
            this.SmartPackItem = String.valueOf(POItem.SmartPack_Item__c);
            this.ItemType = POItem.Item_Type__c != null ? POItem.Item_Type__c : '';
            this.RequestedDeliveryDate = POItem.Requested_Delivery_Date__c;
            this.LastModifiedDate = POItem.LastModifiedDate;
            this.LastUpdatedBy = POItem.LastModifiedById;
            this.OracleVendorNumber = POItem.Vendor_Name__r.Oracle_Vendor_Number__c;
            this.OracleVendorSiteCode = POItem.Vendor_Name__r.Oracle_Vendor_Site_Code__c;
            this.VendorRole=POItem.Partner_Role__c;
        }
    }
    
    global class AccountList {
        
        //        Webservice Account account {get; set;}
        Webservice List<Account> account {get; set;}
        //        Webservice ContactList contactList {get; set;}
        
        public AccountList(Purchase_Order__c PO, Map<Id, List<Schema.Contact>> accountContactMap, Map<Id, List<Bill_To_Site__c>> accountBillToMap, Map<Id, List<Ship_To_Site__c>> accountShipToMap, Map<Id, Ship_To_Site__c> tpsCashSTS){
            this.account = new List<Account>();

            if(PO.Dealer_Account__c != null && PO.Dealer_Account__r.Billingcountry != 'Australia')
                this.account.add(new Account(PO, PO.Dealer_Account__r, accountBillToMap.get(PO.Dealer_Account__c), accountShipToMap.get(PO.Dealer_Account__c),accountContactMap.get(PO.Dealer_Account__c), '', tpsCashSTS));
            if(PO.End_Customer_Account__c != null)
                this.account.add(new Account(PO, PO.End_Customer_Account__r, accountBillToMap.get(PO.End_Customer_Account__c), accountShipToMap.get(PO.End_Customer_Account__c),accountContactMap.get(PO.End_Customer_Account__c), PO.Sales_Type__c, tpsCashSTS ));
            if(PO.TPO_Account__c != null)
                this.account.add(new Account(PO, PO.TPO_Account__r, accountBillToMap.get(PO.TPO_Account__c), accountShipToMap.get(PO.TPO_Account__c),accountContactMap.get(PO.TPO_Account__c), '', tpsCashSTS));
            // Don't add the Installer Partner for New Homes Lease to avoid Duplicate Installer Partner accounts during Order submission
            if(PO.Installer__c != null && PO.Sales_Type__c != 'NH Lease')
                this.account.add(new Account(PO, PO.Installer__r, accountBillToMap.get(PO.Installer__c), accountShipToMap.get(PO.Installer__c),accountContactMap.get(PO.Installer__c), '', tpsCashSTS));

        }
    }
    
    global class Account {
        Webservice AccountHeader accountHeader {get; set;} 
        Webservice SiteList SiteList {get; set;} 
        Webservice contactList contactList {get; set;}
        
        public Account(Purchase_Order__c PO, Schema.Account acct, List<Bill_To_Site__c> billToSiteListPara, List<Ship_To_Site__c> shipToSiteListPara,List<Schema.Contact> contactsListPara, String Type, Map<Id, Ship_To_Site__c> tpsCashSTS)
        {
            System.debug('billToSiteListPara :' + billToSiteListPara);
            System.debug('shipToSiteListPara :' + shipToSiteListPara);
            this.accountHeader = new AccountHeader(PO,acct);
            this.SiteList = new SiteList(PO, billToSiteListPara,shipToSiteListPara,acct, tpsCashSTS);
            this.contactList = new contactList(contactsListPara, PO, Type); // Case 00754398: pass PO
        }
    }
    
    global class AccountHeader
    {
        
        Webservice String AccountId {get; set;}
        Webservice String OracleAccountNumber {get; set;}
        Webservice String Name {get; set;}
        Webservice String AccountType {get; set;}
        Webservice String IsActive {get; set;}
        Webservice String LastUpdatedBy {get; set;}
        Webservice DateTime LastModifiedDate {get; set;}
        Webservice String TransactionStatus {get; set;}
        
        
        public AccountHeader(Purchase_Order__c PO, Schema.Account acc){
            this.AccountId = acc != null ? acc.id : '';
            this.OracleAccountNumber = (acc != null && acc.Oracle_Account_Number__c != null )? String.valueOf(acc.Oracle_Account_Number__c) : '';
            this.Name = acc != null ? acc.Name : '';
            
            if(rt.get(acc.recordtypeid).name == 'Residential Customer' || rt.get(acc.recordtypeid).name == 'FR Residential Customer')
                this.AccountType = 'Home Owner';
            else if(rt.get(acc.recordtypeid).name == 'Partner' && acc.type == 'Third Party Owner') //Need to COnfirm this.
                this.AccountType = 'Third Party Owner';                    
            else if(rt.get(acc.recordtypeid).name == 'Partner')
                this.AccountType = 'Partner';
            
            
            this.IsActive = (acc != null && (acc.Status__c == 'Active' || acc.Status__c == null || acc.Status__c =='') ? 'True' : 'False');
            this.LastUpdatedBy = acc != null ? acc.LastModifiedById : '';
            this.LastModifiedDate = acc != null ? acc.LastModifiedDate : null;
            if(this.OracleAccountNumber != '')
                this.TransactionStatus = 'UPDATE';//hard coded
            else
                this.TransactionStatus = 'CREATE';//hard coded
            
        }
    }
    
    global class SiteList {
        
        Webservice List<Site> Sites {get; set;}
        
        public SiteList(Purchase_Order__c PO, List<Bill_To_Site__c> billToSiteList,List<Ship_To_Site__c> shipToSiteList, Schema.Account acc, Map<Id, Ship_To_Site__c> tpsCashSTS){
            this.Sites = new List<Site>();
            
            System.debug('billToSiteList :' + billToSiteList);
            System.debug('shipToSiteList :' + shipToSiteList);
            
            for(Bill_To_Site__c billToSiteV : billToSiteList)
            {
                //Added this condition so that if there are multiple orders with different bill to for the same account , we need to consider only the one which is on that particular purchase order or if it is a new customer acct
                if(rt.get(acc.recordtypeid).name == 'Residential Customer' || rt.get(acc.recordtypeid).name == 'FR Residential Customer' || PO.Bill_to_Site__c == billToSiteV.id || (rt.get(acc.recordtypeid).name == 'Partner' && acc.type == 'Third Party Owner')){
                    this.Sites.add(new Site(billToSiteV, null, acc, PO));
                    break;
                }
            }
            for(Ship_To_Site__c shipToSiteV : shipToSiteList)
            {
                //Added this condition so that if there are multiple orders with different Ship to for the same account , we need to consider only the one which is on that particular purchase order or if it is a new customer acct
                if(rt.get(acc.recordtypeid).name == 'Residential Customer' || rt.get(acc.recordtypeid).name == 'FR Residential Customer' || PO.Ship_To_Site__c == shipToSiteV.id){
                    if(PO.Sales_Type__c == 'SPD' && String.isNotBlank(PO.Dealer_Account__r.NH_SSE_Type__c) && PO.Dealer_Account__r.NH_SSE_Type__c.contains('TPS')) {
                        this.Sites.add(new Site(null, tpsCashSTS.get(PO.Ship_To_Site__c), acc, PO));
                        break;
                    } else {
                        this.Sites.add(new Site(null, shipToSiteV, acc, PO));
                        break;
                    }
                }
            }
        }
    }
    
    global class Site {        
        Webservice String SiteType {get; set;}
        Webservice String SiteId {get; set;}
        Webservice String SiteAccountId {get; set;}
        Webservice String OracleSiteId {get; set;}
        //Webservice String SiteStatus {get; set;}
        Webservice String OracleAccountNumber {get; set;}
        Webservice String Address1 {get; set;} 
        Webservice String Address2 {get; set;}
        Webservice String Address3 {get; set;}
        Webservice String City {get; set;}
        Webservice String Province {get; set;}
        Webservice String County {get; set;}
        Webservice String State {get; set;}
        Webservice String Postalcode {get; set;}
        Webservice String Country {get; set;}
        Webservice String IsActive {get; set;}
        Webservice String LastUpdatedBy {get; set;}
        Webservice DateTime LastModifiedDate {get; set;}       
        Webservice String IsPrimary {get; set;}
        Webservice String TransactionStatus {get; set;}
        
        public Site(Bill_To_Site__c billtSite, Ship_To_Site__c shiptSite, Schema.Account acc, Purchase_Order__c PO){
            Sobject obj;
            
            System.debug('billtSite is : ' + billtSite);
            System.debug('shiptSite is : ' + shiptSite);
            if(billtSite != null)
            {
                obj = (Bill_To_Site__c) billtSite;
                this.SiteType = 'BILL_TO';
                this.OracleSiteId = String.Valueof(obj.get('Site_ID__c')) != null ? String.Valueof(obj.get('Site_ID__c')) : '';
                this.IsActive  = String.valueOf(obj.get('Active__c')) != null ? String.Valueof(obj.get('Active__c')) : '';
            }
            else if(shiptSite != null)
            {
                obj = (Ship_To_Site__c) shiptSite;
                this.SiteType = 'SHIP_TO';
                if(PO.Sales_Type__c == 'SPD' && String.isNotBlank(PO.Dealer_Account__r.NH_SSE_Type__c) && PO.Dealer_Account__r.NH_SSE_Type__c.contains('TPS')) {
                    this.OracleSiteId = '';
                } else {
                    this.OracleSiteId = String.Valueof(obj.get('siteid__c')) != null ? String.Valueof(obj.get('siteid__c')) : '';
                }
                this.IsActive  = String.Valueof(obj.get('Status__c')) != null && String.Valueof(obj.get('Status__c')) != '' ? String.Valueof(obj.get('Status__c')) : 'Active';
                
            }
            this.OracleAccountNumber =  acc.Oracle_Account_Number__c != null ? acc.Oracle_Account_Number__c  : '';
            this.SiteId = String.Valueof(obj.get('ID'));
            this.SiteAccountId = acc.id;
            
            this.Address1 = String.Valueof(obj.get('Address1__c')) != null ? String.Valueof(obj.get('Address1__c')) : '';
            this.Address2 = String.Valueof(obj.get('Address2__c')) != null ? String.Valueof(obj.get('Address2__c')) : '';
            this.Address3 = String.Valueof(obj.get('Address3__c')) != null ? String.Valueof(obj.get('Address3__c')) : '';            
            this.City = String.Valueof(obj.get('City__c')) != null ? String.Valueof(obj.get('City__c')) : '';
            this.Province = String.Valueof(obj.get('State__c')) != null ? String.Valueof(obj.get('State__c')) : '';
            this.County = String.Valueof(obj.get('Oracle_County__c')) != null ? String.Valueof(obj.get('Oracle_County__c')) : '';
            this.State = String.Valueof(obj.get('State__c')) != null ? String.Valueof(obj.get('State__c')) : '';
            this.PostalCode = String.Valueof(obj.get('Zip__c')) != null ? String.Valueof(obj.get('Zip__c')) : '';
            this.Country = String.Valueof(obj.get('Country__c')) != null ? String.Valueof(obj.get('Country__c')) : '';
            this.LastUpdatedBy = String.Valueof(obj.get('LastModifiedById')) != null ? String.Valueof(obj.get('LastModifiedById')) : '';
            this.LastModifiedDate = DateTime.Valueof(obj.get('LastModifiedDate'));
            this.IsPrimary = String.Valueof(obj.get('Oracle_Primary__c')) != null ? String.Valueof(obj.get('Oracle_Primary__c')) : ''; 
            If(this.OracleSiteId != '')
                this.TransactionStatus = 'UPDATE';//hard coded
            else
                this.TransactionStatus = 'CREATE';
        }
    }
    
    global class ContactList {
        
        Webservice List<Contact> contact {get; set;}
        
        public ContactList(List<Schema.Contact> contcts, Purchase_Order__c PO, String Type){
            
            this.contact = new List<Contact>();
            
            for(Schema.Contact c : contcts)
                this.Contact.add(new Contact(c, PO, Type)); // Case 00754398: pass PO
        }
    }
    
    global class Contact{
        
        Webservice String ContactId {get; set;}
        Webservice String OracleContactId {get; set;}
        Webservice String AccountId {get; set;}
        Webservice String OracleAccountNumber {get; set;}
        Webservice String LastName {get; set;}
        Webservice String FirstName {get; set;}
        Webservice String MobileNumber {get; set;}
        Webservice String PhoneNumber {get; set;}
        Webservice String FaxNumber {get; set;}
        Webservice String EmailAddress {get; set;}
        Webservice String IsActive {get; set;}
        Webservice String LastUpdatedBy {get; set;}
        Webservice DateTime LastModifiedDate {get; set;}
        Webservice String IsPrimary {get; set;}
        Webservice String TransactionStatus {get; set;}
        
        // Case 00754398: added PO as param; add data process for NH only
        public Contact(Schema.Contact c, Purchase_Order__c PO, String Type){
            if(PO.sales_type__c == 'NH Lease' && c.AccountId == PO.Installer__c && Type == 'NH Lease'){
                this.ContactId = c.Id + toFakeId; //fake id
                this.AccountId = PO.End_Customer_Account__c ; //homeowner id
                this.OracleAccountNumber = PO.End_Customer_Account__r.Oracle_Account_Number__c; //should be changed to homeowner account number
                this.OracleContactId = ''; //should be blank to pass oracle validation
            }            
            else{
            this.ContactId = c.Id;
            this.AccountId = c.AccountId != null ? c.AccountId : '';
            this.OracleAccountNumber = c.AccountId != null && c.Account.Oracle_Account_Number__c != null ? c.Account.Oracle_Account_Number__c : '';
                this.OracleContactId = c.Oracle_Contact_id__c != null ? c.Oracle_Contact_id__c : '';                
            }
            this.LastName = c.LastName != null ? c.LastName : '';
            this.FirstName = c.FirstName != null ? c.FirstName : '';
            this.MobileNumber = c.MobilePhone != null ? String.valueOf(c.MobilePhone) : '';
            this.PhoneNumber = c.Phone != null ? String.valueOf(c.Phone) : '';
            this.FaxNumber = c.Fax != null ? String.valueOf(c.Fax) : '';
            this.EmailAddress = c.Email != null ? c.Email : '';
            //            this.IsActive = c.Contact_Status__c != null ? c.Contact_Status__c : '';
            this.IsActive = (c.Contact_Status__c != null && c.Contact_Status__c != '') ? c.Contact_Status__c : 'Active';
            this.LastUpdatedBy = c.LastModifiedById;
            this.LastModifiedDate = c.LastModifiedDate;  
            this.IsPrimary = String.valueOf(c.Primary__c);            
            if(this.OracleContactId != '')
                this.TransactionStatus = 'UPDATE';//hard coded
            else
                this.TransactionStatus = 'CREATE';//hard coded
            
        }
    }
    
    webservice static OrderList GetNewOrders(){
        //public static OrderList GetNewOrders(){
        
        List<Purchase_Order__c> allNonSynPOs = new List<Purchase_Order__c>([Select Id, Primary_PSR_Email__c, Name, Dealer_Fees__c, Shipping_Method__c, 
                                                                            Special_Instructions__c, Is_Taxible_Order__c, CurrencyIsoCode, Requested_Delivery_Date__c, 
                                                                            Delivery_Charges__c, SmartPack_Flag__c, Oracle_Order_Number__c, Order_Status__c, 
                                                                            SmartPack_Mounting_Type__c, SmartPack_Inverter_Type__c, Oracle_Order_Type__c,  
                                                                            Oracle_Operating_Unit__c, Oracle_Vendor_Number__c, Oracle_Vendor_Site_Code__c, 
                                                                            Effective_Price_of_Goods__c, Lease__c, Lease_Number__c, Financier__c, 
                                                                            LastModifiedById, LastModifiedDate, Tax_Identifier__c, Quote__c, Total_Lease_Value__c,
                                                                            Installer__c, Quote__r.Installer__c, Bill_to_Site__r.Oracle_Location_id__c, 
                                                                            Bill_to_Site__r.Id, Bill_to_Site__r.Address1__c, Bill_to_Site__r.Address2__c, 
                                                                            Bill_to_Site__r.Address3__c, Bill_to_Site__r.City__c, Bill_to_Site__r.State__c, 
                                                                            Bill_to_Site__r.Zip__c, Bill_to_Site__r.Country__c, Bill_to_Site__r.Active__c, 
                                                                            Bill_to_Site__r.Dealer_Account__r.Oracle_Operating_Unit__c, Bill_to_Site__r.Oracle_Salesperson__c, 
                                                                            Bill_to_Site__r.Oracle_Price_List__c, Bill_to_Site__r.Oracle_Primary__c, 
                                                                            Bill_to_Site__r.Dealer_Account__r.Oracle_Order_Type__c, Bill_to_Site__r.LastModifiedById, 
                                                                            Bill_to_Site__r.LastModifiedDate, Bill_to_Site__r.Dealer_Account__r.Oracle_Account_Number__c,
                                                                            Bill_to_Site__r.Site_ID__c, Bill_to_Site__r.Oracle_County__c, Bill_to_Site__r.Interface_Status__c, 
                                                                            Ship_to_Site__r.Oracle_Location_id__c, Ship_to_Site__r.Id, Ship_to_Site__r.Address1__c, 
                                                                            Ship_to_Site__r.Address2__c, Ship_to_Site__r.Address3__c, Ship_to_Site__r.City__c, 
                                                                            Ship_to_Site__r.State__c, Ship_to_Site__r.Zip__c, Ship_to_Site__r.Country__c, Ship_to_Site__r.Status__c,
                                                                            Ship_to_Site__r.Dealer_Account__r.Oracle_Operating_Unit__c, Ship_to_Site__r.Oracle_Salesperson__c, 
                                                                            Ship_to_Site__r.Oracle_Primary__c, Ship_to_Site__r.Dealer_Account__r.Oracle_Order_Type__c, 
                                                                            Ship_to_Site__r.LastModifiedById, Ship_to_Site__r.LastModifiedDate, Ship_to_Site__r.Oracle_County__c, 
                                                                            Ship_to_Site__r.Dealer_Account__r.Oracle_Account_Number__c, Ship_to_Site__r.Contact_Phone__c, 
                                                                            Ship_to_Site__r.Contact_Name__c, Ship_to_Site__r.Contact_Email__c, Ship_to_Site__r.SiteID__c,
                                                                            Ship_to_Site__r.Residential_Customer_Account__c,Ship_to_Site__r.Interface_Status__c,  
                                                                            Dealer_Account__r.Oracle_Account_Number__c, Dealer_Account__r.Name, Dealer_Account__r.Oracle_Operating_Unit__c, 
                                                                            Dealer_Account__r.Oracle_Customer_Classification__c, Dealer_Account__r.Oracle_Account_Type__c, 
                                                                            Dealer_Account__r.Oracle_Sales_Channel__c, Dealer_Account__r.Oracle_Related_Account__c, 
                                                                            Dealer_Account__r.Oracle_Related_Account_Reciprocal__c, Dealer_Account__r.Oracle_Related_Account_Bill_to__c, 
                                                                            Dealer_Account__r.Oracle_Related_Account_Shipto__c, Dealer_Account__r.Oracle_Payment_Terms__c, 
                                                                            Dealer_Account__r.Oracle_Warehouse_Derived__c, Dealer_Account__r.LastModifiedById, Dealer_Account__r.LastModifiedDate, 
                                                                            Dealer_Account__r.Credit_Hold__c, Dealer_Account__r.Credit_Limit__c, Dealer_Account__r.CurrencyIsoCode, 
                                                                            Dealer_Account__r.Status__c, Dealer_Account__r.Interface_Status__c, Dealer_Account__r.RecordTypeId, 
                                                                            Dealer_Account__r.Type, Dealer_Account__r.BillingCountry, Dealer_Account__r.NH_SSE_Type__c,
                                                                            Installer__r.Oracle_Account_Number__c, Installer__r.Name, Installer__r.Oracle_Operating_Unit__c, 
                                                                            Installer__r.Oracle_Customer_Classification__c, Installer__r.Oracle_Account_Type__c, 
                                                                            Installer__r.Oracle_Sales_Channel__c, Installer__r.Oracle_Related_Account__c, 
                                                                            Installer__r.Oracle_Related_Account_Reciprocal__c, Installer__r.Oracle_Related_Account_Bill_to__c, 
                                                                            Installer__r.Oracle_Related_Account_Shipto__c, Installer__r.Oracle_Payment_Terms__c, 
                                                                            Installer__r.Oracle_Warehouse_Derived__c, Installer__r.LastModifiedById, Installer__r.LastModifiedDate, 
                                                                            Installer__r.Credit_Hold__c, Installer__r.Credit_Limit__c, Installer__r.CurrencyIsoCode, 
                                                                            installer__r.Status__c, installer__r.Interface_Status__c, Installer__r.RecordTypeId, 
                                                                            Installer__r.Type, installer__r.BillingCountry, End_Customer_Account__r.Oracle_Account_Number__c, 
                                                                            End_Customer_Account__r.Name, End_Customer_Account__r.Oracle_Operating_Unit__c, 
                                                                            End_Customer_Account__r.Oracle_Customer_Classification__c, End_Customer_Account__r.Oracle_Account_Type__c, 
                                                                            End_Customer_Account__r.Oracle_Sales_Channel__c, End_Customer_Account__r.Oracle_Related_Account__c, 
                                                                            End_Customer_Account__r.Oracle_Related_Account_Reciprocal__c, End_Customer_Account__r.Oracle_Related_Account_Bill_to__c, 
                                                                            End_Customer_Account__r.Oracle_Related_Account_Shipto__c, End_Customer_Account__r.Oracle_Payment_Terms__c, 
                                                                            End_Customer_Account__r.Oracle_Warehouse_Derived__c, End_Customer_Account__r.LastModifiedById, 
                                                                            End_Customer_Account__r.LastModifiedDate, End_Customer_Account__r.Credit_Hold__c, End_Customer_Account__r.Credit_Limit__c, 
                                                                            End_Customer_Account__r.CurrencyIsoCode, End_Customer_Account__r.Status__c, End_Customer_Account__r.Interface_Status__c,  
                                                                            End_Customer_Account__r.RecordTypeId, End_Customer_Account__r.Type,  
                                                                            TPO_Account__r.Oracle_Account_Number__c, TPO_Account__r.Name, TPO_Account__r.Oracle_Operating_Unit__c, 
                                                                            TPO_Account__r.Oracle_Customer_Classification__c, TPO_Account__r.Oracle_Account_Type__c, 
                                                                            TPO_Account__r.Oracle_Sales_Channel__c, TPO_Account__r.Oracle_Related_Account__c, 
                                                                            TPO_Account__r.Oracle_Related_Account_Reciprocal__c, TPO_Account__r.Oracle_Related_Account_Bill_to__c, 
                                                                            TPO_Account__r.Oracle_Related_Account_Shipto__c, TPO_Account__r.Oracle_Payment_Terms__c, 
                                                                            TPO_Account__r.Oracle_Warehouse_Derived__c, TPO_Account__r.LastModifiedById, TPO_Account__r.LastModifiedDate, 
                                                                            TPO_Account__r.Credit_Hold__c, TPO_Account__r.Credit_Limit__c, TPO_Account__r.CurrencyIsoCode, TPO_Account__r.Status__c, 
                                                                            TPO_Account__r.Interface_Status__c, TPO_Account__r.RecordTypeId, TPO_Account__r.Type, 
                                                                            Sales_Type__c, Channel_Type__c, Payment_Type__c, Ship_To_Contact__c, Bill_To_Contact__c, Dealer_Account__c, 
                                                                            TPO_Account__c, End_Customer_Account__c,  Interface_Status__c, Ok_To_Ship__c, Racking_Opt_Out__c, Monitoring_Opt_Out__c, Number_of_Systems__c,
                                                                            (
                                                                                Select id, Purchase_Order__r.Id, Order_Line_Number__c, Item_ID__c, Quantity__c, Unit_of_Measure__c, Unit_Price__c, Oracle_Line_Type__c, SmartPack_Item__c, Item_Type__c, Requested_Delivery_Date__c, LastModifiedDate, LastModifiedById, Oracle_Item_ID__c, Oracle_Item_ID__r.Name, Vendor_Name__c,Vendor_Name__r.Oracle_Vendor_Number__c,Vendor_Name__r.Oracle_Vendor_Site_Code__c,Partner_Role__c   from Purchase_Order_Lines__r
                                                                            )
                                                                            // FROM Purchase_Order__c where Integration_Status__c = 'Created' OR Integration_Status__c = 'Changed']);
                                                                            
                                                                            FROM Purchase_Order__c where Order_Status__c = 'Submitted' and interface_status__c = 'New' Limit 25]);
        //  From Purchase_Order__c where /*id = 'a0xS00000013gLIIAY' or id = 'a0xS00000013gL3IAI' or id ='a0xS00000013gKyIAI' */ id = 'a0xS00000013gMkIAI']);
        
        
        
        System.debug(allNonSynPOs.size());
        
        
        
        Set<Bill_To_Site__c> billToSiteList = new Set<Bill_To_Site__c>();        
        Set<Ship_To_Site__c> shipToSiteList = new Set<Ship_To_Site__c>();
		Map<Id, Ship_To_Site__c> tpsCashSTS = new Map<Id, Ship_To_Site__c>();
        Set<Id> accountIds = new Set<id>();
        Set<Id> installerContactIds = new Set<id>(); // Case 00754398
        Map<Id,Id> homeOwnerInstallerMap =  new Map<Id,Id>(); // Case 00754398
        Map<Id,Id> installerContactMap =  new Map<Id,Id>(); // Case 00754398
        /*      Set<Ship_To_Site__c> shipToSiteListTPOLease = new Set<Ship_To_Site__c>();
Set<Ship_To_Site__c> shipToSiteListCash = new Set<Ship_To_Site__c>();
Set<Id> customerTPOLeaseAccountIds = new Set<Id>();
Set<Id> customerCashAccountIds = new Set<Id>(); */
        
        Set<Id> contactId = new Set<Id>();
        List<Schema.Account> accList = new List<Schema.Account>();
        List<Bill_To_Site__c> billToList = new List<Bill_To_Site__c>();
        List<Ship_To_Site__c> shipToList = new List<Ship_To_Site__c>();
        
        for(Purchase_Order__c PO :allNonSynPOs){
            System.debug('PO.Dealer_Account__c : ' + PO.Dealer_Account__c + ',PO.End_Customer_Account__c : ' + PO.End_Customer_Account__c );
            System.debug('PO.Bill_to_Site__c : ' + PO.Bill_to_Site__c + ',PO.Ship_To_Site__c : ' + PO.Ship_To_Site__c );
            if(PO.Dealer_Account__c != null)
            {
                accountIds.add(PO.Dealer_Account__c);
                PO.Dealer_Account__r.Interface_Status__c = 'Submitted to SOA';
                accList.add(PO.Dealer_Account__r);
            }
            // Case 00754398: map homeowner id with installer id
            if(PO.End_Customer_Account__c != null && PO.Installer__c != null && PO.Sales_Type__c == 'NH Lease'){
                accountIds.add(PO.Installer__c);
                homeOwnerInstallerMap.put(PO.End_Customer_Account__c, PO.Installer__c);
            }
            if(PO.End_Customer_Account__c != null){
                accountIds.add(PO.End_Customer_Account__c);
                /*            if(PO.Sales_Type__c == 'Lease' || PO.Sales_Type__c == 'TPO')
customerTPOLeaseAccountIds.add(PO.End_Customer_Account__c);
if(PO.Sales_Type__c == 'Cash')
customerCashAccountIds.add(PO.End_Customer_Account__c);*/
                
                PO.End_Customer_Account__r.Interface_Status__c = 'Submitted to SOA';
                accList.add(PO.End_Customer_Account__r);
            }
            if(PO.TPO_Account__c != null)  
            { 
                accountIds.add(PO.TPO_Account__c);
                accList.add(PO.TPO_Account__r);
                PO.TPO_Account__r.Interface_Status__c = 'Submitted to SOA';
            }
            if(PO.Quote__c != null && PO.Quote__r.Installer__c != null)
                accountIds.add(PO.Quote__r.Installer__c);
            if(PO.Bill_to_Site__c != null)
            {
                billToSiteList.add(PO.Bill_to_Site__r);
                
            }
            if(PO.Ship_To_Site__c != null)
            {
                /*                if((PO.Sales_Type__c == 'Lease' || PO.Sales_Type__c == 'TPO') && PO.Ship_to_Site__r.Residential_Customer_Account__c != null)
shipToSiteListTPOLease.add(PO.Ship_To_Site__r);
else
shipToSiteListCash.add(PO.Ship_To_Site__r); */
                
                shipToSiteList.add(PO.Ship_To_Site__r);
                
            }
            if(PO.Bill_To_Contact__c != null)
            {
                contactId.add(PO.Bill_To_Contact__c);
                
            }
            // Case 00754398: get shiptocontact
            if(PO.sales_type__c == 'NH Lease' && PO.Ship_To_Contact__c != null){                
                installerContactIds.add(PO.Ship_To_Contact__c);            
                PO.Interface_Status__c = 'Submitted to SOA'; 
            }
            else if(PO.sales_type__c != 'NH Lease' && PO.Ship_To_Contact__c != null){                
                contactId.add(PO.Ship_To_Contact__c);
            
            PO.Interface_Status__c =  'Submitted to SOA'; 
			
            if(PO.Sales_Type__c == 'Cash' && PO.Dealer_Account__r.NH_SSE_Type__c != null && PO.Dealer_Account__r.NH_SSE_Type__c.contains('TPS')) {
                tpsCashSTS.put(PO.Ship_to_Site__c, PO.Ship_to_Site__r);
            }			
        }
        }
        
        
        List<Bill_To_Site__c> customerBillToSiteList = new List<Bill_To_Site__c>([Select Oracle_Location_id__c, Id, Address1__c, Address2__c, Address3__c, City__c, State__c, Zip__c, Country__c, Active__c, Dealer_Account__r.Oracle_Operating_Unit__c, Oracle_Salesperson__c, Oracle_Price_List__c, Oracle_Primary__c, Dealer_Account__r.Oracle_Order_Type__c, LastModifiedById, LastModifiedDate, Dealer_Account__r.Oracle_Account_Number__c,Site_ID__c, Oracle_County__c, Interface_Status__c from Bill_To_Site__c where Dealer_Account__c in :accountIds order by LastModifiedDate]);
        List<Ship_To_Site__c> customershipToSiteList = new List<Ship_To_Site__c>([Select Oracle_Location_id__c, Id, Address1__c, Address2__c, Address3__c, City__c, State__c, Zip__c, Country__c, Status__c, Dealer_Account__r.Oracle_Operating_Unit__c, Oracle_Salesperson__c, Oracle_Primary__c, Dealer_Account__r.Oracle_Order_Type__c, LastModifiedById, LastModifiedDate, Oracle_County__c, Dealer_Account__r.Oracle_Account_Number__c, Contact_Phone__c, Contact_Name__c, Contact_Email__c, SiteID__c, Residential_Customer_Account__c, Interface_Status__c from Ship_to_Site__c where Dealer_Account__c in :accountIds order by LastModifiedDate]);
        //                 List<Ship_To_Site__c> customershipToSiteList = new List<Ship_To_Site__c>([Select Oracle_Location_id__c, Id, Address1__c, Address2__c, Address3__c, City__c, State__c, Zip__c, Country__c, Status__c, Dealer_Account__r.Oracle_Operating_Unit__c, Oracle_Salesperson__c, Oracle_Primary__c, Dealer_Account__r.Oracle_Order_Type__c, LastModifiedById, LastModifiedDate, Oracle_County__c, Dealer_Account__r.Oracle_Account_Number__c, Contact_Phone__c, Contact_Name__c, Contact_Email__c, SiteID__c, Residential_Customer_Account__c, Interface_Status__c from Ship_to_Site__c where (Dealer_Account__c in :customerCashAccountIds or  Residential_Customer_Account__c in : customerTPOLeaseAccountIds)AND Dealer_Account__r.Oracle_Account_Number__c = null]);
        
        
        if(customerBillToSiteList.size() > 0){
            billToSiteList.addAll(customerBillToSiteList);
        }
        
        if(customershipToSiteList.size() > 0){
            shipToSiteList.addAll(customershipToSiteList);
        }
        
        System.debug(accountIds.size());
        List<Schema.Contact> allContacts = new List<Schema.Contact>([Select Id, LastName, FirstName, Phone, Fax, MobilePhone, LastModifiedById, Email, Contact_Status__c, Account.Oracle_Account_Number__c, Oracle_Contact_id__c, LastModifiedDate, Primary__c, Interface_Status__c from Contact where (AccountId in :accountIds and Primary__c = true) OR ID in :contactId]);
        System.debug(allContacts.size());
        List<Schema.Contact> nhInstallerContacts = new List<Schema.Contact>();
        if(installerContactIds.size()>0){
            nhInstallerContacts = ([Select Id, LastName, FirstName, Phone, Fax, MobilePhone, LastModifiedById, Email, Contact_Status__c, Account.Oracle_Account_Number__c, Oracle_Contact_id__c, LastModifiedDate, Primary__c, Interface_Status__c from Contact where Id in :installerContactIds]);
        }
        Map<Id, List<Schema.Contact>> accountContactMap = new Map<Id, List<Schema.Contact>>();
        Map<Id, List<Bill_To_Site__c>> accountBillToMap = new Map<Id, List<Bill_To_Site__c>>();
        Map<Id, List<Ship_To_Site__c>> accountShipToMap = new Map<Id, List<Ship_To_Site__c>>();
        
        for(Id aIds : accountIds){
            
            List<Schema.Contact> relatedContact = new List<Schema.Contact>();
            List<Bill_To_Site__c> relatedBillToSite = new List<Bill_To_Site__c>();
            List<Ship_To_Site__c> relatedShipToSite = new List<Ship_To_Site__c>();
            
            for(Schema.Contact c :allContacts){
                //Case 00754398: non-nh lease PO                             
                if(homeOwnerInstallerMap.size()==0 && c.AccountId == aIds){ 
                    relatedContact.add(c);
                    c.Interface_Status__c = 'Submitted to SOA';
                }
                //Case 00754398: nh dealer
                else if((c.AccountId == aIds && homeOwnerInstallerMap.containsKey(aIds) == false)){ 
                    relatedContact.add(c);
                    c.Interface_Status__c = 'Submitted to SOA';
                }
            }   
            //Case 00754398: insert installer contact to homeowner
            if(installerContactIds.size()>0){            
                for(Schema.Contact c :nhInstallerContacts){
                    if(c.AccountId == homeOwnerInstallerMap.get(aIds)){ 
                        installerContactMap.put(c.AccountId, c.Id);                    
                    relatedContact.add(c);
                    c.Interface_Status__c = 'Submitted to SOA';
                }               
                }
            }            
            accountContactMap.put(aIds, relatedContact);
            
            for(Bill_To_Site__c billToSite : billToSiteList){
                if(billToSite.Dealer_Account__c == aIds){
                    relatedBillToSite.add(billToSite);
                    billToSite.Interface_Status__c = 'Submitted to SOA';
                }
                
                
            }
            billToList.addAll(billToSiteList);
            accountBillToMap.put(aIds, relatedBillToSite);
            
            for(Ship_To_Site__c shipToSite : shipToSiteList){
                
                if(shipToSite.Dealer_Account__c == aIds)
                {
                    relatedShipToSite.add(shipToSite);
                    shipToSite.Interface_Status__c = 'Submitted to SOA';
                }
                /*
if(shipToSiteListCash.contains(shipToSite) && shipToSite.Dealer_Account__c == aIds){
relatedShipToSite.add(shipToSite);
}
else if(shipToSiteListTPOLease.contains(shipToSite) && shipToSite.Residential_Customer_Account__c == aIds)
{
relatedShipToSite.add(shipToSite);
}
shipToSite.Interface_Status__c = 'Submitted to SOA';*/
            }
            
            shipToList.addAll(shipToSiteList);
            accountShipToMap.put(aIds, relatedShipToSite);            
        }
        
        System.debug(accountContactMap.values());
        System.debug(accountBillToMap.values());
        System.debug(accountShipToMap.values());
        //Case 00754398: added new parameter to pass fake contactid
        OrderList orderList = new OrderList(allNonSynPOs, accountContactMap, accountBillToMap, accountShipToMap, installerContactMap, tpsCashSTS);
        
        Set<Purchase_Order__c> allPOSet = new Set<Purchase_Order__c>();
        allPOSet.addAll(allNonSynPOs);
        
        List<Purchase_Order__c> allPOList = new List<Purchase_Order__c>();
        allPOList.addAll(allPOSet);
        
        Set<Bill_To_Site__c> allBillToSet = new Set<Bill_To_Site__c>();
        allBillToSet.addAll(billToList);
        
        List<Bill_To_Site__c> allBillToList = new List<Bill_To_Site__c>();
        allBillToList.addAll(allBillToSet);
        
        Set<Ship_To_Site__c> allShipToSet = new Set<Ship_To_Site__c>();
        allShipToSet.addAll(shipToList);
        
        List<Ship_To_Site__c> allShipToList = new List<Ship_To_Site__c>();
        allShipToList.addAll(allShipToSet);
        
        Set<Schema.Contact> allContactSet = new Set<Schema.Contact>();
        allContactSet.addAll(allContacts);
        
        List<Schema.Contact> allContactList = new List<Schema.Contact>();
        allContactList.addAll(allContactSet);
        
        Set<Schema.Account> allAccountSet = new Set<Schema.Account>();
        allAccountSet.addAll(accList);
        
        List<Schema.Account> allAccountList = new List<Schema.Account>();
        allAccountList.addAll(allAccountSet);
        
        Update allPOList;
        Update allBillToList;
        Update allShipToList;
        Update allContactList;
        Update allAccountList;
        //update allNonSynPOs;
        // update accList;
        // update billToList;
        // update shipToList;
        // update allContacts;
        
        return orderList;
    }
}