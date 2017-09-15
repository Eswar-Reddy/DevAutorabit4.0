/*
Name : SOA2SearchTransactionsController
Created On : 17th Nov,2010
Created By : Accenture  
Implementation:
 Controller class for SOA2SearchTransactions Page. 
 Used to search PDF Transaction files (attachment) based on doc no, transaction date and type.
No of SOQL = 1  
*/


public with sharing class  SOA2SearchTransactionsController {
            
      static String SEPERATOR = '__'; 
      
      //used to calculate the even and odd number for table rows css
      static Integer SRNO = 1;
      static Integer DISPLAY_RESULT = 15;
      static Map<Integer,String> MONTHS = new Map<Integer,String>{1 =>'Jan',2=>'Feb',3=>'Mar',4=>'Apr',5=>'May',6=>'Jun',7=>'Jul',8=>'Aug',9=>'Sep',10=>'Oct',11=>'Nov',12=>'Dec'};
      
      public List<SOA2TransactionDetails__c> allResultList = new List<SOA2TransactionDetails__c>();
      public List<InvoiceDetail> lstSearchResult {set;get;}
      //used to display page numbers based on search result
      public List<Integer> pageNumbers {set;get;}
      //find the partner of logged in user
      public String partnerId {get;set;}
      public String selectedAttachmentId {set;get;}
      public String selectedAttachmentName {set;get;}
      public String selectedAttachmentPartnerId {set;get;}
      public String ERROR {set;get;}
      
      //Used to display seach fields 
      public SOA2TransactionDetails__c trnDetails{
        get{
            if(trnDetails== NULL)
              trnDetails = new SOA2TransactionDetails__c();
            return trnDetails;  
        }set;
      }
      
      //Used to display calendar for trasaction "from" date selection
      public SOA2TransactionDetails__c toDate{
        get{
            if(toDate == NULL)
              toDate = new SOA2TransactionDetails__c();
            return toDate;  
        }set;
      
      }
      
      public SOA2SearchTransactionsController(){
         List<User> user = [Select Contact.AccountId, Contact.Id, ContactId 
                            From User 
                            where id =:userInfo.getUserId()
                            and contactId !=NULL];
         partnerId = user.isEmpty() ? NULL : user[0].Contact.AccountId; 
         initializeProperties();
         sortOnColumn = 'Doc_No__c';
         sortOrder = 'ASC';
         ERROR = '';
      }     
      //**********************************************************************************
      // Attributes used for search
      //**********************************************************************************
      //public static integer DISPLAY_RECORD_LIMIT = 10;
      
      public Integer displayRecordLimit{get;set;}
      public Integer totalSearchResult {get;set;}
      public Integer totalPage {get;set;}
      
      public Integer displayResultStartIndex{get;set;}
      public Integer displayResultEndIndex{get;set;}
      public Integer selectedPageIndex{get;set;}
      
      //for sorting on search results
      public String sortOnColumn {set;get;}
      public String sortOrder {set;get;}
     
     //initialize properties      
     public void initializeProperties(){
          lstSearchResult = new List<InvoiceDetail> (); 
          allResultList = new List<SOA2TransactionDetails__c>();
          displayRecordLimit = 0;
          totalSearchResult = 0;
          totalPage = 0;
          displayResultStartIndex = 0;
          displayResultEndIndex = 0;
          selectedPageIndex = 0;
     }      
     public void openDocument(){
        if(selectedAttachmentName != '' && selectedAttachmentName != NULL && selectedAttachmentPartnerId != '' && selectedAttachmentPartnerId != NULL){
          /*capture the details for audit and oncomplete of this method javascript will open the page*/
          SOA2OpenPdfFileController ctrl= new SOA2OpenPdfFileController();
          ctrl.trackPDFDetails(selectedAttachmentName,selectedAttachmentPartnerId);
        }
    }
    public Boolean validateDates(){
        ERROR =''; 
        if(trnDetails.Transaction_Date__c != NULL){
             Integer dateDiff = trnDetails.Transaction_Date__c.daysBetween( system.today());
             system.debug('*******************:dateDiff : ' + dateDiff);
             if(dateDiff > 730){
               ERROR ='OLDFILE';
               return true;
             }
        }
        return false;
    }
     public void searchDocNo(){
          initializeProperties();
          if(validateDates()) return;
          String queryStr = ' Select Transaction_Type__c, Transaction_Date__c,Attachment_Id__c, Partner__c, Doc_No__c, Customer_Number__c ' +
                          ' From SOA2TransactionDetails__c '; 
                 queryStr += whereCondition() + ' ORDER BY ' + sortOnColumn + ' '+ sortOrder +' LIMIT 5000' ; // + Limits.getLimitQueryRows();
           system.debug('***********queryStr***********' + queryStr);
           allResultList = Database.query(queryStr);
           totalSearchResult = allResultList.size();                   
           
           displayRecordLimit = (totalSearchResult >= DISPLAY_RESULT) ? DISPLAY_RESULT : totalSearchResult;
           
           if(totalSearchResult > 0){
               //calculate number of pages
               totalPage = (totalSearchResult > (displayRecordLimit * (totalSearchResult / displayRecordLimit))) ? (totalSearchResult / displayRecordLimit) + 1 : (totalSearchResult / displayRecordLimit) ;
               //start index point 
               if(totalPage > 0){
                   selectedPageIndex = 1;
               }
               filterIndexToDisplay();
           }else{
             ERROR = 'No record found!!!';
           }    
     }
     public void filterIndexToDisplay(){
        lstSearchResult = new List<InvoiceDetail> ();
        displayResultStartIndex =  ((selectedPageIndex - 1) * displayRecordLimit) + 1;
         
        //if end index point is greater then number of search reasult then assign the number of search result value 
        displayResultEndIndex =  ((displayResultStartIndex +  displayRecordLimit) <= totalSearchResult) ? (displayResultStartIndex +  displayRecordLimit)  -1 : totalSearchResult ;
        
        System.debug('*********************************TOTAL PAGE ***********: ' + totalPage);
        System.debug('*********************************SELECTED INDEX ***********: ' + selectedPageIndex);
        System.debug('*********************************START INDEX ***********: ' + displayResultStartIndex); 
        System.debug('*********************************END INDEX ***********: ' + displayResultEndIndex);
        System.debug('*********************************TOTAL RESULT ***********: ' + totalSearchResult);
        System.debug('*********************************TOTAL RESULT (totalSearchResult)***********: ' + totalSearchResult);
        
        for(Integer sIndex = displayResultStartIndex - 1; sIndex < displayResultEndIndex; sIndex++ ){
            if(totalSearchResult <= sIndex) break;
            SOA2TransactionDetails__c transDetails = allResultList.get(sIndex);
            lstSearchResult.add(new InvoiceDetail(transDetails));
        }
        if(totalPage > 0) pageNumbersToDisplay();
     }
     
     
     // we will display only 15 number to select at a time and selected page will be highlighted in middle section.
     public void pageNumbersToDisplay(){
        pageNumbers = new List<Integer>();
         
        Integer sIndex = ((selectedPageIndex + 7) <= totalPage && (selectedPageIndex - 7) < 1) ? 1 : selectedPageIndex - 7 ;
        Integer eIndex = 0;
        
        if((sIndex + 14) <= totalPage){
            eIndex = sIndex + 14 ;
        }else{
           eIndex = totalPage;
           sIndex = (eIndex - 15 < 1) ? 1 : eIndex - 14;    
        }
        
        for(Integer i = sIndex; i <= eIndex; i++ ){
             pageNumbers.add(i);    
        }
     }
     public void sortSearchResults(){
        if(totalSearchResult > 0)
              searchDocNo();
     }
     public String whereCondition(){
         String whereConttion = '';
         
         //when user logged in as a partner then only he/she can see his own attachments.
         if(partnerId != NULL){
            whereConttion += ' WHERE partner__c = \''+ partnerId + '\''; // we can replace this statement using with sharing 
         }
         
         if(trnDetails.Doc_No__c != NULL && trnDetails.Doc_No__c != ''){
           if(whereConttion.contains('WHERE')){
             whereConttion += ' AND Doc_No__c LIKE \''+ trnDetails.Doc_No__c +'%\'';  
            }else{
             whereConttion += ' WHERE Doc_No__c LIKE \''+ trnDetails.Doc_No__c +'%\'';  
            }
         }
         if(trnDetails.Transaction_Type__c != NULL && trnDetails.Transaction_Type__c != '' && trnDetails.Transaction_Type__c != 'All'){
            if(whereConttion.contains('WHERE')){
             whereConttion += ' AND Transaction_Type__c = \''+ trnDetails.Transaction_Type__c +'\'';  
            }else{
             whereConttion += ' WHERE Transaction_Type__c = \''+ trnDetails.Transaction_Type__c +'\'';  
            }
         }
         if(trnDetails.Transaction_Date__c != NULL){
            if(whereConttion.contains('WHERE')){
             whereConttion += ' AND Transaction_Date__c >='+ dateYYYYMMDD(trnDetails.Transaction_Date__c);  
            }else{
             whereConttion += ' WHERE Transaction_Date__c >='+ dateYYYYMMDD(trnDetails.Transaction_Date__c);  
            }
         }
         if(toDate.Transaction_Date__c != NULL){
            if(whereConttion.contains('WHERE')){
             whereConttion += ' AND Transaction_Date__c <='+ dateYYYYMMDD(toDate.Transaction_Date__c);  
            }else{
             whereConttion += ' WHERE Transaction_Date__c <='+ dateYYYYMMDD(toDate.Transaction_Date__c);  
            }
         }
         
      return whereConttion;
     }
     
     
     public String dateYYYYMMDD(Date dt){
        return dt.year() +'-'+ (dt.month() < 10 ? '0'+ dt.month(): dt.month()+'') +'-'+ (dt.day() < 10 ? '0'+ dt.day(): dt.day()+'');
     }
     
     public class InvoiceDetail{
        public Integer sNo  {set;get;}
        public String backColor {set;get;}
        public SOA2TransactionDetails__c soa2TranDetail {set;get;}
        //public String docId {set;get;}
        public String trnDate {set;get;}
        
        public InvoiceDetail(SOA2TransactionDetails__c soa2TranDetail){
          this.soa2TranDetail = soa2TranDetail;
          // used to set style of table rows 
          this.sNo = SRNO++;
          this.backColor = Math.mod(sNo,2) == 0 ? 'datatable-std-row-even' : 'datatable-std-row-odd';
          //format the date in format MMM DD, YYYY
          if(soa2TranDetail.Transaction_Date__c != NULL)
              this.trnDate = MONTHS.get(soa2TranDetail.Transaction_Date__c.Month()) + ' ' + soa2TranDetail.Transaction_Date__c.Day() +', '+soa2TranDetail.Transaction_Date__c.Year();
        }
     } 
     
     public static testmethod void TestSOA2SearchTransactionsController(){
        List<RecordType> recType = [Select Id from RecordType where Name='Partner'];
        String docName = '7897888_9999_12548JAN.pdf';
        
        //insert account
        Account acc = new Account();
        acc.Name = 'Partner Account_'+ System.now();
        acc.Oracle_Account_Number__c = '9999' ;
        acc.Account_Status__c = 'Prospective';
        acc.SPWR_Relationship_Type__c = 'Competitor';
        acc.Phone = '2352352355';
        acc.BillingCity = 'Chennai';
        acc.BillingCountry = 'India';
        acc.BillingStreet = 'st.john Street';
        acc.BillingPostalCode = '3275932';
        
        //if(!recType.isEmpty())
            //acc.RecordTypeId = recType[0].Id;
        insert acc;
        acc = [select Id,Oracle_Account_Number__c from Account where Id=:acc.Id];
        
        
        
        
         //insert attachment
        Attachment att = new attachment();
        att.Name = docName;
        att.ParentId = acc.Id;
        att.Body = Blob.valueOf('Hello World... This is test document');
        att.ContentType = 'application/msword';
        insert att;
        
        SOA2TransactionDetails__c trnDtl = new SOA2TransactionDetails__c();
        trnDtl.Transaction_Type__c = 'Invoice'; 
        trnDtl.Transaction_Date__c = System.Today(); 
        trnDtl.Doc_No__c  = docName;
        trnDtl.Partner__c = acc.Id;
        trnDtl.Attachment_Id__c = att.Id;
        trnDtl.Customer_Number__c = acc.Oracle_Account_Number__c;
        insert trnDtl;     
                   
        trnDtl = [select partner__c, Attachment_Id__c from SOA2TransactionDetails__c where id =:trnDtl.id];
        
        SOA2SearchTransactionsController ctrl = new SOA2SearchTransactionsController();
        ctrl.trnDetails.Transaction_Date__c = System.Today();
        ctrl.toDate.Transaction_Date__c = System.Today();
        ctrl.trnDetails.Doc_No__c = docName;
        ctrl.trnDetails.Transaction_Type__c = 'Invoice';
        ctrl.searchDocNo();
        ctrl.sortSearchResults();
        ctrl.selectedAttachmentId = trnDtl.Attachment_Id__c;
        ctrl.selectedAttachmentName = docName; 
        ctrl.selectedAttachmentPartnerId = trnDtl.partner__c;
        ctrl.openDocument();
        
        //insert attachment to remove duplicate 
        //to fire trigger which used to delete previous existing file with the same name. 
        Attachment att2 = new attachment();
        att2.Name = docName;
        att2.ParentId = acc.Id;
        att2.Body = Blob.valueOf('Hello World... This is test document');
        att2.ContentType = 'application/msword';
        insert att2;
        
        trnDtl = [select partner__c, Attachment_Id__c from SOA2TransactionDetails__c where id =:trnDtl.id];
        //system.assertEquals(trnDtl.Attachment_Id__c,att2.Id+'');
        
        //to fire trigger which used to delete the old files
        trnDtl.Delete_Attachment__c = true;
        update trnDtl;
        
     }
     
}