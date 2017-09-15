/*Created by hemant */
public  class PerformanceCompositePrev {
	
  
   public PerformanceCompositePrev(){}
   
   //Logic for Composite Market metric 
   public static void addCompositeMetricForMarket(List<Metric_Tier_Relation__c> composite,List<PerformanceEvalPreviousController.MetricsDetails> currentTier,Date expDate,Id performanceId,String accountId)
   {
       for(Metric_Tier_Relation__c mtr : composite){
         if(mtr.Metric_Label__c.equals(PerformanceEvalCst.MEET_SIX_MARKET))
         { 
                 PerformanceEvalPreviousController.MetricsDetails m = new PerformanceEvalPreviousController.MetricsDetails();
                   m.meetricTierRel = mtr;
                   List<Metric__c> mlst = mtr.Metrics__r;
                       //filter mlst by Account Id
                   if(mlst != null && mlst.size() > 0  )
                   {  
                       m.metric = mlst.get(0);
                       if(expDate > Date.Today() && m.metric.Overriden__c==false)
                       {
                           Boolean goal=checkMarketUSAGoalMet(currentTier);
                           m.metric.Goal_Met__c=goal;
                           m.metric.Boolean_Achievement__c=goal;     
                       }
                   }
                   else
                   {
                       Metric__c met = new Metric__c();
                       met.Account__c = accountId;
                       met.Metric_Tier_Relation__c = mtr.Id;
                       met.Performance_Metric__c = performanceId;
                       
                       Boolean goal=checkMarketUSAGoalMet(currentTier);
                       met.Goal_Met__c=goal;
                       met.Boolean_Achievement__c=goal;  
                       m.metric=met;           
                   }
                   currentTier.add(m); 
         }
         if(mtr.Metric_Label__c.equals(PerformanceEvalCst.THREE_MARKET_EU))
         {
             PerformanceEvalPreviousController.MetricsDetails m = new PerformanceEvalPreviousController.MetricsDetails();
                   m.meetricTierRel = mtr;
                   List<Metric__c> mlst = mtr.Metrics__r;
                       //filter mlst by Account Id
                   if(mlst != null && mlst.size() > 0  )
                   {
                       m.metric = mlst.get(0);
                       if(expDate > Date.Today() && m.metric.Overriden__c==false)
                       {
                           Boolean goal=checkMarketEUGoalMet(currentTier,'THREE');
                           m.metric.Goal_Met__c=goal;
                           m.metric.Boolean_Achievement__c=goal;     
                       }
                   }
                   else
                   {
                       Metric__c met = new Metric__c();
                       met.Account__c = accountId;
                       met.Metric_Tier_Relation__c = mtr.Id;
                       met.Performance_Metric__c = performanceId;
                       
                       Boolean goal=checkMarketEUGoalMet(currentTier,'THREE');
                       met.Goal_Met__c=goal;
                       met.Boolean_Achievement__c=goal;  
                       m.metric=met;           
                   }
                   currentTier.add(m); 
         }
         if(mtr.Metric_Label__c.equals(PerformanceEvalCst.FOUR_MARKET_EU))
         {
             PerformanceEvalPreviousController.MetricsDetails m = new PerformanceEvalPreviousController.MetricsDetails();
                   m.meetricTierRel = mtr;
                   List<Metric__c> mlst = mtr.Metrics__r;
                       //filter mlst by Account Id
                   if(mlst != null && mlst.size() > 0  )
                   {
                       m.metric = mlst.get(0);
                       if(expDate > Date.Today() && m.metric.Overriden__c==false)
                       {
                           Boolean goal=checkMarketEUGoalMet(currentTier,'FOUR');
                           m.metric.Goal_Met__c=goal;
                           m.metric.Boolean_Achievement__c=goal;     
                       }
                   }
                   else
                   {
                       Metric__c met = new Metric__c();
                       met.Account__c = accountId;
                       met.Metric_Tier_Relation__c = mtr.Id;
                       met.Performance_Metric__c = performanceId;
                       
                       Boolean goal=checkMarketEUGoalMet(currentTier,'FOUR');
                       met.Goal_Met__c=goal;
                       met.Boolean_Achievement__c=goal;  
                       m.metric=met;           
                   }
                   currentTier.add(m); 
         }
         if(mtr.Metric_Label__c.equals(PerformanceEvalCst.SIX_MARKET_EU))
         {
             PerformanceEvalPreviousController.MetricsDetails m = new PerformanceEvalPreviousController.MetricsDetails();
                   m.meetricTierRel = mtr;
                   List<Metric__c> mlst = mtr.Metrics__r;
                       //filter mlst by Account Id
                   if(mlst != null && mlst.size() > 0  )
                   {
                       m.metric = mlst.get(0);
                       if(expDate > Date.Today() && m.metric.Overriden__c==false)
                       {
                           Boolean goal=checkMarketEUGoalMet(currentTier,'SIX');
                           m.metric.Goal_Met__c=goal;
                           m.metric.Boolean_Achievement__c=goal;     
                       }
                   }
                   else
                   {
                       Metric__c met = new Metric__c();
                       met.Account__c = accountId;
                       met.Metric_Tier_Relation__c = mtr.Id;
                       met.Performance_Metric__c = performanceId;
                       
                       Boolean goal=checkMarketEUGoalMet(currentTier,'SIX');
                       met.Goal_Met__c=goal;
                       met.Boolean_Achievement__c=goal;  
                       m.metric=met;           
                   }
                   currentTier.add(m); 
         }
         if(mtr.Metric_Label__c.equals(PerformanceEvalCst.SEVEN_MARKET_EU))
         {
             PerformanceEvalPreviousController.MetricsDetails m = new PerformanceEvalPreviousController.MetricsDetails();
                   m.meetricTierRel = mtr;
                   List<Metric__c> mlst = mtr.Metrics__r;
                       //filter mlst by Account Id
                   if(mlst != null && mlst.size() > 0  )
                   {
                       m.metric = mlst.get(0);
                       if(expDate > Date.Today() && m.metric.Overriden__c==false)
                       {
                           Boolean goal=checkMarketEUGoalMet(currentTier,'SEVEN');
                           m.metric.Goal_Met__c=goal;
                           m.metric.Boolean_Achievement__c=goal;     
                       }
                   }
                   else
                   {
                       Metric__c met = new Metric__c();
                       met.Account__c = accountId;
                       met.Metric_Tier_Relation__c = mtr.Id;
                       met.Performance_Metric__c = performanceId;
                       
                       Boolean goal=checkMarketEUGoalMet(currentTier,'SEVEN');
                       met.Goal_Met__c=goal;
                       met.Boolean_Achievement__c=goal;  
                       m.metric=met;           
                   }
                   currentTier.add(m); 
         }  
       }
   }
   
