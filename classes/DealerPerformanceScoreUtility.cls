/*
Apex Class: DealerPerformanceScoreUtility
Description: Utility Class responsible for the calculation of Dealer Criteria Scores

Code Revision History: 
XX.FEB.2014 Initial Version by CloudSherpas Development Team
21.JUL.2014 2nd Version modified class to display 1 decimal value - Modified By: Michi Magsarili
12.AUG.2014 3nd Version add in Custom Settings for flexibility (for Case 00378549) - Modified By: Michi Magsarili 
*/
public class DealerPerformanceScoreUtility {
   
    public static List<DealerPerformanceScoreUtility.MetricWrapper> calculateScores(Id AccountId) {

        Account account = [SELECT Id, Name, Dealer_Tier__c, Opp_Convert_Rate__c,
                            Contact_SLA__c, SFDC_Timely_Updates__c, RSM_Discretionary_Adj__c
                            FROM Account WHERE Id =: AccountId LIMIT 1];
        
        List<DealerPerformanceScoreUtility.MetricWrapper> lMetricWrappers = new List<DealerPerformanceScoreUtility.MetricWrapper>();  
        
        //MAM 08/12/2014 - Use Custom Settings to compute for the Dealer Score Criteria start
        List<Dealer_Performance_Score_Setting__c> lDealerPerformanceSetting = new List<Dealer_Performance_Score_Setting__c>();
        
        lDealerPerformanceSetting = [SELECT Field_Name__c, Field_Label__c, Field_Value__c, Maximum_Score__c 
                                     FROM Dealer_Performance_Score_Setting__c 
                                     WHERE Category__c = 'DealerPerformanceScoreUtility' 
                                     ORDER BY Display_Order__c, Maximum_Score__c]; 
        
        //Get Max Scores For Entries that have the same values 
        Map<String,Integer> mMaxPoints = new Map<String,Integer> ();
        
        for (Dealer_Performance_Score_Setting__c DPS : lDealerPerformanceSetting){
            if(!mMaxPoints.isEmpty()){
                if(mMaxPoints.containsKey(DPS.Field_Label__c))
                    System.debug('@DPS.Maximum_Score__c ' + DPS.Maximum_Score__c);
                    System.debug('DPS.Field_Label__c ' + mMaxPoints.get(DPS.Field_Label__c));
                    if(mMaxPoints.get(DPS.Field_Label__c) < DPS.Maximum_Score__c){
                        mMaxPoints.put(DPS.Field_Label__c,Integer.valueof(DPS.Maximum_Score__c));
                    }
            }else{
                mMaxPoints.put(DPS.Field_Label__c,Integer.valueof(DPS.Maximum_Score__c));            
            }
        }
        System.debug('@mMaxPoints'+mMaxPoints);
        
        for (Dealer_Performance_Score_Setting__c DPS : lDealerPerformanceSetting){
            if(DPS.Field_Label__c.equals('Dealer Tier')){
                if(account.get(DPS.Field_Name__c).equals(DPS.Field_Value__c))
                    lMetricWrappers.add(new MetricWrapper(DPS.Field_Label__c, DPS.Field_Label__c, mMaxPoints.get(DPS.Field_Label__c), String.ValueOf(account.get(DPS.Field_Name__c)), Integer.valueOf(DPS.Maximum_Score__c)));
            }
            else{
                if(account.get(DPS.Field_Name__c) != null){
                    Decimal YourVAL = (decimal) account.get(DPS.Field_Name__c);
                    Decimal YourPTS = 0.0;
                    if(DPS.Field_Label__c.equals('Score Adjustment')){
                        YourPTS = YourVAL;
                        lMetricWrappers.add(new MetricWrapper(DPS.Field_Label__c, DPS.Field_Label__c, Integer.valueOf(DPS.Maximum_Score__c), String.valueOf(YourVAL.setScale(1)), YourPTS.setScale(1)));
                    }else{
                        YourPTS = (YourVAL*Integer.valueOf(DPS.Maximum_Score__c))/100;
                        lMetricWrappers.add(new MetricWrapper(DPS.Field_Label__c, DPS.Field_Label__c, Integer.valueOf(DPS.Maximum_Score__c), String.valueOf(YourVAL.setScale(1))+'%', YourPTS.setScale(1)));
                    }
                }
                else{
                    lMetricWrappers.add(new MetricWrapper(DPS.Field_Label__c, DPS.Field_Label__c, Integer.valueOf(DPS.Maximum_Score__c), '0.0', 0.0));
                }
            }
        }
        
        Decimal totalPoints = 0.0;
        Integer totalMaxPoints = 0;
        for(MetricWrapper m : lMetricWrappers) {
            totalPoints += m.yourpoints;
            totalMaxPoints +=  m.maxpoints;
        }
        lMetricWrappers.add(new MetricWrapper('TOTAL', '', totalMaxPoints , 'N/A', totalpoints));
        //MAM 08/12/2014 end
               
        return lMetricWrappers;
    }
    
    public class MetricWrapper {
        
        public String metric {get; set;}
        public String metricDecription {get; set;}
        public Integer maxpoints {get; set;}
        public String yourvalue {get; set;}
        public Decimal yourpoints {get; set;}
        
        public MetricWrapper(String metric, String metricDecription, Integer maxpoints, String yourvalue, Decimal yourpoints) {
            this.metric = metric;
            this.metricDecription = metricDecription;
            this.maxpoints = maxpoints;
            this.yourvalue = yourvalue;
            this.yourpoints = yourpoints;            
        }
    }
}