public class CaseOpportunity {

    public static void setCommercialProject(Map <Integer, Case> qualifyMap) {
        Set <String> opptyIdSet = new Set <String>();
        for (Case c : qualifyMap.values()) {
            if (c.Opportunity__c != null) {        
                opptyIdSet.add(c.Opportunity__c);
            } else {
                c.Commercial_Project_num__c = null; //clear. it is coming from opportunity.    
            }
        } 
        if (opptyIdSet.size() > 0) {
            List <Opportunity> opptyList = [SELECT Id, Commercial_Project_num__c 
                FROM Opportunity
                WHERE Id IN :opptyIdSet];        

            Map <String, Opportunity> opptyMap = new Map <String, Opportunity>();

            for (Opportunity oppty : opptyList) {
                opptyMap.put(oppty.Id, oppty);
            }

            for (Case c : qualifyMap.values()) {
                if (c.Opportunity__c != null) {        
                    if (opptyMap.containsKey(c.Opportunity__c)) {
                        c.Commercial_Project_num__c = opptyMap.get(c.Opportunity__c).Commercial_Project_num__c;
                    }
                }
            } 
        }
    }
    
}