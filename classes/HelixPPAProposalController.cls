public class HelixPPAProposalController {
    public String newUIPage {get; set;} //kcm
    public String accountId {get; set;} //kcm
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

    public HelixPPAProposalController() {
        //kcm
        String oppId = ApexPages.currentPage().getParameters().get('opportunityId');
        if (String.IsNotBlank(oppId)) {
            List <Opportunity> oppList = [SELECT AccountId FROM Opportunity WHERE Id =: oppId LIMIT 1];
            if (oppList.size() > 0) {
                accountId = oppList[0].AccountId;
            }
        }

        PageReference pr = Page.SPCommunityCustomer;
        pr.setAnchor('/account/commercial/');
        
        newUIPage = pr.getURL();
    } 

//-----------------------------------------------------------------------------------
// Save Proposal remote action
//-----------------------------------------------------------------------------------
    @RemoteAction
    public static SaveProposalResponse saveProposal(SaveProposalRequest request) {
        SaveProposalResponse response = new SaveProposalResponse();
        
        String errorMessage = '';
        if (request != null) {
            response.isSuccess = true;
        }
        response.errorMessage = errorMessage;
        return response;
    }
    public class SaveProposalRequest {
    }
    public class SaveProposalResponse {
        public Boolean isSuccess;
        public String errorMessage;
        public SaveProposalRequest request;
        public SaveProposalResponse() {
            this.isSuccess = false;
        }
    }
    
//-----------------------------------------------------------------------------------
// Download TermSheet remote action
//-----------------------------------------------------------------------------------
    @RemoteAction
    public static DownloadTermSheetResponse downloadTermSheet(DownloadTermSheetRequest request) {
        DownloadTermSheetResponse response = new DownloadTermSheetResponse();
        
        String errorMessage = '';
        List <SpectrumDebugUtility.debugLog> logs = new List <SpectrumDebugUtility.debugLog>();

        if (request != null) {
            List <DocGen_Mapping__mdt> mList = getDocGenMappingList('Helix PPA Term Sheet');
            Quote q = getQuote(request.quoteId, mList);
            String siteAddresses = getSiteAddresses(q);
            
            // prepare data for json generator
            HelixPPADocGen.Request docgenRequest = new HelixPPADocGen.Request();
            docgenRequest.apiKey = 'DC97-20AF-567E';
            docgenRequest.sector = null;
            docgenRequest.templateName = '';
            docgenRequest.fileType = null;
            docgenRequest.watermark = 'off';
                
            // name value pairs
            for (DocGen_Mapping__mdt m : mList) {
                if (m.sObject_API_Name__c == 'Quote') {            
                    if (m.Field_API_Name__c != null) {
                        docgenRequest.nameValuePairs.add(new HelixPPADocGen.NameValuePair(m.Token_Name__c, getField(q, m.Field_API_Name__c), m.Field_Type__c, m.Field_Format__c));
                    }
                } else if (m.Type__c == 'CurrentDate') {
                    docgenRequest.nameValuePairs.add(new HelixPPADocGen.NameValuePair(m.Token_Name__c, System.now().format(m.Field_Format__c), 'String'));
                } else if (m.Type__c == 'RuleFilter') {
                    docgenRequest.nameValuePairs.add(new HelixPPADocGen.NameValuePair(m.Token_Name__c, m.Token_Value__c, 'String'));
                }
            }
            docgenRequest.nameValuePairs.add(new HelixPPADocGen.NameValuePair('listOfSiteAddressesSelected', siteAddresses, 'String'));
            
            // this call gets the json generator with above data loaded
            HelixPPADocGen.Response docGenResponse = HelixPPADocGen.getResponse(docgenRequest);
            
            if (String.IsBlank(errorMessage)) {  
                // this call gets http response from docgen server
                HelixPPADocGenHandler.Request handlerRequest = new HelixPPADocGenHandler.Request();
                handlerRequest.jsonGenerator = docGenResponse.jsonGenerator;
                HelixPPADocGenHandler.Response handlerResponse = HelixPPADocGenHandler.callDocGen(handlerRequest);
                
                // if there is error html body is returned 
                String resAttName;
                if (handlerResponse.isSuccess) {
                    resAttName = 'DocGen TermSheet.pdf';
                } else {
                    resAttName = 'DocGen Response.html';
                    errorMessage = handlerResponse.errorMessage;
                    logs.add(prepDebugLog(request.quoteId, 'HelixPPADocGenHandler-TermSheet', handlerResponse.httpRequest, handlerResponse.httpResponse));
                } 
                // create quote attachments request and response
                Attachment attReq = new Attachment();
                attReq.ParentId = request.quoteId;
                attReq.Body = Blob.valueOf(docGenResponse.jsonGenerator.getAsString());
                attReq.Name = 'DocGen Request.json';
                try {
                    insert attReq;
                    response.requestAttachmentId = attReq.Id;
                } catch(Exception e) {
                    errorMessage = 'Error while creating quote attachment DocGen Request: ' + e.getMessage();
                }
    
                if (handlerResponse.httpResponse != null) {
                    try {
                        Attachment attDoc = new Attachment();
                        attDoc.ParentId = request.quoteId;
                        attDoc.Body = handlerResponse.httpResponse.getBodyAsBlob();
                        attDoc.Name = resAttName;
                        insert attDoc;
                        response.responseAttachmentId = attDoc.Id;
                    } catch(Exception e) {
                        errorMessage = 'Error while creating quote attachment ' + resAttName + ': ' + e.getMessage();
                    }
                    try {
                        q.Term_Sheet__c = true;
                        q.Term_Sheet_Generated_Date__c = system.now();
                        update q;                        
                    } catch(Exception e) {
                        errorMessage = 'Error while updating quote : ' + e.getMessage();
                    }
                }
                         
            }
        } else {
            errorMessage = 'request is null';
        }

        if (String.IsBlank(errorMessage)) {            
            response.isSuccess = true;
        }

        // spectrum debug log
        if (logs.size() > 0) {
            SpectrumDebugUtility.generateDebugLog(logs);
        }

        response.errorMessage = errorMessage;
        return response;
    }
    public class DownloadTermSheetRequest {
        public String quoteId;
    }
    public class DownloadTermSheetResponse {
        public String requestAttachmentId;
        public String responseAttachmentId;
        public Boolean isSuccess;
        public String errorMessage;
        public DownloadTermSheetRequest request;
        public DownloadTermSheetResponse() {
            this.isSuccess = false;
        }
    }
    
//-----------------------------------------------------------------------------------
// Download Proposal remote action
//-----------------------------------------------------------------------------------
    @RemoteAction
    public static DownloadProposalResponse downloadProposal(DownloadProposalRequest request) {
        DownloadProposalResponse response = new DownloadProposalResponse();
        
        String errorMessage = '';
        List <SpectrumDebugUtility.debugLog> logs = new List <SpectrumDebugUtility.debugLog>();

        if (request != null) {
            List <DocGen_Mapping__mdt> mList = getDocGenMappingList('Commercial PPA Proposal');
            Quote q = getQuote(request.quoteId, mList);
            User u = getUser(UserInfo.getUserId());            
            String siteAddresses = getSiteAddresses(q);
            
            // prepare data for json generator
            HelixPPADocGen.Request docgenRequest = new HelixPPADocGen.Request();
            docgenRequest.apiKey = 'DC97-20AF-567E';
            docgenRequest.sector = null;
            docgenRequest.templateName = '';
            docgenRequest.fileType = 'word';
            docgenRequest.watermark = 'off';
                
            // name value pairs
            for (DocGen_Mapping__mdt m : mList) {
                if (m.sObject_API_Name__c == 'Quote') {            
                    if (m.Field_API_Name__c != null) {
                        docgenRequest.nameValuePairs.add(new HelixPPADocGen.NameValuePair(m.Token_Name__c, getField(q, m.Field_API_Name__c), m.Field_Type__c, m.Field_Format__c));
                    }
                } else if (m.Type__c == 'CurrentDate') {
                    docgenRequest.nameValuePairs.add(new HelixPPADocGen.NameValuePair(m.Token_Name__c, System.now().format(m.Field_Format__c), 'String'));
                } else if (m.Type__c == 'RuleFilter') {
                    docgenRequest.nameValuePairs.add(new HelixPPADocGen.NameValuePair(m.Token_Name__c, m.Token_Value__c, 'String'));
                }
            }                             
               
            if (u != null) {
                docgenRequest.nameValuePairs.add(new HelixPPADocGen.NameValuePair('salesPersonName', u.Name, 'String'));
                docgenRequest.nameValuePairs.add(new HelixPPADocGen.NameValuePair('salesPersonEmail', u.Email, 'String'));
                
                if (u.Contact.Account.Dealer_Locator_Phone__c != null) {
                    docgenRequest.nameValuePairs.add(new HelixPPADocGen.NameValuePair('salesPersonPhone', u.Contact.Account.Dealer_Locator_Phone__c, 'String')); 
                } else if (u.Contact.Account.Phone != null) {
                    docgenRequest.nameValuePairs.add(new HelixPPADocGen.NameValuePair('salesPersonPhone', u.Contact.Account.Phone, 'String'));
                } else {
                    docgenRequest.nameValuePairs.add(new HelixPPADocGen.NameValuePair('salesPersonPhone', u.Phone, 'String'));
                }                       
            }         
                        
            //panelcount of all designs
            integer panelCount = 0;
            
            for (Quote_Design__c qd:q.Quote_Designs__r) {
                panelCount += (Integer) qd.Design__r.Module_Quantity__c;
            }
            
            docgenRequest.nameValuePairs.add(new HelixPPADocGen.NameValuePair('panelCount', HelixPPADocGen.formatNumber(panelCount, 0), 'String'));            
            
            //{solarPanelSeries} from first design
            HelixPPADocGen.DynamicTableColumn column = new HelixPPADocGen.DynamicTableColumn(new List<String>{'designName', 'moduleq','moduletype','designtype'});
            HelixPPADocGen.DynamicTable designTable = new  HelixPPADocGen.DynamicTable(column.columnTokenNames);
            designTable.tableKey = 'DesignTable';
            designTable.dynamicTableColumn = column;
            if (q.Quote_Designs__r.size() > 0) {
                for(Quote_Design__c d : q.Quote_Designs__r) {
                    List<String> values = new List<String>();
                    values.add(d.Design__r.Name);
                    values.add(d.Design__r.Module_Quantity__c == null ? '0' : String.valueOf(d.Design__r.Module_Quantity__c));
                    values.add(d.Design__r.ModuleTypeandWattage__c == null ? '' : d.Design__r.ModuleTypeandWattage__c);
                    values.add(d.Design__r.HelixDesignType__c == null ? '' : d.Design__r.HelixDesignType__c);
                    HelixPPADocGen.DynamicTableRow row = new HelixPPADocGen.DynamicTableRow(values);
                    designTable.rowValues.add(row);
                }
            }
            docgenRequest.dynamicTables.add(designTable);
            
            //bill 20 years without solar
            Decimal escalatedBill = q.Annual_Bill__c != null ? q.Annual_Bill__c : 0;
            Decimal bill20yrs_wo_solar = escalatedBill;
            
            for (integer i = 0; i < 19; i++) {
                escalatedBill = (escalatedBill * (1 + q.Utility_Bill_Annual_Escalation__c != null ? q.Utility_Bill_Annual_Escalation__c : 0) / 100) + escalatedBill;
                bill20yrs_wo_solar += escalatedBill ;
            }
            
            docgenRequest.nameValuePairs.add(new HelixPPADocGen.NameValuePair('electricBillWithoutSolar', HelixPPADocGen.formatNumber(bill20yrs_wo_solar.setScale(0), 0), 'String')); 
            
            //net savings 
            Decimal savings20yrs_w_solar = 0,
                    netSavings20 = 0,
                    netSavings_NPV8 = 0,
                    netSavings_NPV5 = 0,
                    netSavings_NPV3 = 0;
                    
            for (Annual_Financial__c af: q.Annual_Financials__r) {
                if (af.Response_Line_Type__c == 'PPA Rate') {
                    savings20yrs_w_solar += af.Utility_Bill_Savings__c;   
                    netSavings20 += af.Annual_Base__c;                 
                } else if (af.Response_Line_Type__c == 'NPV') {
                    netSavings_NPV3 = af.Net_Savings_NPV_3__c!=null?netSavings_NPV3 + af.Net_Savings_NPV_3__c: netSavings_NPV3 + 0;
                    netSavings_NPV8 = af.Net_Savings_NPV_8__c!=null?netSavings_NPV8 + af.Net_Savings_NPV_8__c: netSavings_NPV8 + 0;
                    netSavings_NPV5 = af.Net_Savings_NPV_5__c!=null?netSavings_NPV5 + af.Net_Savings_NPV_5__c: netSavings_NPV5 + 0;
                }
            }   
            //bill with solar 
            docgenRequest.nameValuePairs.add(new HelixPPADocGen.NameValuePair('electricBillWithSolar', HelixPPADocGen.formatNumber((bill20yrs_wo_solar - savings20yrs_w_solar).setScale(0), 0), 'String')); 
            
            //total 20 year gross savings
            docgenRequest.nameValuePairs.add(new HelixPPADocGen.NameValuePair('electricBillSavingsPerMonth', HelixPPADocGen.formatNumber(savings20yrs_w_solar.setScale(0), 0), 'String'));
            
            docgenRequest.nameValuePairs.add(new HelixPPADocGen.NameValuePair('NPVValue5', HelixPPADocGen.formatNumber(netSavings_NPV5.setScale(0), 0), 'String'));
            
            //net savings
            docgenRequest.nameValuePairs.add(new HelixPPADocGen.NameValuePair('savings20Years', HelixPPADocGen.formatNumber(netSavings20.setScale(0), 0), 'String'));
            
            docgenRequest.nameValuePairs.add(new HelixPPADocGen.NameValuePair('NPVValue3', HelixPPADocGen.formatNumber(netSavings_NPV3.setScale(0), 0), 'String'));
            docgenRequest.nameValuePairs.add(new HelixPPADocGen.NameValuePair('NPVValue8', HelixPPADocGen.formatNumber(netSavings_NPV8.setScale(0), 0), 'String'));
            
            
            //ring charts
            docgenRequest.ringChartList = new List<HelixPPADocGen.ringChart>();
                       
            docgenRequest.ringChartList.add(new HelixPPADocGen.ringChart('productionUsageRing', (Integer) q.System_Production_Year_1__c, (Integer) q.Annual_Usage__c));
            docgenRequest.ringChartList.add(new HelixPPADocGen.ringChart('billOffsetRing', (Integer) savings20yrs_w_solar, (Integer) bill20yrs_wo_solar));
                         
                         
            //bar charts
            docgenRequest.barChartList = new List<HelixPPADocGen.barChart>();
            
            //building the dataSet for 'netSavings'            
            List<HelixPPADocGen.barChart_DataSet_SeriesList> netSavingsSeriesList;            
            List<HelixPPADocGen.barChartDataSet> netSavingsDataSet = new List<HelixPPADocGen.barChartDataSet>();
            
            for (Annual_Financial__c af: q.Annual_Financials__r) {
                if(af.Response_Line_Type__c == 'PPA Rate') {
                    netSavingsSeriesList = new List<HelixPPADocGen.barChart_DataSet_SeriesList>();
                    
                    //build seriesList for 'netSavings'
                    netSavingsSeriesList.add(new HelixPPADocGen.barChart_DataSet_SeriesList('', 'PPA Payments', 1, af.PPA_Payment__c, ''));
                    netSavingsSeriesList.add(new HelixPPADocGen.barChart_DataSet_SeriesList('', 'Utility Bill Savings', 2, af.Utility_Bill_Savings__c, ''));
                
                    //then build actual dataSet for 'netSavings'
                    netSavingsDataSet.add(new HelixPPADocGen.barChartDataSet(af.Row_Number__c, String.ValueOf(af.Row_Number__c), netSavingsSeriesList ));
                } 
            }
            docgenRequest.barChartList.add(new HelixPPADocGen.barChart('netSavings', netSavingsDataSet));
            System.debug('Heap Size: ' + Limits.getHeapSize());   
                         
            // this call gets the json generator with above data loaded
            HelixPPADocGen.Response docGenResponse = HelixPPADocGen.getResponse(docgenRequest);
            
            if (String.IsBlank(errorMessage)) {  
                // this call gets http response from docgen server
                HelixPPADocGenHandler.Request handlerRequest = new HelixPPADocGenHandler.Request();
                handlerRequest.jsonGenerator = docGenResponse.jsonGenerator;
                HelixPPADocGenHandler.Response handlerResponse = HelixPPADocGenHandler.callDocGen(handlerRequest);
                
                // if there is error html body is returned 
                String resAttName;
                if (handlerResponse.isSuccess) {
                    resAttName = 'Commercial PPA Proposal.docx';
                } else {
                    resAttName = 'DocGen Response - Proposal.html';
                    errorMessage = handlerResponse.errorMessage;
                    logs.add(prepDebugLog(request.quoteId, 'HelixPPADocGenHandler-Proposal', handlerResponse.httpRequest, handlerResponse.httpResponse));
                } 
                // create quote attachments request and response
                Attachment attReq = new Attachment();
                attReq.ParentId = request.quoteId;
                attReq.Body = Blob.valueOf(docGenResponse.jsonGenerator.getAsString());
                attReq.Name = 'DocGen Request - Proposal.json';
                try {
                    insert attReq;
                    response.requestAttachmentId = attReq.Id;
                } catch(Exception e) {
                    errorMessage = 'Error while creating quote attachment DocGen Request - Proposal: ' + e.getMessage();
                }
    
                if (handlerResponse.httpResponse != null) {
                    try {
                        Attachment attDoc = new Attachment();
                        attDoc.ParentId = request.quoteId;
                        attDoc.Body = handlerResponse.httpResponse.getBodyAsBlob();
                        attDoc.Name = resAttName;
                        insert attDoc;
                        response.responseAttachmentId = attDoc.Id;
                    } catch(Exception e) {
                        errorMessage = 'Error while creating quote attachment ' + resAttName + ': ' + e.getMessage();
                    }
                    try {
                        q.Proposal__c = true;
                        q.Proposal_Completed__c = system.now();
                        update q;                        
                    } catch(Exception e) {
                        errorMessage = 'Error while updating quote : ' + e.getMessage();
                    }
                }
                         
            }
            
            System.debug('Heap Size: ' + Limits.getHeapSize());
        }

        if (String.IsBlank(errorMessage)) {            
            response.isSuccess = true;
        }

        // spectrum debug log
        if (logs.size() > 0) {
            SpectrumDebugUtility.generateDebugLog(logs);
        }

        response.errorMessage = errorMessage;
        return response;
    }   

    public class DownloadProposalRequest {
        public String quoteId;
    }
    public class DownloadProposalResponse {
        public String requestAttachmentId;
        public String responseAttachmentId;
        public Boolean isSuccess;
        public String errorMessage;
        public DownloadProposalRequest request;
        public DownloadProposalResponse() {
            this.isSuccess = false;
        }
    }
    
//-------------------------------------------------------------------------------------------    
// private static methods
//-------------------------------------------------------------------------------------------    
    private static List <DocGen_Mapping__mdt> getDocGenMappingList(String templateName) {
        List <DocGen_Mapping__mdt> mList = new List <DocGen_Mapping__mdt>();
        if (String.IsNotBlank(templateName)) {
            mList = [SELECT Id,
                    Field_API_Name__c,
                    Field_Format__c,
                    Field_Type__c,
                    sObject_API_Name__c,
                    Template_Name__c,
                    Token_Name__c,
                    Token_Value__c,
                    Type__c
                FROM DocGen_Mapping__mdt
                WHERE Template_Name__c = :templateName
                ORDER BY Token_Name__c ASC];
        } 
        return mList;   
    }
    
    private static String getQuoteQuery(String quoteId, List <DocGen_Mapping__mdt> mList) {
        String qry;
        
        // validate
        if (String.IsBlank(quoteId)) {
            return qry;
        }
        
        Map <String, Set <String>> objNameFieldsMap = new Map <String, Set <String>>();
        for (DocGen_Mapping__mdt m : mList) {
            if (m.sObject_API_Name__c != null && m.Field_API_Name__c != null) {
                Set <String> fields = new Set <String>();
                if (objNameFieldsMap.containsKey(m.sObject_API_Name__c)) {
                    fields = objNameFieldsMap.get(m.sObject_API_Name__c);
                }
                fields.add(m.Field_API_Name__c);
                objNameFieldsMap.put(m.sObject_API_Name__c, fields);
            }
        }
        
        Set <String> fields = new Set <String>();
        // add standard fields
        if (objNameFieldsMap.containsKey('Quote')) {
            fields = objNameFieldsMap.get('Quote');
        }
        fields.add('Id');
        fields.add('Name');
        fields.add('Annual_Bill__c');
        fields.add('Proposal__c');
        fields.add('Proposal_Completed__c');
        fields.add('Term_Sheet__c');
        fields.add('Term_Sheet_Generated_Date__c');
        fields.add('Utility_Bill_Annual_Escalation__c');

        objNameFieldsMap.put('Quote', fields);
        
        // add relationship object fields. to load from custom metadata ?
        fields = new Set <String>();
        if (objNameFieldsMap.containsKey('Quote_Designs__r')) {
            fields = objNameFieldsMap.get('Quote_Designs__r');
        }
        fields.add('Id');
        fields.add('Design__c');
        fields.add('Design__r.Site__c');
        fields.add('Design__r.Site__r.Site_Address__c');
        fields.add('Design__r.Site__r.Site_City__c');
        fields.add('Design__r.Site__r.Site_Country__c');
        fields.add('Design__r.Site__r.Site_State__c');
        fields.add('Design__r.Site__r.Site_Zip_Postal_Code__c');
        fields.add('Design__r.Module_Quantity__c');
        fields.add('Design__r.ModuleTypeandWattage__c');
        fields.add('Design__r.HelixDesignType__c');
        fields.add('Design__r.Name');
        
        objNameFieldsMap.put('Quote_Designs__r', fields);  
        
        //Annual Financial records
        fields = new Set <String>();
        if (objNameFieldsMap.containsKey('Annual_Financials__r')) {
            fields = objNameFieldsMap.get('Annual_Financials__r');
        }
        fields.add('Id');
        fields.add('Utility_Bill_Savings__c');
        fields.add('Response_Line_Type__c');
        fields.add('Net_Savings_NPV_3__c');
        fields.add('Net_Savings_NPV_5__c');
        fields.add('Net_Savings_NPV_8__c');
        fields.add('PPA_Payment__c');
        fields.add('Row_Number__c');
        fields.add('Annual_Base__c');

                
        objNameFieldsMap.put('Annual_Financials__r', fields);              
        
        // generate query string
        qry = 'SELECT ';
        for (String objName : objNameFieldsMap.keySet()) {
            if (objName == 'Quote') {
                List <String> quoteFields = new List <String>(objNameFieldsMap.get(objName));
                if (quoteFields.size() > 0) {
                    qry += String.join(quoteFields, ', ');
                }
            } else {
                // relationship query
                List <String> relationshipFields = new List <String>(objNameFieldsMap.get(objName));
                if (relationshipFields.size() > 0) {
                    qry += ', (SELECT ' + String.join(relationshipFields, ', ') + ' FROM ' + objName + ')';
                }
            }
            
        }
        qry += ' FROM Quote WHERE Id = ' + '\'' + quoteId + '\'';
        
        System.debug('String Query: ' + qry);
        
        return qry;
    }

    private static Quote getQuote(String quoteId, List <DocGen_Mapping__mdt> mList) {
        Quote q = new Quote();    

        String qry = getQuoteQuery(quoteId, mList);
        if (String.IsNotBlank(qry)) {
            List <Quote> qList = (List <Quote>)Database.query(qry);
            if (qList.size() > 0) {
                q = qList[0];
            }
        }
        
        return q;
    }
    
    private static String getSiteAddresses(Quote q) {
        String siteAddresses = '';
        List <String> addressList = new List <String>();
        if (q != null && q.Quote_Designs__r != null) {    
            for (Quote_Design__c qd : q.Quote_Designs__r) {
                String address = ''; 
                address += qd.Design__r.Site__r.Site_Address__c;
                address += ', ' + qd.Design__r.Site__r.Site_City__c;
                address += ', ' + qd.Design__r.Site__r.Site_State__c;
                address += ' ' + qd.Design__r.Site__r.Site_Zip_Postal_Code__c;
                address += ', ' + qd.Design__r.Site__r.Site_Country__c;
                addressList.add(address);
            }
        }
        if (addressList.size() > 0) {
            siteAddresses = String.join(addressList, ', ');
        }
        return siteAddresses;    
    }
    
    private static Object getField(SObject sobj, String fieldName) {
        Object retValue;
        if (sobj != null && String.IsNotBlank(fieldName)) {
            List <String> parts = fieldName.split('\\.');        
            if (parts.size() == 1) {
                retValue = sobj.get(parts[0]);
            } else {
                SObject relationSObj = sobj;
                for (Integer i=0; i<parts.size()-1; i++) {
                    relationSObj = relationSObj.getSObject(parts[i]);
                }
                retValue = relationSObj.get(parts[parts.size()-1]);
            }        
        }
    
        return retValue;    
    }
    
    private static User getUser(String userId) {
        User u = new User();
        if (String.IsNotBlank(userId)) {
            List <User> uList = [SELECT Name, 
                         Email,
                         Phone,
                         Contact.Account.Phone,
                         Contact.Account.Dealer_Locator_Phone__c
                  FROM User
                  WHERE id = :userId
                  LIMIT 1];
            if (uList.size() > 0) {
                u = uList[0];
            }
        }                        
        return u;                
    }

    private static SpectrumDebugUtility.debugLog prepDebugLog(Id quoteId, String serviceName, Httprequest request, Httpresponse response){
        SpectrumDebugUtility.debugLog spExLog = new SpectrumDebugUtility.debugLog();
        spExlog.quoteId = quoteId;
        spExLog.Service = serviceName;
        if (request != null) {
            spExLog.JSONPayload = request.getBody();
        }
        if (response != null) {
            spExLog.Response = response.getBody(); 
            spExLog.responseCode = response.getStatusCode();
        }
        return spExLog;
    }

}