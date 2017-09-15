@isTest
public class DesignTriggerUtil_Test {
    private static final Id proposalDesignRTId = Schema.SObjectType.Design__c.getRecordTypeInfosByName().get('Proposal Design').getRecordTypeId();
    private static final Id projectDesignRTId = Schema.SObjectType.Design__c.getRecordTypeInfosByName().get('Project Design').getRecordTypeId();
    private static final Id systemOnlyDesignRTId = Schema.SObjectType.Design__c.getRecordTypeInfosByName().get('System Only').getRecordTypeId();

    private static testmethod void test_setInitialRevision() {
        Opportunity oppty_1 = getOpportunity();    
        Site_Information_Form__c site_1 = getSite(oppty_1.Id);
        Design__c design_11 = createDesign(site_1.Id, proposalDesignRTId, null);
        design_11.Revision_Letter__c = null;
        insert new List <Design__c>{design_11};
        DesignTriggerUtil.setInitialRevision(new List <Design__c>{design_11}); 
        system.assertEquals('A', design_11.Revision_Letter__c);   
    }

    private static testmethod void test_finalDesign_withoutExisting_oneNew() {
        Opportunity oppty_1 = getOpportunity();    
        Site_Information_Form__c site_1 = getSite(oppty_1.Id);
        Design__c design_11 = createDesign(site_1.Id, proposalDesignRTId, null, 'R-Helix Single Tilt', true);
        insert new List <Design__c>{design_11}; 
        system.assertEquals(true, [SELECT Final_Design__c FROM Design__c WHERE Id = :design_11.Id].Final_Design__c);   
    }

    private static testmethod void test_finalDesign_withExisting_oneNew() {
        Opportunity oppty_1 = getOpportunity();    
        Site_Information_Form__c site_1 = getSite(oppty_1.Id);
        Design__c design_11 = createDesign(site_1.Id, proposalDesignRTId, null, 'R-Helix Single Tilt', true);
        insert new List <Design__c>{design_11}; 
        system.assertEquals(true, [SELECT Final_Design__c FROM Design__c WHERE Id = :design_11.Id].Final_Design__c);   
        
        Design__c design_12 = createDesign(site_1.Id, proposalDesignRTId, null, 'R-Helix Single Tilt', true);
        DesignTriggerUtil.selectFinalDesign(new List <Design__c>{design_12});
        system.assertEquals(false, [SELECT Final_Design__c FROM Design__c WHERE Id = :design_11.Id].Final_Design__c);   
        system.assertEquals(true, design_12.Final_Design__c);   
    }

    private static testmethod void test_finalDesign_withoutExisting_twoNew() {
        Opportunity oppty_1 = getOpportunity();    
        Site_Information_Form__c site_1 = getSite(oppty_1.Id);
        Design__c design_11 = createDesign(site_1.Id, proposalDesignRTId, null, 'R-Helix Single Tilt', true);
        Design__c design_12 = createDesign(site_1.Id, proposalDesignRTId, null, 'R-Helix Single Tilt', true);
        insert new List <Design__c>{design_11, design_12}; 
        system.assertEquals(true, [SELECT Final_Design__c FROM Design__c WHERE Id = :design_11.Id].Final_Design__c);   
        system.assertEquals(false, [SELECT Final_Design__c FROM Design__c WHERE Id = :design_12.Id].Final_Design__c);   
    }

    private static testmethod void test_finalDesign_withoutExisting_twoTechSys() {
        Opportunity oppty_1 = getOpportunity();    
        Site_Information_Form__c site_1 = getSite(oppty_1.Id);
        Design__c design_11 = createDesign(site_1.Id, proposalDesignRTId, null, 'R-Helix Single Tilt', true);
        Design__c design_12 = createDesign(site_1.Id, proposalDesignRTId, null, 'R-Helix Dual Tilt', true);
        insert new List <Design__c>{design_11, design_12}; 
        system.assertEquals(true, [SELECT Final_Design__c FROM Design__c WHERE Id = :design_11.Id].Final_Design__c);   
        system.assertEquals(true, [SELECT Final_Design__c FROM Design__c WHERE Id = :design_12.Id].Final_Design__c); 
    }

    private static testmethod void test_finalDesign_withoutExisting_twoRT() {
        Opportunity oppty_1 = getOpportunity();    
        Site_Information_Form__c site_1 = getSite(oppty_1.Id);
        Design__c design_11 = createDesign(site_1.Id, proposalDesignRTId, null, 'R-Helix Single Tilt', true);
        Design__c design_12 = createDesign(site_1.Id, projectDesignRTId, null, 'R-Helix Single Tilt', true);
        insert new List <Design__c>{design_11, design_12}; 
        system.assertEquals(true, [SELECT Final_Design__c FROM Design__c WHERE Id = :design_11.Id].Final_Design__c);   
        system.assertEquals(true, [SELECT Final_Design__c FROM Design__c WHERE Id = :design_12.Id].Final_Design__c); 
    }

