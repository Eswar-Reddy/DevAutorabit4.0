public with sharing class IncentiveCompositePrevController {
 public IncentiveCompositePrevController(){}
   
   // code for market composite metric
    public static void addCompositeMetricForMarket(List<Metric_Tier_Relation__c> composite,List<IncentiveDetailPrevController.MetricsDetails> currentTier,Date expDate,Id performanceId,String accountId)
   {
       for(Metric_Tier_Relation__c mtr : composite){  
         if(mtr.Metric_Label__c.equals(PerformanceEvalCst.MEET_SIX_MARKET))
         {
                 IncentiveDetailPrevController.MetricsDetails m = new IncentiveDetailPrevController.MetricsDetails();
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
             IncentiveDetailPrevController.MetricsDetails m = new IncentiveDetailPrevController.MetricsDetails();
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
             IncentiveDetailPrevController.MetricsDetails m = new IncentiveDetailPrevController.MetricsDetails();
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
             IncentiveDetailPrevController.MetricsDetails m = new IncentiveDetailPrevController.MetricsDetails();
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
             IncentiveDetailPrevController.MetricsDetails m = new IncentiveDetailPrevController.MetricsDetails();
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
   
   public static Boolean checkMarketEUGoalMet(List<IncentiveDetailPrevController.MetricsDetails> currentTier,String metricCount)
   {
       Integer count=0;
       for(IncentiveDetailPrevController.MetricsDetails m : currentTier)
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
   // check if all the 6 marketing child metric are met       
   public static Boolean checkMarketUSAGoalMet(List<IncentiveDetailPrevController.MetricsDetails> currentTier)
   {
       Boolean flag=false;
       for(IncentiveDetailPrevController.MetricsDetails m : currentTier)
       {
           if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MARKET_WRAP)) //MARKET_USA_M1
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
           else if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MARKET_JOB))//MARKET_USA_M3
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
           else if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MARKET_CERT))//MARKET_USA_M5
           {
               flag=true;
               if(!m.metric.Boolean_Achievement__c)
               {
                   return false;
               }
           }
           else if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MARKETADV))//MARKET_USA_M6
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
   // update the composite metric after save
   public static void updateCompositeMetricForMarket(List<IncentiveDetailPrevController.MetricsDetails> currentTier)
   {
       for(IncentiveDetailPrevController.MetricsDetails m: currentTier)
       {
             if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MEET_SIX_MARKET))
             {
                  if(m.metric.Overriden__c==false)
                  {
                      Boolean goal=checkMarketUSAGoalMet(currentTier);
                      m.metric.Goal_Met__c=goal;
                      m.metric.Boolean_Achievement__c=goal;
                      System.debug('===========m.metric================' + m.metric);                      
                      //changed
                      //update m.metric;
                      upsert m.metric; 
                   }   
             }
            if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.THREE_MARKET_EU))
            {
                if(m.metric.Overriden__c==false)
                  {
                    Boolean goal=checkMarketEUGoalMet(currentTier,'THREE');
                    m.metric.Goal_Met__c=goal;
                    m.metric.Boolean_Achievement__c=goal;
                    //changed
                    //update m.metric;
                    upsert m.metric;
                  }  
            }
            if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.FOUR_MARKET_EU))
            {
                if(m.metric.Overriden__c==false)
                {
                  Boolean goal=checkMarketEUGoalMet(currentTier,'FOUR');
                    m.metric.Goal_Met__c=goal;
                    m.metric.Boolean_Achievement__c=goal;
                    //changed
                    //update m.metric;
                    upsert m.metric;
                 }   
            }
            if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SIX_MARKET_EU))
            {
                if(m.metric.Overriden__c==false)
                {
                  Boolean goal=checkMarketEUGoalMet(currentTier,'SIX');
                    m.metric.Goal_Met__c=goal;
                    m.metric.Boolean_Achievement__c=goal;
                    //changed
                    //update m.metric;
                    upsert m.metric;
                }   
            }
            if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SEVEN_MARKET_EU))
            {
                if(m.metric.Overriden__c==false)
                {
                  Boolean goal=checkMarketEUGoalMet(currentTier,'SEVEN');
                    m.metric.Goal_Met__c=goal;
                    m.metric.Boolean_Achievement__c=goal; 
                    //changed
                    //update m.metric;
                    upsert m.metric;
                 }       
            }
       }
   }
   
   public static Boolean checkSPWRGoalMet2(List<IncentiveDetailPrevController.MetricsDetails> currentTier)
   {
       Boolean flag=false;
       for(IncentiveDetailPrevController.MetricsDetails m : currentTier)
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
   // check is all 9 metric are met
   public static Boolean checkSPWRGoalMet1(List<IncentiveDetailPrevController.MetricsDetails> currentTier)
   {
       Boolean flag=false;
       for(IncentiveDetailPrevController.MetricsDetails m : currentTier)
       {
           if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M1))
           {
               flag=true;
               if(!m.metric.Boolean_Achievement__c)
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
               if(!m.metric.Boolean_Achievement__c)
               {
                   return false;
               }
           }
           else if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M4))
           {
               flag=true;
               if(!m.metric.Boolean_Achievement__c)
               {
                   return false;
               }
           }
           else if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M5))
           {
               flag=true;
               if(!m.metric.Boolean_Achievement__c)
               {
                   return false;
               }
           }
           else if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M6))
           {
               flag=true;
               if(!m.metric.Boolean_Achievement__c)
               {
                   return false;
               }
           }
           else if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M7))
           {
               flag=true;
               if(!m.metric.Boolean_Achievement__c)
               {
                   return false;
               }
           }
           else if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M8))
           {
               flag=true;
               if(!m.metric.Boolean_Achievement__c)
               {
                   return false;
               }
           }
           else if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M9))
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
   
   public static void updateCompositeMetricForSPWR(List<IncentiveDetailPrevController.MetricsDetails> currentTier)
   {
       for(IncentiveDetailPrevController.MetricsDetails m: currentTier)
       {
             if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MEET_SIX_SWPR))
             {
                  if(m.metric.Overriden__c==false)
                  {
                      Boolean goal=checkSPWRsixGoalMet(currentTier,'SIX');
                      m.metric.Goal_Met__c=goal;
                      m.metric.Boolean_Achievement__c=goal; 
                      update m.metric;
                   }   
             }
       }
   }
   
   public static void addCompositeMetricForSPWR(List<Metric_Tier_Relation__c> composite,List<IncentiveDetailPrevController.MetricsDetails> currentTier,Date expDate,Id performanceId,String accountId)
   {
       for(Metric_Tier_Relation__c mtr : composite){
         if(mtr.Metric_Label__c.equals(PerformanceEvalCst.MEET_SIX_SWPR))
         {
                   IncentiveDetailPrevController.MetricsDetails m = new IncentiveDetailPrevController.MetricsDetails();
                   m.meetricTierRel = mtr;
                   List<Metric__c> mlst = mtr.Metrics__r;
                   if(mlst != null && mlst.size() > 0  )
                   {
                       m.metric = mlst.get(0);
                       if(expDate > Date.Today() && m.metric.Overriden__c==false)
                       {
                           Boolean goal=checkSPWRsixGoalMet(currentTier,'SIX');
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
                       
                       Boolean goal= checkSPWRsixGoalMet(currentTier,'SIX');
                       met.Goal_Met__c=goal;
                       met.Boolean_Achievement__c=goal;  
                       m.metric=met;           
                   }
                   currentTier.add(m); 
         }
         if(mtr.Metric_Label__c.equals(PerformanceEvalCst.ALL_SWPR_EU))
         {
             IncentiveDetailPrevController.MetricsDetails m = new IncentiveDetailPrevController.MetricsDetails();
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
                   else
                   {
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
   
   // calculation for performance to business plan metrics
   public static void addCompositeMetricForPbp(List<Metric_Tier_Relation__c> composite,List<IncentiveDetailPrevController.MetricsDetails> currentTier,Date expDate,Id performanceId,String accountId)
   {
       for(Metric_Tier_Relation__c mtr : composite){
         if(mtr.Metric_Label__c.equals(PerformanceEvalCst.RSM_OBJECTIVES)
           || mtr.Metric_Label__c.equals(PerformanceEvalCst.RSM_OBJECTIVES_EU))
         {
                   IncentiveDetailPrevController.MetricsDetails m = new IncentiveDetailPrevController.MetricsDetails();
                   m.meetricTierRel = mtr;
                   List<Metric__c> mlst = mtr.Metrics__r;
                   if(mlst != null && mlst.size() > 0  )
                   {
                       m.metric = mlst.get(0);
                       if(expDate > Date.Today() && m.metric.Overriden__c==false)
                       {
                           Boolean goal=checkPbpGoalMet1(currentTier);
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
                       
                       Boolean goal=checkPbpGoalMet1(currentTier);
                       met.Goal_Met__c=goal;
                       met.Boolean_Achievement__c=goal;  
                       m.metric=met;           
                   }
                   currentTier.add(m); 
         }
         
       }
   }
   // check if the goal is met for performance business plan child metric
   public static Boolean checkPbpGoalMet1(List<IncentiveDetailPrevController.MetricsDetails> currentTier)
   {
       Boolean flag=false;
       for(IncentiveDetailPrevController.MetricsDetails m : currentTier)
       {
           if(m.meetricTierRel.isRSMView__c==true 
              && !m.meetricTierRel.metric_label__c.equals(PerformanceEvalCst.SIX_MONTHS_TARGET)
              && !m.meetricTierRel.metric_label__c.equals(PerformanceEvalCst.KW_TARGET_EU))
           {
               flag=true;
               if(m.meetricTierRel.Boolean_Metric_Y_N__c==true)
               {
                   if(!m.metric.Boolean_Achievement__c)
                   {
                       return false;
                   }
               }
               else
               {    
                   if(!m.metric.Goal_Met__c)
                   {
                       return false;
                   }
               }
           }
       }
       
       if(flag)
         return true;
       else
         return false;  
   }
   public static void updateCompositeMetricForPbp(List<IncentiveDetailPrevController.MetricsDetails> currentTier)
   {
       for(IncentiveDetailPrevController.MetricsDetails m: currentTier)
       {
             if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.RSM_OBJECTIVES)
             || m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.RSM_OBJECTIVES_EU))
             {
                  if(m.metric.Overriden__c==false)
                  {
                      Boolean goal=checkPbpGoalMet1(currentTier);
                      m.metric.Goal_Met__c=goal;
                      m.metric.Boolean_Achievement__c=goal;
                      update m.metric;
                  }     
             }
       }
   }
   
   // code added as a part of phase2a on 21 Apr10 for Training
   public static void addCompositeMetricForTrn(List<Metric_Tier_Relation__c> composite,List<IncentiveDetailPrevController.MetricsDetails> currentTier,Date expDate,Id performanceId,String accountId)
   {
       for(Metric_Tier_Relation__c mtr : composite){
         if(mtr.Metric_Label__c.equals(PerformanceEvalCst.TRAINING_EXTRA_BONUS)){
                   IncentiveDetailPrevController.MetricsDetails m = new IncentiveDetailPrevController.MetricsDetails();
                   m.meetricTierRel = mtr;
                   List<Metric__c> mlst = mtr.Metrics__r;
                   if(mlst != null && mlst.size() > 0  )
                   {
                       m.metric = mlst.get(0);
                       if(expDate > Date.Today() && m.metric.Overriden__c==false)
                       {
                           Boolean goal=checkTrainingGoalMet2(currentTier);
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
                       
                       Boolean goal=checkTrainingGoalMet2(currentTier);
                       met.Goal_Met__c=goal;
                       met.Boolean_Achievement__c=goal;  
                       m.metric=met;           
                   }
                   currentTier.add(m); 
         }
         
       }
   }
   // code added as a part of phase 2a on 21Apr 10 
   public static Boolean checkTrainingGoalMet2(List<IncentiveDetailPrevController.MetricsDetails> currentTier)
   {
       Boolean flag=false;
       for(IncentiveDetailPrevController.MetricsDetails m : currentTier)
       {
           if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.TRAINING_EXTRA_BONUS_I))
           {
               flag=true;
               if(!m.metric.Goal_Met__c)
               {
                   return false;
               }
           }
           else if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.TRAINING_EXTRA_BONUS_II))
           {
               flag=true;
               if(!m.metric.Goal_Met__c)
               {
                   return false;
               }
           }
           else if(m.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.TRAINING_EXTRA_BONUS_II)){
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
   
   //code added for Phase 2a on 22 Apr 10 
   public static Boolean checkSPWRsixGoalMet(List<IncentiveDetailPrevController.MetricsDetails> currentTier,String metricCount)
   {
       Integer count=0;
       for(IncentiveDetailPrevController.MetricsDetails m : currentTier){
            if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M1)||m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M2)||m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M3)||m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M4)||m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M5)||m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M6)||m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M7)||m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M8)||m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M9)){
                if(m.metric.Boolean_Achievement__c){
                    count++;
                }   
            }    
       }
       
       if(metricCount.equals('SIX'))
       {
           if(count>=6)
              return true; 
           else
              return false; 
       }else
       {
           return false;
       }      
   }
  
  
