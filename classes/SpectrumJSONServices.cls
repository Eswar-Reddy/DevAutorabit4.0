public with sharing class SpectrumJSONServices {
    
    
    //public Map<String,List<SpectrumSettings__c>> jsonObjectMap {get; private set;}
    //public Map<String,Set<String>> jsonInnerObjectMap {get; private set;}
    //public Map<String,SpectrumSettings__c> jsonFieldAPIMap {get;private set;}
    //public Map<String,Map<String,String>> sObjectFieldMap {get;private set;}
    //public List<SpectrumSettings__c> settings {get;private set;}
    //private Set<String> fieldAPINamesToCompare {get; set;}
    
    //public SpectrumJSONServices(){
    //    loadSettings();
    //}
    
    ////Pulls all Spectrum Settings and populates usable Map to hold data.
    //private void loadSettings(){
    //    sObjectFieldMap = new Map<String,Map<String,String>>();
    //    jsonObjectMap = new Map<String,List<SpectrumSettings__c>>();
    //    jsonInnerObjectMap = new Map<String,Set<String>>();
    //    jsonFieldAPIMap = new Map<String,SpectrumSettings__c>();
    //    //Instance method of List Custom Settings to get all in the list
    //    settings = SpectrumSettings__c.getAll().values();
    //    for(SpectrumSettings__c ss : settings){
    //        //INNER OBJECT MAP
    //        if(!jsonInnerObjectMap.containsKey(ss.Inner_Object_Of__c))
    //            jsonInnerObjectMap.put(ss.Inner_Object_Of__c,new Set<String>());
    //        jsonInnerObjectMap.get(ss.Inner_Object_Of__c).add(ss.JSON_Object__c);
            
    //        //JSON OBJECT MAP
    //        if(!jsonObjectMap.containsKey(ss.JSON_Object__c))
    //            jsonObjectMap.put(ss.JSON_Object__c,new List<SpectrumSettings__c>());
    //        jsonObjectMap.get(ss.JSON_Object__c).add(ss);
            
            
    //        //Check for key and create Map of Map
    //        if(!sObjectFieldMap.containsKey(ss.sObject_Name__c.toLowerCase()))
    //            sObjectFieldMap.put(ss.sObject_Name__c.toLowerCase(),new Map<String,String>());
            
    //        //Populates Map with JsonString and actual apiname. The Json String will make the json object "pretty"
    //        Map<String,String> jsonFieldMap = sObjectFieldMap.get(ss.sObject_Name__c.toLowerCase());
    //        if(ss.JSON_Name__c != null)
    //            jsonFieldMap.put(ss.JSON_Name__c,ss.Field_API_Name__c);
    //        else
    //            jsonFieldMap.put(ss.Field_API_Name__c,ss.Field_API_Name__c);
            
            
    //        jsonFieldAPIMap.put(ss.JSON_Name__c.toLowerCase(),ss);
    //        //Populate Settings for use in building JSON
            
    //    }
    //}
        
    //// Evaluate an opportunitiy against the Spectrum settings fields, and change the 
    //// SyncWithSpectrum status if needed
    //public Opportunity evaluateSpectrumChangedDataOpportunity(Opportunity newOpp, Opportunity oldOpp, Boolean oldPartnerWasSpectrum)
    //{
    //    system.debug('came to evaluateSpectrumChangedDataOpportunity');
    //    Opportunity result = newOpp;
        
    //    if(fieldAPINamesToCompare == null && sObjectFieldMap.containsKey('opportunity'))
    //    {
    //        List<String> sObjectAPINames = sObjectFieldMap.get('opportunity').values();
    //        fieldAPINamesToCompare = new Set<String>(sObjectAPINames);
    //    }
    //    system.debug('going to reassign clause');
    //    if((newOpp.Partner_Account_Id__c != oldOpp.Partner_Account_Id__c || newOpp.PartnerAccountId != oldOpp.PartnerAccountId) && oldPartnerWasSpectrum){
    //        result.SyncWithSpectrum__c = 'Reassign';
    //      //  newOpp.Lead_Qualification_Notes__c = null;
    //      //  newOpp.Solar_Advisor_Notes_For_EC__c = null;
            
    //        system.debug('made opportunity reassign');
    //        return result;
    //    }
        
    //    if(fieldAPINamesToCompare != null && newOpp.Partner_Account_Id__c != null && result.SyncWithSpectrum__c != 'New')
    //    {
    //        for(String fieldName : fieldAPINamesToCompare)
    //        {
    //            try
    //            {
    //                if(fieldName.contains('.'))
    //                {
    //                    String[] fieldSplit = fieldName.split('\\.', 2);
    //                    String parentObject = fieldSplit[0];
    //                    String parentObjectField = fieldSplit[1];
                        
    //                    if(result.getsObject(parentObject) != null)
    //                    {
    //                        if(result.getsObject(parentObject).get(parentObjectField) != 
    //                            oldOpp.getsObject(parentObject).get(parentObjectField))
    //                        {
    //                            result.SyncWithSpectrum__c = 'Update';
    //                            break;
    //                        }
    //                    }
    //                }
    //                else if(fieldName != 'SyncWithSpectrum__c' && result.get(fieldName) != oldOpp.get(fieldName))
    //                {
    //                    system.debug('fieldname is '+fieldName);
    //                    result.SyncWithSpectrum__c = 'Update';
    //                    break;
    //                }
    //            }
    //            catch(SObjectException error)
    //            {
    //                Diagnostics.exception(error);
    //            }
    //        }
    //    }
        
    //    return result;
    //}
    
    //// As above, for accounts
    //public Boolean evaluateSpectrumChangedDataAccount(Account newAccount, Account oldAccount)
    //{
    //    Boolean result = false;
        
    //    if(fieldAPINamesToCompare == null && sObjectFieldMap.containsKey('account'))
    //    {
    //        List<String> sObjectAPINames = sObjectFieldMap.get('account').values();
    //        fieldAPINamesToCompare = new Set<String>(sObjectAPINames);
    //    }
        
    //    Diagnostics.debug('fieldAPINamesToCompare: ' + fieldAPINamesToCompare);
        
    //    if(fieldAPINamesToCompare != null)
    //    {
    //        for(String fieldName : fieldAPINamesToCompare)
    //        {
    //            Diagnostics.debug('fieldName: ' + fieldName);
                
    //            try
    //            {
    //                if(newAccount.get(fieldName) != oldAccount.get(fieldName))
    //                {
    //                    result = true;
    //                    break;
    //                }
    //            }
    //            catch(SObjectException error)
    //            {
    //                Diagnostics.exception(error);
    //            }
    //        }
    //    }
        
    //    return result;
    //}
    
    //// As above, for contacts
    //public Boolean evaluateSpectrumChangedDataContact(Contact newContact, Contact oldContact)
    //{
    //    Boolean result = false;
        
    //    if(fieldAPINamesToCompare == null && sObjectFieldMap.containsKey('contact'))
    //    {
    //        List<String> sObjectAPINames = sObjectFieldMap.get('contact').values();
    //        fieldAPINamesToCompare = new Set<String>(sObjectAPINames);
    //    }
        
    //    Diagnostics.debug('fieldAPINamesToCompare: ' + fieldAPINamesToCompare);
        
    //    if(fieldAPINamesToCompare != null)
    //    {
    //        for(String fieldName : fieldAPINamesToCompare)
    //        {
    //            Diagnostics.debug('fieldName: ' + fieldName);
                
    //            try
    //            {
    //                if(newContact.get(fieldName) != oldContact.get(fieldName))
    //                {
    //                    result = true;
    //                    break;
    //                }
    //            }
    //            catch(SObjectException error)
    //            {
    //                Diagnostics.exception(error);
    //            }
    //        }
    //    }
        
    //    return result;
    //}

    //// this method is to check which accounts are spectrum partners based on the parameter
    //public static Set<Id> isSpectrumPartner(Set<Id> accountIds) {
    //    List<Account> accountList = [select id,isSpectrumPartner__c from Account where Id IN:accountIds];
    //    Set<Id> spectrumPartnerIds = new Set<Id>();
    //    for(Account acc : accountList){
    //      if(acc.isSpectrumPartner__c == true){
    //        spectrumPartnerIds.add(acc.Id);
    //      }
    //    }

    //    return spectrumPartnerIds;
    //}
}