   //check if the market Composite metric req no. of child metrics have met their goal
   public static Boolean checkMarketEUGoalMet(List<PerformanceEvalPreviousController.MetricsDetails> currentTier,String metricCount)
   {
       Integer count=0;
       for(PerformanceEvalPreviousController.MetricsDetails m : currentTier)
       {
          if(m.metric.Boolean_Achievement__c)
          {
               count++;
          } 
       }
       
       if(metricCount.equals('SIX'))
       {
           if(count>=6)
              return true; 
           else
              return false; 
       }
       else if(metricCount.equals('SEVEN'))
       {
           if(count>=7)
              return true; 
           else
              return false; 
       }
       else if(metricCount.equals('THREE'))
       {
           if(count>=3)
              return true; 
           else
              return false; 
       }
       else if(metricCount.equals('FOUR'))
       {
           if(count>=4)
              return true; 
           else
              return false; 
       }
       else
       {
           return false;
       }      
   }
  
  //check if the market Composite metric child metrics have met their goal
   public static Boolean checkMarketUSAGoalMet(List<PerformanceEvalPreviousController.MetricsDetails> currentTier)
   {
       Boolean flag=false;
       for(PerformanceEvalPreviousController.MetricsDetails m : currentTier)
       {
           if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MARKET_USA_M1))
           {
               flag=true;
               if(!m.metric.Boolean_Achievement__c)
               {
                   return false;
               }
           }
           else if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MARKET_USA_M2))
           {
               flag=true;
               if(!m.metric.Boolean_Achievement__c)
               {
                   return false;
               }
           }
           else if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MARKET_USA_M3))
           {
               flag=true;
               if(!m.metric.Boolean_Achievement__c)
               {
                   return false;
               }
           }
           else if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MARKET_USA_M4))
           {
               flag=true;
               if(!m.metric.Boolean_Achievement__c)
               {
                   return false;
               }
           }
           else if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MARKET_USA_M5))
           {
               flag=true;
               if(!m.metric.Boolean_Achievement__c)
               {
                   return false;
               }
           }
           else if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MARKET_USA_M6))
           {
               flag=true;
               if(!m.metric.Boolean_Achievement__c)
               {
                   return false;
               }
           }
       }
       
       if(flag)
         return true;
       else
         return false;  
   }
   
   // code to check if both the SPWR Elite tier are met.
   public static Boolean checkSPWRGoalMet2(List<PerformanceEvalPreviousController.MetricsDetails> currentTier)
   {
       Boolean flag=false;
       for(PerformanceEvalPreviousController.MetricsDetails m : currentTier)
       {
           if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SEVENTY_RES_KITS_EU))
           {
               flag=true;
               if(!m.metric.Goal_Met__c)
               {
                   return false;
               }
           }
           else if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SEVENTY_COM_INVTR_EU))
           {
               flag=true;
               if(!m.metric.Goal_Met__c)
               {
                   return false;
               }
           }
       }
       
       if(flag)
         return true;
       else
         return false;  
   }
   
   // code to check if all the 6 spwr metric's goals are met
   public static Boolean checkSPWRGoalMet1(List<PerformanceEvalPreviousController.MetricsDetails> currentTier)
   {
       Boolean flag=false;
       for(PerformanceEvalPreviousController.MetricsDetails m : currentTier)
       {
           if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M1))
           {
               flag=true;
               if(!m.metric.Goal_Met__c)
               {
                   return false;
               }
           }
           else if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M2))
           {
               flag=true;
               if(!m.metric.Goal_Met__c)
               {
                   return false;
               }
           }
           else if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M3))
           {
               flag=true;
               if(!m.metric.Goal_Met__c)
               {
                   return false;
               }
           }
           else if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M4))
           {
               flag=true;
               if(!m.metric.Goal_Met__c)
               {
                   return false;
               }
           }
           else if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M5))
           {
               flag=true;
               if(!m.metric.Goal_Met__c)
               {
                   return false;
               }
           }
           else if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M6))
           {
               flag=true;
               if(!m.metric.Goal_Met__c)
               {
                   return false;
               }
           }
       }
       
       if(flag)
         return true;
       else
         return false;  
   }
   //code for SPWR composite calculation
   public static void addCompositeMetricForSPWR(List<Metric_Tier_Relation__c> composite,List<PerformanceEvalPreviousController.MetricsDetails> currentTier,Date expDate,Id performanceId,String accountId)
   {
       for(Metric_Tier_Relation__c mtr : composite){
         if(mtr.Metric_Label__c.equals(PerformanceEvalCst.MEET_SIX_SWPR))
         {
                   PerformanceEvalPreviousController.MetricsDetails m = new PerformanceEvalPreviousController.MetricsDetails();
                   m.meetricTierRel = mtr;
                   List<Metric__c> mlst = mtr.Metrics__r;
                   if(mlst != null && mlst.size() > 0  )
                   {
                       m.metric = mlst.get(0);
                       if(expDate > Date.Today() && m.metric.Overriden__c==false)
                       {
                           Boolean goal=checkSPWRGoalMet1(currentTier);
                           m.metric.Goal_Met__c=goal;
                           m.metric.Boolean_Achievement__c=goal;     
                       }
                   }
                   else
                   {
                       Metric__c met = new Metric__c();
                       met.Account__c = accountId;
                       met.Metric_Tier_Relation__c = mtr.Id;
                       met.Performance_Metric__c = performanceId;
                       
                       Boolean goal=checkSPWRGoalMet1(currentTier);
                       met.Goal_Met__c=goal;
                       met.Boolean_Achievement__c=goal;  
                       m.metric=met;           
                   }
                   currentTier.add(m); 
         }
         if(mtr.Metric_Label__c.equals(PerformanceEvalCst.ALL_SWPR_EU))
         {
             PerformanceEvalPreviousController.MetricsDetails m = new PerformanceEvalPreviousController.MetricsDetails();
                   m.meetricTierRel = mtr;
                   List<Metric__c> mlst = mtr.Metrics__r;
                       //filter mlst by Account Id
                   if(mlst != null && mlst.size() > 0  )
                   {
                       m.metric = mlst.get(0);
                       if(expDate > Date.Today() && m.metric.Overriden__c==false)
                       {
                           Boolean goal=checkSPWRGoalMet2(currentTier);
                           m.metric.Goal_Met__c=goal;
                           m.metric.Boolean_Achievement__c=goal;     
                       }
                   }
                   else{
                       Metric__c met = new Metric__c();
                       met.Account__c = accountId;
                       met.Metric_Tier_Relation__c = mtr.Id;
                       met.Performance_Metric__c = performanceId;
                       
                       Boolean goal=checkSPWRGoalMet2(currentTier);
                       met.Goal_Met__c=goal;
                       met.Boolean_Achievement__c=goal;  
                       m.metric=met;           
                   }
                   currentTier.add(m); 
         }  
       }
    }
}