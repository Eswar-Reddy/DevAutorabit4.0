@isTest
private class TestAccountTrigger {

    @testSetup
    static void setup() {

        Installation_Model__c imTps = TestFactory_Invoices.createInstallationModel();
        imTps.Country__c = 'United States';
        imTps.Financing_Option__c = 'Lease';
        imTps.Partner__c = 'TPS';
        imTps.Roles__c = 'IP';

        Installation_Model__c imSpd = TestFactory_Invoices.createInstallationModel();
        imSpd.Country__c = 'United States';
        imSpd.Financing_Option__c = 'Cash';
        imSpd.Partner__c = 'SPD';
        imSpd.Roles__c = 'IP';

        Installation_Model__c imFr = TestFactory_Invoices.createInstallationModel();
        imFr.Country__c = 'France';
        imFr.Financing_Option__c = 'Cash';
        imFr.Partner__c = 'TPS';
        imFr.Roles__c = 'IP';

        Installation_Model__c imAu = TestFactory_Invoices.createInstallationModel();
        imAu.Country__c = 'Australia';
        imAu.Financing_Option__c = 'Cash';
        imAu.Partner__c = 'TPS';
        imAu.Roles__c = 'IP';

        List<Installation_Model__c> imList = new List<Installation_Model__c>{imTps, imSpd, imFr, imAu};
        insert imList;


        Invoice_Document_Data__c idd1 = TestFactory_Invoices.createInvoiceDocumentData();
        idd1.Name = 'Customer Signed Layout';
        idd1.Location__c = 'Account';

        Invoice_Document_Data__c idd2 = TestFactory_Invoices.createInvoiceDocumentData();
        idd2.Name = 'Customer Signed SRP Form';
        idd2.Location__c = 'Opportunity';

        Invoice_Document_Data__c idd3 = TestFactory_Invoices.createInvoiceDocumentData();
        idd3.Name = 'Origination Invoice';
        idd3.Location__c = 'Residential Project';

        Invoice_Document_Data__c idd4 = TestFactory_Invoices.createInvoiceDocumentData();
        idd4.Name = 'Signed Copy of Proposal';
        idd4.Location__c = 'Residential Project';

        Invoice_Document_Data__c idd5 = TestFactory_Invoices.createInvoiceDocumentData();
        idd5.Name = 'Facture de Consomation Electrique';
        idd5.Location__c = 'Residential Project';

        List<Invoice_Document_Data__c> iddList = new List<Invoice_Document_Data__c>{idd1, idd2, idd3, idd4, idd5};
        insert iddList;

        
        IDD_Junction__c ijTPS1CA = TestFactory_Invoices.createIM2IDDJunction(imTps.Id, idd1.Id);
        ijTPS1CA.State__c = 'CA';
        ijTPS1CA.Invoice_Type__c = 'Origination';

        IDD_Junction__c ijTPS2CA = TestFactory_Invoices.createIM2IDDJunction(imTps.Id, idd2.Id);
        ijTPS2CA.State__c = 'CA;NY';
        ijTPS2CA.Invoice_Type__c = 'Origination';

        IDD_Junction__c ijTPS3CA = TestFactory_Invoices.createIM2IDDJunction(imTps.Id, idd3.Id);
        ijTPS3CA.State__c = 'CA';
        ijTPS3CA.Invoice_Type__c = 'Origination';

        IDD_Junction__c ijTPS1NJ = TestFactory_Invoices.createIM2IDDJunction(imTps.Id, idd1.Id);
        ijTPS1NJ.State__c = 'FL';
        ijTPS1NJ.Invoice_Type__c = 'Origination';

        IDD_Junction__c ijSPD1CA = TestFactory_Invoices.createIM2IDDJunction(imSpd.Id, idd1.Id);
        ijSPD1CA.State__c = 'CA';
        ijSPD1CA.Invoice_Type__c = 'Origination';

        IDD_Junction__c ijFr1 = TestFactory_Invoices.createIM2IDDJunction(imFr.Id, idd1.Id);
        ijFr1.State__c = null;
        ijFr1.Invoice_Type__c = 'Origination';

        IDD_Junction__c ijFr4 = TestFactory_Invoices.createIM2IDDJunction(imFr.Id, idd4.Id);
        ijFr4.State__c = null;
        ijFr4.Invoice_Type__c = 'Origination';

        List<IDD_Junction__c> iddjList = new List<IDD_Junction__c>{ijTPS1CA, ijTPS2CA, ijTPS3CA, ijTPS1NJ, ijSPD1CA, ijFr1, ijFr4};
        insert iddjList;
    }

    @isTest
    static void testcreateOriginationDocumentsForAccounts() {
        //Test for AccountServices.createOriginationDocumentsForAccounts

        Account aCA = TestFactory_StandardObjects.createResidentialCustomerAccount();
        aCa.ShippingCountry = 'United States';
        aCa.ShippingState = 'CA';
        insert aCa;

        System.assertEquals(3,[SELECT Id FROM Origination_Document__c WHERE Account__c = :aCA.Id].size(), 'The Account should have three associated origination documents');

        aCa.Run_Origination_Docs_Trigger__c = true;
        update aCa;

        System.assertEquals(3,[SELECT Id FROM Origination_Document__c WHERE Account__c = :aCA.Id].size());
    }

    @isTest
    static void testcreateOriginationDocumentsFrance() {
        //Test for AccountServices.createOriginationDocumentsForAccounts

        Account aCa = TestFactory_StandardObjects.createResidentialCustomerAccount();
        aCa.ShippingState = null;
        aCa.ShippingCountry = 'France';
        aCa.BillingState = null;
        aCa.BillingCountry = 'France';

        insert aCa;

        System.assertEquals(2,[SELECT Id FROM Origination_Document__c WHERE Account__c = :aCA.Id].size(), 'The Account should have two associated origination documents');

        aCa.Run_Origination_Docs_Trigger__c = true;
        update aCa;

        System.assertEquals(3,[SELECT Id FROM Origination_Document__c WHERE Account__c = :aCA.Id].size());
    }

}