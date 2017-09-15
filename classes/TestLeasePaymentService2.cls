@isTest
public class TestLeasePaymentService2 {

	@isTest
	private static void leasePaymentStatusTest(){

		Id accntId = [SELECT Id FROM Account LIMIT 1].Id;
		Id optyId = [SELECT Id FROM Opportunity LIMIT 1].Id;
		Id quoteId = [SELECT Id FROM Quote LIMIT 1].Id;

		LeasePayment__c lp1 = TestFactory_Invoices.createLeasePayment(accntId, optyId, quoteId);
		lp1.Site_State_Prov_old__c = 'CA';
		insert lp1;

		LeasePayment__c lpRes = [SELECT Id, Install_Invoice_Docs_Required__c, Interconnect_Invoice_Docs_Required__c, Reason_for_Cancellation__c, Status__c FROM LeasePayment__c WHERE Id = :lp1.Id];

        System.assertEquals(1, lpRes.Install_Invoice_Docs_Required__c);
        System.assertEquals(2, lpRes.Interconnect_Invoice_Docs_Required__c);

        List<Invoice_Documents__c> installdocs = [SELECT Id, Documents_in_File__c, Lease_Payment__c FROM Invoice_Documents__c WHERE Lease_Payment__c = :lpRes.Id];
        System.assertEquals(3, installdocs.size());


        lpRes.Install_Invoice_Docs_Required__c = 0;
        lpRes.Interconnect_Invoice_Docs_Required__c = 0;
        lpRes.Status__c = 'Cancelled';
        lpRes.Reason_for_Cancellation__c = 'Because';
        update lpRes;

        delete installdocs;


		LeasePayment__c lpRes1 = [SELECT Id, Install_Invoice_Docs_Required__c, Interconnect_Invoice_Docs_Required__c, Reason_for_Cancellation__c, Status__c FROM LeasePayment__c WHERE Id = :lp1.Id];

        System.assertEquals(0, lpRes1.Install_Invoice_Docs_Required__c);
        System.assertEquals(0, lpRes1.Interconnect_Invoice_Docs_Required__c);

        List<Invoice_Documents__c> installdocs1 = [SELECT Id, Documents_in_File__c, Lease_Payment__c FROM Invoice_Documents__c WHERE Lease_Payment__c = :lpRes.Id];
        System.assertEquals(0, installdocs1.size());


	}

	@isTest
	private static void nullJunctionStateTest(){

		Id accntId = [SELECT Id FROM Account LIMIT 1].Id;
		Id optyId = [SELECT Id FROM Opportunity LIMIT 1].Id;
		Id quoteId = [SELECT Id FROM Quote LIMIT 1].Id;
		IDD_Junction__c junc = [SELECT Id FROM IDD_Junction__c WHERE State__c = 'CA;NY' LIMIT 1];
		junc.State__c = null;
		update junc;

		//Test null State
		LeasePayment__c lp1 = TestFactory_Invoices.createLeasePayment(accntId, optyId, quoteId);
		lp1.Site_State_Prov_old__c = 'CA';
		insert lp1;

		LeasePayment__c lpRes = [SELECT Id, Install_Invoice_Docs_Required__c, Interconnect_Invoice_Docs_Required__c FROM LeasePayment__c WHERE Id = :lp1.Id];

        System.assertEquals(1, lpRes.Install_Invoice_Docs_Required__c);
        System.assertEquals(2, lpRes.Interconnect_Invoice_Docs_Required__c);

        List<Invoice_Documents__c> installdocs = [SELECT Id, Documents_in_File__c, Lease_Payment__c FROM Invoice_Documents__c WHERE Lease_Payment__c = :lpRes.Id];
        System.assertEquals(3, installdocs.size());
	}

