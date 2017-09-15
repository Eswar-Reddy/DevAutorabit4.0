@isTest
public class TestFactory_Commercial {
    
    //static string variables
    public static String designExported = 'Design Exported';
    public static String designDelivered = 'Design Delivered';
    public static String designCompleted = 'Completed';
    public static String indirect = 'Indirect';


    //static records
    public static Account cvarPartnerAccount;
    public static Opportunity cvarOpportunity;
    public static Site_Information_Form__c cvarSite;
    public static Design__c cvarDesign;
    public static EnergyProductionYr1__c auroraProduction;
    public static Roof_Design__c cvarRoofDesign;
    public static Quote ppaQuote;
    public static Cost_Matrix__c costMatrix;
    public static Product2 product;
    public static Annual_Financial__c annualFinancial;

    public static Id retrievePartnerAcctId(Id partnerId) {
        if(partnerId != null) return partnerId;
        else if(cvarPartnerAccount != null && cvarPartnerAccount.Id != null) return cvarPartnerAccount.Id;
        else return TestFactory_StandardObjects.getPartnerAccount().Id;
    }

    //get opportunity basic - NO INSERT
    public static Opportunity createNewCVARCustomer(Id partnerId, Id customerAccountId) {

        partnerId = retrievePartnerAcctId(partnerId);
        
        if(customerAccountId == null) customerAccountId = TestFactory_StandardObjects.getCommercialCustomerAccount().Id;
        if(cvarOpportunity == null) cvarOpportunity = TestFactory_StandardObjects.createCvarOpportunity(partnerId, customerAccountId);

        return cvarOpportunity;
    }

    //get opportunity basic - WITH INSERT
    public static Opportunity getNewCvarCustomer(Id partnerId, Id customerAccountId) {
        if(cvarOpportunity == null)
            insert createNewCVARCustomer(partnerId, customerAccountId);
        return cvarOpportunity;
    }

    //get site basic - NO INSERT
    public static Site_Information_Form__c createBasicSite(Id oppId) {
        if(oppId == null) oppId = getNewCvarCustomer(null, null).Id;

        if(cvarSite == null) {
            cvarSite = (Site_Information_Form__c)SmartFactory.createSObject('Site_Information_Form__c',false);
            cvarSite.Opportunity_del__c = oppId;
        }

        return cvarSite;
    }

    //get site basic - WITH INSERT
    public static Site_Information_Form__c getBasicSite(Id oppId) {
        if(cvarSite == null)
            insert createBasicSite(oppId);
        return cvarSite;
    }

    //get site w/ complete address - NO INSERT
    public static Site_Information_Form__c createFullSite(Id oppId, String state) {
        if(oppId == null) oppId = getNewCvarCustomer(null, null).Id;

        if(cvarSite == null) {
            cvarSite = (Site_Information_Form__c)SmartFactory.createSObject('Site_Information_Form__c',false);
            cvarSite.Site_State__c = state == null ? SmartFactory.DefaultState : state;
            cvarSite.Site_Country__c = SmartFactory.DefaultCountry;
            cvarSite.RecordTypeId = Schema.SObjectType.Site_Information_Form__c.getRecordTypeInfosByName().get('Standard Site').getRecordTypeId();
            cvarSite.Opportunity_del__c = oppId;
        } 

        return cvarSite;
    }

    //get site w/ complete address - WITH INSERT
    public static Site_Information_Form__c getFullSite(Id oppId, String state) {
        if(cvarSite == null || (cvarSite != null && cvarSite.Site_State__c == null))
            insert createFullSite(oppId, state);
        return cvarSite;
    }

    //get Proposal Design Record Type design associated to Site and Opportunity - NO INSERT
    public static Design__c createProposalDesign(Id oppId, Id siteId) {
        if(oppId == null) oppId = getNewCvarCustomer(null, null).Id;
        if(siteId == null) siteId = getFullSite(oppId, null).Id;
        if(cvarDesign == null) {
            cvarDesign = (Design__c)SmartFactory.createSObject('Design__c',false);
            cvarDesign.RecordTypeId = Schema.SObjectType.Design__c.getRecordTypeInfosByName().get('Proposal Design').getRecordTypeId();
            cvarDesign.Opportunity__c = oppId;
            cvarDesign.Site__c = siteId;
        }
        return cvarDesign;
    }

