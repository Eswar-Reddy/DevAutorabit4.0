/*** Created by: Accenture
* Date : 1/24/2010 
* Purpose: This Controller contains the calculation for all the Automated metric for Performance Evaluation tab and Incentive tab.
* Modified By :   hemant garg(Appirio offshore)
* Modified Date : Nov 24, 2010
* Purpose       : Changes in metric formulas According to SunRise 2b NA RVAR changes
**/
//Case 00096123 - Replaced ''+EvalDate.year() with new method getCurrentYear(performancePeriod)
public class PerformanceAchievementClass{
    
    public PerformanceAchievementClass(){
    } 
    
    public static Date EvalDate = Date.Today();
    // Done for case # 00063380
    public static final String REGEX_DECIMAL = '[0-9]+|[0-9]+\\.[0-9]+';
    
    public  static void updatePrevEvalDate(Date evDate){
        EvalDate = evDate;
    }
    //for case # 00052350
    public static Double computeCSATSCORE(Id accountId, Date validFrom,Date validTo, Performance_Metric__c currentPM){
        System.debug('=============1=================' + validTo);
        
        System.debug('========================1validFrom=================' + validFrom);
        Performance_Metric__c prevPeriod = findPreviousPeriod(currentPM); 
        if(prevPeriod  != null){
            validFrom = prevPeriod.Performance_Period_Start_Date__c;        
        }
        List<Customer_Survey_Result__c> surveyResult = [select Aggregate_Score_New__c  from Customer_Survey_Result__c where Partner_Account__c =: accountId and Survey_Response_Date__c >= :validFrom and Survey_Response_Date__c <= :validTo];
        Double score=0;
        Integer count=0;
        for(Customer_Survey_Result__c csat:surveyResult){
            if(csat.Aggregate_Score_New__c!= null){
                score=score+csat.Aggregate_Score_New__c;
                count++;    
            }
        }        
        System.debug('========================2=================' + score);        
        if(score>0){
            Double a = (score/count).round();
            return a;
        }
        return score; 
    }
    //for case # 00052350
    public static Double computeCSATSCORE(Id accountId, Date validFrom,Date validTo){
        System.debug('=============1=================' + validTo);
        
        List<Customer_Survey_Result__c> surveyResult = [select Aggregate_Score_New__c  from Customer_Survey_Result__c where Partner_Account__c =: accountId and Survey_Response_Date__c >= :validFrom and Survey_Response_Date__c <= :validTo];
        Double score=0;
        Integer count=0;
        for(Customer_Survey_Result__c csat:surveyResult){
            if(csat.Aggregate_Score_New__c!= null){
                score=score+csat.Aggregate_Score_New__c;
                count++;    
            }
        }        
        System.debug('========================2=================' + score);        
        if(score>0){
            Double a = (score/count).round();
            return a;
        }
        return score; 
    }
    
    //code written as part of Phase2a on 3/5/10
    public static Boolean checkCSATCount(Id accountId,Date validFrom,Date validTo,Double thershold){
         List<Customer_Survey_Result__c> surveyResult = [select Aggregate_Score_New__c  from Customer_Survey_Result__c where Partner_Account__c =: accountId and Survey_Response_Date__c >= :validFrom and Survey_Response_Date__c <= :validTo and Account1__r.recordtype.name='Residential Customer'];
         Double count = 0;
         count = surveyResult.size();
         if(count >= thershold){
            return true;    
         }else {
            return false;
         }
         
    }
    //for case # 00052350
    //code written as part of Phase2a for CSAT Survey Requirement 11May
    public static Double computeCSATSURVEYREQ(Id accountId, Date validFrom,Date validTo, Performance_Metric__c currentPM ){     
        System.debug('========================1validFrom=================' + validFrom);
        Performance_Metric__c prevPeriod = findPreviousPeriod(currentPM); 
        if(prevPeriod  != null){
            validFrom = prevPeriod.Performance_Period_Start_Date__c;        
        }
        
        List<Customer_Survey_Result__c> surveyResult = [select Aggregate_Score_New__c  from Customer_Survey_Result__c where Partner_Account__c =: accountId and Survey_Response_Date__c >= :validFrom and Survey_Response_Date__c <= :validTo]; 
        return surveyResult.size();
    }
    //for case # 00052350
    //code written as part of Phase2a for CSAT Survey Requirement 11May
    public static Double computeCSATSURVEYREQ(Id accountId, Date validFrom,Date validTo){       
        List<Customer_Survey_Result__c> surveyResult = [select Aggregate_Score_New__c  from Customer_Survey_Result__c where Partner_Account__c =: accountId and Survey_Response_Date__c >= :validFrom and Survey_Response_Date__c <= :validTo]; 
        return surveyResult.size();
    }
    
    public static Boolean checkGoalMet(Double minGoal,Double maxGoal,Double achieve)
    {
        if(minGoal!=null && maxGoal!=null && (achieve>=minGoal && achieve<=maxGoal))
        {
            return true;
        }
        else if(minGoal!=null && maxGoal!=null && (achieve<minGoal || achieve>maxGoal))
        {
            return false;
        }
        else if(minGoal!=null && achieve>=minGoal)
        {
            return true;
        }
        else if(maxGoal!=null && achieve<=maxGoal)
        {
            return true;
        }
        return false;
    }
    
    //code changed for Phase2a
    /*
    public static Double coumputeSITEINSPECTION(Id accountId, Date validFrom,Date validTo){     
        List<Case> caseList=[select Id from Case Where (Partner_Name__c=:accountId OR Partner_Account__c=:accountId) and Type=:'Inspection'];
        List<Id> caseIds=new List<Id>();
        if(caseList.size()>0){
            for(Case c : caseList){
                caseIds.add(c.Id);
            }
            List<Inspection__c> inspection = [select score__c ,Score_Details__c,Inspection_Date__c from Inspection__c where Case__c in :caseIds and Inspection_Date__c >= :validFrom and Inspection_Date__c <= :validTo and (Score_Details__c='YES'OR Score_Details__c='PASS' )]; // PASS                       
            if(inspection.size()>0)
            return inspection.size(); 
            else
            return 0;      
        }    
        return 0;
    }
    */
    /*Updated By Hemant for NA, for NA it will be boolean*/
    public static Boolean coumputeSITEINSPECTION(Id accountId, Date validFrom,Date validTo){        
        Integer totalInspections = 0;
        Integer inspectionsPassed = 0;
        List<Case> caseList = [select Id from Case Where (Partner_Name__c=:accountId OR Partner_Account__c=:accountId) and Type=:'Inspection'];
        List<Id> caseIds = new List<Id>();
        if(caseList.size() > 0){
            
            for(Case c : caseList){
                caseIds.add(c.Id);
            }
            
            System.debug('=====caseIds===='+caseIds);           
            List<Inspection__c> inspection = [select score__c ,Residential_Result__c,Score_Details__c,Inspection_Date__c from Inspection__c where Case__c in :caseIds and Inspection_Date__c >= :validFrom and Inspection_Date__c <= :validTo and Site_Type__c = 'Residential']; // PASS
            System.debug('=====inspection===='+inspection);
            if(inspection != null)
                totalInspections = inspection.size();
          
            for(Inspection__c i:inspection){
                if((i.Score_Details__c != null && i.Score_Details__c.contains('PASS')) || (i.Residential_Result__c != null && i.Residential_Result__c.contains('PASS'))){               
                    inspectionsPassed++;
                }
            }
        }    
        
        return (totalInspections == inspectionsPassed);
    }
    
    public static Double coumputeSITEINSPECTIONEUSTAY(Id accountId, Date validFrom,Date validTo){       
        Set<Id> euAccId = new Set<Id>();
        List<Opportunity> oppAccList = [Select AccountId From Opportunity where PartnerAccountId =:accountID];
        for(Opportunity o : oppAccList){
            euAccId.add(o.AccountId);
        }
        List<Case> caseList=[select Id from Case Where AccountId IN:euAccId  and Type=:'Inspection']; // Changed (Partner_Name__c=:accountId OR Partner_Account__c=:accountId) to AccountId IN:euAccId
        List<Id> caseIds=new List<Id>();
        if(caseList.size()>0){
            for(Case c : caseList){
                caseIds.add(c.Id);
            }
            List<Inspection__c> inspection = [select score__c ,Score_Details__c,Inspection_Date__c from Inspection__c where Case__c in :caseIds and Inspection_Date__c >= :validFrom and Inspection_Date__c <= :validTo and (Score_Details__c='YES'OR Score_Details__c='PASS' )]; // PASS           
            
            if(inspection.size()>0)
            return inspection.size(); 
            else
            return 0;     
        }    
        return 0;
    }
    
    //code for Phase2a
    public static Double coumputeSITEINSPECTIONEU(Id accountId, Date validFrom,Date validTo,Id tId){
        Tier__c tName = new Tier__c();
        tName = [Select Tier_Name__c FROM Tier__c where Id =:tId];
        Set<Id> euAccId = new Set<Id>();
          
        List<Opportunity> oppAccList = [Select AccountId From Opportunity where PartnerAccountId =:accountID];
        for(Opportunity o : oppAccList){
            euAccId.add(o.AccountId);
        }
        List<Case> caseList=[select Id from Case Where AccountId IN:euAccId  and Type=:'Inspection']; // Changed (Partner_Name__c=:accountId OR Partner_Account__c=:accountId) to AccountId IN:euAccId
        List<Id> caseIds=new List<Id>();
        if(caseList.size()>0) 
        {
            for(Case c : caseList){
                caseIds.add(c.Id);
            }
            List<Inspection__c> inspection = new List<Inspection__c>();
            List<Inspection__c> inspectionList = new List<Inspection__c>();
            Set<Id> inspId = new Set<id>();
            if(tName.Tier_Name__c.equals('Authorized')){
                 inspection = [select Id,score__c ,Score_Details__c,Inspection_Date__c from Inspection__c where Case__c in :caseIds and Inspection_Date__c >= :validFrom and Inspection_Date__c <= :validTo  ORDER by Inspection_Date__c asc LIMIT 5]; //PASS   //and (Score_Details__c='YES'OR Score_Details__c='PASS')                
                 for(Inspection__c i:inspection){
                    inspId.add(i.Id);
                 }
                 inspectionList = [select Id,score__c ,Score_Details__c from Inspection__c where Id IN:inspId and (Score_Details__c='YES'OR Score_Details__c='PASS') ];           
            }else if(tName.Tier_Name__c.equals('Premier')){
                 inspection = [select Id,score__c ,Score_Details__c,Inspection_Date__c from Inspection__c where Case__c in :caseIds and Inspection_Date__c >= :validFrom and Inspection_Date__c <= :validTo  ORDER by Inspection_Date__c desc LIMIT 5]; //PASS  and (Score_Details__c='YES'OR Score_Details__c='PASS')                
                 for(Inspection__c i:inspection){
                    inspId.add(i.Id);
                 }
                 inspectionList = [select Id,score__c ,Score_Details__c from Inspection__c where Id IN:inspId and (Score_Details__c='YES'OR Score_Details__c='PASS') ];              
            }else if(tName.Tier_Name__c.equals('SRI')){
                 inspection = [select Id,score__c ,Score_Details__c,Inspection_Date__c from Inspection__c where Case__c in :caseIds and Inspection_Date__c >= :validFrom and Inspection_Date__c <= :validTo ORDER by Inspection_Date__c asc LIMIT 1]; //PASS and (Score_Details__c='YES'OR Score_Details__c='PASS')                 
                 for(Inspection__c i:inspection){
                    inspId.add(i.Id);
                 }
                 inspectionList = [select Id,score__c ,Score_Details__c from Inspection__c where Id IN:inspId and (Score_Details__c='YES'OR Score_Details__c='PASS') ];             
            }
            
            
            if(inspection.size()>0)
                return inspectionList.size(); 
            else
                return 0;
            
        }    
        return 0;
    }
    
    public static Double coumputeSITEINSPECTIONNONCOMP(Id accountId, Date validFrom,Date validTo){
        List<Case> caseList=[select Id from Case where (Partner_Name__c=:accountId  OR Partner_Account__c=:accountId) and Type=:'Inspection'];
        if(caseList.size()>0)
        {
            List<Inspection__c> inspection = [select score__c ,Score_Details__c from Inspection__c where Case__c=:caseList.get(0).Id and Inspection_Date__c > :validFrom and Inspection_Date__c < :validTo];
            if(inspection.size()>0)
            {
                String nonComp= inspection.get(0).Score_Details__c;
            }
        }
        return 0;
    }
    
