public class PurchaseOrderWizardPDFController {
    //To get current user's locale
    public String currentLocale {get;set;}
    public boolean isEUUser{get;set;}
    public boolean isPartnerUser{get;set;}
    //String constant for Dealer Account type Residential Installer
    public String RESIDENTIAL_INSTALLER = 'Residential Installer';
    //Variable to check whether Dealer Account type is Residential Intaller or not
    public boolean isDealerResidential{get;set;}
    //Reference of purchase order
    public Purchase_Order__c purchaseOrder {get;set;}
    //Selected opportunity
    public Opportunity  selectedOpportunity{get;set;}
    //Variable for ship to site address
    public String shipToSiteAddress{get;set;}
    //Variable for Bill to site address
    public String billToSiteAddress{get;set;}
    //List of purchase order line items
    private List<Purchase_Order_Line__c> purchaseOrderList= null; 
    //List of product line items
    public List<PurchaseOrderLineItemWrapper> selProductItems {get;set;}
    
    public boolean isNAUser{get;set;}
    
    public Boolean hasDiscounts {get;set;}
    
    /** Constructor PurchaseOrderWizardPDFController.
     *  @param ApexPages.standardController
     */
    public PurchaseOrderWizardPDFController(ApexPages.standardController control){
        hasDiscounts = false;
        String pOID=null;
        selectedOpportunity=null;
        shipToSiteAddress= null;
        initlizeUserType();
        isDealerResidential = false;
        currentLocale = userinfo.getLocale();
        purchaseOrder = (Purchase_Order__c)control.getRecord();
        if(purchaseOrder != null && purchaseOrder.ID != null)
            pOID =purchaseOrder.ID;
        else
            pOID = ApexPages.currentPage().getParameters().get('id');
        if(pOID != null){
            //Case#00058280
            //for(Purchase_Order__c p:[Select p.Lease__c, p.Lease_Number__c,p.CreatedDate,p.Ship_To_Contact__c,p.Owner.Profile.Name,p.SmartPack_Mounting_Type__c, p.SmartPack_Inverter_Type__c, p.Accept_Partial_Shipment__c, p.System_Size__c, p.SunPower_Design__c, (Select Id, Name, Order_Line_Number__c, Item_Description__c, Quantity__c, Unit_Price__c, Price__c, Unit_of_Measure__c, Quantity_per_Box__c, Item_ID__c, Item_Number__c, Purchase_Order__c,Item_Type__c, Oracle_Item_Id__c, Oracle_Item_Id__r.Name, Oracle_Item_Id__r.Line_Type__c, Oracle_Item_Id__r.Description__c, Oracle_Item_Id__r.Long_Description__c From Purchase_Order_Lines__r order by Item_Type__c),p.Special_Instructions__c, p.SmartMount__c, p.Shipping_Method__c, p.Ship_to_Site__r.Contact_Phone__c, p.Ship_to_Site__r.Contact_Email__c, p.Ship_to_Site__r.Contact_Last_Name__c, p.Ship_to_Site__r.Residential_Customer_Account__c, p.Ship_to_Site__r.Dealer_Account__c, p.Ship_to_Site__r.Zip__c, p.Ship_to_Site__r.State__c, p.Ship_to_Site__r.SiteID__c, p.Ship_to_Site__r.Oracle_Account_Number__c, p.Ship_to_Site__r.Country__c, p.Ship_to_Site__r.Contact_First_Name__c, p.Ship_to_Site__r.City__c, p.Ship_to_Site__r.Address3__c, p.Ship_to_Site__r.Address2__c, p.Ship_to_Site__r.Address1__c, p.Ship_to_Site__r.RecordTypeId, p.Ship_to_Site__r.Name, p.Ship_to_Site__r.Id, p.Ship_to_Site__c, p.Requested_Delivery_Date__c, p.Organization_ID__c, p.Order_Wizard_Step__c, p.Order_Total__c, p.Order_Status__c, p.Oracle_Order_Status__c, p.Oracle_Order_Number__c, p.Opportunity__r.Description, p.Opportunity__r.Name, p.Opportunity__c, p.Name, p.Is_Taxible_Order__c, p.Id, p.Delivery_Charges__c, p.Dealer_Account__r.ShippingCountry, p.Dealer_Account__r.ShippingPostalCode, p.Dealer_Account__r.ShippingState, p.Dealer_Account__r.ShippingCity, p.Dealer_Account__r.ShippingStreet, p.Dealer_Account__r.BillingCountry, p.Dealer_Account__r.BillingPostalCode, p.Dealer_Account__r.BillingState, p.Dealer_Account__r.BillingCity, p.Dealer_Account__r.BillingStreet, p.Dealer_Account__r.RecordTypeId, p.Dealer_Account__r.Type, p.Dealer_Account__r.Name, p.Dealer_Account__r.Id, p.Dealer_Account__c, p.CurrencyIsoCode, p.Contact_ID__c, p.Bill_to_Site__r.Oracle_Operating_Unit__c, p.Bill_to_Site__r.Dealer_Account__c, p.Bill_to_Site__r.Zip__c, p.Bill_to_Site__r.State__c, p.Bill_to_Site__r.Address3__c, p.Bill_to_Site__r.Address2__c, p.Bill_to_Site__r.Country__c, p.Bill_to_Site__r.City__c, p.Bill_to_Site__r.Address1__c, p.Bill_to_Site__r.Site_ID__c, p.Bill_to_Site__r.Id, p.Bill_to_Site__c, p.Accept_Expedited_Delivery_Charges__c, p.Notes__c From Purchase_Order__c p where p.ID = :pOID LIMIT 1]){
            for(Purchase_Order__c p:[Select p.Lease__c, p.Lease_Number__c,p.CreatedDate,p.Ship_To_Contact__c,p.Owner.Profile.Name,p.SmartPack_Mounting_Type__c, p.SmartPack_Inverter_Type__c, p.Accept_Partial_Shipment__c, p.System_Size__c, p.SunPower_Design__c, (Select Id, Name, Order_Line_Number__c, Item_Description__c, Quantity__c, Unit_Price__c, Price__c, Unit_of_Measure__c, Quantity_per_Box__c, Item_ID__c, Item_Number__c, Purchase_Order__c,SmartPack_Item__c, Oracle_Item_Id__c, Oracle_Item_Id__r.Name, Oracle_Item_Id__r.Line_Type__c, Oracle_Item_Id__r.Description__c, Oracle_Item_Id__r.Long_Description__c,Oracle_Item_Id__r.Item_Displayable_Description__c, Discount_Amount__c,Discount_Percent__c,Service_Fee__c From Purchase_Order_Lines__r order by SmartPack_Item__c),p.Special_Instructions__c, p.SmartMount__c, p.Shipping_Method__c, p.Ship_to_Site__r.Contact_Phone__c, p.Ship_to_Site__r.Contact_Email__c, p.Ship_to_Site__r.Contact_Last_Name__c, p.Ship_to_Site__r.Residential_Customer_Account__c, p.Ship_to_Site__r.Dealer_Account__c, p.Ship_to_Site__r.Zip__c, p.Ship_to_Site__r.State__c, p.Ship_to_Site__r.SiteID__c, p.Ship_to_Site__r.Oracle_Account_Number__c, p.Ship_to_Site__r.Country__c, p.Ship_to_Site__r.Contact_First_Name__c, p.Ship_to_Site__r.City__c, p.Ship_to_Site__r.Address3__c, p.Ship_to_Site__r.Address2__c, p.Ship_to_Site__r.Address1__c, p.Ship_to_Site__r.RecordTypeId, p.Ship_to_Site__r.Name, p.Ship_to_Site__r.Id, p.Ship_to_Site__c, p.Requested_Delivery_Date__c, p.Organization_ID__c, p.Order_Wizard_Step__c, p.Order_Total__c, p.Order_Status__c, p.Oracle_Order_Status__c, p.Oracle_Order_Number__c, p.Opportunity__r.Description, p.Opportunity__r.Name, p.Opportunity__c, p.Name, p.Is_Taxible_Order__c, p.Id, p.Delivery_Charges__c, p.Dealer_Account__r.ShippingCountry, p.Dealer_Account__r.ShippingPostalCode, p.Dealer_Account__r.ShippingState, p.Dealer_Account__r.ShippingCity, p.Dealer_Account__r.ShippingStreet, p.Dealer_Account__r.BillingCountry, p.Dealer_Account__r.BillingPostalCode, p.Dealer_Account__r.BillingState, p.Dealer_Account__r.BillingCity, p.Dealer_Account__r.BillingStreet, p.Dealer_Account__r.RecordTypeId, p.Dealer_Account__r.Type, p.Dealer_Account__r.Name, p.Dealer_Account__r.Id, p.Dealer_Account__c, p.CurrencyIsoCode, p.Contact_ID__c, p.Bill_to_Site__r.Oracle_Operating_Unit__c, p.Bill_to_Site__r.Dealer_Account__c, p.Bill_to_Site__r.Zip__c, p.Bill_to_Site__r.State__c, p.Bill_to_Site__r.Address3__c, p.Bill_to_Site__r.Address2__c, p.Bill_to_Site__r.Country__c, p.Bill_to_Site__r.City__c, p.Bill_to_Site__r.Address1__c, p.Bill_to_Site__r.Site_ID__c, p.Bill_to_Site__r.Id, p.Bill_to_Site__c, p.Accept_Expedited_Delivery_Charges__c, p.Notes__c From Purchase_Order__c p where p.ID = :pOID LIMIT 1]){
             //for(Purchase_Order__c p:[Select p.Lease__c, p.Lease_Number__c,p.CreatedDate,p.Ship_To_Contact__c,p.Owner.Profile.Name,p.SmartPack_Mounting_Type__c, p.SmartPack_Inverter_Type__c, p.Accept_Partial_Shipment__c, p.System_Size__c, p.SunPower_Design__c, (Select Id, Name, Order_Line_Number__c, Item_Description__c, Quantity__c, Unit_Price__c, Price__c, Unit_of_Measure__c, Quantity_per_Box__c, Item_ID__c, Item_Number__c, Purchase_Order__c,SmartPack_Item__c, Oracle_Item_Id__c, Oracle_Item_Id__r.Name, Oracle_Item_Id__r.Description__c, Oracle_Item_Id__r.Long_Description__c From Purchase_Order_Lines__r order by SmartPack_Item__c),p.Special_Instructions__c, p.SmartMount__c, p.Shipping_Method__c, p.Ship_to_Site__r.Contact_Phone__c, p.Ship_to_Site__r.Contact_Email__c, p.Ship_to_Site__r.Contact_Last_Name__c, p.Ship_to_Site__r.Residential_Customer_Account__c, p.Ship_to_Site__r.Dealer_Account__c, p.Ship_to_Site__r.Zip__c, p.Ship_to_Site__r.State__c, p.Ship_to_Site__r.SiteID__c, p.Ship_to_Site__r.Oracle_Account_Number__c, p.Ship_to_Site__r.Contact_First_Name__c, p.Ship_to_Site__r.City__c, p.Ship_to_Site__r.Address3__c, p.Ship_to_Site__r.Address2__c, p.Ship_to_Site__r.Address1__c, p.Ship_to_Site__r.RecordTypeId, p.Ship_to_Site__r.Name, p.Ship_to_Site__r.Id, p.Ship_to_Site__c, p.Requested_Delivery_Date__c, p.Organization_ID__c, p.Order_Wizard_Step__c, p.Order_Total__c, p.Order_Status__c, p.Oracle_Order_Status__c, p.Oracle_Order_Number__c, p.Opportunity__r.Description, p.Opportunity__r.Name, p.Opportunity__c, p.Name, p.Is_Taxible_Order__c, p.Id, p.Delivery_Charges__c, p.Dealer_Account__r.ShippingCountry, p.Dealer_Account__r.ShippingPostalCode, p.Dealer_Account__r.ShippingState, p.Dealer_Account__r.ShippingCity, p.Dealer_Account__r.ShippingStreet, p.Dealer_Account__r.BillingCountry, p.Dealer_Account__r.BillingPostalCode, p.Dealer_Account__r.BillingState, p.Dealer_Account__r.BillingCity, p.Dealer_Account__r.BillingStreet, p.Dealer_Account__r.RecordTypeId, p.Dealer_Account__r.Type, p.Dealer_Account__r.Name, p.Dealer_Account__r.Id, p.Dealer_Account__c, p.CurrencyIsoCode, p.Contact_ID__c, p.Bill_to_Site__r.Oracle_Operating_Unit__c, p.Bill_to_Site__r.Dealer_Account__c, p.Bill_to_Site__r.Zip__c, p.Bill_to_Site__r.State__c, p.Bill_to_Site__r.Address3__c, p.Bill_to_Site__r.Address2__c, p.Bill_to_Site__r.Country__c, p.Bill_to_Site__r.City__c, p.Bill_to_Site__r.Address1__c, p.Bill_to_Site__r.Site_ID__c, p.Bill_to_Site__r.Id, p.Bill_to_Site__c, p.Accept_Expedited_Delivery_Charges__c, p.Notes__c From Purchase_Order__c p where p.ID = :pOID LIMIT 1]){
                    purchaseOrder = p;
                    if(p.Dealer_Account__r.Type == RESIDENTIAL_INSTALLER)
                        isDealerResidential = true;
                    if(purchaseOrder.Opportunity__c != null)
                        selectedOpportunity =purchaseOrder.Opportunity__r;
                    if(p.Ship_to_Site__c !=null)
                        setFormatedShipToSiteAddress(p.Ship_to_Site__r);
                    if(p.Bill_To_Site__c !=null)
                        setFormatedBillToSiteAddress(p);
                    if(purchaseOrderList == null)
                        purchaseOrderList= p.Purchase_Order_Lines__r;
            }
        }
        if(purchaseOrderList != null && purchaseOrderList.size()>0){
            purchaseOrderList = getSortedList(purchaseOrderList);
            if(selProductItems == null) 
                selProductItems = new List<PurchaseOrderLineItemWrapper>();
            for(Purchase_Order_Line__c item:purchaseOrderList){
                PurchaseOrderLineItemWrapper pWrap = new PurchaseOrderLineItemWrapper();
                copyItemToWrapper(item,pWrap);
                selProductItems.add(pWrap);     
            }
        }
            
    }//constructor ends
    
