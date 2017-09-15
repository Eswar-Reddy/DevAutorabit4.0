public class QuoteReadOnlyExtension {
    public Quote qt{get;set;}
    public System_Production__c systemProdOutput {get;set;}
    public Quote  QuoteOutput {get;set;}
    public Quote_Summary__c QuoteSummary {get;set;}
    public Map<String, String> RoofDescMap {get; set;}
    public Map<String, String> RoofPitch {get; set;}
    public Map<String, Decimal> RoofAzimuth {get; set;}
    public Map<String, Roof_Details__c> roofdetailMap {get; set;}
    public Map<String, String> RoofInvtrManf {get; set;}
    public Map<String, String> RoofInvtrModl {get; set;}
    public Map<String, Decimal> RoofInvrtrcnt {get; set;}
    public Map<String, Decimal> RoofModuleQty {get; set;}
    public Map<String, Decimal> RoofTotalParallelStr {get; set;}
    public integer roofcount {get; set;}
    public String acModuleText {get; set;}
    public Boolean acModule {get; set;}
    public String QuoteState {get; set;}
    public Boolean roof1exists {get;set;}
    public Boolean roof2exists {get;set;}
    public Boolean roof3exists {get;set;}
    public Boolean roof4exists {get;set;}
    

    public QuoteReadOnlyExtension(ApexPages.StandardController controller) {
        qt=(Quote)controller.getRecord();
        qt = [ SELECT
                Id,
                AccountId,
                DesignLookup__c,
                ModuleConfigurationId__r.name,
                Modules_Per_String_Roof1__c,
                Modules_Per_String_Roof2__c,
                Modules_Per_String_Roof3__c,
                Modules_Per_String_Roof4__c,
                Total_Parallel_Strings_Roof1__c,
                Total_Parallel_Strings_Roof2__c,
                Total_Parallel_Strings_Roof3__c,
                Total_Parallel_Strings_Roof4__c,
                Inverter_Manufacturer_Roof1__c,
                Inverter_Manufacturer_Roof2__c,
                Inverter_Manufacturer_Roof3__c,
                Inverter_Manufacturer_Roof4__c,
                Inverter_Model__c,
                Inverter_Model_2__c,
                Inverter_Model_3__c,
                Inverter_Model_4__c,
                Inverter_Count_Roof1__c,
                Inverter_Count_Roof2__c,
                Inverter_Count_Roof3__c,
                Inverter_Count_Roof4__c,
                System_Model__c,
                is_Locked__c
        FROM Quote
        WHERE id=:qt.Id];
        acModuleText = 'Number of Modules';
        acModule = false;
        if(qt.is_Locked__c){
            QuoteState='Locked';
        }else{
            QuoteState='Saved';
        }
        if(qt.System_Model__c !=null){
          if(qt.System_Model__c.contains('AC')){
            acModuleText = 'Number of Modules';
            acModule = false;
          }
          else{
            acModuleText = 'Total Parallel Strings';
            acModule = true;
          }  
        }else{
          if(qt.moduleconfigurationID__r.Name!=null &&  qt.ModuleConfigurationId__r.name.contains('AC')){
            acModuleText = 'Number of Modules';
            acModule = false;
          }
          else{
            acModuleText = 'Total Parallel Strings';
            acModule = true;
          }  
        }
        
        roof1exists = false;
        roof2exists = false;
        roof3exists = false;
        roof4exists = false;
        
        RoofDescMap = new Map<String, String>();
        RoofDescMap.put('roof1','');
        RoofDescMap.put('roof2','');
        RoofDescMap.put('roof3','');
        RoofDescMap.put('roof4','');
        
        RoofInvtrManf = new Map<String, String>();
        RoofInvtrManf.put('roof1','');
        RoofInvtrManf.put('roof2','');
        RoofInvtrManf.put('roof3','');
        RoofInvtrManf.put('roof4','');
        
        RoofInvtrModl = new Map<String, String>();
        RoofInvtrModl.put('roof1','');
        RoofInvtrModl.put('roof2','');
        RoofInvtrModl.put('roof3','');
        RoofInvtrModl.put('roof4','');
        
        RoofInvrtrcnt = new Map<String, Decimal>();
        RoofInvrtrcnt.put('roof1',0);
        RoofInvrtrcnt.put('roof2',0);
        RoofInvrtrcnt.put('roof3',0);
        RoofInvrtrcnt.put('roof4',0);
        
        RoofModuleQty = new Map<String, Decimal>();
        RoofModuleQty.put('roof1',0);
        RoofModuleQty.put('roof2',0);
        RoofModuleQty.put('roof3',0);
        RoofModuleQty.put('roof4',0);
        
        RoofTotalParallelStr = new Map<String, Decimal>();
        RoofTotalParallelStr.put('roof1',0);
        RoofTotalParallelStr.put('roof2',0);
        RoofTotalParallelStr.put('roof3',0);
        RoofTotalParallelStr.put('roof4',0);
        
        RoofPitch= new Map<String, String>();
        RoofPitch.put('roof1','');
        RoofPitch.put('roof2','');
        RoofPitch.put('roof3','');
        RoofPitch.put('roof4','');
                
        RoofAzimuth= new Map<String, Decimal>();
        RoofAzimuth.put('roof1',0);
        RoofAzimuth.put('roof2',0);
        RoofAzimuth.put('roof3',0);
        RoofAzimuth.put('roof4',0);
        
        roofdetailMap =new Map<String, Roof_Details__c>();
        
        List<System_Production__c> systemProdList = new List<System_Production__c>();
        List<Quote> qtList = new List<Quote>();
        systemProdList = [SELECT ID,
                             System_Size_DC__c,
                             System_Size_AC__c,
                             Upfront_Incentives__c,
                             //Rebate_Design_Factor__c,
                            // Solar_Loan_Interest_Rate__c,
                             //Monthly_Loan_Payment_Net_Of_ITC__c,
                            // Monthly_Loan_Payment_With_ITC__c,
                             Monthly_Lease_Payment__c,
                           //  Monthly_Lease_Payment_7_50_discount__c,
                             Upfront_Lease_Payment__c,
                             Cost_per_watt_DC__c,
                             cost_per_watt_AC__c,
                             Incentive_Design_Factor__c,
                             Monthly_Lease_Payment7_50discount__c,
                             Monthly_Electric_Bill_Without_PV_year1__c,
                             Monthly_Electric_Bill_With_PV_year1__c,
                             Monthly_Electric_Bill_saving_year1__c,
                             Percentage_Electricity_Produced__c,
                             Cash_Price_Return_On_Investment_year1__c,
                             Monthly_Electric_Bill_Without_PV_year5__c,
                             Monthly_Electric_Bill_With_PV_year5__c,
                             Monthly_Electric_Bill_saving_year5__c,
                             Cash_Price_Return_On_Investment_year5__c,
                             Total_Energy__c,
                             Quote__c
                             FROM
                             System_Production__c
                             WHERE
                             Quote__c =:qt.Id limit 1];

        if(systemProdList.size() > 0)
            systemProdOutput = systemProdList[0];
            
        qtList     =[SELECT ID,
                           Total_Energy__c,
                           System_Cost__c,
                           Status__c,
                           Elapsed_Time__c,
                           Latitude__c,
                            Longitude__c,
                            Start_Date__c,
                            End_Date__c,
                            Total_Contract_Price__c,
                            Financed_Amount__c,
                            Cost_of_Financing__c,
                            Equipment_Installation_Value__c,
                       Down_Payment__c
                       FROM
                           Quote
                    WHERE
                    ID =:qt.id limit 1];

        if(qtList.size() > 0) {
            QuoteOutput = qtList[0];
        }
            
            
        List<Quote_Summary__c> QuoteSummaryLst = [SELECT ID,
                          Account_Name__c,
                          Locked_Scenario__c,
                          System_Cost__c
                           FROM
                                  Quote_Summary__c
                           WHERE
                                  Locked_Scenario__c =: qt.id
                                  LIMIT 1///quote.ID///
                           ];
            
        if(QuoteSummaryLst.size()>0){
            QuoteSummary=QuoteSummaryLst[0];
        }
            
        
        populateRoofDetails();    
            
            
            
    }
    
    
    public void populateRoofDetails(){
        
        List<Roof_Details__c> roofDetails = [SELECT ID, 
                                                Modules_per_strings__c,
                                                Description__c,
                                                Total_parallel_strings__c,
                                                Inverter_Manufacturer__c,
                                                Inverter_Model__c,
                                                Inverter_Count__c,
                                                Direction__c,
                                                Pitch__c,
                                                Jan__c,
                                                Feb__c,
                                                Mar__c,
                                                Apr__c,
                                                May__c,
                                                Jun__c,
                                                Jul__c,
                                                Aug__c,
                                                Sep__c,
                                                Oct__c,
                                                Nov__c,
                                                Dec__c
                                             FROM Roof_Details__c 
                                            Where Roof_Design__r.Quote__c =:qt.Id];
              
        if(roofDetails.size()>0){
            roofcount = roofDetails.size()+1;         
            for(Integer i=0;i<roofDetails.size();i++){
                if(i==0){
                    
                    if(roofDetails[i].Description__c!=null){
                        RoofDescMap.put('roof1',roofDetails[i].Description__c);
                    }
                    if(roofDetails[i].Modules_per_strings__c!=null){
                        RoofModuleQty.put('roof1',roofDetails[i].Modules_per_strings__c);
                    }
                    if(roofDetails[i].Inverter_Manufacturer__c!=null){
                        RoofInvtrManf.put('roof1',roofDetails[i].Inverter_Manufacturer__c);
                    }
                    if(roofDetails[i].Inverter_Model__c!=null){
                        RoofInvtrModl.put('roof1',roofDetails[i].Inverter_Model__c);
                    }
                    if(roofDetails[i].Inverter_Count__c!=null){
                        RoofInvrtrcnt.put('roof1',roofDetails[i].Inverter_Count__c);
                    }
                    if(roofDetails[i].Total_parallel_strings__c!=null){
                        RoofTotalParallelStr.put('roof1',roofDetails[i].Total_parallel_strings__c);
                    }
                    if(roofDetails[i].Pitch__c!=null){
                        RoofPitch.put('roof1',roofDetails[i].Pitch__c);
                    }
                    if(roofDetails[i].Direction__c!=null){
                        RoofAzimuth.put('roof1',roofDetails[i].Direction__c);
                    }
                    roofdetailMap.put('roof1',roofDetails[i]);
                    roof1exists = true;
                }
                if(i==1){
                    if(roofDetails[i].Description__c!=null){
                        RoofDescMap.put('roof2',roofDetails[i].Description__c);
                    }
                    if(roofDetails[i].Modules_per_strings__c!=null){
                        RoofModuleQty.put('roof2',roofDetails[i].Modules_per_strings__c);
                    }
                    if(roofDetails[i].Inverter_Manufacturer__c!=null){
                        RoofInvtrManf.put('roof2',roofDetails[i].Inverter_Manufacturer__c);
                    }
                    if(roofDetails[i].Inverter_Model__c!=null){
                        RoofInvtrModl.put('roof2',roofDetails[i].Inverter_Model__c);
                    }
                    if(roofDetails[i].Inverter_Count__c!=null){
                        RoofInvrtrcnt.put('roof2',roofDetails[i].Inverter_Count__c);
                    }
                    if(roofDetails[i].Total_parallel_strings__c!=null){
                        RoofTotalParallelStr.put('roof2',roofDetails[i].Total_parallel_strings__c);
                    }
                    if(roofDetails[i].Pitch__c!=null){
                        RoofPitch.put('roof2',roofDetails[i].Pitch__c);
                    }
                    if(roofDetails[i].Direction__c!=null){
                        RoofAzimuth.put('roof2',roofDetails[i].Direction__c);
                    }
                    roofdetailMap.put('roof2',roofDetails[i]);
                    roof2exists = true;
                }
                if(i==2){
                    if(roofDetails[i].Description__c!=null){
                        RoofDescMap.put('roof3',roofDetails[i].Description__c);
                    }
                    if(roofDetails[i].Modules_per_strings__c!=null){
                        RoofModuleQty.put('roof3',roofDetails[i].Modules_per_strings__c);
                    }
                    if(roofDetails[i].Inverter_Manufacturer__c!=null){
                        RoofInvtrManf.put('roof3',roofDetails[i].Inverter_Manufacturer__c);
                    }
                    if(roofDetails[i].Inverter_Model__c!=null){
                        RoofInvtrModl.put('roof3',roofDetails[i].Inverter_Model__c);
                    }
                    if(roofDetails[i].Inverter_Count__c!=null){
                        RoofInvrtrcnt.put('roof3',roofDetails[i].Inverter_Count__c);
                    }
                    if(roofDetails[i].Total_parallel_strings__c!=null){
                        RoofTotalParallelStr.put('roof3',roofDetails[i].Total_parallel_strings__c);
                    }
                    if(roofDetails[i].Pitch__c!=null){
                        RoofPitch.put('roof3',roofDetails[i].Pitch__c);
                    }
                    if(roofDetails[i].Direction__c!=null){
                        RoofAzimuth.put('roof3',roofDetails[i].Direction__c);
                    }
                    roofdetailMap.put('roof3',roofDetails[i]);
                    roof3exists = true;
                }
                if(i==3){
                    if(roofDetails[i].Description__c!=null){
                        RoofDescMap.put('roof4',roofDetails[i].Description__c);
                    }
                    if(roofDetails[i].Modules_per_strings__c!=null){
                        RoofModuleQty.put('roof4',roofDetails[i].Modules_per_strings__c);
                    }
                    if(roofDetails[i].Inverter_Manufacturer__c!=null){
                        RoofInvtrManf.put('roof4',roofDetails[i].Inverter_Manufacturer__c);
                    }
                    if(roofDetails[i].Inverter_Model__c!=null){
                        RoofInvtrModl.put('roof4',roofDetails[i].Inverter_Model__c);
                    }
                    if(roofDetails[i].Inverter_Count__c!=null){
                        RoofInvrtrcnt.put('roof4',roofDetails[i].Inverter_Count__c);
                    }
                    if(roofDetails[i].Total_parallel_strings__c!=null){
                        RoofTotalParallelStr.put('roof4',roofDetails[i].Total_parallel_strings__c);
                    }
                    if(roofDetails[i].Pitch__c!=null){
                        RoofPitch.put('roof4',roofDetails[i].Pitch__c);
                    }
                    if(roofDetails[i].Direction__c!=null){
                        RoofAzimuth.put('roof4',roofDetails[i].Direction__c);
                    }
                    roofdetailMap.put('roof4',roofDetails[i]);
                    roof4exists = true;
                }
            }
        }else{
            List<Roof_Details__c> accRoofDetails = [SELECT ID,
                                                Description__c,
                                                Total_parallel_strings__c,
                                                Inverter_Manufacturer__c,
                                                Inverter_Model__c,
                                                Inverter_Count__c,
                                                Direction__c,
                                                Pitch__c,
                                                Jan__c,
                                                Feb__c,
                                                Mar__c,
                                                Apr__c,
                                                May__c,
                                                Jun__c,
                                                Jul__c,
                                                Aug__c,
                                                Sep__c,
                                                Oct__c,
                                                Nov__c,
                                                Dec__c
                                             FROM Roof_Details__c 
                                            Where Account__c =:qt.AccountId];
                                             
            if(accRoofDetails.size()>0){   
                roofcount = accRoofDetails.size()+1;                                
                for(Integer i=0;i<accRoofDetails.size();i++){
                
                    if(i==0){
                        if(accRoofDetails[i].Description__c!=null){
                            RoofDescMap.put('roof1',accRoofDetails[i].Description__c);
                        }    
                        if(qt.Total_Parallel_Strings_Roof1__c!=null){
                            RoofTotalParallelStr.put('roof1',qt.Total_Parallel_Strings_Roof1__c);
                        }
                        if(qt.Inverter_Manufacturer_Roof1__c!=null){
                            RoofInvtrManf.put('roof1',qt.Inverter_Manufacturer_Roof1__c);
                        }
                        if(qt.Inverter_Model__c!=null){
                            RoofInvtrModl.put('roof1',qt.Inverter_Model__c);
                        }
                        if(qt.Inverter_Count_Roof1__c!=null){
                            RoofInvrtrcnt.put('roof1',qt.Inverter_Count_Roof1__c);
                        }
                        if(qt.Modules_Per_String_Roof1__c!=null){
                            RoofModuleQty.put('roof1',qt.Modules_Per_String_Roof1__c);
                        }
                        if(accRoofDetails[i].Pitch__c!=null){
                            RoofPitch.put('roof1',accRoofDetails[i].Pitch__c);
                        }
                        if(accRoofDetails[i].Direction__c!=null){
                            RoofAzimuth.put('roof1',accRoofDetails[i].Direction__c);
                        }
                        roofdetailMap.put('roof1',accRoofDetails[i]);
                       roof1exists = true;
                    }
                    if(i==1){
                        if(accRoofDetails[i].Description__c!=null){
                            RoofDescMap.put('roof2',accRoofDetails[i].Description__c);
                        }    
                        if(qt.Total_Parallel_Strings_Roof2__c!=null){
                            RoofTotalParallelStr.put('roof2',qt.Total_Parallel_Strings_Roof2__c);
                        }
                        if(qt.Inverter_Manufacturer_Roof2__c!=null){
                            RoofInvtrManf.put('roof2',qt.Inverter_Manufacturer_Roof2__c);
                        }
                        if(qt.Inverter_Model__c!=null){
                            RoofInvtrModl.put('roof2',qt.Inverter_Model_2__c);
                        }
                        if(qt.Inverter_Count_Roof2__c!=null){
                            RoofInvrtrcnt.put('roof2',qt.Inverter_Count_Roof2__c);
                        }
                        if(qt.Modules_Per_String_Roof2__c!=null){
                            RoofModuleQty.put('roof2',qt.Modules_Per_String_Roof2__c);
                        }
                        if(accRoofDetails[i].Pitch__c!=null){
                            RoofPitch.put('roof2',accRoofDetails[i].Pitch__c);
                        }
                        if(accRoofDetails[i].Direction__c!=null){
                            RoofAzimuth.put('roof2',accRoofDetails[i].Direction__c);
                        }
                        roofdetailMap.put('roof2',accRoofDetails[i]);
                        roof2exists = true;
                        
                    }
                    if(i==2){
                        if(accRoofDetails[i].Description__c!=null){
                            RoofDescMap.put('roof3',accRoofDetails[i].Description__c);
                        }    
                        if(qt.Total_Parallel_Strings_Roof3__c!=null){
                            RoofTotalParallelStr.put('roof3',qt.Total_Parallel_Strings_Roof3__c);
                        }
                        if(qt.Inverter_Manufacturer_Roof3__c!=null){
                            RoofInvtrManf.put('roof3',qt.Inverter_Manufacturer_Roof3__c);
                        }
                        if(qt.Inverter_Model__c!=null){
                            RoofInvtrModl.put('roof3',qt.Inverter_Model_3__c);
                        }
                        if(qt.Inverter_Count_Roof3__c!=null){
                            RoofInvrtrcnt.put('roof3',qt.Inverter_Count_Roof3__c);
                        }
                        if(qt.Modules_Per_String_Roof3__c!=null){
                            RoofModuleQty.put('roof3',qt.Modules_Per_String_Roof3__c);
                        }
                        if(accRoofDetails[i].Pitch__c!=null){
                            RoofPitch.put('roof3',accRoofDetails[i].Pitch__c);
                        }
                        if(accRoofDetails[i].Direction__c!=null){
                            RoofAzimuth.put('roof3',accRoofDetails[i].Direction__c);
                        }
                        roofdetailMap.put('roof3',accRoofDetails[i]);
                        roof3exists = true;
                    }
                    if(i==3){
                        if(accRoofDetails[i].Description__c!=null){
                            RoofDescMap.put('roof4',accRoofDetails[i].Description__c);
                        }    
                        if(qt.Total_Parallel_Strings_Roof4__c!=null){
                            RoofTotalParallelStr.put('roof4',qt.Total_Parallel_Strings_Roof4__c);
                        }
                        if(qt.Inverter_Manufacturer_Roof4__c!=null){
                            RoofInvtrManf.put('roof4',qt.Inverter_Manufacturer_Roof4__c);
                        }
                        if(qt.Inverter_Model__c!=null){
                            RoofInvtrModl.put('roof4',qt.Inverter_Model_4__c);
                        }
                        if(qt.Inverter_Count_Roof4__c!=null){
                            RoofInvrtrcnt.put('roof4',qt.Inverter_Count_Roof4__c);
                        }
                        if(qt.Modules_Per_String_Roof4__c!=null){
                            RoofModuleQty.put('roof4',qt.Modules_Per_String_Roof4__c);
                        }
                        if(accRoofDetails[i].Pitch__c!=null){
                            RoofPitch.put('roof4',accRoofDetails[i].Pitch__c);
                        }
                        if(accRoofDetails[i].Direction__c!=null){
                            RoofAzimuth.put('roof4',accRoofDetails[i].Direction__c);
                        }
                        
                        roofdetailMap.put('roof4',accRoofDetails[i]);
                        roof4exists = true;
                    }
                }
                
                
            }                               

        }    
        system.debug('==Roof Desc==='+RoofDescMap); 
        system.debug('==Roof Modules==='+RoofTotalParallelStr);                                    
    
    }
           
    
}