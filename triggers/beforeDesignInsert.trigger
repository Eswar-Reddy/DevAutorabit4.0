trigger beforeDesignInsert on Design__c(before insert)
{
 // bypass DM user
if(Util.byPassValidation()== true)
  return ;
  
   DesignManagement.beforeDesignInsert (Trigger.new);
}