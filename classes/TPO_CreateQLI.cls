/*** Class added in Sunpower TPO Phase 1 -- 20/10/2013, to create Quote Line Item ***/
public class TPO_CreateQLI {/*
    Quote Quote = new Quote();
    public TPO_CreateQLI(ApexPages.StandardController controller) {
    
       
    }
    
    //Create quote line item
    public PageReference createQuoteLine(){
        PageReference p;
        Id  quoteID= ApexPages.currentPage().getParameters().get('qid');
        Decimal DealerFee = 0.0;
        Quote = [SELECT ID,Name,Module__c,Consolidated_Lease_Number__c,ERDF_Fee__c,Origination__c,
                                Description__c,OracleItemNumber__c,
                                System_Cost__c,
                                InstallDate__c,
                                Modules__c,
                                Module_Count__c,
                                Modules_Per_String__c,
                                Total_Parallel_Strings__c,
                                Inverter_Manufacturer__c,
                                InverterModel__c,
                                Inverter_Count__c  ,
                                Mounting_Description__c,
                                Racking_Quantity__c,
                                Monitoring_System__c,
                                Production_Shaver__c,
                                Full_Prepaid_Lease__c,
                                Lease_Annual_Escalation__c,
                                Buydown_Override__c,
                                PBI_Override__c,
                                PBI_Amount__c,
                                PBI_Years__c,
                                Partial_target__c,
                                Partial_Prepayment__c,
                                Target_Implied_Rate__c,
                                Target_implied_target__c,
                                Design_Factor__c,
                                Design_Factor_value__c,
                                Optional_Incentives__c,
                                REC_Value_kWh__c,
                                QuoteNumber,                              
                                REC_Escalation__c,
                                REC_Life_Years__c,
                                Proposed_Electric_Utility__c,
                                ProposedRate__c,
                                Utility_Bill_Annual_Escalation__c,
                                QuoteType__c,
                                LastModifiedByid,
                                Account__c,
                                Is_Locked__c,
                                Inverter_Manufacturer_Roof1__c,
                                Inverter_Manufacturer_Roof2__c,
                                Inverter_Manufacturer_Roof3__c,
                                Inverter_Manufacturer_Roof4__c,
                                Modules_Per_String_Roof1__c,
                                Modules_Per_String_Roof2__c,
                                Modules_Per_String_Roof3__c,
                                Modules_Per_String_Roof4__c,                                
                                Total_Parallel_Strings_Roof2__c,                                                              
                                Inverter_Quantity__c,
                                Inverter_Quantity_2__c,
                                Inverter_Quantity_3__c,
                                Inverter_Quantity_4__c,
                                Inverter_Model__c,
                                Inverter_Model_2__c,
                                Inverter_Model_3__c,
                                Inverter_Model_4__c,
                                Cash_Amount__c ,
                                Cash_Amount1__c ,                                
                                Cash_Amount2__c ,                                                               
                                Cash_Amount3__c ,                                                                                               
                                Cash_Description__c ,
                                Cash_Description1__c ,                              
                                Cash_Description2__c ,                              
                                Cash_Description3__c ,                              
                                Taxable__c,
                                Taxable1__c,                                
                                Taxable2__c,                                
                                Taxable3__c,                                
                                Net_Cost__c,
                                Proposed_Rate_Name__c, 
                                Incentives_detail_1__c,
                                Incentives_detail_1_amt__c,
                                Incentives_detail_2__c,
                                Incentives_detail_2_amt__c,
                                Incentives_detail_3__c,
                                Total_Cost__c,
                                Total_Incentive__c,
                                Latitude__c,
                                Longitude__c,
                                Start_Date__c,
                                End_Date__c,
                                Inverter_0_StandarInverterId__c,
                                Inverter_0_Layout_0_StandardPVModuleId__c,
                                Inv_0_Layout_0_ModuleCountPerString__c,
                                Inv_0_Layout_0_ParallelStringsCount__c,   
                                Inverter_0_Layout_0_AxisTiltAngle__c,
                                Inverter_0_Layout_0_SystemAzimuth__c,
                                Inverter_0_Layout_0_Shading_Month_1__c,
                                Inverter_0_Layout_0_Shading_Month_2__c,
                                Inverter_0_Layout_0_Shading_Month_3__c,
                                Inverter_0_Layout_0_Shading_Month_4__c,
                                Inverter_0_Layout_0_Shading_Month_5__c,
                                Inverter_0_Layout_0_Shading_Month_6__c,
                                Inverter_0_Layout_0_Shading_Month_7__c,
                                Inverter_0_Layout_0_Shading_Month_8__c,
                                Inverter_0_Layout_0_Shading_Month_9__c,
                                Inverter_0_Layout_0_Shading_Month_10__c,
                                Inverter_0_Layout_0_Shading_Month_11__c,
                                Inverter_0_Layout_0_Shading_Month_12__c,
                                Status__c,Fit_Rate__c,
                                Elapsed_Time__c,
                                Total_Energy__c,
                                Recalculate__c,Annual_target__c,Buydown_Amount__c,System_Model__c,Isnew__c ,
                                Not_An_Historical_Quote__c,
                                Sales_Tax_Rate__c,
                                On_Markup_Only__c,
                                Income__c,Racking__c,Irregular_Roof__c,
                                Design_Help_Status__c,
                                Multiple_Roofs__c,                             
                                Inverter_Model_Roof1__c,Inverter_Count_Roof1__c,Inverter_Model_Roof3__c,
                                Inverter_Count_Roof2__c, Inverter_Count_Roof3__c, Inverter_Count_Roof4__c,
                                Inverter_Model_Roof2__c, Inverter_Model_Roof4__c,                                     
                                Roof_1_MPPT_1_Module__c, Roof_1_MPPT_1_string__c,
                                Roof_1_MPPT_2_Module__c, Roof_1_MPPT_2_string__c, Roof_1_MPPT_3_Module__c,
                                Roof_1_MPPT_3_string__c, Roof_1_MPPT_4_Module__c, Roof_1_MPPT_4_string__c,
                                Roof_2_MPPT_1_Module__c, Roof_2_MPPT_1_string__c, Roof_2_MPPT_2_Module__c,
                                Roof_2_MPPT_2_string__c, Roof_2_MPPT_3_Module__c, Roof_2_MPPT_3_string__c,
                                Roof_2_MPPT_4_Module__c, Roof_2_MPPT_4_string__c, Roof_3_MPPT_1_Module__c,
                                Roof_3_MPPT_1_string__c, Roof_3_MPPT_2_Module__c, Roof_3_MPPT_2_string__c,
                                Roof_3_MPPT_3_Module__c, Roof_3_MPPT_3_string__c, Roof_3_MPPT_4_Module__c,
                                Roof_3_MPPT_4_string__c, Roof_4_MPPT_1_Module__c, Roof_4_MPPT_1_string__c,
                                Roof_4_MPPT_2_Module__c, Roof_4_MPPT_2_string__c, Roof_4_MPPT_3_Module__c,
                                Roof_4_MPPT_3_string__c, Roof_4_MPPT_4_Module__c, Roof_4_MPPT_4_string__c,
                                System_Model_FR__c, Total_Parallel_Strings_Roof1__c,
                                Total_Parallel_Strings_Roof4__c,
                                Total_Parallel_Strings_Roof3__c,
                                Dealer_Fees__c,
                                Filing_Status__c,
                                Customer_s_DownPayment_1__c,Grid_Connection_Type__c,Trenching__c,Quote_MandateFields__c,Wiring_Distance__c,DownPayment_Type__c,
                                Customer_s_DownPayment_2__c,DC_Cabinet_Multiple_Roofs__c,Ac_Cabinet_Type__c,Inverter_Count_Multiple_Roofs__c,DC_Cabinet__c,DC_Cabinet_Roof2__c,DC_Cabinet_Roof3__c,DC_Cabinet_Roof4__c,Original_ERDFFee__c FROM Quote WHERE Id =: quoteID];
        
        
         List<Global_Variable__c> gvList = [SELECT Name,End_Date__c,Start_Date__c,Variable_Type__c,Variable_Value__c FROM Global_Variable__c WHERE Variable_Type__c =:'TPO France'];

    for (Global_Variable__c gv : gvList )
        {

            If ((gv.Name == 'FitRate' ) && ( gv.End_Date__c > system.today()))
            {
                If ( Quote != null)
                {
                    If (Quote.Fit_Rate__c == null)
                    {
                        Quote.Fit_Rate__c    =   decimal.ValueOf(gv.Variable_Value__c);
                    }
                    Quote.Original_FitRate__c =   decimal.ValueOf(gv.Variable_Value__c);
                }
                
            }
            else if ((gv.Name == 'ERDFFee' ) && ( gv.End_Date__c > system.today()))
            {
                If ( Quote != null)
                {
                    If (Quote.ERDF_Fee__c == null)
                    {
                        Quote.ERDF_Fee__c    =   decimal.ValueOf(gv.Variable_Value__c);
                    }
                    Quote.Original_ERDFFee__c =   decimal.ValueOf(gv.Variable_Value__c);
                }
                
            }
            else if ((gv.Name == 'Origination' ) && ( gv.End_Date__c > system.today()))
            {
                If ( Quote != null)
                {
                    //  Quote.Origination__c    = ((DealerFee)*(.25));
                    //DealerFee = Quote.Dealer_Fees__c;
                    Quote.Origination__c    = ((DealerFee)*(decimal.ValueOf(gv.Variable_Value__c)));
                    //Quote.Origination__c    = ((DealerFee)*(decimal.ValueOf(gv.Variable_Value__c)));
                }
                
            }
            else if ((gv.Name == 'Interconnection' ) && ( gv.End_Date__c > system.today()))
            {
                If ( Quote != null)
                {

                        Quote.Interconnect__c    =   ((DealerFee)* (decimal.ValueOf(gv.Variable_Value__c)));

                }
                
            }
            //Ashok_Oct1
            else if ((gv.Name == 'FITRateEsc' ) && ( gv.End_Date__c > system.today()))
            {
                If ( Quote != null)
                {

                        Quote.Fit_Annual_Esc__c =   (decimal.ValueOf(gv.Variable_Value__c));

                }
                
            }
            //Ashok_Oct1
            
        }
        
        
        
        
        List<Quote_Line__c> lst_QLIToInsert = new List<Quote_Line__c>();
        Map<String,Quote_Line__c> Quote_Line_Map = new Map<String,Quote_Line__c>();
        Boolean monitoringRecordsCheck = false;
        String ACCabinetType;
        List<Price_List_Item__c> lst_PLI = [select Id, Name, Item_ID__r.Item_ID__c, Item_ID__c,Item_Description__c,
        Category__c,Manufacturing_cost__c from Price_List_Item__c WHERE Price_List__r.Name =: 'TPO FR Pricelist'];
        
        Map<String, ID> map_InvModelToItemId = new Map<String, ID>();
        Map<String, Decimal> map_CostToPriceItem = new Map<String, Decimal>();
            If(lst_PLI.size()>0)
            {
                for(Price_List_Item__c pli : lst_PLI){
                    map_InvModelToItemId.put(pli.Name, pli.Item_ID__c);
                    map_CostToPriceItem.put(pli.Name, pli.Manufacturing_cost__c);
                    //New Code -- Sunpower TPO AC Cabinet -- 04/05/2014
                    if (Quote.Ac_Cabinet_Type__c != null && pli.name.contains(Quote.Ac_Cabinet_Type__c))
                    {
                        ACCabinetType = pli.name;
                    }
                    //End New Code -- Sunpower TPO AC Cabinet -- 04/05/2014
                }
            }
            if(Quote.Inverter_Model_Roof1__c != null){
                System.debug('################ Inverter_Model_Roof1__c: ' + Quote.Inverter_Model_Roof1__c);
                Quote_Line__c qtli = new Quote_Line__c();
                qtli.Quantity__c = 1;
                qtli.Quote__c = Quote.Id;
                qtli.Roof__c = 'SF Roof 1';
                 system.debug('******Map val**'+map_InvModelToItemId.get(Quote.Inverter_Model_Roof1__c));
                qtli.Item__c = map_InvModelToItemId.get(Quote.Inverter_Model_Roof1__c) != null ? map_InvModelToItemId.get(Quote.Inverter_Model_Roof1__c): null;
                qtli.Unit_Price__c = map_CostToPriceItem.get(Quote.Inverter_Model_Roof1__c) != null ? map_CostToPriceItem.get(Quote.Inverter_Model_Roof1__c): null;
                
                if(qtli.Item__c!=null)
                {
                    system.debug('******i am in**'+qtli.Item__c);
                    system.debug('*****qtli**'+qtli);
                    
                    lst_QLIToInsert.add(qtli);
                    //Quote_Line_Map.put(qtli.Item__c,qtli);
                }    
            }   
            if(Quote.Inverter_Model__c != null){
                System.debug('################ Inverter_Model__c: ' + Quote.Inverter_Model__c);
                Quote_Line__c qtli = new Quote_Line__c();
                qtli.Quantity__c = 1;
                qtli.Quote__c = Quote.Id;
                qtli.Roof__c = 'SF Roof 1';
                qtli.Item__c = map_InvModelToItemId.get(Quote.Inverter_Model__c) != null ? map_InvModelToItemId.get(Quote.Inverter_Model__c): null;
                qtli.Unit_Price__c = map_CostToPriceItem.get(Quote.Inverter_Model__c) != null ? map_CostToPriceItem.get(Quote.Inverter_Model__c): null;
                
                if(qtli.Item__c!=null)
                {
                    lst_QLIToInsert.add(qtli);  
                    //Quote_Line_Map.put(qtli.Item__c,qtli);
                }    
                
            }
            
            if(Quote.Inverter_Model_Roof2__c != null ){
                System.debug('############################# updating QuoteLIneItem1');
                Quote_Line__c qtli = new Quote_Line__c();
                qtli.Quantity__c = 1;
                qtli.Quote__c = Quote.Id;
                qtli.Roof__c = 'SF Roof 2';
                qtli.Item__c = map_InvModelToItemId.get(Quote.Inverter_Model_Roof2__c) != null ? map_InvModelToItemId.get(Quote.Inverter_Model_Roof2__c): null;
                qtli.Unit_Price__c  = map_CostToPriceItem.get(Quote.Inverter_Model_Roof2__c) != null ? map_CostToPriceItem.get(Quote.Inverter_Model_Roof2__c): null;
                
                if(qtli.Item__c!=null)
                {
                    lst_QLIToInsert.add(qtli);
                    //Quote_Line_Map.put(qtli.Item__c,qtli);
                }                    
               
            }
            
            if(Quote.Inverter_Model_2__c!= null ){
                System.debug('################ Inverter_Model_2__c: ' + Quote.Inverter_Model_2__c);
                Quote_Line__c qtli = new Quote_Line__c();
                qtli.Quantity__c = 1;
                qtli.Quote__c = Quote.Id;
                qtli.Roof__c = 'SF Roof 2';
                qtli.Item__c = map_InvModelToItemId.get(Quote.Inverter_Model_2__c) != null ? map_InvModelToItemId.get(Quote.Inverter_Model_2__c): null;
                qtli.Unit_Price__c = map_CostToPriceItem.get(Quote.Inverter_Model_2__c) != null ? map_CostToPriceItem.get(Quote.Inverter_Model_2__c): null;
                
                if(qtli.Item__c!=null)
                {
                    lst_QLIToInsert.add(qtli);
                    //Quote_Line_Map.put(qtli.Item__c,qtli);
                }    
               
            }
            
            if(Quote.Inverter_Model_Roof3__c != null ){
                System.debug('################ Inverter_Model_Roof3__c : ' + Quote.Inverter_Model_Roof3__c);   
                Quote_Line__c qtli = new Quote_Line__c();
                qtli.Quantity__c = 1;
                qtli.Quote__c = Quote.Id;
                qtli.Roof__c = 'SF Roof 3';
                qtli.Item__c = map_InvModelToItemId.get(Quote.Inverter_Model_Roof3__c) != null ? map_InvModelToItemId.get(Quote.Inverter_Model_Roof3__c): null;
                qtli.Unit_Price__c = map_CostToPriceItem.get(Quote.Inverter_Model_Roof3__c) != null ? map_CostToPriceItem.get(Quote.Inverter_Model_Roof3__c): null;
                
                if(qtli.Item__c!=null)
                {
                    lst_QLIToInsert.add(qtli);
                    //Quote_Line_Map.put(qtli.Item__c,qtli);
                }    
                
            }
            
            if(Quote.Inverter_Model_3__c != null ){
                Quote_Line__c qtli = new Quote_Line__c();
                qtli.Quantity__c = 1;
                qtli.Quote__c = Quote.Id;
                qtli.Roof__c = 'SF Roof 3';
                qtli.Item__c = map_InvModelToItemId.get(Quote.Inverter_Model_3__c) != null ? map_InvModelToItemId.get(Quote.Inverter_Model_3__c): null;
                qtli.Unit_Price__c = map_CostToPriceItem.get(Quote.Inverter_Model_3__c) != null ? map_CostToPriceItem.get(Quote.Inverter_Model_3__c): null;
                
                if(qtli.Item__c!=null)
                {
                    lst_QLIToInsert.add(qtli);
                    //Quote_Line_Map.put(qtli.Item__c,qtli);
                }    
                
            }
            
            if(Quote.Inverter_Model_Roof4__c != null ){
                Quote_Line__c qtli = new Quote_Line__c();
                qtli.Quantity__c = 1;
                qtli.Quote__c = Quote.Id;
                qtli.Roof__c = 'SF Roof 4';
                qtli.Item__c = map_InvModelToItemId.get(Quote.Inverter_Model_Roof4__c) != null ? map_InvModelToItemId.get(Quote.Inverter_Model_Roof4__c): null;
                qtli.Unit_Price__c = map_CostToPriceItem.get(Quote.Inverter_Model_Roof4__c) != null ? map_CostToPriceItem.get(Quote.Inverter_Model_Roof4__c): null;
                
                if(qtli.Item__c!=null)
                {
                   lst_QLIToInsert.add(qtli);
                   //Quote_Line_Map.put(qtli.Item__c,qtli);
                }    
                
            }
            
            if(Quote.Inverter_Model_4__c != null ){
                Quote_Line__c qtli = new Quote_Line__c();
                qtli.Quantity__c = 1;
                qtli.Quote__c = Quote.Id;
                qtli.Roof__c = 'SF Roof 4';
                qtli.Item__c = map_InvModelToItemId.get(Quote.Inverter_Model_4__c) != null ? map_InvModelToItemId.get(Quote.Inverter_Model_4__c): null;
                qtli.Unit_Price__c = map_CostToPriceItem.get(Quote.Inverter_Model_4__c) != null ? map_CostToPriceItem.get(Quote.Inverter_Model_4__c): null;
                
                if(qtli.Item__c!=null)
                {
                    lst_QLIToInsert.add(qtli);
                    //Quote_Line_Map.put(qtli.Item__c,qtli);
                }    
                
            }
           //Ashok
           
            //if(Quote.Dealer_Fees__c != null ){
                //Quote_Line__c qtli = new Quote_Line__c();
                //qtli.Quantity__c = 1000;
                //qtli.Quote__c = Quote.Id;
                //qtli.Roof__c = 'Quote';
                //qtli.Item__c = map_InvModelToItemId.get('ERDFOA Fee') != null ? map_InvModelToItemId.get('ERDFOA Fee'): null;
                //qtli.Unit_Price__c = map_CostToPriceItem.get('ERDFOA Fee') != null ? map_CostToPriceItem.get('ERDFOA Fee'): null;
                
                //if(qtli.Item__c!=null)
                //{
                   // lst_QLIToInsert.add(qtli);
                    //Quote_Line_Map.put(qtli.Item__c,qtli);
                //} 
                
            //} 
        
            //DC Cabinet
            if((Quote.DC_Cabinet__c != null || Quote.DC_Cabinet_Roof2__c != null || Quote.DC_Cabinet_Roof3__c != null || Quote.DC_Cabinet_Roof4__c != null) && (Quote.DC_Cabinet_Multiple_Roofs__c > 0)){
                Quote_Line__c qtli = new Quote_Line__c();
                qtli.Quantity__c = Quote.DC_Cabinet_Multiple_Roofs__c;
                qtli.Quote__c = Quote.Id;
                qtli.Roof__c = 'Quote';
                qtli.Item__c = map_InvModelToItemId.get('DC-CABINET') != null ? map_InvModelToItemId.get('DC-CABINET'): null;
                qtli.Unit_Price__c = map_CostToPriceItem.get('DC-CABINET') != null ? map_CostToPriceItem.get('DC-CABINET'): null;
                
                if(qtli.Item__c!=null)
                {
                   // lst_QLIToInsert.add(qtli);
                    Quote_Line_Map.put(qtli.Item__c,qtli);
                }    
                
            }

            if(Quote.Dealer_Fees__c != null ){
                Quote_Line__c qtli = new Quote_Line__c();
                qtli.Quantity__c = 1;
                qtli.Quote__c = Quote.Id;
                qtli.Roof__c = 'Quote';
                qtli.Item__c = map_InvModelToItemId.get('ERDFOA Fee') != null ? map_InvModelToItemId.get('ERDFOA Fee'): null;
                qtli.Unit_Price__c = map_CostToPriceItem.get('ERDFOA Fee') != null ? map_CostToPriceItem.get('ERDFOA Fee'): null;
                
                if(qtli.Item__c!=null)
                {
                   // lst_QLIToInsert.add(qtli);
                    Quote_Line_Map.put(qtli.Item__c,qtli);
                }    
                
            }

            /*if(Quote.DC_Cabinet_Roof2__c != null // && Trigger.OldMap.get(q.Id).Inverter_Model_4__c!= null && q.Inverter_Model_4__c != Trigger.OldMap.get(q.Id).Inverter_Model_4__c ){
                Quote_Line__c qtli = new Quote_Line__c();
                qtli.Quantity__c = Quote.DC_Cabinet_Roof2__c;
                qtli.Quote__c = Quote.Id;
                qtli.Roof__c = 'SF Roof2';
                qtli.Item__c = map_InvModelToItemId.get('DC-CABINET') != null ? map_InvModelToItemId.get('DC-CABINET'): null;
                qtli.Unit_Price__c = map_CostToPriceItem.get('DC-CABINET') != null ? map_CostToPriceItem.get('DC-CABINET'): null;
                
                if(qtli.Item__c!=null)
                {
                   // lst_QLIToInsert.add(qtli);
                    Quote_Line_Map.put(qtli.Item__c,qtli);
                }    
                
            }

            if(Quote.DC_Cabinet_Roof3__c != null // && Trigger.OldMap.get(q.Id).Inverter_Model_4__c!= null && q.Inverter_Model_4__c != Trigger.OldMap.get(q.Id).Inverter_Model_4__c ){
                Quote_Line__c qtli = new Quote_Line__c();
                qtli.Quantity__c = Quote.DC_Cabinet_Roof3__c;
                qtli.Quote__c = Quote.Id;
                qtli.Roof__c = 'SF Roof3';
                qtli.Item__c = map_InvModelToItemId.get('DC-CABINET') != null ? map_InvModelToItemId.get('DC-CABINET'): null;
                qtli.Unit_Price__c = map_CostToPriceItem.get('DC-CABINET') != null ? map_CostToPriceItem.get('DC-CABINET'): null;
                
                if(qtli.Item__c!=null)
                {
                   // lst_QLIToInsert.add(qtli);
                    Quote_Line_Map.put(qtli.Item__c,qtli);
                }    
                
            }

            if(Quote.DC_Cabinet_Roof4__c != null // && Trigger.OldMap.get(q.Id).Inverter_Model_4__c!= null && q.Inverter_Model_4__c != Trigger.OldMap.get(q.Id).Inverter_Model_4__c ){
                Quote_Line__c qtli = new Quote_Line__c();
                qtli.Quantity__c = Quote.DC_Cabinet_Roof4__c;
                qtli.Quote__c = Quote.Id;
                qtli.Roof__c = 'SF Roof4';
                qtli.Item__c = map_InvModelToItemId.get('DC-CABINET') != null ? map_InvModelToItemId.get('DC-CABINET'): null;
                qtli.Unit_Price__c = map_CostToPriceItem.get('DC-CABINET') != null ? map_CostToPriceItem.get('DC-CABINET'): null;
                
                if(qtli.Item__c!=null)
                {
                   // lst_QLIToInsert.add(qtli);
                    Quote_Line_Map.put(qtli.Item__c,qtli);
                }    
                
            }
            *//*

            if(Quote.Dealer_Fees__c != null ){
                Quote_Line__c qtli = new Quote_Line__c();
                //qtli.Quantity__c = Quote.ERDF_Fee__c;
               If (Quote.ERDF_Fee__c != null || Quote.ERDF_Fee__c > 0)
               {
                    qtli.Quantity__c = Quote.ERDF_Fee__c;
               }
                else
               {
                    qtli.Quantity__c = Quote.Original_ERDFFee__c;
               }
                qtli.Quote__c = Quote.Id;
                qtli.Roof__c = 'Quote';
                qtli.Item__c = map_InvModelToItemId.get('ERDF Fee') != null ? map_InvModelToItemId.get('ERDF Fee'): null;
                qtli.Unit_Price__c = map_CostToPriceItem.get('ERDF Fee') != null ? map_CostToPriceItem.get('ERDF Fee'): null;
                
                if(qtli.Item__c!=null)
                {
                   // lst_QLIToInsert.add(qtli);
                    Quote_Line_Map.put(qtli.Item__c,qtli);
                }    
                
            }
        
            if(Quote.Origination__c != null ){
                Quote_Line__c qtli = new Quote_Line__c();
                qtli.Quantity__c = Quote.Origination__c;
                qtli.Quote__c = Quote.Id;
                qtli.Roof__c = 'Quote';
                qtli.Item__c = map_InvModelToItemId.get('Origination Fee') != null ? map_InvModelToItemId.get('Origination Fee'): null;
                qtli.Unit_Price__c = map_CostToPriceItem.get('Origination Fee') != null ? map_CostToPriceItem.get('Origination Fee'): null;
                
                if(qtli.Item__c!=null)
                {
                   // lst_QLIToInsert.add(qtli);
                    Quote_Line_Map.put(qtli.Item__c,qtli);
                }    
                
            }
            Quote.Dealer_Fees__c = DealerFee;
            system.debug('******11111******'+Quote.Dealer_Fees__c);
            system.debug('******22222******'+Quote.Origination__c );
            system.debug('******33333******'+Quote.Interconnect__c);
            Decimal InstalationFees = Quote.Dealer_Fees__c - Quote.Origination__c - Quote.Interconnect__c;
            if(InstalationFees != null ){
                Quote_Line__c qtli = new Quote_Line__c();
                qtli.Quantity__c = InstalationFees ;
                qtli.Quote__c = Quote.Id;
                qtli.Roof__c = 'Quote';
                qtli.Item__c = map_InvModelToItemId.get('Installation Fee') != null ? map_InvModelToItemId.get('Installation Fee'): null;
                qtli.Unit_Price__c = map_CostToPriceItem.get('Installation Fee') != null ? map_CostToPriceItem.get('Installation Fee'): null;
                
                if(qtli.Item__c!=null)
                {
                   // lst_QLIToInsert.add(qtli);
                    Quote_Line_Map.put(qtli.Item__c,qtli);
                }    
                
            }
        
            if(Quote.Interconnect__c != null ){
                Quote_Line__c qtli = new Quote_Line__c();
                qtli.Quantity__c = Quote.Interconnect__c;
                qtli.Quote__c = Quote.Id;
                qtli.Roof__c = 'Quote';
                qtli.Item__c = map_InvModelToItemId.get('Interconnection Fee') != null ? map_InvModelToItemId.get('Interconnection Fee'): null;
                qtli.Unit_Price__c = map_CostToPriceItem.get('Interconnection Fee') != null ? map_CostToPriceItem.get('Interconnection Fee'): null;
                
                if(qtli.Item__c!=null)
                {
                    // lst_QLIToInsert.add(qtli);
                    Quote_Line_Map.put(qtli.Item__c,qtli);
                }    
                
            }
        
        
        
        
            if(monitoringRecordsCheck == false){
                Quote_Line__c qtli6 = new Quote_Line__c();
                qtli6.Quantity__c = 1;
                qtli6.Quote__c = Quote.Id;
                qtli6.Roof__c = 'Quote';
                qtli6.Item__c = map_InvModelToItemId.get('Monitoring1') != null ? map_InvModelToItemId.get('Monitoring1'): null;
                qtli6.Unit_Price__c = map_CostToPriceItem.get('Monitoring1') != null ? map_CostToPriceItem.get('Monitoring1'): null;
                
                if(qtli6.Item__c!=null)
                {
                  //  lst_QLIToInsert.add(qtli6);          
                    Quote_Line_Map.put(qtli6.Item__c,qtli6);
                }    
        
                Quote_Line__c qtli1 = new Quote_Line__c();
                qtli1.Quantity__c = 1;
                qtli1.Quote__c = Quote.Id;
                qtli1.Roof__c = 'Quote';
                qtli1.Item__c = map_InvModelToItemId.get('Monitoring2') != null ? map_InvModelToItemId.get('Monitoring2'): null;
                qtli1.Unit_Price__c = map_CostToPriceItem.get('Monitoring2') != null ? map_CostToPriceItem.get('Monitoring2'): null;
                
                if(qtli1.Item__c!=null)
                {
                   // lst_QLIToInsert.add(qtli1);
                    Quote_Line_Map.put(qtli1.Item__c,qtli1);
                }   
        
                Quote_Line__c qtli2 = new Quote_Line__c();
                qtli2.Quantity__c = 1;
                qtli2.Quote__c = Quote.Id;
                qtli2.Roof__c = 'Quote';
                qtli2.Item__c = map_InvModelToItemId.get('Monitoring3') != null ? map_InvModelToItemId.get('Monitoring3'): null;
                qtli2.Unit_Price__c = map_CostToPriceItem.get('Monitoring3') != null ? map_CostToPriceItem.get('Monitoring3'): null;
                
                if(qtli2.Item__c!=null)
                {
                   // lst_QLIToInsert.add(qtli2);
                    Quote_Line_Map.put(qtli2.Item__c,qtli2);
                }    
        
                Quote_Line__c qtli3 = new Quote_Line__c();
                qtli3.Quantity__c = 1;
                qtli3.Quote__c = Quote.Id;
                qtli3.Roof__c = 'Quote';
                qtli3.Item__c = map_InvModelToItemId.get('Monitoring4') != null ? map_InvModelToItemId.get('Monitoring4'): null;
                qtli3.Unit_Price__c = map_CostToPriceItem.get('Monitoring4') != null ? map_CostToPriceItem.get('Monitoring4'): null;
                
                if(qtli3.Item__c!=null)
                {
                   // lst_QLIToInsert.add(qtli3);
                    Quote_Line_Map.put(qtli3.Item__c,qtli3);
                }

                Quote_Line__c qtli7 = new Quote_Line__c();
                qtli7.Quantity__c = 1;
                qtli7.Quote__c = Quote.Id;
                qtli7.Roof__c = 'Quote';
                qtli7.Item__c = map_InvModelToItemId.get('Monitoring5') != null ? map_InvModelToItemId.get('Monitoring5'): null;
                qtli7.Unit_Price__c = map_CostToPriceItem.get('Monitoring5') != null ? map_CostToPriceItem.get('Monitoring5'): null;
                
                if(qtli7.Item__c!=null)
                {
                   // lst_QLIToInsert.add(qtli7);
                    Quote_Line_Map.put(qtli7.Item__c,qtli7);
                }

                Quote_Line__c qtli8 = new Quote_Line__c();
                qtli8.Quantity__c = 1;
                qtli8.Quote__c = Quote.Id;
                qtli8.Roof__c = 'Quote';
                qtli8.Item__c = map_InvModelToItemId.get('Monitoring6') != null ? map_InvModelToItemId.get('Monitoring6'): null;
                qtli8.Unit_Price__c = map_CostToPriceItem.get('Monitoring6') != null ? map_CostToPriceItem.get('Monitoring6'): null;
                
                if(qtli8.Item__c!=null)
                {
                   // lst_QLIToInsert.add(qtli8);
                    Quote_Line_Map.put(qtli8.Item__c,qtli8);
                }
        
                //Quote_Line__c qtli4 = new Quote_Line__c();
                //qtli4.Quantity__c = 1;
                //qtli4.Quote__c = Quote.Id;
                //qtli4.Roof__c = 'Quote';
                //qtli4.Item__c = map_InvModelToItemId.get('PERFORMANCE GUARANTEE, 20-YEAR MONTHLY PLAN') != null ? map_InvModelToItemId.get('PERFORMANCE GUARANTEE, 20-YEAR MONTHLY PLAN'): null;
                //qtli4.Unit_Price__c = map_CostToPriceItem.get('PERFORMANCE GUARANTEE, 20-YEAR MONTHLY PLAN') != null ? map_CostToPriceItem.get('PERFORMANCE GUARANTEE, 20-YEAR MONTHLY PLAN'): null;
                
                //if(qtli4.Item__c!=null)
                //{
                   // lst_QLIToInsert.add(qtli4);
                    //Quote_Line_Map.put(qtli4.Item__c,qtli4);
                //}
            }
            //New Code -- Sunpower TPO AC Cabinet -- 04/05/2014
            if(Quote.Ac_Cabinet_Type__c != '' || Quote.Ac_Cabinet_Type__c != null){
                Quote_Line__c qtli = new Quote_Line__c();
                qtli.Quantity__c = 1;
                qtli.Quote__c = Quote.Id;
                qtli.Roof__c = 'Quote';
                qtli.Item__c = map_InvModelToItemId.get(ACCabinetType) != null ? map_InvModelToItemId.get(ACCabinetType): null;
                qtli.Unit_Price__c = map_CostToPriceItem.get(ACCabinetType) != null ? map_CostToPriceItem.get(ACCabinetType): null;
                
                if(qtli.Item__c!=null)
                {
                   // lst_QLIToInsert.add(qtli);
                    Quote_Line_Map.put(qtli.Item__c,qtli);
                }    
                
            }
            //End New Code -- Sunpower TPO AC Cabinet -- 04/05/2014

            //Modified Code -- Sunpower TPO BOM Requirement for Wiring Distance -- 04/05/2014
            if(Quote.Wiring_Distance__c == 'greater than 2.5 meters'){
                Quote_Line__c qtli = new Quote_Line__c();
                qtli.Quantity__c = 1;
                qtli.Quote__c = Quote.Id;
                qtli.Roof__c = 'Quote';
                qtli.Item__c = map_InvModelToItemId.get('MonitoringCheck') != null ? map_InvModelToItemId.get('MonitoringCheck'): null;
                qtli.Unit_Price__c = map_CostToPriceItem.get('MonitoringCheck') != null ? map_CostToPriceItem.get('MonitoringCheck'): null;
                
                if(qtli.Item__c!=null)
                {
                   // lst_QLIToInsert.add(qtli);
                    Quote_Line_Map.put(qtli.Item__c,qtli);
                }    
                
            }

            if(Quote.Wiring_Distance__c == 'greater than 2.5 meters' && Quote.Inverter_Count_Multiple_Roofs__c > 1){
                Quote_Line__c qtli = new Quote_Line__c();
                qtli.Quantity__c = Quote.Inverter_Count_Multiple_Roofs__c - 1;
                qtli.Quote__c = Quote.Id;
                qtli.Roof__c = 'Quote';
                qtli.Item__c = map_InvModelToItemId.get('MonitoringCheck1') != null ? map_InvModelToItemId.get('MonitoringCheck1'): null;
                qtli.Unit_Price__c = map_CostToPriceItem.get('MonitoringCheck1') != null ? map_CostToPriceItem.get('MonitoringCheck1'): null;
                
                if(qtli.Item__c!=null)
                {
                   // lst_QLIToInsert.add(qtli);
                    Quote_Line_Map.put(qtli.Item__c,qtli);
                }    
                
            }

            if(Quote.Wiring_Distance__c == '2.5 meters or less'){
                Quote_Line__c qtli = new Quote_Line__c();
                qtli.Quantity__c = Quote.Inverter_Count_Multiple_Roofs__c;
                qtli.Quote__c = Quote.Id;
                qtli.Roof__c = 'Quote';
                qtli.Item__c = map_InvModelToItemId.get('MonitoringCheck1') != null ? map_InvModelToItemId.get('MonitoringCheck1'): null;
                qtli.Unit_Price__c = map_CostToPriceItem.get('MonitoringCheck1') != null ? map_CostToPriceItem.get('MonitoringCheck1'): null;
                
                if(qtli.Item__c!=null)
                {
                   // lst_QLIToInsert.add(qtli);
                    Quote_Line_Map.put(qtli.Item__c,qtli);
                }    
                
            }
            //End Modified Code -- Sunpower TPO BOM Requirement for Wiring Distance -- 04/05/2014
            system.debug('******************'+Quote_Line_Map.size());
            if(Quote_Line_Map.size() > 0)
            { 
                List<Quote_Line__c> lst_qli = [select Id, Item__c, Item__r.Product_Type__c from Quote_Line__c WHERE Quote__c =: Quote.Id AND Roof__c <> 'Roof 1' AND Roof__c <> 'Roof 2' AND Roof__c <> 'Roof 3' AND Roof__c <> 'Roof 4'];
                if(lst_qli.size() > 0){
                    System.debug('%%%%%%%%lst_qli ' + lst_qli.size());
                    delete lst_qli;   
                } 
                if(Quote_Line_Map != null){
                    system.debug('*********map*********'+Quote_Line_Map);
                    for(Quote_Line__c qIterate : Quote_Line_Map.Values())
                    {
                    
                        if(qIterate.Roof__c == 'Quote' )
                        {
                            lst_QLIToInsert.add(qIterate);
                        }    
                    }
                    if(lst_QLIToInsert.size() >0)
                    { 
                        insert lst_QLIToInsert;
                        system.debug('*********lquoteID*********'+quoteID);
                        p = new PageReference('/'+quoteID); 
                        system.debug('*********lst_QLIToInsert*********'+lst_QLIToInsert.size()); 
                        return p;
                    }    
                
                }
            }    
    return null;
    }
    
    
*/
}