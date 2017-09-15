trigger afterDesignUpdate on Design__c(after update)
{
system.debug('--------------------Abhay1-----------------------');
     // bypass DM user
if(Util.byPassValidation()== true)
  return ;
   system.debug('--------------------Abhay2-----------------------');       

    DesignManagement.afterDesignUpdate (Trigger.new, Trigger.old , Trigger.oldMap);
}