    public static Double coumputeCUSTOMERCOMPLAINTS(Id accountId, Date validFrom,Date validTo){
       // Added filter for Complaint_Towards__c as dealer.
       Datetime vFrom = datetime.newInstance(validFrom.year(), validFrom.month(),validFrom.day());
       Datetime vTo = datetime.newInstance(validTo.year(), validTo.month(),validTo.day());
       List<Case> caseList=[select Id from Case where (Partner_Name__c=:accountId  OR Partner_Account__c=:accountId) and Type=:'Customer Complaint' and Complaint_Towards__c='Dealer' and CreatedDate >= :vFrom and CreatedDate <= :vTo]; // and CreatedDate > :vFrom and CreatedDate < :vTo
       return caseList.size();
    }
       // method changed for Phase2a - No of rows in oracle changed.
    public static Double computePERCENTINSTALLCRM(Id accountID,Date validFrom,Date validTo){
        List<Opportunity> oppObj = [select StageName from Opportunity where StageName='100% - Won' and Closed_Won_Date__c >= :validFrom and Closed_Won_Date__c <= :validTo and  Account.Id=:accountId];
        Integer numOfClosedOpp=oppObj.size();        
        String currentQuarter = getCurrentQuarter();
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
        String year=getCurrentYear(performancePeriod);
        List<order_detail_sunrise2__c> orderDetail = [select Number_of_QTD_Residential_PV_Order__c,oracle_account_number__r.Num_Open_Opportunities__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and Year__c=:year];// Changed Quarter__c in : quarters to =:currentQuarter and Quarter__c =:currentQuarter to performance period
        if(orderDetail.size() > 0)
        {
            Double qtdPVOrder=0;
            //Modified by Neeraj as per chandra's email [14-Jan-2011] to include both quarters
            for(order_detail_sunrise2__c ord : orderDetail){
                if(ord.Number_of_QTD_Residential_PV_Order__c!=null)
                qtdPVOrder += ord.Number_of_QTD_Residential_PV_Order__c; //qtdPVOrder+
            }
            if(qtdPVOrder!=0)
            return (numOfClosedOpp/qtdPVOrder); 
            else
            return 0;
        }
        else
        return 0;
    }
   
    
    //code added for Sunrise phase2a  for Warranty Cards
    public static Double computeWARRANTYCARDSNA(Id accountID,Date validFrom,Date validTo){
        /*Commented by hemant Sunrise2b*/
        /*
        Set<Id> euAccId = new Set<Id>();
        Double sumPVOrder=0;
        //Account accnt =[Select a.Id, (Select AccountId From Opportunities__r) from Account a where a.Id =:accountID];
        List<Opportunity> oppAccList = [Select AccountId From Opportunity where PartnerAccountId =:accountID];
        for(Opportunity o : oppAccList){
            euAccId.add(o.AccountId);
        }
        //List<Asset> assetObj = [select Name from Asset where AccountId IN :euAccId and Name like 'SPR%']; //=:accountID
        //Double assetCount = assetObj.size();
        Double assetCount = 0;
        //code change 28th 
        //Integer i = [Select Count() from Asset where AccountId IN :euAccId and Name like 'SPR%' limit 10000];
        for(List<Asset> assetObj: [select Name from Asset where AccountId IN :euAccId and Name like 'SPR%'and (CreatedDate  > :validFrom and CreatedDate  < :validTo) limit 3000]){
            system.debug('array5--'+assetObj.size());
            assetCount = assetCount + assetObj.size();
        }
        system.debug('Array34--'+assetCount);
        //assetCount = i;// double.valueOf(i);
        
        String year=getCurrentYear(performancePeriod);
        String currentQuarter = getCurrentQuarter();
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
        List<order_detail_sunrise2__c> orderDetail = [select Number_of_QTD_Commercial_PV_Order__c, Number_of_QTD_Residential_PV_Order__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod  and Year__c=:year]; //Quarter__c =:currentQuarter to performance period Cumulative_No_of_Residential_PV_orders__c,Cumulative_No_of_Commercial_PV_orders__c
        if(orderDetail.size() > 0){
            if(orderDetail.get(0).Number_of_QTD_Commercial_PV_Order__c!=null && orderDetail.get(0).Number_of_QTD_Residential_PV_Order__c!=null){
                sumPVOrder = orderDetail.get(0).Number_of_QTD_Commercial_PV_Order__c + orderDetail.get(0).Number_of_QTD_Residential_PV_Order__c; 
            }
        }
        if(sumPVOrder!=0)
            return(assetCount/sumPVOrder)*100;// multiply 100;            
        else    
            return 0;
        */
        /*New Metric for RVAR-NA */
        Set<Id> naAccId = new Set<Id>();
        Double kwShipped = 0;   
        Double assetCount = 0;
        List<Opportunity> oppAccList = [Select AccountId From Opportunity where PartnerAccountId =:accountID];
        for(Opportunity o : oppAccList){
            naAccId.add(o.AccountId);
        }       
        for(List<Asset> assetObj: [select Name from Asset where AccountId IN :naAccId and Item__r.Item_Category_1__c like '%MODULE'and (CreatedDate  > :validFrom and CreatedDate  < :validTo) limit 3000]){
            assetCount = assetCount + assetObj.size();
        }
                
        String currentQuarter = getCurrentQuarter();
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
        String year = getCurrentYear(performancePeriod);
        for(order_detail_sunrise2__c ord : [select QTD_kW_for_Residential_Orders__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod  and Year__c=:year]){
            if(ord.QTD_kW_for_Residential_Orders__c != null){
                kwShipped = kwShipped + ord.QTD_kW_for_Residential_Orders__c;
            }
        }
        
        if(kwShipped != 0)
            return(assetCount/kwShipped)*100;           
        else    
            return 0;
    }
    
    //code added for Sunrise phase2a for Warranty Cards Europe
    public static Double computeWARRANTYCARDSEU(Id accountID,Date validFrom,Date validTo , Performance_Metric__c currentPM){
       
        /*Commented by hemant*/
        /*
        Set<Id> euAccId = new Set<Id>();
        Double sumPVOrder=0;
        Double totWatt = 0;
        Account accnt =[Select a.Id, (Select AccountId From Opportunities__r) from Account a where a.Id =:accountID];
        List<Opportunity> oppAccList = accnt.Opportunities__r;
        for(Opportunity o : oppAccList){
            euAccId.add(o.AccountId);
        }
        List<Asset> assetObj = [select Name,Quantity from Asset where AccountId IN:euAccId and Name like 'SPR%' and (CreatedDate  > :validFrom and CreatedDate  < :validTo)];//=:accountID
        for(Asset a:assetObj){
            String[] b = new List<String>();
            Double wattage=0;
            Integer res = 0;
            String wattStr = '';
            String aName = a.Name;
            String[] str = aName.split('-', 2);
            //Integer res = aName.indexOf('-',4);
            for(Integer i =0;i<str[1].length();i++){
                String s = str[1];
                b.add(s.substring(i,i+1));      
            }
            Integer num = inverterValue(b);
            if(num!=0){
                res = 4+num;
                wattStr = aName.substring(4,res);
            }else{
                wattStr = '0';  // new code
            }
            Double wattInt = double.valueOf(wattStr);
            if(a.Quantity != null){
                wattage = wattInt*a.Quantity;   
            }   
            
            totWatt = totWatt + wattage;
        }
        Double kWatt = totWatt/1000;
        String year=getCurrentYear(performancePeriod);
        String currentQuarter = getCurrentQuarter();
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
        List<order_detail_sunrise2__c> orderDetail = [select QTD_kW_for_Commercial_Orders__c, QTD_kW_for_Residential_Orders__c,Cumulative_kW_for_Commercial_Orders__c, Cumulative_kW_for_Residential_Orders__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod  and Year__c=:year];//Quarter__c =:currentQuarter to performance period  Cumulative_No_of_Residential_PV_orders__c,Cumulative_No_of_Commercial_PV_orders__c
        if(orderDetail.size() > 0){
            if(orderDetail.get(0).Cumulative_kW_for_Commercial_Orders__c!=null && orderDetail.get(0).Cumulative_kW_for_Residential_Orders__c!=null){
                sumPVOrder = orderDetail.get(0).Cumulative_kW_for_Commercial_Orders__c + orderDetail.get(0).Cumulative_kW_for_Residential_Orders__c; 
            }
        }
        if(sumPVOrder!=0)
            return (kWatt/sumPVOrder)*100; // multiply 100
        else
            return 0;   
        */
        System.debug('========EvalDate========'+EvalDate);        
        String currentQuarter = getCurrentQuarter();
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
        String year = getCurrentYear(performancePeriod);
        System.debug('========currentQuarter========'+currentQuarter);
        System.debug('========performancePeriod========'+performancePeriod);
        /*EXCEPTION FOR H2 2010*/
        if(validFrom.year() == 2010 && performancePeriod == 'P2'){
            System.debug('=============In Exception==============');
            return computeWARRANTYCARDSEU_Exception2010(accountID, validFrom, validTo);
        }
        
        // Done for case # 00064909 (Also including the previous performance period data)
        Performance_Metric__c previousPM = findPreviousPeriod(currentPM);
        if(previousPM != null)
            validFrom = previousPM.Performance_Period_Start_Date__c;
        Set<Id> euAccId = new Set<Id>();
        Double sumPVOrder = 0;
        Double totWatt = 0;
        Date startDate = Date.newInstance(validFrom.Year(), 1, 1);
        // List<Opportunity> oppAccList = [Select AccountId From Opportunity where PartnerAccountId =:accountID and (Installation_Date__c  > :startDate and Installation_Date__c  < :validTo)];
        List<Opportunity> oppAccList = [Select AccountId From Opportunity where PartnerAccountId =:accountID and  ((Installation_Date__c  > :validFrom and Installation_Date__c  < :validTo) OR (Delivery_Date__c  > :validFrom and Delivery_Date__c  < :validTo) ) AND (StageName = 'Installation Completed')];
        for(Opportunity o : oppAccList){
            euAccId.add(o.AccountId);
        }
          System.debug('===============1===============' + euAccId);
          System.debug('========validFrom======' + validFrom+'=========validTo========='+validTo);
        for(Asset ass : [select Name, Quantity, Item__r.Item_Category_1__c, Item__r.Item_Category_3__c  from Asset where AccountId IN:euAccId and Item__r.Item_Category_1__c like '%MODULE']){// and (CreatedDate  > :startDate and CreatedDate  < :validTo)]){
            // Done for case # 00063380
            //if(ass.Item__r.Item_Category_3__c != null && ass.Quantity != null){
            if(ass.Item__r.Item_Category_3__c != null && ass.Quantity != null && Pattern.matches(REGEX_DECIMAL,ass.Item__r.Item_Category_3__c)){
                totWatt = totWatt + double.valueOf(ass.Item__r.Item_Category_3__c) * ass.Quantity;
            }
        }
        // Done for case # 00064455
        // Double kWatt = totWatt;///1000;       
        Double kWatt = totWatt/1000;
          System.debug('===============2===============' + kWatt);     
        /* for(order_detail_sunrise2__c ord : [select QTD_kW_for_Commercial_Orders__c, QTD_kW_for_Residential_Orders__c,Cumulative_kW_for_Commercial_Orders__c, Cumulative_kW_for_Residential_Orders__c from order_detail_sunrise2__c where Account_Name__c=:accountID  and Year__c=:year]){
            if(ord.Cumulative_kW_for_Residential_Orders__c != null){
                sumPVOrder = sumPVOrder + ord.Cumulative_kW_for_Residential_Orders__c; 
            }
        }*/
        // Done for case # 00064909 (Also including the previous performance period data)
        String prevPeriodYear = '' + validFrom.Year();
        String prevPeriodQuarter = 'Q' + getQuarterByDate(validFrom); 
        String prevPerformancePeriod = getCurrentPerformancePeriod(prevPeriodQuarter);
        System.debug('======performancePeriod======='+performancePeriod+'=======year=========='+year+'=======prevPerformancePeriod========='+prevPerformancePeriod+'=======prevPeriodYear========'+prevPeriodYear);
        for(order_detail_sunrise2__c ord : [select QTD_kW_for_Commercial_Orders__c, QTD_kW_for_Residential_Orders__c,Cumulative_kW_for_Commercial_Orders__c, Cumulative_kW_for_Residential_Orders__c, Quarter__c from order_detail_sunrise2__c where Account_Name__c=:accountID and  
                                                ((Performance_Period__c =:performancePeriod and Year__c=:year) or (Performance_Period__c =:prevPerformancePeriod and Year__c=:prevPeriodYear) )]){
            // Done for Case # 00068655
            /*if(ord.Cumulative_kW_for_Residential_Orders__c != null){
                sumPVOrder = sumPVOrder + ord.Cumulative_kW_for_Residential_Orders__c; 
            }
            if(ord.Cumulative_kW_for_Commercial_Orders__c != null){
                sumPVOrder = sumPVOrder + ord.Cumulative_kW_for_Commercial_Orders__c; 
            }*/
            //Start 95738
            if(performancePeriod=='P2' && year=='2011' && ord.Quarter__c=='Q4'){
			    continue;
			}
            //End 95738
            if(ord.QTD_kW_for_Residential_Orders__c != null){
                sumPVOrder = sumPVOrder + ord.QTD_kW_for_Residential_Orders__c; 
            }
            if(ord.QTD_kW_for_Commercial_Orders__c != null){
                sumPVOrder = sumPVOrder + ord.QTD_kW_for_Commercial_Orders__c; 
            }
        }
        System.debug('===============3===============' + sumPVOrder);
        if(sumPVOrder!=0)
            return (kWatt/sumPVOrder)*100;
        else
            return 0;     
    }
    
