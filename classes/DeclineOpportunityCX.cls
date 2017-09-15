/*
* @auther : Cloud Sherpas Inc.
* @date : 03/13/2014
* @description : Apex class for Decline Opportunity VF Page
*/
public class DeclineOpportunityCX {
    
    public Opportunity opp {get; set;}
    public String selectedDeclineReason {get; set;}
    public Boolean error {get; set;}
    public Boolean isDeclineReasonNull {get;set;}
    public Boolean isEligible {get; set;}
    
    //Constructor
    public DeclineOpportunityCX(ApexPages.StandardController controller) {
        selectedDeclineReason = '';
        error = false;
        isDeclineReasonNull = true;
        isEligible = true;
        opp = (Opportunity) controller.getRecord();
        System.debug(LoggingLevel.INFO, '== in DeclineOpportunityCX original opp ==' + opp);
        opp = [SELECT Id, Name, StageName, Decline_Reason__c, OwnerId, Owner.Name, PartnerAccountId FROM Opportunity WHERE Id =: opp.Id LIMIT 1 FOR UPDATE];
                
        if((opp.StageName != 'New Opportunity') && (opp.StageName != 'Contacted')) {
            isEligible = false;
        }
    }
    
    //Select Option list for choices
    public List<SelectOption> getDeclineReasons() {
        List<SelectOption> options = new List<SelectOption>();            
        Schema.DescribeFieldResult fieldResult = Opportunity.Decline_Reason__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();            
        options.add(new SelectOption('', '--Select--'));
        for( Schema.PicklistEntry f : ple) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }
    
    /*
    * @auther : Cloud Sherpas Inc. - Sumit Shingavi
    * @date : 03/13/2014
    * @description : Apex method for calling Assign Dealer Service
    * @parameters : Nothing
    * @returns : Nothing
    */
    public void declineOpportunity() {
        
        System.debug('==entering declineOpportunity selectedDeclineReason=='+selectedDeclineReason);
        
        if(!String.isBlank(selectedDeclineReason)) {
            error = false;            
            isDeclineReasonNull = false;
            opp.Decline_Reason__c = selectedDeclineReason;
            
            String username = 'Dia Katrina Deuda-Dondoy';
            System.debug('==selectedDeclineReason=='+selectedDeclineReason);
            if(selectedDeclineReason == 'Not qualified - Renter') {
                User usr = [SELECT Id, Name FROM User WHERE Name =: username LIMIT 1];
                opp.ownerId = usr.Id;
            }
            update opp;
            
            if(selectedDeclineReason != 'Not qualified - Renter') {
                System.debug('==executing DealerLocatorService.AssignDealer==');
                if(!Test.isRunningTest()) DealerLocatorService.AssignDealer(opp.Id);
                String strActivity = 'DeclineOpportunity';
                if(!Test.isRunningTest()) ChatterNotificationUtility.createOppAssignmentPost(opp, strActivity, null);
            }
            System.debug(LoggingLevel.INFO, '== in DeclineOpportunityCX updated opp ==' + opp);
                        
        } else {
            isDeclineReasonNull = true;
            error = true;
        }
    }
}