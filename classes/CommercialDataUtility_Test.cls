@isTest
public class CommercialDataUtility_Test {

    private static testMethod void test_getPermissions() {
        User pu_1 = createPartnerUser();
        pu_1.Business_Function__c = 'Create PPA Quote;Commercial Aurora Design Licensee';
        // avoid error MIXED_DML_OPERATION, DML operation on setup object is not permitted after you have updated 
        // a non-setup object (or vice versa): User, original object: AccountShare
        UserManagement.IS_TEST = true;
        insert pu_1;
        
        Master_Configurator__c masConf = createMasterConfigurator();
        insert masConf;
        SalesConfiguration__c salesConf = createSalesConfiguration(masConf.Id, Design__c.HelixDesignType__c.getDescribe().getPicklistValues()[0].getValue());
        insert salesConf;
        Cost_Matrix__c costMatrix = createCostMatrix(salesConf.Id);
        insert costMatrix;
        
        Account acc_1 = TestFactory_StandardObjects.getCommercialCustomerAccount();
        Opportunity oppty_1 = TestFactory_Commercial.createNewCvarCustomer(acc_1.Id, [SELECT Contact.AccountId FROM User WHERE Id = :pu_1.Id].Contact.AccountId);  
        oppty_1.OwnerId = pu_1.Id;
        oppty_1.Facility_State1__c = 'CA';
        insert oppty_1;

        ResultMessage rm;
        system.runAs(pu_1) {
            rm = CommercialDataUtility.getPermissions(acc_1.Id, oppty_1.Id);
        }
        
        system.assertEquals(true, rm.success);
        system.assertNotEquals(null, rm.payloadMap.get('records'));
        Map <String, Object> records = (Map <String, Object>)rm.payloadMap.get('records');
        Map <String, Object> ppaAvailableState = (Map <String, Object>)records.get('ppaAvailableState');
        system.assertEquals(true, ppaAvailableState.get('allowed'));
        Map <String, Object> ppaPartner = (Map <String, Object>)records.get('ppaPartner');
        system.assertEquals(true, ppaPartner.get('allowed'));
        Map <String, Object> createPPAQuote = (Map <String, Object>)records.get('createPPAQuote');
        system.assertEquals(true, createPPAQuote.get('allowed'));
        Map <String, Object> commercialHDS = (Map <String, Object>)records.get('commercialHDS');
        system.assertEquals(true, commercialHDS.get('allowed'));
        
        Map <String, Object> recordAccess = (Map <String, Object>)rm.payloadMap.get('recordAccess');
        system.assertNotEquals(null, recordAccess);
        system.assertEquals(true, recordAccess.containsKey(acc_1.Id));
        system.assertEquals(true, recordAccess.containsKey(oppty_1.Id));
    }
    
    private static testMethod void test_getDesignSummary() {
        Opportunity oppty_1 = TestFactory_Commercial.getNewCvarCustomer(null, null);    
        // sites
        Site_Information_Form__c site_1 = createSite(oppty_1.Id);
        Site_Information_Form__c site_2 = createSite(oppty_1.Id);
        insert new List <Site_Information_Form__c>{site_1, site_2};
        
        // roof design
        Roof_Design__c rd_11 = createRoofDesign();
        Roof_Design__c rd_12 = createRoofDesign();
        insert new List <Roof_Design__c>{rd_11, rd_12};
        
        // designs. why roof design not getting set while inserting ?
        Design__c design_11 = createDesign(oppty_1.Id, site_1.Id);
        Design__c design_12 = createDesign(oppty_1.Id, site_1.Id);
        insert new List <Design__c>{design_11, design_12};
        design_11.Roof_Design__c = rd_11.Id;
        design_12.Roof_Design__c = rd_12.Id;
        update new List <Design__c>{design_11, design_12};
        
        // documents
        Document__c doc_111 = createDocument(design_11.Id);
        doc_111.Bucket_Name__c = 'TestBucket';
        Document__c doc_112 = createDocument(design_11.Id);
        insert new List <Document__c>{doc_111, doc_112};
        
        // energy productions
        EnergyProductionYr1__c ep_11 = createEnergyProduction(rd_11.Id);
        insert new List <EnergyProductionYr1__c>{ep_11};
        
        // attachments
        Attachment att_1111 = createAttachment(doc_112.Id);    // document attachment
        Attachment att_111 = createAttachment(design_11.Id);    // design attachment
        att_111.Name = '8760.csv';
        insert new List <Attachment>{att_1111, att_111};
        
        ResultMessage rm = CommercialDataUtility.getDesignSummary(oppty_1.Id);
        
        system.assertEquals(2, ((List <Object>)rm.payloadMap.get('records')).size());    // sitePayloadList
        
        Map <Id, Set <Id>> siteDesigns = new Map <Id, Set <Id>>{
            site_1.Id => new Set <Id>{design_11.Id, design_12.Id},
            site_2.Id => new Set <Id>{}
        };
        
        for (Object site : ((List <Object>)rm.payloadMap.get('records'))) {
            Map <String, Object> sitePayload = (Map <String, Object>)site;
            Id siteId = (Id)sitePayload.get('Id');
            system.assertEquals(true, siteDesigns.containsKey(siteId));
            for (Object design : ((List <Object>)sitePayload.get('designs'))) {
                Map <String, Object> designPayload = (Map <String, Object>)design;
                Id designId = (Id)designPayload.get('Id');
                system.assertEquals(true, siteDesigns.get(siteId).contains(designId));
            }
        }
    }