    /*EXCEPTION FOR H2 2010*/
    public static Double computeWARRANTYCARDSEU_Exception2010(Id accountID,Date validFrom,Date validTo){
        //Dates are hardcoded in this function as it is exception for P2 of year 2010.
        Set<Id> euAccId = new Set<Id>();
        Double sumPVOrder = 0;
        Double totWatt = 0;
        Date startDate = Date.newInstance(2010, 7, 1);
        Date endDate = Date.newInstance(2010, 11, 30);
        List<Opportunity> oppAccList = [Select AccountId From Opportunity where PartnerAccountId =:accountID and (Installation_Date__c  > :startDate and Installation_Date__c  < :validTo)];
        for(Opportunity o : oppAccList){
            euAccId.add(o.AccountId);
        }
        System.debug('===============Start Date===============' + startdate);
        System.debug('===============End Date===============' + enddate);
        System.debug('===============1===============' + euAccId);
        for(Asset ass : [select Name, Quantity, Item__r.Item_Category_1__c, Item__r.Item_Category_3__c  from Asset where AccountId IN:euAccId and Item__r.Item_Category_1__c like '%MODULE']){// and (CreatedDate  > :startDate and CreatedDate  < :endDate)]){
            System.debug('=AssetID='+ass.id);
            // Done for case # 00063380
            //if(ass.Item__r.Item_Category_3__c != null && ass.Quantity != null){
            if(ass.Item__r.Item_Category_3__c != null && ass.Quantity != null && Pattern.matches(REGEX_DECIMAL,ass.Item__r.Item_Category_3__c) ){
                totWatt = totWatt + double.valueOf(ass.Item__r.Item_Category_3__c) * ass.Quantity;
            }
        }
        // Done for case # 00064455
        // Double kWatt = totWatt;///1000;       
        Double kWatt = totWatt/1000;
        System.debug('===============2===============' + kWatt);            
        String currentQuarter = getCurrentQuarter();
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
        String year = getCurrentYear(performancePeriod);
        //Only for Q3 of 2010
        List<order_detail_sunrise2__c> orderDetail = [select QTD_kW_for_Commercial_Orders__c, QTD_kW_for_Residential_Orders__c,Cumulative_kW_for_Commercial_Orders__c, Cumulative_kW_for_Residential_Orders__c from order_detail_sunrise2__c where Account_Name__c=:accountID  and Year__c = '2010' and Quarter__c='Q3'];//Quarter__c =:currentQuarter to performance period  Cumulative_No_of_Residential_PV_orders__c,Cumulative_No_of_Commercial_PV_orders__c
        if(orderDetail.size() > 0){
            if(orderDetail.get(0).Cumulative_kW_for_Commercial_Orders__c!=null && orderDetail.get(0).Cumulative_kW_for_Residential_Orders__c!=null){
                sumPVOrder = orderDetail.get(0).Cumulative_kW_for_Commercial_Orders__c + orderDetail.get(0).Cumulative_kW_for_Residential_Orders__c; 
            }
        }
         System.debug('===============3===============' + sumPVOrder);
        if(sumPVOrder!=0)
            return (kWatt/sumPVOrder)*100;
        else
            return 0;     
    } 
    
    public static Double computeTRAININGASSDESIGN(Id accountId){
        //adding a condition to check the certified as true
        //List<Certification__c> certification = [select Attended_ILC__c from Certification__c where Curriculum_Role__c in (:'Design') and Curriculum_Level__c in (:'Associate') and Account__c =:accountId and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE]; // terminated condition is added in Phase2a on 4th June
        //Added by Neeraj
        List<Certification__c> certification = [select Attended_ILC__c from Certification__c where Curriculum_Role__c in (:'Design') and Curriculum_Level__c in (:'Associate') and Account__c =:accountId and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE and Business__c in (null,'RESIDENTIAL')]; // terminated condition is added in Phase2a on 4th June
     
     
        return certification.size();
    }
    public static Double computeTRAININGASSINSTALL(Id accountId){
        //adding a condition to check the certified as true
        //List<Certification__c> certification = [select Attended_ILC__c from Certification__c where Curriculum_Role__c in (:'Install') and Curriculum_Level__c in (:'Associate') and Account__c =:accountId and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE]; // terminated condition is added in Phase2a on 4th June];
        //Added by Neeraj
        List<Certification__c> certification = [select Attended_ILC__c from Certification__c where Curriculum_Role__c in (:'Install') and Curriculum_Level__c in (:'Associate') and Account__c =:accountId and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE and Business__c in (null,'RESIDENTIAL')]; // terminated condition is added in Phase2a on 4th June];
        return certification.size();
    }
    public static Double computeTRAININGASSSALES(Id accountId){
        //adding a condition to check the certified as true
        //List<Certification__c> certification = [select Attended_ILC__c from Certification__c where Curriculum_Role__c in (:'Sales') and Curriculum_Level__c in (:'Associate') and Account__c =:accountId  and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE]; // terminated condition is added in Phase2a on 4th June];
        //Added by Neeraj
        List<Certification__c> certification = [select Attended_ILC__c from Certification__c where Curriculum_Role__c in (:'Sales') and Curriculum_Level__c in (:'Associate') and Account__c =:accountId  and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE and Business__c in (null,'RESIDENTIAL')]; // terminated condition is added in Phase2a on 4th June];
        return certification.size();
    }
    
    public static Double computeTRAININGADVDESIGN(Id accountId){
            //adding a condition to check the certified as true
        //List<Certification__c> certification = [select Id,Attended_ILC__c from Certification__c where Curriculum_Role__c in (:'Design') and Curriculum_Level__c in (:'Advanced','ADVANCE') and Account__c =:accountId and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE]; // terminated condition is added in Phase2a on 4th June];
        //Added by Neeraj
        List<Certification__c> certification = [select Id,Attended_ILC__c from Certification__c where Curriculum_Role__c in (:'Design') and Curriculum_Level__c in (:'Advanced','ADVANCE') and Account__c =:accountId and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE and Business__c in (null,'RESIDENTIAL')]; // terminated condition is added in Phase2a on 4th June];
        return certification.size();
    }
    public static Double computeTRAININGADVINSTALL(Id accountId){
     // adding a condition to check the certified as true
        //List<Certification__c> certification = [select Attended_ILC__c from Certification__c where Curriculum_Role__c in (:'Install') and Curriculum_Level__c in (:'Advanced','ADVANCE') and Account__c =:accountId and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE]; // terminated condition is added in Phase2a on 4th June];
        //Added by Neeraj
        List<Certification__c> certification = [select Attended_ILC__c from Certification__c where Curriculum_Role__c in (:'Install') and Curriculum_Level__c in (:'Advanced','ADVANCE') and Account__c =:accountId and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE and Business__c in (null,'RESIDENTIAL')]; // terminated condition is added in Phase2a on 4th June];
        return certification.size();
    }
    public static Double computeTRAININGADVSALES(Id accountId){
        //  adding a condition to check the certified as true
        //List<Certification__c> certification = [select Attended_ILC__c from Certification__c where Curriculum_Role__c in (:'Sales') and Curriculum_Level__c in (:'Advanced','ADVANCE') and Account__c =:accountId  and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE]; // terminated condition is added in Phase2a on 4th June];
        //Added by Neeraj
        List<Certification__c> certification = [select Attended_ILC__c from Certification__c where Curriculum_Role__c in (:'Sales') and Curriculum_Level__c in (:'Advanced','ADVANCE') and Account__c =:accountId  and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE and Business__c in (null,'RESIDENTIAL')]; // terminated condition is added in Phase2a on 4th June];
        return certification.size();
    }
    
    //Calculation for Bonus for extra Training
    public static Boolean computeTRAININGEXTRABONUS(Id accountId){
        Double designAdv=computeTRAININGADVDESIGN(accountId);
        Double installAdv=computeTRAININGADVINSTALL(accountId);
        Double salesAdv=computeTRAININGADVSALES(accountId);
        
        //List<Certification__c> advSalesWitoutCertCheck = [select Attended_ILC__c from Certification__c where Curriculum_Role__c in (:'Sales') and Curriculum_Level__c in (:'Advanced','ADVANCE') and Account__c =:accountId and PartnerContact__r.Terminated__c = FALSE]; // terminated condition is added in Phase2a on 4th June];
        List<Certification__c> advSalesWitoutCertCheck = [select Attended_ILC__c from Certification__c where Curriculum_Role__c in (:'Sales') and Curriculum_Level__c in (:'Advanced','ADVANCE') and Account__c =:accountId and PartnerContact__r.Terminated__c = FALSE and Business__c in (null,'RESIDENTIAL')]; // terminated condition is added in Phase2a on 4th June];
        Double salesWitoutCertCheck=advSalesWitoutCertCheck.size();
        if(salesWitoutCertCheck!=null && salesWitoutCertCheck!=0)
        {
            Double salesPersonelRatio=(salesAdv/salesWitoutCertCheck);
            if(designAdv>=2 && installAdv>=2 && salesPersonelRatio>=0.5)
            {
                return true;
            }
        }
        return false;
    }
    
    public static Double computeADVANCEPRODTRAINING(Id accountId){
    //  adding a condition to check the certified as true
        //List<Certification__c> certification = [select Attended_ILC__c from Certification__c where  Curriculum_Level__c in (:'Advanced','ADVANCE') and Account__c =:accountId  and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE ]; // terminated condition is added in Phase2a on 4th June];
        //Added by Neeraj
        List<Certification__c> certification = [select Attended_ILC__c from Certification__c where  Curriculum_Level__c in (:'Advanced','ADVANCE') and Account__c =:accountId  and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE and Business__c in (null,'RESIDENTIAL')]; // terminated condition is added in Phase2a on 4th June];
        return certification.size();
    }
    
    public static Double computeADVANCE_TRAINING_EU(Id accountId){
    // adding a condition to check the certified as true
        //List<Certification__c> certification = [select Attended_ILC__c from Certification__c where  Curriculum_Level__c in (:'Advanced','ADVANCE') and Account__c =:accountId and Curriculum_Role__c in (:'Install','Design') and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE]; // terminated condition is added in Phase2a on 4th June];
        //Added by Neeraj
        List<Certification__c> certification = [select Attended_ILC__c from Certification__c where  Curriculum_Level__c in (:'Advanced','ADVANCE') and Account__c =:accountId and Curriculum_Role__c in (:'Install','Design') and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE and Business__c in (null,'RESIDENTIAL')]; // terminated condition is added in Phase2a on 4th June];
        return certification.size();
    }
    
    public static Double computeBASICTRAINING(Id accountId){
        //  adding a condition to check the certified as true
        //List<Certification__c> certification = [select Attended_ILC__c from Certification__c where Curriculum_Level__c in (:'Associate') and Account__c =:accountId and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE]; // terminated condition is added in Phase2a on 4th June ];
        //Added by Neeraj
        List<Certification__c> certification = [select Attended_ILC__c from Certification__c where Curriculum_Level__c in (:'Associate') and Account__c =:accountId and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE and Business__c in (null,'RESIDENTIAL')]; // terminated condition is added in Phase2a on 4th June ];
        return certification.size();
    }
    
    public static Double computeBASICTRAININGEU(Id accountId){
    //  adding a condition to check the certified as true
        //List<Certification__c> certification = [select Attended_ILC__c from Certification__c where Curriculum_Level__c in (:'Associate') and Account__c =:accountId and Curriculum_Role__c in (:'Install','Design') and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE]; // terminated condition is added in Phase2a on 4th June];
        //Added by Neeraj
        List<Certification__c> certification = [select Attended_ILC__c from Certification__c where Curriculum_Level__c in (:'Associate') and Account__c =:accountId and Curriculum_Role__c in (:'Install','Design') and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE and Business__c in (null,'RESIDENTIAL')]; // terminated condition is added in Phase2a on 4th June];
        return certification.size();
    }
    
    // code added for Phase2a on 19Apr10 
    public static Double computeEXTRABONUSI(Id accountId){
    //  adding a condition to check the certified as true
        //List<Certification__c> certification = [select Attended_ILC__c from Certification__c where Curriculum_Level__c in (:'Advanced','ADVANCE') and Account__c =:accountId and Curriculum_Role__c in (:'Install','Design') and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE]; // terminated condition is added in Phase2a on 4th June];
        //Added by Neeraj
        List<Certification__c> certification = [select Attended_ILC__c from Certification__c where Curriculum_Level__c in (:'Advanced','ADVANCE') and Account__c =:accountId and Curriculum_Role__c in (:'Install','Design') and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE and Business__c in (null,'RESIDENTIAL')]; // terminated condition is added in Phase2a on 4th June];
        return certification.size();
    }
    