	@isTest
	private static void countryTest(){

		Id accntId = [SELECT Id FROM Account LIMIT 1].Id;
		Id optyId = [SELECT Id FROM Opportunity LIMIT 1].Id;
		Id imId = [SELECT Id FROM Installation_Model__c WHERE Country__c = 'France' LIMIT 1].Id;
		Quote qt = [SELECT Id, Installation_Model__c FROM Quote LIMIT 1];
		qt.Installation_Model__c = imId;
		update qt;

		LeasePayment__c lp1 = TestFactory_Invoices.createLeasePayment(accntId, optyId, qt.Id);
		lp1.Site_State_Prov_old__c = null;
		insert lp1;

		LeasePayment__c lpRes = [SELECT Id, Install_Invoice_Docs_Required__c, Interconnect_Invoice_Docs_Required__c FROM LeasePayment__c WHERE Id = :lp1.Id];

        System.assertEquals(0, lpRes.Install_Invoice_Docs_Required__c);
        System.assertEquals(2, lpRes.Interconnect_Invoice_Docs_Required__c);

        List<Invoice_Documents__c> installdocs = [SELECT Id, Documents_in_File__c, Lease_Payment__c FROM Invoice_Documents__c WHERE Lease_Payment__c = :lpRes.Id];
        System.assertEquals(2, installdocs.size());
	}

	@isTest
	private static void locationTest(){
	    //REMOVE AFTER INV DOC OPTIMIZATION - Location workaround functionality 

		Id accntId = [SELECT Id FROM Account LIMIT 1].Id;
		Id optyId = [SELECT Id FROM Opportunity LIMIT 1].Id;
		Id quoteId = [SELECT Id FROM Quote LIMIT 1].Id;

		Residential_Project__c rp = TestFactory_ResidentialProjMgmt.createTPSProject(accntId, optyId, quoteId);
		insert rp;

		List<Document__c> docs = TestFactory_ResidentialProjMgmt.createProjectDocuments(rp.Id, 3);
		docs[0].Document_Type__c = 'Commissioning Report';
		docs[0].Account__c = accntId;
		docs[0].Residential_Project__c = null;
		docs[1].Document_Type__c = 'Final Permit';
		docs[1].Opportunity__c = optyId;
		docs[1].Residential_Project__c = null;
		docs[2].Document_Type__c = 'Photos';
		insert docs;

		List<Attachment> atts = new List<Attachment>{	new Attachment(Name='Test1', ParentId=docs[0].Id, Body=Blob.valueOf('TestBody')),
														new Attachment(Name='Test2', ParentId=docs[1].Id, Body=Blob.valueOf('TestBody')),
														new Attachment(Name='Test3', ParentId=docs[2].Id, Body=Blob.valueOf('TestBody'))};
		insert atts; 

		LeasePayment__c lp1 = TestFactory_Invoices.createLeasePayment(accntId, optyId, quoteId);
		lp1.Site_State_Prov_old__c = 'CA';
		insert lp1;

		System.assertEquals(3,[SELECT Id FROM Invoice_Documents__c WHERE Lease_Payment__c = :lp1.Id].size());
	}

	@isTest
	private static void partnerTest(){
		Id accntId = [SELECT Id FROM Account LIMIT 1].Id;
		Id optyId = [SELECT Id FROM Opportunity LIMIT 1].Id;
		Id quoteId = [SELECT Id FROM Quote LIMIT 1].Id;
		Id iddId = [SELECT Id FROM Invoice_Document_Data__c WHERE Name = 'Shading Report' LIMIT 1].Id;
		Id partnerId = TestFactory_StandardObjects.getPartnerAccount().Id;

		IDD_Junction__c ij = TestFactory_Invoices.createPartner2IDDJunction(partnerId, iddId);
		ij.State__c = 'CA';
		ij.Invoice_Type__c = 'Interconnect';
		ij.System_Type__c = 'AC;DC';
		insert ij; 

		LeasePayment__c lp1 = TestFactory_Invoices.createLeasePayment(accntId, optyId, quoteId);
		lp1.Site_State_Prov_old__c = 'CA';
		lp1.Partner_Account__c = partnerId;
		insert lp1;
		System.assertEquals(4,[SELECT Id FROM Invoice_Documents__c WHERE Lease_Payment__c = :lp1.Id].size());
		LeasePayment__c lpTest = [SELECT Id, Install_Invoice_Docs_Required__c, Interconnect_Invoice_Docs_Required__c FROM LeasePayment__c WHERE Id =: lp1.Id];
		System.assertEquals(3, lpTest.Interconnect_Invoice_Docs_Required__c);
		System.assertEquals(1, lpTest.Install_Invoice_Docs_Required__c);

	}

