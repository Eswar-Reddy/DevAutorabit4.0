public class UandCDealSheet_CC {
    
    public String quoteIdValue {get; set;}  //relatedToType (Quote) Id Value holder 
    public String opportunityIdValue {get; set;} //Opportunity Id Value holder
    
    public Quote quoteDetails { //Quote record details holder
        get { 
            List<Quote> lstQuote = [SELECT Id, Opportunity.Name, Business_Unit__c, Opportunity.Owner.Name, Opportunity.CloseDate, Opportunity.Expected_Commercial_Operation_Date__c,
                                        Opportunity.Probability, Opportunity.StageName, Opportunity.Customer_Funding_Type__c, Opportunity.Contract_Type__c, CurrencyISOCode,
                                        TotalPrice, Total_Cost__c, Opportunity.Net_Present_Value__c, Opportunity.NPV_W__c, ASP_Formula__c, BOS_w_Formula__c, 
                                        PV_w_Formula__c, System_Size_PV_Formula__c, Opportunity.Selling_Strategy__c, Opportunity.My_Position_vs_Competition__c, Opportunity.Project_Margin_Risks__c,
                                        Opportunity.Closure_Deal_Risks__c, Opportunity.Actions_Remaining_to_Close_Deal__c, DirectMargin_per__c, Direct_Margin__c
                                    FROM Quote 
                                    WHERE Id =: quoteIdValue];  
            
            if (!lstQuote.isempty() && quoteDetails == null) quoteDetails = lstQuote[0];
            
            else quoteDetails = new Quote();
            
            return quoteDetails;

        } 
        set;
    } 
    
    public List<QuoteLineItem> mountingSysQueryList{ //Query for Mounting System
    
        get{
            List<QuoteLineItem> mountingSysList = [SELECT Id, Product_Family__c, Product_Name__c, Product_Type__c, PriceBookEntry.Name
                                                   FROM QuoteLineItem
                                                   WHERE Quote.Id =: quoteIdValue
                                                   AND (Product_Family__c LIKE '%Mounting System%')];
                                                   
            mountingSysQueryList = mountingSysList;
            return mountingSysQueryList;
        }
        set;
    
    }
    
    public List<QuoteLineItem> pvModuleQueryList{ //Query for PV Module
    
        get{
            List<QuoteLineItem> pvModuleList = [SELECT Id, Product_Family__c, Product_Name__c, Product_Type__c, PriceBookEntry.Name
                                                   FROM QuoteLineItem
                                                   WHERE Quote.Id =: quoteIdValue
                                                   AND (Product_Type__c = 'PV Module')];
                                                   
            pvModuleQueryList = pvModuleList;
            return pvModuleQueryList;
        }
        set;
    
    }
    
    public List<OpportunityTeamMember> teamMemberQueryList{
        get{
            List<OpportunityTeamMember> lstOppTeamMember = [SELECT Id, User.Name, TeamMemberRole
                                                            FROM OpportunityTeamMember 
                                                            WHERE OpportunityId =: opportunityIdValue 
                                                            AND (TeamMemberRole = 'Sales Analyst' 
                                                            OR TeamMemberRole = 'Project Manager' 
                                                            OR TeamMemberRole = 'Structured Finance' 
                                                            OR TeamMemberRole = 'Designer')];
                                                                 
                                                                 
                                                                 
            teamMemberQueryList = lstOppTeamMember;
            
            return teamMemberQueryList;
        }
        set;
    }
    
    
    public String salesAnalystVals {    //Opportunity Team Members with "Sales Analyst" Role
        
        get{
            String querySalesAnalystRole = '';
        
            if(!teamMemberQueryList.isEmpty()){
                for(OpportunityTeamMember oppTeamSales: teamMemberQueryList){
                    if(oppTeamSales.TeamMemberRole == 'Sales Analyst'){
                    if(querySalesAnalystRole.length() > 0 ) {
                        querySalesAnalystRole += ', ';
                    }
                    
                        querySalesAnalystRole += oppTeamSales.User.Name;
                        // remove last additional comma from string
                        querySalesAnalystRole = querySalesAnalystRole.subString(0,querySalesAnalystRole.length()); 
                    }
                                       
                }
            }

            salesAnalystVals = querySalesAnalystRole;
            
            return salesAnalystVals;
        }
        set;
    }
    
    public String projectManagerVals {  //Opportunity Team Members with "Project Manager" Role
        
        get{
            String queryProjectManagerRole = '';

            if(!teamMemberQueryList.isEmpty()){
                for(OpportunityTeamMember oppTeamProjMan: teamMemberQueryList){
                    if(oppTeamProjMan.TeamMemberRole == 'Project Manager'){
                    if(queryProjectManagerRole.length() > 0) {
                        queryProjectManagerRole += ', ';
                        
                    }
                        queryProjectManagerRole += oppTeamProjMan.User.Name;
                        // remove last additional comma from string
                        queryProjectManagerRole = queryProjectManagerRole.subString(0,queryProjectManagerRole.length());
                    }
                }
            }
            
            projectManagerVals = queryProjectManagerRole;
            
            return projectManagerVals;
        }
        set;
    }
    
    public String structuredFinanceVals {   //Opportunity Team Members with "Structured Finance" Role
        
        get{
            String queryStructuredFinanceRole = '';

            if(!teamMemberQueryList.isEmpty()){
                for(OpportunityTeamMember oppStrucFin: teamMemberQueryList){
                    if(oppStrucFin.TeamMemberRole == 'Structured Finance'){
                        if(queryStructuredFinanceRole.length() > 0) {
                            queryStructuredFinanceRole += ', ';
                        }
                        queryStructuredFinanceRole += oppStrucFin.User.Name;
                        // remove last additional comma from string
                        queryStructuredFinanceRole = queryStructuredFinanceRole.subString(0,queryStructuredFinanceRole.length());
                    }
                }
            }
            
            structuredFinanceVals = queryStructuredFinanceRole;
            
            return structuredFinanceVals;
        }
        set;
    }
    
    public String designerVals {    //Opportunity Team Members with "Designer" Role
        
        get{
            String queryDesignerRole = '';
            
            if(!teamMemberQueryList.isEmpty()){
                for(OpportunityTeamMember oppdesigner: teamMemberQueryList){
                    if(oppdesigner.TeamMemberRole == 'Designer'){
                        if(queryDesignerRole.length() > 0) {
                            queryDesignerRole += ', ';
                        }
                        queryDesignerRole += oppdesigner.User.Name;
                        // remove last additional comma from string
                        queryDesignerRole = queryDesignerRole.subString(0,queryDesignerRole.length());
                    }
                }
            }
            designerVals = queryDesignerRole;
            
            return designerVals;
        }
        set;
    }
    
    public String mountingSystemVals {
    
         get{
            String queryMountingSys = '';
            
            if(!mountingSysQueryList.isEmpty()){
                for(QuoteLineItem mountStys: mountingSysQueryList){
                    if(queryMountingSys.length() > 0) {
                        queryMountingSys += ', ';
                    }
                        queryMountingSys += mountStys.PriceBookEntry.Name;
                        // remove last additional comma from string
                        queryMountingSys = queryMountingSys.subString(0,queryMountingSys.length());
                }
            }
            mountingSystemVals = queryMountingSys;
            
            return mountingSystemVals;
        }
        set;
    
    }
    
    public String pvModuleVals {
    
         get{
            String queryPVModule = '';
            
            if(!pvModuleQueryList.isEmpty()){
                for(QuoteLineItem pvModule: pvModuleQueryList){
                    if(queryPVModule.length() > 0) {
                        queryPVModule += ', ';
                    }
                       queryPVModule += pvModule.PriceBookEntry.Name;
                        // remove last additional comma from string
                        queryPVModule = queryPVModule.subString(0,queryPVModule.length());
                }
            }
            pvModuleVals = queryPVModule;
            
            return pvModuleVals;
        }
        set;
    
    }
}