trigger beforeDesignUpdate on Design__c(before update)
{
 // bypass DM user
//if(Util.byPassValidation()== true)
//  return ;
    DesignManagement.beforeDesignUpdate (Trigger.new, Trigger.oldMap); 
}