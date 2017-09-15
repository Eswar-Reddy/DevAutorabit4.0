/*
* Utility class for online Warranty registration
* @Author Shailendra Singh (Appiro offshore)
*/
public without sharing class WarrantyRegistrationUtil { 
    
    
    // Tab Names
    public static String HOME_TAB = 'Home';
    public static String CUSTOMER_INFO_TAB = 'CustomerData';
    public static String PRODUCT_SELECTION_TAB ='InstallationData';
    public static String DETAIL_TAB = 'WarantyDetails';
    public static String OPTIN_TAB = 'optin';
    static final String SORTING_ORDER_DESC = 'DESC';
    static final String SORTING_ORDER_ASC = 'ASC';
    public static integer total_size {get; private set;}
  
   /********************************************************************************************************
    convert Date into string representation as yy/mm/dd
   *********************************************************************************************************/   
   public static String dateFormat(Date d){
        String dStr = '';
        if(d != null){
            dStr = d.year()+ '-'+dateStringFormat(d.month())+'-'+dateStringFormat(d.day());
        }
        return dStr;
    }
    /*********************************************************************************************************
    convert integer value of date/month into string representation
    **********************************************************************************************************/
    public static String dateStringFormat(Integer value){
        String format = '';
        if(value>9){
            format = String.valueOf(value);
        }else{
            format = '0'+String.valueOf(value);
        }
        return format;
    } 
  /********************************************************************************************
   Return object of StandardSetController, created for query Account of passed dealer and customer Name if customer Name is not null.
   
   @return ssc (ApexPages.StandardSetController)
   *********************************************************************************************/
   public static ApexPages.StandardSetController createAccountSetController(WR_customerFilter filter, integer counter){
        Set<ID> endCustomerId = new Set<ID>();
        String query = 'select accountId  From Opportunity where ';
        // Done for Change order "EU Partner Opportunity Management" [replacing EU Partner Account with PartnerAccount]
        /*if(!filter.countryDomain.endsWith('us')) // EU Customer
            query = query +' EU_Partner_Account__c = \''+filter.dealerID+'\'';
        else*/
            //query = query + ' PartnerAccountId =\''+filter.dealerID+'\'';
        query = query + ' (PartnerAccountId =\''+filter.dealerID+'\' or Installer__c=\''+filter.dealerID+'\')';

        //cdevarapalli -- Warranty Registration Process - SSE -- changin the accountname part of the query based on the  type of search that is being used.
        String accountNameLike = 'AND Account.Name like \'';
        
        if (filter.isSearchByClick==false)
            accountNameLike = 'AND Account.Name like \'%';
             
        if(filter.searchText != null && filter.searchText != ''){
            query = query + accountNameLike +String.escapeSingleQuotes(filter.searchText)+'%\'';
        }
        
        for(Opportunity op :Database.query(query)){
            endCustomerId.add(op.accountId); 
        }  
        if(filter.sortField == null)
            filter.sortField = filter.previousSortField;
        if (!filter.isAscending){
             filter.sortingOrder = SORTING_ORDER_DESC; 
        }else
             filter.sortingOrder = SORTING_ORDER_ASC;             
        //String accountQuery = 'select Name,LastName,Id,BillingCountry,BillingStreet,BillingState,BillingPostalCode,createdDate,Email__c,Phone,PersonMobilePhone,BillingCity,Fax,isPersonAccount,OwnerId,ParentID  From Account where id IN :endCustomerId AND (RecordTypeId = \''+filter.commercialRecordTypeID+'\' OR RecordTypeId = \''+filter.homeOwnerRecordTypeID+'\')  ORDER BY '+filter.sortField+' '+filter.sortingOrder; 
        
        String accountQuery = 'select Name,LastName,Id,BillingCountry,BillingStreet,BillingState,BillingPostalCode,createdDate,Email__c,Phone,PersonMobilePhone,BillingCity,Fax,isPersonAccount,OwnerId,ParentID  From Account where id IN :endCustomerId AND (RecordTypeId = \''+filter.commercialRecordTypeID+'\' OR RecordTypeId = \''+filter.homeOwnerRecordTypeID+'\')  ORDER BY '+filter.sortField+' '+filter.sortingOrder; 
        System.debug('**********accountQuery****** ' + accountQuery );
        //jaja case 00475662 Mar.26.2015
        // Even count queries have to be limited at 50000 or SF will throw an error. 10-19-2016
        String count_query = 'select count() From Account where id IN :endCustomerId AND (RecordTypeId = \''+ filter.commercialRecordTypeID+'\' OR RecordTypeId = \''+filter.homeOwnerRecordTypeID +'\') LIMIT 10000';
        total_size = database.countQuery(count_query);        
        accountQuery = accountQuery + ' LIMIT 10 ';
        //JAJA-The maximum offset is 2,000 rows. Requesting an offset greater than 2,000 will result in a NUMBER_OUTSIDE_VALID_RANGE error.
        if (counter > 2000){ counter = 2000; }
        accountQuery  = accountQuery + '  OFFSET ' + counter;        
        List<Account> accList = Database.query(accountQuery);
        
        //String accountQuery = 'select Quality_Inspection_opt_in__c, Customer_Satisfaction_survey_opt_in__c, Marketing_opt_in__c,Name,LastName,Id,BillingCountry,BillingStreet,BillingState,BillingPostalCode,createdDate,Email__c,Phone,PersonMobilePhone,BillingCity,Fax,isPersonAccount,OwnerId,ParentID  From Account where id IN :endCustomerId AND (RecordTypeId = \''+filter.commercialRecordTypeID+'\' OR RecordTypeId = \''+filter.homeOwnerRecordTypeID+'\')  ORDER BY '+filter.sortField+' '+filter.sortingOrder;
        //ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(Database.getQueryLocator(accountQuery));
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(accList); //JAJA 26.MAR.2015
        if(ssc.getResultSize() != 0){
           //ssc.setPageSize(10);
           return ssc;
        }else 
            return null;
        
   }    
   /********************************************************************************************
   Return object of StandardSetController, created for query waranties according to filter criteria.
   
   @param filter (WarrantySearchFilter) 
   @param dealerID(String) , Id of dealer Account
   @return ssc (ApexPages.StandardSetController) 
   *********************************************************************************************/
   public static ApexPages.StandardSetController createWarrantiesSetController(WR_WarrantySearchFilter filter,String dealerID){
        String query = 'Select Customer_SFDC_ID__r.createdDate,Customer_SFDC_ID__C,Customer_SFDC_ID__r.Name,Customer_SFDC_ID__r.PersonMobilePhone,Customer_SFDC_ID__r.Email__c, Customer_SFDC_ID__r.Phone, Customer_SFDC_ID__r.BillingStreet, Customer_SFDC_ID__r.BillingCity, Customer_SFDC_ID__r.BillingState, Customer_SFDC_ID__r.BillingPostalCode,Customer_SFDC_ID__r.BillingCountry,Name,Delivery_Date__c,Status__c From Warranty_Registration__c where  Partner_SFDC_ID__r.id =\''+dealerID+'\'';
        if(filter.customerName != null && filter.customerName != '')
            query = query + ' AND Customer_SFDC_ID__r.Name like \''+String.escapeSingleQuotes(filter.customerName)+'%\'';
        if(filter.status != null && filter.status != '')
            query = query + ' AND Status__c = \''+filter.status+'\'';
        if(filter.startDate != null)
            query = query + ' AND Delivery_Date__c >= '+WarrantyRegistrationUtil.dateFormat(filter.startDate);
        if(filter.endDate != null)
            query = query + ' AND Delivery_Date__c <= '+WarrantyRegistrationUtil.dateFormat(filter.endDate);
        if(filter.warrantyNumber != null & filter.warrantyNumber != '')
            query = query + ' AND Name = \''+String.escapeSingleQuotes(filter.warrantyNumber)+'\'';
        if(filter.sortField == null)
            filter.sortField = filter.previousSortField; 
        if (!filter.isAscending){
             filter.sortingOrder = SORTING_ORDER_DESC; 
        }else
             filter.sortingOrder = SORTING_ORDER_ASC;  
                        
        //ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(Database.getQueryLocator(query+ ' ORDER BY '+filter.sortField+' '+filter.sortingOrder));
        
        //jzaguirre case 00475662 Mar.26.2015
        query = query+ ' ORDER BY '+filter.sortField+' '+filter.sortingOrder;
        List<Warranty_Registration__c> warrList = Database.query(query);         
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(warrList);
        
        if(ssc.getResultSize() != 0){
            ssc.setPageSize(30);
            return ssc;
        }else 
            return null;
   }
  
   /********************************************************************************************
   Return List of SalesOrderWrapper  object matching to filter criteria. Fileter must have partnerAccountNumber (Oracle Account Number)
   
   @param filter (SalesOrderFiler)
   @return List<SalesOrderWrapper> 
   *********************************************************************************************/   
   public static List<WR_SalesOrderWrapper> findSalesOrders(WR_SalesOrderFilter filter){
        
       // Building Search Query
        //cdevarapalli -- Warranty Registration Process - SSE
        String productsubquery = '';
        String innerQuery ='Select w.Product_Name__c,w.WR_ORACLE_SalesOrder__c, w.Serial_Number__c, w.Product_Type__c, w.Packing_Slip__c,w.Alternate_Packing_Slip__c, w.Id, w.Converted_To_Asset__c,WR_ORACLE_SalesOrder__r.Purchase_Order__c From WR_FDS_Products__r w ';
        String mainQuery = 'Where  Oracle_Account_Number__c = \''+filter.partnerAccountNumber+'\'';
        Set<String> packslipCollection = new Set<String>(); //Used display either alternate PL or PL depending on PL used for searching.
        if(filter.deliveryStartDate != null)
            mainQuery = mainQuery + ' AND So_Created__c >= '+WarrantyRegistrationUtil.dateFormat(filter.deliveryStartDate)+'T00:00:00Z';
        if(filter.deliveryEndDate !=null )
            mainQuery = mainQuery + ' AND So_Created__c <= '+WarrantyRegistrationUtil.dateFormat(filter.deliveryEndDate)+'T00:00:00Z';
        if(filter.numberType != null && filter.numberValue != null && filter.numberValue != ''){
            if(filter.numberType == 'Sales Order'){
                 String subquery = '';
                 for (String str : filter.numberValue.split(',|\\s+|;')) {
                   if(str.trim() != ''){
                        if(subquery != '')
                            subquery = subquery + 'OR ';
                        subquery = subquery + 'Sales_order__c like  \'%'+String.escapeSingleQuotes(str)+'%\'';
                   }
                 }
                 mainQuery = mainQuery + ' AND ('+subquery+')';
            } if(filter.numberType == 'Packing List'){ // Packslip is either matched with Oracle(salesorder) packslip field or with FDS alternate packslip value
                 String subquery = '';
                 String packSlipQuery = '';
                 for (String str : filter.numberValue.split(',|\\s+|;')) {
                    if(str.trim() != ''){
                        if(subquery != ''){
                            subquery = subquery + 'OR ';
                            packSlipQuery = packSlipQuery +' OR ';
                        }
                        subquery = subquery + ' packing_slip__c like  \'%'+String.escapeSingleQuotes(str)+'%\'';
                        packSlipQuery = packSlipQuery + ' Alternate_Packing_Slip__c like  \'%'+String.escapeSingleQuotes(str)+'%\'';
                        packslipCollection.add(str); // Put packing slip in set which is used display either alternate PL or PL depending on PL used for searching.
                    }
                 } 
                 // Create Query for matching Salesorder IDs
                 List<WR_FDS_Product__c> productList = Database.query('Select WR_ORACLE_SalesOrder__c FROM WR_FDS_Product__c Where ('+packSlipQuery+') AND WR_ORACLE_SalesOrder__r.Oracle_Account_Number__c = \''+filter.partnerAccountNumber+'\'');
                 packSlipQuery = '';
                 for(WR_FDS_Product__c product :productList){
                    if(!packSlipQuery.contains(product.WR_ORACLE_SalesOrder__c)){ // include in Query if this is not alredy in query.
                        if(packSlipQuery != '')
                            packSlipQuery = packSlipQuery + ',';
                        packSlipQuery = packSlipQuery + '\''+product.WR_ORACLE_SalesOrder__c+'\'';
                    }
                 }
                 if(packSlipQuery != '')  // If packslip was not matched in FDS products then filter is only on Salesorder (Oracle Salesorder)     
                    mainQuery = mainQuery + ' AND (('+subquery+') OR ID IN ('+ packSlipQuery+' ))';
                 else
                    mainQuery = mainQuery + ' AND ('+subquery+') ';
            }
            if(filter.numberType == 'Serial Number'){
                String subquery = ''; 
                 for (String str : filter.numberValue.split(',|\\s+|;')) {
                       if(str.trim() != ''){ 
                            if(subquery != '')
                                subquery = subquery + ' OR ';
                            //cdevarapalli -- Warranty Registration Process - SSE -- Changing the query to make Serial Number search an exact match instead of a wild card search
                            //subquery = subquery + ' Serial_Number__c like  \'%'+String.escapeSingleQuotes(str)+'%\'';
                            subquery = subquery + ' Serial_Number__c = \''+String.escapeSingleQuotes(str)+'\'';
                       }
                }
                             
                mainQuery = mainQuery + ' AND ID IN(Select WR_ORACLE_SalesOrder__c FROM WR_FDS_Product__c Where ('+subquery+'))';
                innerQuery = innerQuery + 'Where ('+subquery+')'; // In case filter contain serial condition also need to filter line items
                //cdevarapalli -- Warranty Registration Process - SSE -- Saving the product subquery to use it in the additional querying for products which are not associated to a Sales Order
                productsubquery = subquery;     
            } 
            if(filter.numberType == 'Purchase order'){
                 String subquery = '';
                 for (String str : filter.numberValue.split(',|\\s+|;')) {
                    if(str.trim() != ''){
                        if(subquery != '')
                            subquery = subquery + 'OR ';
                        subquery = subquery + ' Purchase_Order__c like  \'%'+String.escapeSingleQuotes(str)+'%\'';
                    }
                 }            
                mainQuery = mainQuery + ' AND ('+subquery+')';   
           }     
        }
        if (filter.isAscending != null && !filter.isAscending){
             filter.sortingOrder = SORTING_ORDER_DESC; 
        }else
             filter.sortingOrder = SORTING_ORDER_ASC;  
                     
        if(filter.sortField == null){
            mainQuery = 'Select ID,Sales_Order__c,Purchase_Order__c,So_Created__c,Packing_Slip__c,('+innerQuery+' limit 1) FROM WR_ORACLE_SalesOrder__c '+mainQuery+' ORDER BY Purchase_Order__c ASC,Sales_Order__c ASC,Packing_Slip__c,So_Created__c DESC';
            filter.sortField = 'Purchase_Order__c';
        }
        else
            mainQuery = 'Select ID,Sales_Order__c,Purchase_Order__c,So_Created__c,Packing_Slip__c,('+innerQuery+' limit 1) FROM WR_ORACLE_SalesOrder__c '+mainQuery+' ORDER BY '+ filter.sortField +' '+ filter.sortingOrder;
        // Build query code ended.    
            
        System.debug('Query-----anjali------>'+mainQuery);
        List<WR_ORACLE_SalesOrder__c> salesOrdersList = Database.query(mainQuery); 
        
        List<WR_SalesOrderWrapper> salesOrders = new List<WR_SalesOrderWrapper>();
        List<WR_SalesOrderWrapper> registeredSalesOrders = new List<WR_SalesOrderWrapper>(); //All the salesorders that are fully completed (all  S/Ns registered) should be last in list
        WR_SalesOrderWrapper salesOrderWrapper;
        //Start for Case# 00075207
        Integer countSalesOrders = 0;
        Integer countFDSProducts = 0;
        //End for Case# 00075207
        for(WR_ORACLE_SalesOrder__c salesOrder :salesOrdersList){
            //if (Limits.getHeapSize() > 3994000) {  // Heap size is about to exceed.
            if (Limits.getHeapSize() > Limits.getLimitHeapSize()){
                    throw new WR_CustomViewStateException();  
            }
            //Start for Case# 00075207
            countFDSProducts = countFDSProducts + salesOrder.WR_FDS_Products__r.Size();
            countSalesOrders++;
            if (countSalesOrders > 150 || countFDSProducts > 6000) {  // Can't show more than 100 Orders or 6000 SN's at a time.
                throw new WR_CustomViewStateException();
            }
            //End for Case# 00075207                    
            System.debug('--'+Limits.getHeapSize() +'  --' +Limits.getLimitHeapSize());  
            salesOrderWrapper = new WR_SalesOrderWrapper(salesOrder);
            if(!salesOrder.WR_FDS_Products__r.isEmpty()){
                salesOrderWrapper.serialNum = salesOrder.WR_FDS_Products__r.get(0).Serial_Number__c; // putting first product serial num
                if(packslipCollection.contains(salesOrder.WR_FDS_Products__r.get(0).Alternate_Packing_Slip__c)) // Alternate PL used for searching then display that else primary PL#
                    salesOrderWrapper.packingSlip = salesOrder.WR_FDS_Products__r.get(0).Alternate_Packing_Slip__c;
                else
                    salesOrderWrapper.packingSlip = salesOrder.Packing_Slip__c;
            }else{
                salesOrderWrapper.packingSlip = salesOrder.Packing_Slip__c;
            }
            if(!salesOrder.WR_FDS_Products__r.isEmpty() && salesOrder.WR_FDS_Products__r.get(0).Converted_To_Asset__c)
                registeredSalesOrders.add(salesOrderWrapper);
            else
                salesOrders.add(salesOrderWrapper);
        }
        salesOrders.addAll(registeredSalesOrders);

        //cdevarapalli -- Warranty Registration Process - SSE -- Additional Code to find Products which are not associated to a WR_Oracle_Sales_Order__c
        List<WR_FDS_Product__c> fdsproductsList = new List<WR_FDS_Product__c>();
        if(filter.numberType == 'Serial Number'){
            String productQuery ='Select Product_Name__c,WR_ORACLE_SalesOrder__c, Serial_Number__c, Product_Type__c, Packing_Slip__c,Alternate_Packing_Slip__c, Id, Converted_To_Asset__c,WR_ORACLE_SalesOrder__r.Purchase_Order__c from WR_FDS_Product__c where WR_ORACLE_SalesOrder__c=null and ('+productsubquery+')';
            System.debug('productQuery is ----- '+productQuery);
            fdsproductsList = Database.query(productQuery);
        }

        //cdevarapalli -- Warranty Registration Process - SSE -- Iterating through the Products without Sales Orders and adding them to the SalesOrderWrapper
        for(WR_FDS_Product__c fdsProd:fdsproductsList){
            if (fdsproductsList.size()> 6000) {  // Can't show more than 100 Orders or 6000 SN's at a time.
                throw new WR_CustomViewStateException();
            }
            WR_ORACLE_SalesOrder__c wrORSO = new WR_ORACLE_SalesOrder__c();
            salesOrderWrapper = new WR_SalesOrderWrapper(wrORSO);
            salesOrderWrapper.serialNum = fdsProd.Serial_Number__c;

            salesOrders.add(salesOrderWrapper);
        }
        System.debug('salesOrders ----- '+salesOrders);
        
        return salesOrders;  
  }  
  /************************************************************************************************
  @return products , MAP of products for those warranty is in process , Key is product id and value is WR_line_item
  ************************************************************************************************/
  public static Map<ID,WR_Line_Item__c> findRegistrationInProcessProducts(ID partnerID){
    Map<ID,WR_Line_Item__c> products = new Map<ID,WR_Line_Item__c>();
    for(WR_Line_Item__c lineItem : [Select WR_FDS_Product__c,Warranty_registration__c,Warranty_registration__r.Customer_SFDC_ID__r.Name From WR_Line_Item__c Where WR_FDS_Product__r.Converted_To_Asset__c = false AND Warranty_Registration__r.Partner_SFDC_ID__c = :partnerID]){
        products.put(lineItem.WR_FDS_Product__c,lineItem);
    }
    return products;
  } 
  /************************************************************************************************
  Share Customer Account record with Partner.
  @param String accountName
  @param ID customerId
  ************************************************************************************************/
  public static void createAccountSharingRule(String partnerAccountName,Id customerId){
        String userRoleName = partnerAccountName+' Partner Executive';
        List<UserRole> usrRoleList = [Select ID From UserRole where Name =:userRoleName limit 1];
        if(!usrRoleList.isEmpty()){
            List<Group> groupList = [Select id From Group where RelatedId=:usrRoleList.get(0).id AND Type IN ('RoleAndSubordinates','RoleAndSubordinatesInternal')];
            if(!groupList.isEmpty()){
                List<AccountShare> accountShareObjList = [Select id From AccountShare where AccountId =:customerId AND UserOrGroupId =:groupList.get(0).id];
                if(accountShareObjList.isEmpty()){
                     AccountShare accountShareObj = new AccountShare();
                     accountShareObj.AccountId = customerId;
                     accountShareObj.UserOrGroupId = groupList.get(0).id;
                     accountShareObj.AccountAccessLevel = 'Read';
                     accountShareObj.OpportunityAccessLevel = 'None';
                     insert accountShareObj;                                
                }
            }
     }
  }
  /************************************************************************************************
  Share campaign record with Partner.
  @param String accountName
  @param ID campaign id
  ************************************************************************************************/
  public static void createCampaignSharingRule(String partnerAccountName,Id cmpgnId){
        String userRoleName = partnerAccountName+' Partner Executive';
        List<UserRole> usrRoleList = [Select ID From UserRole where Name =:userRoleName limit 1];
        if(!usrRoleList.isEmpty()){
            List<Group> groupList = [Select id From Group where RelatedId=:usrRoleList.get(0).id AND Type IN ('RoleAndSubordinates','RoleAndSubordinatesInternal')];
            if(!groupList.isEmpty()){
                List<CampaignShare> campaignShareObjList = [Select id From CampaignShare where CampaignId =:cmpgnId AND UserOrGroupId =:groupList.get(0).id];
                if(campaignShareObjList.isEmpty()){
                     CampaignShare campaignShareObj = new CampaignShare();
                     campaignShareObj.CampaignId = cmpgnId;
                     campaignShareObj.UserOrGroupId = groupList.get(0).id;
                     campaignShareObj.CampaignAccessLevel = 'Read';
                     //campaignShareObj.OpportunityAccessLevel = 'None';
                     insert campaignShareObj;                                
                }
            }
     }
  }
  /************************************************************************************************
  @return products , MAP of products for those warranty is registered , Key is product id and value is WR_line_item
  ************************************************************************************************/
  public static Map<ID,WR_Line_Item__c> findRegisteredProducts(ID partnerID){
    Map<ID,WR_Line_Item__c> products = new Map<ID,WR_Line_Item__c>();
    for(WR_Line_Item__c lineItem : [Select WR_FDS_Product__c,Warranty_registration__c,Warranty_registration__r.Customer_SFDC_ID__r.Name From WR_Line_Item__c Where WR_FDS_Product__r.Converted_To_Asset__c = true AND Warranty_Registration__r.Partner_SFDC_ID__c = :partnerID LIMIT 10000]){
        products.put(lineItem.WR_FDS_Product__c,lineItem);
    }
    return products;
  }
 
  /*
  @param List Of WR_Oracle_SalesOrder__c
  @param List Of WR_Oracle_SalesOrder__c wrapper after casting them into SalesOrderWrapper
  */
  public static List<WR_SalesOrderWrapper> convertSalesOrderTOSalesOrderWrapper(List<WR_ORACLE_SalesOrder__c> salesOrderes){
    List<WR_SalesOrderWrapper> salesOrderList = new List<WR_SalesOrderWrapper>();
    WR_SalesOrderWrapper salesOrder;
    for(WR_ORACLE_SalesOrder__c order : salesOrderes){
        salesOrder = new WR_SalesOrderWrapper(order);
        salesOrder.packingSlip = order.Packing_Slip__c;
        salesOrderList.add(salesOrder);
    }
    return salesOrderList;
  }
  /*
   Send email notification to end customer
  */
  public static void sendWarrantyRegistrationNitification(String warrantyId,String country,String contactID){
        Warranty_Registration__c warranty = [Select ID,Customer_SFDC_ID__r.Email__c From Warranty_Registration__c where ID=:warrantyId limit 1];
        if(warranty.Customer_SFDC_ID__r.Email__c == null)
            return ;
        country = country.substring(country.length()-2);
        PageReference pdf =  Page.WROptinForm_us;
         if(country == 'it')
             pdf =  Page.WROptinForm_italy;
        if(country== 'de')
             pdf =  Page.WROptinForm_germany;
        if(country== 'fr')
             pdf =  Page.WROptinForm_france;
        if(country== 'ses')
             pdf =  Page.WROptinForm_spain;
        if(country== 'be')
             pdf =  Page.WROptinForm_BELGIUM;   
        pdf.getParameters().put('warrantyId',warrantyId); 
        EmailTemplate template = [select Id, DeveloperName from EmailTemplate  where DeveloperName = 'Warranty_Registered_Email' and isActive = true limit 1];
        Blob b = !Test.isRunningTest() ? pdf.getContent() : Blob.ValueOf('dummy text'); //MAM 22.MAY.2015 Fix GetContent condition to fix test class error call -  Methods defined as TestMethod do not support getContent call, test skipped for testclass WarrantyRegistrationUtil_Test
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('WR_Attachment.pdf');
        efa.setBody(b);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTemplateId(template.id);
        mail.setToAddresses(new String[] {warranty.Customer_SFDC_ID__r.Email__c});
        mail.setTargetObjectId(contactID);
        mail.saveAsActivity=false;
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        
        mail.setWhatId(warranty.id);
        List<Messaging.Email> emailMessages = new List<Messaging.Email>();
        emailMessages.add(mail);
        Messaging.sendEmail(emailMessages);
        
  }
  
  //------------------------------------------------------------------------------------------------------------------------------------------------
    //Util Methods For New Architecture that includes an Staging table WR_StagingSelection
  //------------------------------------------------------------------------------------------------------------------------------------------------
    
    //Return Products as per Serial Number in Filter Criteria
    //cdevarapalli -- Warranty Registration Process - SSE -- Additional parameter serialNums added to the method to consider FDS Products that are not associate to WR ORacle Sales Orders
    public static List<WR_FDS_Product__c> findProducts(Set<ID> salesOrders,WR_SalesOrderFilter filter,Set<String> serialNums){
        
        //cdevarapalli -- Code modified to find products even if they are not associated to a WR_Oracle_Sales_Order__c
        List<WR_FDS_Product__c> productQueryList = new List<WR_FDS_Product__c>();
        List<WR_FDS_Product__c> serialproductQueryList = new List<WR_FDS_Product__c>();
        Set<WR_FDS_Product__c> productQueryListIDSet = new Set<WR_FDS_Product__c>();
        String serialProductQuery = '';
        
        // Building Search Query
        String productQuery ='Select w.Product_Name__c,w.WR_ORACLE_SalesOrder__c, w.Serial_Number__c, w.Product_Type__c, w.Packing_Slip__c,w.Alternate_Packing_Slip__c, w.Id, w.Converted_To_Asset__c,WR_ORACLE_SalesOrder__r.Purchase_Order__c From WR_FDS_Product__c w Where WR_ORACLE_SalesOrder__c in :salesOrders';
        if(filter.numberType != null && filter.numberType == 'Serial Number' && filter.numberValue != null && filter.numberValue != ''){
                 String subquery = ''; 
                 for (String str : filter.numberValue.split(',|\\s+|;')) {
                       if(str.trim() != ''){ 
                            if(subquery != '')
                                subquery = subquery + ' OR ';
                            subquery = subquery + ' Serial_Number__c like  \'%'+String.escapeSingleQuotes(str)+'%\'';
                       }
                 }              
                productQuery = productQuery + ' AND ('+subquery+')'; // In case filter contain serial condition also need to filter line items     
                
                //cdevarapalli -- Warranty Registration Process - SSE -- Build Query on FDS Products
                if(serialNums.size()>0){
                    //if(subquery != '')
                    //subquery = subquery + ' OR w.Serial_Number__c IN :serialNums';
                    serialProductQuery = 'Select w.Product_Name__c,w.WR_ORACLE_SalesOrder__c, w.Serial_Number__c, w.Product_Type__c, w.Packing_Slip__c,w.Alternate_Packing_Slip__c, w.Id, w.Converted_To_Asset__c,WR_ORACLE_SalesOrder__r.Purchase_Order__c From WR_FDS_Product__c w Where WR_ORACLE_SalesOrder__c = null AND w.Serial_Number__c IN :serialNums';
                    System.debug('serialProductQuery -----'+serialProductQuery);
                }
        }
        System.debug('=======Query=========='+productQuery);
        
        
        System.debug('productQueryList# -----'+productQueryList);
        productQueryList = Database.query(productQuery);
        productQueryListIDSet.addAll(productQueryList);
        
        //cdevarapalli -- Warranty Registration Process - SSE -- Query on FDS Products and add them to the products being returned
        if(serialNums.size()>0){
            serialproductQueryList=Database.query(serialProductQuery);
            for(WR_FDS_Product__c wrfdsPr:serialproductQueryList){
                if(!productQueryListIDSet.contains(wrfdsPr))
                    productQueryList.add(wrfdsPr);
            }
        }
        
        return productQueryList;
        //cdevarapalli -- Warranty Registration Process - SSE -- Commenting out to accomodate return of additional products as well
        //return Database.query(productQuery);
        //return Database.query('Select w.Product_Name__c,w.WR_ORACLE_SalesOrder__c, w.Serial_Number__c, w.Product_Type__c, w.Packing_Slip__c,w.Alternate_Packing_Slip__c, w.Id, w.Converted_To_Asset__c,WR_ORACLE_SalesOrder__r.Purchase_Order__c From WR_FDS_Product__c w limit 8000');
    }
    
    //Return All Selected Stagging Record of Warranty
    public static List<WR_StagingSelection__c> findAllSelectedInstallationdata(ID warrantyID,Boolean IsInSelectedList){
        return ([Select id,Customer_Name__c,IsDrafted__c,IsInSelectedList__c,
                        isNew__c,isRegistered__c,ISselected__c,Warranty_Registration__c,
                        WR_FDS_Product__c,WR_Line_Item__c
                 From WR_StagingSelection__c
                 Where Warranty_Registration__c = :warrantyID
                 And ISselected__c = true AND IsInSelectedList__c = :IsInSelectedList
                ]);
    }
    //Return All Stagging Record of Warranty
    public static List<WR_StagingSelection__c> findAllInstallationdata(ID warrantyID,Boolean IsInSelectedList){
        return ([Select id,Customer_Name__c,IsDrafted__c,IsInSelectedList__c,
                        isNew__c,isRegistered__c,ISselected__c,Warranty_Registration__c,
                        WR_FDS_Product__c,WR_Line_Item__c
                 From WR_StagingSelection__c
                 Where Warranty_Registration__c = :warrantyID
                 AND IsInSelectedList__c = :IsInSelectedList
                ]);
    }   
    
    //Return StandardSetController of StaggingTable Records
    public static ApexPages.Standardsetcontroller createInstallationStagingsetController(ID warrantyID,Boolean IsInSelectedList,Integer pageSize, string sortField, string sortOrder){
        
        //create Search Query
        String query = 'Select id,Customer_Name__c,IsDrafted__c,IsInSelectedList__c, '+
                            'isNew__c,isRegistered__c,ISselected__c,Warranty_Registration__c, '+
                            'WR_FDS_Product__c,WR_Line_Item__c,WR_FDS_Product__r.Converted_To_Asset__c,WR_FDS_Product__r.Serial_Number__c, '+
                            'WR_FDS_Product__r.WR_ORACLE_SalesOrder__r.Purchase_Order__c,WR_FDS_Product__r.Product_Name__c, '+
                            'WR_FDS_Product__r.Product_Type__c '+
                        ' From WR_StagingSelection__c '+
                        'Where Warranty_Registration__c = :warrantyID '+
                        'And IsInSelectedList__c = :IsInSelectedList Order by '+String.escapeSingleQuotes(SortField)+' '+sortOrder +' limit 10000';
        system.debug('Query========>'+query);           
        ApexPages.Standardsetcontroller standardSetController = new ApexPages.Standardsetcontroller(Database.query(query));
        standardSetController.setPageSize(pageSize);
        return standardSetController;
    }
    
    //Remove Records from WR_StagingSelection  
     @future 
    public static void cleanWarrantyStagingData(Id warrantyID,Boolean IsInSelectedList,Datetime currentTimeStamp){
        system.debug('currentTimeStamp:::' + currentTimeStamp);
        List<WR_StagingSelection__c> records = new List<WR_StagingSelection__c>();
        for(WR_StagingSelection__c w : [select id from WR_StagingSelection__c where Warranty_Registration__c =:warrantyId AND IsInSelectedList__c = :   IsInSelectedList AND Timestamp__c < :currentTimeStamp limit 10000]){
            records.add(w);
        }
        if(!records.isEmpty())
            delete records;
    }
    /*
        Remove Records from WR_StagingSelection  
        @param warrantyID , id of Warranty
    */
    @future 
    public static void cleanWarrantyStagingData(Id warrantyID,Datetime currentTimeStamp){
        List<WR_StagingSelection__c> records = new List<WR_StagingSelection__c>();
        for(WR_StagingSelection__c w : [select id from WR_StagingSelection__c where Warranty_Registration__c =:warrantyId AND Timestamp__c < :currentTimeStamp limit 10000]){
            records.add(w);
        }   
        if(!records.isEmpty())
            delete records; 
    }   
    
    
     // Delete WR_Lineitems of Warranty that are removed. 
     public static void updateWarrantyLineItem(ID id){
        Set<ID>  productIds = new Set<ID>();
        set<ID>  newProducts = new Set<ID>();
        Set<ID> savedProducts = new Set<ID>();
        for(WR_Line_Item__c item : [select ID,WR_FDS_Product__c From WR_Line_Item__c where Warranty_Registration__c =: id]){
            savedProducts.add(item.WR_FDS_Product__c);
        }
        for(WR_StagingSelection__c selectedProduct : [Select id,WR_FDS_Product__c,IsInSelectedList__c,WR_Line_Item__c from WR_StagingSelection__c where Warranty_Registration__c = :id]) {
            if(selectedProduct.IsInSelectedList__c && savedProducts.contains(selectedProduct.WR_FDS_Product__c)){
                productIds.add(selectedProduct.WR_FDS_Product__c);// Don't delete this
            }else if(selectedProduct.IsInSelectedList__c && selectedProduct.WR_Line_Item__c == null){ // New Line Item
                newProducts.add(selectedProduct.WR_FDS_Product__c);
            }
        }
        // remove saved but removed entries (not existing in selectedProducts (step 3))
        List<WR_Line_Item__c> oldItems = [select ID From WR_Line_Item__c where Warranty_Registration__c =: id AND WR_FDS_Product__c NOT IN :productIds];
        delete oldItems;
        // save new entries 
        List<WR_Line_Item__c> lineItems = convertIntoWRLineItems(newProducts,id);
        if(!lineItems.isEmpty()){
            insert lineItems;
        }       
     }
      /************************************************************************************************
      @param Set<ID> products
      @return insert WR_Lineitem for each WR_FDS_Product and return list.
      ************************************************************************************************/
      public static List<WR_Line_Item__c> convertIntoWRLineItems(Set<ID> products,ID warrantyId){
            List<WR_Line_Item__c> wrLineItems = new List<WR_Line_Item__c>();
            for(ID id :products){
                WR_Line_Item__c wrLineItem = new WR_Line_Item__c();
                wrLineItem.WR_FDS_Product__c = id;
                wrLineItem.Warranty_Registration__c = warrantyId;
                wrLineItems.add(wrLineItem);   
           } 
           return wrLineItems;      
      }   
      
      /************************************************************************************************
      @param String partner name , String currentUser Name
      Send mail to Lito, amit and Gopi when Total btach running exceed maximum limit
      ************************************************************************************************/
      public static void sendBatchLimitEmail(String partner, String currUser){
            
            String email_Amit = WR_Batch_Limit_EmailIds__c.getInstance('EmailAddress_Amit').Batch_Limit_Email_Recepient_Id__c;
            String email_Lito = WR_Batch_Limit_EmailIds__c.getInstance('EmailAddress_Lito').Batch_Limit_Email_Recepient_Id__c;
            String email_Upendra = WR_Batch_Limit_EmailIds__c.getInstance('EmailAddress_Upendra').Batch_Limit_Email_Recepient_Id__c;
            String[] toAddresses = new String[]{email_Amit,email_Lito,email_Upendra};
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddresses);
            mail.setPlainTextBody(Label.Partner+' '+partner+' '+Label.Of+' '+currUser+' '+Label.Wait_for_completing_batches+' ' + Label.Batch_Class_Error_Message);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
      }   
      
      /************************************************************************************************
      @param Set<ID> stagingIdsToDel > WR_StagingSelection__c Ids to delete after warranty completion
      ************************************************************************************************/
      @future
      public static void deleteStagingDataOfCompletedWR(set<Id> stagingIdsToDel){
        
        List<WR_StagingSelection__c> stagingListToDel = new List<WR_StagingSelection__c>();
        WR_StagingSelection__c stagingRec;
        for(Id stagingId : stagingIdsToDel){
            stagingRec = new WR_StagingSelection__c(Id = stagingId);
            stagingListToDel.adD(stagingRec);
        }
        if(stagingListToDel.size() > 0){
            delete stagingListToDel;
        }
                 
      }     
      
  
}