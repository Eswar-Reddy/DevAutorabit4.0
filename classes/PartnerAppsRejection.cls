public class PartnerAppsRejection
{
    public Partner_Application__c PartApps{get;set;}         
    public String selectedTamplate{get;set;}     
    List<EmailTemplate> etemplate = new List<EmailTemplate>();   
          
    public PartnerAppsRejection(ApexPages.StandardController pa)
    {  
       String pAppID = ApexPages.currentPage().getParameters().get('ID');
       //Get PA
       PartApps = new Partner_Application__c();
       if(pAppID != null)
           PartApps= [select Id,Reason__c,Email__c,Details__c,Lead__r.Name,Lead__r.Email,Contact__c,Lead__c from Partner_Application__c where Id=:pAppID  limit 1];                  
    }
          
        
    public List<SelectOption> getTamplate() 
    {                
          List<Folder> fldName = new  List<Folder>();
          List<EmailTemplate> TemplateName= new List<EmailTemplate>();
         
          fldName = [Select id from Folder where name='Partner Application'];                
          TemplateName = [select Id,Name,folderId from EmailTemplate where folderId =:fldName[0].Id order by name];     
         
          List<SelectOption> options = new List<SelectOption>();  
          options.add(new SelectOption('--None--','--None--'));               
          for(EmailTemplate emp :TemplateName)
          {
              options.add(new SelectOption(emp.Id,emp.Name));
          }                
          return options;
    }

    public PageReference save()    
    {             
         partApps.Status__c ='Rejected';    
         update PartApps;   
         if(partApps.Lead__c!=null && selectedTamplate!='--None--' && partApps.Lead__r.Email !=null && partApps.Lead__r.Email !='')
         {
            Lead ld = new Lead(ID = partApps.Lead__c);
            ld .Status='Unqualified'; 
            update ld;
          
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();                                            
            List<Profile> prf = new  List<Profile>();
            prf = [select Id,Name from Profile];
             
           	if(prf[0].Name == 'SunPower Super User' || prf[0].Name == 'SunPower User' || prf[0].Name == 'SunPower Sales User'){
	            OrgWideEmailAddress owa = [select id, Address from OrgWideEmailAddress where Address =:'partners@sunpowercorp.com'];                        
	            mail.setOrgWideEmailAddressId(owa.Id);                                         
           	}
            mail.setTemplateId((ID)selectedTamplate);  
            mail.setTargetObjectId ((Id)partApps.Lead__c);             
            mail.setWhatId(partApps.Id);  
            mail.saveAsActivity = false;                                   
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });                    
          
       } 
       return null; 
    }           
}