    private static testmethod void test_finalDesign_withoutExisting_twoSite() {
        Opportunity oppty_1 = getOpportunity();    
        Site_Information_Form__c site_1 = getSite(oppty_1.Id);
        Site_Information_Form__c site_2 = getSite(oppty_1.Id);
        Design__c design_11 = createDesign(site_1.Id, proposalDesignRTId, null, 'R-Helix Single Tilt', true);
        Design__c design_21 = createDesign(site_2.Id, proposalDesignRTId, null, 'R-Helix Single Tilt', true);
        insert new List <Design__c>{design_11, design_21}; 
        system.assertEquals(true, [SELECT Final_Design__c FROM Design__c WHERE Id = :design_11.Id].Final_Design__c);   
        system.assertEquals(true, [SELECT Final_Design__c FROM Design__c WHERE Id = :design_21.Id].Final_Design__c); 
    }

    private static testmethod void test_setOpportunitySystemSize_systemOnly() {
        Opportunity oppty_1 = getOpportunity();    
        Site_Information_Form__c site_1 = getSite(oppty_1.Id);
        Design__c design_11 = createDesign(site_1.Id, systemOnlyDesignRTId, oppty_1.Id);
        design_11.Actual_System_Size__c = 700;
        insert new List <Design__c>{design_11}; 
        system.assertEquals(700, [SELECT System_Size_KwP__c FROM Opportunity WHERE Id = :oppty_1.Id].System_Size_KwP__c);   
    }

    private static testmethod void test_setOpportunitySystemSize() {
        Opportunity oppty_1 = getOpportunity();    
        Site_Information_Form__c site_1 = getSite(oppty_1.Id);
        Design__c design_11 = createDesign(site_1.Id, proposalDesignRTId, oppty_1.Id, 100, true);
        Design__c design_12 = createDesign(site_1.Id, proposalDesignRTId, oppty_1.Id, 200, true);
        Design__c design_13 = createDesign(site_1.Id, proposalDesignRTId, oppty_1.Id, 400, false);
        Design__c design_14 = createDesign(site_1.Id, systemOnlyDesignRTId, oppty_1.Id);
        design_14.Actual_System_Size__c = 700;
        Design__c design_15 = createDesign(site_1.Id, projectDesignRTId, oppty_1.Id, 500, true);
        Design__c design_16 = createDesign(site_1.Id, projectDesignRTId, oppty_1.Id, 600, false);
        insert new List <Design__c>{design_11, design_12, design_13, design_14, design_15, design_16}; 
        system.assertEquals(1500, [SELECT System_Size_KwP__c FROM Opportunity WHERE Id = :oppty_1.Id].System_Size_KwP__c);   
    }
    
    private static testmethod void test_deleteFinalDesign() {
        Opportunity oppty_1 = getOpportunity();    
        Site_Information_Form__c site_1 = getSite(oppty_1.Id);
        Design__c design_11 = createDesign(site_1.Id, proposalDesignRTId, oppty_1.Id, 'R-Helix Single Tilt', true);
        insert new List <Design__c>{design_11}; 
        Database.DeleteResult dr = Database.delete(design_11, false);
        system.assertEquals(false, dr.isSuccess());  // You cannot delete final design 
    }

    private static testmethod void test_validateFinalDesign_siteNull() {
        Opportunity oppty_1 = getOpportunity();    
        Site_Information_Form__c site_1 = getSite(oppty_1.Id);
        Design__c design_11 = createDesign(null, proposalDesignRTId, oppty_1.Id, 'R-Helix Single Tilt', true);
        Database.SaveResult sr = Database.insert(design_11, false);
        system.assertEquals(false, sr.isSuccess());  // You cannot pick this design as your final one, since there is no site associated with it 
    }

    private static testmethod void test_validateStatusCompletedFields() {
        Opportunity oppty_1 = createOpportunity();  
        oppty_1.Contract_Type__c = 'PPA';
        insert oppty_1;  
        Site_Information_Form__c site_1 = getSite(oppty_1.Id);
        Design__c design_11 = createDesign(site_1.Id, proposalDesignRTId, oppty_1.Id);
        design_11.Actual_System_Size__c = null;
        design_11.Actual_Annual_Production__c = null;
        design_11.Module_Quantity__c = null;
        design_11.ModuleTypeandWattage__c = null;
        design_11.Technology_System__c = null;
        insert design_11;
        system.assertEquals(null, design_11.Actual_System_Size__c);
        system.assertEquals(null, design_11.Actual_Annual_Production__c);
        system.assertEquals(null, design_11.Module_Quantity__c);
        system.assertEquals(null, design_11.ModuleTypeandWattage__c);
        system.assertEquals(null, design_11.Technology_System__c);
        DesignTriggerUtil.validateStatusCompletedFields(new Map<Id, Design__c>{design_11.Id => design_11});
    }