     // code added for Phase2a on 19Apr10 
    public static Double computeEXTRABONUSII(Id accountId){
        System.debug('====In===');
    //  adding a condition to check the certified as true
        /*
        Double salesAdv = computeTRAININGADVSALES(accountId);
        System.debug('============1.salesAdv======='+salesAdv);
        List<Contact> allSalewitoutCert = [select Id from Contact where Portal_User_Profile__c='Partner Sales' and AccountId =:accountId and Terminated__c = FALSE];                    
        System.debug('============1.allSalewitoutCert======='+allSalewitoutCert);
        Double allSales = allSalewitoutCert.size();
        if(allSales!=0){
            Double aggSales = (salesAdv/allSales) *100;
            //return aggSales;
        }else{
            //return 0;
        }
        */
        Map<Id, Contact> mapSalesPersons = new Map<Id, Contact>([select Id from Contact where Portal_User_Profile__c='Partner Sales' and AccountId =:accountId and Terminated__c = FALSE]);
        System.debug('============2.mapSalesPersons======='+mapSalesPersons);
        System.debug('============2.mapSalesPersons.size======='+mapSalesPersons.size());
        Map<Id, Certification__c> mapCert = new Map<Id, Certification__c>();
        for(Certification__c cert : [select PartnerContact__c, Attended_ILC__c from Certification__c where Curriculum_Role__c in (:'Sales') and Curriculum_Level__c in (:'Advanced','ADVANCE') and Account__c =:accountId  and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE and Business__c in (null,'RESIDENTIAL')]){
            if(mapSalesPersons.containsKey(cert.PartnerContact__c))
                mapCert.put(cert.PartnerContact__c, cert);
        }
        System.debug('============2.mapCert======='+mapCert);
        System.debug('============2.mapCert.size()======='+mapCert.size());
        Double allAttended = mapCert.size();
        Double allSalesPerson = mapSalesPersons.size();
        
        if(allSalesPerson != 0){
            Double result = (allAttended / allSalesPerson) * 100 ;
            return result;
        }else{
            return 0;
        }
    }
    
    //Calculation for Credit limit 
    public static Double computeCREDITLIMIT(Id accountId){
       Account accObj = [select Credit_Limit__c from Account where id =: accountId  ];
       if(accObj.Credit_Limit__c!=null)
       return accObj.Credit_Limit__c;
       else
       return 0;
    }
    // calculation for credit limit for EU
    public static Boolean computeCREDITLIMITEU(Id accountId){
       Account accObj = [select Credit_Limit__c,Bank_Guarantee__c from Account where id =: accountId  ];
       if((accObj.Credit_Limit__c!=null && accObj.Credit_Limit__c>=50000) || accObj.Bank_Guarantee__c==true)
       {
           return true;
       }    
       else
       return false;
    }
    
    //Code added for phase2a for Credit Limit for SRI on 11May
    public static Boolean computeCREDITLIMITSRI(Id accountId){
       Account accObj = [select Credit_Limit__c,Bank_Guarantee__c from Account where id =: accountId  ];
       if((accObj.Credit_Limit__c!=null && accObj.Credit_Limit__c>=30000) || accObj.Bank_Guarantee__c==true) {
           return true;
       }    
       else
       return false;
    }
    
    //code changed for phase2a
    public static Boolean computeSIXMONTHSASAUTHWITHTWENTYINSTALL( Id accountID){
        Account accObj=[select Authorized_Partner_Date__c from account where id=:accountId];        
        if(accObj.Authorized_Partner_Date__c!=null)
        {
            Date resdentialDate=accObj.Authorized_Partner_Date__c;
            Date todayDate=EvalDate;
            if(resdentialDate.monthsBetween(todayDate)>=6)
            {
                String currentQuarter = getCurrentQuarter();
                String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
                String year=getCurrentYear(performancePeriod);
                List<order_detail_sunrise2__c> orderDetail = [select Cumulative_No_of_Residential_PV_orders__c,Cumulative_No_of_Commercial_PV_orders__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and Year__c=:year]; //Quarter__c =:currentQuarter to performance period
                
                if(orderDetail.size() > 0)
                {
                    if(orderDetail.get(0).Cumulative_No_of_Residential_PV_orders__c!=null && orderDetail.get(0).Cumulative_No_of_Commercial_PV_orders__c!=null)
                    {
                        if((orderDetail.get(0).Cumulative_No_of_Residential_PV_orders__c + orderDetail.get(0).Cumulative_No_of_Commercial_PV_orders__c) >= 20){
                            return true;
                        }
                    }
                }
            }
        }
        return false;
    }  
    
    public static Boolean computeSIXMONTHSASAUTH( Id accountID){
        Account accObj=[select Authorized_Partner_Date__c from account where id=:accountId];        
        if(accObj.Authorized_Partner_Date__c!=null)
        {
            Date resdentialDate=accObj.Authorized_Partner_Date__c;
            Date todayDate=EvalDate;
            
            if(resdentialDate.monthsBetween(todayDate)>=6)
            {
                return true;
            }
        }
        return false;    
    }
    //Calculation for 20 Installs for Authorised
    public static Boolean computeTWENTYINSTALLSASAUTH( Id accountID){        
        String currentQuarter = getCurrentQuarter();
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
        String year=getCurrentYear(performancePeriod);
        List<order_detail_sunrise2__c> orderDetail = [select Cumulative_No_of_Residential_PV_orders__c,Cumulative_No_of_Commercial_PV_orders__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and Year__c=:year]; //Quarter__c =:currentQuarter to performance period
        if(orderDetail.size() > 0)
        {
           if(orderDetail.get(0).Cumulative_No_of_Residential_PV_orders__c!=null && orderDetail.get(0).Cumulative_No_of_Commercial_PV_orders__c!=null)
            {
               if((orderDetail.get(0).Cumulative_No_of_Residential_PV_orders__c + orderDetail.get(0).Cumulative_No_of_Commercial_PV_orders__c) >= 20){
                     return true;
               }
             }
        }
        return false;     
    }
    public static Boolean computeSIXMONTHSASPREM( Id accountID){
        Account accObj=[select Promoted_Premier_Date__c from account where id=:accountId];        
        if(accObj.Promoted_Premier_Date__c!=null)
        {
            Date resdentialDate=accObj.Promoted_Premier_Date__c;
            Date todayDate=EvalDate;
            if(resdentialDate.monthsBetween(todayDate)>=6)
            {
                return true;
            }
        } 
        return false; 
    }
    //Calculation for 100 installs
    public static Boolean computeHUNDREDINSTALLSASPREM( Id accountID){        
        String currentQuarter = getCurrentQuarter();
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
        String year=getCurrentYear(performancePeriod);
        List<order_detail_sunrise2__c> orderDetail = [select Cumulative_No_of_Residential_PV_orders__c,Cumulative_No_of_Commercial_PV_orders__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and Year__c=:year]; //Quarter__c =:currentQuarter to performance period
        if(orderDetail.size() > 0)
        {
           if(orderDetail.get(0).Cumulative_No_of_Residential_PV_orders__c!=null && orderDetail.get(0).Cumulative_No_of_Commercial_PV_orders__c!=null)
            {
               if((orderDetail.get(0).Cumulative_No_of_Residential_PV_orders__c + orderDetail.get(0).Cumulative_No_of_Commercial_PV_orders__c) >= 100){
                     return true;
               }
             }
        }
        return false;
    }   

    // Calculation for 20 installs
    public static Boolean computeTWENTYINSTALLSASAUTHORTWOHUNDREDKWS( Id accountID){        
        String currentQuarter = getCurrentQuarter();
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
        String year=getCurrentYear(performancePeriod);
        /*
        List<order_detail_sunrise2__c> orderDetail = [select Life_kW_for_Residential_Customer__c, Cumulative_kW_for_Commercial_Orders__c,Cumulative_kW_for_Residential_Orders__c,Cumulative_No_of_Residential_PV_orders__c,Cumulative_No_of_Commercial_PV_orders__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and Year__c=:year];//Quarter__c =:currentQuarter to performance period
        if(orderDetail.size() > 0)
        {
           if(orderDetail.get(0).Cumulative_No_of_Residential_PV_orders__c!=null && orderDetail.get(0).Cumulative_No_of_Commercial_PV_orders__c!=null)
            {
               if((orderDetail.get(0).Cumulative_No_of_Residential_PV_orders__c + orderDetail.get(0).Cumulative_No_of_Commercial_PV_orders__c) >= 20){
                     return true;
               }
            }
            //OR
            if(orderDetail.get(0).Cumulative_kW_for_Commercial_Orders__c!=null && orderDetail.get(0).Cumulative_kW_for_Residential_Orders__c!=null)
            {
                if((orderDetail.get(0).Cumulative_kW_for_Commercial_Orders__c + orderDetail.get(0).Cumulative_kW_for_Residential_Orders__c) >= 200){
                      return true;
                }
            }
        }
        */
        /*changed by hemant in this condition Life kw is needed to check*/
        // Done for case # 00064909
        /* List<order_detail_sunrise2__c> orderDetail = [select Life_kW_for_Residential_Customer__c, Cumulative_kW_for_Commercial_Orders__c,Cumulative_kW_for_Residential_Orders__c,Cumulative_No_of_Residential_PV_orders__c,Cumulative_No_of_Commercial_PV_orders__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and Year__c=:year order by Quarter__c desc];//Quarter__c =:currentQuarter to performance period
        if(orderDetail.size() > 0)
        {
           if(orderDetail.get(0).Cumulative_No_of_Residential_PV_orders__c != null )
            {
               if(orderDetail.get(0).Cumulative_No_of_Residential_PV_orders__c  >= 20){
                     return true;
               }
            }
            //OR
            if(orderDetail.get(0).Life_kW_for_Residential_Customer__c!=null )
            {
                if(orderDetail.get(0).Life_kW_for_Residential_Customer__c >= 200){
                      return true;
                }
            }
        }*/
        List<order_detail_sunrise2__c> orderDetail = [select Life_kW_for_Residential_Customer__c,Life_kW_for_Commercial_Customer__c, Cumulative_kW_for_Commercial_Orders__c,Cumulative_kW_for_Residential_Orders__c,Cumulative_No_of_Residential_PV_orders__c,Cumulative_No_of_Commercial_PV_orders__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and Year__c=:year order by Quarter__c desc];//Quarter__c =:currentQuarter to performance period
        if(orderDetail.size() > 0) {
            Double sumOfPVOrders = 0;
            Double sumOfLifeKW = 0; 
            if(orderDetail.get(0).Cumulative_No_of_Residential_PV_orders__c != null )
                sumOfPVOrders = orderDetail.get(0).Cumulative_No_of_Residential_PV_orders__c;
            if(orderDetail.get(0).Cumulative_No_of_Commercial_PV_orders__c != null )
                sumOfPVOrders += orderDetail.get(0).Cumulative_No_of_Commercial_PV_orders__c;
            if(sumOfPVOrders  >= 20)
                return true;

            if(orderDetail.get(0).Life_kW_for_Residential_Customer__c!=null )
                sumOfLifeKW = orderDetail.get(0).Life_kW_for_Residential_Customer__c;
            if(orderDetail.get(0).Life_kW_for_Commercial_Customer__c!=null )
                sumOfLifeKW += orderDetail.get(0).Life_kW_for_Commercial_Customer__c;
            if(sumOfLifeKW >= 200)
                return true;
        }
        return false;
    }   
    
    public static Boolean computeSIXMONTHSASAUTHWITHTWENTYINSTALLORTWOHUNDREDKWS( Id accountID){
        String currentQuarter = getCurrentQuarter();        
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
        String year=getCurrentYear(performancePeriod);
        List<order_detail_sunrise2__c> orderDetail = [select Cumulative_No_of_Residential_PV_orders__c,Cumulative_No_of_Commercial_PV_orders__c,Cumulative_kW_for_Commercial_Orders__c,Cumulative_kW_for_Residential_Orders__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and Year__c=:year]; //Quarter__c =:currentQuarter to performance period
        if(orderDetail.size() > 0)
        {
            Account accObj=[select Authorized_Partner_Date__c from account where id=:accountId];
            if(accObj.Authorized_Partner_Date__c!=null)
            {
                Date resdentialDate=accObj.Authorized_Partner_Date__c;
                Date todayDate=EvalDate;
                if(resdentialDate.monthsBetween(todayDate)>=6)
                {
                    if(orderDetail.get(0).Cumulative_No_of_Residential_PV_orders__c!=null && orderDetail.get(0).Cumulative_No_of_Commercial_PV_orders__c!=null)
                    {
                        if((orderDetail.get(0).Cumulative_No_of_Residential_PV_orders__c + orderDetail.get(0).Cumulative_No_of_Commercial_PV_orders__c) >= 20){
                            return true;
                        }
                    }
                    //OR
                    if(orderDetail.get(0).Cumulative_kW_for_Commercial_Orders__c!=null && orderDetail.get(0).Cumulative_kW_for_Residential_Orders__c!=null)
                    {
                        if((orderDetail.get(0).Cumulative_kW_for_Commercial_Orders__c + orderDetail.get(0).Cumulative_kW_for_Residential_Orders__c) >= 200){
                            return true;
                        }
                    }
                }
            }
        }
        return false;
    }
    