    /** Function to set the formatted ship to site address.
     *  @param Ship_to_Site__c
     */
    private void setFormatedShipToSiteAddress(Ship_to_Site__c shipSite ){
        if(shipSite != null){
            shipToSiteAddress='';
            if(shipSite.Address1__c != null){
                shipToSiteAddress+=shipSite.Address1__c;
            }if(shipSite.Address2__c != null){
                shipToSiteAddress+=' ' + shipSite.Address2__c;
            }if(shipSite.Address3__c != null){
                shipToSiteAddress+=' ' + shipSite.Address3__c;
            }
            if(shipSite.City__c != null)
                shipToSiteAddress+=shipSite.City__c +', '; 
            if(shipSite.State__c != null)
                shipToSiteAddress+=shipSite.State__c +', ';    
            if(shipSite.Zip__c != null)
                shipToSiteAddress+=shipSite.Zip__c +', ';      
            if(shipSite.Country__c != null)
                shipToSiteAddress+=shipSite.Country__c +' ';
                
        }
        //shipToSiteAddress 
    }
    
    /** Formatting the BillToSiteAddress in proper way.
     *  @param Purchase_Order__c
     */
    private void setFormatedBillToSiteAddress(Purchase_Order__c pOrder ){
        if(pOrder != null){
            if(pOrder.Bill_to_Site__c != null){
                billToSiteAddress='';                   
                if(pOrder.Bill_to_Site__r.Address1__c != null){
                    billToSiteAddress+=pOrder.Bill_to_Site__r.Address1__c;
                }if(pOrder.Bill_to_Site__r.Address2__c != null){
                    billToSiteAddress+=' ' + pOrder.Bill_to_Site__r.Address2__c;
                }if(pOrder.Bill_to_Site__r.Address3__c != null){
                    billToSiteAddress+=' ' + pOrder.Bill_to_Site__r.Address3__c;
                }
                if(pOrder.Bill_to_Site__r.City__c != null)
                    billToSiteAddress+=pOrder.Bill_to_Site__r.City__c +', '; 
                if(pOrder.Bill_to_Site__r.State__c != null)
                    billToSiteAddress+=pOrder.Bill_to_Site__r.State__c +', ';    
                if(pOrder.Bill_to_Site__r.Zip__c != null)
                    billToSiteAddress+=pOrder.Bill_to_Site__r.Zip__c +', ';      
                if(pOrder.Bill_to_Site__r.Country__c != null)
                    billToSiteAddress+=pOrder.Bill_to_Site__r.Country__c +' '; 
            }              
        }    
    }//function ends
    
