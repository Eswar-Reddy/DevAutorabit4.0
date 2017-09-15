/*
Modifications:
04-Jul-2014: Birlasoft : Added Extra Fields & Vendor_Name__c in the PO Query
*/

public class LeaseOrderWizardControllerInternal
{
    /***** VARIABLES *****/
    /*****
If intTabToDisplay = 0, display No Tab  
If intTabToDisplay = 1, display Add Product Tab
If intTabToDisplay = 2, display Shipping Tab  
If intTabToDisplay = 3, display Submit Order Tab
If intTabToDisplay = 4, display Order Details Tab  
*****/     
    private integer intTabToDisplay = 0;
    /*****
Will hold value comming from User Selected Tab
*****/ 
    private integer intGotoTab = 0;
    private Purchase_Order__c objPurchaseOrder = new Purchase_Order__c();
    private String strShiAdd = '';
    private String strBilAdd = ''; 
    private String strInstShiAdd='';
    private List<Purchase_Order_Line__c> orderedPOLList = new List<Purchase_Order_Line__c>(); 
    private String str3MsgOnSubmit = '';
    private String str4MsgOnSubmit = '';
    private Boolean bFinancierChanged = false;
    public boolean showNextbutton{get;set;}  
    /*** END VARIABLES ***/
    
    /***** PROPERTY *****/
    public Integer propTabToDisplay { get{ return intTabToDisplay; } private set; }//Tab Handlers
    public Integer propGotoTab { get { return intGotoTab; } set { intGotoTab = value; } }//Tab Handlers 
    public Purchase_Order__c propPurchaseOrder { get { return objPurchaseOrder; } set { objPurchaseOrder = value; } }//Base property to expose data on page
    public String propShipingAddress { get { return strShiAdd; } set; } //Exposing Shipping Address Transformation
    public String propBillingAddress { get { return strBilAdd; } set; } //Exposing Billing Address Transformation 
    public String propInstShipingAddress { get {return strInstShiAdd;} set;} //Exposing Shipping Address of Installer
    public Boolean showOrderConfirmation {get;set;}
    public DateTime userCurrentTime{get;set;}
    public Integer userCurrentTimeHour{get;set;}
    public String dayOfWeek {get;set;}
    public List<Purchase_Order_Line__c> propOrderedPOLList { get {return orderedPOLList; } set { orderedPOLList = value; } }
    public User propCurrentUser
    {
        get{
            return ([SELECT id, Allow_Financier_Update__c FROM User WHERE id =: Userinfo.getUserId()]);
        }
        private set;
    }
    public String prop3MsgOnSubmit { get { return str3MsgOnSubmit; } set { str3MsgOnSubmit = value; } }  
    public String prop4MsgOnSubmit { get { return str4MsgOnSubmit; } set { str4MsgOnSubmit = value; } } 
    public Boolean propFinancierChanged  { get { return bFinancierChanged; } set { bFinancierChanged = value; } }
    private Set<String> SSDwithin3DaysTheaterSet = new Set<String>();
    public String creditCheckStatus {get;set;} // added by Ganesh Chedella to replace credit app fields of Account with fields on Credit check request to see if Credit check is approved to conitnue with PO process as part of Loan
	public String poDeltaURL {get; private set;}
    /*** END PROPERTY ***/
    
