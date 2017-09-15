public class performanceAchievePrevious {
    
    
    public performanceAchievePrevious(){
    } 
    
    public static Double computeCSATSCORE(Id accountId, Date validFrom,Date validTo ){
        List<Customer_Survey_Result__c> surveyResult = [select Aggregate_Score_New__c  from Customer_Survey_Result__c where Partner_Account__c =: accountId and Survey_Response_Date__c >= :validFrom and Survey_Response_Date__c <= :validTo];
        Double score=0;
        Integer count=0;
        for(Customer_Survey_Result__c csat:surveyResult){
            if(csat.Aggregate_Score_New__c!= null){
                score=score+csat.Aggregate_Score_New__c;
                count++;    
            }
            
        }
        if(score>0){
            Double a = (score/count).round();
            return a;
        }
        
        return score; 
    }
    
    //code written as part of Phase2a on 3/5/10
    public static Boolean checkCSATCount(Id accountId,Date validFrom,Date validTo,Double thershold){
         List<Customer_Survey_Result__c> surveyResult = [select Aggregate_Score_New__c  from Customer_Survey_Result__c where Partner_Account__c =: accountId and Survey_Response_Date__c >= :validFrom and Survey_Response_Date__c <= :validTo];
         Double count = 0;
         count = surveyResult.size();
         if(count >= thershold){
            return true;    
         }else {
            return false;
         }
         
    }
    //code written as part of Phase2a for CSAT Survey Requirement 11May
    public static Double computeCSATSURVEYREQ(Id accountId, Date validFrom,Date validTo ){
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
        String year=''+date.newinstance(2010,7,4).year();
        String currentQuarter = getCurrentQuarter();
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
        List<order_detail_sunrise2__c> orderDetail = [select Number_of_QTD_Residential_PV_Order__c,oracle_account_number__r.Num_Open_Opportunities__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and Year__c=:year];// Changed Quarter__c in : quarters to =:currentQuarter and Quarter__c =:currentQuarter to performance period
        if(orderDetail.size() > 0)
        {
            Double qtdPVOrder=0;
           
                if(orderDetail.get(0).Number_of_QTD_Residential_PV_Order__c!=null)
                qtdPVOrder=orderDetail.get(0).Number_of_QTD_Residential_PV_Order__c; //qtdPVOrder+
            
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
        
        String year=''+date.newinstance(2010,7,4).year();
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
    }
    
    //code added for Sunrise phase2a for Warranty Cards Europe
    public static Double computeWARRANTYCARDSEU(Id accountID,Date validFrom,Date validTo){
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
        String year=''+date.newinstance(2010,7,4).year();
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
    }
    
    public static Double computeTRAININGASSDESIGN(Id accountId){
        //adding a condition to check the certified as true
        List<Certification__c> certification = [select Attended_ILC__c from Certification__c where Curriculum_Role__c in (:'Design') and Curriculum_Level__c in (:'Associate') and Account__c =:accountId and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE]; // terminated condition is added in Phase2a on 4th June
        return certification.size();
    }
    public static Double computeTRAININGASSINSTALL(Id accountId){
        //adding a condition to check the certified as true
        List<Certification__c> certification = [select Attended_ILC__c from Certification__c where Curriculum_Role__c in (:'Install') and Curriculum_Level__c in (:'Associate') and Account__c =:accountId and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE]; // terminated condition is added in Phase2a on 4th June];
        return certification.size();
    }
    public static Double computeTRAININGASSSALES(Id accountId){
        //adding a condition to check the certified as true
        List<Certification__c> certification = [select Attended_ILC__c from Certification__c where Curriculum_Role__c in (:'Sales') and Curriculum_Level__c in (:'Associate') and Account__c =:accountId  and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE]; // terminated condition is added in Phase2a on 4th June];
        return certification.size();
    }
    
    public static Double computeTRAININGADVDESIGN(Id accountId){
            //adding a condition to check the certified as true
        List<Certification__c> certification = [select Id,Attended_ILC__c from Certification__c where Curriculum_Role__c in (:'Design') and Curriculum_Level__c in (:'Advanced','ADVANCE') and Account__c =:accountId and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE]; // terminated condition is added in Phase2a on 4th June];
        return certification.size();
    }
    public static Double computeTRAININGADVINSTALL(Id accountId){
     // adding a condition to check the certified as true
        List<Certification__c> certification = [select Attended_ILC__c from Certification__c where Curriculum_Role__c in (:'Install') and Curriculum_Level__c in (:'Advanced','ADVANCE') and Account__c =:accountId and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE]; // terminated condition is added in Phase2a on 4th June];
        return certification.size();
    }
    public static Double computeTRAININGADVSALES(Id accountId){
        //  adding a condition to check the certified as true
        List<Certification__c> certification = [select Attended_ILC__c from Certification__c where Curriculum_Role__c in (:'Sales') and Curriculum_Level__c in (:'Advanced','ADVANCE') and Account__c =:accountId  and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE]; // terminated condition is added in Phase2a on 4th June];
        return certification.size();
    }
    
    //Calculation for Bonus for extra Training
    public static Boolean computeTRAININGEXTRABONUS(Id accountId){
        Double designAdv=computeTRAININGADVDESIGN(accountId);
        Double installAdv=computeTRAININGADVINSTALL(accountId);
        Double salesAdv=computeTRAININGADVSALES(accountId);
        
        List<Certification__c> advSalesWitoutCertCheck = [select Attended_ILC__c from Certification__c where Curriculum_Role__c in (:'Sales') and Curriculum_Level__c in (:'Advanced','ADVANCE') and Account__c =:accountId and PartnerContact__r.Terminated__c = FALSE]; // terminated condition is added in Phase2a on 4th June];
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
        List<Certification__c> certification = [select Attended_ILC__c from Certification__c where  Curriculum_Level__c in (:'Advanced','ADVANCE') and Account__c =:accountId  and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE]; // terminated condition is added in Phase2a on 4th June];
        return certification.size();
    }
    
    public static Double computeADVANCE_TRAINING_EU(Id accountId){
    // adding a condition to check the certified as true
        List<Certification__c> certification = [select Attended_ILC__c from Certification__c where  Curriculum_Level__c in (:'Advanced','ADVANCE') and Account__c =:accountId and Curriculum_Role__c in (:'Install','Design') and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE]; // terminated condition is added in Phase2a on 4th June];
        return certification.size();
    }
    
    public static Double computeBASICTRAINING(Id accountId){
        //  adding a condition to check the certified as true
        List<Certification__c> certification = [select Attended_ILC__c from Certification__c where Curriculum_Level__c in (:'Associate') and Account__c =:accountId and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE]; // terminated condition is added in Phase2a on 4th June ];
        return certification.size();
    }
    
    public static Double computeBASICTRAININGEU(Id accountId){
    //  adding a condition to check the certified as true
        List<Certification__c> certification = [select Attended_ILC__c from Certification__c where Curriculum_Level__c in (:'Associate') and Account__c =:accountId and Curriculum_Role__c in (:'Install','Design') and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE]; // terminated condition is added in Phase2a on 4th June];
        return certification.size();
    }
    
    // code added for Phase2a on 19Apr10 
    public static Double computeEXTRABONUSI(Id accountId){
    //  adding a condition to check the certified as true
        List<Certification__c> certification = [select Attended_ILC__c from Certification__c where Curriculum_Level__c in (:'Advanced','ADVANCE') and Account__c =:accountId and Curriculum_Role__c in (:'Install','Design') and Attended_ILC__c =: true and PartnerContact__r.Terminated__c = FALSE]; // terminated condition is added in Phase2a on 4th June];
        return certification.size();
    }
    
     // code added for Phase2a on 19Apr10 
    public static Double computeEXTRABONUSII(Id accountId){
    //  adding a condition to check the certified as true
        Double salesAdv=computeTRAININGADVSALES(accountId);
        List<Contact>allSalewitoutCert=[select Id from Contact where Portal_User_Profile__c='Partner Sales' and AccountId =:accountId and Terminated__c = FALSE];
        Double allSales = allSalewitoutCert.size();
        if(allSales!=0){
            Double aggSales = (salesAdv/allSales) *100;
            return aggSales;
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
        String year=''+date.newinstance(2010,7,4).year();
        if(accObj.Authorized_Partner_Date__c!=null)
        {
            Date resdentialDate=accObj.Authorized_Partner_Date__c;
            Date todayDate=date.newinstance(2010,7,4);
            if(resdentialDate.monthsBetween(todayDate)>=6)
            {
                String currentQuarter = getCurrentQuarter();
                String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
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
        String year=''+date.newinstance(2010,7,4).year();
        if(accObj.Authorized_Partner_Date__c!=null)
        {
            Date resdentialDate=accObj.Authorized_Partner_Date__c;
            Date todayDate=date.newinstance(2010,7,4);
            
            if(resdentialDate.monthsBetween(todayDate)>=6)
            {
                return true;
            }
        }
        return false;    
    }
    //Calculation for 20 Installs for Authorised
    public static Boolean computeTWENTYINSTALLSASAUTH( Id accountID){
        String year=''+date.newinstance(2010,7,4).year();
        String currentQuarter = getCurrentQuarter();
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
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
        String year=''+date.newinstance(2010,7,4).year();
        if(accObj.Promoted_Premier_Date__c!=null)
        {
            Date resdentialDate=accObj.Promoted_Premier_Date__c;
            Date todayDate=date.newinstance(2010,7,4);
            if(resdentialDate.monthsBetween(todayDate)>=6)
            {
                return true;
            }
        } 
        return false; 
    }
    //Calculation for 100 installs
    public static Boolean computeHUNDREDINSTALLSASPREM( Id accountID){
        String year=''+date.newinstance(2010,7,4).year();
        String currentQuarter = getCurrentQuarter();
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
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
        String year=''+date.newinstance(2010,7,4).year();
        String currentQuarter = getCurrentQuarter();
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
        List<order_detail_sunrise2__c> orderDetail = [select Cumulative_kW_for_Commercial_Orders__c,Cumulative_kW_for_Residential_Orders__c,Cumulative_No_of_Residential_PV_orders__c,Cumulative_No_of_Commercial_PV_orders__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and Year__c=:year];//Quarter__c =:currentQuarter to performance period
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
        return false;
    }
    
    public static Boolean computeSIXMONTHSASAUTHWITHTWENTYINSTALLORTWOHUNDREDKWS( Id accountID){
        String currentQuarter = getCurrentQuarter();
        String year=''+date.newinstance(2010,7,4).year();
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
        List<order_detail_sunrise2__c> orderDetail = [select Cumulative_No_of_Residential_PV_orders__c,Cumulative_No_of_Commercial_PV_orders__c,Cumulative_kW_for_Commercial_Orders__c,Cumulative_kW_for_Residential_Orders__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and Year__c=:year]; //Quarter__c =:currentQuarter to performance period
        if(orderDetail.size() > 0)
        {
            Account accObj=[select Authorized_Partner_Date__c from account where id=:accountId];
            if(accObj.Authorized_Partner_Date__c!=null)
            {
                Date resdentialDate=accObj.Authorized_Partner_Date__c;
                Date todayDate=date.newinstance(2010,7,4);
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
    
    public static Boolean computeMINSALESAUTHZEU( Id accountID){
        Account accObj=[select  Residential_Installer_Date__c from account where id=:accountId];
        String year=''+date.newinstance(2010,7,4).year();
        if(accObj.Residential_Installer_Date__c!=null)
        {
            Date resdentialDate=accObj.Residential_Installer_Date__c;
            Date todayDate=date.newinstance(2010,7,4);
            Integer resMonth=todayDate.month();
            Integer todayMonth=resdentialDate.month();
            if(resdentialDate.monthsBetween(todayDate)>=3)
            {
                String currentQuarter = getCurrentQuarter();
                String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
                List<order_detail_sunrise2__c> orderDetail = [select Cumulative_No_of_Residential_PV_orders__c,Cumulative_No_of_Commercial_PV_orders__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and Year__c=:year];//Quarter__c =:currentQuarter to performance period
                if(orderDetail.size() > 0)
                {
                    if(orderDetail.get(0).Cumulative_No_of_Residential_PV_orders__c!=null && orderDetail.get(0).Cumulative_No_of_Commercial_PV_orders__c!=null)
                    {
                        if((orderDetail.get(0).Cumulative_No_of_Residential_PV_orders__c + orderDetail.get(0).Cumulative_No_of_Commercial_PV_orders__c) >= 8){
                            return true;
                        }
                    }
                }
            }
        }
        return false;
    }
    
    // method changed for Phase2a - No of rows in oracle changed. 
    public static Boolean computeACTIVEDEALER(Id accountId,Date validFrom,Date validTo){
        String currentQuarter = getCurrentQuarter();
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
        String year=''+date.newinstance(2010,7,4).year();
        List<order_detail_sunrise2__c> orderDetail = [select Number_of_QTD_Residential_PV_Order__c,Number_of_QTD_Commercial_PV_Order__c,QTD_kW_for_Residential_Orders__c,QTD_kW_for_Commercial_Orders__c,Cumulative_kW_for_Commercial_Orders__c,Cumulative_kW_for_Residential_Orders__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod  and Year__c=:year];// Changed Quarter__c in : quarters to =:currentQuarter and Quarter__c =:currentQuarter to performance period
        if(orderDetail!=null && orderDetail.size() > 0)
        {
            Double qtdResPv=0;
            Double qtdKw=0;
           
                if(orderDetail.get(0).Number_of_QTD_Residential_PV_Order__c!=null && orderDetail.get(0).Number_of_QTD_Commercial_PV_Order__c!=null)
                    qtdResPv=orderDetail.get(0).Number_of_QTD_Residential_PV_Order__c + orderDetail.get(0).Number_of_QTD_Commercial_PV_Order__c; //qtdResPv+(
                if(orderDetail.get(0).Cumulative_kW_for_Residential_Orders__c!=null && orderDetail.get(0).Cumulative_kW_for_Commercial_Orders__c!=null)
                    qtdKw=orderDetail.get(0).Cumulative_kW_for_Residential_Orders__c + orderDetail.get(0).Cumulative_kW_for_Commercial_Orders__c; //qtdKw+(
            
            if(qtdResPv >= 6){
                return true;
            }
            else if(qtdKw >= 60){
                return true;
            }
        }
        return false;
    }
    // method changed for Phase2a - No of rows in oracle change
    public static Boolean computeMINQUATSALESEUCLONE(Id accountId,Date validFrom,Date validTo){
        String currentQuarter = getCurrentQuarter();
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
        String year=''+date.newinstance(2010,7,4).year();
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
        String year=''+date.newinstance(2010,7,4).year();
        if(accObj.Residential_Installer_Date__c!=null)
        {
            Date resdentialDate=accObj.Residential_Installer_Date__c;
            String currentQuarter = getCurrentQuarter();
            String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
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
        String year=''+date.newinstance(2010,7,4).year();
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
        List<order_detail_sunrise2__c> orderDetail = [select Cumulative_No_of_Commercial_PV_orders__c,Cumulative_No_of_Residential_PV_orders__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and Year__c=:year];//Quarter__c =:currentQuarter to performance period
        if(orderDetail.size()>0)
        {
            if(orderDetail.get(0).Cumulative_No_of_Commercial_PV_orders__c!=null && orderDetail.get(0).Cumulative_No_of_Residential_PV_orders__c!=null ){
                Double comercialCum=orderDetail.get(0).Cumulative_No_of_Commercial_PV_orders__c;
                Double resCom=orderDetail.get(0).Cumulative_No_of_Residential_PV_orders__c;
                if((comercialCum+resCom)>=100)
                {
                    return true;
                }
            }
        }
        return false;
    }
   
   // method changed for Phase2a - No of rows in oracle changed. 
   public static Double computeSEVENTYSALESKITS(Id accountId,Date validFrom,Date validTo){
        String currentQuarter = getCurrentQuarter();
        Double qtdResSmartPck=0;
        String year=''+date.newinstance(2010,7,4).year();
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
        List<order_detail_sunrise2__c> orderDetail = [select QTD_of_Residential_SmartPack_orders__c,QTD_of_Commercial_orders_with_Inverter__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod  and Year__c=:year];// Changed Quarter__c in : quarters to =:currentQuarter and Quarter__c =:currentQuarter to performance period
        if(orderDetail.size() > 0)
        {
            
            Double commInver=0;
            
                if(orderDetail.get(0).QTD_of_Residential_SmartPack_orders__c!=null)
                qtdResSmartPck=orderDetail.get(0).QTD_of_Residential_SmartPack_orders__c; //qtdResSmartPck+
               
        }
          return qtdResSmartPck;
    }
    
    // method changed for Phase2a - No of rows in oracle changed.
    public static Double computeSEVENTYRESKITSEU(Id accountId,Date validFrom,Date validTo){  // return type changed from boolean to double
        String currentQuarter = getCurrentQuarter(); 
        String year=''+date.newinstance(2010,7,4).year();
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
        
            
       }
        
    
    // method changed for Phase2a - No of rows in oracle changed.
    public static Double computeSEVENTYCOMINVTREU(Id accountId,Date validFrom,Date validTo){  // return type changed from boolean to double
        String currentQuarter = getCurrentQuarter(); 
        String year=''+date.newinstance(2010,7,4).year();
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
        List<order_detail_sunrise2__c> orderDetail = [select QTD_of_Residential_SmartPack_orders__c,QTD_of_Commercial_orders_with_Inverter__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and Year__c=:year]; // Changed Quarter__c in : quarters to =:currentQuarter and Quarter__c =:currentQuarter to performance period
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
        String year=''+date.newinstance(2010,7,4).year();
        List<order_detail_sunrise2__c> orderDetail = [select QTD_Net_Purchase_Amount__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and Year__c=:year];// Changed Quarter__c in : quarters to =:currentQuarter and Quarter__c =:currentQuarter to performance period
        Double target=0;
        if(orderDetail.size() > 0)
        {
                if(orderDetail.get(0).QTD_Net_Purchase_Amount__c!=null)
                target = orderDetail.get(0).QTD_Net_Purchase_Amount__c;
           
        }
        return target;
    }
    
     // method changed for Phase2a - No of rows in oracle changed.
     public static Double computeKWTARGETEU(Id accountId,Date validFrom,Date validTo){
        String currentQuarter = getCurrentQuarter(); 
        String year=''+date.newinstance(2010,7,4).year();
        String performancePeriod = getCurrentPerformancePeriod(currentQuarter);
        List<order_detail_sunrise2__c> orderDetail = [select QTD_kW_for_Commercial_Orders__c,QTD_kW_for_Residential_Orders__c,Cumulative_kW_for_Commercial_Orders__c, Cumulative_kW_for_Residential_Orders__c from order_detail_sunrise2__c where Account_Name__c=:accountID and Performance_Period__c =:performancePeriod and Year__c=:year]; // Changed Quarter__c in : quarters to =:currentQuarter and Quarter__c =:currentQuarter to performance period
        Double qtdKw=0;
        if(orderDetail.size() > 0){
            
                if(orderDetail.get(0).Cumulative_kW_for_Residential_Orders__c!=null && orderDetail.get(0).Cumulative_kW_for_Commercial_Orders__c!=null)
                qtdKw=orderDetail.get(0).Cumulative_kW_for_Residential_Orders__c + orderDetail.get(0).Cumulative_kW_for_Commercial_Orders__c; //qtdKw+(
           
        }
        return qtdKw;
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
        Date tDate = date.newinstance(2010,7,4);
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
   
    public static void automatedDoubleGoalCheck(Metric__c m,Metric_Tier_Relation__c mtr,Double achieve){
        m.Achievement_Value__c = achieve;
        Double min=mtr.Metric_Min_Value__c;
        Double max=mtr.Metric_Max_Value__c;
        Boolean goalMet=PerformanceAchievementClass.checkGoalMet(min,max,achieve);
        m.Goal_Met__c=goalMet;
    }
    
    public static void automatedBooleanGoalCheck(Metric__c m,Metric_Tier_Relation__c mtr,Boolean achieve){
        m.Boolean_Achievement__c = achieve;
        m.Goal_Met__c=achieve;
    }
    
    public static void automatedDoubleGoalCheckKW(Metric__c m,Metric_Tier_Relation__c mtr,Double achieve){
        m.Achievement_Value__c = achieve;
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
    
    /******* UTIL FUNCTIONS ******************/
    
    
    
    
    

}