    /** This function copy a price list item to wrapper object.
     *  @param Purchase_Order_Line__c 
     *  @param PurchaseOrderLineItemWrapper
     */
    private void copyItemToWrapper(Purchase_Order_Line__c pLine, PurchaseOrderLineItemWrapper pWrap){
        //Quantity
        pWrap.Qty = String.valueOf(pLine.Quantity__c);
        //Line Number
        pWrap.lineNumber = pLine.Order_Line_Number__c;
        //Item Number     
        pWrap.ID = pLine.ID;
        
        //pWrap.ItemID = pLine.Item_ID__c;
        //pWrap.Name = pLine.Item_Description__c;
        pWrap.oracleItemIDRef = pLine.Oracle_Item_ID__c;
        pWrap.ItemID = pLine.Oracle_Item_ID__r.Name;
        if(pLine.Oracle_Item_ID__r.Description__c != null)
        //sangita updated for EU Pricing
           // pWrap.Name = pLine.Oracle_Item_ID__r.Description__c;
           pWrap.Name = pLine.Oracle_Item_ID__r.Item_Displayable_Description__c;
        else
            pWrap.Name = pLine.Oracle_Item_ID__r.Long_Description__c;    
        pWrap.isSmartPack = pLine.SmartPack_Item__c;
        pWrap.isFromDesign =false;
        pWrap.isExisting =true;
        pWrap.perUnitPrice = pLine.Unit_Price__c;
        pWrap.totalPrice = pline.Price__c;
        // changed for maintaining currency format
        ///For Currency Added @19 Nov,2009
            if(purchaseOrder != null && purchaseOrder.CurrencyIsoCode != null)
                pWrap.pOrderLine.CurrencyIsoCode =purchaseOrder.CurrencyIsoCode;
        ///For Currency Added @19 Nov,2009  
        // changed for maintaining currency format
        pWrap.pOrderLine.Unit_Price__c = (pLine.Unit_Price__c != null)? pLine.Unit_Price__c :0.0;
        pWrap.pOrderLine.Price__c = (pLine.Price__c != null) ? pLine.Price__c :0.0;
        pWrap.pOrderLine.Discount_Amount__c = (pLine.Discount_Amount__c != null) ? pLine.Discount_Amount__c : 0;
        pWrap.pOrderLine.Discount_Percent__c = (pLine.Discount_Percent__c != null) ? pLine.Discount_Percent__c : 0;
        pWrap.pOrderLine.Service_Fee__c = (pLine.Service_Fee__c != null) ? pLine.Service_Fee__c : 0;
        pWrap.discountPercent = String.valueOf((pLine.Discount_Percent__c != null) ? Decimal.valueOf(pLine.Discount_Percent__c).setScale(2) : 0) + '%';
        pWrap.discountAmount = (pLine.Discount_Amount__c != null) ? pLine.Discount_Amount__c.setScale(2) : 0;
        pWrap.serviceFee = (pLine.Service_Fee__c != null) ? pLine.Service_Fee__c.setScale(2): 0;
        pWrap.lineType = pLine.Oracle_Item_Id__r.Line_Type__c;
        
        if((pLine.Discount_Amount__c != null && pLine.Discount_Amount__c > 0) || (pLine.Discount_Percent__c != null && pLine.Discount_Percent__c > 0) || (pLine.Service_Fee__c != null && pLine.Service_Fee__c > 0))
            hasDiscounts = true;
        //setCounter(pWrap.lineNumber);
    }
    /** Inner class PurchaseOrderLineItemWrapper.
     *  
     */
    public class PurchaseOrderLineItemWrapper{
        public String ID {get;set;}
        public String lineType {get;set;}
        public String lineNumber {get;set;}
        public String Name{get;set;}
        public String prodType{get;set;}
        public String Qty{get;set;}
        public boolean isSmartPack{get;set;}
        public boolean isFromDesign{get;set;}
        public String itemID{get;set;}
        public ID oracleItemIdRef{get;set;}
        public Boolean isExisting{get;set;}
        public decimal perUnitPrice{get;set;}
        public decimal totalPrice{get;set;}
        public String discountPercent {get;set;}
        public Decimal discountAmount {get;set;}
        public Decimal serviceFee {get;set;}
        public Purchase_Order_Line__c pOrderLine {get;set;} 
        