    /* hemant : Minimum sales and experience */
    public static Boolean Min_Sales_Experience_Autho_EU( Id accountID){
        Account accObj=[select  Residential_Installer_Date__c from account where id=:accountId];        
        if(accObj.Residential_Installer_Date__c!=null){
            Date resdentialDate=accObj.Residential_Installer_Date__c;
            Date todayDate=EvalDate;
            Integer resMonth=todayDate.month();
            Integer todayMonth=resdentialDate.month();
          
            String currentQuarter = getCurrentQuarter();
            String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
            String year=getCurrentYear(performancePeriod);
            if(resdentialDate.monthsBetween(todayDate) >= 3){
                List<order_detail_sunrise2__c> orderDetail = [select Life_kW_for_Residential_Customer__c, Cumulative_No_of_Residential_PV_orders__c,Cumulative_No_of_Commercial_PV_orders__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and Year__c=:year];
                if(orderDetail.size() > 0){
                    if(orderDetail.get(0).Cumulative_No_of_Residential_PV_orders__c != null && orderDetail.get(0).Cumulative_No_of_Commercial_PV_orders__c!=null){
                        if((orderDetail.get(0).Cumulative_No_of_Residential_PV_orders__c + orderDetail.get(0).Cumulative_No_of_Commercial_PV_orders__c) >= 8){
                            return true;
                        }
                    }
                }
            }          
        }
        return false;
    }
     /* hemant
     public static Boolean Min_Sales_Experience_Premier_EU( Id accountID){
        Account accObj=[select Authorized_Partner_Date__c from account where id=:accountId];
        String year=getCurrentYear(performancePeriod);
        if(accObj.Authorized_Partner_Date__c!=null){
            Date authorizedDate = accObj.Authorized_Partner_Date__c;
            Date todayDate=EvalDate;
            Integer resMonth=todayDate.month();
            Integer todayMonth=authorizedDate.month();
          
            String currentQuarter = getCurrentQuarter();
            String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
            if(resdentialDate.monthsBetween(todayDate) >= 3){
                List<order_detail_sunrise2__c> orderDetail = [select Life_kW_for_Residential_Customer__c, Cumulative_No_of_Residential_PV_orders__c,Cumulative_No_of_Commercial_PV_orders__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and Year__c=:year];
                if(orderDetail.size() > 0){
                    if(orderDetail.get(0).Cumulative_No_of_Residential_PV_orders__c != null && orderDetail.get(0).Cumulative_No_of_Commercial_PV_orders__c!=null){
                        if((orderDetail.get(0).Cumulative_No_of_Residential_PV_orders__c + orderDetail.get(0).Cumulative_No_of_Commercial_PV_orders__c) >= 8){
                            return true;
                        }
                    }
                }
            }          
        }
        return false;
    }*/
    
  public static Boolean computeMINSALESAUTHZEU( Id accountID){
        Account accObj=[select  Residential_Installer_Date__c from account where id=:accountId];        
        if(accObj.Residential_Installer_Date__c!=null)
        {
            Date resdentialDate=accObj.Residential_Installer_Date__c;
            Date todayDate=EvalDate;
            Integer resMonth=todayDate.month();
            Integer todayMonth=resdentialDate.month();
            
            if(resdentialDate.monthsBetween(todayDate)>=3)
            {
                System.debug('==============Inside >=3 ===========');
                String currentQuarter = getCurrentQuarter();
                String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
                String year=getCurrentYear(performancePeriod);
                
                List<order_detail_sunrise2__c> orderDetail = [select Cumulative_No_of_Residential_PV_orders__c,Cumulative_No_of_Commercial_PV_orders__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and Year__c=:year];//Quarter__c =:currentQuarter to performance period
                Decimal noOfOrders = 0;
                if(orderDetail.size() > 0)
                {
                    //Added by Neeraj as per fernando suggestion[25-January]
                    for(order_detail_sunrise2__c ord:orderDetail){
                        if(ord.Cumulative_No_of_Residential_PV_orders__c!=null && ord.Cumulative_No_of_Commercial_PV_orders__c!=null)
                        {
                            noOfOrders += (ord.Cumulative_No_of_Residential_PV_orders__c + ord.Cumulative_No_of_Commercial_PV_orders__c);
                            /*if((ord.Cumulative_No_of_Residential_PV_orders__c + ord.Cumulative_No_of_Commercial_PV_orders__c) >= 8){
                                return true;
                            }*/
                        }
                        
                    }
                    System.debug('===============noOfOrders======' + noOfOrders);
                    if(noOfOrders >=8){
                        return true;
                    }
                        
                    /*if(orderDetail.get(0).Cumulative_No_of_Residential_PV_orders__c!=null && orderDetail.get(0).Cumulative_No_of_Commercial_PV_orders__c!=null)
                    {
                        if((orderDetail.get(0).Cumulative_No_of_Residential_PV_orders__c + orderDetail.get(0).Cumulative_No_of_Commercial_PV_orders__c) >= 8){
                            return true;
                        }
                    }*/
                }
            }
       
        }
        return false;
    }
    //Created by neeraj
     public static Boolean computeBonusForMINSALESAUTHZEU( Id accountID){
            Account accObj=[select  Residential_Installer_Date__c from account where id=:accountId];            
            Boolean isBonus = null;
            if(accObj.Residential_Installer_Date__c!=null)
            {
                Date resdentialDate = accObj.Residential_Installer_Date__c;
                Date todayDate=EvalDate;
                Integer resMonth=todayDate.month();
                Integer todayMonth=resdentialDate.month();
            
                String currentQuarter = getCurrentQuarter();
                String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
                String year=getCurrentYear(performancePeriod);
                
                List<order_detail_sunrise2__c> orderDetail = [select Quarter__c,QTD_kW_for_Residential_Orders__c, Cumulative_No_of_Residential_PV_orders__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and Year__c=:year Order by Quarter__c];//Quarter__c =:currentQuarter to performance period
                for(order_detail_sunrise2__c ord : orderDetail){
                    //for first Quarter
                    if(ord.Quarter__c.equalsIgnoreCase('Q1')){
                        if(((ord.Cumulative_No_of_Residential_PV_orders__c!=null) && (ord.Cumulative_No_of_Residential_PV_orders__c  >= 1)) || (ord.QTD_kW_for_Residential_Orders__c!=null)&&(ord.QTD_kW_for_Residential_Orders__c >= 10)) 
                        {
                            IsBonus = true;   
                                 
                        }else{
                            IsBonus = false;    
                        }
                    }
                    else{//for rest quarters
                        if(((ord.Cumulative_No_of_Residential_PV_orders__c!=null) && (ord.Cumulative_No_of_Residential_PV_orders__c  >= 3)) || (ord.QTD_kW_for_Residential_Orders__c!=null)&&(ord.QTD_kW_for_Residential_Orders__c >= 30)) 
                        {
                                if(isBonus == null)
                                    IsBonus = true;
                                else
                                    IsBonus = IsBonus && true;
                        }
                    }
                }
            }
            if(IsBonus==null)
                return false;
            return isBonus;
    }
    
    // method changed for Phase2a - No of rows in oracle changed. 
    // updated by hemant : identified that it is only for NA
    public static Boolean computeACTIVEDEALER(Id accountId,Date validFrom,Date validTo){
        String currentQuarter = getCurrentQuarter();
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
        String year=getCurrentYear(performancePeriod);
        List<order_detail_sunrise2__c> orderDetail = [select Number_of_QTD_Residential_PV_Order__c,Number_of_QTD_Commercial_PV_Order__c,QTD_kW_for_Residential_Orders__c,QTD_kW_for_Commercial_Orders__c,Cumulative_kW_for_Commercial_Orders__c,Cumulative_kW_for_Residential_Orders__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod  and Year__c=:year];// Changed Quarter__c in : quarters to =:currentQuarter and Quarter__c =:currentQuarter to performance period
        if(orderDetail!=null && orderDetail.size() > 0)
        {
            Double qtdResPv=0;
            Double qtdKw=0;
           
                if(orderDetail.get(0).Number_of_QTD_Residential_PV_Order__c!=null && orderDetail.get(0).Number_of_QTD_Commercial_PV_Order__c!=null)
                    qtdResPv=orderDetail.get(0).Number_of_QTD_Residential_PV_Order__c + orderDetail.get(0).Number_of_QTD_Commercial_PV_Order__c; //qtdResPv+(
                /*if(orderDetail.get(0).Cumulative_kW_for_Residential_Orders__c!=null && orderDetail.get(0).Cumulative_kW_for_Commercial_Orders__c!=null)
                    qtdKw=orderDetail.get(0).Cumulative_kW_for_Residential_Orders__c + orderDetail.get(0).Cumulative_kW_for_Commercial_Orders__c; //qtdKw+( */
                /* Done for the case # */
                /*if(orderDetail.get(0).Cumulative_kW_for_Residential_Orders__c!=null )
                    qtdKw=orderDetail.get(0).Cumulative_kW_for_Residential_Orders__c; //qtdKw+( */
                
                for(order_detail_sunrise2__c ord : orderDetail){
                    if(ord.Cumulative_kW_for_Residential_Orders__c!=null )
                    qtdKw = qtdKw + ord.Cumulative_kW_for_Residential_Orders__c;
                }
               
            System.debug('======qtdKw==='+qtdKw);                
            //Removed this check for Sunrise-2B
            /*if(qtdResPv >= 6){
                return true;
            }
            else */if(qtdKw >= 60){
                return true;
            }
        }
        return false;
    } 
    
    //Created by hemant : For Authorized it will be 30kW
    public static Boolean computeACTIVEDEALER_AUTHO(Id accountId,Date validFrom,Date validTo){
        String currentQuarter = getCurrentQuarter();
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
        String year=getCurrentYear(performancePeriod);
        system.debug('------------anu-------'+EvalDate+'--------'+performancePeriod+'--------'+year);
        List<order_detail_sunrise2__c> orderDetail = [select Number_of_QTD_Residential_PV_Order__c,Number_of_QTD_Commercial_PV_Order__c,QTD_kW_for_Residential_Orders__c,QTD_kW_for_Commercial_Orders__c,Cumulative_kW_for_Commercial_Orders__c,Cumulative_kW_for_Residential_Orders__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod  and Year__c=:year];// Changed Quarter__c in : quarters to =:currentQuarter and Quarter__c =:currentQuarter to performance period
        if(orderDetail!=null && orderDetail.size() > 0)
        {
           // Double qtdResPv=0;
            Double qtdKw=0;
           
                //if(orderDetail.get(0).Number_of_QTD_Residential_PV_Order__c!=null && orderDetail.get(0).Number_of_QTD_Commercial_PV_Order__c!=null)
                //    qtdResPv=orderDetail.get(0).Number_of_QTD_Residential_PV_Order__c + orderDetail.get(0).Number_of_QTD_Commercial_PV_Order__c; //qtdResPv+(
                
                /* Done for the case # */
                /* if(orderDetail.get(0).Cumulative_kW_for_Residential_Orders__c!=null )
                    qtdKw=orderDetail.get(0).Cumulative_kW_for_Residential_Orders__c; //qtdKw+( */
                
                for(order_detail_sunrise2__c ord : orderDetail){
                    if(ord.Cumulative_kW_for_Residential_Orders__c!=null )
                    qtdKw = qtdKw + ord.Cumulative_kW_for_Residential_Orders__c;
                }
                
           System.debug('======qtdKw==='+qtdKw);     
           if(qtdKw >= 30){
                return true;
            }
        }
        return false;
    }
    // method changed for Phase2a - No of rows in oracle change
    public static Boolean computeMINQUATSALESEUCLONE(Id accountId,Date validFrom,Date validTo){
        String currentQuarter = getCurrentQuarter();
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
        String year=getCurrentYear(performancePeriod);
        List<order_detail_sunrise2__c> orderDetail = [select Number_of_QTD_Residential_PV_Order__c,Number_of_QTD_Commercial_PV_Order__c,QTD_kW_for_Residential_Orders__c,QTD_kW_for_Commercial_Orders__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and Year__c=:year]; // Changed Quarter__c in : quarters to =:currentQuarter and Quarter__c =:currentQuarter to performance period
        if(orderDetail!=null && orderDetail.size() > 0)
        {
            Double qtdResPv=0;
            Double qtdKw=0;
          
                if(orderDetail.get(0).Number_of_QTD_Residential_PV_Order__c!=null && orderDetail.get(0).Number_of_QTD_Commercial_PV_Order__c!=null)
                qtdResPv=orderDetail.get(0).Number_of_QTD_Residential_PV_Order__c + orderDetail.get(0).Number_of_QTD_Commercial_PV_Order__c;//qtdResPv+(
                
                if(orderDetail.get(0).QTD_kW_for_Residential_Orders__c!=null && orderDetail.get(0).QTD_kW_for_Commercial_Orders__c!=null)
                qtdKw=orderDetail.get(0).QTD_kW_for_Residential_Orders__c + orderDetail.get(0).QTD_kW_for_Commercial_Orders__c;//qtdKw+(
                 system.debug('morning'+qtdResPv+'morning1'+qtdKw);
            if(currentQuarter.equals('Q1')){ //quarters.size()==1 && quarters.get(0).equals('Q1')
                if(qtdResPv >= 1){
                    return true;
                }
                else if(qtdKw >= 10){
                    return true;
                }
            }
            else
            {
                if(qtdResPv >= 3){
                    return true;
                }
                else if(qtdKw >= 30){
                    return true;
                }
            }
        }
        return false;
    }
    
