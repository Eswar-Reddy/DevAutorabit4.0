public class RMAMilestone {

    public static void setDate(Map <Integer, RMA_Milestone__c> qualifyMap) {
        for (RMA_Milestone__c milestone : qualifyMap.values()) {
            if (milestone.Status__c != null) {
                milestone.Date__c = system.today();
            } else {
                milestone.Date__c = null;
            }
        }
    }
    
    public static void createMilestones(Map <Integer, RMA__c> qualifyMap) {
        CustomSetting cs = getCustomSetting();
        Set <String> rmaIdSet = new Set <String>();    
        for (RMA__c rma : qualifyMap.values()) {
            if (rma.Id != null) {
                rmaIdSet.add(rma.Id);
            }
        }
        if (rmaIdSet.size() > 0) {
            List <RMA__c> rmaList = [SELECT Id, (SELECT Id, Name FROM RMA_Milestones__r) FROM RMA__c WHERE Id IN :rmaIdSet]; 
            List <RMA_Milestone__c> missingMilestoneList = new List <RMA_Milestone__c>();       
            for (RMA__c rma : rmaList) {
                Set <String> existingMilestones = new Set <String>();
                for (RMA_Milestone__c milestone : rma.RMA_Milestones__r) {
                    existingMilestones.add(milestone.Name.toLowerCase());
                }
                for (String milestone : cs.milestoneSet) {
                    if (existingMilestones.contains(milestone.toLowerCase()) == false) {
                        RMA_Milestone__c missingMilestone = new RMA_Milestone__c(Name = milestone, RMA__c = rma.Id);
                        missingMilestoneList.add(missingMilestone);
                    }
                }
            }  
            if (missingMilestoneList.size() > 0) {
                insert missingMilestoneList;
            }      
        }
    }
    
    private static CustomSetting getCustomSetting() {
        CustomSetting cs = new CustomSetting();
        
        for (RMA_Settings__c setting : RMA_Settings__c.getAll().values()) {
            if (setting.Value__c != null) {
                if (setting.Name.startsWithIgnoreCase('Milestone_')) {
                    cs.milestoneSet.add(setting.Value__c);
                }
            }
        }    
    
        return cs;
    }
    
    private class CustomSetting {
        Set <String> milestoneSet = new Set <String>();    
    }
    
}