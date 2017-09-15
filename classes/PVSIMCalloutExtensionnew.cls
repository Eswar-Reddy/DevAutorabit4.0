/*** Class added in Sunpower TPO Phase 1 -- 20/10/2013, to Generate PVSIM Request and get the Response ***/
public class PVSIMCalloutExtensionnew{

    // This Constructor is written for temporary purpose :Hari 24-09-2013 
    //  Commented : by Manoj Mishra 21OCT13
    /*  public PVSIMCalloutExtension(TPO_RoofDetailsQuote_validation controller) {
      populateEnergyWrapperList(null, idQuote);https://c.cs3.visual.force.com/s.gif
        System.debug('############## constructor1');
    */
    /* Code Cleanup 2017 WW21

    public Transient TPO_PVsimIntegration.SimulationResponse response;
    public Transient TPO_PVsimIntegration.SimulationRequest request;
    public String idQuote{get;set;}
    public String idAccount{get;set;}
    public Static String systemId{get;set;}
    public  List<EnergyWrapper> lst_EnergyWrapper{get;set;}
    //public String systemProdRTId;
    
 //   public QuickquoteCTRL con;
    public TPO_RoofDetailsQuotenew con;
    public Map<String, TPO_PV_SIM_INT__c> map_pvSimCustomSetting;
    public Account acc;
    public Quote qt;

    public PVSIMCalloutExtensionnew(){
        map_pvSimCustomSetting = TPO_PV_SIM_INT__c.getAll();   
        //populateEnergyWrapperList(null, idQuote);
        System.debug('############## constructor2');
    }
    
    
    public PVSIMCalloutExtensionnew(TPO_RoofDetailsQuotenew controller) {
        System.debug('############## constructor3');
        request = new TPO_PVsimIntegration.SimulationRequest();
        response = new TPO_PVsimIntegration.SimulationResponse();
        
       
        lst_EnergyWrapper = new List<EnergyWrapper>();
        
        idQuote = ApexPages.currentPage().getParameters().get('qid');
        idAccount = ApexPages.currentPage().getParameters().get('aid');
        
        this.con = controller;
        
        /*
        try{
            populateEnergyWrapperList(null, idQuote);     
        }catch(Exception e)
        {
        
        } 
        *//* Code Cleanup 2017 WW21
           
        //acc = PVSIMCalloutUtil.getAccountDetails(idAccount);
        //qt  = PVSIMCalloutUtil.getQuoteDetails(idQuote);  
    }
    
    public void init(){
    //idQuote  = qtID;
    //idAccount = accId;
            idQuote = ApexPages.currentPage().getParameters().get('qid');
        idAccount = ApexPages.currentPage().getParameters().get('aid');
        request = generateRequest();
        response =  doCallout(request);
        
        if(!response.Status.equalsIgnoreCase('ok')){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error is the response, please contact your administrator: ' + response.Status));
        }else{
          //  System.debug(LoggingLevel.error,'################## QuoteId is: ' + idQuote);
          //  System.debug(LoggingLevel.error,'##############response #### QuoteId is: ' + response );
            
              attachRequestAndResponseToQuote(idQuote, JSON.serialize(request), JSON.serialize(response));
              insertSystemProductionRecord(response, idQuote);
           // TPO_RoofDetailsQuotenew c = new TPO_RoofDetailsQuotenew(); // instantiate MyClass1
           // c.CalcDealerFee(); 
              //populateEnergyWrapperList();        
        }
      
    }
    
    // Method is used to Generate Pvsim Request using PvsimIntegration webservice class
    public TPO_PVsimIntegration.SimulationRequest generateRequest(){
    
        List<Roof_Details__c> Roofs = new List<Roof_Details__c>();
        
        Roofs = [SELECT ID, name, Apr__c, Aug__c, Dec__c, Description__c, Direction__c, Feb__c, Jan__c, Jul__c, Jun__c,
                  Mar__c, May__c, Nov__c, Oct__c, Pitch__c, Roof_Pitches__c, Sep__c, Shading_Measurement_Date__c,
                  Shading_Notes__c, Account__c,
                  Modules_per_strings__c,
                  Total_parallel_strings__c,
                  Inverter_Count__c,
                  Inverter_Model__c
                  
                  FROM
                  Roof_Details__c
                  WHERE Account__c =: idAccount  
                  ORDER BY CreatedDATE ASC LIMIT 4];
       
    TPO_PVsimIntegration.SimulationRequest obj = new TPO_PVsimIntegration.SimulationRequest ();
    TPO_PVsimIntegration.ArrayOfInverter arrayinverter =new TPO_PVsimIntegration.ArrayOfInverter();
    List<TPO_PVsimIntegration.Inverter> lstInvert = new List<TPO_PVsimIntegration.Inverter>();
    Map<Id, List<String>> map_RoofIdToListOfShadingData = new Map<Id, List<String>>();
    map_RoofIdToListOfShadingData = PVSIMCalloutUtil.putIdsAndShadingValues(Roofs);
    
    PVSIMCalloutUtil util = new PVSIMCalloutUtil();
    PVSIMCalloutUtil.getMapOfRoofToPVSIMNum(idQuote);
    
    Integer roofCount =1;
    Quote qt = PVSIMCalloutUtil.getQuoteDetails(idQuote);
    Account acc = PVSIMCalloutUtil.getAccountDetails(idAccount);   
    
    for(Roof_Details__c roof : Roofs){      
        System.debug('1 ################ entering roofs here');
        if(roof.Name.equalsIgnoreCase('roof 1')){
            System.debug('2 ################ entering roofs loop here');
            List<TPO_PVsimIntegration.MonthlyShadingData> lst_monthlyShadingData = new List<TPO_PVsimIntegration.MonthlyShadingData>();   
            lst_monthlyShadingData = PVSIMCalloutUtil.createShadingDataForRoof(map_RoofIdToListOfShadingData.get(Roof.Id)); 
            
            TPO_PVsimIntegration.ArrayOfMonthlyShadingData array_monthlyShadingData = new TPO_PVsimIntegration.ArrayOfMonthlyShadingData();
            array_monthlyShadingData.MonthlyShadingData = lst_monthlyShadingData;
        
            if(qt.Inverter_Model_Roof1__c != null){
                TPO_PVsimIntegration.Inverter invert = new TPO_PVsimIntegration.Inverter();
                TPO_PVsimIntegration.ArrayOfLayoutData ArrayOfLayoutData = new TPO_PVsimIntegration.ArrayOfLayoutData();
                List<TPO_PVsimIntegration.LayoutData> lstlayoutd = new List<TPO_PVsimIntegration.LayoutData>();
                
                if(qt.Roof_1_MPPT_1_Module__c != null && qt.Roof_1_MPPT_1_string__c != null)
                    lstlayoutd.add(PVSIMCalloutUtil.createLayoutData(roof, array_monthlyShadingData, roofCount, idQuote, 1, 1));
                
                if(qt.Roof_1_MPPT_2_Module__c != null && qt.Roof_1_MPPT_2_string__c != null)
                    lstlayoutd.add(PVSIMCalloutUtil.createLayoutData(roof, array_monthlyShadingData, roofCount, idQuote, 1, 2));
                
                ArrayOfLayoutData.LayoutData = lstlayoutd;
                lstInvert.add(PVSIMCalloutUtil.createInverter(ArrayOfLayoutData, 1, PVSIMCalloutUtil.getPVSIMNumberForRoofId(qt.Inverter_Model_Roof1__c)));
            }
            if(qt.Inverter_Model__c != null){   
                TPO_PVsimIntegration.Inverter invert = new TPO_PVsimIntegration.Inverter();
                TPO_PVsimIntegration.ArrayOfLayoutData ArrayOfLayoutData = new TPO_PVsimIntegration.ArrayOfLayoutData();
                List<TPO_PVsimIntegration.LayoutData> lstlayoutd = new List<TPO_PVsimIntegration.LayoutData>();
                
                if(qt.Roof_1_MPPT_3_Module__c != null && qt.Roof_1_MPPT_3_string__c != null)
                    lstlayoutd.add(PVSIMCalloutUtil.createLayoutData(roof, array_monthlyShadingData, roofCount, idQuote, 2, 1));
                
                if(qt.Roof_1_MPPT_4_Module__c != null && qt.Roof_1_MPPT_4_string__c != null)
                    lstlayoutd.add(PVSIMCalloutUtil.createLayoutData(roof, array_monthlyShadingData, roofCount, idQuote, 2, 2));
                
                ArrayOfLayoutData.LayoutData = lstlayoutd;                
                lstInvert.add(PVSIMCalloutUtil.createInverter(ArrayOfLayoutData, 1, PVSIMCalloutUtil.getPVSIMNumberForRoofId(qt.Inverter_Model__c)));
            }       
        }
        
        if(roof.Name.equalsIgnoreCase('roof 2')){
            List<TPO_PVsimIntegration.MonthlyShadingData> lst_monthlyShadingData = new List<TPO_PVsimIntegration.MonthlyShadingData>();   
            lst_monthlyShadingData = PVSIMCalloutUtil.createShadingDataForRoof(map_RoofIdToListOfShadingData.get(Roof.Id)); 
            
            TPO_PVsimIntegration.ArrayOfMonthlyShadingData array_monthlyShadingData = new TPO_PVsimIntegration.ArrayOfMonthlyShadingData();
            array_monthlyShadingData.MonthlyShadingData = lst_monthlyShadingData;
            
            if(qt.Inverter_Model_Roof2__c != null){
                TPO_PVsimIntegration.Inverter invert = new TPO_PVsimIntegration.Inverter();
                TPO_PVsimIntegration.ArrayOfLayoutData ArrayOfLayoutData = new TPO_PVsimIntegration.ArrayOfLayoutData();
                List<TPO_PVsimIntegration.LayoutData> lstlayoutd = new List<TPO_PVsimIntegration.LayoutData>();
                
                if(qt.Roof_2_MPPT_1_Module__c != null && qt.Roof_2_MPPT_1_string__c != null)
                lstlayoutd.add(PVSIMCalloutUtil.createLayoutData(roof, array_monthlyShadingData, roofCount, idQuote, 1, 1));
                
                if(qt.Roof_2_MPPT_2_Module__c != null && qt.Roof_2_MPPT_2_string__c != null)
                lstlayoutd.add(PVSIMCalloutUtil.createLayoutData(roof, array_monthlyShadingData, roofCount, idQuote, 1, 2));
                
                ArrayOfLayoutData.LayoutData = lstlayoutd;
                lstInvert.add(PVSIMCalloutUtil.createInverter(ArrayOfLayoutData, 1, PVSIMCalloutUtil.getPVSIMNumberForRoofId(qt.Inverter_Model_Roof2__c)));
            }
            if(qt.Inverter_Model_2__c != null){ 
                TPO_PVsimIntegration.Inverter invert = new TPO_PVsimIntegration.Inverter();
                TPO_PVsimIntegration.ArrayOfLayoutData ArrayOfLayoutData = new TPO_PVsimIntegration.ArrayOfLayoutData();
                List<TPO_PVsimIntegration.LayoutData> lstlayoutd = new List<TPO_PVsimIntegration.LayoutData>();
                
                if(qt.Roof_2_MPPT_3_Module__c != null && qt.Roof_2_MPPT_3_string__c != null)
                lstlayoutd.add(PVSIMCalloutUtil.createLayoutData(roof, array_monthlyShadingData, roofCount, idQuote, 2, 1));
                
                if(qt.Roof_2_MPPT_4_Module__c != null && qt.Roof_2_MPPT_4_string__c != null)
                lstlayoutd.add(PVSIMCalloutUtil.createLayoutData(roof, array_monthlyShadingData, roofCount, idQuote, 2, 2));
                
                ArrayOfLayoutData.LayoutData = lstlayoutd;                
                lstInvert.add(PVSIMCalloutUtil.createInverter(ArrayOfLayoutData, 1, PVSIMCalloutUtil.getPVSIMNumberForRoofId(qt.Inverter_Model_2__c)));
            }       
        }

        if(roof.Name.equalsIgnoreCase('roof 3')){
            List<TPO_PVsimIntegration.MonthlyShadingData> lst_monthlyShadingData = new List<TPO_PVsimIntegration.MonthlyShadingData>();   
            lst_monthlyShadingData = PVSIMCalloutUtil.createShadingDataForRoof(map_RoofIdToListOfShadingData.get(Roof.Id)); 
            
            TPO_PVsimIntegration.ArrayOfMonthlyShadingData array_monthlyShadingData = new TPO_PVsimIntegration.ArrayOfMonthlyShadingData();
            array_monthlyShadingData.MonthlyShadingData = lst_monthlyShadingData;
            
            if(qt.Inverter_Model_Roof3__c != null){
                TPO_PVsimIntegration.Inverter invert = new TPO_PVsimIntegration.Inverter();
                TPO_PVsimIntegration.ArrayOfLayoutData ArrayOfLayoutData = new TPO_PVsimIntegration.ArrayOfLayoutData();
                List<TPO_PVsimIntegration.LayoutData> lstlayoutd = new List<TPO_PVsimIntegration.LayoutData>();
                
                if(qt.Roof_3_MPPT_1_Module__c != null && qt.Roof_3_MPPT_1_string__c != null)
                lstlayoutd.add(PVSIMCalloutUtil.createLayoutData(roof, array_monthlyShadingData, roofCount, idQuote, 1, 1));
                
                if(qt.Roof_3_MPPT_2_Module__c != null && qt.Roof_3_MPPT_2_string__c != null)
                lstlayoutd.add(PVSIMCalloutUtil.createLayoutData(roof, array_monthlyShadingData, roofCount, idQuote, 1, 2));
                
                ArrayOfLayoutData.LayoutData = lstlayoutd;
                lstInvert.add(PVSIMCalloutUtil.createInverter(ArrayOfLayoutData, 1, PVSIMCalloutUtil.getPVSIMNumberForRoofId(qt.Inverter_Model_Roof3__c)));
            }
            if(qt.Inverter_Model_3__c != null){ 
                TPO_PVsimIntegration.Inverter invert = new TPO_PVsimIntegration.Inverter();
                TPO_PVsimIntegration.ArrayOfLayoutData ArrayOfLayoutData = new TPO_PVsimIntegration.ArrayOfLayoutData();
                List<TPO_PVsimIntegration.LayoutData> lstlayoutd = new List<TPO_PVsimIntegration.LayoutData>();
                
                if(qt.Roof_3_MPPT_3_Module__c != null && qt.Roof_3_MPPT_3_string__c != null)
                lstlayoutd.add(PVSIMCalloutUtil.createLayoutData(roof, array_monthlyShadingData, roofCount, idQuote, 2, 1));
                
                if(qt.Roof_3_MPPT_4_Module__c != null && qt.Roof_3_MPPT_4_string__c != null)
                lstlayoutd.add(PVSIMCalloutUtil.createLayoutData(roof, array_monthlyShadingData, roofCount, idQuote, 2, 2));
                
                ArrayOfLayoutData.LayoutData = lstlayoutd;                
                lstInvert.add(PVSIMCalloutUtil.createInverter(ArrayOfLayoutData, 1, PVSIMCalloutUtil.getPVSIMNumberForRoofId(qt.Inverter_Model_3__c)));
            }       
        }

        if(roof.Name.equalsIgnoreCase('roof 4')){
            List<TPO_PVsimIntegration.MonthlyShadingData> lst_monthlyShadingData = new List<TPO_PVsimIntegration.MonthlyShadingData>();   
            lst_monthlyShadingData = PVSIMCalloutUtil.createShadingDataForRoof(map_RoofIdToListOfShadingData.get(Roof.Id)); 
            
            TPO_PVsimIntegration.ArrayOfMonthlyShadingData array_monthlyShadingData = new TPO_PVsimIntegration.ArrayOfMonthlyShadingData();
            array_monthlyShadingData.MonthlyShadingData = lst_monthlyShadingData;
            
            if(qt.Inverter_Model_Roof4__c != null){
                TPO_PVsimIntegration.Inverter invert = new TPO_PVsimIntegration.Inverter();
                TPO_PVsimIntegration.ArrayOfLayoutData ArrayOfLayoutData = new TPO_PVsimIntegration.ArrayOfLayoutData();
                List<TPO_PVsimIntegration.LayoutData> lstlayoutd = new List<TPO_PVsimIntegration.LayoutData>();
                
                if(qt.Roof_4_MPPT_1_Module__c != null && qt.Roof_4_MPPT_1_string__c != null)
                lstlayoutd.add(PVSIMCalloutUtil.createLayoutData(roof, array_monthlyShadingData, roofCount, idQuote, 1, 1));
                
                if(qt.Roof_4_MPPT_2_Module__c != null && qt.Roof_4_MPPT_2_string__c != null)
                lstlayoutd.add(PVSIMCalloutUtil.createLayoutData(roof, array_monthlyShadingData, roofCount, idQuote, 1, 2));
                
                ArrayOfLayoutData.LayoutData = lstlayoutd;
                lstInvert.add(PVSIMCalloutUtil.createInverter(ArrayOfLayoutData, 1, PVSIMCalloutUtil.getPVSIMNumberForRoofId(qt.Inverter_Model_Roof4__c)));
            }
            if(qt.Inverter_Model_4__c != null){ 
                TPO_PVsimIntegration.Inverter invert = new TPO_PVsimIntegration.Inverter();
                TPO_PVsimIntegration.ArrayOfLayoutData ArrayOfLayoutData = new TPO_PVsimIntegration.ArrayOfLayoutData();
                List<TPO_PVsimIntegration.LayoutData> lstlayoutd = new List<TPO_PVsimIntegration.LayoutData>();
                
                if(qt.Roof_4_MPPT_3_Module__c != null && qt.Roof_4_MPPT_3_string__c != null)
                lstlayoutd.add(PVSIMCalloutUtil.createLayoutData(roof, array_monthlyShadingData, roofCount, idQuote, 2, 1));
                
                if(qt.Roof_4_MPPT_4_Module__c != null && qt.Roof_4_MPPT_4_string__c != null)
                lstlayoutd.add(PVSIMCalloutUtil.createLayoutData(roof, array_monthlyShadingData, roofCount, idQuote, 2, 2));
                
                ArrayOfLayoutData.LayoutData = lstlayoutd;                
                lstInvert.add(PVSIMCalloutUtil.createInverter(ArrayOfLayoutData, 1, PVSIMCalloutUtil.getPVSIMNumberForRoofId(qt.Inverter_Model_4__c)));
            }       
        }       
                
        roofCount++;
    }   
        
        arrayinverter.Inverter = lstInvert;
        System.debug('##################### lstInvert ' + lstInvert);
        string year = String.valueOf(System.Today().Year());
        string month = '01';
        string day = '01';
        string hour = '00';
        string minute = '00';
        string second = '00';
        string stringDate = year + '-' + month
        + '-' + day + ' ' + hour + ':' + 
        minute +  ':' + second;
        
        Datetime myStartDate = datetime.valueOf(stringDate);
        myStartDate.addHours(-8);
        
        
        
        string month1 = '12';
        string day1 = '31';
        string hour1 = '23';
        string minute1 = '59';
        string second1 = '59';
        string stringDate1 = year + '-' + month1
        + '-' + day1 + ' ' + hour1 + ':' + 
        minute1 +  ':' + second1;
        
        Datetime myEndDate = datetime.valueOf(stringDate1);
        myEndDate.addHours(-8);
        
        obj.LockedQuote = qt.Is_Locked__c;
        obj.LeaseNumber = qt.Consolidated_Lease_Number__c;
        
        //obj.AccessKey ='b807b921-f6a4-4922-8a75-68296147dd08';
        // Hari: Added code to get Access_key__c from Custom Settings, Date: 07-Mar-2014. 
        if(map_pvSimCustomSetting.get('PV SIM1') != null)
          {
             system.debug('@@@@@'+map_pvSimCustomSetting.get('PV SIM1').Access_key__c);
             obj.AccessKey = map_pvSimCustomSetting.get('PV SIM1').Access_key__c;
             }
        obj.StartDate = myStartDate.format('yyyy-MM-dd\'T\'hh:mm:ss');
        obj.EndDate = myEndDate.format('yyyy-MM-dd\'T\'hh:mm:ss'); 
        obj.Inverters = arrayinverter;
        obj.Latitude= acc.Lat__c;
        obj.Longitude= acc.Log__c;
        obj.OutputSettings = PVSIMCalloutUtil.createEnergyOutput();

    

        return obj; 
    }
    
    // Method is used to get the pvsim response making a Web Service call out
    public TPO_PVsimIntegration.SimulationResponse doCallout(TPO_PVsimIntegration.SimulationRequest request){
        TPO_PVsimIntegration.SimulationResponse response = new TPO_PVsimIntegration.SimulationResponse();
        
        TPO_PVsimIntegration.SimEngBrokerServiceEndpoint stub = new TPO_PVsimIntegration.SimEngBrokerServiceEndpoint();
      // TPO_PVsimIntegration.BasicHttpBinding_ISimEngBrokerService stub = new TPO_PVsimIntegration.BasicHttpBinding_ISimEngBrokerService();
        //stub.endpoint_x = 'https://pvsim-dev.sunpowercorp.com/SimEngPublicService/SFSimEngPublicService.svc/soap';     //map_pvSimCustomSetting.get('PV SIM DEV').End_point__c;
         // Hari: Added code to get endpoint_x from Custom Settings, Date: 07-Mar-2014. 
        if(map_pvSimCustomSetting.get('PV SIM1') != null)
          {
             system.debug('@@@@@'+map_pvSimCustomSetting.get('PV SIM1').End_point__c);
             stub.endpoint_x = map_pvSimCustomSetting.get('PV SIM1').End_point__c;
             }
         System.debug('##############request in Callout #### QuoteId is: ' + request); 
         Stub.timeout_x = 120000; 
         response = stub.RunSimulation(request); 
         System.debug('##############response in Callout #### QuoteId is: ' + response );       
         return response;
    }
    
    // Method is used to insert the attachments of Pvsim Request xml and Response in a quote
    @future
    public static void attachRequestAndResponseToQuote(String quoteId, String req, String Res){
        List<Attachment> lst_Att = new List<Attachment>();
        
        Attachment attReq = new Attachment();
        attReq.parentId = quoteId;
        attReq.Body = Blob.valueof(req);
        attReq.Name = 'PV SIM Request.xml';
        attReq.ContentType = 'xml';
        lst_Att.add(attReq);
        
        Attachment attRes = new Attachment();
        attRes.parentId = quoteId;
        attRes.Body = Blob.valueof(res);
        attRes.Name = 'PV SIM Response.xml';
        attRes.ContentType = 'xml';
        lst_Att.add(attRes);
                
        insert lst_Att;
    }  
    
    // Method is used to insert System Production Record
    public Static void insertSystemProductionRecord(TPO_PVsimIntegration.SimulationResponse res, String quoteId){
        //Taking field API names from Custom Setting Data
        Map<String, SystemObjectMonthlyEnergyNames__c> monthlyEnergy = SystemObjectMonthlyEnergyNames__c.getAll();
        Map<String, SystemObjectYearlyEnergyOutput__c> yearlyEnergy = SystemObjectYearlyEnergyOutput__c.getAll();
        Map<String, SysProdHighAndLowFieldNames__c> highLowPeGuFieldNames = SysProdHighAndLowFieldNames__c.getAll();
        Map<String, TPO_PeGu__c> highLowPercentValues = TPO_PeGu__c.getAll();
        
        
        Double highPercent = highLowPercentValues.get('TPO INT').TPO_PeGu_High__c;
        Double lowPercent = highLowPercentValues.get('TPO INT').TPO_PeGu_Low__c;
        
        
        
        //Processing entries in monthly energy fields
        TPO_PVsimIntegration.ArrayOfMonthlyEnergy array_MonthlyEnergy = new TPO_PVsimIntegration.ArrayOfMonthlyEnergy();
        
        if(res.MonthlyIntervalEnergyOutput != null){
            array_MonthlyEnergy = res.MonthlyIntervalEnergyOutput;
        }
        
        TPO_PVsimIntegration.MonthlyEnergy[] lst_monthlyEnergy = new List<TPO_PVsimIntegration.MonthlyEnergy>();
        
        if(array_MonthlyEnergy.MonthlyEnergy != null){
            lst_monthlyEnergy = array_MonthlyEnergy.MonthlyEnergy;
        }
        
        sObject systemProdObj = new System_Production__c();
        
        Integer count = 1;
        if(lst_monthlyEnergy != null && lst_monthlyEnergy.size() > 0){      
            for(TPO_PVsimIntegration.MonthlyEnergy mEnergy : lst_monthlyEnergy){
                systemProdObj.put(monthlyEnergy.get(String.valueOf(count)).FieldName__c, mEnergy.Energy);
                count++;    
            }
        }
        
        
        
        //Processing entries in yearly energy fields
        TPO_PVsimIntegration.ArrayOfAnnualEnergy array_AnnualEnergy = new TPO_PVsimIntegration.ArrayOfAnnualEnergy();
        
        if(res.YearlyIntervalEnergyOutput != null){
            array_AnnualEnergy = res.YearlyIntervalEnergyOutput;
        }
        
        
        TPO_PVsimIntegration.AnnualEnergy[] lst_annualEnergy = new List<TPO_PVsimIntegration.AnnualEnergy>();
        
        if(array_AnnualEnergy.AnnualEnergy != null){
            lst_annualEnergy = array_AnnualEnergy.AnnualEnergy;
        }
        
        
        Integer count2 = 1;
        if(lst_annualEnergy != null && lst_annualEnergy.size() > 0){
            for(TPO_PVsimIntegration.AnnualEnergy annualEnergy : lst_annualEnergy){
                systemProdObj.put(yearlyEnergy.get(String.valueOf(count2)).BaseEnergy__c, annualEnergy.BaseEnergy); 
                Decimal DegradationFactor = Decimal.valueOf(annualEnergy.DegradationFactor);
                System.debug('########################### annualEnergy.DegradationFactor ' + annualEnergy.DegradationFactor);
                
                systemProdObj.put(yearlyEnergy.get(String.valueOf(count2)).DegradationFactor__c, DegradationFactor.setScale(12));   
                systemProdObj.put(yearlyEnergy.get(String.valueOf(count2)).NetEnergy__c, annualEnergy.Energy);
                systemProdObj.put(highLowPeGuFieldNames.get(String.valueOf(count2)).High_Names__c, ((highPercent/100 * annualEnergy.Energy) + annualEnergy.Energy));
                systemProdObj.put(highLowPeGuFieldNames.get(String.valueOf(count2)).Low_Names__c, (annualEnergy.Energy -(lowPercent/100 * annualEnergy.Energy)));                
                count2++;
            }
        }
        
        systemProdObj.put('Name', System.now().format('yyyy-MM-dd\'T\'hh:mm:ss'));
        systemProdObj.put('Quote__c', quoteId);
        FR_Record_Type__c frt1    = FR_Record_Type__c.getValues('FR RecordType Id');
            String systemProdRTId = frt1.FR_SystemProduction_RT_Id__c;
        systemProdObj.put('RecordTypeId', systemProdRTId);
        
         
        System.debug('############################## going to insert system production' );
        
        if(systemProdObj != null){
            insert systemProdObj;
            systemId = systemProdObj.Id;
            
            Quote q = new Quote(id=(ID)systemProdObj.get('Quote__c'), Total_Yr_1_Production__c = (Decimal)systemProdObj.get('PV_AnnualNetEnergy_Year1__c'));
            update q;
            
            System.debug('############################## systemProdObj.Id :' + systemProdObj);

        }
        
      //  populateEnergyWrapperList();  
    }
    
    // Method is used to Adding Values in a list to Populate Pvsim Response from system Production object
    /*public void populateEnergyWrapperList(){ 
        String quoteId = ApexPages.currentPage().getParameters().get('qid');
       
        
        System_Production__c sysProductionObj;
        List<System_Production__c> lst_systemProduction = new List<System_Production__c>();
        
        System.debug('############################## calling populateEnergyWrapperList');
        
        
        if(quoteId != null){
        /*
        if(sysProductionId != null){
            lst_systemProduction = [select Id, PV_AnnualNetEnergy_Year1__c, PV_AnnualNetEnergy_Year2__c, PV_AnnualNetEnergy_Year3__c,
                                           PV_AnnualNetEnergy_Year4__c, PV_AnnualNetEnergy_Year5__c, PV_AnnualNetEnergy_Year6__c, 
                                           PV_AnnualNetEnergy_Year7__c, PV_AnnualNetEnergy_Year8__c, PV_AnnualNetEnergy_Year9__c,
                                           PV_AnnualNetEnergy_Year10__c, PV_AnnualNetEnergy_Year11__c, PV_AnnualNetEnergy_Year12__c,
                                           PV_AnnualNetEnergy_Year13__c, PV_AnnualNetEnergy_Year14__c, PV_AnnualNetEnergy_Year15__c,
                                           PV_AnnualNetEnergy_Year16__c, PV_AnnualNetEnergy_Year17__c, PV_AnnualNetEnergy_Year18__c,
                                           PV_AnnualNetEnergy_Year19__c, PV_AnnualNetEnergy_Year20__c, PV_AnnualNetEnergy_Year21__c,
                                           PV_AnnualNetEnergy_Year22__c, PV_AnnualNetEnergy_Year23__c, PV_AnnualNetEnergy_Year24__c,
                                           PV_AnnualNetEnergy_Year25__c
                                           FROM System_Production__c
                                           WHERE ID =: sysProductionId limit 1];
         }else if(quoteId != null){
         */
             /*lst_systemProduction = [select Id, PV_AnnualNetEnergy_Year1__c, PV_AnnualNetEnergy_Year2__c, PV_AnnualNetEnergy_Year3__c,
                                           PV_AnnualNetEnergy_Year4__c, PV_AnnualNetEnergy_Year5__c, PV_AnnualNetEnergy_Year6__c, 
                                           PV_AnnualNetEnergy_Year7__c, PV_AnnualNetEnergy_Year8__c, PV_AnnualNetEnergy_Year9__c,
                                           PV_AnnualNetEnergy_Year10__c, PV_AnnualNetEnergy_Year11__c, PV_AnnualNetEnergy_Year12__c,
                                           PV_AnnualNetEnergy_Year13__c, PV_AnnualNetEnergy_Year14__c, PV_AnnualNetEnergy_Year15__c,
                                           PV_AnnualNetEnergy_Year16__c, PV_AnnualNetEnergy_Year17__c, PV_AnnualNetEnergy_Year18__c,
                                           PV_AnnualNetEnergy_Year19__c, PV_AnnualNetEnergy_Year20__c, PV_AnnualNetEnergy_Year21__c,
                                           PV_AnnualNetEnergy_Year22__c, PV_AnnualNetEnergy_Year23__c, PV_AnnualNetEnergy_Year24__c,
                                           PV_AnnualNetEnergy_Year25__c
                                           FROM System_Production__c
                                           WHERE Quote__c =: quoteId ORDER BY createdDate DESC limit 1];*/
         //}
         
                                           
         /*if(lst_systemProduction != null && lst_systemProduction.size() > 0){
               sysProductionObj = lst_systemProduction[0];
                                             
               lst_EnergyWrapper = new List<EnergyWrapper>();

               EnergyWrapper ew = new EnergyWrapper();
               
               ew.yearName = '1';
               ew.energyValue = sysProductionObj.PV_AnnualNetEnergy_Year1__c!= null? Math.round(sysProductionObj.PV_AnnualNetEnergy_Year1__c) : null;
               lst_EnergyWrapper.add(ew);
               ew = new EnergyWrapper();
               ew.yearName = '2';
               ew.energyValue = sysProductionObj.PV_AnnualNetEnergy_Year2__c != null ? Math.round(sysProductionObj.PV_AnnualNetEnergy_Year2__c) : null;
               lst_EnergyWrapper.add(ew);                           
               ew = new EnergyWrapper();
               ew.yearName = '3';
               ew.energyValue = sysProductionObj.PV_AnnualNetEnergy_Year3__c != null ? Math.round(sysProductionObj.PV_AnnualNetEnergy_Year3__c) : null;
               lst_EnergyWrapper.add(ew);
                ew = new EnergyWrapper();
               ew.yearName = '4';
               ew.energyValue = sysProductionObj.PV_AnnualNetEnergy_Year4__c!= null ? Math.round(sysProductionObj.PV_AnnualNetEnergy_Year4__c) : null;
               lst_EnergyWrapper.add(ew);
               ew = new EnergyWrapper();
               ew.yearName = '5';
               ew.energyValue = sysProductionObj.PV_AnnualNetEnergy_Year5__c!= null ? Math.round(sysProductionObj.PV_AnnualNetEnergy_Year5__c) : null;
               lst_EnergyWrapper.add(ew);
               ew = new EnergyWrapper();
               ew.yearName = '6';
               ew.energyValue = sysProductionObj.PV_AnnualNetEnergy_Year6__c != null? Math.round(sysProductionObj.PV_AnnualNetEnergy_Year6__c) : null;
               lst_EnergyWrapper.add(ew);
               ew = new EnergyWrapper();
               ew.yearName = '7';
               ew.energyValue = sysProductionObj.PV_AnnualNetEnergy_Year7__c != null? Math.round(sysProductionObj.PV_AnnualNetEnergy_Year7__c) : null;
               lst_EnergyWrapper.add(ew);
               ew = new EnergyWrapper();
               ew.yearName = '8';
               ew.energyValue = sysProductionObj.PV_AnnualNetEnergy_Year8__c != null ?  Math.round(sysProductionObj.PV_AnnualNetEnergy_Year8__c) : null;
               lst_EnergyWrapper.add(ew);
               ew = new EnergyWrapper();
               ew.yearName = '9';
               ew.energyValue = sysProductionObj.PV_AnnualNetEnergy_Year9__c != null ? Math.round(sysProductionObj.PV_AnnualNetEnergy_Year9__c) : null;
               lst_EnergyWrapper.add(ew);
               ew = new EnergyWrapper();
               ew.yearName = '10';
               ew.energyValue = sysProductionObj.PV_AnnualNetEnergy_Year10__c != null ? Math.round(sysProductionObj.PV_AnnualNetEnergy_Year10__c) : null;
               lst_EnergyWrapper.add(ew);
               ew = new EnergyWrapper();
               ew.yearName = '11';
               ew.energyValue = sysProductionObj.PV_AnnualNetEnergy_Year11__c != null ? Math.round(sysProductionObj.PV_AnnualNetEnergy_Year11__c) : null;
               lst_EnergyWrapper.add(ew);
               ew = new EnergyWrapper();
               ew.yearName = '12';
               ew.energyValue = sysProductionObj.PV_AnnualNetEnergy_Year12__c != null ? Math.round(sysProductionObj.PV_AnnualNetEnergy_Year12__c) : null;
               lst_EnergyWrapper.add(ew);
               ew = new EnergyWrapper();
               ew.yearName = '13';
               ew.energyValue = sysProductionObj.PV_AnnualNetEnergy_Year13__c != null ? Math.round(sysProductionObj.PV_AnnualNetEnergy_Year13__c) : null;
               lst_EnergyWrapper.add(ew);
               ew = new EnergyWrapper();
               ew.yearName = '14';
               ew.energyValue = sysProductionObj.PV_AnnualNetEnergy_Year14__c != null ? Math.round(sysProductionObj.PV_AnnualNetEnergy_Year14__c) : null;
               lst_EnergyWrapper.add(ew);
               ew = new EnergyWrapper();
               ew.yearName = '15';
               ew.energyValue = sysProductionObj.PV_AnnualNetEnergy_Year15__c != null ? Math.round(sysProductionObj.PV_AnnualNetEnergy_Year15__c) : null;
               lst_EnergyWrapper.add(ew);                                                                                                                                                                                    
               ew = new EnergyWrapper();
               ew.yearName = '16';
               ew.energyValue = sysProductionObj.PV_AnnualNetEnergy_Year16__c != null ? Math.round(sysProductionObj.PV_AnnualNetEnergy_Year16__c) : null;
               lst_EnergyWrapper.add(ew);
               ew = new EnergyWrapper();
               ew.yearName = '17';
               ew.energyValue = sysProductionObj.PV_AnnualNetEnergy_Year17__c != null ? Math.round(sysProductionObj.PV_AnnualNetEnergy_Year17__c) : null;
               lst_EnergyWrapper.add(ew);
               ew = new EnergyWrapper();
               ew.yearName = '18';
               ew.energyValue = sysProductionObj.PV_AnnualNetEnergy_Year18__c != null ? Math.round(sysProductionObj.PV_AnnualNetEnergy_Year18__c) : null;
               lst_EnergyWrapper.add(ew);
               ew = new EnergyWrapper();
               ew.yearName = '19';
               ew.energyValue = sysProductionObj.PV_AnnualNetEnergy_Year19__c != null ? Math.round(sysProductionObj.PV_AnnualNetEnergy_Year19__c) : null;
               lst_EnergyWrapper.add(ew);
               ew = new EnergyWrapper();
               ew.yearName = '20';
               ew.energyValue = sysProductionObj.PV_AnnualNetEnergy_Year21__c != null ? Math.round(sysProductionObj.PV_AnnualNetEnergy_Year21__c) : null;
               lst_EnergyWrapper.add(ew);
               ew = new EnergyWrapper();
               ew.yearName = '21';
               ew.energyValue = sysProductionObj.PV_AnnualNetEnergy_Year21__c != null ? Math.round(sysProductionObj.PV_AnnualNetEnergy_Year21__c) : null;
               lst_EnergyWrapper.add(ew);
               ew = new EnergyWrapper();
               ew.yearName = '22';
               ew.energyValue = sysProductionObj.PV_AnnualNetEnergy_Year22__c != null ? Math.round(sysProductionObj.PV_AnnualNetEnergy_Year22__c) : null;
               lst_EnergyWrapper.add(ew);
               ew = new EnergyWrapper();
               ew.yearName = '23';
               ew.energyValue = sysProductionObj.PV_AnnualNetEnergy_Year23__c != null ? Math.round(sysProductionObj.PV_AnnualNetEnergy_Year23__c) : null;
               lst_EnergyWrapper.add(ew);
               ew = new EnergyWrapper();
               ew.yearName = '24';
               ew.energyValue =  sysProductionObj.PV_AnnualNetEnergy_Year24__c != null ? Math.round(sysProductionObj.PV_AnnualNetEnergy_Year24__c): null;
               lst_EnergyWrapper.add(ew);
               ew = new EnergyWrapper();
               ew.yearName = '25';
               ew.energyValue = sysProductionObj.PV_AnnualNetEnergy_Year25__c != null ? Math.round(sysProductionObj.PV_AnnualNetEnergy_Year25__c) : null;
               lst_EnergyWrapper.add(ew);
               system.debug('@@@@@'+lst_EnergyWrapper);
            }
        }
    }   *//* Code Cleanup 2017 WW21
    
    //Wrapper class to create a values for year and energy 
    public class EnergyWrapper{
        public String yearName{get;set;}
        public Decimal energyValue{get;set;}
    } */
       
}