@isTest(SeeAllData=true)
public class TestLeadConversion 
{
 //madhuri
 
  @isTest
  public static void checkInsertUpdateLead()
  {    
      //Check for Account Insert
       Account accountObj = createAccount();
            
      //Check for Lead insert
        Lead lead1 = new Lead();
        lead1.FirstName = 'Test';
        lead1.LastName = 'Commercial';
        lead1.Lead_Type__c='Commercial';
        lead1.Company = 'TEST Company A';
        lead1.Country = 'North America';
        lead1.Email = 'testEmail@test123.com';
        lead1.Phone = '09829098290';
        lead1.LeadSource = 'Web';
        lead1.Affiliate_Account__c =accountObj.id;
        insert lead1;
        /*
        lead1.Competitor_Account__c=accountObj.id;
        update lead1;
     	*/
        List<Lead> lstLead = new List<Lead>();
        lstLead.add(lead1);
       
      
      test.startTest();
      //Convert Lead
      convertLead(lstLead);  
      test.stopTest(); 
      LeadConversion.after_Lead_Update(lstLead);

      
 
   }
   
  @isTest
  public static void checkInsertUpdateLead1(){
  
  
      //Check for Account Insert
      Account accountObj = createAccount();
      
      //Check for Lead insert
        Lead lead1 = new Lead();
        //lead1.Account__c=accountObj.id;
        lead1.FirstName = 'Test';
        lead1.LastName = 'Commercial';
        lead1.Lead_Type__c='Commercial';
        lead1.Company = 'TEST Company A';
        lead1.Country = 'North America';
        lead1.Email = 'testEmail@test123.com';
        lead1.Phone = '09829098290';
        lead1.LeadSource = 'Web';
        lead1.Affiliate_Account__c=accountObj.id;
      
        insert lead1;
        
     
        List<Lead> lstLead = new List<Lead>();
        lstLead.add(lead1);
        
      test.startTest();
      //Convert Lead       
      convertLead(lstLead); 
      test.stopTest(); 
      LeadConversion.after_Lead_Update(lstLead);

      
 
   }
    @isTest(SeeAllData=true)
    public static void checkInsertUpdateLead2(){
  	  //Check for Account Insert
      Account accountObj = createAccount();
      
        System.debug('--------------checkInsertUpdateLead2='); 
        for(Trigger_By_Pass__c custSettingTriggerByPass  : Trigger_By_Pass__c.getAll().values()){
            System.debug('--------------custSettingTriggerByPass1='+custSettingTriggerByPass); 
            if(custSettingTriggerByPass.name == 'UpdateScore'){
               System.debug('--------------1'); 
                System.debug('--------------custSettingTriggerByPass='+custSettingTriggerByPass); 
               custSettingTriggerByPass.Is_Active__c = true;
                update custSettingTriggerByPass;
                System.debug('--------------custSettingTriggerByPass='+custSettingTriggerByPass); 
            }
        }
        
      
      //Check for Lead insert
        Lead lead1 = new Lead();
        //lead1.Account__c=accountObj.id;
        lead1.FirstName = 'Test';
        lead1.LastName = 'Commercial';
        lead1.Lead_Type__c='Commercial';
        lead1.Company = 'TEST Company A';
        lead1.Country = 'North America';
        lead1.Email = 'testEmail@test123.com';
        lead1.Phone = '09829098290';
        lead1.LeadSource = 'Web';
        lead1.Affiliate_Account__c=accountObj.id;
      
        insert lead1;
        
     
        List<Lead> lstLead = new List<Lead>();
        lstLead.add(lead1);
        
      test.startTest();
      //Convert Lead       
      convertLead(lstLead); 
      test.stopTest(); 
      LeadConversion.after_Lead_Update(lstLead);

      
 
   }
   
   public static Account createAccount(){
       Account accountObj = new Account();
       accountObj.Name = 'Testing Account' +String.valueOf(DateTime.Now());
       accountObj.Type ='Commercial';
       
       accountObj.BillingCity = 'chicago';
       accountObj.BillingCountry = 'Spain';
       accountObj.BillingStreet = 'btm';
       accountObj.BillingPostalCode = '12311';
       
       accountObj.ShippingCity = 'chicago';
       accountObj.ShippingCountry = 'Spain';
       accountObj.ShippingStreet = 'btm';
       accountObj.ShippingPostalCode = '12311';
       
       accountObj.Oracle_County__c = 'Spain';
              
       accountObj.Theater__c = 'Europe';
       accountObj.Territory__c = 'Spain';

       insert accountObj; 
       return accountObj;
   }
   
