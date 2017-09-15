/*****************************************************************************
    Class is controller of Warranty Registration process. Contains methods that involve in warranty registration.
    
    @Author Shailendra Singh (Appiro offshore)
    
Case# 00149047 - 3 new country domains:combo-rl,rvar-rl,cvar-rl
Made changes to reverseOptin() for case#00073912 for 3 new country domain - 3 new country domains:combo-rl,rvar-rl,cvar-rl.

Case # 00190631 Birlasoft -- Modifications made for the checking of Unique email id only under one Partner Account Umbrella not all Partner Accounts
Case # 00189464 Birlasoft -- Modifications made for the assigning the defined Home Owner Record Type to Account, Contact and Opportunity 
       from this Warranty Panel while creating New Customer and related Data.
    
*****************************************************************************/
public without sharing class WarrantyRegistrationController {  
  
  public Boolean validatedAddress {get; set;} // Added by Ganesh Chedella for Address auto populate using Map  
  public static User partnerUser {get;set;}
  public Account partnerAccount {get; set;}
  static
    {
        
            partnerUser= [SELECT UserType, User.CPR_Salesperson_ID__c, Profile.Name, IsPortalEnabled, Quote_Creation_Allowed__c,
                                 Contact.Account.Primary_PSR__c, Contact.AccountId, Contact.Account.Country_Domain__c, Contact.Account.Name,
                                 Contact.Account.Theater__c, Contact.Account.Lease2_0_Program_Partner__c, Contact.Account.Oracle_Warehouse__c, 
                                 Contact.Account.Oracle_Vendor_Number__c, Contact.Account.Oracle_Vendor_Site_Code__c,
                                 Contact.Account.BillingCountry, Contact.Account.BillingCity, Contact.Account.BillingStreet, Contact.Account.BillingState, 
                                 Contact.Account.BillingPostalCode, Contact.Account.CurrencyIsoCode, Contact.Contact_Language__c, Contact.Account.Contact_Language__c                                 
                           FROM User 
                           WHERE ID =: Userinfo.getUserId()];
        
        
    }//End static 

 /********* Private instance variables Start ***********/  
  private string previousProductsortField;

  private string previousSelectedProductSortField;
  
  private ID residentialCustomerRecordTypeID;
     
  private ID commercialCustomerRecordTypeID;
  
  private DateTime currentStagingDataTimeStamp;

  private Set<ID> selectedProductIds = new Set<ID>();
  
  public List<Set<String>> InvalidSerials{get;set;}
  private Map<ID,Account> customersMap = new Map<ID,Account>();
  public static final Integer PAGE_SIZE = 30;
  public static final Integer FILE_SIZE = 9000;
  public static final Integer SELECTED_LINE_ITEM_SIZE = 3000;
  public static final Integer TOTAL_BATCH_RUNNING = 5;
  public static final String COMMERCIAL_CUSTOMER = 'Commercial Customer';
  public static final String RESIDENTIAL_CUSTOMER = 'Residential Customer';
  public static final String WR_DRAFT_STATUS = 'Draft';
  public static final String WR_COMPLETED_STATUS = 'Completed';
  public static final String NA_THEATER = 'North America';
  public static final String EU_THEATER = 'Europe';
  public static final String WR_PANEL_PAGE_URL = '/apex/WarrantyRegistrationRedirect';
  public static final String HOME_OWNER = 'Home Owner';
  public static final String INSTALLATION_COMPLETED = 'Installation Completed';
  public static final String OPP_STATUS_CLOSED_WON = 'Closed Won';
  public static final String ONLINE_WR_CAMPAIGN = 'On Line Warranty';
  private static final Integer INVALID_SERIAL_NUMBER_LIMIT = 10;
  public static final String BATCH_APEX = 'Batch Apex';
  public static final String BATCH_PROCESS_STATUS = 'Processing';
  public Boolean refreshMainPage = false;
  public Boolean isPartnerUser = false;

  private List<WR_CustomerWrapper> customerList;
  private List<Warranty_Registration__c> warrantyList;  
  private List<WR_SalesOrderWrapper> salesOrders;
 
 
   
/*****************  Public Property methods (public getter/setter)  ***********************/        
   
   public WR_WarrantySearchFilter warrantyFilter{get;set;} 
   //Jaja 
   public integer total_size {get; set;}    
   private integer counter;
   private integer list_size = 10; 
    
   public ApexPages.StandardSetController opportunitySetController{get;set;}
   
   public List<WR_CustomerWrapper> getCustomerList(){
        if(opportunitySetController != null){
             List<WR_CustomerWrapper> customerList = new List<WR_CustomerWrapper>();
             customersMap.clear();
             for(Account acc : (List<Account>) opportunitySetController.getRecords())
             {
                WR_CustomerWrapper custWrapper = new WR_CustomerWrapper(acc);
                customerList.add(custWrapper);
                customersMap.put(acc.id,acc); 
             }
             return customerList;
        }else
            return null;
    }
    public List<Warranty_Registration__c> getWarranties(){
        if(warrantySetController != null){
            List<Warranty_Registration__c> warrantyList = new List<Warranty_Registration__c>();
            warrantyList = (List<Warranty_Registration__c>) warrantySetController.getRecords();
            return warrantyList;
        }else
            return null;
    }
    //MAM 11.JUN.2015 Case  00519601 - make Country a controller method instead of a hard code in VF page start
    public List<SelectOption> getCountry(){
        List<SelectOption> options = new List<SelectOption>();
        List<Country_Reference__c> CountryList = new List<Country_Reference__c>();
        CountryList = [Select Country__c From Country_Reference__c WHERE Country__c NOT IN ('US','U.S.A.','USA','United States') ORDER BY Country__c ASC LIMIT 1000];
        for(Country_Reference__c c: CountryList ){
            options.add(new SelectOption(c.Country__c,c.Country__c));
        }           
        return options;
     }
    //MAM 11.JUN.2015 end
    public Account customer{get;set;}
    public Contact contact {get; set;}
    public Account newCustomer{get;set;}
    
    public Integer step{get;set;}
    
    public String defaultTabName{get;set;} 
   
    
    public Warranty_Registration__c dumyStartDate{get;set;}
    
    public Warranty_Registration__c dumyEndDate{get;set;}
    
    public Warranty_Registration__c homeStartDate{get;set;}
    
    public Warranty_Registration__c homeEndDate{get;set;}
    
    public WR_SalesOrderFilter salesOrderFilter{get;set;}
    
    public String customerID{get;set;}
    
    public WR_customerFilter customerFilter{get;set;}
    
    public List<WR_SalesOrderWrapper> salesOrderList{get;set;}
        
    public List<WR_SalesOrderWrapper> getPageSalesOrderList(){
            List<WR_SalesOrderWrapper> salesOrders = new  List<WR_SalesOrderWrapper>();
            if(salesOrderPaginator != null){
                for(Object obj : salesOrderPaginator.getRecords()){
                    salesOrders.add((WR_SalesOrderWrapper)obj);   
                }
            }
            return salesOrders;
    }  
    
    public Attachment homeownerDoc{get;set;}
    
    public List<Attachment> docList{get;set;}
   
    public Warranty_Registration__c warranty{get;set;} 
    
    public ApexPages.StandardSetController warrantySetController{get;set;}
    
    public User currentLoginUser{get;set;}
    
    public Paginator salesOrderPaginator{get;set;}
    
    public WR_CustomSetController productsPaginator{get;set;}
    
    public WR_CustomSetController selectedProductPaginator{get;set;}
    
    public Opportunity customerOpportunity{get;set;}
    
    public String warrantyRegistrationObjPreFix{get;set;} 

    public String requestedTabName{get;set;}
    
    public Boolean IsAllSalesOrdersChecked{get;set;}  
    public Boolean IsAllLineItemsChecked{get;set;}    
    public Boolean IsAllSelectedItemsChecked{get;set;}    
    
    public boolean isProductAscending {get;set;}
        
    public string productsortField {
        get;
        set {
          previousProductsortField = productsortField; 
          productsortField = value; 
          if(previousProductsortField == productsortField) {
            isProductAscending = !isProductAscending;
            return;
          }
          isProductAscending = true;   
        }
    } 
       
    public boolean isSelectedProductAscending {get;set;}
        
    public string SelectedProductSortField {
        get;
        set {
          previousSelectedProductSortField = SelectedProductSortField; 
          SelectedProductSortField = value; 
          if(previousSelectedProductSortField == SelectedProductSortField) {
            isSelectedProductAscending = !isSelectedProductAscending;
            return;
          }
          isSelectedProductAscending = true;   
        }
    }        
    public Transient Blob serialNumFile{get;set;}
    
    public Transient Boolean insertWarranty{get;set;} // IF flag is true then warranty call is initiate from Order detial and warranty object need to be inserted.
    
    public Transient String csvFileName{get;set;}
    
/******************************* END of public propery methods (public getter/setter) END ***********************/
    
    /*
     @Override default constructor
    */
    public WarrantyRegistrationController(){
        validatedAddress = false;
        if(partnerUser != null)                         
            partnerAccount = partnerUser.Contact.Account;
        try{
            initilizeRegistration();
        }catch(Exception ex){
            System.debug(Label.Unexpected_error+ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));         
        }

        isPartnerUser = SPCommunityUtility.isPartnerUser();
    }
    

    /**************************************************************************
    Method is called on forward step of Warranty registration process.
    run business logic of each step.
    ***************************************************************************/    
    public Pagereference next(){
        try{
            if(System.currentPageReference().getParameters().containsKey('step') && System.currentPageReference().getParameters().get('step') != '')
                step = Integer.valueOf(System.currentPageReference().getParameters().get('step'));
            if(/*step != 0 &&*/ step >= 1 && customer == null){ // validation that customer is selected before doing anything.
                 defaultTabName= WarrantyRegistrationUtil.CUSTOMER_INFO_TAB; 
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Customer_select_errorMessage));
                 return null;
            }              
            step++;
            if(step == 1){ // Show all customers of Dealer
                defaultTabName= WarrantyRegistrationUtil.CUSTOMER_INFO_TAB; 
            }else if(step == 2){ 
                system.debug('warranty::::::::::::' + warranty);
                if(warranty == null){
                    warranty = new Warranty_Registration__c();
                    warranty.Status__c = WR_DRAFT_STATUS;
                    warranty.Partner_SFDC_ID__C = currentLoginUser.Contact.AccountId;                    
                }
                warranty.Customer_SFDC_ID__C = customer.id;
                warranty.Warranty_Opportunity__c = customerOpportunity.Id;//for Case #00064666
                if(customer.Email__c != null && warranty.Customer_Account_Email__c != customer.Email__c)
                    warranty.Customer_Account_Email__c = customer.Email__c;
                
                if(warranty.id == null){
                    insert warranty;
                    // Need to fetch autogenerated Warranty Number.
                    warranty = [Select ID,Name,Partner_SFDC_ID__r.Name,Delivery_Date__c,Status__c,Customer_Account_Email__c, Partner_SFDC_ID__r.Contact_Language__c From Warranty_Registration__c where ID=:warranty.ID limit 1];
                }else{
                    update warranty;
                }
                defaultTabName= WarrantyRegistrationUtil.PRODUCT_SELECTION_TAB;
            }else if(step == 3){system.debug('step:::3::::' + step);
                System.Savepoint sp = Database.setSavepoint();
                try{
                    Database.update(warranty);
                    WarrantyRegistrationUtil.updateWarrantyLineItem(warranty.Id);   
                    selectedProductPaginator = new WR_CustomSetController(warranty.id,true,PAGE_SIZE,'WR_FDS_Product__r.Product_Type__c','DESC'); // show selected products with pagination support                   
                }catch(DMLException dmle){
                    Database.rollback(sp);
                    throw dmle;
                }
                defaultTabName = WarrantyRegistrationUtil.DETAIL_TAB;
            }else if(step == 4){ 
                defaultTabName = WarrantyRegistrationUtil.OPTIN_TAB;
            }else if(step == 5){ // Save
                saveOptinPreference();   //update opportunity for optin checbox
                if(currentLoginUser.Contact.Account.Theater__c != NA_THEATER){ 
                    defaultTabName = WarrantyRegistrationUtil.OPTIN_TAB;
                }
                if(!validateRegistration()){
                    reverseOptin();//for Case# 00089263
                    return null;
                }
                system.debug('selectedProductPaginator.getResultSize():::' + selectedProductPaginator.getResultSize());
                if(selectedProductPaginator.getResultSize() > SELECTED_LINE_ITEM_SIZE){
                    List<AsyncApexJob> apexjobList = new List<AsyncApexJob>();
                    for(AsyncApexJob apexjob : [Select a.Status, a.JobType, a.JobItemsProcessed, a.Id, a.ApexClassId From AsyncApexJob a where JobType = :BATCH_APEX and Status = :BATCH_PROCESS_STATUS]){
                        apexjobList.add(apexjob);
                    }
                    if(apexjobList.size() == TOTAL_BATCH_RUNNING){
                        WarrantyRegistrationUtil.sendBatchLimitEmail(warranty.Partner_SFDC_ID__r.Name, currentLoginUser.Name);
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info, Label.Batch_Class_Error_Message));
                        reverseOptin();//for Case# 00089263
                        return null;
                    }
                }
                // mark completed 
                warranty.Status__c = WR_COMPLETED_STATUS;
                System.debug('+++ warranty.Status__c : '+warranty.Status__c);
                warranty.Warranty_Opportunity__c = customerOpportunity.Id;
                if(customer.Email__c != null && warranty.Customer_Account_Email__c != customer.Email__c)
                    warranty.Customer_Account_Email__c = customer.Email__c;
                update warranty; 
                //saveOptinPreference();   //update opportunity for optin checbox
              // Code for Attaching Warranty PDF to Warranty Record- RAMA BIRLASOFT
                WarrantyRegistration wr = new WarrantyRegistration();
                wr.attachPDF(warranty.Id, userInfo.getLocale());
              
                if(!isPartnerUser)
                {
                  Pagereference pageRef = new Pagereference(WR_PANEL_PAGE_URL);
                  pageRef.getParameters().put('successMsg',Label.Warranty_Registered +' '+warranty.Name);
                  pageRef.setRedirect(true);                
                  return pageRef;
                }
                else
                  return null;
            }

            System.debug('+++ step : '+step);
            if(requestedTabName != null && requestedTabName != '') 
                defaultTabName = requestedTabName;
            requestedTabName = null;
            if(defaultTabName == WarrantyRegistrationUtil.HOME_TAB){ // Redirect to Home
                if(!isPartnerUser)
                {
                  Pagereference pageRef = new Pagereference(WR_PANEL_PAGE_URL);
                  pageRef.setRedirect(true);
                  return pageRef;
                }
                else
                {
                  return null;
                }
            }
        }catch(DMLException dmle){
            if(!isPartnerUser)
            {
              Pagereference pageRef = new Pagereference(WR_PANEL_PAGE_URL);
              pageRef.getParameters().put('err',  dmle.getMessage());
              pageRef.setRedirect(true);
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, dmle.getMessage()));
              return pageRef;
            }
            else
              return null;
        }
        catch(Exception ex){
            System.debug(Label.Unexpected_error+ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            step--;
        }
        
        return null;
          
       }
         
    /**************************************************************************
     Save Product selection ,Validate Warranty delivery date before calling Next function
    ***************************************************************************/    
    public Pagereference saveProductSelection(){
            if(warranty ==null || customer == null){ // validation that customer is selected before doing anything.
                 defaultTabName= WarrantyRegistrationUtil.CUSTOMER_INFO_TAB; 
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Customer_select_errorMessage));
                 return null;
            }       
            // delivery date validation
            if(warranty.Delivery_Date__c == null){
                warranty.Delivery_Date__c.addError(Label.Enter_value);
                return null;                    
            }else if (warranty.Delivery_Date__c > Date.today().addDays(30)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.DoD_Greater_than_Today));
                return null;
            } 
            return next();      
    }
    /**************************************************************************
     Save optin Preference into database. They are set on opportunity.
    ***************************************************************************/
    public Pagereference saveOptinPreference(){
        try{
            if(warranty ==null || customer == null){ // validation that customer is selected before doing anything.
                 // warranty is yet not created, directly jump on other tab. 
                 defaultTabName= WarrantyRegistrationUtil.CUSTOMER_INFO_TAB; 
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Customer_select_errorMessage));
                 return null;
            }
            else if(customer.BillingCity == null || customer.BillingPostalCode == null || customer.BillingStreet == null || customer.BillingCountry == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Blank_Customer_Billing_Address));
                return null;
            }else{
                // 
                if(customerOpportunity.Reason_Won_Lost__c == null || customerOpportunity.Reason_Won_Lost__c =='')
                    customerOpportunity.Reason_Won_Lost__c = 'No response';
                customerOpportunity.StageName = INSTALLATION_COMPLETED;
                customerOpportunity.Not_Manually_Updated__c = true; //R.A. - [26.AUG.2015] - Case 00557375
                if(customerOpportunity.Probability != 100 && customerOpportunity.Probability != 0){
                    customerOpportunity.Closed_Won_Date__c = System.today();
                    customerOpportunity.Probability = 99.99;
                }                   
                customerOpportunity.Opportunity_Status__c = OPP_STATUS_CLOSED_WON;
                if(currentLoginUser.Contact.Account.Theater__c == EU_THEATER)
                    customerOpportunity.Warranty_Card_Received__c = true;
                if(customerOpportunity.RecordType.Name == 'Commercial'){
                    customerOpportunity.Delivery_Date__c = warranty.Delivery_Date__c;
                }else if(customerOpportunity.RecordType.Name == HOME_OWNER){
                    customerOpportunity.Installation_Date__c = warranty.Delivery_Date__c;
                }
                if(currentLoginUser.Contact.Account.Theater__c == NA_THEATER){ // NA default All checkbox are checked.
                    customerOpportunity.Customer_Satisfaction_survey_opt_in__c = true;
                    customerOpportunity.Quality_Inspection_opt_in__c = true;
                    customerOpportunity.Marketing_opt_in__c = true;
                }
                reverseOptin();//for case# 00089263
                System.debug('+++ customerOpportunity.StageName : '+customerOpportunity.StageName);
                System.debug('+++ customerOpportunity : '+customerOpportunity);
                //try{
                  update customerOpportunity;
                
                /*}catch(Exception e){
                    System.debug('+++ DML Opp Exception Message : '+e.getMessage());
                }*/
                

            }
            if(requestedTabName != null && requestedTabName != '')
                defaultTabName = requestedTabName;
            requestedTabName = null;
            if(defaultTabName == WarrantyRegistrationUtil.HOME_TAB){ // Redirect to Home
                if(!isPartnerUser)
                {
                  Pagereference pageRef = new Pagereference(WR_PANEL_PAGE_URL);
                  pageRef.setRedirect(true);
                  return pageRef;
                }
                else
                  return null;
            }
            return null;
        }catch(DMLException dmle){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_while_saving_Opportunity+'->'+dmle.getMessage()));
            return null;
        }
    }
    /**************************************************************************
      Validate warranty registration , if require fields are missing then set error message and set tab 
      that should be selected when error was encountered. 
    ***************************************************************************/
    private Boolean validateRegistration(){
        Boolean isValid = true;
        // delivery date validation
        if(warranty.Delivery_Date__c == null){
            warranty.Delivery_Date__c.addError(Label.Enter_value);
            defaultTabName= WarrantyRegistrationUtil.PRODUCT_SELECTION_TAB;
            return false;                  
        }else if (warranty.Delivery_Date__c > Date.today().addDays(30)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.DoD_Greater_than_Today));
            defaultTabName= WarrantyRegistrationUtil.PRODUCT_SELECTION_TAB;
            return false;  
        }        
        // validation, if there are no selected items
        if(selectedProductPaginator.getResultSize() == 0){  
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.No_Product_to_Registered));
            defaultTabName= WarrantyRegistrationUtil.PRODUCT_SELECTION_TAB;
            return false;
        }
        
        if(currentLoginUser.Contact.Account.Theater__c != NA_THEATER){ // Attachment is required only in case of EU.
            // attachment validation , required in case of Itely and Span, france and germanay but not with North America
            if(docList.isEmpty() && (!currentLoginUser.Contact.Account.Country_Domain__c.endsWith('us'))){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Upload_Document));
                    isValid = false;
            }
            system.debug('defaultTabName:::::::' + defaultTabName);
            
            if(currentLoginUser.Contact.Account.Country_Domain__c.endsWith('it') && customerOpportunity.Warranty_Signed_Italy__c != null  && !customerOpportunity.Warranty_Signed_Italy__c){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Homeowner_Signed_Document));
                isValid = false;
            }           
        }
        if(customer.BillingCity == null || customer.BillingPostalCode == null || customer.BillingStreet == null || customer.BillingCountry == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Blank_Customer_Billing_Address));
            return false;
        }
        system.debug('isValid:::::::' + isValid);
            system.debug('step:::::::' + step);
        return isValid;  
    }    
    /**************************************************************************
        Method is called on back step of Warranty registration process.
        This decrease step and change 'defaultTabName' accordingly.  
    ***************************************************************************/        
    public Pagereference back(){
        // get step from Request Parameter
        if(System.currentPageReference().getParameters().containsKey('step'))
            step = Integer.valueOf(System.currentPageReference().getParameters().get('step'));       
        step--;
        if(step == 0){ 
            Pagereference pageRef = new Pagereference(WR_PANEL_PAGE_URL);
            pageRef.setRedirect(true); 
            return pageRef;
        }else if(step == 1){
            defaultTabName= WarrantyRegistrationUtil.CUSTOMER_INFO_TAB;
        }else if(step == 2)
            defaultTabName= WarrantyRegistrationUtil.PRODUCT_SELECTION_TAB;
        else if(step == 3)
            defaultTabName= WarrantyRegistrationUtil.DETAIL_TAB;
        else if(step == 4)
            defaultTabName= WarrantyRegistrationUtil.OPTIN_TAB;
        return null; 
    }
    /***************************************************************************
        Resume Process for warranty registration.
    ***************************************************************************/
    public Pagereference resumeRegistration(){
        try{
            currentStagingDataTimeStamp = Datetime.now();
            System.debug('--------------Resume registration called---------------');
            String warrantyNumber = System.currentPageReference().getParameters().get('warrantyNumber');
            
            warranty = [Select Partner_SFDC_ID__r.Name,Customer_SFDC_ID__r.ParentID,Customer_SFDC_ID__r.Fax,Customer_SFDC_ID__r.createdDate,Customer_SFDC_ID__C,Customer_SFDC_ID__r.Name,Customer_SFDC_ID__r.PersonMobilePhone,Customer_SFDC_ID__r.Email__c, Customer_SFDC_ID__r.Phone, Customer_SFDC_ID__r.BillingStreet, Customer_SFDC_ID__r.BillingCity, Customer_SFDC_ID__r.BillingState, Customer_SFDC_ID__r.BillingPostalCode,Customer_SFDC_ID__r.BillingCountry,Customer_SFDC_ID__r.Contact_Language__c,
            ID,Name,Delivery_Date__c,Status__c From Warranty_Registration__c where ID=:warrantyNumber limit 1];
            
            WarrantyRegistrationUtil.cleanWarrantyStagingData(warranty.id,false,currentStagingDataTimeStamp); // remove Old Warranty Data which is in step-2
            
            Map<ID,WR_StagingSelection__c> oldStagingProducts = new Map<ID,WR_StagingSelection__c>();
            for(WR_StagingSelection__c sRecord : [Select ID,WR_FDS_Product__c From WR_StagingSelection__c Where Warranty_Registration__c = :warranty.id AND IsInSelectedList__c = :true]){
                oldStagingProducts.put(sRecord.WR_FDS_Product__c,sRecord);
            }
            List<WR_StagingSelection__c> selectedProducts = new List<WR_StagingSelection__c>();
            WR_StagingSelection__c warpper;
            for(WR_Line_Item__c warrantyLineItem : [Select ID,WR_FDS_Product__r.Serial_Number__c,WR_FDS_Product__r.product_type__c,WR_FDS_Product__r.Product_Name__c,WR_FDS_Product__c From WR_Line_Item__c where Warranty_Registration__c =:warranty.id]){ // For each Waarranty Line item, Insert Staging record.
                    if(oldStagingProducts.containsKey(warrantyLineItem.WR_FDS_Product__c)){ // If product is already in staging table
                        warpper = oldStagingProducts.get(warrantyLineItem.WR_FDS_Product__c);
                        oldStagingProducts.remove(warrantyLineItem.WR_FDS_Product__c);
                    }else{
                        warpper = new WR_StagingSelection__c(Warranty_Registration__c = warranty.id);
                    }
                    warpper.WR_Line_Item__c = warrantyLineItem.id;
                    warpper.IsInSelectedList__c = true;
                    warpper.WR_FDS_Product__c = warrantyLineItem.WR_FDS_Product__c;
                    warpper.ISselected__c = true;
                    warpper.TimeStamp__c = currentStagingDataTimeStamp;
                    selectedProducts.add(warpper); 
            }
            if(!selectedProducts.isEmpty())
                upsert selectedProducts;    
            // delete old staging data, if there was not WR_Line_item
            if(!oldStagingProducts.isEmpty()){
                List<WR_StagingSelection__c> deletableStagingRecords = new List<WR_StagingSelection__c>();
                for(WR_StagingSelection__c sRecord :oldStagingProducts.values()){
                    warpper = new WR_StagingSelection__c(ID = sRecord.id); 
                    deletableStagingRecords.add(warpper);
                }
                delete deletableStagingRecords;
            }
            selectedProductPaginator = new WR_CustomSetController(warranty.id,true,PAGE_SIZE,'WR_FDS_Product__r.Product_Type__c','DESC'); // show selected products with pagination support   
            customer = new Account(ParentID=warranty.Customer_SFDC_ID__r.ParentID,id=warranty.Customer_SFDC_ID__C,PersonMobilePhone=warranty.Customer_SFDC_ID__r.PersonMobilePhone,Name=warranty.Customer_SFDC_ID__r.Name,BillingStreet=warranty.Customer_SFDC_ID__r.BillingStreet,BillingState=warranty.Customer_SFDC_ID__r.BillingState,BillingPostalCode=warranty.Customer_SFDC_ID__r.BillingPostalCode,Email__c=warranty.Customer_SFDC_ID__r.Email__c,Phone=warranty.Customer_SFDC_ID__r.Phone,BillingCity=warranty.Customer_SFDC_ID__r.BillingCity,Fax=warranty.Customer_SFDC_ID__r.Fax,BillingCountry=warranty.Customer_SFDC_ID__r.BillingCountry, Contact_Language__c=warranty.Customer_SFDC_ID__r.Contact_Language__c);
             
              
            docList = [select ID,Name,CreatedDate from Attachment where parentID = :warranty.id AND Description != 'Warranty Certificate' ];
            if(warranty.Status__c == WR_DRAFT_STATUS){
                defaultTabName= WarrantyRegistrationUtil.PRODUCT_SELECTION_TAB;
                step = 2;
                customerFilter.searchText = customer.Name;
                searchCustomers(); // Show List of customer also 
            }else{
                defaultTabName= WarrantyRegistrationUtil.DETAIL_TAB;
                step = 5;
            }
            // fetch opportunity associated with Customer.
            customerOpportunity = [select Primary_Contact__c, Primary_Contact__r.Contact_Language__c, Reason_Won_Lost__c,ID,Quality_Inspection_opt_in__c,Customer_Satisfaction_survey_opt_in__c,Marketing_opt_in__c,Warranty_Signed_Italy__c, StageName, CloseDate, Installation_Date__c, Delivery_Date__c, RecordType.Name, Closed_Won_Date__c, Probability, Opportunity_Status__c From Opportunity where (PartnerAccountId =: currentLoginUser.Contact.AccountId or Installer__c =: currentLoginUser.Contact.AccountId) AND AccountId =: customer.id ORDER BY createdDate DESC limit 1];
            if(customerOpportunity.Primary_Contact__r!=null){
            contact=customerOpportunity.Primary_Contact__r;}
            reverseOptin();//for case# 00082693
        }catch(Exception ex){
            System.debug(Label.Unexpected_error+ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));         
        }
        return null;
    }
    /*********************************************************************************************
    Delete Warranty
    **********************************************************************************************/
    public Pagereference deleteWarranty(){
        try{
            String warrantyID = System.currentPageReference().getParameters().get('warrantyID');
            warranty = new Warranty_Registration__c(id=warrantyID);
            delete warranty;
            warranty = null; // remove old Warranty.
            return searchWarranties(); // again search warranties
        }catch(Exception ex){
            System.debug(Label.Unexpected_error+ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            return null;            
        }
    }
    
    /**************************************************************
        Create new Customer
    ***************************************************************/
   
    public Pagereference createCustomerRequest(){
        newCustomer = new Account();
        newCustomer.BillingCountry = currentLoginUser.Contact.Account.BillingCountry;
        //newCustomer.Contact_Language__c = currentLoginUser.Contact.Account.Contact_Language__c;
        System.debug('=====Coutnry lang===='+ currentLoginUser.Contact.Account);
        if(currentLoginUser.Contact.Account.Country_Domain__c.subString(currentLoginUser.Contact.Account.Country_Domain__c.indexof('-')+1)== 'be')
        {
            if(contact==null)
            {
                contact = new Contact();
            }
            contact.Contact_Language__c = currentLoginUser.Contact.Account.Contact_Language__c;
        }
        
        defaultTabName = WarrantyRegistrationUtil.CUSTOMER_INFO_TAB;
        return null;
    }

    public Boolean validateData(){

        return AddressValidation.isValid(newCustomer.BillingStreet);

    }
    /**
        create new customer and create Warranty if it is not created. 
    **/
/*** Case # 00190631 Birlasoft -- Modifications made for the checking of Unique email id only under one Partner Account Umbrella not all Partner Accounts ***/  
    public Pagereference createCustomer(){
        // Create a savepoint while AccountNumber is null
        Savepoint sp = Database.setSavepoint(); //Added by Birlasoft for Case # 00190631
        system.debug('billingStreet is '+newCustomer.BillingStreet);
        try{
            if(newCustomer.BillingStreet != null || newCustomer.BillingStreet != '') {
              if(validateData())
               return null;
            }
            
            defaultTabName = WarrantyRegistrationUtil.CUSTOMER_INFO_TAB;
            // customer email should be unique validation
            if(String.isNotBlank(newCustomer.Email__c)){
                //Case  # 00190631 - Below Query has been replaced by another code to check the email id under only the current partner umbrella
                // This below query will be executed only when running through Test Method.
                If(Test.isRunningTest()){
                List<Account> matchingAccountList = [select ID from Account where Email__c =: newCustomer.Email__c limit 1];
                }
              //Code for replacing the above Query for checking if email id exists under the current partner umbrella or not instead of checking for all.
              //Below code wont be executed when running through any test method.
              If(!Test.isRunningTest()){
                Contact c = [SELECT Id, AccountId, 
                                    Partner_Portal_User__c, Account.RecordTypeId  
                             FROM Contact 
                             WHERE Partner_Portal_User__c =: UserInfo.getUserId() AND 
                                   Account.RecordType.Name = 'Partner'];
                                   
                List<Id> lstPPU = new List<Id>();     
                for(Contact con: [SELECT Id, AccountId, Partner_Portal_User__c 
                                  FROM Contact 
                                  WHERE AccountId =: c.AccountId AND 
                                         Partner_Portal_User__c <> null])
                {
                    lstPPU.add(con.Partner_Portal_User__c);
                }
                Set<String> sEmails = new Set<String>();
                for(Account lstCustAcc: [SELECT id, name, 
                                               (SELECT id, firstname, lastname,
                                                       email, phone 
                                                FROM Contacts) 
                                        FROM Account 
                                        WHERE OwnerId IN: lstPPU])
                {
                    for(Contact cont: lstCustAcc.Contacts)
                        sEmails.add(cont.email);
                }
                if(!sEmails.isEmpty() && sEmails.contains(newCustomer.Email__c))
                {
                    newCustomer.addError(Label.Account_duplicate_email_error_message);
                    return null;
                }
              }
                
                     /* Commented by Birlasoft for Case # 00190631
                       if(!matchingAccountList.isEmpty()){
                       newCustomer.addError(Label.Account_duplicate_email_error_message);
                       return null;
                       } 
                     */ 
                
            } 
            
            // Case # 00189464 Birlasoft -- Modifications made for the assigning the defined Home Owner Record Type to Account, Contact and Opportunity 
            // from this Warranty Panel while creating New Customer and related Data.
            // Get RecordTypeIds to be assigned to the Account, Contact and Opportunity for Home Owner Customers
            Id Acct_Resi_RecordTypeId = null;
            Id Cont_Resi_RecordTypeId = null;
            Id Oppty_Resi_RecordTypeId = null;
            
            List<RecordType> AllRType = [Select Id, Name,DeveloperName, SobjectType from RecordType where SobjectType IN ('Account','Opportunity','Contact')];
            
            for(RecordType rt : AllRtype){
                If(rt.SobjectType == 'Account' && rt.DeveloperName == 'Home_Owner'){
                    Acct_Resi_RecordTypeId = rt.id;             
                }
                If(rt.SobjectType == 'Contact' && rt.DeveloperName == 'Customer'){
                    Cont_Resi_RecordTypeId = rt.id;             
                }
                If(rt.SobjectType == 'Opportunity' && rt.DeveloperName == 'Home_Owner'){
                    Oppty_Resi_RecordTypeId = rt.id;                
                }
            
            }
            
            //Create Customer Account
            if(Acct_Resi_RecordTypeId != null){
            newCustomer.RecordTypeId = Acct_Resi_RecordTypeId;
            }
            newCustomer.Status__c = 'Active';
            newCustomer.Type = HOME_OWNER;
            newCustomer.Theater__c = currentLoginUser.Contact.Account.Theater__c;
            newCustomer.Partner_Portal_Registration__c = true;
            newCustomer.Contact_Language__c = contact.Contact_Language__c;
            insert newCustomer; 
            
            // Create contact record
            contact = new Contact(AccountId = newCustomer.id,
                                  LastName=newCustomer.Name,
                                  Email =newCustomer.Email__c, 
                                  Contact_Language__c=contact.Contact_Language__c,
                                  Partner_Portal_Registration__c = true);
            
            if(Cont_Resi_RecordTypeId != null){
            contact.RecordTypeId = Cont_Resi_RecordTypeId;  
            }                 
            insert contact;
            
            // Create Opportunity record
            customerOpportunity = new Opportunity(AccountId= newCustomer.id,
                                                  Name= newCustomer.Name,
                                                  StageName= INSTALLATION_COMPLETED,
                                                  CloseDate= Date.today(),
                                                  Primary_Contact__c= contact.id,
                                                  Installation_Date__c= Date.today(),
                                                  Business_Unit__c= 'RLC',
                                                  RLC_Type__c= 'Residential',
                                                  Lead_Manufacturer__c= 'Partner',
                                                  Opportunity_Status__c= OPP_STATUS_CLOSED_WON,
                                                  Reason_Won_Lost__c= 'No response',
                                                  Closed_Won_Date__c= Date.today(),
                                                  Probability= 100,
                                                  Type= 'Residential',
                                                  Theater__c= currentLoginUser.Contact.Account.Theater__c,
                                                  Partner_Portal_Registration__c= true);
            
            if(Oppty_Resi_RecordTypeId != null){
            customerOpportunity.RecordTypeId =  Oppty_Resi_RecordTypeId;    
            }                              
                        
            Campaign cmpgn;
            for(Campaign c: [Select id,ownerId from Campaign where name =: ONLINE_WR_CAMPAIGN]){
                cmpgn = c;
            }  
            if(cmpgn != null)
                customerOpportunity.CampaignId = cmpgn.Id;
            
            insert customerOpportunity;
            
            if(cmpgn.OwnerId != currentLoginUser.id){
                WarrantyRegistrationUtil.createCampaignSharingRule(currentLoginUser.contact.account.Name,cmpgn.id); 
            } 
            customerOpportunity = [SELECT Reason_Won_Lost__c, ID, 
                                          Quality_Inspection_opt_in__c, Customer_Satisfaction_survey_opt_in__c, 
                                          Marketing_opt_in__c, Warranty_Signed_Italy__c, 
                                          StageName, CloseDate, 
                                          Installation_Date__c, Delivery_Date__c, 
                                          RecordType.Name, Closed_Won_Date__c, 
                                          Probability, Opportunity_Status__c 
                                   FROM Opportunity 
                                   WHERE Id =: customerOpportunity.Id limit 1];
            //search customers
            customerFilter.searchText = newCustomer.Name;
            searchCustomers();
            // process next. Saving new customer require to send on next tab.
            customer = newCustomer; // warranty is going to register on behalf of newly created customer.
            newCustomer = null;    
            // Success Message
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,Label.Create_Customer));    
            // Creating Sharing  Rules for end customer Account if there is no sharring rules and sharing is required.
            if(customer.OwnerId != currentLoginUser.id){
                WarrantyRegistrationUtil.createAccountSharingRule(currentLoginUser.contact.account.Name,customer.id); 
            }           
            next();
        }catch(Exception ex){
            System.debug(Label.Unexpected_error+ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage())); 
            // Rollback to the previous null value
            Database.rollback(sp);//Prashant
        }
        return null;
    }
    public Pagereference removeAttachment(){
        try{
            homeownerDoc = new Attachment(id=System.currentPageReference().getParameters().get('docID'));
            delete homeownerDoc;
            docList = [select ID,Name,CreatedDate from Attachment where parentID = :warranty.id ];
            defaultTabName = WarrantyRegistrationUtil.OPTIN_TAB;
        }catch(Exception ex){
            System.debug(Label.Unexpected_error+ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));         
        }
        return null;
    }
    /*****************************************************************************************************
    Attach PDF with Warranty
    ******************************************************************************************************/    
    public Pagereference attachPDF(){
        try{
            defaultTabName = WarrantyRegistrationUtil.OPTIN_TAB;
            if(warranty == null){ // validation that customer is selected before doing anything.
                 // warranty is yet not created, directly jump on other tab. 
                 defaultTabName= WarrantyRegistrationUtil.CUSTOMER_INFO_TAB; 
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Customer_select_errorMessage));
                 return null;
            }           
            Attachment doc = new Attachment();
            if(homeownerDoc.Body == Null || homeownerDoc.Name == null || homeownerDoc.Name == ''){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Upload_File));
                return null;  
            }
            doc.ParentId = warranty.id;
            doc.Body = homeownerDoc.Body;
            doc.Name = homeownerDoc.Name;
            docList.add(doc);
            insert doc;
            doc.Body = Blob.valueOf(''); // due to view page size limit. 
            homeownerDoc.Body = Blob.valueOf(''); // due to view page size limit.
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.Document_Uploaded));
        }catch(Exception ex){
            homeownerDoc.Body = Blob.valueOf(''); // due to view page size limit.
            System.debug(Label.Unexpected_error+ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));         
        }
        return null;        
    }
    
    /**************************************************************************
        Search warranties according to search filter properties.
        if seach filter is null, pull all warrantes related to logged in dealer.
    ***************************************************************************/
    public Pagereference searchWarranties(){
        warrantyFilter.startDate = homeStartDate.Delivery_Date__c;
        warrantyFilter.endDate = homeEndDate.Delivery_Date__c;
        warrantySetController = WarrantyRegistrationUtil.createWarrantiesSetController(warrantyFilter,currentLoginUser.Contact.AccountId);
        if(warrantySetController == null )
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,Label.No_records_found));
        return null;
    } 
    /**************************************************************************
        Search customers 
    ***************************************************************************/    
    public Pagereference searchCustomers(){  
        counter = 0; //MAM 22.MAY.2015      
        opportunitySetController = WarrantyRegistrationUtil.createAccountSetController(customerFilter,counter);
        total_size = WarrantyRegistrationUtil.total_size; //MAM 22.MAY.2015
        if(opportunitySetController == null)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,Label.No_records_found));
        return null;
    }
    
    //cdevarapalli -- Warranty Registration Process - SSE -- Enhancing Search Functionality by introducing AJAX search -- Method if searching for customers by click
    public Pagereference searchCustomersByClick(){
        //searchByClick=true;
        customerFilter.filterText = '';
        searchCustomers();
        return null;
    }
    
    //cdevarapalli -- Warranty Registration Process - SSE --Method if searching for customers by Text
    public Pagereference searchCustomersByText(){
        customerFilter.searchText = customerFilter.filterText;
        //searchByClick=false;
        searchCustomers();
        return null;
    }
    /**************************************************************************
        Search Sales Orders 
    ***************************************************************************/    
    public Pagereference searchSalesOrders(){
      try{
        //clean step 2 data (Delete from DB)
        if(warranty != null && warranty.id != null){
            List<WR_StagingSelection__c> selectedProducts = new List<WR_StagingSelection__c>();
            for(WR_StagingSelection__c sRecords : [Select id,Customer_Name__c,IsDrafted__c,IsInSelectedList__c,isNew__c,isRegistered__c,ISselected__c,Warranty_Registration__c,
                                                   WR_FDS_Product__c,WR_Line_Item__c From WR_StagingSelection__c Where Warranty_Registration__c = :warranty.id  
                                                   And IsInSelectedList__c = false limit 10000]){
                selectedProducts.add(sRecords); 
            }       
            if(!selectedProducts.isEmpty())
              delete selectedProducts; 
        }
        // END of Cleaning Staging Data        
        salesOrderFilter.deliveryStartDate = dumyStartDate.Delivery_Date__c;
        if(salesOrderFilter.isAscending == null)
            salesOrderFilter.isAscending = true;
        if(salesOrderFilter.sortField == 'serialNum') // Sorting by Order By can not be implemented if Sort Field is Serial Num
            salesOrderFilter.sortField = null;
        salesOrderFilter.deliveryEndDate = dumyEndDate.Delivery_Date__c;
        salesOrderFilter.partnerAccountNumber = currentLoginUser.Contact.Account.Oracle_Account_Number__c;
        salesOrderList = WarrantyRegistrationUtil.findSalesOrders(salesOrderFilter); // fetch matching saleorders
        System.debug('Sales# '+salesOrderList);
        salesOrderPaginator = new Paginator(salesOrderList,PAGE_SIZE);  
        InvalidSerials.clear();
        if(salesOrderPaginator.totalRecords == 0)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,Label.No_records_found));
      }catch(WR_CustomViewStateException ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Refine_Search_Criteria));
      }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
      }
      productsPaginator = new WR_CustomSetController();  // clear step-2
      return null;
    }
    
   /*******************************************************************************************************
    Show Customer information & create Warranty for this customer if Warranty is not created.
   ********************************************************************************************************/
   public PageReference displayCustomerInfo(){
        defaultTabName = WarrantyRegistrationUtil.CUSTOMER_INFO_TAB;
        customer = customersMap.get(customerID);
        newCustomer = null;
        // Creating Sharing  Rules for end customer Account if there is no sharring rules and sharing is required.
        if(customer != null){ //MAM 23.MAY.2015 add additional condition check to avoid null pointer exceptions
            if(customer.OwnerId != currentLoginUser.id){ 
                WarrantyRegistrationUtil.createAccountSharingRule(currentLoginUser.contact.account.Name,customer.id); 
            }
            // fetch opportunity associated with Customer.
            customerOpportunity = [select Primary_Contact__c, Primary_Contact__r.Contact_Language__c, Reason_Won_Lost__c,ID,Quality_Inspection_opt_in__c,Customer_Satisfaction_survey_opt_in__c,Marketing_opt_in__c,Warranty_Signed_Italy__c, StageName, CloseDate, Installation_Date__c, Delivery_Date__c, RecordType.Name, Closed_Won_Date__c, Probability, Opportunity_Status__c From Opportunity where (PartnerAccountId =: currentLoginUser.Contact.AccountId or Installer__c =: currentLoginUser.Contact.AccountId) AND AccountId =: customer.id ORDER BY createdDate DESC limit 1];
            
            if(customerOpportunity.Primary_Contact__r!=null){
            contact=customerOpportunity.Primary_Contact__r;}
        }
        reverseOptin();//for case# 00082693
        return null;
   }
   /****************************************************************************************************
    Move selected salesorder products into salesOrderProductList List
   *****************************************************************************************************/
   public PageReference selectSalesOrder() { 
            if(warranty == null){ // validation that customer is selected before doing anything.
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Customer_select_errorMessage));
                 return null;
            }   
            currentStagingDataTimeStamp = System.now();
            WarrantyRegistrationUtil.cleanWarrantyStagingData(warranty.id,false,currentStagingDataTimeStamp); 
            List<WR_StagingSelection__c> salesOrderProductList = new List<WR_StagingSelection__c>(); 
            InvalidSerials.clear();
            Set<ID> salesOrderID = new Set<ID>();

            //cdevarapalli -- Warranty Registration Process - SSE -- Code Change to send Serial Numbers as well to findProducts method along with SalesOrders
            Set<String> serialNumSet = new Set<String>();
            for(WR_SalesOrderWrapper wrapper : salesOrderList) {
               if(wrapper.isSelected) {  
                    if(wrapper.salesOrder.id!=null) 
                      salesOrderID.add(wrapper.salesOrder.id);
                    else
                      serialNumSet.add(wrapper.serialNum);
               }
            }
            
            //cdevarapalli -- Warranty Registration Process - SSE -- Check if size of serialNumSet is also zero before displaying error
            if(salesOrderID.size() == 0 && serialNumSet.size() == 0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.No_Data_Selected));
                return null;
            }    
            List<WR_FDS_Product__c> products = WarrantyRegistrationUtil.findProducts(salesOrderID,salesOrderFilter,serialNumSet);
            insertStaginData(products);
            productsPaginator = new WR_CustomSetController(warranty.id,false,PAGE_SIZE,'defaultSortOrder__c','ASC',currentStagingDataTimeStamp);
            if(productsPaginator.getResultSize() == 0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.No_Data_Selected));
            }
            return null;
   }
    /*********************************************************************************************************
    Move selected sales order products into customer selected sales order products(step 3) List
   **********************************************************************************************************/ 
   public PageReference selectSalesOrderLineItem() {
       System.debug('---------------selectSalesOrderLineItem---------------');
       system.debug('productsPaginator::::::::' + productsPaginator);
       productsPaginator.save();
       Integer previousTotalRecords = selectedProductPaginator.getResultsize();
       List<WR_StagingSelection__c> selectedProducts = new List<WR_StagingSelection__c>();
       for(WR_StagingSelection__c sRecords : [Select id,Customer_Name__c,IsDrafted__c,IsInSelectedList__c,isNew__c,isRegistered__c,ISselected__c,Warranty_Registration__c,
                                               WR_FDS_Product__c,WR_Line_Item__c From WR_StagingSelection__c Where Warranty_Registration__c = :warranty.id  
                                               And ISselected__c = true AND IsInSelectedList__c = false AND TimeStamp__c >= :currentStagingDataTimeStamp]){
            selectedProducts.add(sRecords);
       }
       // Max allowed to be selected validation
       if(previousTotalRecords + selectedProducts.size() > FILE_SIZE){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Max_Allowed_SN_To_Upload+' '+FILE_SIZE));
            return null;
       }
       List<WR_StagingSelection__c> updatedProducts = new List<WR_StagingSelection__c>();
       for(WR_StagingSelection__c item : selectedProducts){
            if(item.isNew__c == 'true'){
                item.IsInSelectedList__c = true;
                updatedProducts.add(item);
            }
       }    
       if(!updatedProducts.isEmpty())
         update updatedProducts;        
       productsPaginator = new WR_CustomSetController(warranty.id,false,PAGE_SIZE,'defaultSortOrder__c','ASC',currentStagingDataTimeStamp);
       selectedProductPaginator = new WR_CustomSetController(warranty.id,true,PAGE_SIZE,'WR_FDS_Product__r.Product_Type__c','ASC');
       if((selectedProductPaginator.getResultSize() - previousTotalRecords) == 0){
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.No_Data_Selected));
       }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,(selectedProductPaginator.getResultSize() - previousTotalRecords)+' '+Label.Count_Selected_SN));
       }
       return null;
    }
   /*********************************************************************************************************
     remove selected sales order products from customer selected sales order products(step 3) List
   **********************************************************************************************************/   
    public PageReference deselectSalesOrderLineItem() {
       selectedProductPaginator.save(); // update with new choise.
       List<WR_StagingSelection__c> selectedProducts = WarrantyRegistrationUtil.findAllSelectedInstallationdata(warranty.id,true);
       if(!selectedProducts.isEmpty())
         delete selectedProducts; 
       selectedProductPaginator = new WR_CustomSetController(warranty.id,true,PAGE_SIZE,'defaultSortOrder__c','ASC');    
       return null;
    }
   /*********************************************************************************************************
     remove Selected Products from List
   **********************************************************************************************************/   
    public PageReference removeProducts() {
        productsPaginator.save(); // update with new choise.
        List<WR_StagingSelection__c> selectedProducts = new List<WR_StagingSelection__c>();
        for(WR_StagingSelection__c sRecords : [Select id,Customer_Name__c,IsDrafted__c,IsInSelectedList__c,isNew__c,isRegistered__c,ISselected__c,Warranty_Registration__c,
                                               WR_FDS_Product__c,WR_Line_Item__c From WR_StagingSelection__c Where Warranty_Registration__c = :warranty.id  
                                               And ISselected__c = true AND IsInSelectedList__c = false AND TimeStamp__c >= :currentStagingDataTimeStamp]){
            selectedProducts.add(sRecords);
        }       
        if(!selectedProducts.isEmpty())
          delete selectedProducts; 
        productsPaginator = new WR_CustomSetController(warranty.id,false,PAGE_SIZE,'defaultSortOrder__c','ASC',currentStagingDataTimeStamp);
        return null;
    }  
  /**************************************************************************
   Toggle check/uncheck Salesorders
  **************************************************************************/
  public Pagereference checkUncheckAllSalesOrders(){
        for(WR_SalesOrderWrapper wrapper : salesOrderList) {
           wrapper.isSelected = IsAllSalesOrdersChecked;
       }  
       return null;     
 }
 
 /**************************************************************************
 Toggle check/uncheck Salesorders Line items
 **************************************************************************/ 
 public Pagereference checkUncheckAllLineItems(){
        System.debug('checkUncheckAllLineItems =>'+IsAllLineItemsChecked);
        List<WR_StagingSelection__c> selectedProducts = WarrantyRegistrationUtil.findAllInstallationdata(warranty.id,false); // second Table records
        for(WR_StagingSelection__c wrapper : selectedProducts) {
           wrapper.isSelected__c = IsAllLineItemsChecked;
       } 
     if(!selectedProducts.isEmpty())
        update selectedProducts;
    productsPaginator = new WR_CustomSetController(warranty.id,false,PAGE_SIZE,'defaultSortOrder__c','ASC',currentStagingDataTimeStamp);
    return null;   
  }
  /**************************************************************************
  Toggle check/uncheck Salesorders selected line times
  **************************************************************************/  
  public Pagereference  checkUncheckAllSelectedItems(){
    List<WR_StagingSelection__c> selectedProducts = WarrantyRegistrationUtil.findAllInstallationdata(warranty.id,true); // 3rd Table records
     for(WR_StagingSelection__c wrapper : selectedProducts) {
           wrapper.isSelected__c = IsAllSelectedItemsChecked;
     }
     if(!selectedProducts.isEmpty())
        update selectedProducts;
     selectedProductPaginator = new WR_CustomSetController(warranty.id,true,PAGE_SIZE,'WR_FDS_Product__r.Product_Type__c','ASC');
     return null;   
  }
  /**************************************************************************
    Sort list of Products according to selected sorted field and order 
  **************************************************************************/ 
  public Pagereference sortProductList(){
        if(isProductAscending){
            //cdevarapalli -- Warranty Registration Process - SSE -- Passing additional argument for double sort so that locks appear at bottom
            //productsPaginator = new WR_CustomSetController(warranty.id,false,PAGE_SIZE,productsortField,'ASC',currentStagingDataTimeStamp);
            productsPaginator = new WR_CustomSetController(warranty.id,false,PAGE_SIZE,productsortField,'ASC',currentStagingDataTimeStamp,'lockslast');
        }
            
        else{
            //cdevarapalli -- Warranty Registration Process - SSE -- Passing additional argument for double sort so that locks appear at bottom
            productsPaginator = new WR_CustomSetController(warranty.id,false,PAGE_SIZE,productsortField,'ASC',currentStagingDataTimeStamp);
            productsPaginator = new WR_CustomSetController(warranty.id,false,PAGE_SIZE,productsortField,'DESC',currentStagingDataTimeStamp,'lockslast');
        }
            
        return null;
  } 
  /**************************************************************************
    Sort list of selected Products according to selected sorted field and orer
  **************************************************************************/  
  public Pagereference sortSelectedProductList(){
        if(isSelectedProductAscending)
            selectedProductPaginator = new WR_CustomSetController(warranty.id,true,PAGE_SIZE,selectedProductSortField,'ASC');
        else
            selectedProductPaginator = new WR_CustomSetController(warranty.id,true,PAGE_SIZE,selectedProductSortField,'DESC');
        return null;
  }
  /**************************************************************************
    Sort list of Sales Orders according to selected sorted field and orer (Used to sory fir Serial Number)
  **************************************************************************/  
  public Pagereference sortSalesOrders(){
        if(salesOrderFilter.isAscending)
            WR_SortHelper.sortSalesOrderList(salesOrderList,salesOrderFilter.sortField,'ASC');
        else
            WR_SortHelper.sortSalesOrderList(salesOrderList,salesOrderFilter.sortField,'DESC');
        return null;
  }
  /*
    Upload csv file,containing Serial Numbers.
  */
  public Pagereference uploadCSVFile(){
    try{
        if(warranty == null){ // validation that customer is selected before doing anything.
             // warranty is yet not created, directly jump on other tab. 
             defaultTabName= WarrantyRegistrationUtil.CUSTOMER_INFO_TAB; 
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Customer_select_errorMessage));
             return null;
        }       
        currentStagingDataTimeStamp = System.now();
        WarrantyRegistrationUtil.cleanWarrantyStagingData(warranty.id,false,currentStagingDataTimeStamp); 
        if(csvFileName == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Browse_CSV_File));
            return null;
            
        }
        if(csvFileName != null && !csvFileName.endsWith('.csv')){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.InvalidCSVMessage));
            serialNumFile = null; 
            return null;
        }

        WR_CSVFileUploader fileUploader = new WR_CSVFileUploader(serialNumFile,currentLoginUser.Contact.Account.Oracle_Account_Number__c);
        
        if((fileUploader.isTotalSNExceeded != null && fileUploader.isTotalSNExceeded) || fileUploader.products.size() > FILE_SIZE){ // Allow to upload only 9000 SN.//for Case# 00091077
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CSVFile_RecordLimitError_Message));
            serialNumFile = null; 
            return null;
        }
        InvalidSerials = new List<Set<String>>();
        insertStaginData(fileUploader.products);
        productsPaginator = new WR_CustomSetController(warranty.id,false,PAGE_SIZE,'defaultSortOrder__c','ASC',currentStagingDataTimeStamp);
        String errMsg = Label.File_Uploaded+' <I>'+csvFileName+'</I> '+Label.containing+' '+(fileUploader.totalValidSN + fileUploader.totalInvalidSN)+' '+Label.rows+':<ul style="padding-left:5px;margin-bottom:5px;margin-top:5px;"><li>'+Label.Serial_Numbers_accepted+ ' '+ fileUploader.totalValidSN +'</li><li>'+Label.Serial_Numbers_not_accepted+' '+fileUploader.totalInvalidSN+'</li></ul>';
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,+fileUploader.totalValidSN +' '+Label.Serial_Numbers_accepted));
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,+fileUploader.totalInvalidSN+' '+Label.Serial_Numbers_not_accepted));
        if(fileUploader.totalInvalidSN <= INVALID_SERIAL_NUMBER_LIMIT && fileUploader.getNoneMatchedSerialNumstring() != null && fileUploader.getNoneMatchedSerialNumstring() != ''){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,+fileUploader.getNoneMatchedSerialNumstring() +' '+Label.SN_Not_Present_Info));
            errMsg = errMsg+fileUploader.getNoneMatchedSerialNumstring() +' '+Label.SN_Not_Present_Info;
        } 
        if(fileUploader.totalInvalidSN > INVALID_SERIAL_NUMBER_LIMIT){ 
            Set<String> innerInvalidSns = new Set<String>();
            for(String str : fileUploader.serialNums){
                innerInvalidSns.add(str);
                if(innerInvalidSns.size() >= 1000){
                    InvalidSerials.add(innerInvalidSns);
                    innerInvalidSns = new Set<String>(); 
                }
            }
            if(!innerInvalidSns.isEmpty()){
                InvalidSerials.add(innerInvalidSns);
                
            }
            //errMsg = errMsg+'<br />';
            errMsg += Label.Click+'<a href="" onclick="javascript:generateExceptionCSV();return false;" style="font-family:Arial,Helvetica,sans-serif;font-size:11.5167px">'+Label.Here+'</a>'+Label.Download_CSV_Of_SN;
            
        }
        if(errMsg != ''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,errMsg));
        }
        defaultTabName = WarrantyRegistrationUtil.PRODUCT_SELECTION_TAB;    
    }catch(Exception ex){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.InvalidCSVMessage));
    }
    serialNumFile = null; 
    return null;

  }
  public Pagereference generateExceptionCSV(){
    Pagereference pg = new Pagereference('/apex/WR_UploadedSNCSV');
    pg.setRedirect(false);
    return pg;
  }
  /*
    insert Warranty Object into DB.
  */
  public Pagereference persistWarranty(){
    if(warranty != null && warranty.id == null){
        insert warranty;
        // Need to fetch autogenerated Warranty Number.
        warranty = [Select ID,Name,Delivery_Date__c,Status__c,Customer_Account_Email__c From Warranty_Registration__c where ID=:warranty.ID limit 1];       
    }
    return null;
  }
   /**
    initilize customer data of customer data tab
   **/
   private void initilizeRegistration(){
        currentStagingDataTimeStamp = System.now();
        defaultTabName= WarrantyRegistrationUtil.HOME_TAB;
        step = 0 ;
        currentLoginUser = [select LanguageLocaleKey, UserRole.Name,Name,Profile.Name,IsPortalEnabled,Contact.Account.Primary_PSR__c,Contact.AccountId,Contact.Account.Country_Domain__c,Contact.Account.Contact_Language__c,Contact.Contact_Language__c,Contact.Account.Oracle_Account_Number__c,Contact.Account.Name,Contact.Account.Theater__c,Contact.Account.BillingCountry,CountryDomainText__c from User where  ID = :Userinfo.getUserId()];
        
        //Case# 00168358 -- This is because the Schema method returns the translated value if there is a translation for the RecordType and doesnt match the Labels Specified here.
        commercialCustomerRecordTypeID = [Select ID From RecordType where Name =: COMMERCIAL_CUSTOMER Limit 1].id;           
        residentialCustomerRecordTypeID = [Select ID From RecordType where Name =: RESIDENTIAL_CUSTOMER Limit 1].id;
        //commercialCustomerRecordTypeID = GW_RecTypes.GetRecordTypeId('Account',COMMERCIAL_CUSTOMER);
        //residentialCustomerRecordTypeID =  GW_RecTypes.GetRecordTypeId('Account',RESIDENTIAL_CUSTOMER);
        warrantyRegistrationObjPreFix = Warranty_Registration__c.SObjectType.getDescribe().getKeyPrefix();
        
        docList = new List<Attachment>();
        homeownerDoc = new Attachment();   
        dumyStartDate = new Warranty_Registration__c(); 
        dumyEndDate = new Warranty_Registration__c(); 
        homeStartDate = new Warranty_Registration__c();
        homeEndDate = new Warranty_Registration__c();  
        
        contact = new Contact();
        InvalidSerials = new List<Set<String>>();
        // create customer filter and populate required fields and fetch customers
        customerFilter = new WR_customerFilter();
        customerFilter.countryDomain = currentLoginUser.Contact.Account.Country_Domain__c;
        customerFilter.dealerID = currentLoginUser.contact.accountID;
        customerFilter.commercialRecordTypeID = commercialCustomerRecordTypeID;
        customerFilter.homeOwnerRecordTypeID = residentialCustomerRecordTypeID;
        counter = 0; //MAM 22.MAY.2015
        opportunitySetController = WarrantyRegistrationUtil.createAccountSetController(customerFilter,counter);
        total_size = WarrantyRegistrationUtil.total_size; //MAM 22.MAY.2015
        
        IsAllSalesOrdersChecked = false; 
        IsAllLineItemsChecked = IsAllSelectedItemsChecked = true; // checkbox of instalation data tab
       
        warrantyFilter = new WR_WarrantySearchFilter();
        
        //MAM 11.JUN.2015 Case 00519601 fix start - start specifing the Delivery Date to the current year
        homeStartDate.Delivery_Date__c = Date.valueOf(String.ValueOf(Date.Today().year())+'-01-01');
        homeEndDate.Delivery_Date__c = Date.Today();
        warrantyFilter.startDate = homeStartDate.Delivery_Date__c;
        warrantyFilter.endDate = homeEndDate.Delivery_Date__c;
        //MAM 11.JUN.2015 end
        
        warrantySetController = WarrantyRegistrationUtil.createWarrantiesSetController(warrantyFilter,currentLoginUser.Contact.AccountId);
      
        salesOrderList = new  List<WR_SalesOrderWrapper>();
        salesOrderFilter = new WR_salesOrderFilter();  
        // iniit Step-2 and 3rd Paginator
        productsPaginator = selectedProductPaginator = new WR_CustomSetController();
        
        // In case of redirected from Online Ordering pages, Create Warranty for Custome which is in request Parameter
        if(System.currentPageReference().getParameters().get('customer') != null && System.currentPageReference().getParameters().get('salesoorder') != null){
            customerID = System.currentPageReference().getParameters().get('customer');
            customer  = [select Name,LastName,Id,BillingCountry,BillingStreet,BillingState,BillingPostalCode,createdDate,Email__c,Phone,PersonMobilePhone,BillingCity,Fax,isPersonAccount,OwnerId,ParentID , Contact_Language__c From Account where ID =:customerID AND (RecordTypeId = :commercialCustomerRecordTypeID OR RecordTypeId =:residentialCustomerRecordTypeID)];
           
             // Done for Change order "EU Partner Opportunity Management" [replacing EU Partner Account with PartnerAccount]
            //customerOpportunity = [select Reason_Won_Lost__c,ID,Quality_Inspection_opt_in__c,Customer_Satisfaction_survey_opt_in__c,Marketing_opt_in__c,Warranty_Signed_Italy__c, StageName, CloseDate, Installation_Date__c, Delivery_Date__c, RecordType.Name, Closed_Won_Date__c, Probability, Opportunity_Status__c From Opportunity where (PartnerAccountId =: currentLoginUser.Contact.AccountId or EU_Partner_Account__c =: currentLoginUser.Contact.AccountId) AND AccountId =: customer.id ORDER BY createdDate DESC limit 1];
            customerOpportunity = [select Primary_Contact__c, Primary_Contact__r.Contact_Language__c, Reason_Won_Lost__c,ID,Quality_Inspection_opt_in__c,Customer_Satisfaction_survey_opt_in__c,Marketing_opt_in__c,Warranty_Signed_Italy__c, StageName, CloseDate, Installation_Date__c, Delivery_Date__c, RecordType.Name, Closed_Won_Date__c, Probability, Opportunity_Status__c From Opportunity where (PartnerAccountId =: currentLoginUser.Contact.AccountId) AND AccountId =: customer.id ORDER BY createdDate DESC limit 1];           
            if(customerOpportunity.Primary_Contact__r!=null){
            contact=customerOpportunity.Primary_Contact__r;}
            
            WR_InitiateOnlineOrder initiateOnlineOrder = new WR_InitiateOnlineOrder(System.currentPageReference().getParameters().get('salesoorder'),currentLoginUser.Contact.Account.Oracle_Account_Number__c);
            salesOrderList = WarrantyRegistrationUtil.convertSalesOrderTOSalesOrderWrapper(initiateOnlineOrder.salesOrders);
            if(initiateOnlineOrder.getNoneMatchedSalesOrdersString() != null){ 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,initiateOnlineOrder.getNoneMatchedSalesOrdersString() +' '+Label.SN_Not_Present_Info));
            }
            defaultTabName= WarrantyRegistrationUtil.PRODUCT_SELECTION_TAB;// send on Product selection Tab tab
            if(customer != null || customerOpportunity != null){
                // create Warranty 
                warranty = new Warranty_Registration__c();
                warranty.Status__c = WR_DRAFT_STATUS;
                warranty.Partner_SFDC_ID__C = currentLoginUser.Contact.AccountId;
                warranty.Customer_SFDC_ID__C = customer.id;
                warranty.Warranty_Opportunity__c = customerOpportunity.Id;//for Case #00064666
                if(customer.Email__c != null)
                    warranty.Customer_Account_Email__c = customer.Email__c;
                insertWarranty = true; // Insert Warranty since it can not be inserted in Constructor Call (DML not allowed).
            }           
        }
        salesOrderPaginator = new Paginator(salesOrderList,PAGE_SIZE);
   } 
   // 
   private void insertStaginData(List<WR_FDS_Product__c> products){
            Map<ID,WR_Line_Item__c> registrationInprocessProducts =  WarrantyRegistrationUtil.findRegistrationInProcessProducts(currentLoginUser.contact.accountID);
            Map<ID,WR_Line_Item__c> convertedToAssetProducts =   WarrantyRegistrationUtil.findRegisteredProducts(currentLoginUser.contact.accountID);
            Set<ID> selectedProductIds = new Set<ID>();
            for(WR_StagingSelection__c sRecord :[Select ID,WR_FDS_Product__c FROM WR_StagingSelection__c where Warranty_Registration__c =:warranty.id AND IsInSelectedList__c = True]){
                selectedProductIds.add(sRecord.WR_FDS_Product__c);
            }
            // old staging records      
            List<WR_StagingSelection__c> stagingList = new List<WR_StagingSelection__c>();
            WR_StagingSelection__c stagingItem;
            WR_Line_Item__c lineItem;
            for(WR_FDS_Product__c item : products) {
                if(selectedProductIds.contains(item.id))
                    continue; // Product is already in Selected List.
                stagingItem = new WR_StagingSelection__c();
                stagingItem.WR_FDS_Product__c = item.id;
                stagingItem.Warranty_Registration__c = warranty.id;   
                stagingItem.ISselected__c = true;
                stagingItem.TimeStamp__c = currentStagingDataTimeStamp; 
                if(convertedToAssetProducts.containsKey(item.id)){ //Registered
                    stagingItem.isRegistered__c = true;
                    lineItem =  convertedToAssetProducts.get(item.id);
                    stagingItem.Customer_Name__c = lineItem.Warranty_registration__r.Customer_SFDC_ID__r.Name;
                    stagingItem.WR_Line_Item__c = lineItem.id;
                }else if(item.Converted_To_Asset__c){ //Registered but done manually
                    stagingItem.isManuallyRegistered__c = true;
                }else if(registrationInprocessProducts.containsKey(item.id)){ // Draft
                    stagingItem.IsDrafted__c = true;
                    lineItem =  registrationInprocessProducts.get(item.id);
                    stagingItem.Customer_Name__c = lineItem.Warranty_registration__r.Customer_SFDC_ID__r.Name;
                    stagingItem.WR_Line_Item__c = lineItem.id;                  
                }           
                stagingList.add(stagingItem);
            }
            if(!stagingList.isEmpty()){
                insert stagingList;  
            }       
   }
   //Start for case# 00082693
   public void reverseOptin(){
    if(currentLoginUser.Contact.Account.Country_Domain__c == null) return;
    String countryDomain = currentLoginUser.Contact.Account.Country_Domain__c.subString(currentLoginUser.Contact.Account.Country_Domain__c.indexof('-')+1);
    //Start 00103324 & ( case# 00073912 -Amit Saha -3 new country domains:combo-rl,rvar-rl,cvar-rl) 
    //if(countryDomain == 'be' || countryDomain == 'de' || countryDomain == 'fr'){
    if(countryDomain == 'be' || countryDomain == 'de' || countryDomain == 'fr' || countryDomain == 'uk' || countryDomain == 'rl' ){
    //End 00103324 & (case# 00073912)
        customerOpportunity.Quality_Inspection_opt_in__c = !customerOpportunity.Quality_Inspection_opt_in__c;
        customerOpportunity.Marketing_opt_in__c = !customerOpportunity.Marketing_opt_in__c;
        customerOpportunity.Customer_Satisfaction_survey_opt_in__c = !customerOpportunity.Customer_Satisfaction_survey_opt_in__c;
    }
   }
   //End for case# 00082693
   
   //cdevarapalli -- Warranty Registration Process - SSE -- Method to be executed if the page has CustomerID parameter. The parameter appears when the "New Warranty Registration" button on the Account detail page is clicked
   public PageReference setCustomerID(){
       //getCustomerList();
       
       pageReference cid = ApexPages.currentPage();
       System.debug('CustomerID ----- '+cid);
       System.debug('CustomerID ----- '+ApexPages.currentPage().getParameters().get('CustomerId'));
       if(ApexPages.currentPage().getParameters().get('CustomerId')!=null){
           defaultTabName = WarrantyRegistrationUtil.CUSTOMER_INFO_TAB;
           CustomerID=ApexPages.currentPage().getParameters().get('customerID');
           newCustomer = null;
        customer = [select Name,LastName,Id,BillingCountry,BillingStreet,BillingState,BillingPostalCode,createdDate,Email__c,Phone,PersonMobilePhone,BillingCity,Fax,isPersonAccount,OwnerId,ParentID  From Account where id=:CustomerID];
        // Creating Sharing  Rules for end customer Account if there is no sharring rules and sharing is required.
        if(customer.OwnerId != currentLoginUser.id){
            WarrantyRegistrationUtil.createAccountSharingRule(currentLoginUser.contact.account.Name,customer.id); 
        }
        // fetch opportunity associated with Customer.
        customerOpportunity = [select Primary_Contact__c, Primary_Contact__r.Contact_Language__c, Reason_Won_Lost__c,ID,Quality_Inspection_opt_in__c,Customer_Satisfaction_survey_opt_in__c,Marketing_opt_in__c,Warranty_Signed_Italy__c, StageName, CloseDate, Installation_Date__c, Delivery_Date__c, RecordType.Name, Closed_Won_Date__c, Probability, Opportunity_Status__c From Opportunity where (PartnerAccountId =: currentLoginUser.Contact.AccountId or Installer__c =: currentLoginUser.Contact.AccountId) AND AccountId =: customer.id ORDER BY createdDate DESC limit 1];
        
        if(customerOpportunity.Primary_Contact__r!=null){
        contact=customerOpportunity.Primary_Contact__r;}
        reverseOptin();//for case# 00082693
        step=1;
        next();
       }
       
       return null;
   }
     
    //cdevarapalli -- Warranty Registration Process - SSE -- Method to delete the current Warranty Registration record and return to the home panel
    public PageReference deleteWR(){
      
      delete warranty;
      
      if(isPartnerUser)
      {
        Pagereference pageRef = new Pagereference(WR_PANEL_PAGE_URL);
        pageRef.setRedirect(true);
        return pageRef;
      }
      else
        return null;
    }
    
    //cdevarapalli -- Warranty Registration Process - SSE -- Method to set the tab to Product Selection Tab
    public PageReference backToProdList(){
      defaultTabName= WarrantyRegistrationUtil.PRODUCT_SELECTION_TAB;
      return null;
    }
    
    //pagination - JAJA APRIL-10-2015
       
       public PageReference Beginning() { //user clicked beginning
          counter = 0;          
          opportunitySetController = WarrantyRegistrationUtil.createAccountSetController(customerFilter,counter);
          total_size = WarrantyRegistrationUtil.total_size;
          return null;
       }
       public PageReference Previous() { //user clicked previous button
          counter -= list_size;
          opportunitySetController = WarrantyRegistrationUtil.createAccountSetController(customerFilter,counter);
          total_size = WarrantyRegistrationUtil.total_size;
          return null;
       }
     
       public PageReference NextPaging() { //user clicked next button          
          counter += list_size;
          opportunitySetController = WarrantyRegistrationUtil.createAccountSetController(customerFilter,counter);
          total_size = WarrantyRegistrationUtil.total_size;
          return null;
       }
     
       public PageReference End() { //user clicked end
          counter = total_size - math.mod(total_size, list_size);
          opportunitySetController = WarrantyRegistrationUtil.createAccountSetController(customerFilter,counter);
          total_size = WarrantyRegistrationUtil.total_size;
          return null;
       }
     
       public Boolean getDisablePrevious() { 
          //this will disable the previous and beginning buttons
          if (counter>0) return false; else return true;
       }
     
       public Boolean getDisableNext() { //this will disable the next and end buttons
          if (counter + list_size < total_size) return false; else return true;
       }
     
       public Integer getTotal_size() {
          return total_size;
       }
     
       public Integer getPageNumber() {
          return counter/list_size + 1;
       }
     
       public Integer getTotalPages() {
          if (math.mod(total_size, list_size) > 0) {
             return total_size/list_size + 1;
          } else {
             return (total_size/list_size);
          }
       }
}