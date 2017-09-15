public class StandardLineItemBeforeDeleteHandler extends TriggerHandlerBase {
	// -------- Constants --------

    // -------- Constructor --------
	public StandardLineItemBeforeDeleteHandler() {

	}

    // -------- Variables --------

    // -------- Properties --------

    // -------- Methods --------
    // Cast and determine qualified records
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap){
        Diagnostics.push('StandardLineItemBeforeDeleteHandler qualifyStartingRecords');

        List<StandardLineItem__c> oldRecords = (List<StandardLineItem__c>)oldList;

        for(StandardLineItem__c sli : oldRecords) {
        	// check to make sure user has rights to delete material lines to a residential project
        	if(String.isNotBlank(sli.Residential_Project__c) && !ResidentialProjectValidationUtility.canCreate(sli.Residential_Project__c, 'StandardLineItem__c')) sli.addError('You do not have rights to delete material lines to this project because you are not assigned to proper team member role.');
        }

        Diagnostics.pop();
    }

    public override void start() {

    	Diagnostics.push('StandardLineItemBeforeDeleteHandler start');

    	Diagnostics.pop();
    }

    public override void finish(Boolean fromStart) {
        Diagnostics.push('StandardLineItemBeforeDeleteHandler finish');

        if(fromStart) {

        }

        Diagnostics.pop();
    }
}