    // method changed for Phase2a - No of rows in oracle change
    public static Boolean computeMINQUATSALESEU(Id accountId,Date validFrom,Date validTo){
        Account accObj=[select  Residential_Installer_Date__c from account where id=:accountId];        
        if(accObj.Residential_Installer_Date__c!=null)
        {
            Date resdentialDate=accObj.Residential_Installer_Date__c;
            String currentQuarter = getCurrentQuarter();
            String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
            String year=getCurrentYear(performancePeriod);
            List<order_detail_sunrise2__c> orderDetail = [select Number_of_QTD_Residential_PV_Order__c,QTD_kW_for_Residential_Orders__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and Year__c=:year];// Changed Quarter__c in : quarters to =:currentQuarter and Quarter__c =:currentQuarter to performance period
            system.debug('evening'+orderDetail.size());
            if(orderDetail!=null && orderDetail.size() > 0)
            {
                if(orderDetail.size()>1)
                {
                    for(Integer i=0;i<orderDetail.size();i++)
                    {
                        if(i>=1)
                        {
                            if(orderDetail.get(i-1).Number_of_QTD_Residential_PV_Order__c!=null
                              && orderDetail.get(i).Number_of_QTD_Residential_PV_Order__c!=null)
                            {
                                 Double prevQ=orderDetail.get(i-1).Number_of_QTD_Residential_PV_Order__c;
                                 Double nxtQ=orderDetail.get(i).Number_of_QTD_Residential_PV_Order__c;
                                 if(nxtQ>=(prevQ+1))
                                 {
                                     return true;
                                 }       
                            }
                        }
                    }
                }
                else if(orderDetail.get(0).Number_of_QTD_Residential_PV_Order__c!=null
                          && orderDetail.get(0).Number_of_QTD_Residential_PV_Order__c>0)
                {
                    return true;
                }
            }
        }
        return false;
    }
    
    public static Boolean computeRETROFITSOLARSYS(Id accountID){
        String currentQuarter = getCurrentQuarter();        
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
        String year=getCurrentYear(performancePeriod);
        //for case # 00052776
        //List<order_detail_sunrise2__c> orderDetail = [select Cumulative_No_of_Commercial_PV_orders__c,Cumulative_No_of_Residential_PV_orders__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and Year__c=:year];//Quarter__c =:currentQuarter to performance period
        List<order_detail_sunrise2__c> orderDetail = [select Cumulative_No_of_Commercial_PV_orders__c,Cumulative_No_of_Residential_PV_orders__c from order_detail_sunrise2__c where Account_Name__c=:accountID and CreatedDate <= :EvalDate];
        //for case # 00052776
        if(orderDetail.size()>0)
        {   
            Double comercialCum = 0;
            Double resCom = 0;
            //Modified by Neeraj as per chandra's email [14-jan-2011] to include both quarters
            for(order_detail_sunrise2__c ord : orderDetail){
                if(ord.Cumulative_No_of_Commercial_PV_orders__c!=null && ord.Cumulative_No_of_Residential_PV_orders__c!=null ){
                    comercialCum += ord.Cumulative_No_of_Commercial_PV_orders__c;
                    resCom += ord.Cumulative_No_of_Residential_PV_orders__c;
            }
                if((comercialCum+resCom)>=100)
                {
                    return true;
                }
            }
        }
        return false;
    }
    
    //Modified by Neeraj (21-Dec-2010)
    public static double computeRETROFITSOLAR_NA(Id accountID){
        String currentQuarter = getCurrentQuarter();        
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
        String year=getCurrentYear(performancePeriod);
        //for case # 00052776
        //List<order_detail_sunrise2__c> orderDetail = [select Cumulative_kW_for_Residential_Orders__c, Cumulative_No_of_Commercial_PV_orders__c,Cumulative_No_of_Residential_PV_orders__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and Year__c=:year];//Quarter__c =:currentQuarter to performance period
        List<order_detail_sunrise2__c> orderDetail = [select Cumulative_kW_for_Residential_Orders__c, Cumulative_No_of_Commercial_PV_orders__c,Cumulative_No_of_Residential_PV_orders__c from order_detail_sunrise2__c where Account_Name__c=:accountID and CreatedDate <= :EvalDate];
        //for case # 00052776
        //Fix will uncomment later
        //List<order_detail_sunrise2__c> orderDetail = [select Cumulative_kW_for_Residential_Orders__c, Cumulative_No_of_Commercial_PV_orders__c,Cumulative_No_of_Residential_PV_orders__c from order_detail_sunrise2__c where Account_Name__c=:accountID];//Quarter__c =:currentQuarter to performance period
        Double resCom = 0;
        //As per email requirement by Chandra we are using Cumulative_kW_for_Residential_Orders__c instead of Cumulative_No_of_Commercial_PV_orders__c
        for(order_detail_sunrise2__c ord : orderDetail)
        {
            if(ord.Cumulative_kW_for_Residential_Orders__c!=null ){
                resCom +=ord.Cumulative_kW_for_Residential_Orders__c;
            }
        }
        return resCom;
    }
    
    
    
    
   
   // method changed for Phase2a - No of rows in oracle changed. 
   public static Double computeSEVENTYSALESKITS(Id accountId,Date validFrom,Date validTo){
        String currentQuarter = getCurrentQuarter();
        Double qtdResSmartPck=0;        
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
        String year=getCurrentYear(performancePeriod);
        /*Modified by hemant under SunRise 2B RVAR changes*/
        /*
        List<order_detail_sunrise2__c> orderDetail = [select QTD_of_Residential_SmartPack_orders__c,QTD_of_Commercial_orders_with_Inverter__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod  and Year__c=:year];// Changed Quarter__c in : quarters to =:currentQuarter and Quarter__c =:currentQuarter to performance period
        if(orderDetail.size() > 0)
        {
            
            Double commInver=0;
            
                if(orderDetail.get(0).QTD_of_Residential_SmartPack_orders__c!=null)
                qtdResSmartPck=orderDetail.get(0).QTD_of_Residential_SmartPack_orders__c; //qtdResSmartPck+
               
        }
        */
        List<order_detail_sunrise2__c> orderDetail = [select Sum_of_Watts_Invoiced_Smart_Pack__c,Total_Watts_Invoiced_RVAR__c,QTD_of_Residential_SmartPack_orders__c,QTD_of_Commercial_orders_with_Inverter__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod  and Year__c=:year];// Changed Quarter__c in : quarters to =:currentQuarter and Quarter__c =:currentQuarter to performance period
        /*
        if(orderDetail.size() > 0){
            if(orderDetail.get(0).Total_Watts_Invoiced_RVAR__c != null && orderDetail.get(0).Total_Watts_Invoiced_RVAR__c != 0){
                if(orderDetail.get(0).Sum_of_Watts_Invoiced_Smart_Pack__c != null){
                    qtdResSmartPck = (orderDetail.get(0).Sum_of_Watts_Invoiced_Smart_Pack__c / orderDetail.get(0).Total_Watts_Invoiced_RVAR__c) * 100;
                }else{
                    qtdResSmartPck = 0;
                }
                
            }else{
                return 0;
            }
        }*/
        Double totalWattsSmartPack = 0;
        Double totalWattsRVAR = 0;
        if(orderDetail.size() > 0){
            for(order_detail_sunrise2__c ord : orderDetail){
                if(ord.Sum_of_Watts_Invoiced_Smart_Pack__c != null){
                    totalWattsSmartPack = totalWattsSmartPack + ord.Sum_of_Watts_Invoiced_Smart_Pack__c;
                }
                
                if(ord.Total_Watts_Invoiced_RVAR__c != null){
                    totalWattsRVAR = totalWattsRVAR + ord.Total_Watts_Invoiced_RVAR__c;
                }
        
            }
        }
        
        if(totalWattsRVAR == 0){
            return 0;
        }else{
            return (totalWattsSmartPack / totalWattsRVAR) * 100;
        }
        
    }
    
    /*
    // method changed for Phase2a - No of rows in oracle changed.*/
    public static Double computeSEVENTYRESKITSEU(Id accountId,Date validFrom,Date validTo){  // return type changed from boolean to double
    /*    String currentQuarter = getCurrentQuarter(); 
        String year=getCurrentYear(performancePeriod);
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
        List<order_detail_sunrise2__c> orderDetail = [select QTD_of_Residential_SmartPack_orders__c,QTD_of_Commercial_orders_with_Inverter__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and Year__c=:year]; //// Changed Quarter__c in : quarters to =:currentQuarter and Quarter__c =:currentQuarter to performance period
        if(orderDetail.size() > 0){
            Double qtdResSmartPck=0;
            Double commInver=0;
            
                if(orderDetail.get(0).QTD_of_Residential_SmartPack_orders__c!=null)
                qtdResSmartPck=orderDetail.get(0).QTD_of_Residential_SmartPack_orders__c;
            
           //if(qtdResSmartPck >= 70){
                return qtdResSmartPck;//true;
            //}
        }
        return 0;
        
      */ 
      return 0;     
    }
       
   // method changed for Phase2a - No of rows in oracle changed.(Modified by Neeraj)
    public static Double computeSEVENTYRESKITSEU(Id accountId,Date validFrom,Date validTo,String Country, Decimal rackingPrice){  // return type changed from boolean to double
        System.debug('$$$$$$$$$Country$$$$$$In computeSEVENTYRESKITSEU' + Country);
        System.debug('$$$$$$$$$rackingPrice$$$$$$In computeSEVENTYRESKITSEU' + rackingPrice);
        String currentQuarter = getCurrentQuarter();         
        Double Sum_of_Watts_Invoiced_Smart_Pack = 0;
        Double Sum_of_Watts_Invoiced_Non_Smart_Pack = 0;
        Double Total_Watts_Invoiced_RVAR = 0;
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
        String year=getCurrentYear(performancePeriod);
        List<order_detail_sunrise2__c> orderDetail = [select QTD_of_Residential_SmartPack_orders__c,Sum_of_Watts_Invoiced_Smart_Pack__c,Racking_lines_inv_amt_Non_Smart_pack__c,Total_Watts_Invoiced_RVAR__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and Year__c=:year]; //// Changed Quarter__c in : quarters to =:currentQuarter and Quarter__c =:currentQuarter to performance period
        
        /**Added by Neeraj**/ 
        Double qtdResSmartPck=0;
        if(orderDetail.size() > 0){
            System.debug('============orderDetail.size()============' + orderDetail.size());
            for(order_detail_sunrise2__c ord : orderDetail){
                //(Sum_of_Watts_Invoiced_Smart_Pack__c + (Racking_lines_inv_amt_Non_Smart_pack__c/Racking))/Total_Watts_Invoiced_RVAR__c;
                if(ord.Sum_of_Watts_Invoiced_Smart_Pack__c!=null) 
                    Sum_of_Watts_Invoiced_Smart_Pack += ord.Sum_of_Watts_Invoiced_Smart_Pack__c;
                if(ord.Racking_lines_inv_amt_Non_Smart_pack__c !=null)
                    Sum_of_Watts_Invoiced_Non_Smart_Pack += ord.Racking_lines_inv_amt_Non_Smart_pack__c;
                if(ord.Total_Watts_Invoiced_RVAR__c != null)
                    Total_Watts_Invoiced_RVAR += ord.Total_Watts_Invoiced_RVAR__c;
                    //qtdResSmartPck += (orderDetail.get(0).Sum_of_Watts_Invoiced_Smart_Pack__c + (orderDetail.get(0).Racking_lines_inv_amt_Non_Smart_pack__c/rackingPrice))/orderDetail.get(0).Total_Watts_Invoiced_RVAR__c ; 
            System.debug('=========ord.id========' +ord.id);
            }
            System.debug('============Sum_of_Watts_Invoiced_Smart_Pack===============' + Sum_of_Watts_Invoiced_Smart_Pack);
            System.debug('=============Sum_of_Watts_Invoiced_Non_Smart_Pack==============' + Sum_of_Watts_Invoiced_Non_Smart_Pack);
            System.debug('==========Total_Watts_Invoiced_RVAR=================' + Total_Watts_Invoiced_RVAR);
            System.debug('==========rackingPrice=================' + rackingPrice);
            
            if(Total_Watts_Invoiced_RVAR !=0){
                if(Country.equalsIgnoreCase('Germany')){
                    System.debug('Testing $$$$$$$$$$$$In Germany');
                    if(rackingPrice != null)
                        qtdResSmartPck = ((Sum_of_Watts_Invoiced_Smart_Pack + (Sum_of_Watts_Invoiced_Non_Smart_Pack/rackingPrice))/Total_Watts_Invoiced_RVAR)*100;
                    else
                        qtdResSmartPck = ((Sum_of_Watts_Invoiced_Smart_Pack )/Total_Watts_Invoiced_RVAR)*100;
                }else{
                    qtdResSmartPck = (Sum_of_Watts_Invoiced_Smart_Pack /Total_Watts_Invoiced_RVAR)*100;
                }
            }
            System.debug('$$$$$$$$$$$$$$$$' + qtdResSmartPck);
            return qtdResSmartPck; 
            }/*
            else{
                    Double commInver=0; 
                    if(orderDetail.get(0).QTD_of_Residential_SmartPack_orders__c!=null)
                    qtdResSmartPck=orderDetail.get(0).QTD_of_Residential_SmartPack_orders__c;
                System.debug('=========Italy France Residential > 70======' + qtdResSmartPck);
                //if(qtdResSmartPck >= 70){
                    return qtdResSmartPck;//true;
                //}
            }
        }*/
        return 0;
        
    }   
        
    
    // method changed for Phase2a - No of rows in oracle changed.
    //greater than 70 of  Commercial sales include Inverter(changed by hemant in Sunrise2b)
    public static Double computeSEVENTYCOMINVTREU(Id accountId,Date validFrom,Date validTo){  // return type changed from boolean to double
        String currentQuarter = getCurrentQuarter();         
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
        String year=getCurrentYear(performancePeriod);
        List<order_detail_sunrise2__c> orderDetail = [select Sum_of_Watts_Invoiced_Inverters__c, Total_Watts_Invoiced_CVAR__c, QTD_of_Residential_SmartPack_orders__c, QTD_of_Commercial_orders_with_Inverter__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and Year__c=:year]; // Changed Quarter__c in : quarters to =:currentQuarter and Quarter__c =:currentQuarter to performance period
        Double wattInvoicedInverters = 0 ;
        //Double totalWattsInvoicedCVAR = 0;
        //Inv.Penetration Rate=  (?_(Invoiced Inverter CVAR lines)¦?InverterNominal Power*Quantity?)/(?_(Invoiced module CVAR lines)¦?Module Nominal Power*Quantity?)
        if(orderDetail.size() > 0){
            for(order_detail_sunrise2__c ord : orderDetail){
                if(ord.QTD_of_Commercial_orders_with_Inverter__c != null)
                    wattInvoicedInverters = wattInvoicedInverters + ord.QTD_of_Commercial_orders_with_Inverter__c;
                //if(ord.Total_Watts_Invoiced_CVAR__c != null)
                //  totalWattsInvoicedCVAR = totalWattsInvoicedCVAR + ord.Total_Watts_Invoiced_CVAR__c;
            }
        }
        if(orderDetail == null || orderDetail.size() == 0){
            return 0;
        }else{
            return wattInvoicedInverters / orderDetail.size();
        }
            
        /*commented by hemant Sunrise2b*/
        /*
        if(orderDetail.size() > 0)
        {
            Double qtdResSmartPck=0;
            Double commInver=0;
           
                if(orderDetail.get(0).QTD_of_Commercial_orders_with_Inverter__c!=null)
                commInver=orderDetail.get(0).QTD_of_Commercial_orders_with_Inverter__c;    
            
           // if(commInver >= 70){
                return commInver;// true;
            //}
        }   
        return 0;//false;
        */        
    }
    
