/*
*
*
*
*
*
*/


public with sharing class CommercialDataUtility {
    
    /*STATIC CONSTANTS*/
    @TestVisible
    private static final String helixRoof = 'Helix Roof';
    @TestVisible
    private static final String helixRoofSingle = 'Helix Roof Single Tilt';
    @TestVisible
    private static final String helixRoofDual = 'Helix Roof Dual Tilt';

    /*VARIABLES*/


    /*CONSTRUCTORS*/
    public CommercialDataUtility() {    }


    /*METHODS*/
    
    //validation for PPA access and other user permissions related to quote creation
    public static ResultMessage getPermissions(String accId, String oppId) {
        ResultMessage rm = new ResultMessage();
        String userOrAccPermError = 'This section is not visible because you are not part of the Helix PPA program.  If you want to learn more about our Helix PPA program, please contact your Regional Sales Manager.';
        String statePPAError = 'No Facility State found.  Please review the opportunity address.';
        
        // defaults
        rm.success = false;
        
        Map <String, Object> ppaAvailableState = new Map <String, Object>();
        ppaAvailableState.put('allowed', false);
        ppaAvailableState.put('permissionDeniedMessage', statePPAError);

        Map <String, Object> ppaPartner = new Map <String, Object>();
        ppaPartner.put('allowed', false);
        ppaPartner.put('permissionDeniedMessage', userOrAccPermError);

        Map <String, Object> createPPAQuote = new Map <String, Object>();
        createPPAQuote.put('allowed', false);
        createPPAQuote.put('permissionDeniedMessage', userOrAccPermError);

        Map <String, Object> commercialHDS = new Map <String, Object>();
        commercialHDS.put('allowed', false);
        commercialHDS.put('permissionDeniedMessage', '');
        
        Map <String, Object> records = new Map <String, Object>();
        records.put('ppaAvailableState', ppaAvailableState);
        records.put('ppaPartner', ppaPartner);
        records.put('createPPAQuote', createPPAQuote);
        records.put('commercialHDS', commercialHDS);
        
        Map <String, Object> recordAccess = new Map <String, Object>();
        User u = [SELECT Id, ContactId, FirstName, LastName, Business_Function__c,
                    Profile.Name, Contact.AccountId, Contact.Account.Name,
                    Contact.Account.Special_Programs__c, Contact.Account.Oracle_Operating_Unit__c,
                    Contact.Account.Design_Tool_Organization_Id__c, Contact.Account.Type
                  FROM User WHERE Id =: UserInfo.getUserId()];


            
        if (u.Business_Function__c != null) {
            Set <String> bfSet = new Set <String>();
            for (String bf : u.Business_Function__c.split(';')) {
                bfSet.add(bf);
            }
            if (bfSet.contains('Create PPA Quote')) {
                createPPAQuote.put('allowed', true);
                createPPAQuote.put('permissionDeniedMessage', '');
            }
            if (bfSet.contains('Commercial Aurora Design Licensee')) {
                if (u.Contact.Account.Design_Tool_Organization_Id__c != null) {
                    commercialHDS.put('allowed', true);
                }
            }
        } 
        if (u.Contact.Account.Special_Programs__c != null) {
            Set <String> spSet = new Set <String>();
            for (String sp : u.Contact.Account.Special_Programs__c.split(';')) {
                spSet.add(sp);
            }
            if (spSet.contains('Helix PPA program')) {
                ppaPartner.put('allowed', true);
                ppaPartner.put('permissionDeniedMessage', '');
            }
        }          


        if(String.isNotBlank(accId)) {
            Set<String> recordIds = new Set<String>{accId};
            for(Opportunity o : [SELECT Id FROM Opportunity WHERE AccountId =: accId]) {
                recordIds.add(o.Id);
            }

            for(UserRecordAccess a : [SELECT RecordId, MaxAccessLevel
                                      FROM UserRecordAccess
                                      WHERE UserId =: UserInfo.getUserId()
                                      AND RecordId IN: recordIds]) {
                recordAccess.put(a.RecordId, a.MaxAccessLevel);
            }
        }
        
        if (String.IsNotBlank(oppId)) {
            Opportunity o = [SELECT Id, 
                                    Facility_State1__c
                             FROM Opportunity 
                             WHERE Id = :oppId];
            
            if(o != null) {                 
                statePPAError = 'The state of this facility address (' + o.Facility_State1__c + ') is not yet activated as part of our Helix PPA program.  Please contact your Regional Sales Manager for further updates.';
                ppaAvailableState.put('permissionDeniedMessage', statePPAError);
                
                if (getCostMatrixList(o.Facility_State1__c).size() > 0) {
                    ppaAvailableState.put('allowed', true);
                    ppaAvailableState.put('permissionDeniedMessage', '');        
                }
            } else {
                ppaAvailableState.put('allowed', false);
                ppaAvailableState.put('permissionDeniedMessage', 'access denied');
            }
        }
        rm.payloadMap = new Map <String, Object>();
        rm.payloadMap.put('records', records);
        rm.payloadMap.put('recordAccess', recordAccess);
        rm.payloadMap.put('mixpanel',u);
        rm.success = true;
        
        return rm;
    }
    
    //Get Sites and Designs
    @RemoteAction
    public static ResultMessage getDesignSummary(String opportunityId) {
        ResultMessage result = new ResultMessage();    
        result.success = false;

        if (String.IsBlank(opportunityId)) {
            result.message = Label.Invalid_Parameters;
            return result;
        }
        
        // load data once by using bulkified methods
        List <Site_Information_Form__c> siteList = getSiteList(opportunityId);
        Set <String> designIdSet = new Set <String>();
        Set <String> roofDesignIdSet = new Set <String>();
        for (Site_Information_Form__c site : siteList) {
            for (Design__c design : site.Designs__r) {
                designIdSet.add(design.Id);
                if (design.Roof_Design__c != null && design.Design_Originated_by__c == 'Indirect') {
                    roofDesignIdSet.add(design.Roof_Design__c);
                }
            }
        } 
        Map <String, Design__c> designMap = getDesignMap(designIdSet); 
        Map <String, EnergyProductionYr1__c> energyProductionMap = getEnergyProductionMap(roofDesignIdSet);      
        Set <String> documentIdSet = new Set<String>();
        for (Site_Information_Form__c site : siteList) {
            for (Design__c d : site.Designs__r) {
                Design__c design = designMap.get(d.Id);
                for(Document__c doc : design.Documents__r) {
                    if(doc.Bucket_Name__c != null) {
                    
                    } else {
                        documentIdSet.add(doc.Id);
                    }
                }
            }
        }
        Map <String, List <Attachment>> attachmentsMap = getAttachmentsMap(documentIdSet, designIdSet);
                
        // sites
        List <Object> sitePayloadList = new List <Object>();
        for (Site_Information_Form__c site : siteList) {
            Map <String, Object> sitePayload = new Map <String, Object>();
            sitePayload.put('Id', site.Id);
            sitePayload.put('Name', site.Name);
            sitePayload.put('Site_Name__c', site.Site_Name__c);
            sitePayload.put('Site_Address__c', site.Site_Address__c);
            sitePayload.put('Site_City__c', site.Site_City__c);
            sitePayload.put('Site_State__c', site.Site_State__c);
            sitePayload.put('Site_Zip_Postal_Code__c', site.Site_Zip_Postal_Code__c);
            sitePayload.put('Site_Country__c', site.Site_Country__c);
            sitePayload.put('Site_Latitude_Y_coordinate__c', site.Site_Latitude_Y_coordinate__c);
            sitePayload.put('Site_Longitude_X_coordinate__c', site.Site_Longitude_X_coordinate__c);
            sitePayload.put('Nominal_AC_Voltage__c', site.Nominal_AC_Voltage__c);
            sitePayload.put('Design_Wind_Speed_Mph__c', site.Design_Wind_Speed_Mph__c);
            sitePayload.put('Account__c', site.Account__c);
            sitePayload.put('Opportunity_del__c', site.Opportunity_del__c);

            sitePayloadList.add(sitePayload);
            
            // designs
            List <Object> designPayloadList = new List <Object>();
            for (Design__c d : site.Designs__r) {
                Design__c design = designMap.get(d.Id);
                Map <String, Object> designPayload = new Map <String, Object>();
                designPayload.put('Id', design.Id);
                designPayload.put('Name', design.Name);
                designPayload.put('designedBy', design.Design_Originated_By__c == 'Request' || design.Design_Originated_by__c == 'Direct' ? 'SunPower' : design.DealerName__r.Name);
                designPayload.put('Actual_Annual_Production__c', design.Actual_Annual_Production__c);
                designPayload.put('Actual_System_Size__c', design.Actual_System_Size__c);
                designPayload.put('Design_Originated_By__c', design.Design_Originated_By__c);
                designPayload.put('Export_Status__c', design.Export_Status__c);
                designPayload.put('Dealer_Status__c', design.Dealer_Status__c);
                designPayload.put('Step_Number__c', design.Step_Number__c);
                designPayload.put('Final_Design__c', design.Final_Design__c);
                designPayload.put('Design_Package_Type__c', design.Design_Package_Type__c);
                designPayload.put('HelixDesignType__c', design.HelixDesignType__c);
                designPayload.put('Technology_System__c', design.Technology_System__c);
                if(design.HelixDesignType__c == helixRoof) {
                    if(design.Technology_System__c == Label.HelixDualTilt) {
                        designPayload.put('designType', helixRoofDual);
                    } else {
                        designPayload.put('designType', helixRoofSingle);
                    }
                } else {
                    designPayload.put('designType', design.HelixDesignType__c);
                }
                designPayload.put('Module_Quantity__c', design.Module_Quantity__c);
                designPayload.put('ModuleTypeAndWattage__c', design.ModuleTypeAndWattage__c);
                designPayload.put('Roof_Design__c', design.Roof_Design__c);
                designPayload.put('Roof_Design__r.Design_DesignId__c', design.Roof_Design__r.Design_DesignId__c);
                
                designPayloadList.add(designPayload);
                
                // energy production
                if (design.Roof_Design__c != null && design.Design_Originated_by__c == 'Indirect' && energyProductionMap.containsKey(design.Roof_Design__c)) {
                    designPayload.put('energyProduction', energyProductionMap.get(design.Roof_Design__c));
                }

                // documents
                String pngURL;
                Set <String> docIdSet = new Set<String>();
                List <Object> documentPayloadList = new List <Object>();
                for(Document__c doc : design.Documents__r) {
                    if(doc.Bucket_Name__c != null) {
                        Map <String, Object> documentPayload = new Map <String, Object>();
                        documentPayload.put('Id', doc.Id);
                        documentPayload.put('File_Name__c', doc.File_Name__c);
                        documentPayload.put('Name', doc.Name);
                        documentPayload.put('Document_Link__c', doc.Document_Link__c);
                        documentPayload.put('CreatedDate', doc.CreatedDate);
                        
                        documentPayloadList.add(documentPayload);
                        
                        if(String.isBlank(pngURL) && doc.Content_Type__c == 'application/png') {
                            pngURL = 'https://' + doc.Bucket_Name__c + '.s3.amazonaws.com/' + doc.File_Name__c;
                        }
                    } else {
                        docIdSet.add(doc.Id);
                    }
                }
                designPayload.put('imageURL', pngURL);

                // attachments
                List <Object> attachmentPayloadList = new List <Object>();
                attachmentPayloadList.addAll(documentPayloadList);
                // document attachments
                for (String docId : docIdSet) {
                    if (attachmentsMap.containsKey(docId)) {
                        List <Attachment> attList = attachmentsMap.get(docId);
                        for (Attachment att : attList) {
                            Map <String, Object> attachmentPayload = new Map <String, Object>(); 
                            attachmentPayload.put('Id', att.Id);       
                            attachmentPayload.put('File_Name__c', '');       
                            attachmentPayload.put('Name', att.Name);       
                            attachmentPayload.put('Document_Link__c', '');
                            attachmentPayload.put('CreatedDate', att.CreatedDate);
                            attachmentPayloadList.add(attachmentPayload);       
                        }
                    }
                } 
                // design attachments
                if (attachmentsMap.containsKey(design.Id)) {
                    List <Attachment> attList = attachmentsMap.get(design.Id);
                    for (Attachment att : attList) {
                        Map <String, Object> attachmentPayload = new Map <String, Object>(); 
                        attachmentPayload.put('Id', att.Id);       
                        attachmentPayload.put('File_Name__c', '');       
                        attachmentPayload.put('Name', att.Name);       
                        attachmentPayload.put('Document_Link__c', '');
                        attachmentPayload.put('CreatedDate', att.CreatedDate);
                        attachmentPayloadList.add(attachmentPayload);       
                    }
                }
                
                designPayload.put('attachments', (Object)attachmentPayloadList);
                
            }
            sitePayload.put('designs', (Object)designPayloadList);

        }
        result.payloadMap.put('records', (Object)sitePayloadList);
        result.success = true;
        
        return result;    
    }
    
    public static ResultMessage createSystemOnlyDesign(Design__c design, List <SunPower_Design_Item__c> inverters) {
        ResultMessage result = new ResultMessage();    
        result.success = false;
        
        String originalDesignType = '';
        Savepoint sp = Database.setSavepoint();
        try {
            if (design != null) {
                if(design.HelixDesignType__c != null && design.HelixDesignType__c.contains(helixRoof)) {
                    originalDesignType = design.HelixDesignType__c;
                    if(design.HelixDesignType__c.containsIgnoreCase('Single'))
                        design.Technology_System__c = Label.HelixSingleTilt;
                    else
                        design.Technology_System__c = Label.HelixDualTilt;

                    design.HelixDesignType__c = helixRoof;
                } else originalDesignType = design.HelixDesignType__c;
                design.DealerName__c = [SELECT Contact.AccountId FROM User WHERE Id =: UserInfo.getUserId()].Contact.AccountId;
                if (design.Id == null) {
                    design.Final_Design__c = true;
                    design.RecordTypeId = Schema.SObjectType.Design__c.getRecordTypeInfosByName().get('System Only').getRecordTypeId();
                    insert design;
                } else {
                    update design;
                }
            } else {
                result.message = 'design is null';
            }
            if (inverters != null) {
                List <SunPower_Design_Item__c> invertersInsert = new List <SunPower_Design_Item__c>();
                List <SunPower_Design_Item__c> invertersUpdate = new List <SunPower_Design_Item__c>();
                List <SunPower_Design_Item__c> invertersDelete = new List <SunPower_Design_Item__c>();
                for (SunPower_Design_Item__c inverter : inverters) {
                    if (inverter != null) {
                        if (inverter.isDeleted == true) {
                            if (inverter.Id != null) {
                                invertersDelete.add(inverter);
                            }                        
                        } else {
                            if (inverter.Id == null) {
                                inverter.Design__c = design.Id;
                                invertersInsert.add(inverter);
                            } else {
                                invertersUpdate.add(inverter);
                            }
                        }
                    }
                }
                if (invertersDelete.size() > 0) {
                    delete invertersDelete;
                }
                if (invertersInsert.size() > 0) {
                    insert invertersInsert;
                }
                if (invertersUpdate.size() > 0) {
                    update invertersUpdate;
                }
            }
            Map <String, Object> payloadMap = new Map <String, Object>();
            Map <String, Object> records = new Map <String, Object>();

            if(String.isNotBlank(originalDesignType)) {
                design.HelixDesignType__c = originalDesignType;
            }

            records.put('design', design);
            records.put('inverters', inverters);
            payloadMap.put('records', records);
            result.payloadMap = payloadMap;
            result.success = true;
        } catch (Exception e) {
            result.message = e.getMessage();
            Database.rollback(sp);
        }                           

        return result;
    }
    
    public static ResultMessage getOpportunitySystems(String opportunityId) {
        ResultMessage result = new ResultMessage();    
        result.success = false;
        List<Object> records = new List<Object>();
        try {
            for(Design__c design : [SELECT Id, Name, Final_Design__c, HelixDesignType__c, Technology_System__c,
                                      Actual_System_Size__c, ModuleTypeandWattage__c, Module_Quantity__c,
                                      (SELECT Id, Name, Component_Type__c, Description__c,
                                              Design__c, Oracle_Item_Description__c,
                                              Oracle_Item_ID__c, Quantity__c
                                        FROM SunPower_Design_Items__r WHERE Component_Type__c = 'Inverter')
                               FROM Design__c WHERE Opportunity__c = :opportunityId 
                               AND Final_Design__c = true 
                               AND (RecordTypeId = :Schema.SObjectType.Design__c.getRecordTypeInfosByName().get('Proposal Design').getRecordTypeId() 
                                OR RecordTypeId = :Schema.SObjectType.Design__c.getRecordTypeInfosByName().get('System Only').getRecordTypeId())
                               Order By CreatedDate DESC]) {
                Map <String, Object> designPayload = new Map <String, Object>();
                designPayload.put('Id', design.Id);
                designPayload.put('Name', design.Name);
                designPayload.put('Actual_System_Size__c', design.Actual_System_Size__c);
                designPayload.put('Final_Design__c', design.Final_Design__c);
                designPayload.put('Technology_System__c', design.Technology_System__c);
                if(String.isNotBlank(design.HelixDesignType__c) && design.HelixDesignType__c == helixRoof) {
                    if(design.Technology_System__c == Label.HelixDualTilt)
                        designPayload.put('HelixDesignType__c', 'Helix Roof Dual Tilt');
                    else designPayload.put('HelixDesignType__c', 'Helix Roof Single Tilt');
                }
                else designPayload.put('HelixDesignType__c', design.HelixDesignType__c);
                designPayload.put('Module_Quantity__c', design.Module_Quantity__c);
                designPayload.put('ModuleTypeandWattage__c', design.ModuleTypeandWattage__c);
                designPayload.put('moduleWattage', design.ModuleTypeandWattage__c == null ? '0' : design.ModuleTypeandWattage__c.right(7).left(3));
                designPayload.put('SunPower_Design_Items__r', design.SunPower_Design_Items__r);
                records.add(designPayload);
            }
            result.payloadMap.put('records', (Object)records);
            result.success = true;
        } catch(Exception e) {
            result.err = JSON.deserializeUntyped(SPCommunityErrorUtility.generateExceptionJSON(e));
        }        
        return result;
    }
    
    private static List <Site_Information_Form__c> getSiteList(String opportunityId) {
        List <Site_Information_Form__c> siteList = new List <Site_Information_Form__c>();
        if (String.IsNotBlank(opportunityId)) {    
            siteList = [SELECT Id, Name, Account__c, Opportunity_del__c,
                    Nominal_AC_Voltage__c, Site_Name__c, Site_Address__c, 
                    Site_City__c, Site_Country__c, Site_State__c, Site_Zip_Postal_Code__c,
                    Site_Latitude_Y_coordinate__c, Site_Longitude_X_coordinate__c, 
                    Design_Wind_Speed_Mph__c, 
                (SELECT Id, Name, Step_Number__c,
                        Actual_System_Size__c,
                        DealerName__r.Name,
                        Dealer_Status__c,
                        Design_Originated_by__c, 
                        Design_Package_Type__c,
                        Final_Design__c,
                        HelixDesignType__c,
                        Roof_Design__c,
                        Roof_Design__r.Design_DesignId__c,
                        Export_Status__c
                    FROM Designs__r
                    WHERE RecordTypeId = :Schema.SObjectType.Design__c.getRecordTypeInfosByName().get('Proposal Design').getRecordTypeId())
                FROM Site_Information_Form__c 
                WHERE Opportunity_del__c = :opportunityId
                ORDER BY Name DESC]; 
    
        }
        return siteList;
    }
    
    private static Map <String, Design__c> getDesignMap(Set <String> designIdSet) {
        Map <String, Design__c> designMap = new Map <String, Design__c>();
        if (designIdSet != null && designIdSet.size() > 0) {
            for (Design__c design: [SELECT Id, Name, Step_Number__c,
                    Actual_Annual_Production__c, Actual_System_Size__c, 
                    DealerName__r.Name, Dealer_Status__c, Final_Design__c,
                    Export_Status__c, Design_Originated_By__c,
                    Design_Package_Type__c, HelixDesignType__c, Technology_System__c,
                    Module_Quantity__c, ModuleTypeAndWattage__c, 
                    Roof_Design__c, Roof_Design__r.Design_DesignId__c,
                    (SELECT Id, Name,
                        Bucket_Name__c, 
                        Content_Type__c, 
                        CreatedDate,  
                        Design__c,
                        Document_Link__c, 
                        File_Name__c 
                    FROM Documents__r ORDER BY CreatedDate DESC)
                FROM Design__c WHERE Id = :designIdSet
                Order By CreatedDate DESC]) {
                    designMap.put(design.Id, design);
            }
        }        
        return designMap;    
    }
    
    private static Map <String, List <Attachment>> getAttachmentsMap(Set <String> documentIdSet, Set <String> designIdSet) {
        Map <String, List <Attachment>> attachmentsMap = new Map <String, List <Attachment>>();
        for (Attachment att : [SELECT Id, Name, CreatedDate, ParentId 
                FROM Attachment 
                WHERE ((ParentId IN :documentIdSet) OR 
                       (Name = '8760.csv' AND ParentId = :designIdSet))
                ORDER BY CreatedDate DESC ]) {
        
            List <Attachment> attList = new List <Attachment>();
            if (attachmentsMap.containsKey(att.ParentId)) {
                attList = attachmentsMap.get(att.ParentId);
            }
            attList.add(att);
            attachmentsMap.put(att.ParentId, attList);        
        }        
    
        return attachmentsMap;
    }
    
    private static Map <String, EnergyProductionYr1__c> getEnergyProductionMap(Set <String> roofDesignIdSet) {
        Map <String, EnergyProductionYr1__c> epMap = new Map <String, EnergyProductionYr1__c>();

        if (roofDesignIdSet != null && roofDesignIdSet.size() > 0) {
            List <EnergyProductionYr1__c> epList = [SELECT Id, Name, RoofDesign__c, 
                    Jan__c, Feb__c, Mar__c, Apr__c, May__c, Jun__c, Jul__c, Aug__c, Sep__c, Oct__c, Nov__c, Dec__c 
                FROM EnergyProductionYr1__c 
                WHERE RoofDesign__c IN :roofDesignIdSet
                ORDER BY CreatedDate DESC];
            for (EnergyProductionYr1__c ep : epList) {
                if (ep.RoofDesign__c != null && epMap.containsKey(ep.RoofDesign__c) == false) {
                    epMap.put(ep.RoofDesign__c, ep);
                }
            }                
        }    
           
        return epMap;    
    }
    
    private static List <Cost_Matrix__c> getCostMatrixList(String state) {
        List <Cost_Matrix__c> cmList = new List <Cost_Matrix__c>();
        if (String.IsNotBlank(state)) {
            cmList = [SELECT Id, Sales_Configuration__r.Active__c 
                    FROM Cost_Matrix__c 
                    WHERE State__c = :state AND Sales_Configuration__r.Active__c = true];
        }
        return cmList;
    }

    @RemoteAction
    public static ResultMessage getModuleInverterList() {
        ResultMessage message = new ResultMessage();
        message.success = false;

        //getFieldDependencies
        Map<String, List<String>> fieldDependencies = new Map<String, List<String>>();
        fieldDependencies = MetadataRetrievalUtil.getFieldDependencies('Design__c','HelixDesignType__c','ModuleTypeAndWattage__c');

        if(fieldDependencies == null || fieldDependencies.isEmpty()) {
            message.err = SPCommunityErrorUtility.errMessage;
            return message;
        }

        Map<String, List<ModuleInverterJunction__c>> masterCollection = ProductConfigurationUtility.fetchModulesInvertersByConfigurationModel(fieldDependencies.keySet()); //ProductConfigurationUtility.fetchModulesInvertersByMasterName(fieldDependencies.keySet());
        if(masterCollection == null || masterCollection.isEmpty()) {
            message.err = SPCommunityErrorUtility.errMessage;
            return message;
        }

        List<SystemConfiguration> setupRecords = new List<SystemConfiguration>();

        Map<String, Map<Module_Configuration__c, List<Inverter_Configuration__c>>> typeToModWithInverters = new Map<String, Map<Module_Configuration__c, List<Inverter_Configuration__c>>>();

        try {
            for(String s : masterCollection.keySet()) {
                List<ModuleInverterJunction__c> tempMIJList = masterCollection.get(s);
                

                Map<Module_Configuration__c, List<Inverter_Configuration__c>> tempInnerMap = new Map<Module_Configuration__c, List<Inverter_Configuration__c>>(); //typeToModWithInverters.get(s);
                for(ModuleInverterJunction__c mij : tempMIJList) {
                    if(tempInnerMap.containsKey(mij.Module_Configuration__r)) {
                        tempInnerMap.get(mij.Module_Configuration__r).add(mij.Inverter_Configuration__r);
                    } else {
                        tempInnerMap.put(mij.Module_Configuration__r, new List<Inverter_Configuration__c>{mij.Inverter_Configuration__r});
                    }
                }
                typeToModWithInverters.put(s,tempInnerMap);
            } 
            
            for(String designType : fieldDependencies.keySet()) {
                if(designType.containsIgnoreCase('Other')) continue;
                SystemConfiguration config = new SystemConfiguration();
                config.designType = designType;
                List<DesignSystemSetup> modulesList = new List<DesignSystemSetup>();
                for(String configModel : typeToModWithInverters.keySet()) {
                    if(configModel == designType) {
                        Map<Module_Configuration__c, List<Inverter_Configuration__c>> modInvTempFinal = typeToModWithInverters.get(configModel);

                        for(String avalilableMod : fieldDependencies.get(designType)) {
                            DesignSystemSetup payloadObj = new DesignSystemSetup();
                            payloadObj.moduleName = avalilableMod;
                            for(Module_Configuration__c m : modInvTempFinal.keySet()) {
                                if(m.Name == avalilableMod) {
                                    payloadObj.moduleWattage = m.Item__r.Item_Category_3__c;
                                    payloadObj.module = m;
                                    payloadObj.inverters = modInvTempFinal.get(m);
                                }
                            }
                            modulesList.add(payloadObj);
                        }   
                    }
                }
                config.modules = (Object)modulesList;
                if(designType == 'Helix Roof') {
                    SystemConfiguration config2 = new SystemConfiguration();
                    config2.designType = 'Helix Roof Single Tilt';
                    config2.modules = config.modules;
                    setupRecords.add(config2);
                    config.designType = 'Helix Roof Dual Tilt';
                }
                setupRecords.add(config);            
            }
        } catch(Exception e) {
            message.err = JSON.deserializeUntyped(SPCommunityErrorUtility.generateExceptionJSON(e));
            return message;
        }

        message.payloadMap.put('records',(Object)setupRecords);
        message.success = true;
        return message;
    }

    public class DesignSystemSetup {
        String moduleName;
        String moduleWattage;
        Object module;
        Object inverters;
        
    }

    public class SystemConfiguration {
        String designType;
        Object modules;
    }

    
}