global class CalculateDealerScore
{

    //list for accounts to be inserted/updated
    global List <Account> accountList = new List <Account>();
    global Boolean accountTriggerRequest = false;
    
    global void calculateScoresInsert()
    {   
        //Get list of all settings
        List <Dealer_Scoring__c> settings = Dealer_Scoring__c.getAll().values();
        
        //Get list of "Number" Calculation Type settings for later
        List <Dealer_Scoring__c> numberSettingList = new List <Dealer_Scoring__c>();
        
        //Aggregate the scores by each field name to get the maximum score allowed
        system.debug('@@@@@CalculateDealerRollups.calculateRollupsInsert_Acct (SOQL): Aggregate for maxScores');
        List <AggregateResult> maxScores = new List <AggregateResult>([SELECT Field_Name__c, Field_Label__c, Sort_Order__c, Filter_Field__c, Filter_Value__c, MAX(Score_Value__c) maxScore FROM Dealer_Scoring__c GROUP BY Field_Name__c, Field_Label__c, Sort_Order__c, Filter_Field__c, Filter_Value__c ORDER BY Sort_Order__c]);
        decimal totalScoreAvailable = 10;
        system.debug('@@@@@CalculateDealerScore.calculateScoresInsert (SOQL): Aggregate for maxScores');
        
        //Create the maps to score the max scores per category, running score results, and friendly names for the fields
        Map <String, String> maxScoreMap = new Map <String, String>();
        Map <String, Dealer_Scoring__c> textSettingMap = new Map <String, Dealer_Scoring__c>();
        Map <String, Dealer_Scoring__c> percentSettingMap = new Map <String, Dealer_Scoring__c>();
        Map <String, String> fieldLabels = new Map <String, String>();
        
        //Total the max scores allowed for each category
        //add the categories to the scoreResults map - this will be used to track the score results in the next set of code
        for(AggregateResult ms : maxScores)
        {
            maxScoreMap.put(string.valueOf(ms.get('Field_Name__c')), string.valueOf(ms.get('maxScore')));
            fieldLabels.put(string.valueOf(ms.get('Field_Name__c')), string.valueOf(ms.get('Field_Label__c')));
            totalScoreAvailable += decimal.valueOf(double.valueOf(ms.get('maxScore')));
        }
        
        //Build the maps and lists that will be used to use the groups of settings based on calculation type
        for(Dealer_Scoring__c ds : settings)
        {
            if(ds.Calculation_Type__c == 'Text')
            {
                textSettingMap.put(string.valueOf(ds.Field_Name__c) + '|' + string.valueOf(ds.Field_Value__c), ds);
            }
            else
            if(ds.Calculation_Type__c == 'Percent')
            {
                percentSettingMap.put(string.valueOf(ds.Field_Name__c), ds);
            }
            else
            if(ds.Calculation_Type__c == 'Number')
            {
                numberSettingList.add(ds);
            }
        }
        
        //Loop through the accounts being sent
        for(Account acct : accountList)
        {   
            //Initialize the dealer score and score results at zero, initialize the adjustment to 10 for the maximum amount allowed
            decimal score = 0;
            Decimal percent = 0;
            String scoreSummary = '';
            Map <String, String> scoreResults = new Map <String, String>();
            Map <String, String> fieldValues = new Map <String, String>();
           
            //If settings are found, begin comparing record to possible scores
            if(settings.size() > 0)
            {
                for(AggregateResult ms : maxScores)
                {
                    decimal catScore = 0;
                    decimal settingScore = 0;
                    scoreResults.put(string.valueOf(ms.get('Field_Name__c')), string.valueOf(0));
                    fieldValues.put(string.valueOf(ms.get('Field_Name__c')), '');
                    
                    //Set the field name to compare (valueToGet) and the value (value)
                    String valueToGet = string.valueOf(ms.get('Field_Name__c'));
                    String value = string.valueOf(acct.get(valueToGet));
                    String filterValueToGet = string.valueOf(ms.get('Filter_Field__c'));
                    String filterValueToMatch = string.valueOf(ms.get('Filter_Value__c'));
                    String filterValue;
                    
                    if(!string.isBlank(filterValueToGet))
                    {
                        filterValue = string.valueOf(acct.get(filterValueToGet));
                    }
                    
                    system.debug('@@@@@ field filter: ' + filterValueToGet + ' ' + filterValueToMatch + ' ' + filterValue);
                    
                    //Create a dealer score setting to be filled in later
                    Dealer_Scoring__c setting = new Dealer_Scoring__c();
                    
                    
                    //Look for a score setting in the text setting map that matches the field and value of the account
                    setting = textSettingMap.get(valueToGet+'|'+value);
                    
                    if(!string.isBlank(string.valueOf(setting)) && (string.isBlank(string.valueOf(setting.Filter_Field__c)) || filterValueToMatch == filterValue))
                    {
                        if(setting.Calculation_Type__c == 'Text' && setting.Field_Value__c == value && !string.isBlank(string.valueOf(setting.Score_Value__c)))
                        {
                            //Increase the score and update the summary field with the score results
                            settingScore += decimal.valueOf(double.valueOf(setting.Score_Value__c));
                            
                            //Add the field value to the fieldValues map to use in the summary later
                            fieldValues.put(valueToGet, value);
                        }
                    }
                    
                    else
                    {
                        //If no text setting was found, look for a percent setting in the percent setting map
                        setting = percentSettingMap.get(valueToGet);
                        
                        if(!string.isBlank(string.valueOf(setting)) && (string.isBlank(string.valueOf(setting.Filter_Field__c)) || filterValueToMatch == filterValue))
                        {
                            //Initialize the percentage to zero
                            value = '0';
                            
                            //Set the percentage based on the record's field value
                            if(!string.isBlank(string.valueOf(acct.get(valueToGet))))
                            {
                                value = string.valueOf(acct.get(valueToGet));
                            }
                            
                            //Calculate the score increase based on the percentage value returned
                            //For example, if the field value is 85% and the maximum points for the score is 100, the returned points will be 85
                            decimal percentScore = decimal.valueOf(double.valueOf(setting.Score_Value__c)) * decimal.valueOf(double.valueOf(value))/100;
                            
                            //Increase the score and update the summary field with the score results
                            settingScore += percentScore;
                            
                            //Add the field value to the fieldValues map to use in the summary later
                            fieldValues.put(valueToGet, decimal.valueOf(value).round() + '%');
                        }
                        else
                        {
                            //If no percent setting was found, compare all remaining number settings from the number settings list
                            for(Dealer_Scoring__c dsn : numberSettingList)
                            {
                                if(string.isBlank(string.valueOf(dsn.Filter_Field__c)) || filterValueToMatch == filterValue)
                                {
                                    //Number calculations are used to evaluate if a number value is equal to, between, or greater/less than another value
                                    if(dsn.Operator__c == 'Between')
                                    {
                                        //Split the field value on semi-colon to return the low and high values for the 'between' evaluation
                                        String[] numSplit = dsn.Field_Value__c.split(';');
                                        
                                        //Make sure the split returns two numbers
                                        if(numSplit.size() == 2 && !string.isBlank(value) && !string.isBlank(numSplit[0]) && !string.isBlank(numSplit[1]) && numSplit[0].isNumeric() && numSplit[1].isNumeric() && decimal.valueOf(numSplit[0]) <= decimal.valueOf(value) && decimal.valueOf(numSplit[1]) >= decimal.valueOf(value))
                                        {
                                            //Increase the score if the field value is between the high and low values from the score setting
                                            settingScore += decimal.valueOf(double.valueOf(dsn.Score_Value__c));
                                                
                                            //Add the field value to the fieldValues map to use in the summary later
                                            fieldValues.put(valueToGet, 'between ' + string.valueOf(numSplit[0]) + ' and ' + string.valueOf(numSplit[1]));
                                        }
                                    }
                                    else
                                        
                                    if(dsn.Operator__c == 'Greater Than' && !string.isBlank(value) && !string.isBlank(dsn.Field_Value__c) && value.isNumeric() && dsn.Field_Value__c.isNumeric() && decimal.valueOf(dsn.Field_Value__c) < decimal.valueOf(value))
                                    {
                                        //Increase the score if the field value is between the high and low values from the score setting
                                        settingScore += decimal.valueOf(double.valueOf(dsn.Score_Value__c));
                                        
                                        //Add the field value to the fieldValues map to use in the summary later
                                        fieldValues.put(valueToGet, 'greater than ' + value);
                                    }
                                    else
                                            
                                    //Less than operator setting
                                    if(dsn.Operator__c == 'Less than' && !string.isBlank(value) && !string.isBlank(dsn.Field_Value__c) && value.isNumeric() && dsn.Field_Value__c.isNumeric() && decimal.valueOf(dsn.Field_Value__c) > decimal.valueOf(value))
                                    {
                                        //Increase the score if the field value is less than the value from the score setting
                                        settingScore += decimal.valueOf(double.valueOf(dsn.Score_Value__c));
                                        
                                        //Add the field value to the fieldValues map to use in the summary later
                                        fieldValues.put(valueToGet, 'less than ' + value);
                                    }
                                    else
                                            
                                    //Greater than or equal to operator setting
                                    if(dsn.Operator__c == 'Greater than or equal to' && !string.isBlank(value) && !string.isBlank(dsn.Field_Value__c) && value.isNumeric() && dsn.Field_Value__c.isNumeric() && decimal.valueOf(dsn.Field_Value__c) <= decimal.valueOf(value))
                                    {
                                        //Increase the score if the field value is more than or equal to the value from the setting
                                        settingScore += decimal.valueOf(double.valueOf(dsn.Score_Value__c));
                                        
                                        //Add the field value to the fieldValues map to use in the summary later
                                        fieldValues.put(valueToGet, 'greater than ' + value);
                                    }
                                    else
                                            
                                    //Less than or equal to operator setting
                                    if(dsn.Calculation_Type__c == 'Number' && dsn.Operator__c == 'Less than or equal to' && !string.isBlank(value) && !string.isBlank(dsn.Field_Value__c) && value.isNumeric() && dsn.Field_Value__c.isNumeric() && decimal.valueOf(dsn.Field_Value__c) >= decimal.valueOf(value))
                                    {
                                        //Increase the score if the field value is less than or equal to the value from the setting
                                        settingScore += decimal.valueOf(double.valueOf(dsn.Score_Value__c));
                                        
                                        //Add the field value to the fieldValues map to use in the summary later
                                        fieldValues.put(valueToGet, 'Less than ' + value);
                                    }
                                    else
                                    
                                    //Equals operator setting
                                    if(dsn.Calculation_Type__c == 'Number' && dsn.Operator__c == 'Equals' && !string.isBlank(value) && !string.isBlank(dsn.Field_Value__c) && value.isNumeric() && dsn.Field_Value__c.isNumeric() && decimal.valueOf(dsn.Field_Value__c) == decimal.valueOf(value))
                                    {
                                        //Increase the score if the field value is equal to the value from the score setting
                                        settingScore += decimal.valueOf(double.valueOf(dsn.Score_Value__c));
                                            
                                        //Add the field value to the fieldValues map to use in the summary later
                                        fieldValues.put(valueToGet, 'equals ' + value);
                                    }
                                }
                            }
                        }
                    }
                    
                    //Update the record's score for the category using this pass. If the record does not meet the criteria for this pass, it will increase the score by 0
                    catScore = decimal.valueOf(scoreResults.get(valueToGet)) + settingScore.setScale(1);
                    
                    //Add the updated catScore back to the score results to track the scores
                    scoreResults.put(valueToGet, string.valueOf(catScore));
                    
                    //Add this pass of the score to the total score. As stated above, if the record does not meet the criteria on this pass, the score will not increase
                    score += settingScore;
                
                    //set spacing value for each summary line (for better formatting)
                    String dot = '.';
                    integer repeatNum = 40 - fieldLabels.get(string.valueOf(ms.get('Field_Name__c'))).length();
                    
                    if(!string.isBlank(string.valueOf(setting)) && (string.isBlank(string.valueOf(setting.Filter_Field__c)) || filterValueToMatch == filterValue))
                    {
                        scoreSummary += fieldLabels.get(string.valueOf(ms.get('Field_Name__c'))) + dot.repeat(repeatNum) + ' ' + fieldValues.get(string.valueOf(ms.get('Field_Name__c'))) + ' for ' + scoreResults.get(string.valueOf(ms.get('Field_Name__c'))) + ' pts (' + maxScoreMap.get(string.valueOf(ms.get('Field_Name__c'))) + ' max)' + '\n';
                    }
                }
                
                //Add the discretionary adjustment to the running score and set the value on the record
                if (acct.RSM_Discretionary_Adj__c != null)
                {
                    if(acct.Theater__c == 'North America')
                    {
                        score += decimal.valueOf(double.valueOf(acct.RSM_Discretionary_Adj__c));
                    }
                }
                 
                //09.30.13
                if (score == null) acct.Dealer_Score_Total__c = 0;
                else acct.Dealer_Score_Total__c = score;
                
                //Calculate the percentage of points received, compile the summary text, and set the summary field value
                if(totalScoreAvailable != 0)
                {
                    percent = decimal.valueOf(double.valueOf(score)).divide(decimal.valueOf(double.valueOf(totalScoreAvailable)), 2)*100;
                }
                else percent = 0;
                
                //set spacing value for each summary line (for better formatting)
                String dot = '.';
                String textAdj = 'RSM Discretionary Adj';
                String valueAdj = string.valueOf(integer.valueOf(acct.RSM_Discretionary_Adj__c));
                integer repeatNum = 40 - textAdj.length();
                acct.Dealer_Score_Percent__c = percent;
                
                if(string.isBlank(valueAdj))
                {
                    valueAdj = '0';
                }
                if(acct.Theater__c == 'North America' || acct.Theater__c == 'Central America and the Caribbean')
                {
                    acct.Dealer_Score_Summary__c = scoreSummary + textAdj + dot.repeat(repeatNum) + ' ' + valueAdj + ' pts  (10 max) ';
                }
                else acct.Dealer_Score_Summary__c = scoreSummary;     
            }   
        }
        
        if(!accountTriggerRequest)
        {
            Database.saveResult [] srList = database.update(accountList, false);
            
            List <Job_Result__c> jobresults = new List <Job_Result__c>();
            
            integer rowIndex = 0;
            
            for (Database.SaveResult sr : srList) 
            {
                if (sr.isSuccess()) 
                {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully updated Account. Account ID: ' + sr.getId());
                }
                else 
                {
                    
                    
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) 
                    {
                        Job_Result__c jr = new Job_Result__c();
                        jr.Result__c = 'CalculateDealerScore failed for Account Id: ' + accountList[rowIndex].Id + ' - ' + err.getStatusCode() + ': ' + err.getMessage();
                        jobresults.add(jr);                        
                    }
                }
                
                rowIndex += 1;
            }
            
            try
            {
                insert jobresults;
            }
            catch(exception e)
            {
            
            }
        }
    }
}