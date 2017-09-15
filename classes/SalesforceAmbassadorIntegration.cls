global class SalesforceAmbassadorIntegration{
    
    //Update SSN based on the ContactID
    webservice static boolean updateSSN(Id ContactId,String SSN){
        //variables
        boolean ssnUpdated=false;
        List<Contact> conList= new List<Contact>([select SSN__c from Contact where Id=:ContactId]);
        
        //Logic
        if(!conList.isEmpty()){
            try{
                conList[0].SSN__c=SSN;
                update conList[0];
                ssnUpdated=true;
            }
            catch(Exception e){
                
            }
        }
        
        return ssnUpdated;
    }
    
    //Check if SSN exists for given ContactID
    webservice static boolean SSNExists(Id ContactId){
        //variables
        boolean hasSSN=false;
        List<Contact> conList= new List<Contact>([select SSN__c from Contact where Id=:ContactId]);
        
        //Logic
        if(!conList.isEmpty()){
            if(conList[0].SSN__c!=null && conList[0].SSN__c!='')
                hasSSN=true;
        }
        
        return hasSSN;
    }


}