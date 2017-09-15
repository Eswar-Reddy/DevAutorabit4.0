/*********************************************************************
    Name  : X1YSatisfactionSurveyResultManagement
    Date  : June 15,2011
    Related Case : 00066815  
    Description:This is a Class for managing the insert,update and delete events of object "1Y Satisfaction Survey Result".
*********************************************************************/

public class X1YSatisfactionSurveyResultManagement {
    
    public static void beforeX1YSatisfactionSurveyResultInsertUpdate(List<X1Y_Satisfaction_Survey_Result__c> listX1YSSRNew,Map<ID,X1Y_Satisfaction_Survey_Result__c> mapX1YSSROld){
        setX1YSSRFields(listX1YSSRNew,mapX1YSSROld);
    }
    
    // Set X1YSSR Fields 
    private static void setX1YSSRFields(List<X1Y_Satisfaction_Survey_Result__c> listX1YSSRNew,Map<ID,X1Y_Satisfaction_Survey_Result__c> mapX1YSSROld){
        
        // Creating Set of associated Opportunity Ids
        Set<Id> oppIdSet = new Set<Id>(); 
        for(X1Y_Satisfaction_Survey_Result__c X1YSSR : listX1YSSRNew){
            if(X1YSSR.Opportunity__c != null)
                oppIdSet.add(X1YSSR.Opportunity__c); 
        }
        // Creating Map for Opportunities
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([select id, RecordType.Name,Installation_Completed_Date__c,Installation_Date__c,Delivery_Date__c,Theater__c,PartnerAccountID from Opportunity where id in :oppIdSet]);
        
        for(X1Y_Satisfaction_Survey_Result__c X1YSSR : listX1YSSRNew){
            if(oppMap.get(X1YSSR.Opportunity__c) == null)
                continue;
            else{   
                // Setting the Survey Reference Date Field from Opportunity 
                if(oppMap.get(X1YSSR.Opportunity__c).RecordType.Name == 'Commercial' && oppMap.get(X1YSSR.Opportunity__c).Delivery_Date__c!=null){
                    X1YSSR.Survey_Reference_Date__c = oppMap.get(X1YSSR.Opportunity__c).Delivery_Date__c;
                }else if(oppMap.get(X1YSSR.Opportunity__c).RecordType.Name == 'Home Owner' && oppMap.get(X1YSSR.Opportunity__c).Installation_Completed_Date__c!=null){
                    X1YSSR.Survey_Reference_Date__c = oppMap.get(X1YSSR.Opportunity__c).Installation_Completed_Date__c;
                }
                
                // Setting the Partner Account Field from Opportunity
                // Done for Change order "EU Partner Opportunity Management" [replacing EU Partner Account with PartnerAccount]
                X1YSSR.Partner_Account__c = oppMap.get(X1YSSR.Opportunity__c).PartnerAccountId;
            }
        }
    }
}