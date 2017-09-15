// 
// (c) 2010 Appirio, Inc.
//
// Contains methods to calculate Comemmercial metric goals.
//
// 11/1/2010    Hemant Garg(Appirio offshore)   Original
//   
//Case 00096123 - Replaced ''+EvalDate.year() with new method getCurrentYear(performancePeriod)
public with sharing class PerformanceAchievementComm {
     
    /**  
     * Default Constructor
     */
    public PerformanceAchievementComm(){        
    
    }
    
    public static Date EvalDate = Date.Today();
    
    public  static void updatePrevEvalDate(Date evDate){
        EvalDate = evDate;
    }
    
    /**
     * C-1 Customer Satisfaction Score (CVAR for NA User)
     * @param accountId
     * @param validFrom
     * @param validTo
     * @return percentScore
     */
    public static Double computeCSATSCORE(Id accountId, Date validFrom, Date validTo ){
        Double score = 0;
        Integer count = 0;
        for(Customer_Survey_Result__c csat : [select Aggregate_Score_New__c  from Customer_Survey_Result__c where Partner_Account__c =: accountId and Survey_Response_Date__c >= :validFrom and Survey_Response_Date__c <= :validTo and Aggregate_Score_New__c != null and Account1__r.recordtype.name='Commercial Customer' ])
		{          
            score = score+csat.Aggregate_Score_New__c;
            count++;    
        }  
        return (score>0) ?  (score/count).round() : score;
    }
            
    /**
     * C-3 Installation Inspections – Powerguard, T5 and T10 Systems
     * @param accountId
     * @param validFrom
     * @param validTo
     * @return percentPassScore
     */
    public static Double computeInspections(Id accountId, Date validFrom, Date validTo){
        Double totalInspections = 0 ;
        Integer passCount = 0;  
        //Calculation percentage of inspections passed  
        for(Inspection__c insp : [select score__c ,Score_Details__c,Inspection_Date__c from Inspection__c where Case__c != null and Partner_Contact__r.AccountId =: accountId and Site_Type__c = 'Commercial' and Inspection_Date__c >= :validFrom and Inspection_Date__c <= :validTo]){
            System.debug('============insp=========='+insp);
            if(insp.Score_Details__c == 'YES' || insp.Score_Details__c == 'PASS' ){
                passCount++;
            }
            totalInspections++;
        }
        System.debug('============totalInspections=========='+totalInspections);
        System.debug('============passCount=========='+passCount);
        if(totalInspections > 0){
            return (passCount/totalInspections)*100;
        }else{
            return 0;
        }               
    }
    
    /**
     * C-5 SunPower Installations Registered at CRM
     * @param accountId
     * @param validFrom
     * @param validTo
     * @return percentInstallations
     */
    public static Double calcInstallationsRegistered(Id accountId, Date validFrom, Date validTo){
        
        //Number of Commercial Opportunities in Sales Stage ‘Closed/ Won’  and with last Stage change date 
        //within the period/ Oracle Shipments - Commercial
        //Oracle Shipments we assume Opportunity Amount We are not sure still have to be confirm 
        /*
        Double oracleShippmentValue = 0.0;
        Integer numOfClosedOpp =0;
        for(Opportunity opp:[select id,Amount from Opportunity where StageName ='Closed/Won' and RecordType.Name ='Commercial' and Closed_Won_Date__c > :validFrom and Closed_Won_Date__c  < :validTo ]){
            oracleShippmentValue += opp.Amount;
            numOfClosedOpp++;
        }
        if(numOfClosedOpp >0 ){
            return (numOfClosedOpp/oracleShippmentValue);
        }
        else 
            return 0;
        */
        /*Adopted Code from Residential as per discussion with Chandra*/
        // Done for case # 00053826 on 14March'2011
        //List<Opportunity> oppObj = [select StageName from Opportunity where (StageName='100% - Won' OR  StageName='Installation Completed' OR stageName='100% - Delivered' OR stageName = '100% Opportunity Won') and Closed_Won_Date__c >= :validFrom and Closed_Won_Date__c <= :validTo and PartnerAccountId=:accountId and RecordType.Name = 'Commercial'];
        List<Opportunity> oppObj = [select StageName from Opportunity where (StageName='100% - Won' OR  StageName='Installation Completed' OR stageName='100% - Delivered' OR stageName = '100% Opportunity Won') and Delivery_Date__c >= :validFrom and Delivery_Date__c <= :validTo and PartnerAccountId=:accountId and RecordType.Name = 'Commercial'];
        System.debug('=======oppObj====='+oppObj);
        Integer numOfClosedOpp=oppObj.size();        
        String currentQuarter = getCurrentQuarter();
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
        String year=getCurrentYear(performancePeriod);
        System.debug('======hemant==performancePeriod=='+performancePeriod);
        System.debug('======hemant=numOfClosedOpp==='+numOfClosedOpp);
        List<order_detail_sunrise2__c> orderDetail = [select Number_of_QTD_Commercial_PV_Order__c,oracle_account_number__r.Num_Open_Opportunities__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and Year__c=:year];// Changed Quarter__c in : quarters to =:currentQuarter and Quarter__c =:currentQuarter to performance period
        System.debug('===========orderDetail==='+orderDetail);
        Double qtdPVOrder = 0;
        if(orderDetail.size() > 0){
            for(order_detail_sunrise2__c ord : orderDetail){
             if(ord.Number_of_QTD_Commercial_PV_Order__c != null){
                qtdPVOrder = qtdPVOrder + ord.Number_of_QTD_Commercial_PV_Order__c;
             }
            }
            
        }
        System.debug('===========qtdPVOrder==='+qtdPVOrder);
       
        Decimal myDecimal = numOfClosedOpp * 100;
        Decimal divDec;
        if(qtdPVOrder != 0){
         divDec = myDecimal.divide(qtdPVOrder, 2, System.RoundingMode.UP);
         return (Double)divDec;
        }else{
         return 0;
        }
        
        
        /*
        System.debug('===========qtdPVOrder==='+qtdPVOrder);
        if(qtdPVOrder != 0)
           return (numOfClosedOpp/qtdPVOrder)*100; 
        else
           return 0;
          */ 
        /*
        if(orderDetail.size() > 0){
            Double qtdPVOrder=0;
            System.debug('======hemant=orderDetail==='+orderDetail);
            if(orderDetail.get(0).Number_of_QTD_Commercial_PV_Order__c!=null)
                qtdPVOrder=orderDetail.get(0).Number_of_QTD_Commercial_PV_Order__c; //qtdPVOrder+
                
            System.debug('======hemant=qtdPVOrder==='+qtdPVOrder);
            if(qtdPVOrder!=0)
                return (numOfClosedOpp/qtdPVOrder)*100; 
            else
                return 0;
        }else{
            return 0;
        }*/
    }
    
    /**
     * C7- Warranty Cards
     * @param accountId
     * @param validFrom
     * @param validTo
     * @return percentAssetCount
     */
    public static Double calcWarrantyCards(Id accountId, Date validFrom, Date validTo){
        
        Set<Id> commAccId = new Set<Id>();
        Integer numOppsWon = 0;
        for(Opportunity opp : [Select StageName, Closed_Won_Date__c, AccountId, PartnerAccountId From Opportunity where PartnerAccountId =:accountID and RecordType.Name = 'Commercial']){
            if(opp.AccountId != null){
                commAccId.add(opp.AccountId);
            }
            if((opp.StageName == '100% - Won' || opp.StageName == 'Installation Completed' || opp.StageName == '100% - Delivered' || opp.stageName == '100% Opportunity Won') && (opp.Closed_Won_Date__c >= validFrom && opp.Closed_Won_Date__c <= validTo))
                numOppsWon += 1;
        }
        //validFrom = validFrom.addDays(14);
        date weekStart = validTo.toStartofWeek();
        weekStart = weekStart.addDays(14);
        //Start of the Week and 2 weeks after
        validTo = weekStart;
        System.debug('============== number of commAccId===='+commAccId.size());
        System.debug('==============commAccId===='+commAccId);
        Double assetCount = [select count() from Asset where AccountId IN :commAccId and (CreatedDate  > :validFrom and CreatedDate  < :validTo)];
        System.debug('==============assetCount===='+assetCount);
        System.debug('==============numOppsWon===='+numOppsWon);
        if(numOppsWon > 0){
            return (assetCount/numOppsWon)* 100;
        }else{
            return 0;
        }
    } 
    
    /**
     * C-14.1 Training: Fundamentals of Commercial Design
     * @param accountId 
     * @return (# Active Personnel attended the "Fundamentals of Commercial Design" Course) 
     */
    public static Double calcTrainingFundCommDesignAssocDesign(Id accountId){       
    
      
        List<Certification__c> certification = [select Attended_ILC__c from Certification__c where  Curriculum_Level__c in (:'Associate') and Account__c =:accountId and Curriculum_Role__c in (:'Design') and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE /* and Business__c = 'COMMERCIAL' */]; // terminated condition is added as Checking existing queries for Phase2a in class PerformanceAchievement];
        System.debug('======Training1==='+certification.size());
        return certification.size();
      
    }
    
    /**
     * C-15.1 Training: Fundamentals of Commercial Installation
     * @param accountId 
     * @return (# Active Personnel attended the "Fundamentals of Commercial Installation" Course) 
     */
    public static Double calcTrainingFundCommDesignAssocInstall(Id accountId){
           List<Certification__c> certification = [select Attended_ILC__c from Certification__c where  Curriculum_Level__c in (:'Associate') and Account__c =:accountId and Curriculum_Role__c in (:'Install') and Attended_ILC__c =: true AND PartnerContact__r.Terminated__c = FALSE /* and Business__c = 'COMMERCIAL' */]; // terminated condition is added as Checking existing queries for Phase2a in class PerformanceAchievement];
        System.debug('======Training2==='+certification.size());
        return certification.size();
    
    }
    
    /**
     * C-16.1 Training: Fundamentals of Commercial Sales
     * @param accountId 
     * @return (# Personnel attended the "Fundamentals of Commercial Sales" Course) 
     */
    public static Double calcTrainingFundCommDesignAssocSales(Id accountId){    
        List<Certification__c> certification = [select Attended_ILC__c from Certification__c where  Curriculum_Level__c in (:'Associate') and Account__c =:accountId and Curriculum_Role__c in (:'Sales') and Attended_ILC__c =: true AND PartnerContact__r.Terminated__c = FALSE /* and Business__c = 'COMMERCIAL' */]; // terminated condition is added as Checking existing queries for Phase2a in class PerformanceAchievement];
        System.debug('======Training3==='+certification.size());
        return certification.size();
    
    }
        
    /**
     * C-14.2 Training: Associate Commercial Design Certification
     * @param accountId 
     * @return (# of personnel certified for Assoc Commercial Sales)
     */
    public static Double calcTrainingFundCommDesignAssocDesignCert(Id accountId){
        // adding a condition to check the certified as true
        List<Certification__c> certification = [select Attended_ILC__c from Certification__c where  Curriculum_Level__c in (:'Associate') and Account__c =:accountId and Curriculum_Role__c in (:'Design') and (Attended_ILC__c =: true OR Is_Certified__c = true)  AND PartnerContact__r.Terminated__c = FALSE /* and Business__c = 'COMMERCIAL' */]; // terminated condition is added as Checking existing queries for Phase2a in class PerformanceAchievement];
        System.debug('========calcTrainingFundCommDesignAssocDesignCert');
        return certification.size();
    
    }
    
    /**
     * C-15.2 Training: Associate Commercial Installation Certification
     * @param accountId 
     * @return (# of personnel certified for Assoc Commercial  Install)
     */
    public static Double calcTrainingFundCommDesignAssocInstallCert(Id accountId){
        // adding a condition to check the certified as true
        List<Certification__c> certification = [select Attended_ILC__c from Certification__c where  Curriculum_Level__c in (:'Associate') and Account__c =:accountId and Curriculum_Role__c in (:'Install') and (Attended_ILC__c =: true OR Is_Certified__c = true) AND PartnerContact__r.Terminated__c = FALSE  /* and Business__c = 'COMMERCIAL' */]; // terminated condition is added as Checking existing queries for Phase2a in class PerformanceAchievement];
        return certification.size();
    
    }
    
    /**
     * C-16.2 Training: Associate Commercial Sales Certification
     * @param accountId 
     * @return (# of personnel certified for Assoc Commercial  Sales)
     */
    public static Double calcTrainingFundCommDesignAssocSalesCert(Id accountId){
        // adding a condition to check the certified as true
        List<Certification__c> certification = [select Attended_ILC__c from Certification__c where  Curriculum_Level__c in (:'Associate') and Account__c =:accountId and Curriculum_Role__c in (:'Sales') and (Attended_ILC__c =: true OR Is_Certified__c = true) AND PartnerContact__r.Terminated__c = FALSE  /* and Business__c = 'COMMERCIAL' */]; // terminated condition is added as Checking existing queries for Phase2a in class PerformanceAchievement];
        return certification.size();
    
    }
     
    /**
     * C-19 Must be an Active Dealer 
     * @param accountId
     * @param validFrom
     * @param validTo
     * @return Boolean
     */
    public static Map<String, boolean> mustBeAnActiveDealer(Id accountId, Date validFrom, Date validTo){
        Map<String, boolean> mapMetricAchievement = new Map<String, boolean>();
        String currentQuarter = getCurrentQuarter();
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
        String year=getCurrentYear(performancePeriod);
        System.debug('===year==='+year);
        System.debug('===accountID==='+accountID);
        System.debug('====performancePeriod=='+performancePeriod);
        List<order_detail_sunrise2__c> orderDetail = [select Number_of_QTD_Commercial_PV_Order__c,QTD_kW_for_Commercial_Orders__c,Cumulative_kW_for_Commercial_Orders__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod  and Year__c=:year];// Changed Quarter__c in : quarters to =:currentQuarter and Quarter__c =:currentQuarter to performance period
        System.debug('======orderDetail==='+orderDetail);
        Double qtdCommPv=0;
        Double qtdKw=0;
        if(orderDetail!=null && orderDetail.size() > 0){
            for(order_detail_sunrise2__c ord : orderDetail){
                if(ord.Number_of_QTD_Commercial_PV_Order__c != null)
                    qtdCommPv = qtdCommPv + ord.Number_of_QTD_Commercial_PV_Order__c; //qtdCommPv+(
                if(ord.Cumulative_kW_for_Commercial_Orders__c != null)
                    qtdKw = qtdKw + ord.Cumulative_kW_for_Commercial_Orders__c;
            } 
        }
        System.debug('======qtdKw==='+qtdKw);
        System.debug('======qtdCommPv==='+qtdCommPv);
        
        if(qtdKw >= 50){
            mapMetricAchievement.put(PerformanceEvalCst.PBP_ACTIVE_DEALER_CVAR_50KW,true);           
        }else if(qtdCommPv >= 2){
            mapMetricAchievement.put(PerformanceEvalCst.PBP_ACTIVE_DEALER_CVAR_2SYSTEM,true);                      
        }
            /*
        if(orderDetail!=null && orderDetail.size() > 0){
            System.debug('=====hemant=====orderDetail=='+orderDetail);
            Double qtdCommPv=0;
            Double qtdKw=0;
           
            if(orderDetail.get(0).Number_of_QTD_Commercial_PV_Order__c!=null)
                qtdCommPv=orderDetail.get(0).Number_of_QTD_Commercial_PV_Order__c; //qtdCommPv+(
            if(orderDetail.get(0).Cumulative_kW_for_Commercial_Orders__c!=null)
                qtdKw=orderDetail.get(0).Cumulative_kW_for_Commercial_Orders__c; //qtdKw+(
                        
            if(qtdKw >= 50){
                return true;
            }else if(qtdCommPv >= 2){
                return true;
            }
        }*/
        return mapMetricAchievement;
    }
    
    /**
     * C-24- Credit Limit Maintained    
     * @param accountId
     * @param validFrom
     * @param validTo
     * @return Boolean
     */ 
    public static Boolean isCreditLineMaintained(Id accountId, Date validFrom, Date validTo){       
        Boolean isMaintained = false;              
        Account partnerAcc;
        Double minCreditLimit = 100000;
        //Querying partner account
        List<Account> listAcc = [select Available_Credit__c, Credit_Hold__c, Credit_Limit__c from Account where Id=:accountId];
        if(listAcc != null && listAcc.size() > 0){
            partnerAcc = listAcc.get(0);
        }
        //if at present the credit line is not maintained then no need to check history, return from here
        if(partnerAcc != null){
            if(!partnerAcc.Credit_Hold__c && (partnerAcc.Available_Credit__c == null || partnerAcc.Available_Credit__c >= 0) && partnerAcc.Credit_Limit__c >= minCreditLimit ){
                isMaintained = true;
            }else{
                isMaintained = false;
                return false;
            }
        }else{
            isMaintained = false;
            return false;
        }
        
        if(!isMaintained){
            return false;
        }
        
        System.debug('========1.isMaintained========='+isMaintained);
        //checking change history for last 90 days, if credit line is violated then 
        //immediately break and return from the loop
        for(AccountHistory accHis :[SELECT AccountId, OldValue, NewValue, Id, Field, CreatedDate from AccountHistory where AccountId =:accountId and (Field = 'Credit_Hold__c' OR Field = 'Available_Credit__c') and (createdDate <=:System.now() and createdDate >=:System.now().addDays(-90))]){
            System.debug('===hemant===='+accHis);
            if(accHis.Field == 'Credit_Hold__c') {
                if(accHis.OldValue == false){
                    isMaintained = true;
                }else{
                    isMaintained = false;
                }               
            }else if(accHis.Field == 'Available_Credit__c'){
                if(accHis.OldValue == null ||((Double)accHis.OldValue >= 0)){
                    isMaintained = true;
                }else{
                    isMaintained = false;
                }                                           
            }
            if(!isMaintained){
                break;
            }
        }   
        System.debug('========2.isMaintained========='+isMaintained);    
        return isMaintained;        
    }
    
    /**
     * C-25- SunPower and Dealer Growth Plan - semi-annual   
     * @param accountId
     * @param validFrom
     * @param validTo
     * @return Boolean
     */ 
    public static Boolean calcDealerGrowthPlan(Id accountId, Date validFrom, Date validTo){
        //NOT CLEARED YET
        return true;
    }
    
    /**
     * C-26 SunPower Share of Account (PV purchases in kW)    
     * @param accountId
     * @param validFrom
     * @param validTo
     * @return Cumulative No of Commercial PV orders
     */ 
    public static Double  calculatePVPurchasesInKw(Id accountId, Date validFrom, Date validTo){
        String currentQuarter = getCurrentQuarter();
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
        String year=getCurrentYear(performancePeriod);
        List<order_detail_sunrise2__c> orderDetail = [select Cumulative_No_of_Commercial_PV_orders__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod  and Year__c=:year];// Changed Quarter__c in : quarters to =:currentQuarter and Quarter__c =:currentQuarter to performance period
        if(orderDetail!=null && orderDetail.size() > 0){
           return orderDetail.get(0).Cumulative_No_of_Commercial_PV_orders__c;         
        }
        return 0.0;
    }

    /**
     * C-29 Dealer Bonuses for meeting Business Objectives    
     * @param accountId
     * @param validFrom
     * @param validTo
     * @return Boolean
     */ 
    public static boolean calculateDealerBonuses(){
        //NOT CLEARED YET
        return true;
    }
    
    /**
     * Method to find current Quarter 
     * @return String
     */ 
    public static String getCurrentQuarter(){
        Date tDate = EvalDate;
        Integer Day=tDate.day();
        Integer mon= tDate.month();
               
        if((mon==1)&&(Day>=4 && Day<=31))
         return 'Q1';
         else if((mon==2)&&(Day>=1 && Day<=29))
         return 'Q1';
         else if((mon==3)&&(Day>=1 && Day<=31))
         return 'Q1';
         else if((mon==4)&&(Day>=1 && Day<=4))
         return 'Q1';
         
         if((mon==4)&&(Day>=5 && Day<=30))
         return 'Q2';
         else if((mon==5)&&(Day>=1 && Day<=31))
         return 'Q2';
         else if((mon==6)&&(Day>=1 && Day<=30))
         return 'Q2';
         else if((mon==7)&&(Day>=1 && Day<=4))
         return 'Q2';
         
        if((mon==7)&&(Day>=5&& Day<=31))
         return 'Q3';
        else if((mon==8)&&(Day>=1&& Day<=31))
         return 'Q3';
        else if((mon==9)&&(Day>=1&& Day<=30))
         return 'Q3';
        else if((mon==10)&&(Day>=1&& Day<=3))
         return 'Q3';
         
         if((mon==10)&&(Day>=4&& Day<=31))
         return 'Q4';
        else if((mon==11)&&(Day>=1&& Day<=30))
         return 'Q4';
        else if((mon==12)&&(Day>=1&& Day<=31))
         return 'Q4';
        else if((mon==1)&&(Day>=1&& Day<=3))
         return 'Q4';
        
        return null;
   }
     
   /**
    * Method to find current performance period by Quarter 
    * @return String
    */  
   public static String getCurrentPerformancePeriod(String quater){
        if(quater.equals('Q1')||quater.equals('Q2')){
            return 'P1';    
        }else if(quater.equals('Q3')||quater.equals('Q4')){
            return 'P2';
        }   
        return null;
   }
   
   //method to find year by performancePeriod
   public static String getCurrentYear(String performancePeriod){
   		Date tDate = EvalDate; 
   		Integer year= tDate.year();       
        Integer mon= tDate.month();
        
        if(performancePeriod.equals('P2') && mon == 1){
            return String.valueOf(year-1);    
        }else{
            return String.valueOf(year);
        }          
   }
   
   public static List<String> getQuartesBetweenDates(Date frm,Date to){
        List<String> quarters=new List<String>();
        Integer startQuater=getQuarterByDate(frm);
        Integer endQuater=getQuarterByDate(to);
        if(startQuater==endQuater)
        {
            String quarter='Q'+startQuater;
            quarters.add(quarter);
        }
        else if(endQuater>startQuater)
        {
            for(Integer i=startQuater;i<=endQuater;i++)
            {
                String quarter='Q'+i;
                quarters.add(quarter);
            }
        }
        else if(startQuater>endQuater)
        {
            quarters.add(getCurrentQuarter());
        }
        return quarters;
    }
    
     public static Integer getQuarterByDate(Date tDate){
        Integer mon= tDate.month();
        Integer Day=tDate.day();
       if((mon==1)&&(Day>=4 && Day<=31))
         return 1;
         else if((mon==2)&&(Day>=1 && Day<=29))
         return 1;
         else if((mon==3)&&(Day>=1 && Day<=31))
         return 1;
         else if((mon==4)&&(Day>=1 && Day<=4))
         return 1;
         
         if((mon==4)&&(Day>=5 && Day<=30))
         return 2;
         else if((mon==5)&&(Day>=1 && Day<=31))
         return 2;
         else if((mon==6)&&(Day>=1 && Day<=30))
         return 2;
         else if((mon==7)&&(Day>=1 && Day<=4))
         return 2;
         
        if((mon==7)&&(Day>=5&& Day<=31))
         return 3;
        else if((mon==8)&&(Day>=1&& Day<=31))
         return 3;
        else if((mon==9)&&(Day>=1&& Day<=30))
         return 3;
        else if((mon==10)&&(Day>=1&& Day<=3))
         return 3;
         
         if((mon==10)&&(Day>=4&& Day<=31))
         return 4;
        else if((mon==11)&&(Day>=1&& Day<=30))
         return 4;
        else if((mon==12)&&(Day>=1&& Day<=31))
         return 4;
        else if((mon==1)&&(Day>=1&& Day<=3))
         return 4;
        
        return null;
   }
   
   /**
    * Method to check whether Goal is met or not for a metric 
    * @return Boolean
    */
   public static Boolean checkGoalMet(Double minGoal,Double maxGoal,Double achievement){
        System.debug('=====hemant====checkGoalMet');
        
        if(minGoal!=null && maxGoal!=null && (achievement>=minGoal && achievement<=maxGoal)){
            System.debug('=====1.=====');
            return true;
        }else if(minGoal!=null && maxGoal!=null && (achievement<minGoal || achievement>maxGoal)){
            System.debug('=====2.=====');
            return false;
        }else if(minGoal!=null && achievement>=minGoal){
            System.debug('=====3.=====');
            return true;
        }else if(maxGoal!=null && achievement<=maxGoal){
            System.debug('=====4.=====');
            return true;
        }
        System.debug('=====5.=====');
        return false;
    }
    
    /**
     * Method to check whether Goal is met or not for automated boolean metric 
     * @return Metric__c
     * @return Metric_Tier_Relation__c
     * @return achieve
     */
    public static void automatedBooleanGoalCheck(Metric__c m,Metric_Tier_Relation__c mtr,Boolean achieve){
        m.Boolean_Achievement__c = achieve;
        m.Goal_Met__c=achieve;
    }
    
    /**
     * Method to check whether Goal is met or not for automated metric(returning percentage)
     * @return Metric__c
     * @return Metric_Tier_Relation__c
     * @return achievement
     */
    public static void automatedDoubleGoalCheck(Metric__c m,Metric_Tier_Relation__c mtr,Double achieve){
        System.debug('===hemant==='+m);
        System.debug('======'+mtr);
        m.Achievement_Value__c = achieve;
        Double min = mtr.Metric_Min_Value__c;
        Double max = mtr.Metric_Max_Value__c;
        if(mtr.isRSMView__c){
            min = m.Metric_Min_Value__c;
            max = m.Metric_Max_Value__c;
        }        
        Boolean goalMet = PerformanceAchievementComm.checkGoalMet(min, max, achieve);
        System.debug('====hemant metric:'+m+'===goalMet:'+goalMet);
        m.Goal_Met__c = goalMet;
    }
}