	@isTest
	private static void partnerTestNegative(){
		Id accntId = [SELECT Id FROM Account LIMIT 1].Id;
		Id optyId = [SELECT Id FROM Opportunity LIMIT 1].Id;
		Id quoteId = [SELECT Id FROM Quote LIMIT 1].Id;
		Id iddId = [SELECT Id FROM Invoice_Document_Data__c WHERE Name = 'Shading Report' LIMIT 1].Id;
		Id partnerId = TestFactory_StandardObjects.getPartnerAccount().Id;
		Account partner2 = TestFactory_StandardObjects.createPartnerAccount();
		insert partner2;

		IDD_Junction__c ij = TestFactory_Invoices.createPartner2IDDJunction(partnerId, iddId);
		ij.State__c = 'CA';
		ij.Invoice_Type__c = 'Interconnect';
		ij.System_Type__c = 'AC;DC';
		insert ij; 

		LeasePayment__c lp1 = TestFactory_Invoices.createLeasePayment(accntId, optyId, quoteId);
		lp1.Site_State_Prov_old__c = 'CA';
		lp1.Partner_Account__c = partner2.Id;
		insert lp1;

		System.assertEquals(3,[SELECT Id FROM Invoice_Documents__c WHERE Lease_Payment__c = :lp1.Id].size());
		LeasePayment__c lpTest = [SELECT Id, Install_Invoice_Docs_Required__c, Interconnect_Invoice_Docs_Required__c FROM LeasePayment__c WHERE Id =: lp1.Id];
		System.assertEquals(2, lpTest.Interconnect_Invoice_Docs_Required__c);
		System.assertEquals(1, lpTest.Install_Invoice_Docs_Required__c);

	}

	@isTest
	private static void partnerIMTest(){
		Id accntId = [SELECT Id FROM Account LIMIT 1].Id;
		Id optyId = [SELECT Id FROM Opportunity LIMIT 1].Id;
		Id quoteId = [SELECT Id FROM Quote LIMIT 1].Id;
		Id iddId = [SELECT Id FROM Invoice_Document_Data__c WHERE Name = 'Shading Report' LIMIT 1].Id;
		Id imId = [SELECT Id FROM Installation_Model__c WHERE Name = 'TPS Lease IP Only' LIMIT 1].Id;

		List<Account> accs = new List<Account>();
		for(Integer i=0 ; i <5; i++){
			Account partner = TestFactory_StandardObjects.createPartnerAccount();
			accs.add(partner);
		}
		insert accs;

		
		List<IDD_Junction__c> juncs = new List<IDD_Junction__c>();
		for(Account a : accs){
			IDD_Junction__c ij = TestFactory_Invoices.createPartner2IDDJunction(a.Id, iddId);
			ij.State__c = 'CA';
			ij.Invoice_Type__c = 'Interconnect';
			ij.System_Type__c = 'AC;DC';
			ij.Installation_Model__c = imId;
			juncs.add(ij);
		}
		insert juncs;

		LeasePayment__c lp1 = TestFactory_Invoices.createLeasePayment(accntId, optyId, quoteId);
		lp1.Site_State_Prov_old__c = 'CA';
		lp1.Partner_Account__c = accs[0].Id;
		insert lp1;

		System.assertEquals(4,[SELECT Id FROM Invoice_Documents__c WHERE Lease_Payment__c = :lp1.Id].size());
		LeasePayment__c lpTest = [SELECT Id, Install_Invoice_Docs_Required__c, Interconnect_Invoice_Docs_Required__c FROM LeasePayment__c WHERE Id =: lp1.Id];
		System.assertEquals(3, lpTest.Interconnect_Invoice_Docs_Required__c);
		System.assertEquals(1, lpTest.Install_Invoice_Docs_Required__c);

	}