    private static testMethod void test_createSystemOnlyDesign_insert() {
        Design__c design = new Design__c();
        design.HelixDesignType__c = 'Helix Roof';
        SunPower_Design_Item__c inverter_1 = new SunPower_Design_Item__c();
        List <SunPower_Design_Item__c> inverters = new List <SunPower_Design_Item__c>();
        inverters.add(inverter_1);
        ResultMessage rm = CommercialDataUtility.createSystemOnlyDesign(design, inverters);
        system.assertNotEquals(null, design.Id);
        system.assertNotEquals(null, inverter_1.Id);
        system.assertEquals(design.Id, inverter_1.Design__c);
        
    }

    private static testMethod void test_createSystemOnlyDesign_update() {
        Opportunity oppty = TestFactory_Commercial.getNewCvarCustomer(null, null);    
        // sites
        Site_Information_Form__c site = createSite(oppty.Id);
        insert site;
        
        Design__c design = createDesign(oppty.Id, site.Id);
        design.HelixDesignType__c = 'Helix Roof';
        insert design;

        SunPower_Design_Item__c inverter_1 = createDesignItem(design.Id);
        inverter_1.Quantity__c = 5;
        insert inverter_1;

        design.HelixDesignType__c = 'Helix Tracker';
        inverter_1.Quantity__c = 10;
        
        ResultMessage rm = CommercialDataUtility.createSystemOnlyDesign(design, new List <SunPower_Design_Item__c>{inverter_1});
        system.assertEquals(design.Id, inverter_1.Design__c);
        system.assertEquals('Helix Tracker', [SELECT HelixDesignType__c FROM Design__c WHERE Id = :design.Id].HelixDesignType__c);
        system.assertEquals(10, [SELECT Quantity__c FROM SunPower_Design_Item__c WHERE Id = :inverter_1.Id].Quantity__c);
        
    }

    private static testMethod void test_getOpportunitySystems() {
        Opportunity oppty_1 = TestFactory_Commercial.getNewCvarCustomer(null, null);    
        // sites
        Site_Information_Form__c site_1 = createSite(oppty_1.Id);
        insert new List <Site_Information_Form__c>{site_1};
        
        Design__c design_11 = createDesign(oppty_1.Id, site_1.Id);
        design_11.Final_Design__c = true;
        design_11.RecordTypeId = Schema.SObjectType.Design__c.getRecordTypeInfosByName().get('Proposal Design').getRecordTypeId();
        design_11.HelixDesignType__c = CommercialDataUtility.helixRoof;
        design_11.Technology_System__c = Label.HelixDualTilt;
        insert new List <Design__c>{design_11};

        ResultMessage rm = CommercialDataUtility.getOpportunitySystems(oppty_1.Id);
        system.assertEquals(true, rm.success);
        system.assertNotEquals(null, rm.payloadMap.get('records'));
    }

    private static testMethod void test_getModuleInverterList() {
        Master_Configurator__c masConf = createMasterConfigurator();
        insert masConf;
        List <SalesConfiguration__c> salesConfList = new List <SalesConfiguration__c>();
        for (Schema.PicklistEntry pe : Design__c.HelixDesignType__c.getDescribe().getPicklistValues()) {
            SalesConfiguration__c salesConf = createSalesConfiguration(masConf.Id, pe.getValue());
            salesConfList.add(salesConf);
        }
        insert salesConfList;
        
        Item__c item = createItem();
        insert item;
        
        Inverter_Configuration__c invConf = createInverterConfiguration();
        invConf.Item__c = item.Id;
        insert invConf;
        
        Module_Configuration__c modConf = createModuleConfiguration(item.Id);
        insert modConf;
        
        ModuleInverterJunction__c modInvJunction = createModuleInverterJunction(modConf.Id, invConf.Id);
        insert modInvJunction;
        
        MasterModuleInverterJunction__c mastModInvJunction = createMasterModuleInverterJunction(masConf.Id, modInvJunction.Id);
        insert mastModInvJunction;
        
        ResultMessage rm = CommercialDataUtility.getModuleInverterList();
        system.assertEquals(true, rm.success);
        system.assertNotEquals(null, rm.payloadMap.get('records'));
        
    }
            
    private static Site_Information_Form__c createSite(Id opptyId) {
        return TestFactory_Commercial.createBasicSite(opptyId).clone();
    }
    
    private static Roof_Design__c createRoofDesign() {
        Roof_Design__c rd = (Roof_Design__c)SmartFactory.createSObject('Roof_Design__c',false);
        rd.RecordTypeId = Schema.SObjectType.Roof_Design__c.getRecordTypeInfosByName().get('Commercial Design').getRecordTypeId();
        return rd;
    }
    
