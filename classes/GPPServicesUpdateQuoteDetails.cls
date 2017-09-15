@RestResource(urlMapping='/SPWRQuote/UpdateQuoteDetails/*')
global class GPPServicesUpdateQuoteDetails
{
/******* SERVICE: POST : start *******/

    @HttpPost
    global static WResponse UpdateQuote()
    {
        RestRequest req= RestContext.request;
        WResponse wRes= new WResponse();
            wRes.Success= false;
            wRes.Messages= new List<String>();
        
        //>>> Fetch predefined error messages
        Map<Integer, String> mapErrors= GPPServicesUpdateQuoteDetails.mapErrors();   
SYSTEM.DEBUG('## 8 ## ' + JSON.serialize(req));         
        if(req.requestBody != null)
        {
SYSTEM.DEBUG('## 9 ##');        
            String sJsonData= req.requestBody.toString();
SYSTEM.DEBUG('## 10 ##');
            if(String.isNotBlank(sJsonData))
            {
SYSTEM.DEBUG('## 11 ##');            
                GPPUpdateQuoteAPIPayloadParser updateQ= GPPUpdateQuoteAPIPayloadParser.parse(sJsonData);
                if(updateQ != null && updateQ.Quote != null && updateQ.Quote.QuoteNumber != null)
                {
SYSTEM.DEBUG('## 12 ##');                
                        
                    //>>> Get the data from Quote
                        String sWhereClauseQuote= 'WHERE QuoteNumber=\'' + updateQ.Quote.QuoteNumber + '\'';
                        List<Quote> lstQot= GPPQueryHelper.GetQuotes(sWhereClauseQuote);
SYSTEM.DEBUG('## 13 ##' + lstQot);                    
                    //>>> Validation set for payload's FinacingType attribute. FinacingType ==maps to=> Quote-> QuoteType__c
                        Set<String> setQuoteType= new Set<String>{'Lease', 'Cash'};
                    ////COmment line 46, as this maps to a different field: 12 June 2014    
                    //>>> Validation map for payload's FinancingTerm attribute. FinancingTerm ==maps to==> Quote-> Loan_Term__c
                    ////    Map<Integer, String> mapLoanTerm= new Map<Integer, String>{5=>'5 Years', 10=>'10 Years', 15=>'15 Years', 20=>'20 Years' ,25=>'25 Years'};
                    //>>> Validation set for XQuoteType attribute, QuoteType ==maps to==> Quote--> Quote_type__c
                        Set<String> setXQuoteType = new Set<String>{'Quote with Sales Services - First', 'Quote with Sales Services - Requote', 'Quote with Additional Services- First', 'Quote with Additional Services - Requote', 'RFP Quote - First', 'RFP Quote - Requote', 'Quote Number Retired', 'Residential Lease Quotation'};
                        
                    if(lstQot != null && !lstQot.isEmpty())
                    {
                        Attachment AttachResponse = new Attachment(name='GPP_PayLoad', parentid=lstQot[0].id,body =Blob.valueof(sJsonData));
                        insert AttachResponse;
                    //>> Processing Quote
                        lstQot[0].Date_Modified__c= Date.Today();
                        lstQot[0].Quote_type__c= (GPPServicesUpdateQuoteDetails.CheckString(updateQ.Quote.XQuoteType) != '' && setXQuoteType.contains(updateQ.Quote.XQuoteType) ? updateQ.Quote.XQuoteType : null);
                        lstQot[0].Is_Locked__c= (updateQ.Quote.IsLocked != null ? updateQ.Quote.IsLocked : false);
                        lstQot[0].Is_Quote_Locked__c= (updateQ.Quote.IsLocked != null ? updateQ.Quote.IsLocked : false);
                        lstQot[0].Description= GPPServicesUpdateQuoteDetails.CheckString(updateQ.Quote.Description);
                        lstQot[0].QuoteType__c= (setQuoteType.contains(updateQ.Quote.FinancingType) ? updateQ.Quote.FinancingType : null);
                        //lstQot[0].Loan_Term__c= (mapLoanTerm.containsKey(updateQ.Quote.FinancingTerm) ? mapLoanTerm.get(updateQ.Quote.FinancingTerm) : null);
                        lstQot[0].Term_Years__c= (updateQ.Quote.FinancingTerm != null ? updateQ.Quote.FinancingTerm : 0);
                        lstQot[0].Quote_Amount__c= (updateQ.Quote.SystemCost != null) ? updateQ.Quote.SystemCost : 0.0; //// Based on discussion with Sangita 05/June/2014. (updateQ.Quote.QuoteAmount != null) ? updateQ.Quote.QuoteAmount : 0.0;
                        lstQot[0].System_Price__c= (updateQ.Quote.SystemPrice != null) ? updateQ.Quote.SystemPrice : 0.0;
                        lstQot[0].System_Price_Excluding_Tax__c = (updateQ.Quote.SystemPriceWithoutTax != null) ? updateQ.Quote.SystemPriceWithoutTax : 0.0;
                        lstQot[0].System_Cost__c= (updateQ.Quote.SystemCost != null) ? updateQ.Quote.SystemCost : 0.0;
                        lstQot[0].Sales_Tax__c= lstQot[0].Opportunity.Account.Sales_Tax_Rate__c;
                        lstQot[0].Site_Address_Line_1__c= GPPServicesUpdateQuoteDetails.CheckString(updateQ.Quote.SiteAddress1);
                        lstQot[0].Site_Address_Line_2__c= GPPServicesUpdateQuoteDetails.CheckString(updateQ.Quote.SiteAddress2);
                        lstQot[0].Site_City__c= GPPServicesUpdateQuoteDetails.CheckString(updateQ.Quote.SiteCity);
                        lstQot[0].Site_State__c= GPPServicesUpdateQuoteDetails.CheckString(updateQ.Quote.SiteState);
                        lstQot[0].Site_Country__c= GPPServicesUpdateQuoteDetails.CheckString(updateQ.Quote.SiteCountry);
                        lstQot[0].Site_PostalCode__c= GPPServicesUpdateQuoteDetails.CheckString(updateQ.Quote.SitePostCode);
                        
                        Opportunity objOpp= new Opportunity(id= lstQot[0].OpportunityId,
                                                            NMI__c= GPPServicesUpdateQuoteDetails.CheckString(updateQ.Quote.NMI),
                                                            Business_Unit__c= (new List<String>{'RLC', 'UPP Americas', 'NA Commercial', 'UPP Intl'})[0],
                                                            RLC_Type__c= (new List<String>{'Residential', 'Light Commercial', 'New Homes', 'EU Commercial'})[0]);

                        lstQot[0].Weather_Data_File__c = GPPServicesUpdateQuoteDetails.CheckString(updateQ.Quote.WeatherDataFile);
                        lstQot[0].WeatherFile_longitude__c = (updateQ.Quote.WeatherLongitude != null ? updateQ.Quote.WeatherLongitude : null);
                        lstQot[0].WeatherFile_latitude__c  = (updateQ.Quote.WeatherLatitude != null ? updateQ.Quote.WeatherLatitude : null);
                        lstQot[0].Proposed_Electric_Utility__c = GPPServicesUpdateQuoteDetails.CheckString(updateQ.Quote.UtilityRetailer);
                        lstQot[0].Proposed_Rate_Name__c = GPPServicesUpdateQuoteDetails.CheckString(updateQ.Quote.UtilityRate);
                        lstQot[0].Utility_Bill_Annual_Escalation__c = (updateQ.Quote.UtilityRateEscalation != null ? updateQ.Quote.UtilityRateEscalation : 0.0);
                        lstQot[0].Utility_Distributor__c = GPPServicesUpdateQuoteDetails.CheckString(updateQ.Quote.UtilityDistributor);
                        
                        String moduleOracleItemNumber = GPPServicesUpdateQuoteDetails.CheckString(updateQ.Quote.ModuleOraceItemNumber);
                        List<Item__c> itemList = [SELECT id FROM item__c WHERE Active__c = true AND Name =: moduleOracleItemNumber ];
                        if(!itemList.isEmpty())
                            lstQot[0].Module_Oracle_Item_Number__c = itemList[0].id; //Validate for SFDC ID
                            
                        lstQot[0].Module_Brand__c = GPPServicesUpdateQuoteDetails.CheckString(updateQ.Quote.ModuleManufaturer);
                        lstQot[0].Module__c = GPPServicesUpdateQuoteDetails.CheckString(updateQ.Quote.ModuleName);
                        lstQot[0].Quote_Inverter_Values__c = GPPServicesUpdateQuoteDetails.CheckString(updateQ.Quote.QuoteInverterValues);
                        System.debug('Quote_Inverter_Values__c ----- '+lstQot[0].Quote_Inverter_Values__c);
                        lstQot[0].Module_Quantity__c = (updateQ.Quote.ModuleQuantity != null ? updateQ.Quote.ModuleQuantity : 0);
                        Integer quantity = 0;
                        if(updateQ.Quote.RoofDetails != null && !updateQ.Quote.RoofDetails.isEmpty())
                            {
                                for(GPPUpdateQuoteAPIPayloadParser.RoofDetail rd: updateQ.Quote.RoofDetails)
                                {
                                    quantity += (rd.RackingQuantity != null ? rd.RackingQuantity : 0);
                                    }
                            }
                        lstQot[0].Racking_Quantity__c = String.valueof(quantity);                        
                        lstQot[0].Mounting_Description__c = updateQ.Quote.RackingName;
                        //// Place Holder - Tag to Add
                        //// Place Holder - Tag to Add
                        lstQot[0].Maximum_Rated_Capacity_DC__c = (updateQ.Quote.MaximumRatedCapacityDC != null ? updateQ.Quote.MaximumRatedCapacityDC : 0.0);
                        lstQot[0].Dealer_Fees__c = (updateQ.Quote.DealerFeesTotal != null ? updateQ.Quote.DealerFeesTotal : 0.0);
                        lstQot[0].Dealer_Fees_Sales_Partner_Total__c = (updateQ.Quote.DealerFeesSalesPartnerTotal != null ? updateQ.Quote.DealerFeesSalesPartnerTotal : 0.0);
                        lstQot[0].Dealer_Fee_Installation_Partner_Total__c = (updateQ.Quote.DealerFeesInstallationPartnerTotal != null ? updateQ.Quote.DealerFeesInstallationPartnerTotal : 0.0);
                        lstQot[0].Early_Buyout_Option_Date__c = GPPServicesUpdateQuoteDetails.CheckString(updateQ.Quote.EarlyBuyOutDate);
                        lstQot[0].Solar_Rebate_Amount__c = (updateQ.Quote.SolarRebate != null ? updateQ.Quote.SolarRebate : 0.0);
                        lstQot[0].Full_Prepaid_Lease__c = updateQ.Quote.FullPrePaid;
                        lstQot[0].Monthly_Payment_Base_Year_1__c = (updateQ.Quote.MonthlyPaymentBaseYear1 != null ? updateQ.Quote.MonthlyPaymentBaseYear1 : 0.0);
                        lstQot[0].Monthly_Payment_Tax_Year_1__c = (updateQ.Quote.MonthlyPaymentTaxYear1 != null ? updateQ.Quote.MonthlyPaymentTaxYear1 : 0.0);
                        lstQot[0].Monthly_Payment_Tax_Fees_Year_1__c = (updateQ.Quote.MonthlyPaymentTaxFeesYear1 != null ? updateQ.Quote.MonthlyPaymentTaxFeesYear1 : 0.0);
                        lstQot[0].Total_Monthly_Payment_Base__c = (updateQ.Quote.TotalMonthlyPaymentBase != null ? updateQ.Quote.TotalMonthlyPaymentBase : 0.0);
                        lstQot[0].Total_Monthly_Payment_Tax__c = (updateQ.Quote.TotalMonthlyPaymentTax != null ? updateQ.Quote.TotalMonthlyPaymentTax : 0.0);
                        lstQot[0].TotalMonthlyPaymentBasePlusTax__c = (updateQ.Quote.TotalMonthlyPaymentBasePlusTax != null ? updateQ.Quote.TotalMonthlyPaymentBasePlusTax: 0.0);
                        lstQot[0].Total_Monthly_Payment_Tax_Fees__c = (updateQ.Quote.TotalMonthlyPaymentTaxFees != null ? updateQ.Quote.TotalMonthlyPaymentTaxFees : 0.0);
                        lstQot[0].Down_Payment__c = (updateQ.Quote.DownPaymentBase != null ? updateQ.Quote.DownPaymentBase : 0);
                        lstQot[0].Down_Payment_Tax__c = (updateQ.Quote.DownPaymentTax != null ? updateQ.Quote.DownPaymentTax : 0.0);
                        lstQot[0].Full_PrePayment_Amount_Base_Amount__c = (updateQ.Quote.FullPrePaidBase != null ? updateQ.Quote.FullPrePaidBase : 0);
                        lstQot[0].Full_PrePayment_Amount_Estimated_Tax_on__c = (updateQ.Quote.FullPrePaidTax != null ? updateQ.Quote.FullPrePaidTax : 0);
                        //// Place Holder - Tag to Add
                        lstQot[0].lease_annual_escalation__c = (updateQ.Quote.AnnualPaymentEscalator != null ? updateQ.Quote.AnnualPaymentEscalator : 0.0);
                        //// Place Holder - Tag to Add
                        lstQot[0].Total_Production_Base__c = (updateQ.Quote.TotalProductionBase != null ? updateQ.Quote.TotalProductionBase : 0.0);
                        lstQot[0].Total_Production_Low__c = (updateQ.Quote.TotalProductionLow != null ? updateQ.Quote.TotalProductionLow : 0.0);
                        lstQot[0].Total_Production_High__c = (updateQ.Quote.TotalProductionHigh != null ? updateQ.Quote.TotalProductionHigh : 0.0);
                        lstQot[0].Total_Production_Range__c = GPPServicesUpdateQuoteDetails.CheckString(updateQ.Quote.TotalProductionRange);
                        lstQot[0].Averge_Payback_Rate_Per_KWH__c = (updateQ.Quote.AvergePayBackRatePerKWH != null ? updateQ.Quote.AvergePayBackRatePerKWH : 0.0);
                        lstQot[0].Mounting_Option__c = updateQ.Quote.MountingOption;
                        lstQot[0].Monthly_Base_Plus_Tax_Year_1__c= (updateQ.Quote.MonthlyBasePlusTaxYear1 != null ? updateQ.Quote.MonthlyBasePlusTaxYear1 : 0.0);   //Added on 01st July 2014: Req from Sangita
                        
                        if(updateQ.Quote.MonitoringSystem != null)
                            lstQot[0].Monitoring_System__c = updateQ.Quote.MonitoringSystem;
                            
                        try{
                            System.debug('lstQot ----- '+lstQot[0]);
                            update lstQot[0]; //Update the Quote Details received from GPP
                            update objOpp; //Update the NMI for the related Opportunity
                        //Added : 26_jun-2014 : Don't process child records if Quotelines already exists.
                        if(lstQot[0].Quote_Lines__r.size()>0)
                        {
                             wRes.keyQuoteId= lstQot[0].Id;
                             wRes.QuoteNumber= lstQot[0].QuoteNumber;
                             wRes.Success= false;
                             wRes.Messages= new List<String>{mapErrors.get(4)};                            
                             return wRes;
                        }        
                        //>> Processing Quote Lines
                            List<Quote_Line__c> lstQoL = new List<Quote_Line__c>();
                            if(updateQ.Quote.QuoteLines != null && !updateQ.Quote.QuoteLines.isEmpty())
                            {
                                Map<String, Id> mOINvIId= new Map<String, Id>();
                                for(GPPUpdateQuoteAPIPayloadParser.QuoteLine qol: updateQ.Quote.QuoteLines)
                                    if(GPPServicesUpdateQuoteDetails.CheckString(qol.OracleItemNumber) != '')
                                        mOINvIId.put(qol.OracleItemNumber, null);
                                
                                if(!mOINvIId.isEmpty())
                                    for(Item__c itm: [SELECT id, name, Item_ID__c FROM Item__c WHERE Item_ID__c IN: mOINvIId.keySet()])  
                                         mOINvIId.put(itm.Item_ID__c, itm.Id); 
                                                                     
                                for(GPPUpdateQuoteAPIPayloadParser.QuoteLine qol: updateQ.Quote.QuoteLines)
                                {
                                    if(GPPServicesUpdateQuoteDetails.CheckString(qol.OracleItemNumber) != '' && mOINvIId.containsKey(qol.OracleItemNumber) &&  mOINvIId.get(qol.OracleItemNumber) != null)
                                    {
                                        Quote_Line__c objQL= new Quote_Line__c(Quote__c= lstQot[0].Id);
                                            objQL.Item__c = mOINvIId.get(qol.OracleItemNumber);
                                            objQL.Quantity__c = (qol.Quantity != null ? qol.Quantity : 0);
                                            objQL.Unit_Price__c = (qol.UnitPrice != null ? qol.UnitPrice : 0);                          
                                            objQL.CurrencyISOCode =  lstQot[0].CurrencyISOCode;
                                        lstQoL.add(objQL);
                                    }
                                }
                            }
                            if(!lstQoL.isEmpty())
                                insert lstQoL; //Insert the Quote Lines
                        
                        //>> Annual Energy Production Map
                        Map<Integer, GPPUpdateQuoteAPIPayloadParser.AnnualEnergyProduction> mapAEP= new Map<Integer, GPPUpdateQuoteAPIPayloadParser.AnnualEnergyProduction>();
                        //>> Annual Financials Map
                        Map<Integer, GPPUpdateQuoteAPIPayloadParser.AnnualFinancial> mapAF= new Map<Integer, GPPUpdateQuoteAPIPayloadParser.AnnualFinancial>();
                        
                        //>> Processing Annual Energy Production
                            List<Annual_Energy_Production__c> lstAEP= new List<Annual_Energy_Production__c>();
                            if(updateQ.Quote.AnnualEnergyProductions != null && !updateQ.Quote.AnnualEnergyProductions.isEmpty())
                            {
                                for(GPPUpdateQuoteAPIPayloadParser.AnnualEnergyProduction aep: updateQ.Quote.AnnualEnergyProductions)
                                {
                                    mapAEP.put(aep.RowNumber, aep);
                                    
                                    Annual_Energy_Production__c qotAep= new Annual_Energy_Production__c(Quote__c= lstQot[0].Id);
                                        qotAep.Row_Number__c = (aep.RowNumber != null ? aep.RowNumber : 0);
                                        qotAep.Base__c = (aep.AnnualProdutionBase != null ? aep.AnnualProdutionBase : 0.0);
                                        qotAep.High__c = (aep.AnnualProductionHigh != null ? aep.AnnualProductionHigh : 0.0);
                                        qotAep.Low__c  = (aep.AnnualProductionLow != null ? aep.AnnualProductionLow : 0.0);                                   
                                    lstAEP.add(qotAep);
                                }
                            }
                            if(!lstAEP.isEmpty())
                                insert lstAEP; //Insert the Annual Energy Production Lines
                        
                        //>> Processing Annual Financials
                            List<Annual_Financial__c> lstAF= new List<Annual_Financial__c>();
                            if(updateQ.Quote.AnnualFinancials != null && !updateQ.Quote.AnnualFinancials.isEmpty())
                            {
                                for(GPPUpdateQuoteAPIPayloadParser.AnnualFinancial af: updateQ.Quote.AnnualFinancials)
                                {
                                    mapAF.put(af.RowNumber, af);
                                    
                                    Annual_Financial__c objAF= new Annual_Financial__c(Quote__c= lstQot[0].Id);
                                        objAF.Row_Number__c = (af.RowNumber != null ? af.RowNumber : 0);
                                        objAF.Annual_Base__c = (af.AnnualBase != null ? af.AnnualBase : 0.0);
                                        objAF.Annual_Sales_Tax__c = (af.AnnualSalesTax != null ? af.AnnualSalesTax : 0.0);
                                        objAF.Annual_Fees__c = (af.AnnualFees != null ? af.AnnualFees : 0.0);
                                        objAF.Monthly_Base__c = (af.MonthlyBase != null ? af.MonthlyBase : 0.0);
                                        objAF.Monthly_Fees__c = (af.MonthlyFees != null ? af.MonthlyFees : 0.0);
                                        objAF.Monthly_Sales_Tax__c = (af.MonthlySalesTax != null ? af.MonthlySalesTax : 0.0);
                                        objAF.Monthly_Base_Plus_Tax__c= (af.MonthlyBasePlusTax != null ? af.MonthlyBasePlusTax : 0.0);  //Added on 01st July 2014: Req from Sangita                                 
                                        objAF.Annual_Termination_Amount__c = (af.AnnualTerminationValue != null ? af.AnnualTerminationValue : 0.0);
                                        objAF.CurrencyISOCode =  lstQot[0].CurrencyISOCode;                    
                                    lstAF.add(objAF);
                                }                               
                            } 
                            if(!lstAF.isEmpty())
                                insert lstAF; //Insert the Annual Financials Lines
                                                    
                        //>> Processing Roof Details
                            List<Roof_Details__c> lstRD= new List<Roof_Details__c>();
                            if(updateQ.Quote.RoofDetails != null && !updateQ.Quote.RoofDetails.isEmpty())
                            {
                                for(GPPUpdateQuoteAPIPayloadParser.RoofDetail rd: updateQ.Quote.RoofDetails)
                                {
                                    Roof_Details__c objRD= new Roof_Details__c(Account__c= lstQot[0].Opportunity.Account.Id, Quote_Id__c= lstQot[0].Id);
                                        objRD.Description__c = GPPServicesUpdateQuoteDetails.CheckString(rd.RoofDescription);
                                        objRD.Direction__c = (rd.RoofDirection != null ? rd.RoofDirection : 0);
                                        objRD.Pitch__c = GPPServicesUpdateQuoteDetails.CheckString(rd.RoofPitch);
                                        objRD.Height__c = (rd.RoofHeight !=null ? rd.RoofHeight : 0.0);
                                        objRD.Type__c = GPPServicesUpdateQuoteDetails.CheckString(rd.RoofType);
                                        objRD.Jan__c = (rd.SolarAccess_January != null ? rd.SolarAccess_January : 0.0);
                                        objRD.Feb__c = (rd.SolarAccess_February != null ? rd.SolarAccess_February : 0.0);
                                        objRD.Mar__c = (rd.SolarAccess_March != null ? rd.SolarAccess_March : 0.0);
                                        objRD.Apr__c = (rd.SolarAccess_April != null ? rd.SolarAccess_April : 0.0);
                                        objRD.May__c = (rd.SolarAccess_May != null ? rd.SolarAccess_May : 0.0);
                                        objRD.Jun__c = (rd.SolarAccess_June != null ? rd.SolarAccess_June : 0.0);
                                        objRD.Jul__c = (rd.SolarAccess_July != null ? rd.SolarAccess_July : 0.0);
                                        objRD.Aug__c = (rd.SolarAccess_August != null ? rd.SolarAccess_August : 0.0);
                                        objRD.Sep__c = (rd.SolarAccess_September != null ? rd.SolarAccess_September : 0.0);
                                        objRD.Oct__c = (rd.SolarAccess_October != null ? rd.SolarAccess_October : 0.0);
                                        objRD.Nov__c = (rd.SolarAccess_November != null ? rd.SolarAccess_November : 0.0);
                                        objRD.Dec__c = (rd.SolarAccess_December != null ? rd.SolarAccess_December : 0.0);
                                        objRD.Module_Oracle_Item_Number__c = GPPServicesUpdateQuoteDetails.CheckString(rd.ModuleOraceItemNumber);
                                        objRD.Module_Brand__c = GPPServicesUpdateQuoteDetails.CheckString(rd.ModuleBrand);
                                        objRD.Module__c = GPPServicesUpdateQuoteDetails.CheckString(rd.ModuleName);
                                        objRD.Module_Quantity__c = (rd.TotalModuleCount != null ? rd.TotalModuleCount : 0);
                                        objRD.Number_Of_Modules_MPP1__c = (rd.NumberOfModulesMPP1 != null ? rd.NumberOfModulesMPP1 : 0);
                                        objRD.Number_Of_Strings_MPP1__c = (rd.NumberOfStringsMPP1 != null ? rd.NumberOfStringsMPP1 : 0);
                                        objRD.Number_Of_Modules_MPP2__c = (rd.NumberOfModulesMPP2 != null ? rd.NumberOfModulesMPP2 : 0);
                                        objRD.Number_Of_Strings_MPP2__c = (rd.NumberOfStringsMPP2 != null ? rd.NumberOfStringsMPP2 : 0);
                                        objRD.Roof_Inverter_Values__c = GPPServicesUpdateQuoteDetails.CheckString(rd.RoofInverterValues);
                                        objRD.Racking_Name__c = GPPServicesUpdateQuoteDetails.CheckString(rd.RackingName);
                                        objRD.Racking_Quantity__c = (rd.RackingQuantity != null ? rd.RackingQuantity : 0);
                                        objRD.Quote__c = lstQot[0].Id;
                                    lstRD.add(objRD);
                                }
                            }
                            if(!lstRD.isEmpty())
                                insert lstRD; //Insert the Roof Details

                        //>> Processing Lease Schedules
                            List<Lease_Schedule__c> lstLSch= new List<Lease_Schedule__c>();
                            if(lstQot[0].Is_Locked__c){//Create Schedule only if the Quote is Locked
                            
                                //>>> Get the data from Lease Schedule
                                String sWhereClauseLS= 'WHERE Quote__c =\'' + lstQot[0].Id + '\'';
                                List<Lease_Schedule__c> lstLS= GPPQueryHelper.GetLeaseSchedules(sWhereClauseLS);
                                
                                if(!lstLS.isEmpty()){
                                    //// If Lease Schedules already Exist. What should be the process? Sangita to clarify.
                                    //// 02 June 2014: Sangita: No action to be taken.
                                }
                                else{
                                    if(!mapAEP.isEmpty()){
                                        for(Integer i: mapAEP.keySet()){
                                            GPPUpdateQuoteAPIPayloadParser.AnnualEnergyProduction aep= mapAEP.get(i);
                                            GPPUpdateQuoteAPIPayloadParser.AnnualFinancial af= mapAF.get(i);
                                            
                                            if(aep != null && af != null){
                                                Lease_Schedule__c objLS= new Lease_Schedule__c();
                                                    objLS.Quote__c= lstQot[0].Id;
                                                    objLS.Year__c= i;
                                                    objLS.Record_Count__c= i;                                                   
                                                    objLS.Guarantee_Year__c= 'Year ' + String.valueof(i);
                                                    objLS.Annual_Lease_Payments_Year__c= String.valueOf(i);                                                 
                                                    objLS.System_Size_DC__c= lstQot[0].Maximum_Rated_Capacity_DC__c;
                                                    ////objLS.X105_of_S_P_A_P__c= (aep.AnnualProductionHigh != null ? aep.AnnualProductionHigh : 0.0);
                                                    ////objLS.X95_of_S_P_A_P__c= (aep.AnnualProductionLow != null ? aep.AnnualProductionLow : 0.0);
                                                    objLS.Annual_Lease_Payment__c= (af.AnnualBase != null ? af.AnnualBase : 0.0) + (af.AnnualSalesTax != null ? af.AnnualSalesTax : 0.0) + (af.AnnualFees != null ? af.AnnualFees : 0.0);
                                                   // objLS.Base_Monthy_Payment__c= (af.MonthlyBase != null ? af.MonthlyBase : 0.0) + (af.MonthlySalesTax != null ? af.MonthlySalesTax : 0.0);// + (af.MonthlyFees != null ? af.MonthlyFees : 0.0);
                                                   objLS.Base_Monthy_Payment__c= (af.MonthlyBase != null ? af.MonthlyBase : 0.0);// + (af.MonthlyFees != null ? af.MonthlyFees : 0.0);
                                                    objLS.Estimated_Tax_on_Monthly_Payment__c= (af.MonthlyFees != null ? af.MonthlyFees : 0.0);
                                                    objLS.Guaranteed_Range_of_Annual_Production__c= (String.isNotBlank(aep.AnnualProductionRange) ? aep.AnnualProductionRange : null);
                                                    objLS.PeGu_Estimate__c= String.valueof(aep.AnnualProductionLow != null ? aep.AnnualProductionLow : 0.0) + ' - ' + String.valueOf(aep.AnnualProductionHigh != null ? aep.AnnualProductionHigh : 0.0);
                                                    objLS.Approximate_Price_per_kWh__c= (aep.AnnualPayBackRatePerKWH != null ? aep.AnnualPayBackRatePerKWH : null);
                                                    objLS.Rate_Per_KWH__c= (af.CostofLeasePerkWh != null ? af.CostofLeasePerkWh : null);
                                                    objLS.Annual_SystemProduction_Guarantee_Year__c=  String.isNotBlank(aep.AnnualSystemProductionGuaranteeYear) ? aep.AnnualSystemProductionGuaranteeYear : null;
                                                    objLS.Cost_of_Lease_Per_kWh__c= (af.CostofLeasePerkWh != null ? af.CostofLeasePerkWh : null);
                                                    objLS.Remaining_Lease_Value__c= (af.AnnualTerminationValue != null ? af.AnnualTerminationValue : 0.0);//End To End Testing. Issue# 91
                                                    objLS.System_Production_Annual_Production__c= (af.AnnualBase != null ? af.AnnualBase : null);
                                                    objLS.currencyisocode = lstQot[0].currencyisocode;
                                                lstLSch.add(objLS);
                                            }
                                        }
                                    }
                                }
                            }//End Lock Check
                            if(!lstLSch.isEmpty())
                                insert lstLSch;
                                
                        //>> If everything went well, build the success response    
                            wRes.keyQuoteId= lstQot[0].Id;
                            wRes.QuoteNumber= lstQot[0].QuoteNumber;
                            wRes.Success= true;
                            wRes.Messages= new List<String>{'Quote updated successfully'};
                        }
                        catch(System.DmlException e)
                        {
                            wRes.keyQuoteId= lstQot[0].Id;
                            wRes.QuoteNumber= lstQot[0].QuoteNumber;
                            for(Integer i = 0; i < e.getNumDml(); i++)
                                wRes.Messages.add(e.getDmlMessage(i));                          
                        }
                    }
                    else
                    {
                        wRes.keyQuoteId= updateQ.Quote.keyQuoteId;
                        wRes.QuoteNumber= updateQ.Quote.QuoteNumber;
                        wRes.Messages.add(mapErrors.get(3));
                    }
                }
                else
                    wRes.Messages.add(mapErrors.get(2));
            }
            else
                wRes.Messages.add(mapErrors.get(1));
        }
        else
            wRes.Messages.add(mapErrors.get(0));

        return wRes;
    }//End Func UpdateQuote

/******** SERVICE: POST : end ********/

/******* FUNCTION : start *******/
    
    private static Map<Integer, String> mapErrors()
    {
        Map<Integer, String> mapE= new Map<Integer, String>();
            mapE.put(0, 'Payload corrupt');
            mapE.put(1, 'Payload body empty');
            mapE.put(2, 'Payload Quote attribute faulty');
            mapE.put(3, 'Record not found for supplied \'keyQuoteId\' and \'QuoteNumber\'');
            mapE.put(4, 'Quote Either Locked or Already has Quote Lines');
        return mapE;
    }//End Func mapErrors

    private static String CheckString(String s)
    {
        return (String.isNotBlank(s) ? s.trim() : null);
    }//End Func CheckString
/******** FUNCTION : end ********/

/******* WRAPPER : start *******/
    
    global class WResponse
    {
        global String       keyQuoteId;
        global String       QuoteNumber;
        global Boolean      Success;
        global List<String> Messages;
    }//End Class WResponse
    
/******** WRAPPER : end ********/
    
}//End Class GPPServicesUpdateQuoteDetails