    public static Double computeOPPCLOSERATE(Id accountId){
        Account accObj = [select name, (select StageName from Opportunities) from Account where id=: accountId];
        List<Opportunity> oppObj = accObj.Opportunities;
        Integer numOfClosedOpp=0;
        for(Opportunity o:oppObj  ){
            if(o.StageName.equals('100% - Won')){
                  numOfClosedOpp++;  
            }
        }
        if(numOfClosedOpp > 0 && oppObj.size() > 0)
            return (numOfClosedOpp/oppObj.size() );
        else
            return 0;
    }
        
    public static Double computeBGSMScore(Id accountId){
        List<Partner_Application__c> partnerApp=[select Account__c,Scorecard_Score__c from Partner_Application__c where Account__c=:accountId];
        if(partnerApp.size()>0 && partnerApp.get(0).Scorecard_Score__c!=null)
        {
            return partnerApp.get(0).Scorecard_Score__c;
        }
        return 0;
    }
    
    // method changed for Phase2a - No of rows in oracle changed.
    public static Double computeSIXMONTHSTARGET(Id accountId,Date validFrom,Date validTo){
        String currentQuarter = getCurrentQuarter();
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter); 
        String year=getCurrentYear(performancePeriod);
        system.debug('qwerty12'+year);
        
        //Field changed by neeraj from QTD_Net_Purchase_Amount__c to Net_purchase_amount_for_NA_RVAR__c (17-Jan-2011)
        List<order_detail_sunrise2__c> orderDetail = [select Net_purchase_amount_for_NA_RVAR__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and Year__c=:year];// Changed Quarter__c in : quarters to =:currentQuarter and Quarter__c =:currentQuarter to performance period
        system.debug('123ert'+orderDetail);
        Double target=0;
        //Added by as per discussion in meeting with chandra on 13-Jan-2010
        for(order_detail_sunrise2__c ord : orderDetail){
            if(ord.Net_purchase_amount_for_NA_RVAR__c!=null)
            target += ord.Net_purchase_amount_for_NA_RVAR__c;
        }
        
