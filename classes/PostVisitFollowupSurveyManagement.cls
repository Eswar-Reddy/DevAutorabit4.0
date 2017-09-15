Public class PostVisitFollowupSurveyManagement{
public static String EUUSER = 'Sylwia Buczynska';
public static String NAUSER = 'Maria Luisa Cuenca-Abril';

public static void afterUpdatePostVisitFollowupSurvey(Map<ID, Post_Visit_Follow_Up_Survey__c> newSurvey, Map<ID, Post_Visit_Follow_Up_Survey__c> oldSurvey){
    //Start 83101 
    createCallTask(newSurvey, oldSurvey);
    //End 83101    
}

//Start 83101
public static void createCallTask(Map<ID, Post_Visit_Follow_Up_Survey__c> newSurvey, Map<ID, Post_Visit_Follow_Up_Survey__c> oldSurvey){
    //Regex for valid phone number
    String regexPhone1 = '^(\\+[0-9]{2}|^\\+[0-9]{2}\\(0\\)|^\\(\\+[0-9]{2}\\)\\(0\\)|^00[0-9]{2}|^0)([0-9]{9}$|[0-9\\-\\s]{10})$';
    String regexPhone2 = '[^a-zA-Z]+';
    
    Set<Id> idsForQuery = new Set<Id>();
    for(Post_Visit_Follow_Up_Survey__c p : newSurvey.values()) {
        if(p.Status_Survey__c == 'No Response Received' && p.Status_Survey__c != oldSurvey.get(p.ID).Status_Survey__c) {
            idsForQuery.add(p.Id);
        }
    }
    
    if(idsForQuery == null || idsForQuery.isEmpty()) return;
    
    //Get referenced field information of survey
    Map<ID, Post_Visit_Follow_Up_Survey__c> mapSurveyDetail = new Map<ID, Post_Visit_Follow_Up_Survey__c>([Select id, Customer_Contact__r.phone,Opportunity_id__r.PartnerAccount.BillingCountry,
                                                              Opportunity_id__r.Alliance_Program_Lead__c,Opportunity_id__r.Campaign.name from Post_Visit_Follow_Up_Survey__c where id in :newSurvey.keySet()]);
    
    
    //Get Task recordtypeID
    Schema.DescribeSObjectResult drt = Schema.SObjectType.Task;
    Map<String,Schema.RecordTypeInfo> rtMapByName = drt.getRecordTypeInfosByName();
    Schema.RecordTypeInfo rtByName =  rtMapByName.get('Call Task');
    
    //Get Users
    Map<String,ID> mapAssignee = new Map<String,ID>();
    for(User usr : [select Id,Name from User where (Name = :EUUSER OR Name = :NAUSER) AND isActive = true]){
       mapAssignee.put(usr.name,usr.ID);
    }
    
    //Create task if no response received for survey      
    List<Post_Visit_Follow_Up_Survey__c>   lstToUpdateSurvey = new List<Post_Visit_Follow_Up_Survey__c>();
    List<Task> callTaskToInsert = new List<Task>();
    String ivString = '' ;
    for(Post_Visit_Follow_Up_Survey__c newS : newSurvey.values()){
        Post_Visit_Follow_Up_Survey__c surveyDetail = mapSurveyDetail.get(newS.ID);
        String phone = surveyDetail.Customer_Contact__r.phone;
        String billingCountry = surveyDetail.Opportunity_id__r.PartnerAccount.BillingCountry==null? '' : surveyDetail.Opportunity_id__r.PartnerAccount.BillingCountry;
        
        if(newS.Status_Survey__c == 'No Response Received' && newS.Status_Survey__c != oldSurvey.get(newS.ID).Status_Survey__c && phone != null && phone != ''
           && (Pattern.matches(regexPhone1 ,phone) || Pattern.matches(regexPhone2 ,phone)) )
        {
            Task surveytask = new Task(recordTypeId = rtByName.getRecordTypeId(),
                                      Status = 'Not Started',
                                      whatID =  newS.Opportunity_id__c,
                                      whoID = newS.Customer_Contact__c,
                                      ActivityDate = system.today()+7);   
                                               
            surveytask.subject = 'Opportunity Follow-up Survey ' + billingCountry;
            if(newS.Opportunity_Alliance_Program_Lead__c && surveyDetail.Opportunity_id__r.Campaign.name!=null){
                surveytask.subject += ' Alliance '+ surveyDetail.Opportunity_id__r.Campaign.name;                
            }     
            
            if((billingCountry == 'Germany' || billingCountry == 'Italy' || billingCountry == 'France') && mapAssignee.get(EUUSER)!=null){
                surveytask.ownerID = mapAssignee.get(EUUSER);
            }  
            else if((billingCountry == 'United States' || billingCountry == 'United States of America') && mapAssignee.get(NAUSER)!=null){
                 surveytask.ownerID = mapAssignee.get(NAUSER);
            }   
            if(billingCountry == 'Germany'){
               ivString='q38kvgv144lwy';
           	} else if(billingCountry == 'France') {
               ivString='b8x151kjqfuyg';
           	} else if(billingCountry == 'Italy') {
               ivString='3912c1793252c3e';
           	}else if(billingCountry == 'United States' || billingCountry == 'United States of America') {
               ivString='1pm3rdwpde2epa';
            }
            surveytask.Description = 'http://survey.sunpowercorp.com/go?iv='+ivString+'&q1='+newS.Id;
            callTaskToInsert.add(surveytask);    
            lstToUpdateSurvey.add(new Post_Visit_Follow_Up_Survey__c(id=newS.ID,Survey_Channel__c = 'Phone'));  
        }
    }//End for loop
    
    //Insert task (update survey only if task is created, so done on after trigger)
    if(callTaskToInsert.size() > 0){
        insert callTaskToInsert;
        update lstToUpdateSurvey;
    }
}
//End 83101
}