	@isTest
	private static void systemTypeTest(){
		Id accntId = [SELECT Id FROM Account LIMIT 1].Id;
		Id optyId = [SELECT Id FROM Opportunity LIMIT 1].Id;
		Id quoteId = [SELECT Id FROM Quote LIMIT 1].Id;
		Id iddId = [SELECT Id FROM Invoice_Document_Data__c WHERE Name = 'Shading Report' LIMIT 1].Id;
		Id imId = [SELECT Id FROM Installation_Model__c WHERE Name = 'TPS Lease IP Only' LIMIT 1].Id;

		IDD_Junction__c ij = TestFactory_Invoices.createIM2IDDJunction(imId, iddId);
		ij.State__c = 'CA';
		ij.Invoice_Type__c = 'Interconnect';
		ij.System_Type__c = 'AC';
		insert ij; 

		LeasePayment__c lp1 = TestFactory_Invoices.createLeasePayment(accntId, optyId, quoteId);
		lp1.Site_State_Prov_old__c = 'CA';
		insert lp1;

		System.assertEquals(3,[SELECT Id FROM Invoice_Documents__c WHERE Lease_Payment__c = :lp1.Id].size());
		LeasePayment__c lpTest = [SELECT Id, Install_Invoice_Docs_Required__c, Interconnect_Invoice_Docs_Required__c FROM LeasePayment__c WHERE Id =: lp1.Id];
		System.assertEquals(2, lpTest.Interconnect_Invoice_Docs_Required__c);
		System.assertEquals(1, lpTest.Install_Invoice_Docs_Required__c);

	}
	@isTest
    private static void iSupplierTest(){
        Id accntId = [SELECT Id FROM Account LIMIT 1].Id;
        Id optyId = [SELECT Id FROM Opportunity LIMIT 1].Id;
        Id quoteId = [SELECT Id FROM Quote LIMIT 1].Id;
        Id iddId1,iddId2;
        for(Invoice_Document_Data__c idd : [SELECT Id,Name FROM Invoice_Document_Data__c WHERE Name = 'Final Permit' or Name = 'photos']){
            if(idd.Name == 'Final Permit')
                iddId1 = idd.Id;
            else
                iddId2 = idd.Id;    
        } 
        
        Account partner2 = TestFactory_StandardObjects.createPartnerAccount();
        partner2.iSupplier__c = true;
        insert partner2;

        
        IDD_Junction__c ij = TestFactory_Invoices.createPartner2IDDJunction(partner2.Id, iddId1);
        ij.State__c = 'CA';
        ij.Invoice_Type__c = 'Interconnect';
        ij.System_Type__c = 'AC;DC';
        ij.iSupplier__c = 'Yes';
        insert ij;

        IDD_Junction__c ij1 = TestFactory_Invoices.createPartner2IDDJunction(partner2.Id, iddId2);
        ij1.State__c = 'CA';
        ij1.Invoice_Type__c = 'Interconnect';
        ij1.System_Type__c = 'AC;DC';
        ij1.iSupplier__c = 'NO';
        insert ij1; 

        LeasePayment__c lp1 = TestFactory_Invoices.createLeasePayment(accntId, optyId, quoteId);
        lp1.Site_State_Prov_old__c = 'CA';
        lp1.Partner_Account__c = partner2.Id;
        insert lp1;
        
        System.assertEquals(4,[SELECT Id,Name,Invoice_Type__c,Status__c FROM Invoice_Documents__c WHERE Lease_Payment__c = :lp1.Id].size());
      // two records of Final Permit Created, IDD in Setup and One inserted above with iSupplier 'YES'
        System.assertEquals(2,[SELECT Id,Name,Invoice_Type__c,Status__c FROM Invoice_Documents__c WHERE Name LIKE '%Final Permit%'].size());
      // Even thought another IDD junction inserted , one record for photos because iSupplier = 'No'
        System.assertEquals(1,[SELECT Id,Name,Invoice_Type__c,Status__c FROM Invoice_Documents__c WHERE Name LIKE '%photos%'].size());
    }


