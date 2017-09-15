trigger afterCaseInsertUpdate on Case (after insert, after update) 
{
    if(util.isSkipTrigger())
    {
            return;
    }
    CaseManagement.afterCaseInsertUpdate(Trigger.oldMap, Trigger.newMap);
    
    List<Case> lstCases=new List<Case>();
    if(Trigger.isUpdate)
    {
    for(Case c:Trigger.New)
    {
    System.debug('###'+c.Survey_Sent__c+'::'+Trigger.OldMap.get(c.ID).Survey_Sent__c) ;
    if(c.Survey_Sent__c==True&&Trigger.OldMap.get(c.ID).Survey_Sent__c==False)
    {
    lstCases.add(c);
    }
    }    
    if(lstCases.size()>0)
    {
        PostCallSurvey.createPostCallSurveyObjectWithContactLastSurveyDateUpdate(lstCases);
    }
    }
}