        public PurchaseOrderLineItemWrapper(){
            this.pOrderLine = new Purchase_Order_Line__c();
            isExisting =false;
        }
        public PurchaseOrderLineItemWrapper(String ID,String lineNumber,String Name,String prodType,String Qty,Boolean isSmartPack,Boolean isFromDesign){
            this.pOrderLine = new Purchase_Order_Line__c();
            isExisting =false;
            this.ID = ID;   
            this.lineNumber = lineNumber;
            this.Name=Name;
            this.prodType=prodType;
            this.Qty=Qty;
            this.isSmartPack=isSmartPack;
            this.isFromDesign=isFromDesign;
        }
         // new constructor having per unit price and total price
        public PurchaseOrderLineItemWrapper(String ID,String lineNumber,String Name,String prodType,String Qty,decimal perUnitPrice,Boolean isSmartPack,Boolean isFromDesign,Decimal price){
            this.pOrderLine = new Purchase_Order_Line__c();
            isExisting =false;
            this.ID = ID;   
            this.lineNumber = lineNumber;
            this.Name=Name;
            this.prodType=prodType;
            this.Qty=Qty;
            this.perUnitPrice =0.0; 
            this.totalPrice = price;
            this.pOrderLine.Unit_Price__c = perUnitPrice;
            this.pOrderLine.Price__c = totalPrice;
            this.isSmartPack=isSmartPack;
            this.isFromDesign=isFromDesign;
        }
        
    }
    