    /***** CONSTRUCTOR *****/
    public LeaseOrderWizardControllerInternal(ApexPages.StandardController controller) 
    {
        creditCheckStatus = null; 
        if(controller != null)
        {
            str3MsgOnSubmit = '';
            str4MsgOnSubmit = '';
            bFinancierChanged = false;
            String strPOId = controller.getId();
            if(strPOId != null)
            {
                // Logic added to not to show the "Next" button as there is a PO Exist for same lot number and Community.
                showNextbutton = true;
                if(purchaseOrderManagement.fIsPurchaseOrderExistNewHomes(Id.valueof(strPOId))){
                    showNextbutton = false;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.Purchase_Order_Already_Exist));
                 }
                intTabToDisplay = 1;
                propPurchaseOrder = FetchData(strPOId);
                if(propPurchaseOrder != null){
                    system.debug('AccountID is '+propPurchaseOrder.End_Customer_Account__c + ' and quote type is '+propPurchaseOrder.Quote__r.QuoteType__c);
                    List<Credit_Check_Request__c> creditApp = [select id,Status__c,Application_Type__c,Account__c from Credit_Check_Request__c where Account__c = :propPurchaseOrder.End_Customer_Account__c AND Application_Type__c = :propPurchaseOrder.Quote__r.QuoteType__c  limit 1];
                    if(!creditApp.isEmpty() && creditApp.get(0).Status__c == 'Approved'){
                        creditCheckStatus = 'Approved';
                    }
					// change order phase II - add button to compare po's
                    Id amendedQuoteId = propPurchaseOrder.Quote__r.Amended_Lease__c;
                    poDeltaURL = PurchaseOrderUtility.getPODeltaURL(strPOId, amendedQuoteId);                    
                }
                if(propPurchaseOrder != null && (propPurchaseOrder.Order_Status__c == 'Submitted' || propPurchaseOrder.Order_Status__c == 'Processed'))
                {
                    intTabToDisplay = 4;
                    if((propPurchaseOrder.Order_Status__c == 'Submitted' || propPurchaseOrder.Order_Status__c == 'Processed') && propPurchaseOrder.Oracle_Order_Number__c != null)
                        str4MsgOnSubmit = 'Order Processed. Your Oracle Order number is ' + propPurchaseOrder.Oracle_Order_Number__c + '.';
                    else if(propPurchaseOrder.Order_Status__c == 'Submitted' && propPurchaseOrder.Oracle_Order_Number__c == null) 
                        str4MsgOnSubmit = 'Your Order has been successfully Submitted to SunPower.';
                }
                if(propPurchaseOrder != null && (propPurchaseOrder.Order_Status__c == 'Error' || propPurchaseOrder.Order_Status__c == 'In Progress'))
                {
                    intTabToDisplay = 3;
                    if(propPurchaseOrder.Order_Status__c == 'Error')
                        str3MsgOnSubmit = 'Order has Error - ' + propPurchaseOrder.Order_Status_Interface_Message__c + '.';
                }         
                AddressTransformation(propPurchaseOrder);
                // Hari: Sunpower TPO Start: REL 1.5 Code Start : for REQ :
                /*        isFRTPOPO = false;
if(propPurchaseOrder.Opportunity__r.Account.BillingCountry != null && propPurchaseOrder.Opportunity__r.Account.BillingCountry.equalsIgnoreCase('France'))
{
partnerAddressTrans(propPurchaseOrder);
isFRTPOPO = true; 
}  */
                // Hari: Sunpower TPO End: REL 1.5 Code Start : for REQ :   
            }
        }
        userCurrentTime = Datetime.valueOfGMT(string.valueof(Datetime.now()));
        userCurrentTimeHour = userCurrentTime.hourGmt();
        
        if(Label.ThreedayswithinSSDRegions!=null){
            List<String> ThreedayswithinSSDList = Label.ThreedayswithinSSDRegions.split(',');
            System.debug('ThreedayswithinSSDList ----->'+ThreedayswithinSSDList);
            SSDwithin3DaysTheaterSet.addAll(ThreedayswithinSSDList);
        }
    }
    /*** END CONSTRUCTOR ***/
    
    /***** FUNCTION *****/
    /*****
Tab Switch Handler
*****/
    public PageReference SwitchTab()
    {  
        if(intGotoTab != null)
        {
            if(intGotoTab == 2)
            {
                if(propPurchaseOrder.Projected_Install__c == null)
                {
                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please provide Projected Install Complete Date.');
                    ApexPages.addMessage(errorMsg);
                    return null;        
                }
                else if(propPurchaseOrder.Financier__c == null)
                {
                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Financier.');
                    ApexPages.addMessage(errorMsg);
                    return null;          
                }
                else{
                    updatePOrder(true, 'New');
                }
            }
            else if(intGotoTab == 3)
            {
                //Below if block added by Rehan for Shipping method of France
                if(propPurchaseOrder.Opportunity__r.Account.BillingCountry.equalsIgnoreCase('France')){
                    propPurchaseOrder.Shipping_Method__c = propPurchaseOrder.Shipping_Method_France__c;
                }
                if(dayOfWeek == 'Sunday')
                {
                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please contact your PSR.  Sunday delivery requires special handling.');
                    ApexPages.addMessage(errorMsg);
                    return null;          
                }
                if(propPurchaseOrder.Requested_Delivery_Date__c == null)
                {
                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please provide Requested Delivery Date.');
                    ApexPages.addMessage(errorMsg);
                    return null;          
                }
                if(propPurchaseOrder.Requested_Delivery_Date__c != null && propPurchaseOrder.Requested_Delivery_Date__c <= Date.Today().addDays(3) && propPurchaseOrder.Accept_Expedited_Delivery_Charges__c == false && !SSDwithin3DaysTheaterSet.contains(propPurchaseOrder.Dealer_Account__r.Theater__c) )
                {
                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Requested Delivery Date less than 3 days from today, is applicable for Expedited Delivery Charges. Please select Accept Expedited Delivery Charges.');
                    ApexPages.addMessage(errorMsg);
                    return null;  
                }
                if(propPurchaseOrder.Requested_Delivery_Date__c != null && propPurchaseOrder.Requested_Delivery_Date__c <= PriceListItemUtilityLease.getNextWorkingDate(Date.Today(),3) && SSDwithin3DaysTheaterSet.contains(propPurchaseOrder.Dealer_Account__r.Theater__c) )
                {
                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.Warning,Label.DeliveryDatewith3daysofToday_ERROR);
                    ApexPages.addMessage(errorMsg);
                    return null;  
                }
                if(propPurchaseOrder.Shipping_Method__c == null)
                {
                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Shipping Method.');
                    ApexPages.addMessage(errorMsg);
                    return null;        
                } 
                // Hari: Sunpower TPO Start: REL 1.5 Code Start : for REQ :
                /*        if(partnerhasshippAdd == false && selectadd == 'Partner Address' && propPurchaseOrder.Opportunity__r.Account.BillingCountry != null && propPurchaseOrder.Opportunity__r.Account.BillingCountry.equalsIgnoreCase('France') ) // This if partner is selected and partner has no shippadd 
{
//ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No Address Mentioned for Partner Shipping Site, Please Create shipping Address for Parnter.');
ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.TPO_shippingAddress);
ApexPages.addMessage(errorMsg);
return null;          
}
if(partnerhasshippAdd == true && selectadd == 'Partner Address' && partnershiprecID != null && propPurchaseOrder.Opportunity__r.Account.BillingCountry != null && propPurchaseOrder.Opportunity__r.Account.BillingCountry.equalsIgnoreCase('France') ) // This if partner is selected and partner has shippadd, then assign that to Shipptosite id of PO
{
propPurchaseOrder.Ship_to_Site__c = partnershiprecID;        
}
if(partnerhasshippAdd == true && selectadd == 'HO Address' && partnershiprecID != null && HOshiprecID != null && propPurchaseOrder.Opportunity__r.Account.BillingCountry != null && propPurchaseOrder.Opportunity__r.Account.BillingCountry.equalsIgnoreCase('France') ) // This if HO is selected (return back from 3rd screen to 2nd screen ) then assign back the HO shipd rec id to shipptosite of PO
{
propPurchaseOrder.Ship_to_Site__c = HOshiprecID ;        
}*/
                // Hari: Sunpower TPO End: REL 1.5 Code END : for REQ :
                updatePOrder(true, 'New');
            } 
            else if(intGotoTab == 4)
            {
                if(creditCheckStatus != 'Approved' && propPurchaseOrder.Opportunity__r.Account.BillingCountry != 'France')
                {
                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Customer\'s Credit Check is not passed yet! Purchase Order can not be submitted.');
                    ApexPages.addMessage(errorMsg);
                    return null;          
                }
                updatePOrder(true, 'Submitted'); 
                str4MsgOnSubmit = 'Your Order has been successfully Submitted to SunPower.';        
            } 
            intTabToDisplay = intGotoTab;
        }
        return null;
    }//End Func SwitchTab
    // Hari: Sunpower TPO Start: REL 1.5 Code Start : for REQ :
    /*  public boolean isFRTPOPO {get;set;} 
public string selectadd = '';
public string selectedadd { get { return selectadd; } set { selectadd = value; } }
public String ShipAddrSelected {get;set;}
public String strMailingAdd {get;set;}
Public Boolean partnerhasshippAdd {get;set;}
Public id partnershiprecID {get;set;}
Public id HOshiprecID {get;set;}
public List<selectoption> getShippAddrSection()
{
List<SelectOption> options = new List<SelectOption>(); 
options.add(new SelectOption('HO Address', 'HO Address'));
options.add(new SelectOption('Partner Address', 'Partner Address'));
return options;
}
public string Addresschange {get;set;}
public Void changeshippadd()
{
system.debug('@@@@@@@@@@@selectadd'+selectadd);
system.debug('2@@@@@@@@@@@selectedadd'+selectedadd );
system.debug('2@!!!!strShiAddd'+strShiAdd );

if(selectadd == 'Partner Address')
{
Addresschange = strShiAdd;
strShiAdd = strMailingAdd ;
}
else if(selectadd == 'HO Address')
{
system.debug('1@@@@@@@@@@Addresschange'+Addresschange);
system.debug('1@@@@@@@@@@AstrShiAdd'+strShiAdd);
strShiAdd = Addresschange;
system.debug('2@@@@@@@@@@strShiAdd'+strShiAdd);
}

}

public void partnerAddressTrans(Purchase_Order__c po)
{
// Partner Addresses Construction
if(po != null && po.TPO_Account__c != null)
{
partnerhasshippAdd = true;
List<Ship_to_Site__c> lstPartnership = [select id,name,Address1__c,City__c,State__c,Zip__c,Country__c,Dealer_Account__c from Ship_to_Site__c where Dealer_Account__c =: po.Dealer_Account__c ];
if(lstPartnership != null && lstPartnership.size()>0)
{
strMailingAdd = '';//Shipping Address String
partnershiprecID = lstPartnership[0].ID;
if(lstPartnership[0] != null && lstPartnership[0].Address1__c != null &&  lstPartnership[0].Address1__c != '')
strMailingAdd = strMailingAdd + lstPartnership[0].Address1__c;
if(lstPartnership[0] != null && lstPartnership[0].City__c != null &&  lstPartnership[0].City__c != '')
strMailingAdd = strMailingAdd + ', ' + lstPartnership[0].City__c;
if(lstPartnership[0] != null && lstPartnership[0].State__c != null &&  lstPartnership[0].State__c != '')
strMailingAdd = strMailingAdd + ', ' + lstPartnership[0].State__c;
if(lstPartnership[0] != null && lstPartnership[0].Zip__c != null &&  lstPartnership[0].Zip__c != '')
strMailingAdd = strMailingAdd + ', ' + lstPartnership[0].Zip__c;
if(lstPartnership[0] != null && lstPartnership[0].Country__c != null &&  lstPartnership[0].Country__c != '')
strMailingAdd = strMailingAdd + ', ' + lstPartnership[0].Country__c + '.';
partnerhasshippAdd = true;
}
else // No Data in Partner account - Shipping site (No Record)
{
strMailingAdd ='No Address Mentioned for Partner Shipping Site, Please Create shipping Address for Parnter.';
partnerhasshippAdd = false;
}
}
if(po != null && po.Ship_to_Site__c != null)
{
List<Ship_to_Site__c> lstHOshipsite = [select id,name,Address1__c,City__c,State__c,Zip__c,Country__c,Dealer_Account__c from Ship_to_Site__c where Dealer_Account__c =: po.End_Customer_Account__c ];
if(lstHOshipsite != null && lstHOshipsite.size()>0)
{
HOshiprecID = lstHOshipsite[0].ID;
}
}
}*/
    
    // Hari: Sunpower TPO END : REL 1.5 Code END : for REQ : 
    /*****
Shipping and Billing Address Transformation to String Handler
*****/
    public void AddressTransformation(Purchase_Order__c po)
    {
        strShiAdd = '';//Shipping Address String
        /*
if(po != null && po.Opportunity__r.Account.ShippingStreet != null &&  po.Opportunity__r.Account.ShippingStreet != '')
strShiAdd = strShiAdd + po.Opportunity__r.Account.ShippingStreet;
if(po != null && po.Opportunity__r.Account.ShippingCity != null &&  po.Opportunity__r.Account.ShippingCity != '')
strShiAdd = strShiAdd + ', ' + po.Opportunity__r.Account.ShippingCity;
if(po != null && po.Opportunity__r.Account.ShippingState != null &&  po.Opportunity__r.Account.ShippingState != '')
strShiAdd = strShiAdd + ', ' + po.Opportunity__r.Account.ShippingState;
if(po != null && po.Opportunity__r.Account.ShippingPostalCode != null &&  po.Opportunity__r.Account.ShippingPostalCode != '')
strShiAdd = strShiAdd + ', ' + po.Opportunity__r.Account.ShippingPostalCode;
if(po != null && po.Opportunity__r.Account.ShippingCountry != null &&  po.Opportunity__r.Account.ShippingCountry != '')
strShiAdd = strShiAdd + ', ' + po.Opportunity__r.Account.ShippingCountry + '.';*/
        if(po!=null && po.Ship_to_Site__r.Address__c!=null)
            strShiAdd=po.Ship_to_Site__r.Address__c;
        
        strBilAdd = '';//Billing Address String  
        if(po != null && po.Opportunity__r.Account.BillingStreet != null &&  po.Opportunity__r.Account.BillingStreet != '')
            strBilAdd = strBilAdd + po.Opportunity__r.Account.BillingStreet;
        if(po != null && po.Opportunity__r.Account.BillingCity != null &&  po.Opportunity__r.Account.BillingCity != '')
            strBilAdd = strBilAdd + ', ' + po.Opportunity__r.Account.BillingCity;
        if(po != null && po.Opportunity__r.Account.BillingState != null &&  po.Opportunity__r.Account.BillingState != '')
            strBilAdd = strBilAdd + ', ' +  po.Opportunity__r.Account.BillingState;
        if(po != null && po.Opportunity__r.Account.BillingPostalCode != null &&  po.Opportunity__r.Account.BillingPostalCode != '')
            strBilAdd = strBilAdd + ', ' + po.Opportunity__r.Account.BillingPostalCode;
        if(po != null && po.Opportunity__r.Account.BillingCountry != null &&  po.Opportunity__r.Account.BillingCountry != '')
            strBilAdd = strBilAdd + ', ' + po.Opportunity__r.Account.BillingCountry + '.';    
        
        
        strInstShiAdd=''; //Installer's ShippingAddress 
        if(po != null && po.Quote__r.Installer__c!=null)
        {
            if(po.Installer__r.ShippingStreet != null &&  po.Installer__r.ShippingStreet != '')
                strInstShiAdd = strInstShiAdd + po.Installer__r.ShippingStreet;
            if(po.Installer__r.ShippingCity != null &&  po.Installer__r.ShippingCity != '')
                strInstShiAdd = strInstShiAdd + ', ' + po.Installer__r.ShippingCity;
            if(po.Installer__r.ShippingState != null &&  po.Installer__r.ShippingState != '')
                strInstShiAdd = strInstShiAdd + ', ' + po.Installer__r.ShippingState;
            if(po.Installer__r.ShippingPostalCode != null &&  po.Installer__r.ShippingPostalCode != '')
                strInstShiAdd = strInstShiAdd + ', ' + po.Installer__r.ShippingPostalCode;
            if(po.Installer__r.ShippingCountry != null &&  po.Installer__r.ShippingCountry != '')
                strInstShiAdd = strInstShiAdd + ', ' + po.Installer__r.ShippingCountry + '.';
        } 
    }//End Func AddressTransformation
    
    /*****
Fetch data to be presented on the Wizard
*****/    
    public Purchase_Order__c FetchData(String strPOId)
    {
        Purchase_Order__c po = [SELECT  System_Fees__c, System_Size__c, 
                                SunPower_Design__c, Special_Instructions__c, 
                                Quote__r.NH_Community__c,                       //sktemp2
                                Quote__r.quote_type__c,                         //sktemp1
                                Quote__r.QuoteType__c,
								Quote__r.Amended_Lease__c,
                                SmartPack_Mounting_Type__c, SmartPack_Inverter_Type__c, 
                                SmartPack_Flag__c, SmartMount__c, 
                                Shipping_Method__c, Ship_to_Site__c, Shipping_Method_France__c,
                                Ship_To_Contact__c, Ship_To_Contact__r.Name, Total_Lease_Value__c, 
                                Requested_Delivery_Date__c, Quote__c, 
                                Purchase_Order_Details__c, Projected_Install__c, 
                                Primary_PSR_Email__c, PO_Submit_SP_WW__c, 
                                PO_Submit_Date__c, Organization_ID__c, Order_Wizard_Step__c, 
                                Order_Type__c, Order_Total__c, 
                                Order_Submit_Date__c, Order_Status__c, 
                                Order_Status_Interface_Message__c, Order_Booked_Date__c, 
                                Oracle_Vendor_Site_Code__c, Oracle_Vendor_Number__c, 
                                Oracle_Ship_to_Site_ID__c, Oracle_Order_Type__c, 
                                Oracle_Order_Status__c, Oracle_Order_Number__c, 
                                Oracle_Operating_Unit__c, OwnerId,
                                Name, Notes__c, Material_Cost_Reimbursement__c, 
                                Lease__c, Lease_Number__c, Language__c, 
                                Is_Taxible_Order__c, IsDeleted, Id, 
                                GenerateURL__c, Ext_Id__c, Financier__c, 
                                Effective_Price_of_Goods__c, 
                                Delivery_Charges__c, Dealer_Fees__c, 
                                Dealer_Account__c,Dealer_Account__r.Theater__c, DSR_PO_Group_Email__c, 
                                CurrencyIsoCode, Contact_ID__c, 
                                Bill_to_Site__c, Attention__c, 
                                Assigned_RSM__c, Assigned_DSR__c, 
                                Account_Territory__c, Accept_Terms__c, 
                                Accept_Partial_Shipment__c, Accept_Expedited_Delivery_Charges__c, 
                                Opportunity__c, Opportunity__r.OwnerId, Opportunity__r.Name,
                                End_Customer_Account__c, End_Customer_Account__r.Name, End_Customer_Account__r.Partner_Account__c,
                                End_Customer_Account__r.Partner_Account__r.Name,
                                Opportunity__r.Account.ShippingStreet, Opportunity__r.Account.ShippingState, 
                                Opportunity__r.Account.ShippingPostalCode, Opportunity__r.Account.ShippingCountry, Opportunity__r.Account.ShippingCity, 
                                Opportunity__r.Account.BillingStreet, Opportunity__r.Account.BillingState, 
                                Opportunity__r.Account.BillingPostalCode, Opportunity__r.Account.BillingCountry, Opportunity__r.Account.BillingCity, TPO_Account__c,
                                Opportunity__r.CreatedBy.Contact.MailingStreet,Opportunity__r.CreatedBy.Contact.MailingCity,Opportunity__r.CreatedBy.Contact.MailingState,Opportunity__r.CreatedBy.Contact.MailingCountry,Opportunity__r.CreatedBy.Contact.MailingPostalCode,
                                //Added Extra fields for Australian PO : 04-Jul-2014 : Birlasoft
                                Quote__r.Installer__r.Name,Quote__r.Installer__r.ShippingStreet,Quote__r.Installer__r.ShippingCity,Quote__r.Installer__r.ShippingState,
                                Quote__r.Installer__r.ShippingPostalCode,Quote__r.Installer__r.ShippingCountry,
                                Installer__r.Name,Installer__r.ShippingStreet,Installer__r.ShippingCity,Installer__r.ShippingState,
                                Installer__r.ShippingPostalCode,Installer__r.ShippingCountry,
                                Ship_To_Site__r.Address__c,
                                Dealer_Account__r.NH_SSE_Type__c,Sales_Type__c,
                                (SELECT Id, IsDeleted, Name, Item_Type__c,  
                                 CurrencyIsoCode, Purchase_Order__c, 
                                 Category__c, Item_Description__c, 
                                 Item_ID__c, Item_Number__c, 
                                 Oracle_Item_ID__c, Order_Line_Number__c, 
                                 Organization_ID__c, Price__c, 
                                 Quantity__c, Quantity_per_Box__c, 
                                 SmartPack_Item__c, Unit_Price__c, 
                                 Unit_of_Measure__c, Child_ID__c, 
                                 Oracle_Line_Type__c, Item_Source__c, 
                                 Oracle_Warehouse__c, Requested_Delivery_Date__c, 
                                 Parent_Item__c, Parent_Item__r.Item_ID__c, Safe_Harbor_ITEM__c
                                 ,Vendor_Name__c,Partner_Role__c     
                                 FROM Purchase_Order_Lines__r ORDER BY Item_ID__c, Quantity__c ASC) 
                                FROM Purchase_Order__c 
                                WHERE Id =: strPOId];
        /***** Start: Reordering POL *****/                          
        List<Purchase_Order_Line__c> polDC = po.Purchase_Order_Lines__r.deepClone(true, false, true);
        //List<Purchase_Order_Line__c> polDC = new List<Purchase_Order_Line__c>();
        //polDC.addall(po.Purchase_Order_Lines__r);
        List<Purchase_Order_Line__c> tempPOLDC = new List<Purchase_Order_Line__c>();
        
        //JAJA Fix Multiple PO Lines MAY 12, 2015 
        for(Purchase_Order_Line__c allPol : polDC)
        {       
            
            for(Purchase_Order_Line__c childPOL : polDC)
            {         
                
                
                if(childPOL.Parent_Item__r.Item_ID__c == allPol.Item_ID__c)
                {
                    Boolean isPresentP = false; 
                    Boolean isPresentC = false;
                    
                    for(Purchase_Order_Line__c parPOL: tempPOLDC)
                    {        
                        if( allPol.Id == parPOL.Id )
                        {
                            isPresentP = true;
                        }      
                        if( childPOL.Id == parPOL.Id )
                        {              
                            isPresentC = true;             
                        }   
                    } 
                    if(!isPresentP && !isPresentC )
                    { 
                        tempPOLDC.add(allPol);       
                        tempPOLDC.add(childPOL);
                    }
                    
                }  
                
                
            }
            
        }
        //JAJA Fix Multiple PO Lines MAY 12, 2015 
        
        
        if(!polDC.isEmpty() || !tempPOLDC.isEmpty())
        {
            for(Purchase_Order_Line__c pol: polDC)
            {
                Boolean isPresent = false;
                for(Purchase_Order_Line__c tempPol: tempPOLDC)
                {
                    if(pol.Id == tempPol.Id)
                        isPresent = true;
                }   
                
                if(!isPresent)
                    tempPOLDC.add(pol);
                
            }
        }
        if(!orderedPOLList.isEmpty()) orderedPOLList.clear();
        orderedPOLList = tempPOLDC;        
        /***** End: Reordering POL *****/                            
        return po;                              
    }//End Func FetchData
    
    /*****
Check for Expedited Delivery Charges, if applicable enable Accept_Expedited_Delivery_Charges__c and set to true
*****/
    public void Foxing()
    {  
        if(!SSDwithin3DaysTheaterSet.isEmpty() && !SSDwithin3DaysTheaterSet.contains(propPurchaseOrder.Dealer_Account__r.Theater__c)){
            if(propPurchaseOrder.Requested_Delivery_Date__c != null && propPurchaseOrder.Requested_Delivery_Date__c > Date.today().addDays(3))
                propPurchaseOrder.Accept_Expedited_Delivery_Charges__c = false;
            else if(propPurchaseOrder.Requested_Delivery_Date__c != null && propPurchaseOrder.Requested_Delivery_Date__c <= Date.today().addDays(3))
                propPurchaseOrder.Accept_Expedited_Delivery_Charges__c = true;
        }
        
        Datetime dt = DateTime.newInstance(propPurchaseOrder.Requested_Delivery_Date__c, Time.newInstance(0, 0, 0, 0));
        dayOfWeek = dt.format('EEEE');
    }//End Func Foxing
    /*** END FUNCTION ***/
    
    //START - Update Purchase order after every switch tab 
    public void updatePOrder(boolean updateList, String status)
    {
        if(propPurchaseOrder.ID != null && status != '' && status == 'New') 
        {
            //propPurchaseOrder.Order_Status__c = 'New';
            update  propPurchaseOrder;
        }
        else if(propPurchaseOrder.ID != null && status != '' && status == 'Submitted')
        {
            propPurchaseOrder.Order_Status__c = 'Submitted';
            //Updating Interface Status to New when the order is Submitted.
            propPurchaseOrder.Interface_Status__c = 'New';
            propPurchaseOrder.PO_Submit_Date__c = System.Now();
            update  propPurchaseOrder;   
            Account acc = new Account(id=propPurchaseOrder.End_Customer_Account__c, Lease_Order_Placed__c=true);
            update acc;   
        }      
    }//End Func updatePOrder
    // END FUNCTION - updatePOrder()
    
    public PageReference SavePOFinancier()
    {
        bFinancierChanged = false;
        if(creditCheckStatus != 'Approved' && propPurchaseOrder.Opportunity__r.Account.BillingCountry != 'France')
        {
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Customer\'s Credit Check is not passed yet! Purchase Order can not be submitted.');
            ApexPages.addMessage(errorMsg);
            return null;          
        } 
        if(propPurchaseOrder.Financier__c == null)
        {
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Financier.');
            ApexPages.addMessage(errorMsg);
            return null;          
        }     
        if(propPurchaseOrder.ID != null && propPurchaseOrder.Order_Status__c != '' && propPurchaseOrder.Order_Status__c != 'New')// && propPurchaseOrder.Order_Status__c == 'Submitted')
        {
            
            update  propPurchaseOrder;
            bFinancierChanged = true;
        }
        return null;
    }//return SavePOFinancier
    
    /*****
check for Expedited Delivery Date difference and hence Charges
**/
    //START FUNCTION
    public void calcDayDifference()
    {      
        if(userCurrentTime != null && propPurchaseOrder!= null && propPurchaseOrder.Requested_Delivery_Date__c !=null)
        {
            Date dateToCheck = Date.newInstance(userCurrentTime.yearGMT(),userCurrentTime.monthGMT() ,userCurrentTime.dayGMT());
            Date userCurrentDate = Date.newInstance(userCurrentTime.yearGMT(),userCurrentTime.monthGMT() ,userCurrentTime.dayGMT());
            Integer checkHours = 13;
            
            if(userCurrentTimeHour < checkHours)
                dateToCheck = PriceListItemUtilityLease.getNextWorkingDate(dateToCheck,2);
            else
                dateToCheck = PriceListItemUtilityLease.getNextWorkingDate(dateToCheck,3);
            
            if(dateToCheck >= propPurchaseOrder.Requested_Delivery_Date__c && propPurchaseOrder.Requested_Delivery_Date__c >= Date.Today())
            {
                //isShowCheckbox =true;
                //propPurchaseOrder.Delivery_Charges__c = <assign expedite fee >
            }
            else
            {
                //isShowCheckbox =false;
                propPurchaseOrder.Accept_Expedited_Delivery_Charges__c =false;
                propPurchaseOrder.Delivery_Charges__c = 0.0;
            }
        }
    }//End Func calcDayDifference
    
    public void SavePOFinancierDummy()
    {
        bFinancierChanged = false;
    }//End Func SavePOFinancierDummy
    
    //END FUNCTION

    public PageReference comparePOs() {
        PageReference pr = new PageReference(poDeltaURL);
        pr.setRedirect(true);
        return pr;
    }
    
    /***** WRAPPER *****/
    /*** END WRAPPER ***/
}//End Class LeaseOrderWizardInternal