    private static Design__c createDesign(Id opptyId, Id siteId) {
        return TestFactory_Commercial.createProposalDesign(opptyId, siteId).clone();
    }

    private static Document__c createDocument(Id designId) {
        Document__c doc = (Document__c)SmartFactory.createSObject('Document__c',false);
        doc.RecordTypeId = Schema.SObjectType.Document__c.getRecordTypeInfosByName().get('Document').getRecordTypeId();
        doc.Design__c = designId;
        return doc;
    }

    private static EnergyProductionYr1__c createEnergyProduction(Id roofDesignId) {
        EnergyProductionYr1__c ep = (EnergyProductionYr1__c)SmartFactory.createSObject('EnergyProductionYr1__c',false);
        ep.RoofDesign__c = roofDesignId;
        return ep;
    }
    
    private static Attachment createAttachment(Id parentId) {
        Attachment att = new Attachment();
        att.ParentId = parentId;
        att.Name = 'Test';    // required
        att.Body = Blob.valueOf('Test');    // required
        return att;
    }

    private static Master_Configurator__c createMasterConfigurator() {
        Master_Configurator__c mc = (Master_Configurator__c)SmartFactory.createSObject('Master_Configurator__c',false);
        mc.Configuration_Model__c = 'Helix Roof';
        return mc;
    }
    
    private static SalesConfiguration__c createSalesConfiguration(Id masterConfigurationId, String commercialInstallationType) {
        SalesConfiguration__c sc = (SalesConfiguration__c)SmartFactory.createSObject('SalesConfiguration__c',false);
        sc.Configurator__c = masterConfigurationId;
        sc.Sector__c = 'Commercial';
        sc.Channel__c = 'Indirect';
        sc.Active__c = true;
        sc.State__c = 'CA';
        sc.Financial_Offering__c = 'PPA';
        return sc;
    }
    
    private static Inverter_Configuration__c createInverterConfiguration() {
        Inverter_Configuration__c ic = (Inverter_Configuration__c)SmartFactory.createSObject('Inverter_Configuration__c',false);
        ic.Start_Date__c = system.today().addDays(-30);
        ic.End_Date__c = system.today().addDays(30);
        ic.Inverter_Manufacturer__c = 'SMA';
        return ic;
    }
    
    private static Module_Configuration__c createModuleConfiguration(Id itemId) {
        Module_Configuration__c modConf = (Module_Configuration__c)SmartFactory.createSObject('Module_Configuration__c',false);
        modConf.Item__c = itemId;    // required
        return modConf;    
    }
    
    private static ModuleInverterJunction__c createModuleInverterJunction(Id modConfId, Id invConfId) {
        ModuleInverterJunction__c modInvJunction = (ModuleInverterJunction__c)SmartFactory.createSObject('ModuleInverterJunction__c',false);
        modInvJunction.Module_Configuration__c = modConfId;
        modInvJunction.Inverter_Configuration__c = invConfId;
        return modInvJunction;
    }
    
    private static MasterModuleInverterJunction__c createMasterModuleInverterJunction(Id masConfId, Id modInvJunction) {
        MasterModuleInverterJunction__c mastModInvJunction = (MasterModuleInverterJunction__c)SmartFactory.createSObject('MasterModuleInverterJunction__c',false);
        mastModInvJunction.Master_Configuration__c = masConfId;
        mastModInvJunction.ModuleInverterJunction__c = modInvJunction;
        return mastModInvJunction;    
    }
    
    private static Cost_Matrix__c createCostMatrix(Id salesConfId) {
        Cost_Matrix__c cm = (Cost_Matrix__c)SmartFactory.createSObject('Cost_Matrix__c',false);
        cm.Sales_Configuration__c = salesConfId;
        cm.Technology_System_Category__c = 'Helix Roof';
        cm.Available_Technology_Systems__c = 'R-Helix Single Tilt';
        return cm;
    }
    
    private static Item__c createItem() {
        Item__c item = (Item__c)SmartFactory.createSObject('Item__c',false);
        item.Item_Category_3__c = 'Test3';
        return item;
    }

    private static SunPower_Design_Item__c createDesignItem(Id designId) {
        SunPower_Design_Item__c item = (SunPower_Design_Item__c)SmartFactory.createSObject('SunPower_Design_Item__c',false);
        item.Design__c = designId;
        return item;
    }
    
    private static User createPartnerUser() {
        Account a = TestFactory_StandardObjects.createPartnerAccount();
        a.Design_Tool_Organization_Id__c = 'testId';
        a.Special_Programs__c = 'Helix PPA program';
        insert a;
        
        Contact c = TestFactory_StandardObjects.createPartnerContact(a.Id);
        insert c;
        
        User u = TestFactory_StandardObjects.createPartnerUser(c.Id, null);
        u.UserRoleId = null;
        u.PortalRole = 'Manager';
        return u;
    }
    
}