/***********************************************************
//Created By- Ritesh Srivastava
//Created On- Sep 26 2016
//Version - 1.0
//Description- Controller Class for CreateStandardAccount
************************************************************/

public class CreateStandardAccount{
     public String errorMessage {get;set;}
     public string partnerId{get;set;}
     public List<Partner_Application__c> listPartner{get;set;}
     public Boolean isCreateAccount{get;set;}
     public Boolean isCreateContact{get;set;}     
     public Partner_Application__c partner{get;set;}
     public RecordType partnerRecordType {get;set;}
     
     /* Added for Sunpower Case # 00030862 */
     private ID partnerContactRecordTypeId;
     /**************************************/
     
     public CreateStandardAccount() {
        
        if(ApexPages.CurrentPage().getParameters().get('PId') != null) {
        
           partnerId= ApexPages.CurrentPage().getParameters().get('PId');
           partner =  new  Partner_Application__c();
           List<Partner_Application__c> listPartner = 
            [Select ID,Account__c,Contact__c,Zip__c,Bill_To_Country__c,Ship_To_Country__c, 
                Website__c, State__c, Phone__c, Employees__c, 
                Country__c, Company_Name__c, City__c, Address__c,
                Title__c, Mobile__c, Last_Name__c, First_Name__c,Fax__c, Email__c,
                Partner_Type__c, Theater__c,//for Case# 00072314
                RSM__c,CRSM__c,Area_Sales_Manager__c,RSM__r.FirstName,RSM__r.LastName,CRSM__r.FirstName,CRSM__r.LastName,Area_Sales_Manager__r.FirstName,Area_Sales_Manager__r.LastName,Director_of_Sales__r.FirstName,Director_of_Sales__r.LastName  //Replacing CRSM to director of Sales
                From Partner_Application__c 
                where Id = :partnerId limit 1];
                
           if(listPartner.Size()>0){
             partner = listPartner.get(0);
           }                                                             
        }
                
       //Making Record Type of Account as Standard as per requirement case # 664384
        for (RecordType partnerAccountRecordType:
            [Select r.Id 
                From RecordType r 
                where Name = 'Standard' and sobjectType = 'Account' limit 1]){
                    
            partnerRecordType=partnerAccountRecordType;             
        }
        
        /* Added for Sunpower Case # 664384  Changing Record type as Customer*/ 
        for (RecordType partnerContactRecordType : [SELECT Id FROM RecordType
                WHERE Name = 'Customer' AND SObjectType = 'Contact' LIMIT 1]) {
            partnerContactRecordTypeId = partnerContactRecordType.Id;
        }
     }        
    
    public PageReference confirm() {
        Account acct = new Account();
        if( partner.Account__c == null && isCreateAccount){
            acct.Name = partner.Company_Name__c;
            acct.BillingStreet = partner.Address__c;
            acct.BillingCity = partner.City__c;
            acct.BillingPostalCode = partner.Zip__c;
            //acct.BillingState = 'NA'; 
           // acct.BillingState = partner.State__c; // Commented out this line as Japan doesn't have a state
           // acct.BillingCountry = partner.Country__c;  //Changed due to validation Rule
            acct.BillingCountry = partner.Bill_To_Country__c;
            acct.ShippingCountry=partner.Ship_To_Country__c;
            acct.Phone = partner.Phone__c;
            acct.partner_Application__c =partner.Id;
            if(partner.Employees__c == null)
                partner.Employees__c =0.0;
            acct.NumberOfEmployees = partner.Employees__c.intValue();
            acct.Website = partner.Website__c;

            //Start for Case#00215703---Populate Account with RSM,CRSM,AreaSalesManager from Partner Account            
            acct.RSM__c=partner.RSM__c;
            acct.CRSM__c=partner.CRSM__c;
            acct.Area_Sales_Manager__c=partner.Area_Sales_Manager__c;
            //End for Case#00215703

            if (partner.Partner_Type__c==null)
                acct.Type = 'Other';
            else
                acct.Type = partner.Partner_Type__c;           
            
            if (partnerRecordType!=null)
                acct.RecordTypeId=partnerRecordType.Id;
                            
            acct.Status__c = 'Contract Pending';   
            //Start for Case# 00072314
            if(partner.Theater__c == 'Europe' && partner.Country__c == 'United Kingdom'){
                acct.CurrencyIsoCode ='GBP';
            }//End for Case# 00072314
            //Start 00099565
            else if(partner.Theater__c == 'Europe'){
                acct.CurrencyIsoCode ='EUR';
            }
            //End 00099565 
            //Start 00577265  
            else if (partner.Theater__c == 'Asia Pacific' && partner.Country__c == 'Japan') {
                acct.CurrencyIsoCode ='JPY';
            } // End 00577265           
            //Start for Case#00077674
            try{
                insert acct;
            }catch(DMLException ex){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
                return null;    
            }
            //End for Case#00077674
            partner.account__c = acct.ID;
        }
                  
        Contact cont = new Contact();
         if(partner.Contact__c == null && isCreateContact){
       
            if(acct.ID == null){
                cont.AccountID= partner.Account__c;
                }
            else{
                cont.AccountID= acct.ID;
            }
            
            /* Added for Sunpower Case # 00030862 */
            if (partnerContactRecordTypeId != null) {
                cont.RecordTypeId = partnerContactRecordTypeId;
            }
            /**************************************/
           
           
            cont.FirstName=partner.First_Name__c;
            cont.LastName=partner.Last_Name__c;
            cont.Title = partner.Title__c;
            cont.MailingStreet=partner.Address__c;
            cont.MailingCity=partner.City__c;
            cont.MailingPostalCode=partner.Zip__c;
            //cont.MailingState=partner.state__c; // Commented out this line as Japan doesn't have a state
            //cont.MailingState='NA';
            //cont.MailingCountry=partner.Country__c;//Changed due to validation Rule
            cont.MailingCountry=partner.Bill_To_Country__c;
            cont.Phone=partner.Phone__c;
            cont.Email=partner.Email__c;
            cont.Fax=partner.Fax__c;
            cont.MobilePhone=partner.Phone__c;
            //Start for Case# 00072314
            if(partner.Theater__c == 'Europe' && partner.Country__c == 'United Kingdom'){
                acct.CurrencyIsoCode ='GBP';
            }
            //End for Case# 00072314            
            //Start for Case#00077674
                        
            try{
                insert cont;
            }catch(DMLException ex){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
                return null;    
            }
            //End for Case#00077674
            partner.contact__c = cont.ID;
        }
            upsert partner;
            PageReference pageRef = new PageReference('/'+partner.ID);
            return pageRef ;
    }
    public PageReference cancel() {
            PageReference pageRef = new PageReference('/'+partnerId);
            return pageRef ;
     
    }
    
    
}