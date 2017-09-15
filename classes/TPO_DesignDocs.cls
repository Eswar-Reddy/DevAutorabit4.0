/*** Class added in Sunpower TPO Phase 1 -- 20/10/2013, to display design docs for partners in quote page layout ***/
public class TPO_DesignDocs {/*

public Quote newQuote;
public List<TPO_MPPT__c>  tpomppt{get;set;}
public List<ContentVersion>  ContentversLst {get;set;}
public List<Attachment>  AttachmentLst {get;set;}
public boolean documentSection {get;set;}
public boolean contentSection {get;set;}
public boolean attachmentSection {get;set;}

    public TPO_DesignDocs(ApexPages.StandardController controller) {
    
 newQuote = [SELECT ID,Name,Module__c,Consolidated_Lease_Number__c,
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
                                Status__c,Origination__c,Interconnect__c,
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
                                Customer_s_DownPayment_1__c,Grid_Connection_Type__c,Trenching__c,Quote_MandateFields__c,Wiring_Distance__c,DownPayment_Type__c,Original_ERDFFee__c,
                                Customer_s_DownPayment_2__c,FR_Conga_formula__c,DC_Cabinet__c,DC_Cabinet_Roof2__c,DC_Cabinet_Roof3__c,DC_Cabinet_Roof4__c,Code_Expiration_Date__c,CreatedDate,TPO_System_Size__c,Fit_Rate__c,ERDF_Fee__c,Original_FitRate__c  FROM Quote WHERE Id =: ApexPages.currentPage().getParameters().get('Id')];   

    }



public pagereference SolrifDesigndocs()
     {
        tpomppt = new List<TPO_MPPT__c>();
        set<Decimal> moduleQty = new set<Decimal>();
        if(newQuote.Modules_Per_String_Roof1__c <> NULL)
        {
            moduleQty.add(newQuote.Modules_Per_String_Roof1__c);
        } 
        if(newQuote.Modules_Per_String_Roof2__c <> NULL)
        {
            moduleQty.add(newQuote.Modules_Per_String_Roof2__c);
        } 
        
        if(newQuote.Modules_Per_String_Roof3__c <> NULL)
        {
            moduleQty.add(newQuote.Modules_Per_String_Roof3__c);
        } 
        
        if(newQuote.Modules_Per_String_Roof4__c <> NULL)
        {
            moduleQty.add(newQuote.Modules_Per_String_Roof4__c);
        }
        
        Set<String> strvals = new Set<String>();
        system.debug('*****newQuote.OracleItemNumber__c***********'+Quote.OracleItemNumber__c);
        if(newQuote.OracleItemNumber__c <> NULL){
             system.debug('*****moduleQty ***********'+moduleQty );
             
            tpomppt = [SELECT Id,Module_Name__c,Document_Link__c,Document_Link_2__c,MPPT_1_String_Qty__c FROM TPO_MPPT__c where  Item_ID__c =: newQuote.OracleItemNumber__c and Module_Quantity__c IN :moduleQty];
            for(TPO_MPPT__c tpomm : tpomppt){
                system.debug('*****Document_Link__c ***********'+tpomm.Document_Link__c );
                system.debug('*****Document_Link_2__c *******'+tpomm.Document_Link_2__c );
                if(tpomm.Document_Link__c <> NULL)
                {
                    string str = tpomm.Document_Link__c ;
                    Integer n = str.length();
                    String finalstr = str.substring(n-15,n);
                    strvals.add(finalstr);
                }
                if(tpomm.Document_Link_2__c <> NULL)
                {
                    string str = tpomm.Document_Link_2__c;
                    Integer n = str.length();
                    String finalstr = str.substring(n-15,n);
                    strvals.add(finalstr);
                }
                system.debug('*****strvals***********'+strvals.size());
                system.debug('*****strvals**val*********'+strvals);
            }
            
        } 
        ContentversLst  = new List<ContentVersion>();
        if(strvals.size() >0 && (!newQuote.Irregular_Roof__c) && (!newQuote.Multiple_Roofs__c))
        {
            ContentversLst = [SELECT Administrator__c,Administrator__r.Name,Category__c,Id,Title,Update_Due__c,Update_Frequency__c,Variable_Content_Detail__c,Vertical__c,System_Model__c FROM ContentVersion where ContentDocumentId IN: strvals order by createddate desc limit 1];
        }
        //AttachmentLst = new List<Attachment>();
        system.debug('*****attachments*********'+ Quote.Id);
        AttachmentLst = [SELECT ContentType,Description,Id,LastModifiedDate,Name,ParentId,CreatedDate FROM Attachment WHERE ParentId =: newQuote.Id AND (Name LIKE: 'Rapport du projet%' OR Name LIKE : 'Calepinage (fichier CAD)%' OR Name LIKE : (newQuote.Name + '%') OR Name LIKE : 'Schema Unifilaire%' OR Name LIKE : 'Liste des matériaux pour%')];
        system.debug('*****attachments*********'+ AttachmentLst);
        if (ContentversLst.size() > 0 || AttachmentLst.size() > 0 )
        {
            documentSection = true;
        }
        if (ContentversLst.size() > 0)
        {
            contentSection = true;
        }
        if ( AttachmentLst.size() > 0 )
        {
            attachmentSection = true;
        }
        return null;

     }*/
}