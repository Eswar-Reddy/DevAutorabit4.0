/*** Class added in Sunpower TPO Phase 1 -- 20/10/2013, To Generate PvsimInput Response ***/
public class PVSIMCalloutUtil{/*
    public Static Map<String, String> map_ModelNameToPVSimNumber;
    public Static Map<Id, String> mapOfRoofIdToModule;
    
    public PVSIMCalloutUtil(){
        map_ModelNameToPVSimNumber = new Map<String, String>();
        mapOfRoofIdToModule = new Map<Id, String>();      
    }
    
    // Method is used to Process Roof Details Data
    public Static Map<Id, List<String>> putIdsAndShadingValues(List<Roof_Details__c> lst_roofs){
        Map<Id, List<String>> map_RoofIdToArrayOfShadingData = new Map<Id, List<String>>(); 
        
        for(Roof_Details__c roof : lst_roofs){
            system.debug('#############roof.jan__c  ' + roof.jan__c);
            List<String> lst_ShadingData = new List<String>();
            lst_ShadingData.add(String.valueOf(1-(roof.jan__c/100)));
            lst_ShadingData.add(String.valueOf(1-(roof.feb__c/100)));
            lst_ShadingData.add(String.valueOf(1-(roof.mar__c/100)));
            lst_ShadingData.add(String.valueOf(1-(roof.apr__c/100)));
            lst_ShadingData.add(String.valueOf(1-(roof.may__c/100)));
            lst_ShadingData.add(String.valueOf(1-(roof.jun__c/100)));
            lst_ShadingData.add(String.valueOf(1-(roof.jul__c/100)));
            lst_ShadingData.add(String.valueOf(1-(roof.aug__c/100)));
            lst_ShadingData.add(String.valueOf(1-(roof.sep__c/100)));
            lst_ShadingData.add(String.valueOf(1-(roof.oct__c/100)));
            lst_ShadingData.add(String.valueOf(1-(roof.nov__c/100)));
            lst_ShadingData.add(String.valueOf(1-(roof.dec__c/100)));
            
            map_RoofIdToArrayOfShadingData.put(roof.Id, lst_ShadingData);        
        } 
        
        return map_RoofIdToArrayOfShadingData;    
    }
    
    //Method is used to Create Energy Output
    public Static TPO_PVsimIntegration.EnergyOutputSettings createEnergyOutput()
    {
        TPO_PVsimIntegration.EnergyOutputSettings  energySettings = new TPO_PVsimIntegration.EnergyOutputSettings();
        energySettings.HourlyIntervalEnergyOutput = true;
        energySettings.MonthlyAverageIntervalEnergyOutput= true;
        energySettings.YearlyIntervalEnergyOutput= true;
        energySettings.YearlyInterval_NumberOfYears= 25;
        energySettings.MonthlyIntervalEnergyOutput= true;
        
        return energySettings;
        
    }
    
    //Method is used to Create Shading Data For Roof
    public Static List<TPO_PVsimIntegration.MonthlyShadingData> createShadingDataForRoof(List<String> lst_ShadingData){
        List<TPO_PVsimIntegration.MonthlyShadingData> lst_MonthlyShadingData = new List<TPO_PVsimIntegration.MonthlyShadingData>();
        
        Integer count = 1;
        for(String str : lst_ShadingData){
            TPO_PVsimIntegration.MonthlyShadingData msd = new TPO_PVsimIntegration.MonthlyShadingData();
            
            msd.Month = count;
            msd.Shading = decimal.valueOf(str);
            
            lst_MonthlyShadingData.add(msd);
            count++;     
        }
        return lst_MonthlyShadingData;   
    }
    
    //Method is used to Create Layout Data
    public Static TPO_PVsimIntegration.LayoutData createLayoutData(Roof_Details__c roof, TPO_PVsimIntegration.ArrayOfMonthlyShadingData array_monthlyShadingData, integer roofCount, String quoteId, integer invCount, integer subInvCount){
        
        Quote qt = getQuoteDetails(quoteId);
        
        //Individual Layout data for single roof
        TPO_PVsimIntegration.LayoutData ld = new TPO_PVsimIntegration.LayoutData();
        ld.SystemAzimuth = roof.Direction__c;
        ld.AxisTiltAngle = Double.valueOf(roof.Pitch__c.mid(roof.Pitch__c.indexOf('(')+1, (roof.Pitch__c.length()+1 - roof.Pitch__c.indexOf(')')))); //Double.valueOf(roof.Pitch__c.left(roof.Pitch__c.indexOf('(')).replace(':', '.'));
        ld.MountingSystemId = 1;
        ld.StandardPVModuleId = getPVSIMNumber(qt.System_Model__c);
        ld.MonthlyShadingData = array_monthlyShadingData;
        System.debug('####################### roof ' + roof);
            
        //ld.ModuleCountPerString = roof.Modules_per_strings__c;
        //ld.ParallelStringsCount = roof.Total_parallel_strings__c;
        
        
        if(roofCount == 1){
            if(invCount == 1){
                if(subInvCount == 1){
                    ld.ModuleCountPerString = Integer.valueOf(qt.Roof_1_MPPT_1_Module__c);
                    ld.ParallelStringsCount = Integer.valueOf(qt.Roof_1_MPPT_1_string__c); 
                }
                if(subInvCount == 2){
                    ld.ModuleCountPerString = Integer.valueOf(qt.Roof_1_MPPT_2_Module__c);
                    ld.ParallelStringsCount = Integer.valueOf(qt.Roof_1_MPPT_2_string__c); 
                }
                
            }else if(invCount == 2){
                if(subInvCount == 1){
                    ld.ModuleCountPerString = Integer.valueOf(qt.Roof_1_MPPT_3_Module__c);
                    ld.ParallelStringsCount = Integer.valueOf(qt.Roof_1_MPPT_3_string__c); 
                }
                if(subInvCount == 2){
                    ld.ModuleCountPerString = Integer.valueOf(qt.Roof_1_MPPT_4_Module__c);
                    ld.ParallelStringsCount = Integer.valueOf(qt.Roof_1_MPPT_4_string__c); 
                }
            }    
        }else if(roofCount == 2){
            if(invCount == 1){
                if(subInvCount == 1){
                    ld.ModuleCountPerString = Integer.valueOf(qt.Roof_2_MPPT_1_Module__c);
                    ld.ParallelStringsCount = Integer.valueOf(qt.Roof_2_MPPT_1_string__c); 
                }
                if(subInvCount == 2){
                    ld.ModuleCountPerString = Integer.valueOf(qt.Roof_2_MPPT_2_Module__c);
                    ld.ParallelStringsCount = Integer.valueOf(qt.Roof_2_MPPT_2_string__c); 
                }
                
            }else if(invCount == 2){
                if(subInvCount == 1){
                    ld.ModuleCountPerString = Integer.valueOf(qt.Roof_2_MPPT_3_Module__c);
                    ld.ParallelStringsCount = Integer.valueOf(qt.Roof_2_MPPT_3_string__c); 
                }
                if(subInvCount == 2){
                    ld.ModuleCountPerString = Integer.valueOf(qt.Roof_2_MPPT_4_Module__c);
                    ld.ParallelStringsCount = Integer.valueOf(qt.Roof_2_MPPT_4_string__c); 
                }
            }    
        }else if(roofCount == 3){
            if(invCount == 1){
                if(subInvCount == 1){
                    ld.ModuleCountPerString = Integer.valueOf(qt.Roof_3_MPPT_1_Module__c);
                    ld.ParallelStringsCount = Integer.valueOf(qt.Roof_3_MPPT_1_string__c); 
                }
                if(subInvCount == 2){
                    ld.ModuleCountPerString = Integer.valueOf(qt.Roof_3_MPPT_2_Module__c);
                    ld.ParallelStringsCount = Integer.valueOf(qt.Roof_3_MPPT_2_string__c); 
                }
                
            }else if(invCount == 2){
                if(subInvCount == 1){
                    ld.ModuleCountPerString = Integer.valueOf(qt.Roof_3_MPPT_3_Module__c);
                    ld.ParallelStringsCount = Integer.valueOf(qt.Roof_3_MPPT_3_string__c); 
                }
                if(subInvCount == 2){
                    ld.ModuleCountPerString = Integer.valueOf(qt.Roof_3_MPPT_4_Module__c);
                    ld.ParallelStringsCount = Integer.valueOf(qt.Roof_3_MPPT_4_string__c); 
                }
            }           
        }else if(roofCount == 4){
            if(invCount == 1){
                if(subInvCount == 1){
                    ld.ModuleCountPerString = Integer.valueOf(qt.Roof_4_MPPT_1_Module__c);
                    ld.ParallelStringsCount = Integer.valueOf(qt.Roof_4_MPPT_1_string__c); 
                }
                if(subInvCount == 2){
                    ld.ModuleCountPerString = Integer.valueOf(qt.Roof_4_MPPT_2_Module__c);
                    ld.ParallelStringsCount = Integer.valueOf(qt.Roof_4_MPPT_2_string__c); 
                }
                
            }else if(invCount == 2){
                if(subInvCount == 1){
                    ld.ModuleCountPerString = Integer.valueOf(qt.Roof_4_MPPT_3_Module__c);
                    ld.ParallelStringsCount = Integer.valueOf(qt.Roof_4_MPPT_3_string__c); 
                }
                if(subInvCount == 2){
                    ld.ModuleCountPerString = Integer.valueOf(qt.Roof_4_MPPT_4_Module__c);
                    ld.ParallelStringsCount = Integer.valueOf(qt.Roof_4_MPPT_4_string__c); 
                }
            }
        }
        
        return ld;         
    }
    
    //Method is used to Create Inverter
    public Static TPO_PVsimIntegration.Inverter createInverter(TPO_PVsimIntegration.ArrayOfLayoutData aold, integer roofCount, Integer inverterId){
        //single invertor
        TPO_PVsimIntegration.Inverter inv = new TPO_PVsimIntegration.Inverter();
        inv.Layouts = aold;
        inv.StandardInverterId =  inverterId;
        inv.InverterCount = roofCount;
        
        return inv; 
                
    }
    
    //Method is used to Get PVSIM Number
    public Static void getMapOfRoofToPVSIMNum(String quoteId){
        Quote qt = getQuoteDetails(quoteId);
        Set<String> modelNames = new Set<String>(); 
        
        Integer count = 1;
        
        modelNames.add(qt.Inverter_Model_Roof1__c);
        modelNames.add(qt.Inverter_Model__c);
        
        modelNames.add(qt.Inverter_Model_Roof2__c);
        modelNames.add(qt.Inverter_Model_2__c);
        
        modelNames.add(qt.Inverter_Model_Roof3__c);
        modelNames.add(qt.Inverter_Model_3__c);
        
        modelNames.add(qt.Inverter_Model_Roof4__c);
        modelNames.add(qt.Inverter_Model_4__c);

        getMapOfPLINameToPVSIMNumber(modelNames);   
      }
     
     //Method is used to Update Price List Item with PVSIM Number 
     public Static void getMapOfPLINameToPVSIMNumber(Set<String> set_ModelValues){  
                
        List<Price_List_Item__c> lst_pli = [Select Id, Name, PV_SIM_No__c from Price_List_Item__c WHERE Price_List__r.Name = 'TPO FR PriceList' AND Name IN : set_ModelValues];
        
        for(Price_List_Item__c pli : lst_pli){
            String pvSimNum = pli.PV_SIM_No__c.format();
                  
            map_ModelNameToPVSimNumber.put(pli.Name, pvSimNum);    
        } 
     } 
     
     //Method is used to Get PVSIM Number For Inverter Model
     public Static Integer getPVSIMNumberForRoofId(String inverterModel){
         String pvSimNumber;
         
         if((inverterModel != null || inverterModel != '')){
             pvSimNumber = map_ModelNameToPVSimNumber.get(inverterModel);    
         }else{
             pvSimNumber = String.valueOf('0');
         }
         
         return Integer.valueOf(pvSimNumber);        
     }  
     
     //Method is used to Get PVSIM Number For System model 
     public Static Integer getPVSIMNumber(String SystemModel){
         Decimal pvSimNumber;
         Price_List_Item__c pl;
         
         List<Price_List_Item__c> lst_pl = [SELECT ID,PV_SIM_No__c, Category__c,Name FROM Price_List_Item__c WHERE Name=: SystemModel AND Category__c='Module'];
         
         if(lst_pl != null && lst_pl.size() > 0){
             pl = lst_pl[0];
         }
         
         if(pl != null && pl.PV_SIM_No__c != null){
             pvSimNumber = pl.PV_SIM_No__c;
         }else{
             pvSimNumber = 0;
         }

        return Integer.valueof(pvSimNumber);        
     }
    
    //Method is used to Get Account Details
    public Static Account getAccountDetails(String accId){
        Account acc = [select Id, Lat__c, Log__c, Latitude__c, Longitude__c from Account WHERE ID =: accId limit 1];
        
        return acc;
    }   
    
    //Method is used to Get Quote Details
    public Static Quote getQuoteDetails(String quoteId){
        Quote q = [select Id, Inverter_Model__c, Inverter_Model_2__c, Inverter_Model_3__c,
        Inverter_Model_4__c, Total_Parallel_Strings_Roof1__c,
        Inverter_Model_Roof1__c,
        Inverter_Model_Roof2__c,
        Inverter_Model_Roof3__c,
        Inverter_Model_Roof4__c,
        Lease_Number__c,Consolidated_Lease_Number__c,               
        Is_Locked__c,
        Total_Parallel_Strings_Roof2__c,
        Total_Parallel_Strings_Roof3__c,
        Total_Parallel_Strings_Roof4__c,
        Modules_Per_String_Roof1__c,
        Modules_Per_String_Roof2__c,
        Modules_Per_String_Roof3__c,
        Modules_Per_String_Roof4__c,
        Roof_1_MPPT_1_Module__c,
        Roof_1_MPPT_1_string__c,
        Roof_1_MPPT_2_Module__c,
        Roof_1_MPPT_2_string__c,
        Roof_1_MPPT_3_Module__c,
        Roof_1_MPPT_3_string__c,
        Roof_1_MPPT_4_Module__c,
        Roof_1_MPPT_4_string__c,

        Roof_2_MPPT_1_Module__c,
        Roof_2_MPPT_1_string__c,
        Roof_2_MPPT_2_Module__c,
        Roof_2_MPPT_2_string__c,
        Roof_2_MPPT_3_Module__c,
        Roof_2_MPPT_3_string__c,
        Roof_2_MPPT_4_Module__c,
        Roof_2_MPPT_4_string__c,
        
        Roof_3_MPPT_1_Module__c,
        Roof_3_MPPT_1_string__c,
        Roof_3_MPPT_2_Module__c,
        Roof_3_MPPT_2_string__c,
        Roof_3_MPPT_3_Module__c,
        Roof_3_MPPT_3_string__c,
        Roof_3_MPPT_4_Module__c,
        Roof_3_MPPT_4_string__c,
        
        Roof_4_MPPT_1_Module__c,
        Roof_4_MPPT_1_string__c,
        Roof_4_MPPT_2_Module__c,
        Roof_4_MPPT_2_string__c,
        Roof_4_MPPT_3_Module__c,
        Roof_4_MPPT_3_string__c,
        Roof_4_MPPT_4_Module__c,
        Roof_4_MPPT_4_string__c,
        
        System_Model__c FROM Quote WHERE ID =: QuoteId limit 1];
        return q;
    }
    
    /*
    public Static void parseSOAPToXml(TPO_PVsimIntegration.SFSimulationResponse res, ID systemProdId){
       String xmlOutput;
       XmlStreamWriter writer = new XmlStreamWriter();
       writer.writeStartDocument('utf-8', '1.0');

       writer.writeStartElement('s', 'Envelope', 'http://schemas.xmlsoap.org/soap/envelope/');
       writer.writeStartElement('s', 'Body', 'http://www.w3.org/2001/XMLSchema-instance');
       writer.writeNamespace('xsi', 'http://www.w3.org/2001/XMLSchema-instance');
       writer.writeNamespace('xsd', 'http://www.w3.org/2001/XMLSchema');
             
       writer.writeStartElement('', 'RunSimulationResponse', 'http://tempuri.org/');     
       writer.writeStartElement('', 'RunSimulationResult', '');     

       
       
       //HourlyIntervalEnergyOutput parse begins
            writer.writeStartElement('', 'HourlyIntervalEnergyOutput', ''); // HourlyIntervalEnergyOutput begins
               
            TPO_PVsimIntegration.ArrayOfHourlyEnergy array_HourlyIntervalEnergyOutput = new TPO_PVsimIntegration.ArrayOfHourlyEnergy();
            array_HourlyIntervalEnergyOutput = res.HourlyIntervalEnergyOutput;
            
            TPO_PVsimIntegration.HourlyEnergy[] lst_HourlyEnergy = new List<TPO_PVsimIntegration.HourlyEnergy>();
            lst_HourlyEnergy = array_HourlyIntervalEnergyOutput.HourlyEnergy;

            
            
            for(TPO_PVsimIntegration.HourlyEnergy he : lst_HourlyEnergy){
                writer.writeStartElement('', 'HourlyEnergy', ''); // HourlyEnergy begins
                
                writer.writeAttribute('', '', 'Interval', String.valueOf(he.Interval));
                writer.writeAttribute('', '', 'Month', String.valueOf(he.Month));
                writer.writeAttribute('', '', 'Day', String.valueOf(he.Day));
                writer.writeAttribute('', '', 'Hour', String.valueOf(he.Hour));
                writer.writeAttribute('', '', 'Energy', String.valueOf(he.Energy));
                
                writer.writeEndElement(); // HourlyEnergy closed
            }
            
            
            writer.writeEndElement(); // HourlyIntervalEnergyOutput closed
       //HourlyIntervalEnergyOutput parse ends
            
            
       //MonthlyHourlyAverageEnergyOutput parse begins
            writer.writeStartElement('', 'MonthlyHourlyAverageEnergyOutput', ''); // MonthlyHourlyAverageEnergyOutput begins           
            
            TPO_PVsimIntegration.ArrayOfMonthlyHourlyEnergy array_MonthlyHourlyAverageEnergyOutput = new TPO_PVsimIntegration.ArrayOfMonthlyHourlyEnergy();
            array_MonthlyHourlyAverageEnergyOutput = res.MonthlyHourlyAverageEnergyOutput;
            
            TPO_PVsimIntegration.MonthlyHourlyEnergy[] lst_MonthlyHourlyEnergy = new List<TPO_PVsimIntegration.MonthlyHourlyEnergy>();
            lst_MonthlyHourlyEnergy = array_MonthlyHourlyAverageEnergyOutput.MonthlyHourlyEnergy;
            
            
            
            for(TPO_PVsimIntegration.MonthlyHourlyEnergy mhe : lst_MonthlyHourlyEnergy){
                writer.writeStartElement('', 'MonthlyHourlyEnergy', ''); // MonthlyHourlyEnergy begins
                
                writer.writeAttribute('', '', 'Month', String.valueOf(mhe.Month));
                writer.writeAttribute('', '', 'Hour', String.valueOf(mhe.Hour));
                writer.writeAttribute('', '', 'Energy', String.valueOf(mhe.Energy));
                
                writer.writeEndElement(); // MonthlyHourlyEnergy closed
            }
            
            
            writer.writeEndElement(); // MonthlyHourlyAverageEnergyOutput closed
            
       //MonthlyHourlyAverageEnergyOutput parse ends
            
            
       //Monthly Energy parse begins
            writer.writeStartElement('', 'MonthlyIntervalEnergyOutput', ''); // MonthlyIntervalEnergyOutput started            
            TPO_PVsimIntegration.ArrayOfMonthlyEnergy array_MonthlyEnergy = new TPO_PVsimIntegration.ArrayOfMonthlyEnergy();
            array_MonthlyEnergy = res.MonthlyIntervalEnergyOutput;
            
            TPO_PVsimIntegration.MonthlyEnergy[] lst_monthlyEnergy = new List<TPO_PVsimIntegration.MonthlyEnergy>();
            lst_monthlyEnergy = array_MonthlyEnergy.MonthlyEnergy;
            
            
            
            for(TPO_PVsimIntegration.MonthlyEnergy mthe : lst_monthlyEnergy){
                writer.writeStartElement('', 'MonthlyEnergy', ''); //MonthlyEnergy begins
                
                writer.writeAttribute('', '', 'Month', String.valueOf(mthe.Month));
                writer.writeAttribute('', '', 'Energy', String.valueOf(mthe.Energy));
                
                writer.writeEndElement(); // MonthlyEnergy closed
            }
            
            
            writer.writeEndElement(); // MonthlyIntervalEnergyOutput closed
            
       //Montly energy parse ends
            
                
       //Annual Energy parse begins
            writer.writeStartElement('', 'YearlyIntervalEnergyOutput', '');  // YearlyIntervalEnergyOutput begins       
            TPO_PVsimIntegration.ArrayOfAnnualEnergy array_AnnualEnergy = new TPO_PVsimIntegration.ArrayOfAnnualEnergy();
            array_AnnualEnergy = res.YearlyIntervalEnergyOutput;
           
            TPO_PVsimIntegration.AnnualEnergy[] lst_annualEnergy = new List<TPO_PVsimIntegration.AnnualEnergy>();
            lst_annualEnergy = array_AnnualEnergy.AnnualEnergy;
            
            
            
            for(TPO_PVsimIntegration.AnnualEnergy ae : lst_annualEnergy){
                writer.writeStartElement('', 'AnnualEnergy', ''); //AnnualEnergy begins
                
                writer.writeAttribute('', '', 'Year', String.valueOf(ae.Year));
                writer.writeAttribute('', '', 'BaseEnergy', String.valueOf(ae.BaseEnergy));
                writer.writeAttribute('', '', 'DegradationFactor', String.valueOf(ae.DegradationFactor));
                writer.writeAttribute('', '', 'Energy', String.valueOf(ae.Energy));
                
                writer.writeEndElement(); // AnnualEnergy closed
            }
            
            
            writer.writeEndElement(); // YearlyIntervalEnergyOutput closed                
       //Annual Energy parse ends
       
       writer.writeStartElement(null, 'Status', null); //Status begins
       writer.writeCharacters(res.Status);
       writer.writeEndElement(); // Status closed
     
       writer.writeEndElement(); // RunSimulationResult closed
       writer.writeEndElement(); // RunSimulationResponse closed
       writer.writeEndElement(); // Body closed
       writer.writeEndElement(); // Envelope closed
       
       writer.writeEndDocument(); // Xml Document ends       
       
       xmlOutput = writer.getXmlString();
       
       /*
       Map<String, SysProduction_XML_Field_Names__c> xmlFields = SysProduction_XML_Field_Names__c.getAll();
       
       Integer count = 1;     
       for(integer i=0; i <= xmlOutput.length(); i =+ 32650){
           String tempString = xmlOutput.mid(i, 32500);          
           systemProdObj.put(xmlFields.get(String.valueOf(count)).XMLField__c, tempString);
           count++;
           
           if(count >= 29){
               break;
           }     
       }
       
       return systemProdObj;
       */
       
       //Attachment att = new Attachment();
        
    //}

}