trigger ScoreSetting on Score_Setting__c (after insert, after update, after delete) 
{
    Map <String, Dealer_Scoring__c> settingsMap = Dealer_Scoring__c.getAll();
    Boolean updateScores = false;
    
    if(trigger.isInsert)
    {
        List <Dealer_Scoring__c> settingsToInsert = new List <Dealer_Scoring__c>();
        
        for(Score_Setting__c ss : trigger.new)
        {
            Dealer_Scoring__c ds = new Dealer_Scoring__c();
            ds.Calculation_Type__c = ss.Calculation_Type__c;
            ds.Field_Label__c = ss.Field_Label__c;
            ds.Field_Name__c = ss.Field_Name__c;
            ds.Field_Value__c = ss.Field_Value__c;
            ds.Operator__c = ss.Operator__c;
            ds.Score_Value__c = ss.Score_Value__c;
            ds.Sort_Order__c = ss.Sort_Order__c;
            ds.Name = ss.Name;
            ds.Filter_Field__c = ss.Filter_Field__c;
            ds.Filter_Value__c = ss.Filter_Value__c;
            settingsToInsert.add(ds);
        }
        
        if(settingsToInsert.size() > 0)
        {
            updateScores = true;
            insert settingsToInsert;
        }
    }
    else
    
    if(trigger.isUpdate)
    {
        List <Dealer_Scoring__c> settingsToUpdate = new List <Dealer_Scoring__c>();
        
        for(Score_Setting__c ss : trigger.new)
        {
            Score_Setting__c beforeUpdate = system.trigger.oldMap.get(ss.Id);
            
            if(ss.Calculation_Type__c != beforeUpdate.Calculation_Type__c ||
            ss.Field_Label__c != beforeUpdate.Field_Label__c ||
            ss.Field_Name__c != beforeUpdate.Field_Name__c ||
            ss.Field_Value__c != beforeUpdate.Field_Value__c ||
            ss.Operator__c != beforeUpdate.Operator__c ||
            ss.Score_Value__c != beforeUpdate.Score_Value__c ||
            ss.Sort_Order__c != beforeUpdate.Sort_Order__c ||
            ss.Filter_Field__c != beforeUpdate.Filter_Field__c ||
            ss.Filter_Value__c != beforeUpdate.Filter_Value__c)
            {
                Dealer_Scoring__c existingSetting = settingsMap.get(ss.Name);
                existingSetting.Calculation_Type__c = ss.Calculation_Type__c; 
                existingSetting.Field_Label__c = ss.Field_Label__c;
                existingSetting.Field_Name__c = ss.Field_Name__c;
                existingSetting.Field_Value__c = ss.Field_Value__c;
                existingSetting.Operator__c = ss.Operator__c;
                existingSetting.Score_Value__c = ss.Score_Value__c;
                existingSetting.Sort_Order__c = ss.Sort_Order__c;
                existingSetting.Filter_Field__c = ss.Filter_Field__c;
                existingSetting.Filter_Value__c = ss.Filter_Value__c;
                settingsToUpdate.add(existingSetting);
            }
        }
        
        if(settingsToUpdate.size() > 0)
        {
            updateScores = true;
            update settingsToUpdate;
        }
    }
    else
    
    if(trigger.isDelete)
    {
        List <Dealer_Scoring__c> settingsToDelete = new List <Dealer_Scoring__c>();
        
        for(Score_Setting__c ss : trigger.old)
        {
            Dealer_Scoring__c existingSetting = settingsMap.get(ss.Name);
            if(existingSetting != null)
            {
                settingsToDelete.add(existingSetting);
            }
        }
        
        if(settingsToDelete.size() > 0)
        {
            updateScores = true;
            delete settingsToDelete;
        }
    }
    
    DealerGeneral__c dg = DealerGeneral__c.getInstance();
    if (dg.Enable_ALR_Dealer_Scoring__c == true)
    {
        if(updateScores)
        {
            UpdateDealerScores updateDS = new UpdateDealerScores();
            ID batchprocessid = Database.executeBatch(updateDS, 1);
        }
    }
}