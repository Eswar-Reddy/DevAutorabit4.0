/********************************************************************************************
Name   : OpportunityNewController 
Author : Hemant Paliwal
Date   : Aug 08, 2011
Related Case : 00073520

Usage  : Controller of VF page OpportunityNew that performs following actions depending on the user profile
        1. Restrict Users with profiles (Sales Analyst - UPP , Sales Management - UPP , Sales Person - UPP) to create new Opportunity 
        2. else Redirect other users to standard new page.
********************************************************************************************/

public class OpportunityNewController {
    
    public String newUrl {get; set;}//for Case# 00081247
     //R.Alega - 25.FEB.2016 - Case 00665939 - Remove restriction/Provided access for Sales Management profile to create new opportunity.
     Set<String> restricedProfileSet = new Set<String>{'Sales Analyst - UPP','Sales Management - UPP','Sales Person - UPP'};
    //Set<String> restricedProfileSet = new Set<String>{'Sales Analyst - UPP','Sales Management - UPP','Sales Person - UPP','Sales Management'};
   // private static Id commercialRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Commercial').getRecordTypeId();
   // private static Id residentialRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Home Owner').getRecordTypeId();
    private static Id commercialRecordTypeId ;
    private static Id residentialRecordTypeId ; 
     
    public String UserType{
        get{
        return UserInfo.getUserType();
        }
    }
     
     private void setRecordTypes() {
        
         List<RecordType> recordTypeList = [Select Id, Name  
                                        From RecordType  
                                        where Name IN ('Commercial','Home Owner') and sobjectType = 'Opportunity' ];
        
        for(RecordType recType : recordTypeList ) {
            if(recType.Name == 'Commercial') {  
                 commercialRecordTypeId=recType.Id;
            }else if(recType.Name == 'Home Owner') {
                 residentialRecordTypeId=recType.Id;
            }             
        }
        system.debug('**** commercialRecordTypeId ' +commercialRecordTypeId + 'residentialRecordTypeId ' + residentialRecordTypeId);
        
        /*Schema.DescribeSObjectResult d = Schema.SObjectType.Opportunity;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
            for(String name : rtMapByName2.keySet()) {
            system.debug(' name ' + name);
        }
        if(rtMapByName.containsKey('Commercial')) {
            Schema.RecordTypeInfo rtByName = rtMapByName.get('Commercial');
            commercialRecordTypeId = rtByName.getRecordTypeId();       
        }
        if(rtMapByName.containsKey('Home Owner')) {
            Schema.RecordTypeInfo rtByName = rtMapByName.get('Home Owner');
            residentialRecordTypeId = rtByName.getRecordTypeId();       
        }
    
        */
    }    
    public OpportunityNewController(ApexPages.StandardController controller) {
        newUrl = ApexPages.currentPage().getURL();//for Case# 00081247 
        setRecordTypes();
    }
    
    public PageReference redirect(){
        PageReference pg;
        Id recTypeId = ApexPages.currentPage().getParameters().get('RecordType');        
        User currentUser = [Select Id, Profile.Name from user where Id =: userInfo.getUserID()];
      
        
        if (restricedProfileSet.contains(currentUser.Profile.Name)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Users with profiles (Sales Analyst - UPP , Sales Management - UPP , Sales Person - UPP) are not allowed to create New Opportunity.'));
        }
        //Shree: 23-Apr-2013: LoanPath Project requirement
        //Shree: 01-July-2014: GPP Project, restrict AU Partner as well
        //Restrict opportunity creation from the portal for North America partners and AU partners. 
        //They can use the portal Account 360 page/interface to create the customer account/contact/opportunity 
        else if(currentUser.Profile.Name.toLowerCase().startsWith('partner') || currentUser.Profile.Name.toLowerCase().startsWith('au partner'))
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.Opportunity_On_Existing));
        }        
       
       //SHOW CUSTOM CREATE VFP PAGE ONLY IF THE USER IS A PARTNER USER AND IS EU. 
        else if('PowerPartner'.equals(UserType) && currentUser.profile.Name.contains('EU')) 
        {
            if(commercialRecordTypeId != null &&  commercialRecordTypeId == recTypeId)                    
                newUrl = newUrl.replace('/apex/OpportunityNew?','/apex/EditCommercialOpportunity?');
            else if(residentialRecordTypeId != null &&  residentialRecordTypeId == recTypeId) 
                newUrl = newUrl.replace('/apex/OpportunityNew?','/apex/EditResidentialOpportunity?');

            newUrl = newUrl.replace('sfdc.override','nooverride');
            newUrl = newUrl.replace('&save_new=1','');
            pg = new PageReference(newUrl);                   
        }        
        else {
            //Start for Case# 00081247          
            newUrl = newUrl.replace('/apex/OpportunityNew?','/006/e?');
            newUrl = newUrl.replace('sfdc.override','nooverride');
            newUrl = newUrl.replace('&save_new=1','');
            pg = new PageReference(newUrl);            
            //End for Case# 00081247 
         }     
         return pg;
    }//End Func redirect
  
       
}