       /* List<order_detail_sunrise2__c> orderDetail = [select QTD_Net_Purchase_Amount__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and Year__c=:year];// Changed Quarter__c in : quarters to =:currentQuarter and Quarter__c =:currentQuarter to performance period
        system.debug('123ert'+orderDetail);
        Double target=0;
        //Added by as per discussion in meeting with chandra on 13-Jan-2010
        for(order_detail_sunrise2__c ord : orderDetail){
            if(ord.QTD_Net_Purchase_Amount__c!=null)
            target += ord.QTD_Net_Purchase_Amount__c;
        }*/
        //Previous Code before 13-Jan-2010
        /*if(orderDetail.size() > 0)
        { 
                if(orderDetail.get(0).QTD_Net_Purchase_Amount__c!=null)
                target = orderDetail.get(0).QTD_Net_Purchase_Amount__c;
           
        }*/
        return target;
    }
    
     // method changed for Phase2a - No of rows in oracle changed.
     public static Double computeKWTARGETEU(Id accountId,Date validFrom,Date validTo){
        String currentQuarter = getCurrentQuarter();         
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
        String year=getCurrentYear(performancePeriod);
        List<order_detail_sunrise2__c> orderDetail = [select QTD_kW_for_Commercial_Orders__c,QTD_kW_for_Residential_Orders__c,Cumulative_kW_for_Commercial_Orders__c, Cumulative_kW_for_Residential_Orders__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and Year__c=:year]; // Changed Quarter__c in : quarters to =:currentQuarter and Quarter__c =:currentQuarter to performance period
        Double qtdKw=0;
        //Case#00069842
        //Calculate for whole period
        /*if(orderDetail.size() > 0){
            
                if(orderDetail.get(0).Cumulative_kW_for_Residential_Orders__c!=null && orderDetail.get(0).Cumulative_kW_for_Commercial_Orders__c!=null)
                qtdKw=orderDetail.get(0).Cumulative_kW_for_Residential_Orders__c + orderDetail.get(0).Cumulative_kW_for_Commercial_Orders__c; //qtdKw+(
        }*/           
        for(order_detail_sunrise2__c ord :orderDetail){    
            if(ord.Cumulative_kW_for_Residential_Orders__c!=null) 
                qtdKw=qtdKw + ord.Cumulative_kW_for_Residential_Orders__c; 
            if(ord.Cumulative_kW_for_Commercial_Orders__c!=null)
                qtdKw=qtdKw + ord.Cumulative_kW_for_Commercial_Orders__c;
        }        
        
        return qtdKw;
    }
    
    //Bonus for Online Ordering(hemant)
    public static double computeBonusForOnlineOrdering(Id accountId, Date validFrom, Date validTo){
        String currentQuarter = getCurrentQuarter();         
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
        String year = getCurrentYear(performancePeriod);
        // Done for Case # 00068852
        List<order_detail_sunrise2__c> orderDetail = [select QTD_kW_for_Residential_Orders__c , Cumulative_kW_for_Residential_Orders__c, Total_kW_shipped_via_online_ordering__c, Number_of_QTD_Residential_PV_Order__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and Year__c=:year]; 
        //Double totalOrdersShipped = 0;
        Double totalKWOrdered = 0;
        Double kwShippedViaOnlineOrdering = 0;
        
        if(orderDetail != null && orderDetail.size() > 0){           
            for(order_detail_sunrise2__c ord : orderDetail){
                //if(ord.Number_of_QTD_Residential_PV_Order__c != null) 
                //    totalOrdersShipped = totalOrdersShipped + ord.Number_of_QTD_Residential_PV_Order__c; 
                if(ord.QTD_kW_for_Residential_Orders__c != null) 
                    totalKWOrdered = totalKWOrdered + ord.QTD_kW_for_Residential_Orders__c;
                if(ord.Total_kW_shipped_via_online_ordering__c != null)
                    kwShippedViaOnlineOrdering = kwShippedViaOnlineOrdering + ord.Total_kW_shipped_via_online_ordering__c;  
            }          
        }
        
        // if(totalOrdersShipped ==0){
        if(totalKWOrdered ==0){
            return 0;
        }else{
            // return (kwShippedViaOnlineOrdering / totalOrdersShipped) * 100 ;
            return (kwShippedViaOnlineOrdering / totalKWOrdered) * 100 ;
        }
               
    }
    
    //method for UpToDateWithPaymentEU Metric Boolean Calculation(Neeraj)
    public static Boolean isUpToDateWithPaymentEU(Id accountId){
        Account accObj = [select Amount_Past_Due__c, Available_Credit__c, Credit_Hold__c, Credit_Limit__c from Account where Id=:accountId][0];
        System.debug('========Amount Past Due===============' + accObj.Amount_Past_Due__c);
        if(accObj.Amount_Past_Due__c == null || accObj.Amount_Past_Due__c <= 0){
            return true;
        }
        return false;
    }
    
     // method for Sunpower Residential Loan Program Signed Metric Boolean Calculation(Neeraj)
     //Metric should check if a contract with Contract Type = Customer Finance Service and Status= Signed exists associated to the account.
    public static Boolean IsSunpowerResidentialLoanProgramSignedEU(Id accountId){
        System.debug('======================' + accountID);
        List<Contract> lstContract = [Select c.Status, c.AccountId,contract_Type__c From Contract c where c.Status='Signed' and contract_Type__c = 'Customer Finance Service' and AccountID=:accountId]; 
        if(lstContract.size()>0){
            return true;
        }
        return false;
    }
    
    //This method check whether the metric is able to move to Premier or not(Only for Germany) (Neeraj)
    public static Boolean isMoveToPremier( Id accountID,Decimal thershold){
        String currentQuarter = getCurrentQuarter();        
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
        String year=getCurrentYear(performancePeriod);
        List<order_detail_sunrise2__c> orderDetail = [select Total_Watts_Invoiced_RVAR__c,Cumulative_No_of_Residential_PV_orders__c,Cumulative_No_of_Commercial_PV_orders__c,Cumulative_kW_for_Commercial_Orders__c,Cumulative_kW_for_Residential_Orders__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and Year__c=:year]; //Quarter__c =:currentQuarter to performance period
        if(orderDetail.size() > 0)
        {
            if(orderDetail[0].Total_Watts_Invoiced_RVAR__c >= thershold ){
                return true;
            }
        }
        return false;
    }
    
     /*EU Automated Training and Inspection metrics */
    public static final String ITALY_SMARTER_SELLING_TRAINING = 'VAR-SALES-SPSS1_IT';
    public static final String FRANCE_SMARTER_SELLING_TRAINING = 'VAR-SALES-SPSS1_FR';
    public static final String GERMANY_SMARTER_SELLING_TRAINING = 'VAR-SALES-SPSS1_DE';
    
    public static final String ITALY_DESIGN_SPFRDSA_TRAINING = 'VAR-DESIGN-SPFRDSA_IT';
    public static final String FRANCE_DESIGN_SPFRDSA_TRAINING = 'VAR-DESIGN-SPFRDSA_FR';
    
    public static final String ITALY_SAL_CORE_TRAINING = 'VAR-SAL-CORE-IL01-IT';
    public static final String FRANCE_SAL_CORE_TRAINING = 'VAR-SAL-CORE-IL01-FR';
    
    // Done for case # 00060258
    public static final String ITALY_INSTALLATION_RESIDENTIAL_TRAINING = 'VAR-INS-RESI-IL01_IT';
    
    // Done for case # 00060076
    public static final String FRANCE_INSTALLATION_RESIDENTIAL_TRAINING = 'VAR-INS-RESI-IL01_FR';
    
    //For Germany and Italy and France
    public static Double smarterSelling_EU(String accountId, String country){
        String courseName ;
        if(country.toLowerCase() == 'italy'){
            courseName = ITALY_SMARTER_SELLING_TRAINING;
        }else if(country.toLowerCase() == 'germany'){
            courseName = GERMANY_SMARTER_SELLING_TRAINING;
        }//Modified by Neeraj
        else if(country.toLowerCase()=='france'){
            courseName = FRANCE_SMARTER_SELLING_TRAINING;
        }
        
        Set<String> uniquePartners = new Set<String>();
        System.debug('=============CourseName============' + courseName);
        for(Certification__c cert :[select PartnerContact__c, Attended_ILC__c from Certification__c where Name=:courseName and Account__c =:accountId and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE and Business__c in (null,'RESIDENTIAL')]){
            uniquePartners.add(cert.PartnerContact__c);
        }       
        return uniquePartners.size();
    }
    
    //For SRI Italy and FRANCE
    public static Double fundamentalDesignSPFRTraining_EU(String accountId){        
        Set<String> uniquePartners = new Set<String>();
        //Modified by Neeraj
        //for(Certification__c cert :[select PartnerContact__c, Attended_ILC__c from Certification__c where Name=:ITALY_DESIGN_SPFRDSA_TRAINING and Account__c =:accountId and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE and Business__c in (null,'RESIDENTIAL')]){
        for(Certification__c cert :[select PartnerContact__c, Attended_ILC__c from Certification__c where Name in (:ITALY_DESIGN_SPFRDSA_TRAINING,:FRANCE_DESIGN_SPFRDSA_TRAINING) and Account__c =:accountId and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE and Business__c in (null,'RESIDENTIAL')]){
            uniquePartners.add(cert.PartnerContact__c);
        } 
        System.debug('==========uniquePartners.size()============' + uniquePartners.size());    
        return uniquePartners.size();
    }
    
    //For SRI Italy
    public static Double fundamentalSALCORETraining_EU(String accountId){       
        Set<String> uniquePartners = new Set<String>();
        //Modified by Neeraj
        //for(Certification__c cert :[select PartnerContact__c, Attended_ILC__c from Certification__c where Name=:ITALY_SAL_CORE_TRAINING and Account__c =:accountId and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE and Business__c in (null,'RESIDENTIAL')]){
        for(Certification__c cert :[select PartnerContact__c, Attended_ILC__c from Certification__c where Name in(:ITALY_SAL_CORE_TRAINING,:FRANCE_SAL_CORE_TRAINING) and Account__c =:accountId and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE and Business__c in (null,'RESIDENTIAL')]){
            uniquePartners.add(cert.PartnerContact__c);
        }   
        return uniquePartners.size();
    }

    // Done for case # 00060258
    // Done for case # 00060076
    //For SRI Italy and FRANCE
    public static Double fundamentalINSTALLATIONTraining_EU(String accountId){       
        Set<String> uniquePartners = new Set<String>();
        for(Certification__c cert :[select PartnerContact__c, Attended_ILC__c from Certification__c where Name in(:ITALY_INSTALLATION_RESIDENTIAL_TRAINING,:FRANCE_INSTALLATION_RESIDENTIAL_TRAINING) and Account__c =:accountId and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE and Business__c in (null,'RESIDENTIAL')]){
            uniquePartners.add(cert.PartnerContact__c);
        }   
        return uniquePartners.size();
    }
    
    //For SRI Italy
    //For stay in this tier: 0 Inspections failed, 
    //                       AND 1Inspection passed if the company is an SRI for less than 6 months. 
    //                       (use sfdc’s field: Residential Installer Since Date)
    public static Boolean inspectionSRI_EU(String accountId, Date validFrom, Date validTo, Performance_Metric__c currentPM){
        System.debug('=====inspectionSRI_EU==========');
        Integer numFailed = 0;
        Integer numPassed = 0;
        Performance_Metric__c previousPM = findPreviousPeriod(currentPM);
        if(previousPM != null)
            validFrom = previousPM.Performance_Period_Start_Date__c;
        Account accObj = [select Residential_Installer_since_date__c, Authorized_Partner_Date__c from account where id=:accountId];
        System.debug('=====accObj=========='+accObj);
        List<Case> caseList = [select Id from Case Where (Partner_Name__c=:accountId OR Partner_Account__c=:accountId) and Type=:'Inspection'];
        List<Id> caseIds = new List<Id>();
        if(caseList.size() > 0){
            
            for(Case c : caseList){
                caseIds.add(c.Id);
            }
            
            System.debug('=====caseIds===='+caseIds);           
            List<Inspection__c> inspection = [select score__c ,Residential_Result__c,Score_Details__c,Inspection_Date__c from Inspection__c where Case__c in :caseIds and Inspection_Date__c >= :validFrom and Inspection_Date__c <= :validTo and Site_Type__c = 'Residential']; // PASS
            System.debug('=====inspection===='+inspection);
           
            for(Inspection__c i:inspection){
                if((i.Score_Details__c != null && i.Score_Details__c.contains('PASS')) || (i.Residential_Result__c != null && i.Residential_Result__c.contains('PASS'))){               
                    numPassed++;
                }else if((i.Score_Details__c != null && i.Score_Details__c.contains('FAIL')) || (i.Residential_Result__c != null && i.Residential_Result__c.contains('FAIL'))){
                    numFailed++;
                }
            }
        }  
       //Modified by Neeraj added accObj != null
        if(numFailed == 0 && accObj != null){
            //Modified by neeraj condition added (accObj.Residential_Installer_since_date__c != null) 
            if((accObj.Residential_Installer_since_date__c != null) && accObj.Residential_Installer_since_date__c.monthsBetween(EvalDate) < 6){
                if(numPassed >= 1){
                    System.debug('=====1.====');
                    return true;
                }else{
                    System.debug('=====2.====');
                    return false;
                }
            }else{
                System.debug('=====3.====');
                return true;
            }
        }else{
            System.debug('=====4.====');
            return false;
        }
    }
    
    //For Authorized Germany and Italy
    //For stay in this tier: 0 Inspections failed, AND 1 Inspection passed for partners with age 
    //                       lower than 6 months. (use Authorized Partner since date AND Promoted Authorized 
    //                       Partner Date should be blank)
    //For Enter in this tier: 0 inspections failed AND min 1 Inspection passed
    public static Boolean inspectionAuthorised_EU(String accountId, Date validFrom, Date validTo, String tierType, String coutry, Performance_Metric__c currentPM){
        System.debug('=====inspectionAuthorised_EU==========');
        Integer numFailed = 0;
        Integer numPassed = 0;
        Performance_Metric__c previousPM = findPreviousPeriod(currentPM);
        if(previousPM != null)
            validFrom = previousPM.Performance_Period_Start_Date__c;
        Account accObj = [Select a.Residential_Installer_since_date__c, a.Promoted_Authorized_Partner_Date__c, a.Authorized_Sunrise_2_Partner_date__c, a.Authorized_Partner_Date__c From Account a where id=:accountId];
        System.debug('=====accObj=========='+accObj);
        List<Case> caseList = [select Id from Case Where (Partner_Name__c=:accountId OR Partner_Account__c=:accountId) and Type=:'Inspection'];
        List<Id> caseIds = new List<Id>();
        if(caseList.size() > 0){
            
            for(Case c : caseList){
                caseIds.add(c.Id);
            }
            
            System.debug('=====caseIds===='+caseIds);           
            List<Inspection__c> inspection = [select score__c ,Residential_Result__c,Score_Details__c,Inspection_Date__c from Inspection__c where Case__c in :caseIds and Inspection_Date__c >= :validFrom and Inspection_Date__c <= :validTo and Site_Type__c = 'Residential']; // PASS
            System.debug('=====inspection===='+inspection);
           
            for(Inspection__c i:inspection){
                if((i.Score_Details__c != null && i.Score_Details__c.contains('PASS')) || (i.Residential_Result__c != null && i.Residential_Result__c.contains('PASS'))){               
                    numPassed++;
                }else if((i.Score_Details__c != null && i.Score_Details__c.contains('FAIL')) || (i.Residential_Result__c != null && i.Residential_Result__c.contains('FAIL'))){
                    numFailed++;
                }
            }
        }
        
        if(tierType.toLowerCase() == 'stay'){
             // Done for case # 00060076 (replaced Authorized_Sunrise_2_Partner_date__c to Authorized_Partner_Date__c )
             if(numFailed == 0 && accObj != null && accObj.Authorized_Partner_Date__c != null ){
                if(accObj.Authorized_Partner_Date__c.monthsBetween(EvalDate) < 6 && accObj.Promoted_Authorized_Partner_Date__c == null){
                    if(numPassed >= 1){
                        System.debug('=====1.====');
                        return true;
                    }else{
                        System.debug('=====2.====');
                        return false;
                    }
                }else{
                    System.debug('=====3.====');
                    return true;
                }
            }else{
                System.debug('=====4.====');
                return false;
            }
        }else{
            if(numFailed == 0 && numPassed >= 1 ){
                System.debug('=====5.====');
                return true;
            }else{
                System.debug('=====6.====');
                return false;
            }
        } 
    }
    
    //For Premier Germany and Italy
    //Stay in tier: 0 Inspections failed
    //Enter in tier: 0 inspections failed AND min 1 Inspection passed
    public static Boolean inspectionPremier_EU(String accountId, Date validFrom, Date validTo, String tierType, String coutry, Performance_Metric__c currentPM){
        System.debug('=====inspectionPremier_EU==========');
        Integer numFailed = 0;
        Integer numPassed = 0;
        Performance_Metric__c previousPM = findPreviousPeriod(currentPM);
        if(previousPM != null)
            validFrom = previousPM.Performance_Period_Start_Date__c;
        List<Case> caseList = [select Id from Case Where (Partner_Name__c=:accountId OR Partner_Account__c=:accountId) and Type=:'Inspection'];
        List<Id> caseIds = new List<Id>();
        if(caseList.size() > 0){
            
            for(Case c : caseList){
                caseIds.add(c.Id);
            }
            
            System.debug('=====caseIds===='+caseIds);           
            List<Inspection__c> inspection = [select score__c ,Residential_Result__c,Score_Details__c,Inspection_Date__c from Inspection__c where Case__c in :caseIds and Inspection_Date__c >= :validFrom and Inspection_Date__c <= :validTo and Site_Type__c = 'Residential']; // PASS
            System.debug('=====inspection===='+inspection);
           
            for(Inspection__c i:inspection){
                if((i.Score_Details__c != null && i.Score_Details__c.contains('PASS')) || (i.Residential_Result__c != null && i.Residential_Result__c.contains('PASS'))){               
                    numPassed++;
                }else if((i.Score_Details__c != null && i.Score_Details__c.contains('FAIL')) || (i.Residential_Result__c != null && i.Residential_Result__c.contains('FAIL'))){
                    numFailed++;
                }
            }
        }
        
        if(tierType.toLowerCase() == 'stay'){
            if(numFailed == 0){
                System.debug('=====1.====');
                return true;
            }else{
                System.debug('=====2.====');
                return false;
            } 
        }else{
            if(numFailed == 0 && numPassed >= 1 ){
                System.debug('=====3.====');
                return true;
            }else{
                System.debug('=====4.====');
                return false;
            }
        } 
    }
     
    /******* UTIL FUNCTIONS ******************/
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
    
    //code change for phase2a
    private static Integer getQuarterByDate(Date tDate){
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
    // method to find current Quarter
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
   
   //method to find current performance period by Quarter
   public static String getCurrentPerformancePeriod(String quater){
        if(quater.equals('Q1')||quater.equals('Q2')){
            return 'P1';    
        }else if(quater.equals('Q3')||quater.equals('Q4')){
            return 'P2';
        }   
        return null; 
   }
   
   //method to find year period by performancePeriod
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
   
    public static void automatedDoubleGoalCheck(Metric__c m,Metric_Tier_Relation__c mtr,Double achieve){
        m.Achievement_Value__c = Math.round(achieve);
        Double min=mtr.Metric_Min_Value__c;
        Double max=mtr.Metric_Max_Value__c;
        if(mtr.isRSMView__c){
            min = m.Metric_Min_Value__c;
            max = m.Metric_Max_Value__c;
        }  
        Boolean goalMet=PerformanceAchievementClass.checkGoalMet(min,max,achieve);
        m.Goal_Met__c=goalMet;
    }
    
    /************************************************/
    //Modified by neeraj
    /************************************************/
    public static void automatedBonusGoalCheck(Metric__c m,Metric_Tier_Relation__c mtr,Double achieve){
        m.Achievement_Value__c = Math.round(achieve);
        Double min=mtr.Bonus_Requirement__c;
        Boolean goalMet=PerformanceAchievementClass.checkGoalMet(min,null,achieve);
        m.Goal_Met__c=goalMet;
    }
    
    
     
    public static void automatedBooleanGoalCheck(Metric__c m,Metric_Tier_Relation__c mtr,Boolean achieve){
        System.debug('================achieve====================' + achieve);
        m.Boolean_Achievement__c = achieve;
        m.Goal_Met__c=achieve;
    }
    
    public static void automatedDoubleGoalCheckKW(Metric__c m,Metric_Tier_Relation__c mtr,Double achieve){
        m.Achievement_Value__c =Math.round(achieve);
        Double min=m.Metric_Min_Value__c;
        Double max=m.Metric_Max_Value__c;
        Boolean goalMet=PerformanceAchievementClass.checkGoalMet(min,max,achieve);
        m.Goal_Met__c=goalMet;
    }    
    
    public static Integer inverterValue(String[] str){
        Integer j =0;
        Integer len = str.size();
        for(Integer i=0;i<len;i++){
            if(str[i].equals('0')||str[i].equals('1')||str[i].equals('2')||str[i].equals('3')||str[i].equals('4')||str[i].equals('5')||str[i].equals('6')||str[i].equals('7')||str[i].equals('8')||str[i].equals('9')){
                j++;
                if(j>3){
                    return 0; // new code
                }
                if(i==len-1){
                    return j;
                }   
            }else{
                return j;
            }
        }
        return null;
    }
    
    public static Performance_Metric__c findPreviousPeriod(Performance_Metric__c currentPM){
        List<Performance_Metric__c> performancelst = [select Thea__c,User_To_Override__c,Performance_Period_Start_Date__c, Performance_Period_End_Date__c,Performance_Evaluation_Cut_off_Date__c, country__c, channel__c from Performance_Metric__c where Thea__c =:currentPM.Thea__c and Country__c = :currentPM.Country__c and channel__c =:currentPM.Channel__c  and (Performance_Period_Start_Date__c <:currentPM.Performance_Period_Start_Date__c.addDays(-30) ) order by Performance_Period_Start_Date__c desc limit 1];
        if(performancelst != null && performancelst.size() > 0){
            return performancelst.get(0);
        }else{
            return null;
        }
    }
    /******* UTIL FUNCTIONS ******************/
    
    
    
    
}