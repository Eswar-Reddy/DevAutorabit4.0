/* Pivotal Tracker Updates:
 * Commercial workstream: #120804611 - Create a Customer Survey Record Type for Commercial WW39 - 2016
 *   added logic to separate residential and commercial survey results 
 * 
 *   
 *
*/

public without Sharing class SurveyUtility
{
//===============================================>SALES SURVEY
    //Sales Survey
    public static void createSalesSurvey(Map<Id, Opportunity> newMapOpportunities)
    {
        List<Post_Visit_Follow_Up_Survey__c> listSalesSurvey = new List<Post_Visit_Follow_Up_Survey__c>(); //Holder for newly created Post_Visit_Follow_Up_Survey__c record
      
        Map<Id, Opportunity> mapOpportunityDetails = new Map<Id,Opportunity>([SELECT Id, PartnerAccountId,Partner_Account_Id__c,
                                                                                                                                  AccountId,Primary_Contact__c,//Added Primary_Contact__c,AccountId
                                                                                                                                  Alliance_Program_Lead__c, 
                                                                                                                     (SELECT id, Status_Survey__c  FROM Post_Visit_Follow_Up_Surveys__r) 
                                                                                                                       FROM Opportunity WHERE Id IN: newMapOpportunities.keyset()]); 
                                                                                       
        for(Id oppId: newMapOpportunities.keySet())
        {
            Opportunity opp = newMapOpportunities.get(oppId);
            Opportunity newOppDet = mapOpportunityDetails.get(opp.Id);
            List<Post_Visit_Follow_Up_Survey__c> listExistingSurvey = newOppDet.Post_Visit_Follow_Up_Surveys__r;
            
            //If no survey created for this Opp yet
            if(listExistingSurvey.isEmpty()){            
                listSalesSurvey.add(new Post_Visit_Follow_Up_Survey__c(Opportunity_ID__c = opp.id,                                                                      
                                                                      Partner_Account__c = (opp.PartnerAccountId != null) ? opp.PartnerAccountId : opp.Partner_Account_Id__c,
                                                                      Customer_Contact__c = opp.Primary_Contact__c, 
                                                                      Customer_Account__c = opp.AccountId,
                                                                      Survey_Channel__c = 'Email', 
                                                                      Name = 'Sales Survey for ' + opp.Name,
                                                                      Opportunity_Creation_Date__c = opp.createdDate
                                                                      //Opportunity_Alliance_Program_Lead__c = opp.Alliance_Program_Lead__c,
                                                                      ));                                                                   
            }
            else
            {            
                for(Post_Visit_Follow_Up_Survey__c salesSurvey: listExistingSurvey){
                    salesSurvey.Partner_Account__c = (opp.PartnerAccountId != null) ? opp.PartnerAccountId : opp.Partner_Account_Id__c;
                    salesSurvey.Customer_Contact__c = opp.Primary_Contact__c;
                    salesSurvey.Customer_Account__c = opp.AccountId;
                    //salesSurvey.Opportunity_Alliance_Program_Lead__c = opp.Alliance_Program_Lead__c;
                    listSalesSurvey.add(salesSurvey);               
                }
          
            }
        }
        /* If valid records got created insert Sales Survey */
        try{
        if(!listSalesSurvey.isEmpty()){
            upsert listSalesSurvey;        
        }}
        Catch(Exception ex)
        {
            
        }            
            
     //Insert dt;     
    }//End Func createSalesSurvey
//===============================================>INSTALL SURVEY
    public static void createInstallSurvey(Map<Id, Opportunity> newMapOpportunities)
    {
        List<Customer_Survey_Result__c> listInstallSurvey = new List<Customer_Survey_Result__c>(); //Holder for newly created Customer_Survey_Result__c record
        Id resiSurveyRecTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Customer_Survey_Result__c.SobjectType).get('Residential'); //#120804611

        Map<Id, Opportunity> mapOpportunityDetails = new Map<Id,Opportunity>([SELECT Id, PartnerAccountId, PartnerAccount.Theater__c, AccountId,
                                                                                     Primary_Contact__c,
                                                                                     (SELECT Id FROM Customer_Survey_Results__r 
                                                                                      WHERE RecordTypeId =: resiSurveyRecTypeId) 
                                                                              FROM Opportunity 
                                                                              WHERE Id IN: newMapOpportunities.keyset()]);
                                                                                        
        for(Id oppId: newMapOpportunities.keySet()){
            Opportunity opp = newMapOpportunities.get(oppId);
            if(!mapOpportunityDetails.containsKey(opp.Id))
                return;
            List<Customer_Survey_Result__c> listExistingSurvey = new List<Customer_Survey_Result__c>(mapOpportunityDetails.get(opp.Id).Customer_Survey_Results__r);
                        
            //If no survey created for this Opp yet
            if(listExistingSurvey.isEmpty()){               
                    Customer_Survey_Result__c newCustomerSurvey;                
                    if(opp.Lease__c && opp.Lease_Placed_in_Service__c)
                    {//For Lease  
                        newCustomerSurvey = new Customer_Survey_Result__c(Partner_Account__c = (opp.PartnerAccountId != null) ? opp.PartnerAccountId : opp.Partner_Account_Id__c ,
                                                                            Opportunity_ID__c = opp.Id,
                                                                            Contact__c = opp.Primary_Contact__c,
                                                                            Account1__c = opp.AccountId,
                                                                            Primary_Contact_Email__c = opp.Primary_Contact_Email__c,
                                                                            Lease__c = true,
                                                                            Cash__c = false,
                                                                            RecordTypeId = resiSurveyRecTypeId); //#120804611                  
                    }
                    else if(!opp.Lease__c && !opp.Lease_Placed_in_Service__c)
                    {//For Cash
                    newCustomerSurvey = new Customer_Survey_Result__c(Partner_Account__c = (opp.PartnerAccountId != null) ? opp.PartnerAccountId : opp.Partner_Account_Id__c ,
                                                                            Opportunity_ID__c = opp.Id,
                                                                            Contact__c = opp.Primary_Contact__c,
                                                                            Account1__c = opp.AccountId,
                                                                            Primary_Contact_Email__c = opp.Primary_Contact_Email__c,
                                                                            Lease__c = false,
                                                                            Cash__c = true,
                                                                            RecordTypeId = resiSurveyRecTypeId); //#120804611
                    }
                    if(newCustomerSurvey != null)
                        listInstallSurvey.add(newCustomerSurvey);        
            }
            else
            {      
                for(Customer_Survey_Result__c customerSurvey: listExistingSurvey)
                {
                    customerSurvey.Partner_Account__c= (opp.PartnerAccountId != null) ? opp.PartnerAccountId : opp.Partner_Account_Id__c;
                    customerSurvey.Opportunity_ID__c= opp.Id;
                    customerSurvey.Contact__c= opp.Primary_Contact__c;
                    customerSurvey.Account1__c= opp.AccountId;
                    customerSurvey.Primary_Contact_Email__c= opp.Primary_Contact_Email__c;
                    
                    if(opp.Lease__c && opp.Lease_Placed_in_Service__c)
                    {//For Lease                
                        customerSurvey.Lease__c= true;
                        customerSurvey.Cash__c= false;
                    }
                    else if(!opp.Lease__c && !opp.Lease_Placed_in_Service__c)
                    {//For Cash
                        customerSurvey.Lease__c= false;
                        customerSurvey.Cash__c= true;
                    }                   
                    listInstallSurvey.add(customerSurvey);              
                }          
            }
        }
         /* If valid records got created insert Install Survey*/
        try{
        if(!listInstallSurvey.isEmpty())
        {
            upsert listInstallSurvey; 
        }}
        Catch(Exception ex){
            
        }
    }//End Func createInstallSurvey
