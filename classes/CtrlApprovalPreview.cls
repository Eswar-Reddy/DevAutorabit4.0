public without sharing class CtrlApprovalPreview {

	public Id objId;
	Map<Integer, List<User>> mapSteps;

    public CtrlApprovalPreview(ApexPages.StandardController controller) {
        this.objId = controller.getId();
    }

    public void init(){
    	loadApprovalMap();
    }

	public Map<Integer, List<User>> getApprovalMap(){
		return mapSteps;
	}
	public Map<Integer, List<User>> loadApprovalMap(){

		mapSteps = new Map<Integer, List<User>>();
		// creating a save point to mock the steps of the approval
	    Savepoint sp = Database.setSavepoint();

	    try{
		    List<ProcessInstance> lsPI = [SELECT Id, ProcessDefinitionId from ProcessInstance where TargetObjectId= :objId and Status = 'Pending']; 
		    // no pending process, there should be only 1 pending
		    if (lsPI.size() != 1){
		    	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'No Pending step for approval'));
		    	return mapSteps;
		    }
		    ProcessInstance proInst = lsPI.get(0);
		    // filter active and standard
		    Map<Id, User> mapUser = new Map<Id, User>([SELECT name, LastName, FirstName, Email from User Where UserType = 'Standard']);


			// Approve the submitted request
	        // First, get the ID of the newly created item
	        Integer i = 0;

	        while(true){
		        List<ProcessInstanceWorkitem> newWorkItemIds = [SELECT Id, actorId FROM ProcessInstanceWorkitem where ProcessInstanceId =:proInst.Id];
		        if (newWorkItemIds.size() < 1){
		        	break;
		        }

		        i++;
		        List<User> lsUser = new List<User>();
		        mapSteps.put(i, lsUser);

		        for (ProcessInstanceWorkitem wi : newWorkItemIds){
			        // Instantiate the new ProcessWorkitemRequest object and populate it
			        Approval.ProcessWorkitemRequest req = 
			            new Approval.ProcessWorkitemRequest();
			        req.setComments('Approving request.');
			        req.setAction('Approve');
			        
			        // Use the ID from the newly created item to specify the item to be worked
			        req.setWorkitemId(wi.Id);


					try{
				        // Submit the request for approval
				        Approval.ProcessResult result =  Approval.process(req);		        
					}
					catch(Exception e){
						System.debug(e.getMessage());
					}
				    mapSteps.get(i).add(mapUser.get(wi.ActorId));

		        }        
	        }	    	
	    }
	    catch(Exception e){
	    	ApexPages.addMessages(e);
	    }

        Database.rollback(sp);
		return mapSteps;
	}    
}