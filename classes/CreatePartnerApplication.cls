/****************************
//Created By- Kapil Goutam
//Created On- May 01 2009
//Last Modified on- May02 2009
//Last Modified By- Prakash G.
//Version - 1.0
//Description- Controller Class for CreatePartnerApplication 
*****************************/
public class CreatePartnerApplication {
     public String errorMessage {get;set;}
     public string leadId{get;set;}
     public string appType{get;set;}     
     public string language{get;set;}    
     
     public List<Lead> listLead{get;set;}
     public Partner_Application__c partnerApplication{get;set;}
     //Start 95084
     private Map<String, String> langCntry = new Map<String, String> {
         'France' => 'French', 
         'Germany' => 'German', 
         'Italy' => 'Italian', 
         'Japan' => 'Japanese',
         'Spain' => 'Spanish'
     };
     //End 95084
     //Start for case#00065563
     public static Map<String, Schema.RecordTypeInfo> nameToPartnerApplicationRecordTypeInfoMap;
     static {
        nameToPartnerApplicationRecordTypeInfoMap = Schema.SObjectType.Partner_Application__c.getRecordTypeInfosByName();
     }
     //End for case#00065563
     public CreatePartnerApplication() {
        
        listLead = new List<Lead>();
        
        if(ApexPages.CurrentPage().getParameters().get('LId') != null &&
            ApexPages.CurrentPage().getParameters().get('LId').length()>0 ) {
                        
           leadId = ApexPages.CurrentPage().getParameters().get('LId');
           
           listLead = [Select Company, City, Country, State,  WebSite, Email, Partner_Type__c,
             Phone, FirstName, LastName, Fax, MobilePhone ,NumberOfEmployees, OwnerId,
             PostalCode, Street, Theater__c from Lead where Id =:leadId limit 1];
                          
           if(listLead.Size()>0){
               partnerApplication = new Partner_Application__c();
               partnerApplication.Lead__c = leadId ; 
               partnerApplication.Company_Name__c = listLead.get(0).Company;
               partnerApplication.City__c = listLead.get(0).City;
               partnerApplication.Country__c = listLead.get(0).Country;
               //Start 95084
               if(listLead.get(0).Country != null && langCntry.containsKey(listLead.get(0).Country))
                    partnerApplication.Language__c = langCntry.get(listLead.get(0).Country);
               if(partnerApplication.Language__c == null)
                    partnerApplication.Language__c = 'English';
               //End 95084
               partnerApplication.State__c = listLead.get(0).State;
               partnerApplication.Zip__c = listLead.get(0).PostalCode;
               partnerApplication.Website__c = listLead.get(0).WebSite;
               partnerApplication.Email__c = listLead.get(0).Email;
               partnerApplication.Phone__c = listLead.get(0).Phone;
               partnerApplication.First_Name__c = listLead.get(0).FirstName;
               partnerApplication.Last_Name__c = listLead.get(0).LastName;
               partnerApplication.Fax__c = listLead.get(0).Fax;
               partnerApplication.Mobile__c = listLead.get(0).MobilePhone;
               partnerApplication.Employees__c = listLead.get(0).NumberOfEmployees; 
               partnerApplication.Address__c= listLead.get(0).Street;
               partnerApplication.Theater__c= listLead.get(0).Theater__c;
               //Start for case #00065563                              
               if(partnerApplication.Theater__c != null){
                    if(partnerApplication.Theater__c.contains('Central America and the Caribbean') 
                        || partnerApplication.Theater__c.contains('North America')){
                        if(listLead.get(0).Partner_Type__c!=null){
                            if(listLead.get(0).Partner_Type__c == 'Residential'){
                                partnerApplication.RecordTypeId = nameToPartnerApplicationRecordTypeInfoMap.get('NA Partner Application').getRecordTypeId();
                            }else if(listLead.get(0).Partner_Type__c == 'Commercial'){
                                partnerApplication.RecordTypeId = nameToPartnerApplicationRecordTypeInfoMap.get('NA Commercial Partner Application').getRecordTypeId();
                            }
                        }                           
                    }else if(partnerApplication.Theater__c.contains('Europe')){
                        partnerApplication.RecordTypeId = nameToPartnerApplicationRecordTypeInfoMap.get('EU Partner Application').getRecordTypeId();
                    }else if(partnerApplication.Theater__c.contains('Australia')){
                        partnerApplication.RecordTypeId = nameToPartnerApplicationRecordTypeInfoMap.get('AUS Partner Application').getRecordTypeId();
                    } else if(partnerApplication.Theater__c.contains('Asia Pacific')){
                        partnerApplication.RecordTypeId = nameToPartnerApplicationRecordTypeInfoMap.get('JP Partner Application').getRecordTypeId();
                    }
               }
               if(listLead.get(0).OwnerId!=null && !(String.valueOf(listLead.get(0).OwnerId).startsWith('00G'))){
                    partnerApplication.Lead_Owner__c= listLead.get(0).OwnerId;
                    partnerApplication.OwnerId = listLead.get(0).OwnerId;
               }
               //End for case#00065563
               
           }
        }//end-if

        appType = ApexPages.CurrentPage().getParameters().get('Type');

        if (appType!=null && appType.length()>0){
            partnerApplication.partner_application_type__c = appType;
        } else if (listLead.size() > 0) { // Else if button "Create Partner Application" is used
            List<RecordType> recordTypeList = [SELECT Id, Name FROM RecordType
                    WHERE SobjectType = 'Partner_Application__c'
                    AND Name IN ('NA Partner Application', 'NA Commercial Partner Application')];
            
            for (RecordType recordType : recordTypeList) {
                if ((listLead[0].Partner_Type__c == 'Residential'
                        && recordType.Name == 'NA Partner Application')
                        || (listLead[0].Partner_Type__c == 'Commercial'
                        && recordType.Name == 'NA Commercial Partner Application')) {
                    partnerApplication.RecordTypeId = recordType.Id;
                    break;
                }
            }
        }
        
        language = ApexPages.CurrentPage().getParameters().get('Lang');

        if (language!=null && language.length()>0){
            partnerApplication.language__c = language;
        }
        
     }
     
    public PageReference saveAndMove(){
        PageReference pr = null;
        try{
            insert partnerApplication;
            Lead leadObject = new Lead(Id=leadId);
            leadObject.Partner_Application__c = partnerApplication.Id;
            update leadObject; 
            pr = new PageReference('/'+partnerApplication.Id + '/e?retURL=%2F'+ partnerApplication.Id); 
            
        }
        catch(Exception ex){
            errorMessage = ex.getMessage();
        }
        return pr;  
    }
    

}