//===============================================>1 YEAR SURVEY
    //1Y Check In Survey
    public static void create1YCheckInSurvey(Map<Id, Opportunity> newMapOpportunities){
  
        List<X1Y_Satisfaction_Survey_Result__c> list1YearSurvey = new List<X1Y_Satisfaction_Survey_Result__c>(); //Holder for newly created X1Y_Satisfaction_Survey_Result__c record
         
        Map<Id, Opportunity> mapOpportunityDetails = new Map<Id,Opportunity>([SELECT Id, PartnerAccountId,
                                                                                                                                  PartnerAccount.Theater__c,
                                                                                                                                  AccountId,Primary_Contact__c,//Added Primary_Contact__c,AccountId
                                                                                     (SELECT id FROM X1Y_Satisfaction_Survey_Results__r)   
                                                                              FROM Opportunity 
                                                                              WHERE Id IN: newMapOpportunities.keyset()]); 
                                                                              
                                                                       
                                                                                        
        for(Id oppId: newMapOpportunities.keySet())
        {
            Opportunity opp = newMapOpportunities.get(oppId);
            Opportunity newOppDet = mapOpportunityDetails.get(opp.Id);
            List<X1Y_Satisfaction_Survey_Result__c> listExistingSurvey = newOppDet.X1Y_Satisfaction_Survey_Results__r;
            
            //If no survey created for this Opp yet
            if(listExistingSurvey.isEmpty())
            {

                    X1Y_Satisfaction_Survey_Result__c new1YearSurvey ;
                
                    if(opp.Lease__c && opp.Lease_Placed_in_Service__c)
                    {//For Lease 
                            new1YearSurvey = new X1Y_Satisfaction_Survey_Result__c(Partner_Account__c =  (opp.PartnerAccountId != null) ? opp.PartnerAccountId : opp.Partner_Account_Id__c ,
                                                                                                Opportunity__c = opp.Id,
                                                                                                Contact__c = opp.Primary_Contact__c,
                                                                                                Customer_Account__c = opp.AccountId,
                                                                                                Primary_Contact_Email__c = opp.Primary_Contact_Email__c,
                                                                                                Theater__c  = opp.Theater__c,
                                                                                                Lease__c = true,
                                                                                                Cash__c = false
                                                                                                );                  
                    }
                    else if(!opp.Lease__c && !opp.Lease_Placed_in_Service__c)
                    {//For Cash
                            new1YearSurvey = new X1Y_Satisfaction_Survey_Result__c( Partner_Account__c =  (opp.PartnerAccountId != null) ? opp.PartnerAccountId : opp.Partner_Account_Id__c ,
                                                                                                Opportunity__c = opp.Id,
                                                                                                Contact__c = opp.Primary_Contact__c,
                                                                                                Customer_Account__c = opp.AccountId,
                                                                                                Primary_Contact_Email__c = opp.Primary_Contact_Email__c,
                                                                                                Theater__c  = opp.Theater__c,
                                                                                                Lease__c = false,
                                                                                                Cash__c = true                                                                              
                                                                                                );                  

                    }
                    list1YearSurvey.add(new1YearSurvey);        
            }
            else
            {            
                for(X1Y_Satisfaction_Survey_Result__c oneYearSurvey: listExistingSurvey)
                {
                    oneYearSurvey.Partner_Account__c=  (opp.PartnerAccountId != null) ? opp.PartnerAccountId : opp.Partner_Account_Id__c;
                    oneYearSurvey.Opportunity__c= opp.Id;
                    oneYearSurvey.Contact__c= opp.Primary_Contact__c;
                    //oneYearSurvey.Customer_Account__c= opp.AccountId;
                    oneYearSurvey.Primary_Contact_Email__c= opp.Primary_Contact_Email__c;
                    
                    if(opp.Lease__c && opp.Lease_Placed_in_Service__c)
                    {//For Lease                
                        oneYearSurvey.Lease__c= true;
                        oneYearSurvey.Cash__c= false;
                    }
                    else if(!opp.Lease__c && !opp.Lease_Placed_in_Service__c)
                    {//For Cash
                        oneYearSurvey.Lease__c= false;
                        oneYearSurvey.Cash__c= true;
                    }                   
                    list1YearSurvey.add(oneYearSurvey);              
                }          
            }
        }
        /*
         * If valid records got created insert Install Survey
         */
        try{
        if(!list1YearSurvey.isEmpty())
        {
            upsert list1YearSurvey;        
        }}
        Catch(Exception ex){
            
        }
    }//End Func create1YCheckInSurvey

    public Static Boolean isValidOppForSurvey(Opportunity opp) {
        Boolean retValue = false;
        
        if (opp.AccountId != null && 
            String.isNotBlank(opp.Customer_Country__c) && 
            String.isNotBlank(opp.Primary_Contact__c) &&       
            String.isNotBlank(opp.Primary_Contact_Email__c)) {

            retValue = true;                
        }          
        
        return retValue;
    } 

    public Static Boolean isValidOppForSalesSurvey(Opportunity opp) {
        Boolean retValue = false;
        
        Set<String> setValidBillingCountryForSaleSurvey = new Set<String>();
        for(Survey_Countries__c sc:Survey_Countries__c.getall().values()) {
            if(sc.Sales_Survey__c == true) {
                setValidBillingCountryForSaleSurvey.add(sc.Name);
            }    
        }

        System.debug('setValidBillingCountryForSaleSurvey is ----- '+setValidBillingCountryForSaleSurvey);

        if(SurveyUtility.isValidOppForSurvey(opp)) {       
            if (opp.Lead_Manufacturer__c == 'SunPower' && 
                opp.StageName != 'Installation Completed' &&                 
                opp.CreatedDate > Date.newInstance(2013,1,1) &&
                opp.Customer_Country__c != null && setValidBillingCountryForSaleSurvey.contains(opp.Customer_Country__c)) {
                    
                retValue = true;        
            }                   
        } 
        return retValue;       
    } 

    public Static Boolean isValidOppForInstallSurvey(Opportunity opp) {
        Boolean retValue = false;
        
        Set<String> setValidBillingCountryForInstallSurvey = new Set<String>();
        for(Survey_Countries__c sc:Survey_Countries__c.getall().values()) {
            if(sc.Install_Survey__c==true) {
                setValidBillingCountryForInstallSurvey.add(sc.Name);
            }    
        }

        System.debug('setValidBillingCountryForInstallSurvey is ----- '+setValidBillingCountryForInstallSurvey);

        // Nathan. included partner account SPD check 
        // case# 00540076 Modify Trigger for Install Survey for Cash 

        if(SurveyUtility.isValidOppForSurvey(opp)) {
            if (opp.Customer_Satisfaction_Survey_opt_in__c &&                   
                opp.stageName == 'Installation Completed' &&
                opp.Customer_Country__c != null && setValidBillingCountryForInstallSurvey.contains(opp.Customer_Country__c) &&
                opp.Installation_Completed_Date__c > System.today()-180) {

                if (isCashSurvey(opp)) {
                    if (isSPDPartnerAccount(opp)) {
                        if (opp.Date_PTO_Letter_Received_Promised__c != null && opp.Date_PTO_Letter_Received_Promised__c <= system.today()) {
                            retValue = true;
                        }
                    } else {
                        retValue = true;
                    }
                } else {
                    retValue = true;                     
                }                
            }             
        }
        
        return retValue;       
    }
    
    public Static Boolean isValidOppFor1YrSurveys(Opportunity opp) {
        Boolean retValue = false;

        Set<String> setValidBillingCountryFor1YrSurvey = new Set<String>();
        for(Survey_Countries__c sc:Survey_Countries__c.getall().values()){
            if(sc.One_Year_Survey__c==true) {
                setValidBillingCountryFor1YrSurvey.add(sc.Name);
            }    
        }

        System.debug('setValidBillingCountryFor1YrSurvey is ----- '+setValidBillingCountryFor1YrSurvey);
        
        // Nathan. included partner account SPD check 
        // case# 00540076 Modify Trigger for Install Survey for Cash 
        
        if(SurveyUtility.isValidOppForSurvey(opp)) {
            if (opp.Customer_Satisfaction_Survey_opt_in__c &&                   
                opp.stageName == 'Installation Completed' &&
                opp.Customer_Country__c != null && setValidBillingCountryFor1YrSurvey.contains(opp.Customer_Country__c)) {
                
                if (isCashSurvey(opp)) {
                    if (isSPDPartnerAccount(opp)) {
                        if (opp.Date_PTO_Letter_Received_Promised__c != null && opp.Date_PTO_Letter_Received_Promised__c <= system.today()) {
                            retValue = true;
                        }
                    } else {
                        retValue = true;
                    }
                } else {
                    retValue = true;                     
                }                
            }             
        }
        return retValue;       
    } 

    private static Boolean isCashSurvey(Opportunity opp) {
        Boolean retValue = false;    

        if (!opp.Lease__c && !opp.Lease_Placed_in_Service__c) {
            retValue = true;
        }
        
        return retValue;
    }
        
    private static Boolean isSPDPartnerAccount(Opportunity opp) {
        Boolean retValue = false;    
        
        // get spd ids from custom label
        Set <String> spdIdsSet = new Set <String>();
        String spdIds = System.Label.SPDIds;
        if (spdIds != null) {
            for (String spdId : spdIds.split(',')) {
                if (String.IsNotBlank(spdId)) {
                    spdIdsSet.add(spdId.trim());
                }
            }
        } 
        
        if (opp != null && opp.Partner_Account_Id__c != null) {
            // take care of 18 or 15 char ids
            if (spdIdsSet.contains(opp.Partner_Account_Id__c) || spdIdsSet.contains(String.valueOf(opp.Partner_Account_Id__c).left(15)) ||
                (opp.Partner_Account_text__c != null && opp.Partner_Account_text__c.contains('(SPD)'))) {   
                retValue = true;
            }
        }
        
        return retValue;    
    }
      

}//End Class SurveyUtility