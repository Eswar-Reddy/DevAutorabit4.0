/*
Name : SOA2OpenPdfFileController
Created On : 17th Nov,2010
Created By : Accenture  
Implementation:
 Controller class for SOA2OpenPdfFile Page. 
 Used to open PDF file based on passed parameter (Doc No.) and maintain the view and download history. 
*/


public with sharing class SOA2OpenPdfFileController {
    
    //used to calculate the even and odd number for table rows css
    static Integer SRNO = 0;
    //to format date
    static Map<Integer,String> MONTHS = new Map<Integer,String>{1 =>'Jan',2=>'Feb',3=>'Mar',4=>'Apr',5=>'May',6=>'Jun',7=>'Jul',8=>'Aug',9=>'Sep',10=>'Oct',11=>'Nov',12=>'Dec'};
    
    public String ERROR {set;get;}
    public List<InvoiceDetail> lstTrnDtl {set;get;}
    Map<Id,SOA2TransactionDetails__c> mapAttIdWithTrnDtl = new Map<Id,SOA2TransactionDetails__c>();
    public String selectedAttachment {set;get;}
    PageReference pg = NULL;
    public Account currentAccount{get;set;}//for case # 00058535
    public Boolean isAllowed{get;set;}//for case # 00058535
    public Boolean isPartner{get;set;}//for case # 00058535
    public String statusMsg{get;set;}//for case # 00058535
    public Final String ORACLE_ACC_NO_QS = 'accNo';//for case # 00058535
    
    public void initialize(){
      //initialize properties
       ERROR = '';
       selectedAttachment = '';
       lstTrnDtl = new List<InvoiceDetail>();      
    }
    public PageReference findAllDocuments(){
        initialize();
        String docNo = ApexPages.currentPage().getParameters().get('docId');
        //start for case # 00065029
        String accNo = ApexPages.currentPage().getParameters().get('accNo');        
        String andQuery = null;               
        if(accNo != null){
            andQuery = ' AND Customer_Number__c = \'' + accNo +'\'';
        }else{
            accNo = ApexPages.currentPage().getParameters().get('OracleAcctID');
            if(accNo != null){
                andQuery = ' AND Customer_Number__c = \'' + accNo +'\'';
            }
        }
        System.debug(loggingLevel.INFO,'Oracle Account Number recieved from Sunpower->' + accNo);
        //end for case # 00065029
        /*
                Query on Attachment for given document number/ transaction number
        */
        String query = ' Select Transaction_Type__c, Transaction_Date__c, Partner__c,Attachment_Id__c, Doc_No__c, Customer_Number__c ' +
                        ', Accessed_by_Partner__c' +//for case # 00059998
                          ' From SOA2TransactionDetails__c WHERE Doc_No__c LIKE \''+ docNo +'%\'' ;
        //start for case # 00065029  
        if(andQuery!=null && andQuery != '')
            query = query + andQuery;
        //end for case # 00065029                  
        System.debug('****************QUERY*************' + query);
        for(SOA2TransactionDetails__c TrnDtl:Database.query(query)){
                lstTrnDtl.add(new InvoiceDetail(TrnDtl));
                mapAttIdWithTrnDtl.put(TrnDtl.Attachment_Id__c,TrnDtl);
        }
        /*
                In case only one record found with given doc no then no need to display records on page as a list.
                just call the method to open document.
        */ 
        if(!lstTrnDtl.isEmpty() && SRNO == 1 && lstTrnDtl[0].soa2TranDetail.Attachment_Id__c != NULL){
            
                selectedAttachment = lstTrnDtl[0].soa2TranDetail.Attachment_Id__c;
                pg = openDocument();
        }               
        /*
           No record found then display msg and close the window using javascript
        */      
        if(lstTrnDtl.isEmpty())
          ERROR = 'File not found. Please contact to your Administrator.';
         return pg;     
    }
    
    public PageReference openDocument(){
        if(selectedAttachment != ''){
          /*capture the details for audit*/
          trackPDFDetails(mapAttIdWithTrnDtl.get(selectedAttachment).Doc_No__c,mapAttIdWithTrnDtl.get(selectedAttachment).Partner__c);
          pg = new PageReference('/servlet/servlet.FileDownload?file='+ selectedAttachment);
        }
        //start for case # 00059998
        if(!lstTrnDtl[0].soa2TranDetail.Accessed_by_Partner__c && UserInfo.getUserType() == 'PowerPartner'){            
            SOA2TransactionDetails__c transDetails = lstTrnDtl[0].soa2TranDetail;
            transDetails.Accessed_by_Partner__c = true;//for case #00067176
            update transDetails;//for case #00067176
        }
        //end for case # 00059998   
        return pg ;
    }
    
    /*insert record in audit detail table to track attachment view/download history*/
    public void trackPDFDetails(String docNo,Id partnerId){
        SOA2TransactionAuditDetail__c trnAuditDtl = new SOA2TransactionAuditDetail__c();
        trnAuditDtl.Doc_No__c = docNo;
        trnAuditDtl.Downloaded_by__c = UserInfo.getUserId();
        trnAuditDtl.Downloaded_Date__c = System.now();
        trnAuditDtl.Partner__c = partnerId;
        trnAuditDtl.Viewed_by__c = UserInfo.getUserId();
        trnAuditDtl.Viewed_Date__c = System.now();
        insert trnAuditDtl;
        system.debug('****************AUDIT RECORD INSERTED**************:' + trnAuditDtl.id);
        system.debug('****************AUDIT RECORD docNo**************:' + docNo);
        system.debug('****************AUDIT RECORD partnerId**************:' + partnerId);
        
    }
    
    /*inner class*/
    public class InvoiceDetail{
        public Integer sNo  {set;get;}
        public String backColor {set;get;}
        public SOA2TransactionDetails__c soa2TranDetail {set;get;}
        public String trnDate {set;get;}
        
        public InvoiceDetail(SOA2TransactionDetails__c soa2TranDetail){
          this.soa2TranDetail = soa2TranDetail;
          /* used to set style of table rows*/ 
          this.sNo = SRNO++;
          this.backColor = Math.mod(sNo,2) == 0 ? 'datatable-std-row-even' : 'datatable-std-row-odd';
          /*format the date in format MMM DD, YYYY*/
          if(soa2TranDetail.Transaction_Date__c != NULL)
              this.trnDate = MONTHS.get(soa2TranDetail.Transaction_Date__c.Month()) + ' ' + soa2TranDetail.Transaction_Date__c.Day() +', '+soa2TranDetail.Transaction_Date__c.Year();
        }
     }
     //start for case # 00058535
    /****************************************************************************************
         This section will handle the functionality of subscribe/unsubscribe page
                                    START SUB/UNSUB
    ****************************************************************************************/
    /*public User currentLoginUser{
        get{
            if(currentLoginUser == NULL)
              currentLoginUser = [select Id,Send_PDF_Notification__c from USer where id=:userinfo.getUserId()];
            return currentLoginUser;
        }set;
    }
    public void updateUser(){
      update currentLoginUser;
    }*/
     /****************************************************************************************
         This section will handle the functionality of subscribe/unsubscribe page
                                    START SUB/UNSUB for case # 00058535
    ****************************************************************************************/
    public void updateAccount(){
        System.debug(loggingLevel.INFO,'account Updated->' + currentAccount.Id);
        if(currentAccount.Send_PDF_Notification__c && currentAccount.Subscription_Date__c == null)
            currentAccount.Subscription_Date__c = System.now();
        else if(!currentAccount.Send_PDF_Notification__c)           
            currentAccount.Subscription_Date__c = null;
        try{                
            update currentAccount;
            statusMsg = System.Label.SOA2RecSave;           
        }catch(DMLException e){
            ApexPages.addMessages(e);       
            statusMsg = e.getMessage();
        }
    }
    
    public SOA2OpenPdfFileController(){
        isAllowed = false;
        isPartner = false;
        if(ApexPages.currentPage().getParameters().get('link')!=null && ApexPages.currentPage().getParameters().get('link') =='yes'){
            isPartner = true;
        }
        //isPartner = false;
        String oracleAccNo = ApexPages.currentPage().getParameters().get(ORACLE_ACC_NO_QS);
        System.debug(loggingLevel.INFO,'Oracle Account Number recieved from Sunpower->' + oracleAccNo);
        if(oracleAccNo == null){                        
            if(UserInfo.getUserType() == 'PowerPartner'){
                List<Contact> conList = [select Account.Oracle_Account_Number__c from Contact where Partner_Portal_User__c = :UserInfo.getUserId() limit 1];
                if(conList.size()>0)
                    oracleAccNo = conList.get(0).Account.Oracle_Account_Number__c;
            }
        }
        
        if(oracleAccNo != null){
            List<Account> accList = [select Id, Oracle_Account_Number__c, Send_PDF_Notification__c, Subscription_Date__c from Account where Oracle_Account_Number__c = :oracleAccNo limit 1];
            if(accList.size()>0)
                currentAccount = accList.get(0);
                isAllowed = true;   
        }else{
            isAllowed = false;  
        }
        
    }
    //end for case # 00058535
    /****************************************************************************************
                                    END SUB/UNSUB
    ****************************************************************************************/
    
      
    public static testMethod void TestSOA2OpenPdfFileController(){
        List<User> lstUser =[SELECT Id,Name,AccountId,ContactId 
                                 FROM user 
                                 WHERE ContactId != NULL 
                                 AND AccountId != NULL
                                 AND IsActive = true];//for case # 00058535
                                 
        if(lstUser.isEmpty()) return;
        
        //value must be true to send email notification 
        lstUser[0].Send_PDF_Notification__c = true;
        update lstUser[0];
        
        //updated account in case oracle account 
        Account acc = new Account(Id=lstUser[0].AccountId, Oracle_Account_Number__c = '5656');
        update acc;
        
        acc = [select Id,Name,IsPartner,Oracle_Account_Number__c from Account where Id=:lstUser[0].AccountId limit 1];
        String docName = '7897888_9999_12548JAN.pdf';
        
        AccountContactRole acRole = new AccountContactRole();
        List<AccountContactRole> acRoleList = new List<AccountContactRole>([Select accountID,contactId, Role from AccountContactRole where accountID=:lstUser[0].AccountId and contactId=:lstUser[0].ContactId and Role ='Finance Manager' limit 1]);
        if(acRoleList.size()>0){
            acRole = acRoleList.get(0);
        }else{        
            acRole.accountID = lstUser[0].AccountId;
            acRole.contactId = lstUser[0].ContactId;
            acRole.Role ='Finance Manager';
            insert acRole;
        }
        //insert attachment
        Attachment att = new attachment();
        //att.Name = acc.Oracle_Account_Number__c + '__'+ docName + '.pdf';
        att.Name = docName;
        att.Body = Blob.valueOf('Hello World... This is test document');
        att.ParentId = acc.Id; 
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
        System.assertEquals([select partner__c from SOA2TransactionDetails__c where id=:trnDtl.id limit 1].partner__c, acc.Id);        
        
        
        //calling class methods
        PageReference pg = Page.SOA2OpenPdfFile;
        pg.getParameters().put('docId','7897888');
        pg.getParameters().put('OracleAcctID','5656');        
        Test.setCurrentPage(pg);
        SOA2OpenPdfFileController ctrl = new SOA2OpenPdfFileController();
        ctrl.findAllDocuments();
        pg.getParameters().put('docId','78956958');
        pg.getParameters().put('accNo','5656');
        ctrl.findAllDocuments();
        //ctrl.updateUser();
        //start for case # 00058535
        acc = [select Id, Name, IsPartner, Oracle_Account_Number__c, Send_PDF_Notification__c,Subscription_Date__c  from Account where Id=:lstUser[0].AccountId limit 1];
        pg = Page.SOA2OpenPdfFile;
        
        pg.getParameters().put('accNo',acc.Oracle_Account_Number__c);
        pg.getParameters().put('link','yes');
        Test.setCurrentPage(pg);
        ctrl = new SOA2OpenPdfFileController();
        
        ctrl.currentAccount.Send_PDF_Notification__c = false;
        System.assertEquals(acc.Id, ctrl.currentAccount.Id);
        ctrl.updateAccount();
        pg.getParameters().put('accNo',null);
        System.RunAs(lstUser[0]){           
            ctrl = new SOA2OpenPdfFileController();        
            ctrl.findAllDocuments();
            pg.getParameters().put('docId','78956958');
	        pg.getParameters().put('accNo','5656');
	        ctrl.findAllDocuments();
	        ctrl = new SOA2OpenPdfFileController();      
            ctrl.currentAccount.Send_PDF_Notification__c = true;
            System.assertEquals(acc.Id, ctrl.currentAccount.Id);
            ctrl.updateAccount();
        }
        trnDtl = new SOA2TransactionDetails__c();
        trnDtl.Transaction_Type__c = 'Invoice'; 
        trnDtl.Transaction_Date__c = System.Today(); 
        trnDtl.Doc_No__c  = acc.Oracle_Account_Number__c + '_9999_12548JAN.pdf';
        trnDtl.Partner__c = acc.Id;
        trnDtl.Attachment_Id__c = att.Id;
        trnDtl.Customer_Number__c = acc.Oracle_Account_Number__c;
        insert trnDtl;
        System.assertEquals([select partner__c from SOA2TransactionDetails__c where id=:trnDtl.id limit 1].partner__c, acc.Id);       
        //end for case # 00058535
    }
}