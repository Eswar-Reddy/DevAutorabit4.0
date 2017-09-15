/*** Class added in Sunpower TPO Phase 1 -- 20/10/2013, to clone the quote and insert the quote line item ***/
public class TPO_QuoteCloneWithItemsController {/*

    //added an instance varaible for the standard controller
    private ApexPages.StandardController controller {get; set;}
     // add the instance for the variables being passed by id on the url
    public Quote qo {get;set;}
    public ID quoteID;
    // set the id of the record that is created -- ONLY USED BY THE TEST CLASS
    public ID newRecordId {get;set;}

    public TPO_QuoteCloneWithItemsController(ApexPages.StandardController controller) {
        //initialize the stanrdard controller
        this.controller = controller;
        // load the current record
        qo= (Quote)controller.getRecord();
        system.debug('##TPO_CloneQuoteQTID ' + qo.ID);
        quoteID = ApexPages.CurrentPage().getParameters().get('qid');
    }

    // method called from the VF's action attribute to clone the qo
    public PageReference cloneWithItems() {
 
         // setup the save point for rollback
         Savepoint sp = Database.setSavepoint();
         Quote newQO;
 
         try {
 
              //copy the purchase order - ONLY INCLUDE THE FIELDS YOU WANT TO CLONE
          Quote  quoteNew = [SELECT Account_Billing_Country__c,Trenching__c,Wiring_Distance__c,Grid_Connection_Type__c,Account_email__c,Account_Phone_Number__c,Account__c,Active_Quote__c,AdditionalCity,
          AdditionalCountry,AdditionalLatitude,AdditionalLongitude,AdditionalName,AdditionalPostalCode,AdditionalState,AdditionalStreet,Additional_Equipment__c,
          Adhoc_Create_LDA__c,Admin_Notes__c,Amended_Lease_number__c,Amended_Lease__c,Amendment_Copy_Error_Message__c,Amendment_Date__c,Amendment_Doc_Signed__c,
          Amendment_History1__c,Amendment_Quote_ID__c,Amendment_Type__c,AmmendmentType_AmdQuote__c,Annual_Bill__c,Annual_Price__c,Annual_target__c,Annual_Usage__c,
          Anticipated_build_rate_mo__c,Approved_by_Business_Unit_Manager__c,Approved_by_Executive_Vice_President__c,Array_Layout_Field_Detailed_3_days__c,
          Array_Layout_Revision__c,Array_Layout_Sales_Audit__c,Array_Layout_Site_Audit__c,ASP1__c,ASP_Formula__c,ASP__c,Auto_Driving_Reduction__c,
          Average_Of_Rate_Per_KWH__c,Average_Price_per_Watt__c,BillingCity,BillingCountry,BillingLatitude,BillingLongitude,BillingName,BillingPostalCode,
          BillingState,BillingStreet,Binding_Offer_Approval__c,BOS_w_Formula__c,BOS_w__c,Budgetary_Pricing_Approval__c,Business_Unit__c,Buydown_Amount__c,
          Buydown_Override__c,Cash_Amount1__c,Cash_Amount2__c,Cash_Amount3__c,Cash_Amount__c,Cash_Description1__c,Cash_Description2__c,Cash_Description3__c,
          Cash_Description__c,Cents_kWh__c,Check_Cont_Licence__c,City_State__c,City__c,CO2_Emissions_Reduction__c,Code_Expiration_Date__c,COGS__c,Comments__c,
          Commercial_Operation_Date__c,Company_ID__c,Conga_Solution_URL1__c,Conga_Solution_URL__c,Consolidated_Lease_Number_Dup__c,Consolidated_Lease_Number__c,
          Construction__c,ContactId,Contacts_Names__c,Contractors_License__c,Contract_Pricing_Approval__c,Contract_Signed_Date__c,Contract_Type__c,
          Contribution_Margin_perc__c,Contribution_Margin__c,Copy_SM_After_Lock__c,Copy_SM_Before_Lock__c,Costomatic_Firm__c,Costs_Output_Comments__c,
          Cost_Estimate_Completed__c,Cost_Estimate_Date_Requested__c,Cost_Estimate_Days_Past_Due__c,Cost_Estimate_Package__c,Cost_Methodology__c,CreatedById,
          CreatedDate,Created_Date_custom__c,Created_Date__c,Create_Amendment_Doc__c,Create_Lease_Docs_FR__c,Create_Lease_Docs__c,Create_LOI__c,
          Create_Termination_Doc__c,CurrencyIsoCode,Current_Rate__c,CustomerID__c,Customer_Accounts_Address_for_LDA__c,Customer_Accounts_Address__c,
          Customer_Address_Address__c,Customer_Address_City__c,Customer_Address_County__c,Customer_Address_State__c,Customer_Address_Zip__c,
          Customer_Electric_Utility__c,Customer_Rate_Name__c,Customer_s_DownPayment_1__c,Customer_s_DownPayment_2__c,CW_URL__c,Date_Created__c,Date_Modified__c,
          Date_Proposal_Delivered__c,Date_Sent_to_Customer__c,Date__c,Day_Left_to_Complete_Quote__c,DC_Cabinet__c,Deadline_Type__c,
          Dealer_Contractor_License_Number__c,Dealer_Fees__c,Dealer_Installer_Address_Address__c,Dealer_Installer_Address_City__c,
          Dealer_Installer_Address_County__c,Dealer_Installer_Address_State__c,Dealer_Installer_Address_Zip__c,Dealer_Installer__c,Dealer_Name__c,
          Deal_Review_Date__c,Deal_Type__c,DELETE_Proposal_Due__c,Description,Description__c,Designers__c,Designer__c,DesignLookup__c,Design_Factor_value__c,
          Design_Factor__c,Design_Help_Status__c,Design__c,Diff_Sales_and_List_Price_Total__c,DirectMargin1_per__c,DirectMargin1__c,DirectMargin_per__c,
          Direct_Margin__c,Discount,DM__c,Document_Created_Date__c,Doc_out_for_signature__c,DownPayment_Type__c,Down_Payment__c,Drawings_Location__c,
          Drawing_90_Due_Date__c,Drawing_Completed__c,Drawing_Date_Requested__c,Drawing_Days_Past_Due__c,DRC_Notes__c,Early_Buyout_Option_Date__c,
          Early_Buyout_Option_Price__c,Edit_Quote_in_CPR__c,Effective_Smart_Pack_Price__c,Elapsed_Time__c,Electrical_Engineers__c,Electrical_Engineer__c,
          Electrical_Estimator__c,Email,End_Date__c,Energy_Efficency_Quote__c,ERDF_Fee__c,Escalator__c,Estimated_Proposal_Delivery__c,Estimate_Urgent_Request__c,
          Estimator__c,ExpirationDate,Fax,Feasibility_Indicator__c,Filing_Status__c,Final_First_Base_Monthly_Pay__c,Final_First_Monthly_pay_Tax__c,
          Final_First_Monthly_Total_Tax__c,Final_Lease_Number__c,Final_Page_4_Monthly_Total__c,Final_Partial_Prepayment_Tax__c,Final_Partial_Prepay_w_Tax__c,
          Final_Total_Yearly_Page_2__c,Final_Total_Yearly_Page_4__c,Financial_Structure_Feasibility__c,Financing_Amendment_Notes__c,First_Monthly_Payment_Base_Amount__c,First_Monthly_Payment_Estimated_Payment__c,First_Monthly_Payment_Est_Tax_on_Payme__c,First_Monthly_Payment__c,Fit_Annual_Esc__c,Fit_Rate__c,Full_Prepaid_Lease__c,Ac_Cabinet_Type__c,Full_PrePayment_Amount_Base_Amount__c,Full_PrePayment_Amount_Estimated_Paymen__c,Full_PrePayment_Amount_Estimated_Tax_on__c,Full_Prepayment_of_Lease_Amount__c,Full_Proposal_or_Just_Pricing__c,General_Derate_Factor__c,GrandTotal,Gross_Margin__c,Id,Incentives_detail_1_amt__c,Incentives_detail_1__c,Incentives_detail_2_amt__c,Incentives_detail_2__c,Incentives_detail_3__c,Incentives__c,Incentive_Forms_completed__c,Income__c,Initial_Cost_Estimate_On_Time__c,Initial_Layout_On_Time__c,Initial_Payment__c,Initial_Simulation_On_Time__c,Initial_Single_Line_On_Time__c,Initial_Site_Audit_On_Time__c,Initial_Structural_Analysis_On_Time__c,Installation_Fee__c,InstallDate__c,Install_Date__c,Interconnect__c,InverterModel__c,Inverter_0_Layout_0_AxisTiltAngle__c,Inverter_0_Layout_0_Shading_Month_1__c,Inverter_0_Layout_0_Shading_Month_2__c,Inverter_0_Layout_0_Shading_Month_3__c,Inverter_0_Layout_0_Shading_Month_4__c,Inverter_0_Layout_0_Shading_Month_5__c,Inverter_0_Layout_0_Shading_Month_6__c,Inverter_0_Layout_0_Shading_Month_7__c,Inverter_0_Layout_0_Shading_Month_8__c,Inverter_0_Layout_0_Shading_Month_9__c,Inverter_0_Layout_0_Shading_Month_10__c,Inverter_0_Layout_0_Shading_Month_11__c,Inverter_0_Layout_0_Shading_Month_12__c,Inverter_0_Layout_0_StandardPVModuleId__c,Inverter_0_Layout_0_SystemAzimuth__c,Inverter_0_StandarInverterId__c,Inverter_Brand_2__c,Inverter_Brand_3__c,Inverter_Brand_4__c,Inverter_Brand__c,Inverter_Count_Roof1__c,Inverter_Count_Roof2__c,Inverter_Count_Roof3__c,Inverter_Count_Roof4__c,Inverter_Count__c,Inverter_Manufacturer_Roof1__c,Inverter_Manufacturer_Roof2__c,Inverter_Manufacturer_Roof3__c,Inverter_Manufacturer_Roof4__c,Inverter_Manufacturer__c,Inverter_Model_2__c,Inverter_Model_3__c,Inverter_Model_4__c,Inverter_Model_Roof1__c,Inverter_Model_Roof2__c,Inverter_Model_Roof3__c,Inverter_Model_Roof4__c,Inverter_Model__c,Inverter_Quantity_2__c,Inverter_Quantity_3__c,Inverter_Quantity_4__c,Inverter_Quantity__c,Invoice_Document_Email__c,Inv_0_Layout_0_ModuleCountPerString__c,Inv_0_Layout_0_ParallelStringsCount__c,Irregular_Roof__c,IsDeleted,Isnew__c,IsSendApprovaltoSalesAnalyst__c,IsSyncing,Is_Locked__c,Is_Quote_Locked__c,Is_Selected_Scenario__c,Kickoff_Meeting_Date__c,kWp_Smartmount__c,kWp_Suntile__c,Latitude__c,Lease_Annual_Escalation__c,Lease_doc_Created_Date__c,Lease_Doc_Created__c,Lease_doc_creation_allowed__c,Lease_Doc_Reviewed__c,Lease_doc_Sent_out_for_Signature__c,Lease_doc_Signed_Date__c,Lease_Doc_Signed__c,Lease_Doc_Terminated__c,Lease_from_Account__c,Lease_Number__c,Lease_Partner__c,Lease_Sales_Tax_Rate__c,Lease_tobe_Amended__c,Leesee_Co_Leesee__c,Legal_Support__c,Lessee_2__c,Lessee_3__c,Lessee_4__c,Lessee_Info_Am_Date__c,Lessee__c,Lessor__c,License_ID__c,Lien_Waiver_Already_Sent__c,LineItemCount,LineItemsFromOpp__c,Loan_Term__c,Longitude__c,mark1__c,Maximum_Rated_Capacity_Watts__c,Maximum_Rated_Capacity__c,Modules_Per_String_Roof1__c,Modules_Per_String_Roof2__c,Modules_Per_String_Roof3__c,Modules_Per_String_Roof4__c,Modules_Per_String__c,Modules__c,Module_Brand__c,Module_Count__c,Module_Oracle_Item_Number__c,Module_Quantity__c,Module_Type__c,Module__c,Monitoring_System_Model__c,Monitoring_System_Option__c,Monitoring_System_Quantity__c,Monitoring_System__c,Monthly_Apr__c,Monthly_Aug__c,Monthly_Dec__c,Monthly_Feb__c,Monthly_Jan__c,Monthly_Jul__c,Monthly_Jun__c,Monthly_Mar__c,Monthly_May__c,Monthly_Nov__c,Monthly_Oct__c,Monthly_Payments_with_Estimated_Tax__c,Monthly_Power_Bill_After_Solar__c,Monthly_Power_Bill_Before_Solar__c,Monthly_Sep__c,Mounting_Description__c,Mounting_Option__c,Mounting_System_Module__c,Name,Net_Cost__c,New_Design__c,Not_An_Historical_Quote__c,Number_of_homes__c,Number_of_Interconnections__c,Number_of_Sites__c,OCIP_Required__c,Old_Sys_Quote_Number__c,On_Markup_Only__c,OpportunityId,Opportunity_ID__c,Opportunity_Name__c,Opportunity_Number__c,Opportunity_Owner_s_Manager_text__c,Opportunity_Owner_s_Manager__c,Optional_Incentives__c,OracleItemNumber__c,Oracle_Vendor_email_field_value__c,Original_ERDFFee__c,Original_FitRate__c,Original_Lease_doc_Date__c,Original_Lease_Number__c,Origination__c,Other_Charges_Amounts_Total__c,Other_Charges_Row0_Amount__c,Other_Charges_Row0_Description__c,Other_Charges_Row0_Name__c,Other_Charges_Row1_Amount__c,Other_Charges_Row1_Description__c,Other_Charges_Row1_Name__c,Other_Charges_Row2_Amount__c,Other_Charges_Row2_Description__c,Other_Charges_Row2_Name__c,Other_Charges_Row3_Amount__c,Other_Charges_Row3_Description__c,Other_Charges_Row3_Name__c,Other_Charges_Row4_Amount__c,Other_Charges_Row4_Description__c,Other_Charges_Row4_Name__c,Other_Charges_Row5_Amount__c,Other_Charges_Row5_Description__c,Other_Charges_Row5_Name__c,Other_Charges_Row6_Amount__c,Other_Charges_Row6_Description__c,Other_Charges_Row6_Name__c,Other_Costs__c,Other_Cost_W__c,Other_Roofing__c,Override_30KW_Limit__c,O_M_Direct_Project_Margin1__c,O_M_Direct_Project_Margin__c,O_M_Service_Level__c,O_M_Suport__c,Partial_Prepayment__c,Partial_target__c,Partner_Accounts_Contractors_License_Exp__c,Partner_Accounts_Contractors_License_Num__c,Partner_Accounts_dealer_address__c,Partner_Account_Id__c,Payment_Terms__c,PBI_Amount__c,PBI_Override__c,PBI_Years__c,Permits_included__c,Permitting_Due_Diligence_Complete__c,Phone,Photo_Rendering__c,PM_Cost_Based_on_Design__c,PM_Cost_without_Design__c,Power_Used_Before_Solar_kWh_year__c,PPA_Customization__c,PPA_Pricing_Template_Budgetary__c,PPA_Pricing_Template_Firm__c,Presentation__c,Pricebook2Id,PriceBook_Name__c,Price_Approval__c,Price_Concession__c,Price_to_Customer__c,Price__c,Pricing_Model_File_Name__c,PrimaryContact__c,Primary_PSR_Email_Id__c,Production_Am_Date__c,Production_Shaver__c,Product_Am_Date__c,Project_Managers__c,Project_Manager_Costing__c,Project_Manager__c,Project_Service_Request_Date_Sent__c,ProposalASHeading__c,Proposal_Completed__c,Proposal_Due_Original__c,Proposal_Due__c,Proposal_File_Name__c,Proposal__c,ProposedRate__c,Proposed_Electric_Utility__c,Proposed_Rate_Name__c,Pro_Forma__c,PSR_Number__c,PSR_Status__c,PSR__c,PV_Availability_Status__c,PV_Cost_Pricing__c,PV_Cost_Roll_Up__c,PV_w_Formula__c,PV_w__c,QuoteCost__c,QuoteNumber,QuoteToCity,QuoteToCountry,QuoteToLatitude,QuoteToLongitude,QuoteToName,QuoteToPostalCode,QuoteToState,QuoteToStreet,QuoteType__c,Quote_1_Gross_Price_of_System__c,Quote_1_gross_W_DC__c,Quote_1_Rebate_per_system__c,Quote_2_Gross_Price_of_System__c,Quote_2_gross_W_DC__c,Quote_2_Rebate_per_system__c,Quote_3_Gross_Price_of_System__c,Quote_3_gross_W_DC__c,Quote_3_Rebate_per_system__c,Quote_Amount__c,Quote_Approval_Date__c,Quote_Cost__c,Quote_Data_Upload_Failure__c,Quote_Due_in_X_Days__c,Quote_Duration__c,Quote_Expiration_Date__c,Quote_Gross_Margin_Percent__c,Quote_Gross_Margin__c,Quote_ID__c,Quote_Inverter_Values__c,Quote_LOI_Status__c,Quote_Status__c,Quote_Steps__c,Quote_Summary__c,Quote_type__c,Racking_Nu__c,Racking_Quantity__c,Rate_Analysis__c,Rebate__c,Recalculate__c,RecordTypeId,REC_Escalation__c,REC_Life_Years__c,REC_Value_kWh__c,Ref_By_Old_Quote__c,Related_Account__c,Resource_Approval__c,Revenue__c,RFI_Date_Sent__c,Rollup_Lease_95_of_S_P_A_P__c,Rollup_Lease_105_of_S_P_A_P__c,Rollup_Rate_Per_KWH__c,Roofing_Material__c,Roof_1_MPPT_1_Module__c,Roof_1_MPPT_1_string__c,Roof_1_MPPT_2_Module__c,Roof_1_MPPT_2_string__c,Roof_1_MPPT_3_Module__c,Roof_1_MPPT_3_string__c,Roof_1_MPPT_4_Module__c,Roof_1_MPPT_4_string__c,Roof_2_MPPT_1_Module__c,Roof_2_MPPT_1_string__c,Roof_2_MPPT_2_Module__c,Roof_2_MPPT_2_string__c,Roof_2_MPPT_3_Module__c,Roof_2_MPPT_3_string__c,Roof_2_MPPT_4_Module__c,Roof_2_MPPT_4_string__c,Roof_3_MPPT_1_Module__c,Roof_3_MPPT_1_string__c,Roof_3_MPPT_2_Module__c,Roof_3_MPPT_2_string__c,Roof_3_MPPT_3_Module__c,Roof_3_MPPT_3_string__c,Roof_3_MPPT_4_Module__c,Roof_3_MPPT_4_string__c,Roof_4_MPPT_1_Module__c,Roof_4_MPPT_1_string__c,Roof_4_MPPT_2_Module__c,Roof_4_MPPT_2_string__c,Roof_4_MPPT_3_Module__c,Roof_4_MPPT_3_string__c,Roof_4_MPPT_4_Module__c,Roof_4_MPPT_4_string__c,Roof_Details1__c,Roof_Details2__c,Roof_Details3__c,Roof_Details4__c,Roof_Pitch__c,Roundoff_Dealer_Fees__c,Roundoff_Effective_Smart_Pack_Price__c,RoundOff_First_Monthly_Payment_Base_Amo__c,RoundOff_First_Monthly_Payment_Estimate__c,RoundOff_First_Monthly_Payment__c,Roundoff_Installation_Fee__c,Roundoff_Interconnect__c,Roundoff_Origination__c,Roundoff_System_Cost__c,RoundOff_Total_Monthly_Payments__c,Salesperson_ID__c,Sales_Analyst_Support__c,Sales_Analyst__c,Sales_Tax_Formula__c,Sales_Tax_Rate__c,Sales_Tax__c,Scenario_Id__c,Scenario_Index__c,SecondaryContact__c,Send_Lien_Waiver_Agreement__c,Send_to_DRC__c,Sent_Welcome_Email__c,Serengeti_Cost_Pricing__c,Shading_Measurement_Date__c,Shading_Notes__c,ShippingCity,ShippingCountry,ShippingHandling,ShippingLatitude,ShippingLongitude,ShippingName,ShippingPostalCode,ShippingState,ShippingStreet,Shipping_Inco_Terms1__c,Shipping_Inco_Terms__c,Shipping_Inco_Term_Date1__c,Shipping_Inco_Term_Date__c,Simulation_Completed__c,Simulation_Date_Requested__c,Simulation_Days_Past_Due__c,Simulation__c,Simulator_c__c,Single_Line_Based_on_Design__c,Single_Line_Completed__c,Single_Line_Date_Requested__c,Single_Line_Days_Past_Due__c,Single_Line_Urgent_Request__c,Single_Line_Without_Design__c,Single_Line__c,Site_Auditors__c,Site_Auditor__c,Site_Audit_Completed__c,Site_Audit_Date_Requested__c,Site_Audit_Days_Past_Due__c,Site_Audit_Detailed__c,Site_Audit_SPWR_Personnel__c,Site_Audit_SPWR_Sub_Contractor__c,Site_Audit_Standard__c,Site_Audit_SubContractor__c,Site_Feasibility__c,Site_Survey__c,Sizing_Calculations__c,Solar_Rebate_Amount__c,Standard_Contract_Used__c,Start_Date__c,Status,Status__c,Strl_Fdtn_Analysis_Days_Past_Due__c,Strl_Fdtn_Analysis_Due__c,Strl_Fdtn_Analysis_Tracking_Completed__c,Structural_Foundation_Engineers__c,Structured_Finance_Lead__c,Subtotal,SystemCost_FR__c,SystemModstamp,System_Cost__c,System_Model__c,System_Output_kWh__c,System_Price_Per_Watt__c,System_Price__c,System_Production_Year_1__c,System_Size_1_DC_kW__c,System_Size_2_DC_kW__c,System_Size_3_DC_kW__c,System_Size_BOS_Formula__c,System_Size_BOS__c,System_Size_kWp__c,System_Size_PV_Formula__c,System_Size_PV__c,System_Size__c,Target_Implied_Rate__c,Target_implied_target__c,Tax,Taxable1__c,Taxable2__c,Taxable3__c,Taxable__c,Temp_Contact_1__c,Temp_Contact_2__c,Termination_Lease_doc_Date__c,Term_Years__c,The_Endo_Box__c,TotalPrice,Total_BOS_Cost_Formula__c,Total_BOS_Cost__c,Total_Cost_W__c,Total_Cost__c,Total_Development_Cost_Formula__c,Total_Development_Cost__c,Total_Energy_Test__c,Total_Energy__c,Total_Incentive__c,Total_kWp__c,Total_List_Price__c,Total_Monthly_Payments__c,Total_of_Payments__c,Total_O_M_Amount__c,Total_O_M_Cost__c,Total_Parallel_Strings_Roof1__c,Total_Parallel_Strings_Roof2__c,Total_Parallel_Strings_Roof3__c,Total_Parallel_Strings_Roof4__c,Total_Parallel_Strings__c,Total_Price_Less_O_M__c,Total_PV_Cost_Formula__c,Total_PV_Cost__c,Total_Yr_1_Production__c,TPO_Module_Count__c,TPO_System_Size__c,Transmission_Due_Diligence_Complete__c,Trees_Planted__c,Trigger_Checkbox__c,Unit_Price_W__c,Utility_Bill_Annual_Escalation__c FROM Quote where id = : quoteID];
             system.debug('##TPO_CloneQuoteQTID ' + quoteNew.ID);
             newQO = quoteNew.clone(false);
             system.debug('##TPO_CloneQuoteQTID ' + newQO);
             newQO.Is_Locked__c = false;
             newQO.Date_Modified__c = null;           
             insert newQO;
 
             // set the id of the new po created for testing
               newRecordId = newQO.id;
 
             // copy over the line items - ONLY INCLUDE THE FIELDS YOU WANT TO CLONE
             List<Quote_Line__c> items = new List<Quote_Line__c>();
             for (Quote_Line__c qi : [Select p.Id, p.Name, p.Item__c, p.Item_description__c, p.Quantity__c,p.Quote_Is_Locked__c,p.Quote_Record_Type__c,p.Roof__c,p.Total_Price__c,p.Unit_Price__c From Quote_Line__c p where Quote__c = : quoteID and Roof__c='Roof 1']) {
             system.debug('##TPO_CloneQuoteQTID ' + qi);
                  Quote_Line__c newQI = qi.clone(false);
                  newQI.Quote__c = newQO.id;
             system.debug('##TPO_CloneQuoteQTID ' + newQI);
                  items.add(newQI);
             }
             if (items.size() > 0){
                 insert items;
             }
             List<Attachment> AttachmentLst = new List<Attachment>();
             for (Attachment at : [SELECT Id, Body, BodyLength, ContentType, CreatedById, CreatedDate, IsDeleted, Description, Name, IsPartnerShared, OwnerId, ParentId, IsPrivate, ConnectionReceivedId, ConnectionSentId, SystemModstamp FROM Attachment WHERE ParentId =: quoteID AND (Name=: 'Rapport du projet.pdf' OR Name =: 'Calepinage (fichier CAD).dxf')])
             {
                 Attachment newAT = at.clone(false);
                 newAT.ParentId = newQO.id;
                 AttachmentLst.add(newAT);
             }
             if (AttachmentLst.size() > 0){
                 insert AttachmentLst;
             } 
         } catch (Exception e){
             // roll everything back in case of error
            Database.rollback(sp);
            ApexPages.addMessages(e);
            return null;
         }
 
        return new PageReference('/'+newQO.id+'/e?retURL=%2F'+newQO.id);
    }
*/
}