public with sharing class WarrantyRegistration {
    
    PageReference newpg;
    public void attachPDF(Id warrantyId, String usrLang)
    //public void attachPDF(Id warrantyId)
    {
      if(usrLang == 'it')
      {
        newpg= Page.Generate_Warranty_Italian; 
        newpg.getParameters().put('Id',warrantyId); 
      }
      else if(usrLang == 'de')
      {
        newpg= Page.Generate_Warranty_German; 
        newpg.getParameters().put('Id',warrantyId);
      }
       else if(usrLang == 'fr_BE')
      {
        newpg= Page.Generate_Warranty_French_Belgium; 
        newpg.getParameters().put('Id',warrantyId);
      }
       else if(usrLang == 'fr')
      {
        newpg= Page.Generate_Warranty_French; 
        newpg.getParameters().put('Id',warrantyId);
      }
       else if(usrLang == 'es')
      {
        newpg= Page.Generate_Warranty_Spanish; 
        newpg.getParameters().put('Id',warrantyId);
      }
       else if(usrLang == 'nl_BE')
      {
        newpg= Page.Generate_Warranty_Dutch_Belgium; 
        newpg.getParameters().put('Id',warrantyId);
      }
      else
      {      
        newpg= Page.GenerateWarranty; 
        newpg.getParameters().put('Id',warrantyId);
      }
      
      
      //newpg.setRedirect(true);
      datetime c_date;
      Blob b;
      String strConvertedDateTim;
      if (!Test.isrunningtest()){
          b = newpg.getContent();
      }else{
          b = Blob.valueof('For_test'); //get content does not work for Test methods- Known issues
      }
       Warranty_Registration__c wr1=new Warranty_Registration__c();
     wr1=[SELECT Warranty_Number__c,CreatedDate,End_customer_s_name__c,Customer_SFDC_ID__c,Customer_SFDC_ID__r.name,
     Certificate_Status__c,Created_date__c,PDF_name__c FROM Warranty_Registration__c WHERE id =: warrantyId] ;
     
     
     
     if(wr1.Certificate_Status__c != 'Generated'){
         User u=new User();
         u=[SELECT LastName,LocaleSidKey,LanguageLocaleKey FROM User WHERE id =:UserInfo.getUserId()];
         string username = u.lastname;
      
          //c_date=wr1.CreatedDate;
          c_date=date.today();
      
          if(u.LocaleSidKey!='en_US')
              strConvertedDateTim = c_date.format('dd-MM-yyyy');
          else
              strConvertedDateTim = c_date.format('MM-dd-yyyy');
          
      
         Attachment attachmentPDF = new Attachment();
         attachmentPDF.parentId = warrantyId;
         attachmentPDF.Name = u.LocaleSidKey+'-'+strConvertedDateTim+'-'+wr1.Warranty_Number__c+'-'+wr1.Customer_SFDC_ID__r.name ;
         attachmentPDF.body = b;
         attachmentPDF.Description='Warranty Certificate';
         attachmentPDF.contentType= 'application/pdf';
        //  attachmentPDF.IsPrivate=false;
         insert attachmentPDF;
         attachmentPDF.body = blob.valueof('');
        
         wr1.Certificate_Status__c = 'Generated';   
         wr1.Created_date__c = date.today();  
         wr1.PDF_name__c =  attachmentPDF.Name;
     
         update wr1;
       }
    }
    
}