/**
 *@name - OpportunityCallActionCC
 *@description - Controller Class for OpportunityCallAction Page
 *@author - Michael Adrian Reyes
 *@date - February 26, 2014
**/

public class OpportunityCallActionCC {
    public Opportunity o {get; set;}
    public boolean isCallOutcomeNull {get;set;}
    //public String callOutcome {get; set;}
    //public List<SelectOption> soList {get; set;}
    public String phone {get; set;}
    public String callNotes {get;set;}
    public boolean error {get;set;}
  
    
    public OpportunityCallActionCC(ApexPages.StandardController controller) {
    
        error = false;
        isCallOutcomeNull = true;
        o = [SELECT Id,Primary_Contact__r.Phone,StageName, 
            Reason_Won_Lost__c,Description,Call_Outcome__c FROM Opportunity WHERE 
            Id=: controller.getId() LIMIT 1];
            
        phone = o.Primary_Contact__r.Phone;
    }
    
    public PageReference submit(){
    
        if (o.Call_Outcome__c!=null){
            if (o.Description==null){
                o.Description = '';
            }else{
                o.Description = o.Description + '\n';
            }
            Date dt = Date.Today();
            //o.Description = o.Description + ' ' + dt.month()+'/'+dt.day
            o.Description = o.Description + dt.month()+'/'+dt.day()+'/'+dt.year() + ' Call logged by ' + UserInfo.getName() + ': ' + o.Call_Outcome__c + '. ' + callNotes;
            isCallOutcomeNull = false;
            o.Call_Outcome__c = null;
            update o;
            //return new pageReference('/'+o.id);
            return null;
        }else{
            isCallOutcomeNull = true;
            error = true;
            return null;
        }   
        return null;
        
    }
    
    public PageReference cancel(){
        
        //return new pageReference('/'+o.id);
        return null;    
    }
    
    public void updateOpp(){
        if (o.StageName.equalsIgnoreCase('New Opportunity')){
            System.debug

('=====================StageName==================' + o.StageName);
            o.StageName = 'Contacted';
            update o;
        }
    }
}