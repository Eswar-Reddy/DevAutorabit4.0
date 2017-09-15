/************************************************************
//Created By- Kapil Goutam
//Created On- May 01 2009
//Last Modified on- June 05 2009
//Last Modified By- Kapil Goutam
//Version - 1.0
//Description- Controller Class for CreatePartnerAccount

==============
CHANGE HISTORY
==============

version: KCM_09132016
author: Kane Chelster Macaspac
last modified date/time: 09-13-2016 03:45am MNL
description: 
1. deploying a fix for the partner application functionality where theaters other than NA are experiencing various issues due to 
   a bug in the code:
   a) There are certain fields like Country__c that are referenced in the code but are not queried and is throwing runtime errors
   b) The original implementation of the splitting of the address into Billing and Shipping addresses has negative impacts on other
      Theaters, mostly Europe
   c) ensured that the mapping of the shipping addresses are done for NA theater only.
2. use the version name above to search the document for changes specific to this version.
3. reference case number: 00786338      

************************************************************/

public class CreatePartnerAccount{
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
     
     public CreatePartnerAccount() {
        
        if(ApexPages.CurrentPage().getParameters().get('PId') != null) {
        
           partnerId= ApexPages.CurrentPage().getParameters().get('PId');
           partner =  new  Partner_Application__c();
           List<Partner_Application__c> listPartner = 
            [Select ID, Account__c,Contact__c, Website__c, Phone__c, Employees__c, 
                Company_Name__c,Title__c, Mobile__c, Last_Name__c, First_Name__c,Fax__c, Email__c,
                Partner_Type__c, Theater__c,//for Case# 00072314
                RSM__c,CRSM__c,Area_Sales_Manager__c,RSM__r.FirstName,RSM__r.LastName,CRSM__r.FirstName,CRSM__r.LastName,Area_Sales_Manager__r.FirstName,Area_Sales_Manager__r.LastName,   //Case#00215703
                /***
                KCM_09132016:
                    -removed the "Bill to" addresses from the query; replaced with the "original" address fields
                 
                Bill_To_Street__c, Bill_To_City__c, Bill_To_State__c, Bill_To_Country__c, Bill_To_Postal_Code__c,
                ***/ 
                Address__c, City__c, State__c, Country__c, ZIP__c, //KCM_09132016: the "original" address fields
                Ship_To_Street__c, Ship_To_City__c, Ship_To_State__c, Ship_To_Country__c, Ship_To_Postal_Code__c
                From Partner_Application__c 
                where Id = :partnerId limit 1];
                
           if(listPartner.Size()>0){
             partner = listPartner.get(0);
           }                                                             
        }
                
       
        for (RecordType partnerAccountRecordType:
            [Select r.Id 
                From RecordType r 
                where Name = 'Partner' and sobjectType = 'Account' limit 1]){
                    
            partnerRecordType=partnerAccountRecordType;             
        }
        
        /* Added for Sunpower Case # 00030862 */
        for (RecordType partnerContactRecordType : [SELECT Id FROM RecordType
                WHERE Name = 'Partner' AND SObjectType = 'Contact' LIMIT 1]) {
            partnerContactRecordTypeId = partnerContactRecordType.Id;
        }
        /**************************************/
     }        
    
    public PageReference confirm() {
        Account acct = new Account();
        if( partner.Account__c == null && isCreateAccount){
            acct.Name = partner.Company_Name__c;
            /** [START] Case 00618830 - Additional Bill To and Shipt To Address Details **/
            
            //KCM_09132016: mapped the account billing address back to the "original" PA address fields.
            acct.BillingStreet = partner.Address__c; 
            acct.BillingCity = partner.City__c;
            acct.BillingPostalCode = partner.ZIP__c;
            acct.BillingState = partner.State__c;
            acct.BillingCountry = partner.Country__c;
            
            //KCM_09132016: shipping address fields to be mapped to accounts, 
            //              specific to NA or Central America and the Caribbean theaters only
            if (acct.Theater__c == 'North America' || acct.Theater__c == 'Central America and the Caribbean') {
                acct.ShippingStreet = partner.Ship_To_Street__c;
                acct.ShippingCity = partner.Ship_To_City__c;
                acct.ShippingPostalCode = partner.Ship_To_Postal_Code__c;
                acct.ShippingState = partner.Ship_To_State__c;
                acct.ShippingCountry = partner.Ship_To_Country__c;
            }
            /** [END] Case 00618830 **/
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
        
        if(partner.Contact__c == null && isCreateContact){
            
            Contact cont = new Contact();
            
            if(acct.ID == null)
                cont.AccountID= partner.Account__c;
            else
                cont.AccountID= acct.ID;
            
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
            cont.MailingPostalCode=partner.ZIP__c;
            cont.MailingState=partner.State__c;
            cont.MailingCountry=partner.Country__c;
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