/****************************************************************************************************************
*******************************************Overloaded Methods for CVAR(Added by hemant)*************************************
****************************************************************************************************************/
   
   /*
    public static void addCompositeMetricForMarket(List<Metric_Tier_Relation__c> composite,List<IncentiveDetailPrevCommController.MetricsDetails> currentTier,Date expDate,Id performanceId,String accountId)
   {
       for(Metric_Tier_Relation__c mtr : composite){
         if(mtr.Metric_Label__c.equals(PerformanceEvalCst.MEET_SIX_MARKET))
         {
                 IncentiveDetailPrevCommController.MetricsDetails m = new IncentiveDetailPrevCommController.MetricsDetails();
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
             IncentiveDetailPrevCommController.MetricsDetails m = new IncentiveDetailPrevCommController.MetricsDetails();
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
             IncentiveDetailPrevCommController.MetricsDetails m = new IncentiveDetailPrevCommController.MetricsDetails();
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
             IncentiveDetailPrevCommController.MetricsDetails m = new IncentiveDetailPrevCommController.MetricsDetails();
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
             IncentiveDetailPrevCommController.MetricsDetails m = new IncentiveDetailPrevCommController.MetricsDetails();
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
   }*/
   
   /*
   public static Boolean checkMarketEUGoalMet(List<IncentiveDetailPrevCommController.MetricsDetails> currentTier,String metricCount)
   {
       Integer count=0;
       for(IncentiveDetailPrevCommController.MetricsDetails m : currentTier)
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
   */
   
   /*
   // check if all the 6 marketing child metric are met       
   public static Boolean checkMarketUSAGoalMet(List<IncentiveDetailPrevCommController.MetricsDetails> currentTier)
   {
       Boolean flag=false;
       for(IncentiveDetailPrevCommController.MetricsDetails m : currentTier)
       {
           if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MARKET_WRAP)) //MARKET_USA_M1
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
           else if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MARKET_JOB))//MARKET_USA_M3
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
           else if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MARKET_CERT))//MARKET_USA_M5
           {
               flag=true;
               if(!m.metric.Boolean_Achievement__c)
               {
                   return false;
               }
           }
           else if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MARKETADV))//MARKET_USA_M6
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
   }*/
   
   /*
   // update the composite metric after save
   public static void updateCompositeMetricForMarket(List<IncentiveDetailPrevCommController.MetricsDetails> currentTier)
   {
       for(IncentiveDetailPrevCommController.MetricsDetails m: currentTier)
       {
             if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MEET_SIX_MARKET))
             {
                  if(m.metric.Overriden__c==false)
                  {
                      Boolean goal=checkMarketUSAGoalMet(currentTier);
                      m.metric.Goal_Met__c=goal;
                      m.metric.Boolean_Achievement__c=goal;
                      update m.metric; 
                   }   
             }
            if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.THREE_MARKET_EU))
            {
                if(m.metric.Overriden__c==false)
                  {
                    Boolean goal=checkMarketEUGoalMet(currentTier,'THREE');
                    m.metric.Goal_Met__c=goal;
                    m.metric.Boolean_Achievement__c=goal;
                    update m.metric; 
                  }  
            }
            if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.FOUR_MARKET_EU))
            {
                if(m.metric.Overriden__c==false)
                {
                  Boolean goal=checkMarketEUGoalMet(currentTier,'FOUR');
                    m.metric.Goal_Met__c=goal;
                    m.metric.Boolean_Achievement__c=goal;
                    update m.metric;
                 }   
            }
            if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SIX_MARKET_EU))
            {
                if(m.metric.Overriden__c==false)
                {
                  Boolean goal=checkMarketEUGoalMet(currentTier,'SIX');
                    m.metric.Goal_Met__c=goal;
                    m.metric.Boolean_Achievement__c=goal;
                    update m.metric;
                }   
            }
            if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SEVEN_MARKET_EU))
            {
                if(m.metric.Overriden__c==false)
                {
                  Boolean goal=checkMarketEUGoalMet(currentTier,'SEVEN');
                    m.metric.Goal_Met__c=goal;
                    m.metric.Boolean_Achievement__c=goal; 
                    update m.metric;
                 }       
            }
       }
   }
   */
   /*
   public static Boolean checkSPWRGoalMet2(List<IncentiveDetailPrevCommController.MetricsDetails> currentTier)
   {
       Boolean flag=false;
       for(IncentiveDetailPrevCommController.MetricsDetails m : currentTier)
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
   }*/
   
   /*
   // check is all 9 metric are met
   public static Boolean checkSPWRGoalMet1(List<IncentiveDetailPrevCommController.MetricsDetails> currentTier)
   {
       Boolean flag=false;
       for(IncentiveDetailPrevCommController.MetricsDetails m : currentTier)
       {
           if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M1))
           {
               flag=true;
               if(!m.metric.Boolean_Achievement__c)
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
               if(!m.metric.Boolean_Achievement__c)
               {
                   return false;
               }
           }
           else if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M4))
           {
               flag=true;
               if(!m.metric.Boolean_Achievement__c)
               {
                   return false;
               }
           }
           else if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M5))
           {
               flag=true;
               if(!m.metric.Boolean_Achievement__c)
               {
                   return false;
               }
           }
           else if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M6))
           {
               flag=true;
               if(!m.metric.Boolean_Achievement__c)
               {
                   return false;
               }
           }
           else if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M7))
           {
               flag=true;
               if(!m.metric.Boolean_Achievement__c)
               {
                   return false;
               }
           }
           else if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M8))
           {
               flag=true;
               if(!m.metric.Boolean_Achievement__c)
               {
                   return false;
               }
           }
           else if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M9))
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
   */
   /*
   public static void updateCompositeMetricForSPWR(List<IncentiveDetailPrevCommController.MetricsDetails> currentTier)
   {
       for(IncentiveDetailPrevCommController.MetricsDetails m: currentTier)
       {
             if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.MEET_SIX_SWPR))
             {
                  if(m.metric.Overriden__c==false)
                  {
                      Boolean goal=checkSPWRsixGoalMet(currentTier,'SIX');
                      m.metric.Goal_Met__c=goal;
                      m.metric.Boolean_Achievement__c=goal; 
                      update m.metric;
                   }   
             }
       }
   }*/
   
