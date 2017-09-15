public class F9ApptReminderOutbound {
    
    private static Five9WebserviceCalloutSettings__c FIVE9WEBSERVICE = Five9WebserviceCalloutSettings__c.getInstance('Five9');
    Map<Id, SpectrumDebugUtility.debugLog> spExlogs = new Map<Id, SpectrumDebugUtility.debugLog>();
    
    /*@InvocableMethod
    public static void sendFive9ApptReminder(List<Id> oppIds) {
        if(oppIds == null || oppIds.isEmpty()) return;
        
        
        callfive9ApptReminder(oppIds);
    }  */
    
    @InvocableMethod
    public static void sendFive9ApptReminder(List<string> oppIds) {
        if(oppIds == null || oppIds.isEmpty()) return;
        string five9list;
        List<Id> OptyIds = new List<Id>(); 
        for( string s : oppIds){
            system.debug('********substringbefore*******'+s.substringbefore(','));
            system.debug('********after*******'+s.substringAfter(','));
            OptyIds.add(s.substringbefore(','));
            five9list=s.substringAfter(',');
            
        }
         system.debug('********OptyIds*******'+OptyIds);
         system.debug('********five9list*******'+five9list);
        
        callfive9ApptReminder(OptyIds , five9list);
    }
    
    
    @future(Callout = true)
    public static void callfive9ApptReminder(List<Id> oppIDs ,string five9list)
    {   
        ReferralManagementCallout.inBatchContext = true;
        Map<Id, Opportunity> opps = new Map<Id, Opportunity>([SELECT Id, Primary_Contact__r.Phone, Primary_Contact__r.MobilePhone, Partner_Account_Id__c,
                                                                    Primary_Contact__r.FirstName, Primary_Contact__r.LastName
                                                              FROM Opportunity
                                                              WHERE Id IN: oppIds]);
                                                              
        if(opps.isEmpty()) return;
        
        Map<Id, SpectrumDebugUtility.debugLog> spectrumLogs = new Map<Id, SpectrumDebugUtility.debugLog>();
        List<Exception_Log__c> exceptionLogs = new List<Exception_Log__c>();
        Map<Id, Opportunity> oppUpdates = new Map<Id, Opportunity>();
        
        try
        {
            for(Id oppId : opps.keySet()) {
                
                Map<String, String> f9Opp = new Map<String, String>();
                f9Opp.put('F9domain', FIVE9WEBSERVICE.Domain_Name__c);      //required
               // f9Opp.put('F9list', FIVE9WEBSERVICE.Reminder_List__c);        //required
               f9Opp.put('F9list', five9list);
               
                f9Opp.put('F9key', FIVE9WEBSERVICE.F9key__c);          //typical use case 
                f9Opp.put('F9CallASAP', 'true');
                f9Opp.put('salesforce_id', oppId); 
                f9Opp.put('first_name', opps.get(oppId).Primary_Contact__r.FirstName);
                f9Opp.put('last_name', opps.get(oppId).Primary_Contact__r.LastName);
                if(opps.get(oppId).Primary_Contact__r.MobilePhone != null) 
                    f9Opp.put('number1', opps.get(oppId).Primary_Contact__r.MobilePhone);
                else 
                    f9Opp.put('number1', opps.get(oppId).Primary_Contact__r.Phone);  
                
                //Instantiate a new F9Web2Campaign object
                F9Web2Campaign f9 = new F9Web2Campaign();             
                
                //Call the doPost method with the lead
                F9Web2CampaignResult res = f9.doPost(f9Opp);
                
                System.debug('RESULT: ' + res);
                if(res.ErrCode == 200) {
                    opps.get(oppId).Five9_Reminder_Call_Sent__c = true;
                    opps.get(oppId).Reminder_Sent_to_Five9__c = System.now();
                    oppUpdates.put(oppId, opps.get(oppId));
                }
                //build log of ob msg and response
                SpectrumDebugUtility.debugLog spExLog = new SpectrumDebugUtility.debugLog();
                spExlog.OpportunityId = oppId;
                spExLog.Service = 'SPD/F9 Appointment Reminder';
                spExLog.Response = F9Web2Campaign.resBody; 
                spExLog.responseCode = F9Web2Campaign.stCode;
                spExLog.JSONPayload = F9Web2Campaign.obmsg;
                
                spectrumLogs.put(oppId, spExLog);                
            }
        } catch(Exception ex) {
            Exception_Log__c log = new Exception_Log__c();
            log.Error_Message__c = ex.getMessage();
            log.Stack_Trace__c = ex.getStackTraceString();
            log.Opportunity_Id__c = opps.values()[0].Id;
            exceptionLogs.add(log);
        }
        
        try {
            if(spectrumLogs != null && !spectrumLogs.isEmpty()) 
                SpectrumDebugUtility.generateDebugLog(spectrumLogs.values());
            
            if(exceptionLogs != null && !exceptionLogs.isEmpty())
                insert exceptionLogs;
            if(oppUpdates != null && !oppUpdates.isEmpty())
                update oppUpdates.values();
            
        } catch(Exception e) {} 
    }
}