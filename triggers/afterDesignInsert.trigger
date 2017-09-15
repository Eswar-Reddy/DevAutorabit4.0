trigger afterDesignInsert on Design__c(after insert)
{
 
 // bypass DM user
if(Util.byPassValidation()== true)
  return ;

DesignManagement.afterDesignInsert (Trigger.new);
}