    /** Function to arrange the purchase order line items in sorted list.
     *  @param List<Purchase_Order_Line__c>
     */
    private List<Purchase_Order_Line__c> getSortedList(List<Purchase_Order_Line__c> purLines){
        for(Integer index =0 ;index<purLines.size();index++){
            for(Integer nextIndex = index+1; nextIndex < purLines.size();nextIndex++){
                if(covertStringToInt(purLines[index].Order_Line_Number__c) > covertStringToInt(purLines[nextIndex].Order_Line_Number__c)){ 
                    Purchase_Order_Line__c tmp = purLines[index];   
                    purLines.set(index,purLines[nextIndex]);
                    purLines.set(nextIndex,tmp);
                } 
            }//inner for ends         
        }//for ends
        return purLines;
    }//Function ends
    
    /** Function to convert a string into integer.
     *  @param String
     */
    private Integer covertStringToInt(String val){
        try{
            return (val == null || val.trim() =='') ? 0 : Integer.valueOf(System.Math.round(System.Math.floor(Double.ValueOf(val))));
        }catch(Exception e){
            return 0;       
        }
    }//Function ends
    
    public void initlizeUserType() {
        isNAUser =false;
        isEUUser =false;
        String userID = UserInfo.getUserID();
        for(User u :[select id, User.Profile.Name,UserType, Contact.Authorized_to_Order__c, Contact.Account.Type,Contact.Account.Theater__c,Contact.Account.Online_Order_Access__c from User where id = :userID and ContactID != null LIMIT 1])
           {
            if(u != null && u.Contact != null && u.Contact.Account != null && u.UserType == 'PowerPartner'){
                //check whether the user is partner or non-partner
              String accType =u.Contact.Account.Type; 
              if( !u.profile.name.startsWith('EU')  && accType !=null && PriceListItemUtility.getValidNAAccountType().contains(accType) && u.Contact.Account.Theater__c == 'North America'){
                isNAUser =true;
              }else if(u.profile.name.startsWith('EU')){
                    isEUUser = true;                    
              } 
            }
         }
         if(!isEUUser && !isNAUser){
            isPartnerUser =false;
         }
    }      
           
    
}//Class ends