    //get Proposal Design Record Type design associated to Site and Opportunity - WITH INSERT
    public static Design__c getProposalDesign(Id oppId, Id siteId) {
        if(cvarDesign == null)
            insert createProposalDesign(oppId, siteId);

        return cvarDesign;
    }

    //get full HDR Design, not completed/approved
    public static Design__c createDesignRequest(Id oppId, Id siteId) {
        if(oppId == null) oppId = getNewCvarCustomer(null, null).Id;
        if(siteId == null) siteId = getFullSite(oppId, null).Id;
        if(cvarDesign == null) {
            cvarDesign = createProposalDesign(oppId, siteId);
            cvarDesign.Design_Originated_by__c = 'Request';
            cvarDesign.DealerName__c = retrievePartnerAcctId(null);
            insert cvarDesign;
        }

        auroraProduction = getDesignConsumption(cvarDesign.Id, null);

        return cvarDesign;
    }

    //get full HDR Design, not completed/approved - WITH INSERT
    public static Design__c getDesignRequest(Id oppId, Id siteId) {
        if(cvarDesign == null)
            cvarDesign = createDesignRequest(oppId, siteId);

        return cvarDesign;
    }

    //get jan-dec energy production associated to design &/or roof design - NO INSERT
    private static EnergyProductionYr1__c createDesignConsumption(Id designId, Id roofDesignId) {

        if(designId == null) designId = getProposalDesign(null,null).Id;
        
        if(auroraProduction == null) {
            auroraProduction = (EnergyProductionYr1__c)SmartFactory.createSObject('EnergyProductionYr1__c',false);
            auroraProduction.Design__c = designId;
            auroraProduction.RoofDesign__c = roofDesignId;
        }

        return auroraProduction;
    }

    //get jan-dec energy production associated to design &/or roof design - WITH INSERT
    private static EnergyProductionYr1__c getDesignConsumption(Id designId, Id roofDesignId) {

        if(designId == null) designId = getProposalDesign(null,null).Id;
        
        if(auroraProduction == null) {
            auroraProduction = createDesignConsumption(designId, roofDesignId);
            insert auroraProduction;
        }

        return auroraProduction;
    }

    //get commercial roof design - NO INSERT
    private static Roof_Design__c createRoofDesignCommercial(Id designId) {
        if(designId == null) designId = getProposalDesign(null,null).Id;

        if(cvarRoofDesign == null) {
            cvarRoofDesign = (Roof_Design__c)SmartFactory.createSObject('Roof_Design__c',false);
            cvarRoofDesign.RecordTypeId = Schema.SObjectType.Design__c.getRecordTypeInfosByName().get('Commercial Design').getRecordTypeId();
            cvarRoofDesign.Design__c = designId;
            cvarRoofDesign.Integration_Status__c = 'Success';
        }

        return cvarRoofDesign;
    }

    //get commercial roof design - WITH INSERT
    private static Roof_Design__c getRoofDesignCommercial(Id designId) {
        if(designId == null) designId = getProposalDesign(null,null).Id;

        if(cvarRoofDesign == null) {
            cvarRoofDesign = createRoofDesignCommercial(designId);
            insert cvarRoofDesign;
        }

        return cvarRoofDesign;
    }

    public static Quote createPPAQuote(Id oppId) {

        if(oppId == null) oppId = getNewCvarCustomer(null, null).Id;
        
        if(ppaQuote == null) {
            ppaQuote = (Quote)SmartFactory.createSObject('Quote');
            ppaQuote.OpportunityId = oppId;
            //for now need to loop cause new record type
            for(RecordType t : [SELECT Id FROM RecordType WHERE SObjectType = 'Quote' AND DeveloperName = 'Commercial_Quote' LIMIT 1]) {
                ppaQuote.RecordTypeId = t.Id;
                break;
            }
            //set ppa specific fields
            //TODO
        }
        return ppaQuote;
    }

    public static Quote getPPAQuote(Id oppId) {

        if(oppId == null) oppId = getNewCvarCustomer(null, null).Id;
        if(ppaQuote == null) 
            insert createPPAQuote(oppId);
            
        return ppaQuote;
    }