   public static void convertLead(List<Lead> lstLead)
   {
        Database.LeadConvert[] leadsToConvert = new Database.LeadConvert[0];
        Database.LeadConvert converter = new Database.LeadConvert();
        for (lead l : lstLead)
        {
            converter.setLeadId(l.id);
             account account = new account();
                account.name='test12345';
                account.BillingCity = 'chicago';
                account.BillingCountry = 'Spain';
                account.BillingStreet = 'btm';
                account.BillingPostalCode = '12311';
                
                account.ShippingCity = 'chicago';
                account.ShippingCountry = 'Spain';
                account.ShippingStreet = 'btm';
                account.ShippingPostalCode = '12311';
                
                account.Oracle_County__c = 'Spain';
            insert account;
            converter.setAccountId(account.id);
            contact contact = new contact(firstname='test', lastname='test',accountid=account.id);
            insert contact;
            converter.setContactId(contact.id);
            //converter.setOwnerId('00570000000oflK');
            converter.setConvertedStatus('Qualified');
            converter.setDoNotCreateOpportunity(false);
            
            leadsToConvert.add(converter);
        }
        util.setInContextOfLeadConversion();
        //Database.ConvertLead( leadsToConvert, true );
   }//End TM 
}//End Class TestLeadConversion
 
 
  /*@isTest
  public static void checkInsertUpdateLead(){
  
  List<Lead> allCasesLeads = new List<Lead>();


  List<Lead> leadList1 = new List<Lead>();
     
       leadList1 = [select id ,Affiliate_Account__c,
                    Competitor_Account__c,
                    ConvertedOpportunityId,
                    Affiliate_Lead_Registered_Date__c,
                    Affiliate_Lead_Expired_Date__c,
                    Affiliate_Account_Manager__c,
                    Affiliate_Agreement_Status__c,
                    ConvertedAccountId,isconverted from Lead
                    where isconverted=true and Affiliate_Account__c !=null
                     and  Country !=null and Email != null and Phone != null  and LeadSource != null  and
                     City  != null  and Country != null  and Street != null  and PostalCode != null  
                    and Competitor_Account__c !=null and isdeleted = false and isDeleted = false
                    limit 1];

        
        if(leadList1.size() >0){
                  allCasesLeads.add(leadList1[0]);
         }
         
     List<Lead> leadList2 = new List<Lead>();
     
       leadList2 = [select id ,Affiliate_Account__c,
                    Competitor_Account__c,
                    ConvertedOpportunityId,
                    Affiliate_Lead_Registered_Date__c,
                    Affiliate_Lead_Expired_Date__c,
                    Affiliate_Account_Manager__c,
                    Affiliate_Agreement_Status__c,
                    ConvertedAccountId,isconverted from Lead
                    where isconverted=true and Affiliate_Account__c !=null
                    and Competitor_Account__c =null
                     and  Country !=null and Email != null and Phone != null  and LeadSource != null  and
                     City  != null  and Country != null  and Street != null  and PostalCode != null and isdeleted = false and isDeleted =false 
                    limit 1];

        
        if(leadList2.size() >0){
                  allCasesLeads.add(leadList2[0]);
         }
         
       List<Lead> leadList3 = new List<Lead>();
     
       leadList3 = [select id ,Affiliate_Account__c,
                    Competitor_Account__c,
                    ConvertedOpportunityId,
                    Affiliate_Lead_Registered_Date__c,
                    Affiliate_Lead_Expired_Date__c,
                    Affiliate_Account_Manager__c,
                    Affiliate_Agreement_Status__c,
                    ConvertedAccountId,isconverted from Lead
                    where isconverted=true and Affiliate_Account__c =null
                    and Competitor_Account__c !=null
                     and  Country !=null and Email != null and Phone != null  and LeadSource != null  and
                    City  != null  and Country != null  and Street != null  and PostalCode != null and isdeleted = false  and isDeleted =false
                    limit 1];

        
        if(leadList3.size() >0){
                  allCasesLeads.add(leadList3[0]);
         }
                  
         
          List<Lead> leadList4 = new List<Lead>();


     /*   if(allCasesLeads.size()==0){
        
           leadList4 = [select id ,Affiliate_Account__c,
                    Competitor_Account__c,
                    ConvertedOpportunityId,
                    Affiliate_Lead_Registered_Date__c,
                    Affiliate_Lead_Expired_Date__c,
                    Affiliate_Account_Manager__c,
                    Affiliate_Agreement_Status__c,
                    ConvertedAccountId,isconverted from Lead
                    where isconverted=true 
                    and  Country !=null and Email != null and Phone != null  and LeadSource != null  and
                    City  != null  and Country != null  and Street != null  and PostalCode != null  
                    limit 1];
                    
             if(leadList4.size()==0){
                 leadList4 = [select id ,Affiliate_Account__c,
                    Competitor_Account__c,
                    ConvertedOpportunityId,
                    Affiliate_Lead_Registered_Date__c,
                    Affiliate_Lead_Expired_Date__c,
                    Affiliate_Account_Manager__c,
                    Affiliate_Agreement_Status__c,
                    ConvertedAccountId,isconverted from Lead
                    where Country !=null and Email != null and Phone != null  and LeadSource != null  and
                    City  != null  and Country != null  and Street != null  and PostalCode != null  
                    limit 1];
                    
                    if(leadList4 .size()>0)
                       allCasesLeads.add(leadList4[0]);
                    
             }else{
                allCasesLeads.add(leadList4[0]);
             }

        } 
         

      
    

      test.startTest();
  
      LeadConversion.after_Lead_Update(allCasesLeads);

      test.stopTest();



  }
*/