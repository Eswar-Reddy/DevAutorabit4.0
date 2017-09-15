public class HelixPPADesignController {
    public static String roofDualTilt = 'Helix Roof Dual Tilt';
    public static String roofSingleTilt = 'Helix Roof Single Tilt';

    public Opportunity opportunity {get; private set;}
    public QuoteWrapper quoteWrpr {get; private set;}
    //kcm
    public boolean isNewUIUser {
        get {
            boolean isNewUIUser = false;
         
            if (SPCommunityUtility.isNewUIUser(UserInfo.getUserId())) { 
                isNewUIUser = true;
            }     
           
            return isNewUIUser;   
        }
        set;
    }
    
    public Boolean hasErrorMessages {
        get {
            return errorMessageList.size() > 0;
        } private set;
    }
    public String errorMsg {
        get {
            String errors;
            if (errorMessageList.size() > 0) {
                errors = String.join(errorMessageList, '\n');
            }
            return errors;
        }    
        private set;
    }
    // custom error messages. Apex.Message does not support clearing messages
    private static List <String> errorMessageList = new List <String>();
    public static String newUIPage {get; set;} //kcm
    
    public HelixPPADesignController() {
        // init
        opportunity = new Opportunity();
        
        String opptyId = ApexPages.currentPage().getParameters().get('opportunityId');
        String quoteId = ApexPages.currentPage().getParameters().get('quoteId');
        opportunity = getOpportunity(opptyId);
        if (String.IsNotBlank(quoteId)) {
            quoteWrpr = getQuoteWrapper(opptyId, quoteId);
        } else {
            quoteWrpr = getQuoteWrapper(opptyId);
        }
        
        PageReference pr = Page.SPCommunityCustomer;
        
        pr.setAnchor('/account/commercial/'+opportunity.AccountId+'/opportunity/'+opportunity.Id+'/quotes');
        newUIPage = pr.getURL();
    }
    
//-----------------------------------------------------------------------------------
// Save Design remote action
//-----------------------------------------------------------------------------------
    @RemoteAction
    public static SaveDesignResponse updateDesign(SaveDesignRequest request) {
        SaveDesignResponse response = new SaveDesignResponse();
        
        String errorMessage = '';
        if (request != null) {
            if (request.design != null) {
                if (request.design.Id != null) {
                    Savepoint sp = Database.setSavepoint();
                    
                    try {
                        update request.design;
                    } catch(Exception e) {
                        errorMessage = e.getMessage();
                    }
                     
                    if (request.quote != null && request.quote.Id != null) {
                        if (request.quoteFieldToNullList != null) {
                            try {
                                for (String fieldName : request.quoteFieldToNullList) {
                                    request.quote.put(fieldName, null);
                                }
                                update request.quote;
                            } catch(Exception e) {
                                errorMessage = e.getMessage();
                            }
                        }
                    }
        
                    if (String.IsNotBlank(errorMessage)) {
                        Database.rollback(sp);
                    } else {
                        response.design = getDesign(request.design.Id);

                        if(response.design.HelixDesignType__c != null && response.design.HelixDesignType__c == 'Helix Roof') {
                            if(response.design.Technology_System__c != null && response.design.Technology_System__c == Label.HelixDualTilt)
                                response.design.HelixDesignType__c = roofDualTilt;
                            else {
                                response.design.HelixDesignType__c = roofSingleTilt;
                                response.design.Technology_System__c = Label.HelixSingleTilt;
                            }
                        }
            
                        response.quote = getQuote(request.quote.Id);
                        response.isSuccess = true;
                    }
    
                } else {
                    errorMessage = 'request.design.Id is null'; 
                }
            } else {
                errorMessage = 'request.design is null';
            }
        } else {
            errorMessage = 'request is null';
        }
        response.errorMessage = errorMessage;
        return response;
    }
    public class SaveDesignRequest {
        public Design__c design;
        public Quote quote;
        public List <String> quoteFieldToNullList;
    }
    public class SaveDesignResponse {
        public Boolean isSuccess;
        public Design__c design;
        public Quote quote;
        public String errorMessage;
        public SaveDesignRequest request;
        public SaveDesignResponse() {
            this.isSuccess = false;
        }
    }
//-----------------------------------------------------------------------------------
// View Savings remote action
//-----------------------------------------------------------------------------------
    @RemoteAction
    public static ViewSavingsResponse viewSavings(ViewSavingsRequest request) {
        System.debug('request: ' + request);
        
        ViewSavingsResponse response = new ViewSavingsResponse();
        String errorMessage = '';

        if (request != null) {
            // validate selected designs
            if (request.bypassValidation == false) {
                ValidateDesignRequest designRequest = new ValidateDesignRequest();
                designRequest.designIdList = request.designIdList;
                ValidateDesignResponse designResponse = validateDesign(designRequest);
                if (designResponse.isSuccess == false) {
                    errorMessage = designResponse.errorMessage;
                }
                if (String.IsNotBlank(errorMessage)) {
                    response.errorMessage = errorMessage;
                    return response;
                }
            }
            
            // create/update quote
            if (request.quote != null) {
                Id partnerAccId = [SELECT Contact.AccountId FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1].Contact.AccountId;
                request.quote.Installer__c = partnerAccId;
                Savepoint sp = Database.setSavepoint();
                String quoteDesignRecordTypeId = getRecordTypeId('Quote_Design__c', 'Commercial');
                
                if (request.quoteFieldToNullList != null) {
                    try {
                        for (String fieldName : request.quoteFieldToNullList) {
                            request.quote.put(fieldName, null);
                        }
                    } catch(Exception e) {
                        errorMessage = e.getMessage();
                    }
                }
                
                if (request.quote.Id == null) {
                    // new quote
                    try {
                        insert request.quote;
                        response.quote = getQuote(request.quote.Id);
                    } catch(Exception e) {
                        errorMessage = e.getMessage();
                    }
                    // quote design
                    if (request.designIdList != null) {
                        List <Quote_Design__c> qdList = new List <Quote_Design__c>();
                        for (String designId : request.designIdList) {
                            qdList.add(new Quote_Design__c(Design__c = designId, Quote__c = response.quote.Id, RecordTypeId = quoteDesignRecordTypeId));
                        }
                        if (qdList.size() > 0) {
                            try {
                                insert qdList;
                            } catch(Exception e) {
                                errorMessage = e.getMessage();
                            }
                        } else {
                            //errorMessage = 'request.designIdList is empty';
                        }
                    } else {
                        errorMessage = 'request.designIdList is null';
                    }
                } else {
                    // update quote
                    try {
                        update request.quote;
                        response.quote = getQuote(request.quote.Id);
                    } catch(Exception e) {
                        errorMessage = e.getMessage();
                    }
                    // quote design. delete/create records
                    Set <String> existingDesignIdSet = new Set <String>();
                    Set <String> currentDesignIdSet = new Set <String>();
                    for (Quote_Design__c qd : [SELECT Id, Quote__c, Design__c FROM Quote_Design__c WHERE Quote__c = :request.quote.Id]) {
                        if (qd.Design__c != null) {
                            existingDesignIdSet.add(qd.Design__c);
                        }
                    }
                    
                    if (request.designIdList != null) {
                        if (request.designIdList.size() > 0) {
                            for (String designId : request.designIdList) {
                                currentDesignIdSet.add(designId);
                            }
                            Set <String> insertDesignIdSet = currentDesignIdSet.clone();
                            insertDesignIdSet.removeAll(existingDesignIdSet);
                            Set <String> deleteDesignIdSet = existingDesignIdSet.clone();
                            deleteDesignIdSet.removeAll(currentDesignIdSet);
                            if (insertDesignIdSet.size() > 0) {
                                List <Quote_Design__c> qdList = new List <Quote_Design__c>();
                                for (String designId : insertDesignIdSet) {
                                    qdList.add(new Quote_Design__c(Design__c = designId, Quote__c = response.quote.Id, RecordTypeId = quoteDesignRecordTypeId));
                                }
                                try {
                                    insert qdList;
                                } catch(Exception e) {
                                    errorMessage = e.getMessage();
                                }
                            }
                            if (deleteDesignIdSet.size() > 0) {
                                List <Quote_Design__c> qdList = [SELECT Id FROM Quote_Design__c WHERE Quote__c = :response.quote.Id AND Design__c IN :deleteDesignIdSet];
                                if (qdList.size() > 0) {
                                    try {
                                        delete qdList;
                                    } catch(Exception e) {
                                        errorMessage = e.getMessage();
                                    }
                                }
                            }
                        } else {
                            // no design selected. delete existing quote designs. this brach is reachable from design page
                            // on clicking save and quit after unselecting all designs
                            List <Quote_Design__c> qdList = [SELECT Id FROM Quote_Design__c WHERE Quote__c = :response.quote.Id];
                            if (qdList.size() > 0) {
                                try {
                                    delete qdList;
                                } catch(Exception e) {
                                    errorMessage = e.getMessage();
                                }
                            }
                        }
                    } else {
                        errorMessage = 'request.designIdList is null';
                    }
                }
                if (String.IsNotBlank(errorMessage)) {
                    Database.rollback(sp);
                } else {
                    response.isSuccess = true;
                }
            } else {
                errorMessage = 'request.quote is null';
            }
        } else {
            errorMessage = 'request is null';
        }
        
        response.errorMessage = errorMessage;
        return response;
    }
    public class ViewSavingsRequest {
        public Quote quote;
        public List <String> quoteFieldToNullList;
        public List <String> designIdList;
        public Boolean bypassValidation;
        public ViewSavingsRequest() {
            bypassValidation = false;
        }
    }
    public class ViewSavingsResponse {
        public Quote quote;
        public Boolean isSuccess;
        public String errorMessage;
        public ViewSavingsRequest request;
        public ViewSavingsResponse() {
            this.isSuccess = false;
        }
    }
    
//-----------------------------------------------------------------------------------
// Validate design
//-----------------------------------------------------------------------------------
    private static ValidateDesignResponse validateDesign(ValidateDesignRequest request) {
        ValidateDesignResponse response = new ValidateDesignResponse ();
        String errorMessage;

        if (request.designIdList != null) {
            if (request.designIdList.size() > 0) {
                Set <String> designIdSet = new Set <String>();
                for (String designId : request.designIdList) {
                    designIdSet.add(designId);
                }
                List <Design__c> designList = getDesignList(designIdSet);
                if (designList.size() > 0) {
                    List <Design__c> invalidDesignList = getInvalidDesignList(designList);
                    // send email
                    if (invalidDesignList.size() > 0) {
                        errorMessage = 'There is a problem with the technology system of this Helix Design Request. Our team has been notified and we will provide you with an update soon.';
                        response.emailResponse = HelixPPAUtil.sendDesignValidationEmail(invalidDesignList);
                    }
                }                    
            }
        }
        if (String.IsBlank(errorMessage)) {
            response.isSuccess = true;
        }

        response.errorMessage = errorMessage;
        return response;
    }
    
    private class ValidateDesignRequest {
        private List <String> designIdList;
    }
    private class ValidateDesignResponse {
        private Boolean isSuccess;
        private String errorMessage;
        private HelixPPAUtil.EmailResponse emailResponse;
        private ValidateDesignResponse() {
            this.isSuccess = false;
        }
    }    

//-----------------------------------------------------------------------------------
// Wrappers
//-----------------------------------------------------------------------------------
    private static QuoteWrapper getQuoteWrapper(String opptyId) {
        QuoteWrapper qw = new QuoteWrapper(getOpportunity(opptyId), new Quote());

        List <Site_Information_Form__c> siteList = getSiteList(opptyId);
        Set <String> siteIdSet = new Set <String>();
        for (Site_Information_Form__c site : siteList) {
            if (site.Site_State__c != null && site.Site_State__c == qw.opportunity.Facility_State1__c) {
                siteIdSet.add(site.Id);
                SiteWrapper sw = new SiteWrapper(site);
                qw.siteList.add(sw);
            }
        }
        Map <String, List <Design__c>> designMap = getDesignMap(siteIdSet);
        List <Design__c> includedDesignList = new List <Design__c>();
        List <Design__c> excludedDesignList = new List <Design__c>();
        for (SiteWrapper sw : qw.siteList) {
            if (designMap.containsKey(sw.site.Id)) {
                for (Design__c design : designMap.get(sw.site.Id)) {
                    if ((design.Design_Originated_by__c == 'Request' && design.Dealer_Status__c == 'Design Delivered' ||
                         design.Design_Originated_by__c == 'Indirect' && design.Dealer_Status__c == 'Design Exported') &&
                         design.ModuleTypeandWattage__c != null &&
                         design.Actual_System_Size__c != null &&
                         design.Actual_Annual_Production__c != null) {
                        sw.designList.add(new DesignWrapper(design));
                        includedDesignList.add(design);
                    } else {
                        excludedDesignList.add(design);
                    }
                }
            }
        }
        qw.nonCompatibleMessage = getNonCompatibleMessage(includedDesignList, excludedDesignList);
        
        return qw;
    }
    
    private static QuoteWrapper getQuoteWrapper(String opptyId, String quoteId) {
        QuoteWrapper qw = getQuoteWrapper(opptyId);
        if (String.IsNotBlank(quoteId)) {
            qw.quote = getQuote(quoteId);
            Set <String> selectedDesignIdSet = new Set <String>();
            for (Quote_Design__c qd : qw.quote.Quote_Designs__r) {
                if (qd.Design__c != null) {
                    selectedDesignIdSet.add(qd.Design__c);
                }
            }
            for (SiteWrapper sw : qw.siteList) {
                for (DesignWrapper dw : sw.designList) {
                    if (selectedDesignIdSet.contains(dw.design.Id)) {
                        dw.isSelected = true;
                    }
                }
            }
        }
        return qw;
    }
    
    private static Opportunity getOpportunity(String opptyId) {
        Opportunity oppty = new Opportunity();
        List <Opportunity> opptyList = [SELECT Id, AccountId, Name, Facility_State1__c 
            FROM Opportunity WHERE Id = :opptyId];
        if (opptyList.size() > 0) {
            oppty = opptyList[0];
        }
        return oppty;    
    }
    
    private static List<Site_Information_Form__c> getSiteList(String opptyId) {
        List <Site_Information_Form__c> siteList = new List <Site_Information_Form__c>();
        if (String.IsNotBlank(opptyId)) {
            siteList = [SELECT Id, Name, 
                    Site_Address__c,
                    Site_City__c,
                    Site_Country__c,
                    Site_Name__c,
                    Site_State__c,
                    Site_Zip_Postal_Code__c
                FROM Site_Information_Form__c WHERE Opportunity_del__c = :opptyId ORDER BY CreatedDate DESC];
        }
        return siteList;
    }

    private static List <Design__c> getDesignList(Set <String> designIdSet) {
        List <Design__c> designList = new List <Design__c>();
        if (designIdSet != null && designIdSet.size() > 0) {
            designList = [SELECT Id, Name, 
                    Cost_Matrix_Technology_System_Category__c,
                    Dealer_Status__c,
                    Design_Originated_by__c,
                    HelixDesignType__c, 
                    Opportunity__c,
                    Opportunity__r.Name, 
                    Opportunity__r.Facility_State1__c,
                    Technology_System__c 
                FROM Design__c WHERE Id IN :designIdSet];
        }
        return designList;
    }

    private static Design__c getDesign(String designId) {
        Design__c design = new Design__c();
        if (String.IsNotBlank(designId)) {
            List <Design__c> designList = [SELECT Id, Name,
                        Cost_Matrix_Technology_System_Category__c, 
                        Actual_Annual_Production__c,
                        Actual_System_Size__c,
                        DealerName__r.Name, 
                        Dealer_Status__c,
                        Design_Originated_by__c,
                        Design_Package_Type__c,
                        HelixDesignType__c,
                        ModuleTypeandWattage__c,
                        Opportunity__c,
                        Site__c, Technology_System__c 
                    FROM Design__c WHERE Id = :designId];
        
            if (designList.size() > 0) {
                design = designList[0];
            }
        }
        return design;
    }
    
    private static Map <String, List <Design__c>> getDesignMap(Set <String> siteIdSet) {
        Map <String, List <Design__c>> designMap = new Map <String, List <Design__c>>();
        if (siteIdSet != null && siteIdSet.size() > 0) {
            for (Design__c d : [SELECT Id, Name, Opportunity__r.Facility_State1__c,
                        Actual_Annual_Production__c,
                        Actual_System_Size__c,
                        Cost_Matrix_Technology_System_Category__c,
                        DealerName__r.Name, 
                        Dealer_Status__c,
                        Design_Originated_by__c,
                        Design_Package_Type__c,
                        HelixDesignType__c,
                        ModuleTypeandWattage__c,
                        Opportunity__c,
                        Site__c, Technology_System__c
                    FROM Design__c WHERE Site__c IN :siteIdSet AND Site__c != null ORDER BY CreatedDate DESC]) {
                List <Design__c> designList = new List <Design__c>();
                if (designMap.containsKey(d.Site__c)) {
                    designList = designMap.get(d.Site__c);
                }
                designList.add(d);
                designMap.put(d.Site__c, designList);
            }
        }
        return designMap;
    }
    
    private static Quote getQuote(String quoteId) {
        Quote q = new Quote();
        if (String.IsNotBlank(quoteId)) {
            List <Quote> qList = [SELECT Id, Name,
                    Annual_Bill__c,
                    AccountId,
                    OpportunityId,
                    Annual_Usage__c,
                    Avoided_Cost_of_Power__c,
                    Credit_Rating__c,
                    Dealer_Fees__c,
                    Escalator__c,
                    Incentives_detail_1__c, 
                    Incentives_detail_1_amt__c,
                    ITC_Ineligible_Cost__c,
                    Loan_Term__c,
                    Number_of_Sites__c,
                    PBI_Amount__c,
                    PBI_Term__c,
                    QuoteNumber, 
                    QuoteType__c,
                    Opportunity.Facility_State1__c,
                    Sector__c,
                    SREC_Indicator__c,
                    Total_Dealer_Fee__c,
                    Utility_Bill_Annual_Escalation__c,
                    Utility_Distributor__c,
                    Utility_Rate_Code__c,
                    Year_1_PPA_Price__c,
                    Year_1_Savings__c,
                    (SELECT Id, Name,
                            Design__c,
                            Design__r.Name,
                            Design__r.Actual_Annual_Production__c,
                            Design__r.Actual_System_Size__c,
                            Design__r.Dealer_Status__c,
                            Design__r.Design_Originated_by__c,
                            Design__r.Design_Package_Type__c,
                            Design__r.HelixDesignType__c,
                            Design__r.ModuleTypeandWattage__c,
                            Design__r.Site__c,
                            Design__r.Opportunity__r.Facility_State1__c,
                            Design__r.DealerName__r.Name,
                            Design__r.Technology_System__c 
                        FROM Quote_Designs__r),
                    (SELECT Id, Name, 
                        Annual_Base__c,
                        Guaranteed_Energy_Price_per_KWH__c,
                        Net_Savings_NPV_3__c,
                        Net_Savings_NPV_5__c,
                        Net_Savings_NPV_8__c,
                        PPA_Payment__c,
                        Response_Line_Type__c,
                        Row_Number__c,
                        Utility_Bill_Savings__c
                    FROM Annual_Financials__r) 
                FROM Quote WHERE Id = :quoteId];
            if (qList.size() > 0) {
                q = qList[0];
            }
        }
        return q;
    }
    
    private static String getRecordTypeId(String objectName, String recordTypeName) {
        String recordTypeId;
        If (String.IsNotBlank(objectName) && String.IsNotBlank(recordTypeName)) {
            List <RecordType> rtList = [SELECT Id FROM RecordType WHERE SObjectType = :objectName AND DeveloperName = :recordTypeName];
            if (rtList.size() > 0) {
                recordTypeId = rtList[0].Id;
            }
        }
        return recordTypeId;
    }

    private static transient Set<String> tempTechSystems {get;set;}
    private static Set<String> getTechSystems(String state) {
        if(tempTechSystems != null && !tempTechSystems.isEmpty()) return tempTechSystems;

        tempTechSystems = new Set<String>();

        for(Cost_Matrix__c m : [SELECT Technology_System_Category__c FROM Cost_Matrix__c
                                WHERE Active__c = true
                                AND Sales_Configuration__r.Active__c = TRUE 
                                AND State__c =: state]) {
            tempTechSystems.add(m.Technology_System_Category__c);
        }
        return tempTechSystems;
    }

    private static HelixPPAPickList getFilteredPicklist(HelixPPAPickList originalList, String oppState) {
        Set<String> systems = getTechSystems(oppState);
        List<HelixPPAPicklist.PicklistOption> newOptions = new List<HelixPPAPicklist.PicklistOption>();
        for(HelixPPAPicklist.PicklistOption ps : originalList.options) {
            for(String s : systems) {
                if(s == ps.label) {
                    newOptions.add(new HelixPPAPicklist.PicklistOption(s,s));
                }
            }
        }
        if(newOptions.size() > 0) newOptions.add(0,new HelixPPAPickList.PicklistOption(roofSingleTilt, roofSingleTilt));
        else newOptions.add(new HelixPPAPickList.PicklistOption(roofSingleTilt, roofSingleTilt));
        newOptions.add(0,new HelixPPAPickList.PicklistOption(roofDualTilt, roofDualTilt));
        originalList.options = newOptions;
        return originalList;
    }

    private static Map <String, List <String>> getCategorySystemsMap(String state) {
        Map <String, List <String>> categorySystemsMap = new Map <String, List <String>>();
        if (String.IsNotBlank(state)) {
            for (Cost_Matrix__c cm : [SELECT Id, Name, Active__c, 
                    Available_Technology_Systems__c, 
                    Technology_System_Category__c
                FROM Cost_Matrix__c WHERE State__c = :state AND Active__c = true AND Sales_Configuration__r.Active__c = true]) {
                
                if (cm.Technology_System_Category__c != null && cm.Available_Technology_Systems__c != null) {
                    List <String> systems = new List <String>();
                    if (categorySystemsMap.containsKey(cm.Technology_System_Category__c)) {
                        systems = categorySystemsMap.get(cm.Technology_System_Category__c);
                    }
                    for (String sys : cm.Available_Technology_Systems__c.split(';')) {
                        systems.add(sys);
                    }
                    categorySystemsMap.put(cm.Technology_System_Category__c, systems);
                }        
            }
        }
        return categorySystemsMap;
    }

    private static List <Design__c> getInvalidDesignList(List <Design__c> designList) {
        List <Design__c> invalidDesignList = new List <Design__c>();

        if (designList.size() > 0) {
            // verify invalid design type
            HelixPPAPickList systemPicklist = getFilteredPicklist(new HelixPPAPickList('Design__c', 'HelixDesignType__c', null), designList[0].Opportunity__r.Facility_State1__c);
            systemPicklist.options.add(0,new HelixPPAPickList.PicklistOption('Helix Roof', 'Helix Roof'));
            Set <String> invalidDesignIdSet = new Set <String>();    // to avoid adding dupes into list
            for (Design__c design : designList) {
                if (design.Design_Originated_by__c == 'Indirect' && design.Dealer_Status__c == 'Design Exported') {
                    continue;
                }
                Boolean isDesignTypeValid = false;
                for (HelixPPAPickList.PicklistOption option : systemPicklist.options) {
                    if (design.HelixDesignType__c == option.value) {
                        isDesignTypeValid = true;
                        break;
                    }
                }
                if (isDesignTypeValid == false) {
                    if (invalidDesignIdSet.add(design.Id)) {
                        invalidDesignList.add(design);
                    }
                }
            }
            // verify invalid technological systems
            Map <String, List <String>> categorySystemsMap = getCategorySystemsMap(designList[0].Opportunity__r.Facility_State1__c);
            for (Design__c design : designList) {
                if (design.Design_Originated_by__c == 'Indirect' && design.Dealer_Status__c == 'Design Exported') {
                    continue;
                }
                Boolean isTechSysValid = false;
                if (design.HelixDesignType__c != null && categorySystemsMap.containsKey(design.Cost_Matrix_Technology_System_Category__c)) {
                    for (String sys : categorySystemsMap.get(design.Cost_Matrix_Technology_System_Category__c)) {
                        if (design.Technology_System__c == sys) {
                            isTechSysValid = true;
                            break;
                        }
                    }
                }
                if (isTechSysValid == false) {
                    if (invalidDesignIdSet.add(design.Id)) {
                        invalidDesignList.add(design);
                    }
                }
            }
        }

        return invalidDesignList;    
    }
    
    private static String getNonCompatibleMessage(List <Design__c> includedDesignList, List <Design__c> excludedDesignList) {
        String msg;
                
        List <Design__c> invalidDesignList = getInvalidDesignList(includedDesignList);
        List <Design__c> nonCompatibleDesignList = new List <Design__c>();
        List <Design__c> nonDeliveredDesigns_list = new List<Design__c>();
        
        //nonCompatibleDesignList.addAll(invalidDesignList);
        //nonCompatibleDesignList.addAll(excludedDesignList);
        
        for (Design__c d:invalidDesignList) {
            if (d.Dealer_Status__c != 'Design Delivered'){
                nonDeliveredDesigns_list.add(d);
            } else {
                nonCompatibleDesignList.add(d);
            }
        }
        
        for (Design__c d:excludedDesignList) {
            if (d.Dealer_Status__c != 'Design Delivered'){
                nonDeliveredDesigns_list.add(d);
            } else {
                nonCompatibleDesignList.add(d);
            }
        }
        
        if(nonDeliveredDesigns_list.size() > 0) {
            msg = nonDeliveredDesigns_list.size() == 1 ? 'The design ' : 'The designs ';
            
            List <String> names = new List <String>();
            
            for (Design__c design : nonDelivereddesigns_list) {
                names.add(design.Name); 
            }
            
            names.sort();
            msg += String.join(names, ',');
            msg += nonDeliveredDesigns_list.size() == 1 ? ' is ' : ' are ';
            msg += 'not available for PPA quotes because ';
            msg += nonDeliveredDesigns_list.size() == 1 ? 'it is not delivered yet.  ' : 'they are not delivered yet.  ';
        }
        
        if (nonCompatibleDesignList.size() > 0) {
            if(msg == null || String.isBlank(msg)) {
                msg = nonCompatibleDesignList.size() == 1 ? 'The design ' : 'The designs ';
            } else {
                msg += nonCompatibleDesignList.size() == 1 ? 'The design ' : 'The designs ';
            }
            
            List <String> names = new List <String>();
            for (Design__c design : nonCompatibleDesignList) {
                names.add(design.Name); 
            }
            names.sort();
            msg += String.join(names, ',');
            msg += nonCompatibleDesignList.size() == 1 ? ' is ' : ' are ';
            msg += 'not available for PPA quotes because of module or technology system compatibility';            
        }
        
        return msg;
    }
    
    public class QuoteWrapper {
        public Opportunity opportunity {get; private set;}
        public Quote quote {get; private set;}
        public String recordTypeId {get; private set;}
        public Decimal sizeKW {get {return getSizeKW();} private set;}
        public Integer production {get {return getProduction();} private set;}
        public Decimal utilityBillPostSolar {get {return getUtilityBillPostSolar();} private set;}
        public Decimal year1NetSavings {get {return getYear1NetSavings();} private set;}
        public Decimal sumNetSavings {get {return getSumNetSavings();} private set;}
        public Decimal npvOfSavings {get {return getNpvOfSavings();} private set;}
        public List <SiteWrapper> siteList {get; private set;}
        public String nonCompatibleMessage {get; private set;}
        public QuoteWrapper(Opportunity opportunity, Quote quote) {
            this.opportunity = opportunity;
            this.quote = quote;
            this.recordTypeId = getRecordTypeId('Quote', 'Commercial_Quote');
            this.siteList = new List <SiteWrapper>();
            if (quote.Id == null) {
                quote.Name = opportunity.Name;
            }
        }
        private Decimal getSizeKW() {
            Decimal retValue = 0;
            for (SiteWrapper w : this.siteList) {
                if (w.sizeKW != null) {
                    retValue = retValue + w.sizeKW;
                }
            }
            return retValue;
        }
        private Integer getProduction() {
            Integer retValue = 0;
            for (SiteWrapper w : this.siteList) {
                if (w.production != null) {
                    retValue = retValue + w.production;
                }
            }
            return retValue;
        }
        private Decimal getUtilityBillPostSolar() {
            Decimal year1UBS = 0;
            for (Annual_Financial__c af : quote.Annual_Financials__r) {
                if (af.Response_Line_Type__c == 'PPA Rate' && af.Row_Number__c == 1) {
                    if (af.Utility_Bill_Savings__c != null) {
                        year1UBS = af.Utility_Bill_Savings__c;
                        break;
                    }
                }
            }
            Decimal annualBill = quote.Annual_Bill__c != null ? quote.Annual_Bill__c : 0;
            return annualBill - year1UBS;
        }
        private Decimal getYear1NetSavings() {
            Decimal retValue = 0;
            for (Annual_Financial__c af : quote.Annual_Financials__r) {
                if (af.Response_Line_Type__c == 'PPA Rate' && af.Row_Number__c == 1) {
                    if (af.Annual_Base__c != null) {
                        retValue = af.Annual_Base__c;
                        break;
                    }
                }
            }
            return retValue;
        }
        private Decimal getSumNetSavings() {
            Decimal retValue = 0;
            for (Annual_Financial__c af : quote.Annual_Financials__r) {
                if (af.Response_Line_Type__c == 'PPA Rate') {
                    if (af.Annual_Base__c != null) {
                        retValue = retValue + af.Annual_Base__c;
                    }
                }
            }
            return retValue;
        }
        private Decimal getNpvOfSavings() {
            Decimal retValue = 0;
            for (Annual_Financial__c af : quote.Annual_Financials__r) {
                if (af.Response_Line_Type__c == 'NPV') {
                    if (af.Net_Savings_NPV_5__c != null) {
                        retValue = af.Net_Savings_NPV_5__c;
                        break;
                    }
                }
            }
            return retValue;
        }
    }
    public class SiteWrapper {
        public Site_Information_Form__c site {get; private set;}
        public String siteAddress {get; private set;}
        public Decimal sizeKW {get {return getSizeKW();} private set;}
        public Integer production {get {return getProduction();} private set;}
        public List <DesignWrapper> designList {get; private set;}
        public SiteWrapper(Site_Information_Form__c site) {
            this.site = site;
            this.designList = new List <DesignWrapper>();
            this.siteAddress = site.Site_Address__c + ',' + site.Site_City__c + ',' + site.Site_State__c;
        }
        private Decimal getSizeKW() {
            Decimal retValue = 0;
            for (DesignWrapper w : this.designList) {
                if (w.sizeKW != null) {
                    retValue = retValue + w.sizeKW;
                }
            }
            return retValue;
        }
        private Integer getProduction() {
            Integer retValue = 0;
            for (DesignWrapper w : this.designList) {
                if (w.production != null) {
                    retValue = retValue + w.production;
                }
            }
            return retValue;
        }
    }
    public class DesignWrapper {
        public Design__c design {get; private set;}
        public Decimal sizeKW {get; private set;}
        public Integer production {get; private set;}
        public String productionFormatted {get; private set;}
        public String designedBy {get; private set;}
        public Boolean isSelected {get; set;}
        public HelixPPAPickList systemPicklist {get; private set;}
        public DesignWrapper(Design__c design) {
            this.design = design;
            this.isSelected = false;
            this.systemPicklist = getFilteredPicklist(new HelixPPAPickList('Design__c', 'HelixDesignType__c', design.HelixDesignType__c), design.Opportunity__r.Facility_State1__c);
            if (design.Actual_System_Size__c != null) {
                sizeKW = design.Actual_System_Size__c;
            }
            if (design.Actual_Annual_Production__c != null) {
                production = Integer.valueOf(design.Actual_Annual_Production__c);
                List<String> args = new String[]{'0','number','###,###,###,##0'};
                productionFormatted = String.format(production.format(), args);
            }
            if (design.Design_Originated_By__c == 'Request' || design.Design_Originated_by__c == 'Direct') {
                designedBy = 'SunPower';
            } else {
                designedBy = design.DealerName__r.Name;
            }
            if(design.HelixDesignType__c != null && design.HelixDesignType__c == 'Helix Roof') {
                if(design.Technology_System__c != null && design.Technology_System__c == Label.HelixDualTilt)
                    design.HelixDesignType__c = roofDualTilt;
                else {
                    design.HelixDesignType__c = roofSingleTilt;
                    design.Technology_System__c = Label.HelixSingleTilt;
                }
            }

        }
    }
}