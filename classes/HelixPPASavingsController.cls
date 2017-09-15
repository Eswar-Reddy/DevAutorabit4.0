public class HelixPPASavingsController {
    public HelixPPAPickList creditRatingPicklist {get; private set;}
    
    public HelixPPASavingsController() {
        String quoteId = ApexPages.currentPage().getParameters().get('quoteId');
        Quote q;
        if (String.IsNotBlank(quoteId)) {
            q = getQuote(quoteId);
        }
        if (q != null && q.Id != null) {
            creditRatingPicklist = new HelixPPAPickList('Quote', 'Credit_Rating__c', q.Credit_Rating__c);
        } else {
            creditRatingPicklist = new HelixPPAPickList('Quote', 'Credit_Rating__c', '');
        }
    }

//-----------------------------------------------------------------------------------
// Calculate Savings remote action
//-----------------------------------------------------------------------------------
    @RemoteAction
    public static CalculateSavingsResponse calculateSavings(CalculateSavingsRequest request) {
        CalculateSavingsResponse response = new CalculateSavingsResponse();

        String errorMessage = '';
        Boolean isSuccess = true;
        String finEngResponseXml = '';
        String genericError = 'There is a problem with this Helix Design Request. Our team has been notified and we will provide you with an update soon.';
        //customError
        if (request != null) {                    
            Quote qt = getQuote(request.quoteId);
            User u = getUser(UserInfo.getUserId());
            
            // add elements
            if (request.finEngRequest != null && request.finEngRequest.batches != null) {
                for (HelixPPAFinEng.Batch batch : request.finEngRequest.batches) {
                    batch.inputCommand.elements.add(new HelixPPAFinEng.Element('State Abbreviation', qt.Opportunity.Facility_State1__c));
                    String cod = '';
                    if (qt.Opportunity.Commercial_Operation_Date__c != null) {
                        Date dt = qt.Opportunity.Commercial_Operation_Date__c;
                        DateTime dtTm = DateTime.newInstance(dt.year(), dt.month(), dt.day());
                        String sDate = dtTm.format('yyyy-MM-dd');
                        String sTime  = dtTm.format('HH:mm:ss.SSSZ');
                        cod = sDate + 'T' + sTime;
                    }
                    batch.inputCommand.elements.add(new HelixPPAFinEng.Element('COD', cod));
                    String dealer = '', dealerId = '';
                    if (u.Contact.AccountId != null) {
                        dealer = u.Contact.Account.Name;
                        dealerId = u.Contact.AccountId;
                    }
                    batch.inputCommand.elements.add(new HelixPPAFinEng.Element('Dealer', dealer));
                    batch.inputCommand.elements.add(new HelixPPAFinEng.Element('Dealer ID', dealerId));
                }
            }
            
            //KM_04122017: Monthly Production Data
            Set <String> designIdSet = new Set <String>();
            List<String> designModuleTypeAndWattage_list = new List<String>(); //for use in item section later below
             
            if (request.designIdList != null) {
                for (String designId : request.designIdList) {            
                    if (String.IsNotBlank(designId)) {
                        designIdSet.add(designId);
                    }            
                }
                        
                Map <Id, Design__c> design_map = new Map<Id, Design__c>(getDesignList(designIdSet));
                
                Set<Id> roofDesignIdSet = new Set<Id>();
                Set<Design__c> missingDesignData_set = new Set<Design__c>();  
                List<Design__c> productionDataValidation_list = new List<Design__c>();
                List<EnergyProductionYr1__c> ep_list = new List<EnergyProductionYr1__c>();                                   
            
                for (Design__c d: design_map.values()) {
                    if (d.Roof_Design__r.Id != null){
                        roofDesignIdSet.add(d.Roof_Design__r.Id);
                    } 
                                                           
                    designModuleTypeAndWattage_list.add(d.ModuleTypeAndWattage__c); 
                                        
                    if (d.Module_Quantity__c == null || d.Actual_System_Size__c == null ||
                        (d.Roof_Design__r.Id == null && (d.Energy_Productions_Year1__r == null || d.Energy_Productions_Year1__r.size() == 0))) {
                        missingDesignData_set.add(d); 
                    } else if (d.Energy_Productions_Year1__r.size() > 0) {
                        ep_list.add(d.Energy_Productions_Year1__r[0]);    // add latest modified. sub query already sorted
                    }                                       
                }
                
                //build complete list of energy production data records related to the designList
                //start of with energy production from roof designs
                ep_list.addAll(getEnergyProductionsForRoofDesigns(roofDesignIdSet));
                
                //extract energy production data of the roof design or design 
                if (ep_list.size() > 0) {                                    
                    List<String> months = new List<String>{'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};
                    List<Decimal> mpd_list = new List<Decimal>{0,0,0,0,0,0,0,0,0,0,0,0};
                                                                                                                                                                                           
                    for (EnergyProductionYr1__c e: ep_list) {                                                                                                       
                        Id dId;
                        
                        if (e.Design__c == null) {
                            dId = e.RoofDesign__r.Design__c;
                        } else {
                            dId = e.Design__c;                            
                        } 
                           
                        if(!isFilled(e.Jan__c) || !isFilled(e.Feb__c) || !isFilled(e.Mar__c) || 
                           !isFilled(e.Apr__c) || !isFilled(e.May__c) || !isFilled(e.Jun__c) || 
                           !isFilled(e.Jul__c) || !isFilled(e.Aug__c) || !isFilled(e.Sep__c) || 
                           !isFilled(e.Oct__c) || !isFilled(e.Nov__c) || !isFilled(e.Dec__c) ||
                           design_map.get(dId).Actual_Annual_Production__c == null) {                               
                               missingDesignData_set.add(design_map.get(dId));
                        } else {    
                            //aggregate values for xml file
                            mpd_list[0] += e.Jan__c;
                            mpd_list[1] += e.Feb__c;
                            mpd_list[2] += e.Mar__c;
                            mpd_list[3] += e.Apr__c;
                            mpd_list[4] += e.May__c;
                            mpd_list[5] += e.Jun__c;
                            mpd_list[6] += e.Jul__c;
                            mpd_list[7] += e.Aug__c;
                            mpd_list[8] += e.Sep__c;
                            mpd_list[9] += e.Oct__c;
                            mpd_list[10] += e.Nov__c;
                            mpd_list[11] += e.Dec__c; 
                                                                                           
                            Decimal totalWatts = e.Jan__c + e.Feb__c + e.Mar__c + e.Apr__c 
                                                 + e.May__c + e.Jun__c + e.Jul__c + e.Aug__c 
                                                 + e.Sep__c + e.Oct__c + e.Nov__c + e.Dec__c;                                                                                                                    
                            
                            Decimal variance = design_map.get(dId).Actual_Annual_Production__c - totalWatts;
                            
                            if(variance > 12 || variance < -12) {
                                productionDataValidation_list.add(design_map.get(dId));                        
                            }
                        }
                    } 
                    
                    if (missingDesignData_set.size() > 0) {
                        //throw UI error
                        errorMessage = 'Design data missing'; //genericError;
                        isSuccess = false;
                        response.customError = true;
                        
                        //send email                        
                        response.emailResponse = HelixPPAUtil.sendMissingDataValidationEmail(missingDesignData_set);
                    }
                    
                    if (productionDataValidation_list.size() > 0) {
                        //throw UI error
                        errorMessage = 'production match validation error'; //genericError;
                        isSuccess = false;
                        response.customError = true;
                            
                        //send email
                        response.emailResponse = HelixPPAUtil.sendProductionDataValidationEmail(productionDataValidation_list);
                    } 
                    if (request.finEngRequest != null && request.finEngRequest.batches != null) {                                                                                                                                            
                        for (HelixPPAFinEng.Batch batch : request.finEngRequest.batches) {
                            for (integer i=0; i<12; i++){
                                batch.inputCommand.elements.add(new HelixPPAFinEng.Element('Year 1 Production ' + months[i], String.valueOf(mpd_list[i])));
                            }                      
                        } 
                    }                                                                        
                } else {
                        missingDesignData_set.addAll(design_map.values());
                        //throw UI error
                        errorMessage = 'no energy production data found';//genericError;
                        isSuccess = false;
                        response.customError = true;
                        
                        //send email                        
                        response.emailResponse = HelixPPAUtil.sendMissingDataValidationEmail(missingDesignData_set);                    
                }         
                //end KM_04122017: Monthly Production Data
                 
                //KM_04122017: Module to Product2 matching part 1
                String quarter, year;
                List<Product2> products_list = new List<Product2>();
                 
                if (qt.opportunity.Installation_Date__c != null) {
                    integer q = (Math.floor(((qt.opportunity.Installation_Date__c.Month()-1)/3)+1)).intValue(); 
                    quarter = 'Q' + String.valueOf(q);
                    year = String.valueOf(qt.opportunity.Installation_Date__c).left(4);
                                          
                    products_list = [SELECT Id, Name,
                                            Module_Name__c,
                                            Quantity__c,
                                            Module_Wattage__c,
                                            Cost__c
                                     FROM Product2
                                     WHERE CurrencyISOCode = 'USD' 
                                           AND Year__c = :year 
                                           AND Quarter__c = :quarter
                                           AND Module_Name__c IN :designModuleTypeAndWattage_list
                                           AND Module_Wattage__c != null];
                }
                //end KM_04122017: Module to Product2 matching part 1
                
                // add items
                if (request.finEngRequest != null && request.finEngRequest.batches != null) {
                    for (HelixPPAFinEng.Batch batch : request.finEngRequest.batches) {
                        Set <String> stateSet = new Set <String>();
                        for (Design__c design : design_map.values()) {
                            if (design.Site__r.Opportunity_del__r.Facility_State1__c != null) {
                                stateSet.add(design.Site__r.Opportunity_del__r.Facility_State1__c);
                            }
                        }
                        List <Cost_Matrix__c> costMatrixList = getCostMatrixList(stateSet);
                        Map <String, List <Cost_Matrix__c>> techSysCostMatrixMap = getTechSysCostMatrixMap(costMatrixList);
                        Map <String, List <Cost_Matrix__c>> designTypeCostMatrixMap = getDesignTypeCostMatrixMap(costMatrixList);
                        
                        for (Design__c design : design_map.values()) {
                            Cost_Matrix__c cm;
                            if (cm == null) {
                                if (design.HelixDesignType__c != null && designTypeCostMatrixMap.containsKey(design.Cost_Matrix_Technology_System_Category__c)) { //KM
                                    List <Cost_Matrix__c> cmList = designTypeCostMatrixMap.get(design.Cost_Matrix_Technology_System_Category__c);
                                    if (cmList.size() == 1) {
                                        cm = cmList[0];
                                    } else if (cmList.size() > 1) {
                                        errorMessage = 'Error: Found ' + cmList.size() + ' Cost Matrix records for Helix Design Type: ' + design.Cost_Matrix_Technology_System_Category__c;
                                        isSuccess = false;
                                    } else if (cmList.size() == 0) {
                                        errorMessage = 'Error: No Cost Matrix records for Helix Design Type: ' + design.Cost_Matrix_Technology_System_Category__c;
                                        isSuccess = false;
                                    }
                                }
                            }
                            if (cm != null) {
                                HelixPPAFinEng.Item item = new HelixPPAFinEng.Item('Item');
                                item.comments.add('Design Id: ' + design.Id + ' Design Name: ' + design.Name);
                                item.comments.add('Cost Matrix Id: ' + cm.Id + ' Cost Matrix Name: ' + cm.Name);
                                String materialCost = cm.Total_Material_Cost__c != null ? String.valueOf(cm.Total_Material_Cost__c) : '';
                                String laborCost = cm.Total_Labor_Cost__c != null ? String.valueOf(cm.Total_Labor_Cost__c) : '';
                                String acctMiscCost = cm.Total_Accounting_Misc_Cost__c != null ? String.valueOf(cm.Total_Accounting_Misc_Cost__c) : '';
                                item.elements.add(new HelixPPAFinEng.Element('Material Cost', materialCost));
                                item.elements.add(new HelixPPAFinEng.Element('Labor Cost', laborCost));
                                item.elements.add(new HelixPPAFinEng.Element('Acct/Misc', acctMiscCost));
                                item.elements.add(new HelixPPAFinEng.Element('Type', cm.Technology_Category_Bucket__c));
                                
                                //KM_04122017: Module to Product2 matching part 2
                                boolean hasMatchedProduct = false;                           
                                
                                for (Product2 p:products_list){
                                    if (design.ModuleTypeAndWattage__c == p.Module_Name__c){
                                        hasMatchedProduct = true;
                                        item.comments.add('Product Id: ' + p.Id + ' Product Name: ' + p.Name);
                                        item.elements.add(new HelixPPAFinEng.Element('Panel Name', p.Module_Name__c));
                                        item.elements.add(new HelixPPAFinEng.Element('Panel Quantity', design.Module_Quantity__c != null ? String.valueOf(design.Module_Quantity__c) : ''));
                                        item.elements.add(new HelixPPAFinEng.Element('Size', p.Module_Wattage__c != null ? String.valueOf(p.Module_Wattage__c) : ''));
                                        if (p.Cost__c != null && p.Cost__c > 0) {
                                            item.elements.add(new HelixPPAFinEng.Element('Panel Cost', String.valueOf(p.Cost__c)));
                                        } else {
                                            item.elements.add(new HelixPPAFinEng.Element('Panel Cost', ''));
                                            item.comments.add('No product cost found for this item'); 
                                            isSuccess = false;
                                            if(String.isBlank(errorMessage)) errorMessage = 'No product cost found for this item';
                                            
                                        }
                                        break;
                                    }
                                }
                                //just in case no products matched the design's ModuleTypeAndWattage__c, send blank strings
                                if(!hasMatchedProduct) {
                                    item.comments.add('no products matched for the design system: ' + design.ModuleTypeAndWattage__c);
                                    item.elements.add(new HelixPPAFinEng.Element('Panel Name', ''));
                                    item.elements.add(new HelixPPAFinEng.Element('Panel Quantity', ''));
                                    item.elements.add(new HelixPPAFinEng.Element('Size', ''));
                                    item.elements.add(new HelixPPAFinEng.Element('Panel Cost', ''));   
                                    
                                    isSuccess = false;
                                    errorMessage = 'no products matched for the design system: ' + design.ModuleTypeAndWattage__c; 
                                }
                                //end KM_04122017: Module to Product2 matching part 2
    
                                batch.inputCommand.items.add(item);
                            } else {
                                errorMessage = 'Cost Matrix record not found for design: ' + design.Name;
                                isSuccess = false;
                            }
        
                        }
                        
                        //System Commissioning - TODO: Error handle
                        String systemCommissioning = costMatrixList.size() > 0 && costMatrixList[0].Sales_Configuration__r.System_Commissioning__c != null ? 
                            String.valueOf(costMatrixList[0].Sales_Configuration__r.System_Commissioning__c) : '';
                        batch.inputCommand.elements.add(new HelixPPAFinEng.Element('System Commissioning', systemCommissioning));
                    }
                }
            } //end of "if (request.designIdList != null)"
            
            String finEngRequestXml;
            if (request.finEngRequest != null) {
                finEngRequestXml = HelixPPAFinEng.getRequestXml(request.finEngRequest);
            }
            
            // call fin eng rest api
            
            if (String.IsNotBlank(request.quoteId)) {
                // call fineng
                Loan_Callout_Settings__c lcs = Loan_Callout_Settings__c.getInstance('FinEng');
                HttpRequest req = new HttpRequest();
                req.setEndpoint(lcs.Endpoint_URL__c);
                req.setHeader('X-ws-apikey', lcs.Client_Secret__c);
                req.setMethod('POST');
                req.setHeader('Content-Type', 'application/xml');
                req.setTimeout(120000);
                req.setBody(finEngRequestXml);
                Http http = new Http();
                
                if(isSuccess == true) {
                    try {
                        HttpResponse res = http.send(req);
                        Integer statusCode = res.getStatusCode();
                        if (statusCode >= 400) {
                            errorMessage = 'Error in FinEng response statusCode: ' + statusCode + ' status: ' + res.getStatus();
                            isSuccess = false;    
                        }
                        finEngResponseXml = res.getBody();
                    } catch(Exception e) {
                        errorMessage = 'Error while sending FinEng request: ' + e.getMessage();
                        isSuccess = false;
                    }
                }
                
                // create finEngRequest.xml quote attachments
                Attachment attReq = new Attachment();
                attReq.ParentId = request.quoteId;
                attReq.Body = Blob.valueOf(finEngRequestXml);
                attReq.Name = 'FinEng Request';
                try {
                    insert attReq;
                    response.requestXmlAttachmentId = attReq.Id;
                } catch(Exception e) {
                    errorMessage = 'Error while creating quote attachment finEngRequest.xml: ' + e.getMessage();
                    isSuccess = false;
                }
                    
                // create finEngResponseXml.xml quote attachments - DO NOT INSERT BLANK RECORDS.........
                if(String.isNotBlank(finEngResponseXml)) {
                    Attachment attRes = new Attachment();
                    attRes.ParentId = request.quoteId;
                    attRes.Body = Blob.valueOf(finEngResponseXml);
                    attRes.Name = 'FinEng Response';
                    try {
                        insert attRes;
                        response.responseXmlAttachmentId = attRes.Id;
                    } catch(Exception e) {
                        errorMessage = 'Error while creating quote attachment finEngResponseXml.xml: ' + e.getMessage();
                        isSuccess = false;
                    }
                }
            
            } else {
                if(String.isBlank(errorMessage)) {
                    errorMessage = 'request.quoteId is blank';
                } 
                isSuccess = false;
            }
        } else {
            errorMessage = 'request is null';
            isSuccess = false;
        }
        response.isSuccess = isSuccess;
        response.errorMessage = errorMessage;
        response.finEngResponse = HelixPPAFinEng.parseResponseXml(finEngResponseXml);

        if(!isSuccess) {
            try {
                createPPAQuoteException(request != null ? request.quoteId : null, 
                    request != null ? String.valueOf(request).left(32768) : null, 
                    response != null ? String.valueOf(response).left(32768) : null);
            } catch(Exception e) {
                System.debug('exception on exception log: ' + e);
            }
        }
        return response;
    }
    public class CalculateSavingsRequest {
        public String quoteId;
        public List <String> designIdList;
        public HelixPPAFinEng.Request finEngRequest;
    }
    public class CalculateSavingsResponse {
        public Boolean isSuccess;
        public Boolean customError;
        public String errorMessage;
        public String requestXmlAttachmentId;
        public String responseXmlAttachmentId;
        public CalculateSavingsRequest request;
        public HelixPPAFinEng.Response finEngResponse;  
        public HelixPPAUtil.EmailResponse emailResponse;      

        public CalculateSavingsResponse() {
            this.isSuccess = false;
        }
    }

    @future
    private static void createPPAQuoteException(Id quoteId, String request, String response) {
        if(String.isBlank(quoteId) || request == null || response == null) return;

        Exception_Log__c log = new Exception_Log__c(Quote__c = quoteId);
        log.Request_Message__c = request;
        log.Error_Message__c = response;
        insert log;
    }

//-----------------------------------------------------------------------------------
// View Proposal remote action
//-----------------------------------------------------------------------------------
    @RemoteAction
    public static HelixPPAUtil.SavePPAResponse viewProposal(HelixPPAUtil.SavePPARequest request) {
        HelixPPAUtil.SavePPAResponse response = new HelixPPAUtil.SavePPAResponse();

        return HelixPPAUtil.savePPA(request);
    }

//-----------------------------------------------------------------------------------
// View Design remote action
//-----------------------------------------------------------------------------------
    @RemoteAction
    public static HelixPPAUtil.SavePPAResponse viewDesign(HelixPPAUtil.SavePPARequest request) {
        HelixPPAUtil.SavePPAResponse response = new HelixPPAUtil.SavePPAResponse();

        return HelixPPAUtil.savePPA(request);
    }


//-----------------------------------------------------------------------------------
// Get Utility codes remote action
//-----------------------------------------------------------------------------------
    @RemoteAction
    public static List<Utility_Code__c> fetchUtilityCodes(String state) {
        
        if(String.isBlank(state)) return new List<Utility_Code__c>();

        return [SELECT External_Id__c, Utility_Name__c FROM Utility_Code__c WHERE State_Code__c =: state];
    }
    
//-----------------------------------------------------------------------------------
// private static methods
//-----------------------------------------------------------------------------------
    private static Quote getQuote(String quoteId) {
        Quote q = new Quote();    
        if (String.IsNotBlank(quoteId)) {
            List <Quote> qList = [SELECT Id, 
                    Credit_Rating__c,
                    Opportunity.Commercial_Operation_Date__c, 
                    Opportunity.Facility_State1__c,
                    Opportunity.Installation_Date__c,
                    Number_of_Sites__c,
                    System_Production_Year_1__c
                FROM Quote WHERE Id = :quoteId];
            if (qList.size() > 0) {
                q = qList[0];
            }
        }
        return q;    
    }
    
    private static User getUser(String userId) {
        User u = new User();
        if (String.IsNotBlank(userId)) {
            List <User> uList = [SELECT Id, Contact.AccountId, Contact.Account.Name FROM User WHERE Id = :userId];
            if (uList.size() > 0) {
                u = uList[0];
            }
        }
        return u;
    }
    
    private static List <Design__c> getDesignList(Set <String> designIdSet) {
        List <Design__c> designList = new List <Design__c>();    
        if (designIdSet != null && designIdSet.size() > 0) {
            designList = [SELECT Id, Name, 
                                 Dealer_Status__c, 
                                 HelixDesignType__c,
                                 Technology_System__c, 
                                 Cost_Matrix_Technology_System_Category__c,
                                 Site__r.Opportunity_del__r.Facility_State1__c,
                                 Roof_Design__r.id,
                                 ModuleTypeandWattage__c,
                                 Module_Quantity__c,
                                 Actual_Annual_Production__c,
                                 Actual_System_Size__c,
                                 Opportunity__r.Name,
                                 Opportunity__c,
                                 (Select Id, Design__c, RoofDesign__r.Design__c,
                                         Jan__c, Feb__c, Mar__c, Apr__c, 
                                         May__c, Jun__c, Jul__c, Aug__c, Sep__c, 
                                         Oct__c, Nov__c, Dec__c 
                                  FROM Energy_Productions_Year1__r
                                  ORDER BY LastModifiedDate DESC)            
                FROM Design__c WHERE Id IN :designIdSet];
    
        }
        return designList;
    }
    
    private static List <Cost_Matrix__c> getCostMatrixList(Set <String> stateSet) {
        List <Cost_Matrix__c> costMatrixList = new List <Cost_Matrix__c>();
        if (stateSet != null && stateSet.size() > 0) {
            costMatrixList = [SELECT Id, Name, Active__c, 
                    Available_Technology_Systems__c, 
                    Technology_Category_Bucket__c,
                    Technology_System_Category__c,
                    Total_Accounting_Misc_Cost__c,
                    Total_Labor_Cost__c,
                    Total_Material_Cost__c,
                    Sales_Configuration__r.System_Commissioning__c
                FROM Cost_Matrix__c WHERE State__c IN :stateSet AND Active__c = true AND Sales_Configuration__r.Active__c = true];
        }
        return costMatrixList;
    }
    
    private static Map <String, List <Cost_Matrix__c>> getTechSysCostMatrixMap(List <Cost_Matrix__c> costMatrixList) {
        Map <String, List <Cost_Matrix__c>> techSysCMMap = new Map <String, List <Cost_Matrix__c>>();
        if (costMatrixList != null) {
            for (Cost_Matrix__c cm : costMatrixList) {
                if (cm.Available_Technology_Systems__c != null) {
                    List <String> tsList = cm.Available_Technology_Systems__c.split(';'); 
                    for (String ts : tsList) {
                        List <Cost_Matrix__c> cmList = new List <Cost_Matrix__c>();
                        if (techSysCMMap.containsKey(ts)) {
                            cmList = techSysCMMap.get(ts);
                        }
                        cmList.add(cm);
                        techSysCMMap.put(ts, cmList);
                    }
                }
            }
        }
        return techSysCMMap;
    }
    
    private static Map <String, List <Cost_Matrix__c>> getDesignTypeCostMatrixMap(List <Cost_Matrix__c> costMatrixList) {
        Map <String, List <Cost_Matrix__c>> designTypeCMMap = new Map <String, List <Cost_Matrix__c>>();
        if (costMatrixList != null) {
            for (Cost_Matrix__c cm : costMatrixList) {
                if (cm.Technology_System_Category__c != null) {
                    List <Cost_Matrix__c> cmList = new List <Cost_Matrix__c>();
                    if (designTypeCMMap.containsKey(cm.Technology_System_Category__c)) {
                        cmList = designTypeCMMap.get(cm.Technology_System_Category__c);
                    }
                    cmList.add(cm);
                    designTypeCMMap.put(cm.Technology_System_Category__c, cmList);
                }
            }
        }
        return designTypeCMMap;
    }
    
    private static List <EnergyProductionYr1__c> getEnergyProductionsForRoofDesigns(Set <Id> roofDesignIdSet) {
        List <EnergyProductionYr1__c> epList = new List <EnergyProductionYr1__c>();
        if (roofDesignIdSet != null && roofDesignIdSet.size() > 0) {
            epList = [SELECT Id, Design__c, RoofDesign__r.Design__c,
                          Jan__c, Feb__c, Mar__c,
                          Apr__c, May__c, Jun__c,
                          Jul__c, Aug__c, Sep__c,
                          Oct__c, Nov__c, Dec__c
                       FROM EnergyProductionYr1__c
                       WHERE RoofDesign__c IN :roofDesignIdSet];                                                                        
        }
        return epList;    
    }
    
     private static Boolean isFilled(Decimal thisValue) {
        if(thisValue == null || thisValue == 0) return false;
        return true;
    }
}