/*   
   public static void addCompositeMetricForSPWR(List<Metric_Tier_Relation__c> composite,List<IncentiveDetailPrevCommController.MetricsDetails> currentTier,Date expDate,Id performanceId,String accountId)
   {
       for(Metric_Tier_Relation__c mtr : composite){
         if(mtr.Metric_Label__c.equals(PerformanceEvalCst.MEET_SIX_SWPR))
         {
                   IncentiveDetailPrevCommController.MetricsDetails m = new IncentiveDetailPrevCommController.MetricsDetails();
                   m.meetricTierRel = mtr;
                   List<Metric__c> mlst = mtr.Metrics__r;
                   if(mlst != null && mlst.size() > 0  )
                   {
                       m.metric = mlst.get(0);
                       if(expDate > Date.Today() && m.metric.Overriden__c==false)
                       {
                           Boolean goal=checkSPWRsixGoalMet(currentTier,'SIX');
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
                       
                       Boolean goal= checkSPWRsixGoalMet(currentTier,'SIX');
                       met.Goal_Met__c=goal;
                       met.Boolean_Achievement__c=goal;  
                       m.metric=met;           
                   }
                   currentTier.add(m); 
         }
         if(mtr.Metric_Label__c.equals(PerformanceEvalCst.ALL_SWPR_EU))
         {
             IncentiveDetailPrevCommController.MetricsDetails m = new IncentiveDetailPrevCommController.MetricsDetails();
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
                   else
                   {
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
   */
   
   // calculation for performance to business plan metrics
   public static void addCompositeMetricForPbp(List<Metric_Tier_Relation__c> composite,List<IncentiveDetailPrevCommController.MetricsDetails> currentTier,Date expDate,Id performanceId,String accountId)
   {
       for(Metric_Tier_Relation__c mtr : composite){
         if(mtr.Metric_Label__c.equals(PerformanceEvalCst.RSM_OBJECTIVES))
         {
                   IncentiveDetailPrevCommController.MetricsDetails m = new IncentiveDetailPrevCommController.MetricsDetails();
                   m.meetricTierRel = mtr;
                   List<Metric__c> mlst = mtr.Metrics__r;
                   if(mlst != null && mlst.size() > 0  )
                   {
                       m.metric = mlst.get(0);
                       if(expDate > Date.Today() && m.metric.Overriden__c==false)
                       {
                           Boolean goal=checkPbpGoalMet1(currentTier);
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
                       
                       Boolean goal=checkPbpGoalMet1(currentTier);
                       met.Goal_Met__c=goal;
                       met.Boolean_Achievement__c=goal;  
                       m.metric=met;           
                   }
                   currentTier.add(m); 
         }
         
       }
   }
   // check if the goal is met for performance business plan child metric
   public static Boolean checkPbpGoalMet1(List<IncentiveDetailPrevCommController.MetricsDetails> currentTier){
       Boolean flag=false;
       // Done for the case # 00052096
       /*
       for(IncentiveDetailPrevCommController.MetricsDetails m : currentTier){
           if(m.meetricTierRel.isRSMView__c == true){
               flag=true;
               if(m.meetricTierRel.Boolean_Metric_Y_N__c==true){
                   if(!m.metric.Boolean_Achievement__c){
                       return false;
                   }
               }else{    
                   if(!m.metric.Goal_Met__c){
                       return false;
                   }
               }
           }
       }*/
       
       for(IncentiveDetailPrevCommController.MetricsDetails m : currentTier){
           if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.RSM_OBJ_1)){
               flag=true;
               if(!m.metric.Boolean_Achievement__c){
                   return false;
               }
           }else if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.RSM_OBJ_2)){
               flag=true;
               if(!m.metric.Boolean_Achievement__c){
                   return false;
               }
           }else if(m.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.RSM_OBJ_3)){
               flag=true;
               if(!m.metric.Boolean_Achievement__c){
                   return false;
               }
           }
       }
       
       if(flag)
         return true;
       else
         return false;  
   }
   
   public static void updateCompositeMetricForPbp(List<IncentiveDetailPrevCommController.MetricsDetails> currentTier){
       List<Metric__c> metricsToBeUpdated = new List<Metric__c>();
       for(IncentiveDetailPrevCommController.MetricsDetails m: currentTier){
             if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.RSM_OBJECTIVES)){
                  System.debug('====m.metric========'+m.metric);
                  System.debug('====m.metric========'+m.metric.Id);
                  if(m.metric.Overriden__c==false){
                      Boolean goal=checkPbpGoalMet1(currentTier);
                      m.metric.Goal_Met__c=goal;
                      m.metric.Boolean_Achievement__c=goal;
                      metricsToBeUpdated.add(m.metric);
                      //update m.metric;
                  }     
             }
       }
       
       if(metricsToBeUpdated.size() > 0){
        update metricsToBeUpdated;
       }
   }
   
   // code added as a part of phase2a on 21 Apr10 for Training
   public static void addCompositeMetricForTrn(List<Metric_Tier_Relation__c> composite,List<IncentiveDetailPrevCommController.MetricsDetails> currentTier,Date expDate,Id performanceId,String accountId){
       SYstem.debug('======composite======'+composite);
       for(Metric_Tier_Relation__c mtr : composite){
         if(mtr.Metric_Label__c.equals(PerformanceEvalCst.TRAINING_EXTRA_BONUS)){
                   IncentiveDetailPrevCommController.MetricsDetails m = new IncentiveDetailPrevCommController.MetricsDetails();
                   m.meetricTierRel = mtr;
                   List<Metric__c> mlst = mtr.Metrics__r;
                   if(mlst != null && mlst.size() > 0  ){
                       m.metric = mlst.get(0);
                       if(expDate > Date.Today() && m.metric.Overriden__c==false){
                           Boolean goal=checkTrainingGoalMet2(currentTier);
                           m.metric.Goal_Met__c=goal;
                           m.metric.Boolean_Achievement__c=goal;     
                       }
                   }else{
                       Metric__c met = new Metric__c();
                       met.Account__c = accountId;
                       met.Metric_Tier_Relation__c = mtr.Id;
                       met.Performance_Metric__c = performanceId;
                       
                       Boolean goal=checkTrainingGoalMet2(currentTier);
                       met.Goal_Met__c=goal;
                       met.Boolean_Achievement__c=goal;  
                       m.metric=met;           
                   }
                   currentTier.add(m); 
         }
         
       }
   }
   // code added as a part of phase 2a on 21Apr 10 
   public static Boolean checkTrainingGoalMet2(List<IncentiveDetailPrevCommController.MetricsDetails> currentTier){
       Boolean flag=false;
       for(IncentiveDetailPrevCommController.MetricsDetails m : currentTier){
           if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.TRAINING_ASS_SALES_CERT_CVAR)){
               flag=true;
               if(!m.metric.Goal_Met__c){
                   return false;
               }
           }else if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.TRAINING_ASS_DESIGN_CERT_CVAR)){
               flag=true;
               if(!m.metric.Goal_Met__c){
                   return false;
               }
           }else if(m.meetricTierRel.Metric_label__c.equals(PerformanceEvalCst.TRAINING_ASS_INSTALL_CERT_CVAR)){
               flag=true;
               if(!m.metric.Goal_Met__c){
                   return false;
               }
           }
           
       }
       
       if(flag)
         return true;
       else
         return false;  
   }
   
   /*
   //code added for Phase 2a on 22 Apr 10 
   public static Boolean checkSPWRsixGoalMet(List<IncentiveDetailPrevCommController.MetricsDetails> currentTier,String metricCount)
   {     
       Integer count=0;
       for(IncentiveDetailPrevCommController.MetricsDetails m : currentTier){
            if(m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M1)||m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M2)||m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M3)||m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M4)||m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M5)||m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M6)||m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M7)||m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M8)||m.meetricTierRel.Metric_Label__c.equals(PerformanceEvalCst.SPWR_M9)){
                if(m.metric.Boolean_Achievement__c){
                    count++;
                }   
            }    
       }
       
       if(metricCount.equals('SIX'))
       {
           if(count>=6)
              return true; 
           else
              return false; 
       }else
       {
           return false;
       }      
   }
   */
}