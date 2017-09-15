// This trigger only populate Partner Portal User field so 
// As per the  discuss with richard as on 04 the Aug 2009 
// No need to do this becuase the same thing done on insert also,
// so going to comment it  

trigger afterUserUpdate on User(after update)
{
	if(UserInfo.getUserId()=='00580000003XtZw' || UserInfo.getUserId()=='00580000003Xtm2' ||UserInfo.getUserId()=='00580000003XrG4')
	{
		return;
	}
	UserManagement.sendMailtoPSR(Trigger.new, Trigger.oldMap);//for case #00068206
	/*
    Set<ID> userIds= new Set<ID>();
	//Modified because there is limitation of future calling inside other future so putting a Condition here that Change only if Active is true       
    for(User u:Trigger.new){
    	//Condition added as on August 04, 2009 for future call problem
        if(u.IsActive)
        	userIds.add(u.Id);
    }
	//Only for Active users
    if(userIds.size()>0){
    	boolean doCall =false;
    	//Now check if only Partner_Portal_User__c = null;
    	for(User uL: [select id, Contact.Partner_Portal_User__c	from User where id in  :userIds and contactId != null and Contact.Partner_Portal_User__c = null]){ 
    		doCall =true;
    		break;
    	}
    	//Only if required else not
    	if(doCall)
    		UserManagement.afterUserUpdate (userIDs);
    }
    */
}
/*Comment Section
	Modified as on 04 Aug2009 due to Future calls inside Future problem 
*/