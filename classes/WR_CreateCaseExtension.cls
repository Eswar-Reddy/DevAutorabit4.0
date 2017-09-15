/*******************************************************************
  Name          :         WR_CreateCaseExtension     
  Purpose       :         Extesnion for CaseLogger page, used for logging case
  
  Created by    :    Anjali Khandelwal(Appirio Off)
  Created Date  :   5th Sept, 2011
  Revision History:
  05.SEP.2011    Anjali Khandelwal    Created.
  27.FEB.2014    Michelle Magsarili   Change Case RecordType to PSR Case CR Implementation changes
  19.FEB.2016      Ralph Alega             Provided default values for Case fields Type, Categories, Sub-categories, Case Differentiator (Case 00659324)
********************************************************************/

public with sharing class WR_CreateCaseExtension {
    
    private static String SEARCH_RESULT_SEPERATOR = ',\t\t';
    public Case caseLog{get;set;}
    //MAM 02/27/2014 Change Case RecordType to PSR Case start
    //private static final String CASE_RECORD_TYPE = 'CRM_Case';   
    //private static final String CASE_OWNER = 'CRM Case'; 
    //MAM 02/27/2014 end
    public String errMsg;     
    String caseType;
    String warrantyId;
    String numList;
    String oracleAccNum;
    Date startdt;
    Date endDt;
    
    public Blob fileContent{get;set;}
    public String fileStr{get;set;}
    public Warranty_Registration__c warranty{get;set;}

    public List<WR_SalesOrderWrapper> salesOrderList{get;set;}
    User user;
    //Warranty_Case_Owner__c caseOwner;
    public WR_CreateCaseExtension(apexPages.Standardcontroller controller){
              
        caseType = ApexPages.currentPage().getParameters().get('caseType');      
        warrantyId = ApexPages.currentPage().getParameters().get('warrantyId');
        numList = ApexPages.currentPage().getParameters().get('numList');
        errMsg = ApexPages.currentPage().getParameters().get('errMsg');
        String stDate = ApexPages.currentPage().getParameters().get('stDate');
        String end_Dt = ApexPages.currentPage().getParameters().get('endDt');
        system.debug('numList::::' + numList);
        if(stDate != null && stDate != '')
            startdt = date.parse(stDate);
        if(end_Dt != null && end_Dt != '')
            endDt = date.parse(end_Dt);
        user = retrieveUser(UserInfo.getUserId());
        //caseOwner = retrieveCaseOwner();
        if(user != null && user.Contact.Account.Oracle_Account_Number__c != null)
            oracleAccNum = user.Contact.Account.Oracle_Account_Number__c;
       
        //Query salesOrders        
        WR_SalesOrderFilter salesOrderFiler = new WR_SalesOrderFilter();
        salesOrderFiler.deliveryStartDate = startdt;
        salesOrderFiler.deliveryEndDate = endDt;
        salesOrderFiler.numberType = caseType;
        salesOrderFiler.numberValue = numList;
        salesOrderFiler.partnerAccountNumber = oracleAccNum;
        if(numList != null && numList != ''){
            try{
                salesOrderList = WarrantyRegistrationUtil.findSalesOrders(salesOrderFiler);
            }catch(WR_CustomViewStateException ex){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Refine_Search_Criteria));
            }
        
        }
      
        if(warrantyId != null && warrantyId != '')
            warranty = retrieveWarranty(warrantyId);
            
        //MAM 02/27/2014 Change Case RecordType to PSR Case start
        //if(warranty != null){
        //    Id rectypeId = RetrieveRecordTypeId(CASE_RECORD_TYPE);
        //    caseLog = createCase(rectypeId, salesOrderList);
        //}
       
        Map<String,Id> caseRTs = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Case.SObjectType); //Get Case RecordTypes
        Id rectypeId = caseRTs.get('PSR_Case');
        caseLog = createCase(rectypeId, salesOrderList);
        //MAM 02/27/2014 end
    }  
    
    //MAM 02/27/2014 Start - Use the SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName method instead
    //-------------------------------------------------------------------------// 
      // Retrieve Record TypeId 
    //------------------------------------------------------------------------//                      
    /*private string RetrieveRecordTypeId(string RecordName) {
        List<RecordType> lstRecordType = [SELECT Id FROM RecordType 
                                           WHERE SobjectType = 'Case' 
                                           And DeveloperName =: RecordName];
        string recordTypeId = '';
        if(lstRecordType.size() > 0) {
          recordTypeId = lstRecordType[0].Id;
        }
        return recordTypeId;
    }
    */
    //MAM 02/27/2014 end
    //-------------------------------------------------------------------------// 
      // Retrieve Owner Id 
    //------------------------------------------------------------------------//                      
    private User retrieveUser(Id userId) {
        User usr = [Select contact.Account.Assigned_PSR_IDS__c,contact.Account.Primary_PSR__c,Contact.AccountId,
                    Contact.Account.Name,u.ContactId,u.Contact.Name, u.Case_Owner__c,
                    Contact.Account.Oracle_Account_Number__c,Contact.Account.Theater__c,
                    Contact.Account.Oracle_Operating_Unit__c 
                    From User u where Id =: userId];
        return usr;
    }
    
    //-------------------------------------------------------------------------// 
      // Retrieve default case Owner
    //------------------------------------------------------------------------//                      
    // private Warranty_Case_Owner__c retrieveCaseOwner() {
        //Warranty_Case_Owner__c wr_CaseOwner = [Select w.Name, w.Id, w.CaseOwnerId__c From Warranty_Case_Owner__c w where name='Case Owner ID'];
        //return wr_CaseOwner;
        //List<Warranty_Case_Owner__c> wr_CaseOwnerList = Warranty_Case_Owner__c.getall().values();
        //Warranty_Case_Owner__c wr_CaseOwner = Warranty_Case_Owner__c.getInstance('Case Owner ID');
        //return null;
    //}
    
    //-------------------------------------------------------------------------// 
      // Retrieve warranty record
    //------------------------------------------------------------------------//                      
    private Warranty_Registration__c retrieveWarranty(String warrantyId) {
        if(warrantyId == null || warrantyId == '') return null;
        
        Warranty_Registration__c warranty = [Select w.Warranty_Number__c, w.Partner_SFDC_ID__c, w.Customer_SFDC_ID__c,w.Partner_SFDC_ID__r.Name, w.Customer_SFDC_ID__r.Name From Warranty_Registration__c w where id =: warrantyId];
        
        return warranty;
    }
    
    private Case createCase(String rectypeId, List<WR_SalesOrderWrapper> salesOrderList /*, String notMatchedNumStr, string matchedNumStr*/){
        Case cLog = new Case();
        
        //MAM 03/05/2014 CRM to PSR Case Record Type Changes start 
        //MAM 03/05/2014 Old Fields and their Previous values
        //cLog.Type = 'Problem';
        //cLog.Subject = 'On Line Warranty Auto Case CRM #';
        //cLog.AccountId = user.Contact.AccountId;
        //cLog.Functional_Area__c = 'Warranty Registrations';
        //cLog.Business_Unit__c = 'Global';
        //cLog.Impacted_User_Type__c = 'Internal SunPower';
        
        cLog.Subject = 'On Line Warranty Auto Case';
        
        // Case Owner would be Primary PSR if it is not blank, 
        // if Primary PSR is blank then values are taken from Assigned PSR 
        // Default assignment (should both Primary PSR and Assigned PRS be blank) is the PSR Online Warranty Case Queue 
        // This is configured via the Warranty Case Owner Detail Custom Setting
        if(user.contact.Account.Primary_PSR__c != null)
             cLog.ownerId = user.contact.Account.Primary_PSR__c;
        //MAM 10/07/2014 remove Assigned_PSR_IDS__c reference start
        /*else if(user.contact.Account.Assigned_PSR_IDS__c != null){
            cLog.ownerId = user.contact.Account.Assigned_PSR_IDS__c.split(',')[0];
        }*/
        //MAM 10/07/2014 end 
        else{
            cLog.ownerId = Warranty_Case_Owner__c.getInstance('Case Owner ID').WR_CaseOwnerId__c;           
        }
        
        cLog.recordTypeId = rectypeId;                         //rectypeId = PSR Case Record Type
        cLog.AccountId = warranty.Customer_SFDC_ID__c;         //Account should be linked to the customer account that the warranty is being created
        cLog.Partner_Name__c = user.Contact.AccountId;      //Account of the Portal  user
        cLog.ContactId = user.ContactId;                       //Contact link to the Portal User record
        cLog.Priority = 'High';
        cLog.Business_Unit__c = 'RLC';
        cLog.Origin = 'Auto-case';  //R.Alega - Case 00716458 - 18.MAY.2016 - Change "Auto Case Warranty" to "Auto-case" picklist value.
        
        //R.Alega - Case 00659324 - START
        cLog.Type = 'Negative Feedback';
        cLog.Case_Differentiator__c = 'Non Product-Related';
        
        //Operating Unit (API Name: Region__c) conditions
        //If Partner Account Theater is North America or Central America and Caribbean, then Operating Unit is SPNA
        if(String.ValueOf(user.Contact.Account.Theater__c).contains('North America') ||
           String.ValueOf(user.Contact.Account.Theater__c).contains('Central America and the Caribbean')){
            cLog.Region__c = 'SPNA';
        }
        //If Partner Account Theater is Europe, then Operating Unit depends on the “Oracle Operating Unit field” in the Partner Account record
        else if(String.ValueOf(user.Contact.Account.Theater__c).contains('Europe')){
            if(!String.isBlank(user.Contact.Account.Oracle_Operating_Unit__c)){
                cLog.Region__c = String.ValueOf(user.Contact.Account.Oracle_Operating_Unit__c).replace(' OU', '');
            }
        }
        
        if(errMsg != null)
            cLog.Description = Label.Error_Description+' :-\n\n'+ Label.Error_Message+' :- '+errMsg +'\n'+ Label.Search_by+' :-'+caseType+'\n'+ Label.Search_Values+' :-'+numList+'\nSearch Result:-\n';
        else
            cLog.Description = Label.Error_Description+' :-\n\n'+ Label.Search_by+' :-'+caseType+'\n'+ Label.Search_Values+' :-'+numList+'\nSearch Result:-\n';
        if(salesOrderList != null && salesOrderList.size() > 0){
            cLog.Description += '\n'+Label.Customer_PO+ SEARCH_RESULT_SEPERATOR+'\t\t' + Label.Sales_Order+ SEARCH_RESULT_SEPERATOR + Label.Packing_List+ SEARCH_RESULT_SEPERATOR + Label.Date_SO;
            String salesOrderDataStr = '';
            if(cLog.Description.length() < 25000){
                for(WR_SalesOrderWrapper sow : salesOrderList){
                    salesOrderDataStr = '';
                    salesOrderDataStr = sow.salesOrder.Purchase_Order__c+SEARCH_RESULT_SEPERATOR+'\t\t' + sow.salesOrder.Sales_Order__c+SEARCH_RESULT_SEPERATOR + sow.packingSlip+SEARCH_RESULT_SEPERATOR + sow.salesOrder.So_Created__c;
                    cLog.Description += '\n'+salesOrderDataStr;
                }
            }
        }
        
        //R.Alega - Case 00659324
        cLog.Categories__c = 'Account Management';    
        cLog.Sub_Categories__c = 'Warranty Registration';
        
        //R.Alega - Case 00659324 - END
        
        //MAM 03/05/2014 end
        
        system.debug('cLog:::::::::::::' + cLog);
        return cLog;
    }
    
    public PageReference logCase(){
        try{ 
            System.debug('Case ->'+caseLog);
            //caseLog.description = errMsg +'\n'+caseLog.description+'\n -------Other Information for Support-------\n Search By :-'+caseType+'\n Search Values :-'+numList+'\n Dealer Name :- '+warranty.Partner_SFDC_ID__r.Name+' \n Customer Name :- '+warranty.Customer_SFDC_ID__r.Name;
            if(warranty != null){
                PageReference pageRef = new PageReference('/' + warranty.id);
                String host = ApexPages.currentPage().getHeaders().get('Host'); 
                String Url = 'https://' + host + pageRef.getUrl();
                caseLog.description = caseLog.description+'\n -------Other Information for Support-------\n  Dealer Name :- '+warranty.Partner_SFDC_ID__r.Name+' \n Customer Name :- '+warranty.Customer_SFDC_ID__r.Name+' \n Warranty Number :- '+ warranty.Warranty_Number__c+' ' +Url;
                
             
            //String cseSolution = sol.Name + ' - ' + Url + '\n\n';
            }else
                caseLog.description = caseLog.description+'\n -------Other Information for Support-------\n  Dealer Name :- '+user.Contact.Account.Name;
            
            insert caseLog; 
            caseLog = [Select caseNumber,subject,description from Case where id=:caseLog.Id limit 1];
            Attachment attach;
            if(caseLog.Id != null && fileContent != null){
                attach = new Attachment();
                attach.Body = fileContent;
                attach.Name = fileStr;
                attach.ParentId = caseLog.Id;
            }
            if(attach != null)
                insert attach;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.Case_Log_Success_Msg +' ' +caseLog.CaseNumber+'. '+Label.Case_Log_Reference_Msg));
            fileContent = null;            
        }
        catch(DMLException ex){
            fileContent = null;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            return null;
        }
        return null;
    }
    
   
    /* private void getLength(List<WR_SalesOrderWrapper> salesOrderList){
        
        for(WR_SalesOrderWrapper sow : salesOrderList){
            if(sow.salesOrder.Purchase_Order__c.length() > purchaseOrderlen){
                purchaseOrderlen = sow.salesOrder.Purchase_Order__c.length();
            }
            if(sow.salesOrder.Sales_Order__c.length() > salesOrderlen){
                salesOrderlen = sow.salesOrder.Sales_Order__c.length();
            }
            if(sow.packingSlip.length() > packingSliplen){
                packingSliplen = sow.packingSlip.length();
            }
        }
        
        if(purchaseOrderlen > Label.Customer_PO.length()){
            purchaseOrderlen = purchaseOrderlen - Label.Customer_PO.length();
        }
        if(salesOrderlen > Label.Sales_Order.length()){
            salesOrderlen = salesOrderlen - Label.Sales_Order.length();
        }
        if(packingSliplen > Label.Packing_List.length()){
            packingSliplen = packingSliplen - Label.Packing_List.length();
        }
        //String PO_Space = '';
        for(Integer len = 0; len< purchaseOrderlen;len++){
            PO_Space+='\t';
        }
        //String SO_Space = '';
        for(Integer len = 0; len< salesOrderlen;len++){
            SO_Space+='\t';
        }
        //String PL_Space = '';
        for(Integer len = 0; len< packingSliplen;len++){
            PL_Space+='\t';
        }
    }
    
    //-------------------------------------------------------------------------// 
      // Get string in date format according to theater
    //------------------------------------------------------------------------// 
    public Date getDate(String dateStr){
        String[] dtArgs;
        Date dt;
        if(user.Contact.Account.Theater__c != null){
            if(user.Contact.Account.Theater__c == 'Europe'){
                String separator = dateStr.substring(2,3);
                dtArgs = dateStr.split('\\'+separator);
                dt = Date.newInstance(Integer.valueOf(dtArgs[2]),Integer.valueOf(dtArgs[1]),Integer.valueOf(dtArgs[0]));
            }
        
            else if(user.Contact.Account.Theater__c == 'North America'){
                String separator = dateStr.substring(1);
                dtArgs = dateStr.split('\\/');
                dt = Date.newInstance(Integer.valueOf(dtArgs[2]),Integer.valueOf(dtArgs[0]),Integer.valueOf(dtArgs[1]));
            }
        }
        
        return dt;
    } */

}