    //get PPA quote and quote designs - NO INSERT (todo: separate quote)
    public static Quote createPPAQuoteWithJunctions(Set<String> designIds, Id oppId) {
        if(oppId == null) oppId = getNewCvarCustomer(null, null).Id;
        if(designIds == null) {
            designIds = new Set<String>();
            designIds.add(createDesignRequest(oppId, null).Id);
        }

        if(ppaQuote == null) ppaQuote = getPPAQuote(oppId);
        List<Quote_Design__c> quotedesigns = new List<Quote_Design__c>();
        for(Id i : designIds) {
            quotedesigns.add(createQuoteDesign(i, ppaQuote.Id));
        }
        insert quotedesigns;

        return ppaQuote;
    }

    //create quote design - NO INSERT, Requires valid ids (todo: fix later)
    public static Quote_Design__c createQuoteDesign(Id designId, Id quoteId) {
        Quote_Design__c qd = (Quote_Design__c)SmartFactory.createSObject('Quote_Design__c');
        qd.Design__c = designId;
        qd.Quote__c = quoteId;
        return qd;
    }

    public static Cost_Matrix__c createCostMatrix(Id salesConfigId) {
        if(salesConfigId == null) salesConfigId = getPPASalesConfiguration(null, null).Id;
        costMatrix = (Cost_Matrix__c)SmartFactory.createSObject('Cost_Matrix__c');
        costMatrix.Sales_Configuration__c = salesConfigId;
        return costMatrix;
    }

    public static Cost_Matrix__c getCostMatrix(Id salesConfigId) {

        if(costMatrix == null) {
            costMatrix = createCostMatrix(salesConfigId);
            insert costMatrix;
        }
        return costMatrix;
    }

    public static Master_Configurator__c getPPAMasterConfiguration() {
        Master_Configurator__c m = TestFactory_Configurations.createMasterConfig();
        m.Name = 'PPA Cost Matrix';
        m.Configuration_Model__c = 'PPA';
        insert m;
        return m;
    }

    public static SalesConfiguration__c getPPASalesConfiguration(Id masterId, String state) {
        if(masterId == null) masterId = getPPAMasterConfiguration().Id;
        if(String.isBlank(state)) state = SmartFactory.DefaultState;

        SalesConfiguration__c s = TestFactory_Configurations.createSalesConfiguration(masterId);
        s.Configurator__c = masterId;
        s.State__c = state;
        s.Channel__c = indirect;
        s.Financial_Offering__c = 'PPA';
        s.Operating_Unit__c = 'SPNA OU';
        s.SalesMethodology__c = 'Quote';
        s.Sector__c = 'Commercial';
        s.System_Commissioning__c = 5000;

        insert s;
        return s;
    }

    public static Product2 createProduct() {
        if (product == null) {
            product = (Product2)SmartFactory.createSObject('Product2');
            product.Cost__c = 100;
        }
        return product;
    }
    
    public static Annual_Financial__c createAnnualFinancial(Id quoteId) {
        if (annualFinancial == null) {
            annualFinancial = (Annual_Financial__c)SmartFactory.createSObject('Annual_Financial__c');
            annualFinancial.Quote__c = quoteId;
        }
        return annualFinancial;
    }

    public static Annual_Financial__c getAnnualFinancial(Id quoteId) {
        if (annualFinancial == null) {
            annualFinancial = createAnnualFinancial(quoteId);
            insert annualFinancial;
        }
        return annualFinancial;
    }

    //manually close a design request
    public static Design__c closeDesignRequest(Design__c design, Boolean calculateConsumption) {
        design.Status__c = designCompleted;
        design.Dealer_Status__c = designDelivered;

        if(calculateConsumption) {
            design.Actual_Annual_Production__c = calculatedConsumption();
        }
        
        return design;
    }

    public static Design__c closeDesignExport(Design__c design, Boolean calculateConsumption) {
        design.Status__c = designExported;
        design.Dealer_Status__c = designExported;
        design.Design_Originated_By__C = indirect;

        if(calculateConsumption) {
            design.Actual_Annual_Production__c = calculatedConsumption();
        }
        
        return design;
    }

    private static Integer calculatedConsumption() {
        Integer result = 0;
        if(auroraProduction == null) return result;
        Decimal totalWatts = auroraProduction.Jan__c + auroraProduction.Feb__c + auroraProduction.Mar__c + auroraProduction.Apr__c 
                            + auroraProduction.May__c + auroraProduction.Jun__c + auroraProduction.Jul__c + auroraProduction.Aug__c 
                            + auroraProduction.Sep__c + auroraProduction.Oct__c + auroraProduction.Nov__c + auroraProduction.Dec__c;
        return Integer.valueOf(totalWatts);//need to divide here?
    }
}