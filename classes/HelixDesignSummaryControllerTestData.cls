@isTest
public class HelixDesignSummaryControllerTestData {
    public Site_Information_Form__c site_1;
    public Roof_Design__c roofDesign_1;
    public Design__c design_1;
    public Document__c document_1;
    public EnergyProductionYr1__c ep_1;
    
    public void createTestData_googleMap() {
        site_1 = getNewSite();
        insert new List <Site_Information_Form__c>{site_1};

        roofDesign_1 = getNewRoofDesign();
        roofDesign_1.Design_DesignId__c = 'testDesignId';
        insert new List <Roof_Design__c>{roofDesign_1};
        
        design_1 = getNewDesign(site_1.Id);
        design_1.Roof_Design__c = roofDesign_1.Id;
        insert new List <Design__c>{design_1};
        
        document_1 = getNewDocument('document_1', design_1.Id);
        insert new List <Document__c>{document_1};
        
        ep_1 = getNewEnergyProduction(roofDesign_1.Id);
        insert new List <EnergyProductionYr1__c>{ep_1};
    }

    public void createTestData_png() {
        site_1 = getNewSite();
        insert new List <Site_Information_Form__c>{site_1};

        roofDesign_1 = getNewRoofDesign();
        roofDesign_1.Design_DesignId__c = 'testDesignId';
        insert new List <Roof_Design__c>{roofDesign_1};
        
        design_1 = getNewDesign(site_1.Id);
        design_1.Roof_Design__c = roofDesign_1.Id;
        insert new List <Design__c>{design_1};
        
        document_1 = getNewDocument('document_1', design_1.Id);
        document_1.Bucket_Name__c = 'testBucket';
        document_1.Content_Type__c = 'application/png';
        insert new List <Document__c>{document_1};

        ep_1 = getNewEnergyProduction(roofDesign_1.Id);
        insert new List <EnergyProductionYr1__c>{ep_1};
    }
    
    public static Site_Information_Form__c getNewSite() {
        Site_Information_Form__c site = new Site_Information_Form__c();
        return site;
    }
    
    public static Design__c getNewDesign(String siteId) {
        Design__c design = new Design__c();
        design.Site__c = siteId;
        return design;
    }
    
    public static Roof_Design__c getNewRoofDesign() {
        Roof_Design__c roofDesign = new Roof_Design__c();
        return roofDesign;
    }
    
    private static Document__c getNewDocument(String name, String designId) {
        Document__c doc = new Document__c();        
        doc.Name = name;
        doc.Design__c = designId;
        return doc;    
    }
    
    public static EnergyProductionYr1__c getNewEnergyProduction(String roofDesignId) {
        EnergyProductionYr1__c ep = new EnergyProductionYr1__c();
        ep.RoofDesign__c = roofDesignId;
        return ep;
    }

}