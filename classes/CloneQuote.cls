/*
Modifications:
2-jul-2014 : Birlasoft : GPP Project : Skip System Cost Validation for Australia
*/
public class CloneQuote
{

public void quoteUpdate(Quote[] Qu)
{
//Cloning the Quote: START//
    Map<id, Quote> mapQuoteProduct = new Map<Id, Quote>();
    Map<Id, Id> mapOpptyProduct = new Map<Id, Id>();
    Map<Id, Id> mapOrgProduct = new Map<Id, Id>();
    
    Map<id, Quote> mapQuoteLessee = new Map<Id, Quote>();
    Map<Id, Id> mapOpptyLessee = new Map<Id, Id>();
    Map<Id, Id> mapOrgLessee = new Map<Id, Id>();

    Map<id, Quote> mapQuoteProduction = new Map<Id, Quote>();
    Map<Id, Id> mapOpptyProduction = new Map<Id, Id>();
    Map<Id, Id> mapOrgProduction = new Map<Id, Id>();
    
    Map<Id, Id> mapOrg = new Map<Id, Id>();
     Map<id, Quote> mapQuote = new  Map<id, Quote>();
    
	list<System_Production__c> listSystemProduction = new list<System_Production__c>();
    
    for(Quote qt: Qu) 
    {
        //Check for Amendment Type "Product"
        if(qt.Is_Locked__c && qt.Amendment_Type__c != null && qt.Amendment_Type__c == 'Product' && qt.Amended_Lease__c != null) 
        {
            mapQuoteProduct.put(qt.Id, qt);
            mapOpptyProduct.put(qt.Id, qt.OpportunityId);
            mapOrgProduct.put(qt.Id, qt.Amended_Lease__c);
    
        }
        
        //Check for Amendment Type "Lessee"     
        if(qt.Is_Locked__c && qt.Amendment_Type__c != null && qt.Amendment_Type__c == 'Lessee' && qt.Amended_Lease__c != null) 
        {
            mapQuoteLessee.put(qt.Id, qt);
            mapOpptyLessee.put(qt.Id, qt.OpportunityId);
            mapOrgLessee.put(qt.Id, qt.Amended_Lease__c);
            
        }
        System.debug('------------mapOrgProduction');
        //Check for Amendment Type "Production"     
        if(qt.Is_Locked__c && qt.Amendment_Type__c != null && qt.Amendment_Type__c == 'Production' && qt.Amended_Lease__c != null) 
        {
            System.debug('------------mapOrgProduction'+mapOrgProduction);
            mapQuoteProduction.put(qt.Id, qt);
            mapOpptyProduction.put(qt.Id, qt.OpportunityId);
            mapOrgProduction.put(qt.Id, qt.Amended_Lease__c);
              
        }
        mapOrg.put(qt.Id, qt.Amended_Lease__c);
        mapQuote.put(qt.Id, qt);
    }
 
    Map<id, Quote> mAmdQ = new Map<Id, Quote>([SELECT id,Module_Brand__c,System_Production_Year_1__c,Module__c,Module_Quantity__c,Maximum_Rated_Capacity__c,Quote_Inverter_Values__c,Monitoring_System__c,Mounting_Option__c,Total_Energy__c,Rollup_Lease_95_of_S_P_A_P__c,Rollup_Lease_105_of_S_P_A_P__c,
                                                      (SELECT id, Item__c, Quantity__c, Quote__c, Unit_Price__c, CurrencyIsoCode FROM Quote_Lines__r),
                                                      (SELECT Id,X95_of_S_P_A_P_1__c,X105_of_S_P_A_P_1__c,Name, CurrencyIsoCode, Quote__c, Annual_Lease_Payment__c, Annual_Lease_Payments_Year__c, Annual_SystemProduction_Guarantee_Year__c, Approximate_Price_per_kWh__c, Base_Monthy_Payment__c, Est_Monthly_Paymt_w_o_formula__c, Est_Mthly_Paymt_includingTax_w_auto_ACH__c, Est_Mthly_Paymt_with_formula__c, Estimated_Monthly_Payment_inclusive_of_T__c, Estimated_Tax_on_Monthly_Payment__c, Guarantee_Year__c, Guaranteed_Range_of_Annual_Production__c, Lease_Payments_Year__c, Monthly_Payments_and_with_automatic_ACH__c,PeGu_Estimate__c, Rate_Per_KWH__c, Record_Count__c, Remaining_Lease_Period__c, Remaining_Lease_Value__c, RoundOff_Base_Monthly_Payment__c, RoundOff_Rate_Per_KWH__c, RoundOff_Remaining_Lease_Value__c, System_Production_Annual_Production__c, Temp_Monthly_Lease_Payments__c, X105_of_S_P_A_P__c, X95_of_S_P_A_P__c, Final_Base_Monthly_Payment__c, Final_Estimated_Tax_on_Monthly__c, Final_Estimated_Monthly_W_Tax_No_ACH__c, Final_Estimated_Monthly_W_Tax_W_ACH__c, Final_Total_Yearly_Page_2__c, Final_Total_Yearly_Page_4__c, Final_Estimated_Monthly_W_Tax_No_ACH_p2__c, Tax_Rate__c, Final_Tax_Rate__c FROM Lease_Progress__r),
                                               		  (SELECT Id,Quote__c, netcostdetail_cost__c, System_Size_DC__c, System_Size_AC__c, Upfront_Incentives__c, Monthly_Electric_Bill_Without_PV_year1__c, Monthly_Electric_Bill_With_PV_year1__c,Total_Energy__c, annual_Produced__c, annual_Purchased__c, Percentage_Electricity_Produced__c, Monthly_Electric_Bill_saving_year1__c, netCostDetail_netCost__c, Cash_Price_Return_On_Investment_year1__c, Monthly_Electric_Bill_Without_PV_year5__c, Monthly_Electric_Bill_With_PV_year5__c, Cash_Price_Return_On_Investment_year5__c, Monthly_Lease_Payment__c, Monthly_Lease_Payment7_50discount__c, Upfront_Lease_Payment__c, Incentive_Design_Factor__c, cost_per_watt_AC__c, cost_per_watt_DC__c, Monthly_Electric_Bill_saving_year5__c, annual_excess__c FROM System_Production__r)	
                                               FROM Quote 
                                               WHERE id IN: (!mapQuoteProduct.isEmpty() ? mapQuoteProduct.keySet() : new Set<id>()) OR 
                                                     id IN: (!mapQuoteLessee.isEmpty() ? mapQuoteLessee.keySet() : new Set<id>()) OR
                                               		 id IN: (!mapQuote.isEmpty() ? mapQuote.keySet() : new Set<id>()) OR	
                                                     id IN: (!mapQuoteProduction.isEmpty() ? mapQuoteProduction.keySet() : new Set<id>())]);
    
 
    System.debug('------------------1');
    List<Quote> lstArchievedQuote = new List<Quote>();
    MAp<ID,Quote> mapCopyAmeInfoQuote = new MAP<ID,Quote>();
    
    List<Quote_Line__c> lstQLDelete = new List<Quote_Line__c>();
    List<Quote_Line__c> lstQL = new List<Quote_Line__c>();
    List<Lease_Schedule__c> lstLP = new List<Lease_Schedule__c>();
    
        
    //*********PRODUCT COPY***********//
    if(!mapOrgProduct.isEmpty()) 
    {
        System.debug('------------------2');
        for(Quote qotsProduct: [SELECT id, name, opportunityId,
                                Module_Oracle_Item_Number__c, Quote_Inverter_Values__c,Module__c,
                                Module_Brand__c, Module_Quantity__c, System_Cost__c,
                                Module_Type__c, Monitoring_System_Model__c,
                                Monitoring_System_Option__c, Monitoring_System_Quantity__c, 
                                Mounting_Option__c, Construction__c, 
                                Dealer_Fees__c, Interconnect__c, 
                                Inverter_Brand__c, Origination__c,
                                Inverter_Brand_2__c, Inverter_Brand_3__c, Racking_Nu__c,Racking_Quantity__c,
                                Inverter_Brand_4__c, Inverter_Model__c,Amendment_History1__c,Financing_Amendment_Notes__c,
                                Inverter_Model_2__c, Inverter_Model_3__c, Consolidated_Lease_Number__c,
                                Inverter_Model_4__c, System_Size__c,Account_Billing_Country__c,Monitoring_System__c,Total_Energy__c,
                                (SELECT id, Item__c, Quantity__c, Quote__c, Unit_Price__c, CurrencyIsoCode FROM Quote_Lines__r)                    
                                FROM Quote 
                                WHERE id IN: mapOrgProduct.values()]) 
        {
        
        // Amendment Copy Error Message Display changes - vivek - 14/09/2012
             String ConcatenateErrorMessage = '';                  
            for(Id amdProductId : mapOrgProduct.keySet())
            {
            System.debug('------------------3');
             String Errormsg1 ='Module Type is different in Original and Amendment quote';
                    if(qotsProduct.Module_Type__c != mapQuoteProduct.get(amdProductId).Module_Type__c)
                    {
                        ConcatenateErrorMessage = system.now()+Errormsg1;
                    }
                    
                    String Errormsg2 ='Module Quantity is different in Original and Amendment quote';
                    if(qotsProduct.Module_Quantity__c != mapQuoteProduct.get(amdProductId).Module_Quantity__c)
                    {
                        ConcatenateErrorMessage = ConcatenateErrorMessage + system.now()+Errormsg2;
                    }
                    
                    String Errormsg3 ='Module Type and Module Quantity is different in Original and Amendment quote';
                    if(qotsProduct.Module_Quantity__c != mapQuoteProduct.get(amdProductId).Module_Quantity__c)
                    {
                        if(qotsProduct.Module_Type__c != mapQuoteProduct.get(amdProductId).Module_Type__c)
                        {
                            ConcatenateErrorMessage = ConcatenateErrorMessage + system.now()+Errormsg3;
                        }
                    }   
			System.debug('------------------4');
 			
            String Errormsg ='System Cost of Original quote and Amendment Quote is not same. Cannot proceed further';
            if(qotsProduct.System_Cost__c != mapQuoteProduct.get(amdProductId).System_Cost__c && (!qotsProduct.Account_Billing_Country__c.equalsIgnoreCase('Australia')))
            {
                mapQuoteProduct.get(amdProductId).Amendment_Copy_Error_Message__c = system.now()+Errormsg + ConcatenateErrorMessage;
                return;
            }
            else
            {
                mapQuoteProduct.get(amdProductId).Amendment_Copy_Error_Message__c = ConcatenateErrorMessage;
            }
			System.debug('------------------5');
             if(mapOrgProduct.get(amdProductId) == qotsProduct.Id)
                {
                //Back up Quote name Change - vivek- 14/09/2012
                    String Lease = qotsProduct.Consolidated_Lease_Number__c;
                    mapQuoteProduct.get(amdProductId).Amended_Lease_number__c = qotsProduct.Consolidated_Lease_Number__c;
                    Quote q = qotsProduct.clone(false, true, true, true);
                    q.OpportunityId = qotsProduct.OpportunityId;
                    String NewQuote = Lease +'_Backup_'+system.now();
                    q.Name = NewQuote;
                    
                    lstArchievedQuote.add(q);
                    
					System.debug('------------------6');
   
                    qotsProduct.Amendment_Quote_ID__c = mapQuoteProduct.get(amdProductId).id;
                    qotsProduct.Module_Oracle_Item_Number__c = mapQuoteProduct.get(amdProductId).Module_Oracle_Item_Number__c;
                    qotsProduct.Module_Quantity__c = mapQuoteProduct.get(amdProductId).Module_Quantity__c;
                    qotsProduct.Quote_Inverter_Values__c = mapQuoteProduct.get(amdProductId).Quote_Inverter_Values__c;
                    qotsProduct.Module__c = mapQuoteProduct.get(amdProductId).Module__c;
                    qotsProduct.Module_Brand__c = mapQuoteProduct.get(amdProductId).Module_Brand__c;
                    qotsProduct.Module_Type__c = mapQuoteProduct.get(amdProductId).Module_Type__c;
                    qotsProduct.Monitoring_System_Model__c = mapQuoteProduct.get(amdProductId).Monitoring_System_Model__c;
                    qotsProduct.Monitoring_System_Option__c = mapQuoteProduct.get(amdProductId).Monitoring_System_Option__c;
                    qotsProduct.Monitoring_System_Quantity__c = mapQuoteProduct.get(amdProductId).Monitoring_System_Quantity__c;
                    qotsProduct.Mounting_Option__c = mapQuoteProduct.get(amdProductId).Mounting_Option__c;
                    qotsProduct.Racking_Nu__c = mapQuoteProduct.get(amdProductId).Racking_Nu__c;
                    qotsProduct.Racking_Quantity__c = mapQuoteProduct.get(amdProductId).Racking_Quantity__c;
                    qotsProduct.Inverter_Brand__c = mapQuoteProduct.get(amdProductId).Inverter_Brand__c;
                    qotsProduct.Inverter_Brand_2__c = mapQuoteProduct.get(amdProductId).Inverter_Brand_2__c;
                    qotsProduct.Inverter_Brand_3__c = mapQuoteProduct.get(amdProductId).Inverter_Brand_3__c;
                    qotsProduct.Inverter_Brand_4__c = mapQuoteProduct.get(amdProductId).Inverter_Brand_4__c;
                    qotsProduct.Inverter_Model__c = mapQuoteProduct.get(amdProductId).Inverter_Model__c;
                    qotsProduct.Inverter_Model_2__c = mapQuoteProduct.get(amdProductId).Inverter_Model_2__c;
                    qotsProduct.Inverter_Model_3__c = mapQuoteProduct.get(amdProductId).Inverter_Model_3__c;
                    qotsProduct.Inverter_Model_4__c = mapQuoteProduct.get(amdProductId).Inverter_Model_4__c;
                    qotsProduct.Inverter_Quantity__c = mapQuoteProduct.get(amdProductId).Inverter_Quantity__c;
                    qotsProduct.Inverter_Quantity_2__c = mapQuoteProduct.get(amdProductId).Inverter_Quantity_2__c;
                    qotsProduct.Inverter_Quantity_3__c = mapQuoteProduct.get(amdProductId).Inverter_Quantity_3__c;
                    qotsProduct.Inverter_Quantity_4__c = mapQuoteProduct.get(amdProductId).Inverter_Quantity_4__c;
                    qotsProduct.System_Cost__c = mapQuoteProduct.get(amdProductId).System_Cost__c;
                    qotsProduct.Dealer_Fees__c = mapQuoteProduct.get(amdProductId).Dealer_Fees__c;
                    qotsProduct.Origination__c = mapQuoteProduct.get(amdProductId).Origination__c;
                    qotsProduct.Construction__c = mapQuoteProduct.get(amdProductId).Construction__c;
                    qotsProduct.Interconnect__c = mapQuoteProduct.get(amdProductId).Interconnect__c;
                    qotsProduct.Monitoring_System__c = mapQuoteProduct.get(amdProductId).Monitoring_System__c;
                    qotsProduct.Total_Energy__c = mapQuoteProduct.get(amdProductId).Total_Energy__c;
                    
                    
                    //qotsProduct.Maximum_Rated_Capacity__c=mapQuoteProduct.get(amdProductId).Maximum_Rated_Capacity__c;
                    
                    //Amendment Dates auotpopulation Changes - vivek - 17/09/2012
                    string Message = qotsproduct.Amendment_History1__c;
                    
                    if(Message == ''|| Message == null) 
                    {
                        qotsProduct.Amendment_History1__c = mapQuoteProduct.get(amdProductId).Amendment_Type__c + ' Amendment ' + system.now();
                    }
                    else
                    {
                        qotsProduct.Amendment_History1__c = Message + ' ' + mapQuoteProduct.get(amdProductId).Amendment_Type__c + ' Amendment ' + system.now();
                    }
                    
                    qotsProduct.Product_Am_Date__c = system.now();
                    qotsProduct.Amendment_Date__c = system.today();
                    
                    string FinanceMessage = qotsproduct.Financing_Amendment_Notes__c;
                    if(FinanceMessage == '' || FinanceMessage == null)
                    {
                        qotsproduct.Financing_Amendment_Notes__c = mapQuoteProduct.get(amdProductId).Financing_Amendment_Notes__c;
                    }
                    else 
                    {
                        qotsproduct.Financing_Amendment_Notes__c = FinanceMessage + mapQuoteProduct.get(amdProductId).Financing_Amendment_Notes__c;
                    }
                    mapCopyAmeInfoQuote.put(qotsProduct.id,qotsProduct);

                    List<Quote_Line__c> tempQL = qotsProduct.Quote_Lines__r;
                  
                    if(!tempQL.isEmpty())
                    {
                        lstQLDelete.addAll(tempQL); 
                        if(!mAmdQ.isEmpty() && mAmdQ.containsKey(amdProductId))
                        {
                            List<Quote_Line__c> tempAmdQL = mAmdQ.get(amdProductId).Quote_Lines__r;
                            if(!tempAmdQL.isEmpty())
                            {
                                for(Quote_Line__c ql: tempAmdQL)
                                {
                                    lstQL.add(new Quote_Line__c (Quote__c = qotsProduct.Id,
                                                                 Item__c = ql.Item__c, 
                                                                 Quantity__c = ql.Quantity__c,
                                                                 Unit_Price__c = ql.Unit_Price__c,
                                                                 CurrencyIsoCode = ql.CurrencyIsoCode));
                                }
                            }
                        }
                        
                     }                   
                }//End If
            }//End For
        }//End For
    }
    //***** END PRODUCT *****//
    
    //******LESSEE COPY*********//
    if(!mapOrgLessee.isEmpty())
    {
        System.debug('------------------7');
        for(Quote qotsLessee: [SELECT id, name, opportunityId,
                                 Module_Oracle_Item_Number__c, Quote_Inverter_Values__c,Module__c,
                                 Module_Brand__c, Module_Quantity__c, 
                                 Module_Type__c, Monitoring_System_Model__c,
                                 Monitoring_System_Option__c, Monitoring_System_Quantity__c, 
                                 Mounting_Option__c, Construction__c, 
                                 Dealer_Fees__c, Interconnect__c,Amendment_Copy_Error_Message__c, 
                                 Inverter_Brand__c, Inverter_Brand_2__c,Financing_Amendment_Notes__c,
                                 Inverter_Brand_3__c, Inverter_Brand_4__c, 
                                 Inverter_Model__c, Inverter_Model_2__c,
                                 Inverter_Model_3__c, Inverter_Model_4__c, System_Cost__c,
                                 Origination__c, System_Size__c,Consolidated_Lease_Number__c,
                                 Account_Billing_Country__c
                                 FROM Quote 
                                 WHERE id IN: mapOrgLessee.values()])
        {
                                 
            for(Id amdLesseeId : mapOrgLessee.keySet())
            {
                String Errormsg ='System Cost of Original quote and Amendment Quote is not same. Cannot proceed further';
                if(qotsLessee.System_Cost__c != mapQuoteLessee.get(amdLesseeId).System_Cost__c && (!qotsLessee.Account_Billing_Country__c.equalsIgnoreCase('Australia')))
                {
                    mapQuoteLessee.get(amdLesseeId).Amendment_Copy_Error_Message__c = system.now()+Errormsg;
                    return;
                }
                if(mapOrgLessee.get(amdLesseeId) == qotsLessee.Id)
                {
                    String Lease = qotsLessee.Consolidated_Lease_Number__c;
                    mapQuoteLessee.get(amdLesseeId).Amended_Lease_number__c = qotsLessee.Consolidated_Lease_Number__c;
                    Quote q = qotsLessee.clone(false, true, true, true);
                    q.OpportunityId = qotsLessee.OpportunityId;
                    String NewQuote = Lease +'_Backup_'+system.now();
                    q.Name = NewQuote;
                    lstArchievedQuote.add(q);
                    
                    qotsLessee.Temp_Contact_1__c = mapQuoteLessee.get(amdLesseeId).Temp_Contact_1__c;
                    qotsLessee.Temp_Contact_2__c = mapQuoteLessee.get(amdLesseeId).Temp_Contact_2__c ;
                    qotsLessee.Lessee__c = mapQuoteLessee.get(amdLesseeId).Lessee__c;
                    qotsLessee.Amendment_Quote_ID__c = mapQuoteLessee.get(amdLesseeId).id;
                    qotsLessee.Lessee_Info_Am_Date__c = system.now();
                    qotsLessee.Amendment_Date__c = system.today();
                   
                   string Message1 = qotsLessee.Amendment_History1__c;
                    if(Message1 == ''|| Message1 == null)
                    {
                    qotsLessee.Amendment_History1__c = mapQuoteLessee.get(amdLesseeId).Amendment_Type__c + ' Amendment' + system.now();
                    }
                    else
                    {
                    qotsLessee.Amendment_History1__c = Message1 + ' ' + mapQuoteLessee.get(amdLesseeId).Amendment_Type__c + ' Amendment' + system.now();
                    }
                    
                    string FinanceMessage1 = qotsLessee.Financing_Amendment_Notes__c;
                    if(FinanceMessage1 == '' || FinanceMessage1 == null)
                    {
                    qotsLessee.Financing_Amendment_Notes__c = mapQuoteLessee.get(amdLesseeId).Financing_Amendment_Notes__c;
                    }
                    else 
                    {
                    qotsLessee.Financing_Amendment_Notes__c = FinanceMessage1 + mapQuoteLessee.get(amdLesseeId).Financing_Amendment_Notes__c;
                    }
                   mapCopyAmeInfoQuote.put(qotsLessee.id,qotsLessee);
                   
                }
            }
        }
    }
    //***** END LESSEE *****//       
    
    System.debug('------------mapOrgProduction'+mapOrgProduction);    
    //**************PRODUCTION COPY*************//
    if(!mapOrgProduction.isEmpty())
    {
        System.debug('------------------mapOrgProduction'+mapOrgProduction);
        
        for(Quote qotsProduction: [SELECT id, name, opportunityId, 
                                 Module_Oracle_Item_Number__c, Quote_Inverter_Values__c,Module__c, Module_Brand__c, Financing_Amendment_Notes__c,
                                 Module_Quantity__c, Module_Type__c, Monitoring_System_Model__c, Monitoring_System_Option__c, Amendment_Copy_Error_Message__c,
                                 Monitoring_System_Quantity__c, Mounting_Option__c, Construction__c, Dealer_Fees__c, Interconnect__c, System_Cost__c,
                                 Inverter_Brand__c, Inverter_Brand_2__c, Inverter_Brand_3__c, Inverter_Brand_4__c, Consolidated_Lease_Number__c,
                                 Inverter_Model__c, Inverter_Model_2__c, Inverter_Model_3__c, Inverter_Model_4__c, Origination__c, System_Size__c,
                                 Account_Billing_Country__c,
                                 (SELECT id, Item__c, Quantity__c, Quote__c, Unit_Price__c, CurrencyIsoCode FROM Quote_Lines__r),
                           		 (SELECT Id,X95_of_S_P_A_P_1__c,X105_of_S_P_A_P_1__c,Name, CurrencyIsoCode, Quote__c, Annual_Lease_Payment__c, Annual_Lease_Payments_Year__c, Annual_SystemProduction_Guarantee_Year__c, Approximate_Price_per_kWh__c, Base_Monthy_Payment__c, Est_Monthly_Paymt_w_o_formula__c, Est_Mthly_Paymt_includingTax_w_auto_ACH__c, Est_Mthly_Paymt_with_formula__c, Estimated_Monthly_Payment_inclusive_of_T__c, Estimated_Tax_on_Monthly_Payment__c, Guarantee_Year__c, Guaranteed_Range_of_Annual_Production__c, Lease_Payments_Year__c, Monthly_Payments_and_with_automatic_ACH__c,PeGu_Estimate__c, Rate_Per_KWH__c, Record_Count__c, Remaining_Lease_Period__c, Remaining_Lease_Value__c, RoundOff_Base_Monthly_Payment__c, RoundOff_Rate_Per_KWH__c, RoundOff_Remaining_Lease_Value__c, System_Production_Annual_Production__c, Temp_Monthly_Lease_Payments__c, X105_of_S_P_A_P__c, X95_of_S_P_A_P__c, Final_Base_Monthly_Payment__c, Final_Estimated_Tax_on_Monthly__c, Final_Estimated_Monthly_W_Tax_No_ACH__c, Final_Estimated_Monthly_W_Tax_W_ACH__c, Final_Total_Yearly_Page_2__c, Final_Total_Yearly_Page_4__c, Final_Estimated_Monthly_W_Tax_No_ACH_p2__c, Tax_Rate__c, Final_Tax_Rate__c FROM Lease_Progress__r),
                                 (SELECT Id,  Quote__c, netcostdetail_cost__c, System_Size_DC__c, System_Size_AC__c,Total_Energy__c,Upfront_Incentives__c, Monthly_Electric_Bill_Without_PV_year1__c, Monthly_Electric_Bill_With_PV_year1__c, annual_Produced__c, annual_Purchased__c, Percentage_Electricity_Produced__c, Monthly_Electric_Bill_saving_year1__c, netCostDetail_netCost__c, Cash_Price_Return_On_Investment_year1__c, Monthly_Electric_Bill_Without_PV_year5__c, Monthly_Electric_Bill_With_PV_year5__c, Cash_Price_Return_On_Investment_year5__c, Monthly_Lease_Payment__c, Monthly_Lease_Payment7_50discount__c, Upfront_Lease_Payment__c, Incentive_Design_Factor__c, cost_per_watt_AC__c, cost_per_watt_DC__c, Monthly_Electric_Bill_saving_year5__c, annual_excess__c FROM System_Production__r)	
                                   
                                 FROM Quote 
                                 WHERE id IN: mapOrgProduction.values()]) 
        {
        	System.debug('------------------qotsProduction'+qotsProduction);            
            System.debug('------------------10');
            for(Id amdProductionId : mapOrgProduction.keySet()) 
            {
                String Errormsg ='System Cost of Original quote and Amendment Quote is not same. Cannot proceed further';
                if(qotsProduction.System_Cost__c != mapQuoteProduction.get(amdProductionId).System_Cost__c  && (!qotsProduction.Account_Billing_Country__c.equalsIgnoreCase('Australia')))
                {
                    mapQuoteProduction.get(amdProductionId).Amendment_Copy_Error_Message__c = system.now()+Errormsg;
                    return;
                }
                if(mapOrgProduction.get(amdProductionId) == qotsProduction.Id) 
                {
                    System.debug('------------------9');
                   String Lease = qotsProduction.Consolidated_Lease_Number__c;
                   mapQuoteProduction.get(amdProductionId).Amended_Lease_number__c = qotsProduction.Consolidated_Lease_Number__c;
                    Quote q = qotsProduction.clone(false, true, true, true);
                    q.OpportunityId = qotsProduction.OpportunityId;
                    String NewQuote = Lease +'_Backup_'+system.now();
                    q.Name = NewQuote;
                    lstArchievedQuote.add(q);
                }
                  string FinanceMessage2 = qotsProduction.Financing_Amendment_Notes__c;
                    if(FinanceMessage2 == '' || FinanceMessage2 == null)
                    {
                    qotsProduction.Financing_Amendment_Notes__c = mapQuoteProduction.get(amdProductionId).Financing_Amendment_Notes__c;
                    }
                    else 
                    {
                     qotsProduction.Financing_Amendment_Notes__c = FinanceMessage2 + mapQuoteProduction.get(amdProductionId).Financing_Amendment_Notes__c;
                    }
                    
                    string Message2 = qotsProduction.Amendment_History1__c;
                    if(Message2 == '' || Message2 == null)
                    {
                    qotsProduction.Amendment_History1__c = mapQuoteProduction.get(amdProductionId).Amendment_Type__c + ' Amendment ' + system.now();
                    }
                    else
                    {
                    qotsProduction.Amendment_History1__c = Message2 + ' ' + mapQuoteProduction.get(amdProductionId).Amendment_Type__c + ' Amendment' + system.now();
                    
                    }
                qotsProduction.Production_Am_Date__c = system.now();
                qotsProduction.Amendment_Date__c = system.today();
                qotsProduction.Amendment_Quote_ID__c = mapQuoteProduction.get(amdProductionId).id;
                mapCopyAmeInfoQuote.put(qotsProduction.id,qotsProduction);
                /*
                //duplicate
                List<Lease_Schedule__c> tempLP = qotsProduction.Lease_Progress__r;
                //Prashant: 0309: Start
                //original                
                List<Lease_Schedule__c> tempAmeLP = mAmdQ.get(amdProductionId).Lease_Progress__r;
                System.debug('------------------8');
                System.debug('------------------tempLP'+tempLP);
                System.debug('------------------tempAmeLP'+tempAmeLP);
                if(!tempLP.isEmpty() && !tempAmeLP.isEmpty()) 
                {
                    for(Lease_Schedule__c ameLS: tempAmeLP)
                    {

                        for(Lease_Schedule__c orgLS: tempLP)
                        {
                            if(ameLS.Temp_Monthly_Lease_Payments__c== orgLS.Temp_Monthly_Lease_Payments__c)
                            {
                            orgLS.PeGu_Estimate__c = ameLS.PeGu_Estimate__c;
                            orgLS.Guaranteed_Range_of_Annual_Production__c = ameLS.Guaranteed_Range_of_Annual_Production__c;
                            orgLS.System_Production_Annual_Production__c = ameLS.System_Production_Annual_Production__c;
                            //orgLS.RoundOff_Rate_Per_KWH__c = ameLS.RoundOff_Rate_Per_KWH__c;
                            orgLS.Rate_Per_KWH__c = ameLS.Rate_Per_KWH__c;
                                System.debug('-----------------orgLS='+orgLS.Rate_Per_KWH__c);
                            lstLP.add(orgLS);                               
                            }
                        }
                    }
                }
               /* 
                ////
                //duplicate
               
                System.debug(LoggingLevel.ERROR,'qotsProduction.System_Production__r='+qotsProduction.System_Production__r);
                System.debug(LoggingLevel.ERROR,'qotsProduction.System_Production__r='+qotsProduction.System_Production__r);
                List<System_Production__c> listCopySystemProduction = qotsProduction.System_Production__r;
                               
                List<System_Production__c> listOriginalSystemProduction = mAmdQ.get(amdProductionId).System_Production__r;
                System.debug(LoggingLevel.ERROR,'------------------8');
                if(listCopySystemProduction.size()>0 && listOriginalSystemProduction.size()>0){
				System_Production__c objCopy = listCopySystemProduction.get(0);
				objCopy.annual_Produced__c = listOriginalSystemProduction.get(0).annual_Produced__c;
                listSystemProduction.add(objCopy);                               
                qotsProduction.System_Production_Year_1__c = listOriginalSystemProduction.get(0).annual_Produced__c;           
                System.debug(LoggingLevel.ERROR,'qotsProduction.System_Production_Year_1__c+'+qotsProduction.System_Production_Year_1__c);
                }
                */
                
                
                /////
            }
        }
    }
    if(!mapQuote.isEmpty())
    {
        System.debug('------------------mapQuote'+mapQuote);
        for(Quote qots: [SELECT System_Production_Year_1__c,id, name, opportunityId,
                                Module_Oracle_Item_Number__c, Quote_Inverter_Values__c,Module__c,
                                Module_Brand__c, Module_Quantity__c, System_Cost__c,
                                Module_Type__c, Monitoring_System_Model__c,
                                Monitoring_System_Option__c, Monitoring_System_Quantity__c, 
                                Mounting_Option__c, Construction__c, 
                                Dealer_Fees__c, Interconnect__c, 
                                Inverter_Brand__c, Origination__c,
                                Inverter_Brand_2__c, Inverter_Brand_3__c, Racking_Nu__c,Racking_Quantity__c,
                                Inverter_Brand_4__c, Inverter_Model__c,Amendment_History1__c,Financing_Amendment_Notes__c,
                                Inverter_Model_2__c, Inverter_Model_3__c, Consolidated_Lease_Number__c,
                                Inverter_Model_4__c, System_Size__c,Account_Billing_Country__c,Monitoring_System__c,Total_Energy__c,Maximum_Rated_Capacity__c,
                                Rollup_Lease_95_of_S_P_A_P__c,Rollup_Lease_105_of_S_P_A_P__c,(SELECT Id,  Quote__c, netcostdetail_cost__c, System_Size_DC__c, System_Size_AC__c, Upfront_Incentives__c, Monthly_Electric_Bill_Without_PV_year1__c, Monthly_Electric_Bill_With_PV_year1__c, annual_Produced__c, annual_Purchased__c, Percentage_Electricity_Produced__c, Monthly_Electric_Bill_saving_year1__c, netCostDetail_netCost__c, Cash_Price_Return_On_Investment_year1__c, Monthly_Electric_Bill_Without_PV_year5__c, Monthly_Electric_Bill_With_PV_year5__c, Cash_Price_Return_On_Investment_year5__c, Monthly_Lease_Payment__c, Monthly_Lease_Payment7_50discount__c, Upfront_Lease_Payment__c, Incentive_Design_Factor__c, cost_per_watt_AC__c, cost_per_watt_DC__c, Monthly_Electric_Bill_saving_year5__c, annual_excess__c FROM System_Production__r),
                         		(SELECT Id,X95_of_S_P_A_P_1__c,X105_of_S_P_A_P_1__c,Name, CurrencyIsoCode, Quote__c, Annual_Lease_Payment__c, Annual_Lease_Payments_Year__c, Annual_SystemProduction_Guarantee_Year__c, Approximate_Price_per_kWh__c, Base_Monthy_Payment__c, Est_Monthly_Paymt_w_o_formula__c, Est_Mthly_Paymt_includingTax_w_auto_ACH__c, Est_Mthly_Paymt_with_formula__c, Estimated_Monthly_Payment_inclusive_of_T__c, Estimated_Tax_on_Monthly_Payment__c, Guarantee_Year__c, Guaranteed_Range_of_Annual_Production__c, Lease_Payments_Year__c, Monthly_Payments_and_with_automatic_ACH__c,PeGu_Estimate__c, Rate_Per_KWH__c, Record_Count__c, Remaining_Lease_Period__c, Remaining_Lease_Value__c, RoundOff_Base_Monthly_Payment__c, RoundOff_Rate_Per_KWH__c, RoundOff_Remaining_Lease_Value__c, System_Production_Annual_Production__c, Temp_Monthly_Lease_Payments__c, X105_of_S_P_A_P__c, X95_of_S_P_A_P__c, Final_Base_Monthly_Payment__c, Final_Estimated_Tax_on_Monthly__c, Final_Estimated_Monthly_W_Tax_No_ACH__c, Final_Estimated_Monthly_W_Tax_W_ACH__c, Final_Total_Yearly_Page_2__c, Final_Total_Yearly_Page_4__c, Final_Estimated_Monthly_W_Tax_No_ACH_p2__c, Tax_Rate__c, Final_Tax_Rate__c FROM Lease_Progress__r)
                                FROM Quote 
                                 WHERE id IN: mapOrg.values()]) 
        {
            System.debug('------------------qots='+qots);        
            //Case:00483868 
            for(Id amdProductionId : mapOrg.keySet()) 
            {
                 System.debug(LoggingLevel.ERROR,'qotsProduction.System_Production__r='+qots.System_Production__r);
                System.debug(LoggingLevel.ERROR,'qotsProduction.System_Production__r='+qots.System_Production__r);
                
                if(mapOrg.get(amdProductionId) == qots.Id) {
                    List<System_Production__c> listCopySystemProduction = qots.System_Production__r;
                                   
                    List<System_Production__c> listOriginalSystemProduction = mAmdQ.get(amdProductionId).System_Production__r;
                    System.debug(LoggingLevel.ERROR,'------------------8');
                    if(listCopySystemProduction.size()>0 && listOriginalSystemProduction.size()>0){
                    System_Production__c objCopy = listCopySystemProduction.get(0);
                    objCopy.annual_Produced__c = listOriginalSystemProduction.get(0).annual_Produced__c;
                    objCopy.annual_Purchased__c = listOriginalSystemProduction.get(0).annual_Purchased__c;    	
                  	objCopy.Total_Energy__c = listOriginalSystemProduction.get(0).Total_Energy__c;
                    objCopy.System_Size_AC__c = listOriginalSystemProduction.get(0).System_Size_AC__c;
                         
                    listSystemProduction.add(objCopy);     
                    
                    //qots.Rollup_Lease_95_of_S_P_A_P__c =  mAmdQ.get(amdProductionId).Rollup_Lease_95_of_S_P_A_P__c;
                    //qots.Rollup_Lease_105_of_S_P_A_P__c =  mAmdQ.get(amdProductionId).Rollup_Lease_105_of_S_P_A_P__c;
                    
                        
                    System.debug(LoggingLevel.ERROR,'qots.System_Production_Year_1__c+'+qots.System_Production_Year_1__c);
                    System.debug(LoggingLevel.ERROR,'qots.System_Production_Year_1__c+'+qots.id);
                        if(mapCopyAmeInfoQuote.containsKey(qots.id)){
                        	Quote objQuote = mapCopyAmeInfoQuote.get(qots.id) ;
                            System.debug('----------------- objQuote.id='+ objQuote.id);
                            System.debug('----------------- qots.id='+ mAmdQ.get(amdProductionId).id);
                            System.debug('----------------- qots.id='+ mAmdQ.get(amdProductionId).System_Production_Year_1__c);
                            objQuote.System_Production_Year_1__c = mAmdQ.get(amdProductionId).System_Production_Year_1__c;
                            mapCopyAmeInfoQuote.put(objQuote.id, objQuote);
                        }
                        //mapCopyAmeInfoQuote.put(qots.id,qots);      
                    
                  }
                    List<Lease_Schedule__c> tempLP = qots.Lease_Progress__r;
                //Prashant: 0309: Start
                //original                
                List<Lease_Schedule__c> tempAmeLP = mAmdQ.get(amdProductionId).Lease_Progress__r;
                System.debug('------------------8');
                System.debug('------------------tempLP'+tempLP);
                System.debug('------------------tempAmeLP'+tempAmeLP);
                if(!tempLP.isEmpty() && !tempAmeLP.isEmpty()) 
                {
                    for(Lease_Schedule__c ameLS: tempAmeLP)
                    {

                        for(Lease_Schedule__c orgLS: tempLP)
                        {
                            if(ameLS.Temp_Monthly_Lease_Payments__c== orgLS.Temp_Monthly_Lease_Payments__c)
                            {
                            orgLS.PeGu_Estimate__c = ameLS.PeGu_Estimate__c;
                            orgLS.Guaranteed_Range_of_Annual_Production__c = ameLS.Guaranteed_Range_of_Annual_Production__c;
                            orgLS.System_Production_Annual_Production__c = ameLS.System_Production_Annual_Production__c;
                           	orgLS.Rate_Per_KWH__c = ameLS.Rate_Per_KWH__c;
                            orgLS.X95_of_S_P_A_P_1__c = ameLS.X95_of_S_P_A_P_1__c;
                            orgLS.X105_of_S_P_A_P_1__c = ameLS.X105_of_S_P_A_P_1__c;   
                                System.debug('-----------------orgLS='+orgLS.Rate_Per_KWH__c);
                            lstLP.add(orgLS);                               
                            }
                        }
                    }
                }
                    
                    Quote objQuote = mapCopyAmeInfoQuote.get(qots.id) ;
                    
                    objQuote.Module_Brand__c =  mAmdQ.get(amdProductionId).Module_Brand__c;
                    objQuote.Module__c =  mAmdQ.get(amdProductionId).Module__c;
                    objQuote.Module_Quantity__c = mAmdQ.get(amdProductionId).Module_Quantity__c;
                    //qots.Maximum_Rated_Capacity__c =  mAmdQ.get(amdProductionId).Maximum_Rated_Capacity__c;
                    objQuote.Quote_Inverter_Values__c =  mAmdQ.get(amdProductionId).Quote_Inverter_Values__c;
                    objQuote.Monitoring_System__c =  mAmdQ.get(amdProductionId).Monitoring_System__c;
                    objQuote.Mounting_Option__c =  mAmdQ.get(amdProductionId).Mounting_Option__c;
                    objQuote.Total_Energy__c =  mAmdQ.get(amdProductionId).Total_Energy__c;
                    System.debug('----------------- objQuote.id'+ objQuote.id);
                    System.debug('----------------- mAmdQ.get(amdProductionId).System_Production_Year_1__c.Total_Energy__c='+ mAmdQ.get(amdProductionId).id);
                    System.debug('----------------- objQuote.Total_Energy__c'+ objQuote.Total_Energy__c);
                    System.debug('----------------- qots.Total_Energy__c'+qots.Total_Energy__c);
                    mapCopyAmeInfoQuote.put(qots.id, objQuote);
                    
                }
            }
            
        }
    }
    // Reetan
    if(Test.isRunningTest() == false)
    {
    
        if(!lstArchievedQuote.isEmpty())
            insert lstArchievedQuote;
    
        if(!mapCopyAmeInfoQuote.isEmpty())
            update mapCopyAmeInfoQuote.values();
        
        if(!lstQL.isEmpty())
            insert lstQL;
        
        if(!lstLP.isEmpty())
            update lstLP; 
    
        if(!lstQLDelete.isEmpty())
            delete lstQLDelete;
         if(!listSystemProduction.isEmpty())
            upsert listSystemProduction;
     }    //
   }
}