    private static testmethod void test_validateEnergyProduction_withoutEP() {
        User pu_1 = createPartnerUser();
        pu_1.UserRoleId = null;
        pu_1.PortalRole = 'Manager';
        // avoid error MIXED_DML_OPERATION, DML operation on setup object is not permitted after you have updated 
        // a non-setup object (or vice versa): User, original object: AccountShare
        UserManagement.IS_TEST = true;
        insert pu_1;
        
        Opportunity oppty_1 = createOpportunity();  
        oppty_1.Contract_Type__c = 'PPA';
        oppty_1.OwnerId = pu_1.Id;
        insert oppty_1;
          
        Site_Information_Form__c site_1 = getSite(oppty_1.Id);
        Design__c design_11 = createDesign(site_1.Id, proposalDesignRTId, oppty_1.Id);
        insert design_11;
        DesignTriggerUtil.validateEnergyProduction(new Map<Id, Design__c>{design_11.Id => design_11});
    }

    private static testmethod void test_validateEnergyProduction_withEP() {
        User pu_1 = createPartnerUser();
        pu_1.UserRoleId = null;
        pu_1.PortalRole = 'Manager';
        // avoid error MIXED_DML_OPERATION, DML operation on setup object is not permitted after you have updated 
        // a non-setup object (or vice versa): User, original object: AccountShare
        UserManagement.IS_TEST = true;
        insert pu_1;
        
        Opportunity oppty_1 = createOpportunity();  
        oppty_1.Contract_Type__c = 'PPA';
        oppty_1.OwnerId = pu_1.Id;
        insert oppty_1;
          
        Site_Information_Form__c site_1 = getSite(oppty_1.Id);
        Design__c design_11 = createDesign(site_1.Id, proposalDesignRTId, oppty_1.Id);
        insert design_11;
        
        EnergyProductionYr1__c ep_1 = getEnergyProduction(design_11.Id, new List <Decimal>{100,100,100,100,100,100,100,100,100,100,100,100});
        
        DesignTriggerUtil.validateEnergyProduction(new Map<Id, Design__c>{design_11.Id => design_11});
    }
    
    private static Opportunity createOpportunity() {
        Opportunity oppty = TestFactory_Commercial.createNewCvarCustomer(null, null).clone(); 
        return oppty;   
    }
    private static Opportunity getOpportunity() {
        Opportunity oppty = TestFactory_Commercial.createNewCvarCustomer(null, null).clone(); 
        insert oppty;
        return oppty;   
    }
    private static Site_Information_Form__c getSite(Id OpportunityId) {
        Site_Information_Form__c site = TestFactory_Commercial.createBasicSite(OpportunityId).clone(); 
        insert site;
        return site;   
    }
    private static Design__c createDesign(Id siteId, Id recordTypeId, Id opportunityId) {
        Design__c design = (Design__c)SmartFactory.createSObject('Design__c',false); 
        design.Site__c = siteId;
        design.RecordTypeId = recordTypeId;
        design.Opportunity__c = opportunityId;
        return design;   
    }
    private static Design__c createDesign(Id siteId, Id recordTypeId, Id opportunityId, String technologySystem, Boolean finalDesign) {
        Design__c design = createDesign(siteId, recordTypeId, opportunityId);
        design.Technology_System__c = technologySystem;
        design.Final_Design__c = finalDesign;
        return design;   
    }
    private static Design__c createDesign(Id siteId, Id recordTypeId, Id opportunityId, Decimal actualSystemSize, Boolean finalDesign) {
        Design__c design = createDesign(siteId, recordTypeId, opportunityId);
        design.Actual_System_Size__c = actualSystemSize;
        design.Final_Design__c = finalDesign;
        return design;   
    }
    
    private static EnergyProductionYr1__c getEnergyProduction(Id designId, List <Decimal> values) {
        EnergyProductionYr1__c ep = (EnergyProductionYr1__c)SmartFactory.createSObject('EnergyProductionYr1__c',false);
        ep.Design__c = designId;
        ep.Jan__c = values[0];
        ep.Feb__c = values[1];
        ep.Mar__c = values[2];
        ep.Apr__c = values[3];
        ep.May__c = values[4];
        ep.Jun__c = values[5];
        ep.Jul__c = values[6];
        ep.Aug__c = values[7];
        ep.Sep__c = values[8];
        ep.Oct__c = values[9];
        ep.Nov__c = values[10];
        ep.Dec__c = values[11];
        insert ep;
        return ep;
    }
    
    private static User createPartnerUser() {
        Contact c = TestFactory_StandardObjects.getPartnerContact();
        return TestFactory_StandardObjects.createPartnerUser(c.Id, null);
    }
}