public class StandardLineItemBeforeUpdateHandler extends TriggerHandlerBase {
	// -------- Constants --------

    // -------- Constructor --------
	public StandardLineItemBeforeUpdateHandler() {

	}

    // -------- Variables --------

    // -------- Properties --------

    // -------- Methods --------
    // Cast and determine qualified records
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap){
        Diagnostics.push('StandardLineItemBeforeUpdateHandler qualifyStartingRecords');

        List<StandardLineItem__c> newRecords = (List<StandardLineItem__c>)newList;

        for(StandardLineItem__c sli : newRecords) {
        	// check to make sure user has rights to add material lines to a residential project
        	if(String.isNotBlank(sli.Residential_Project__c) && !ResidentialProjectValidationUtility.canCreate(sli.Residential_Project__c, 'StandardLineItem__c')) sli.addError('You do not have rights to add material lines to this project because you are not assigned to proper team member role.');
        }

        Diagnostics.pop();
    }

    public override void start() {

    	Diagnostics.push('StandardLineItemBeforeUpdateHandler start');

    	Diagnostics.pop();
    }

    public override void finish(Boolean fromStart) {
        Diagnostics.push('StandardLineItemBeforeUpdateHandler finish');

        if(fromStart) {

        }

        Diagnostics.pop();
    }
}