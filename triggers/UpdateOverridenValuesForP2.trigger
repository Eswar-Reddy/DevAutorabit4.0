trigger UpdateOverridenValuesForP2 on Metrics__c (after update, after Insert) 
{
    public list<Metrics__c> lst_Metrics = new list<Metrics__c>();
    Map<Id, Id> mMvsAccIds = new Map<Id, Id>();//All Accounts
    Map<Id, Double> mMvsPerYear = new Map<Id, Double>();//All Performence Years
    Map<Id, String> mMvsMetCode = new Map<Id, String>();//All Metric Code
    
    for(Id mId : Trigger.newMap.keySet())
    {
      if((Trigger.newMap.get(mId)).Performance_Period__c == 'P1')
      {
        mMvsAccIds.put((Trigger.newMap.get(mId)).Id, (Trigger.newMap.get(mId)).Account__c);
        mMvsPerYear.put((Trigger.newMap.get(mId)).Id, (Trigger.newMap.get(mId)).Performance_Year__c);
        mMvsMetCode.put((Trigger.newMap.get(mId)).Id, (Trigger.newMap.get(mId)).Metric_Code__c);
      }
    }//END FOR
    
    List<Metrics__c> lstRelMet = 
                                [SELECT id,Account__c,
                                    Performance_Period__c,
                                    Performance_Year__c,
                                    Metric_Code__c,
                                    Goal_Override__c,
                                    Result_Override__c,
                                    Bonus_Value_Overridden__c,
                                    Goal_for_Bonus_Display_Overridden__c,
                                    Goal_for_Bonus_Value_Overridden__c,
                                    Goal_for_Promotion_Display_Overridden__c,
                                    Goal_for_Promotion_Overridden__c,
                                    Goal_for_Retention_Overridden__c,
                                    Result_Overidden__c,
                                    Status_for_Bonus_Overidden__c,
                                    Status_for_Promotion_Overidden__c,
                                    Status_for_Retention_Overidden__c,
                                    Goal_for_Retention_Display_Overidden__c
                                FROM Metrics__c 
                                WHERE 
                                    Account__c IN : mMvsAccIds.values() AND 
                                    Performance_Period__c='P2' AND 
                                    Performance_Year__c IN : mMvsPerYear.values() AND 
                                    Metric_Code__c IN : mMvsMetCode.values()];
    if(!lstRelMet.isEmpty())
    {   
        for(Metrics__c mRel : lstRelMet)
        {
          for(Id mId : Trigger.newMap.keySet())
          {
            Metrics__c m = Trigger.newMap.get(mId);
            if(mRel.Account__c == m.Account__c && mRel.Performance_Year__c == m.Performance_Year__c && mRel.Metric_Code__c == m.Metric_Code__c)
            {
                mRel.Bonus_Value_Overridden__c= m.Bonus_Value_Overridden__c;
                mRel.Goal_for_Bonus_Display_Overridden__c= m.Goal_for_Bonus_Display_Overridden__c;
                mRel.Goal_for_Bonus_Value_Overridden__c= m.Goal_for_Bonus_Value_Overridden__c;
                mRel.Goal_for_Promotion_Display_Overridden__c= m.Goal_for_Promotion_Display_Overridden__c;
                mRel.Goal_for_Promotion_Overridden__c= m.Goal_for_Promotion_Overridden__c;
                mRel.Goal_for_Retention_Overridden__c= m.Goal_for_Retention_Overridden__c;
                mRel.Result_Overidden__c= m.Result_Overidden__c;
                mRel.Status_for_Bonus_Overidden__c= m.Status_for_Bonus_Overidden__c;
                mRel.Status_for_Promotion_Overidden__c= m.Status_for_Promotion_Overidden__c;
                mRel.Status_for_Retention_Overidden__c= m.Status_for_Retention_Overidden__c;
                mRel.Goal_for_Retention_Display_Overidden__c= m.Goal_for_Retention_Display_Overidden__c; 
                mRel.Goal_Override__c = m.Goal_Override__c;
                mRel.Result_Override__c = m.Result_Override__c;
                lst_Metrics.add(mRel);          
            }       
          }
        }
    
        try
        {
              update lst_Metrics;
        }
        catch(DMLException  e)
        {
          system.debug('The following error has occured' + e.getMessage());
        }
    }
}