	@testSetup static void setup() {

		Installation_Model__c imTps = TestFactory_Invoices.createInstallationModel();
		imTps.Name = 'TPS Lease IP Only';
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
        idd1.Name = 'Commissioning Report';

		Invoice_Document_Data__c idd2 = TestFactory_Invoices.createInvoiceDocumentData();
        idd2.Name = 'Final Permit';

		Invoice_Document_Data__c idd3 = TestFactory_Invoices.createInvoiceDocumentData();
        idd3.Name = 'Photos';

		Invoice_Document_Data__c idd4 = TestFactory_Invoices.createInvoiceDocumentData();
        idd4.Name = 'Signed Copy of Proposal';

		Invoice_Document_Data__c idd5 = TestFactory_Invoices.createInvoiceDocumentData();
        idd5.Name = 'Shading Report';

        List<Invoice_Document_Data__c> iddList = new List<Invoice_Document_Data__c>{idd1, idd2, idd3, idd4, idd5};
        insert iddList;

		
		IDD_Junction__c ijTPS1CA = TestFactory_Invoices.createIM2IDDJunction(imTps.Id, idd1.Id);
		ijTPS1CA.State__c = 'CA';
		ijTPS1CA.Invoice_Type__c = 'Interconnect';
		ijTPS1CA.System_Type__c = 'AC;DC';
		ijTPS1CA.Document_Upload_Location__c = 'Account';

		IDD_Junction__c ijTPS2CA = TestFactory_Invoices.createIM2IDDJunction(imTps.Id, idd2.Id);
		ijTPS2CA.State__c = 'CA;NY';
		ijTPS2CA.Invoice_Type__c = 'Interconnect';
		ijTPS2CA.System_Type__c = 'AC;DC';
		ijTPS2CA.Document_Upload_Location__c = 'Opportunity';

		IDD_Junction__c ijTPS3CA = TestFactory_Invoices.createIM2IDDJunction(imTps.Id, idd3.Id);
		ijTPS3CA.State__c = 'CA';
		ijTPS3CA.Invoice_Type__c = 'Install';
		ijTPS3CA.System_Type__c = 'AC;DC';
		ijTPS3CA.Document_Upload_Location__c = 'Residential Project';

		IDD_Junction__c ijTPS1NJ = TestFactory_Invoices.createIM2IDDJunction(imTps.Id, idd1.Id);
		ijTPS1NJ.State__c = 'FL';
		ijTPS1NJ.Invoice_Type__c = 'Interconnect';
		ijTPS1NJ.System_Type__c = 'AC;DC';
		ijTPS1NJ.Document_Upload_Location__c = 'Account';

		IDD_Junction__c ijSPD1CA = TestFactory_Invoices.createIM2IDDJunction(imSpd.Id, idd1.Id);
		ijSPD1CA.State__c = 'CA';
		ijSPD1CA.Invoice_Type__c = 'Interconnect';
		ijSPD1CA.System_Type__c = 'AC;DC';
		ijSPD1CA.Document_Upload_Location__c = 'Account';

		IDD_Junction__c ijFr1 = TestFactory_Invoices.createIM2IDDJunction(imFr.Id, idd1.Id);
		ijFr1.State__c = null;
		ijFr1.Invoice_Type__c = 'Interconnect';
		ijFr1.System_Type__c = 'AC;DC';
		ijFr1.Document_Upload_Location__c = 'Account';

		IDD_Junction__c ijFr4 = TestFactory_Invoices.createIM2IDDJunction(imFr.Id, idd4.Id);
		ijFr4.State__c = null;
		ijFr4.Invoice_Type__c = 'Interconnect';
		ijFr4.System_Type__c = 'AC;DC';
		ijFr4.Document_Upload_Location__c = 'Residential Project';

        List<IDD_Junction__c> iddjList = new List<IDD_Junction__c>{ijTPS1CA, ijTPS2CA, ijTPS3CA, ijTPS1NJ, ijSPD1CA, ijFr1, ijFr4};
        insert iddjList;

        Quote qt = TestFactory_StandardObjects.getProposalQuote();
		qt.Installation_Model__c = imTps.Id;
		qt.Inverter_Count__c = 0;
		update qt;
	}

}