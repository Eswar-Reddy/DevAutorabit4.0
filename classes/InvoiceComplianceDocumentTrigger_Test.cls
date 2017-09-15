/* **************************************************************************************
* Class Name     : InvoiceComplianceDocumentTrigger_Test
* Version        : 1.0
* Created Date   : July 31 2017
* Function       : It's a class to test functionalities for trigger on invoice compliance document.

* Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
* Ankit                       July 31 2017          Original Version
*************************************************************************************/
@isTest(SeeAllData=false)
public class InvoiceComplianceDocumentTrigger_Test{

   @testSetup static void setup() {
        TestFactory_Custom_Settings.getMosaicUploadDocuments();

        // inserting the loan Custom setting
        List<Loan_Callout_Settings__c> lstLoanSetting = TestFactory_Custom_Settings.createLoanCallOutSettings();
        insert lstLoanSetting;

        Account pa = TestFactory_StandardObjects.getPartnerAccount();

        Installation_Model__c imTps = TestFactory_Invoices.createInstallationModel();
        imTps.Name = 'TPS Lease IP Only';
        imTps.Country__c = 'United States';
        imTps.Financing_Option__c = 'Lease';
        imTps.Partner__c = 'TPS';
        imTps.Roles__c = 'IP';

        Installation_Model__c imSpd = TestFactory_Invoices.createInstallationModel();
        imSpd.Name = 'SPD Cash IP Only';
        imSpd.Country__c = 'United States';
        imSpd.Financing_Option__c = 'Cash';
        imSpd.Partner__c = 'SPD';
        imSpd.Roles__c = 'IP';

        Installation_Model__c imTpsIpDrip = TestFactory_Invoices.createInstallationModel();
        imTpsIpDrip.Name = 'TPS Lease (IP & DRIP)';
        imTpsIpDrip.Country__c = 'United States';
        imTpsIpDrip.Financing_Option__c = 'Lease';
        imTpsIpDrip.Partner__c = 'TPS';
        imTpsIpDrip.Roles__c = 'IP;DRIP';
        imTpsIpDrip.Type__c= 'Manual';

       

        List<Installation_Model__c> imList = new List<Installation_Model__c>{imTps,imSpd,imTpsIpDrip};
        insert imList;

        system.debug(LoggingLevel.ERROR,'---Installlation Model---' + imList);

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
        ijTPS1CA.Document_Owner__c = 'IP';

        IDD_Junction__c ijTPS2CA = TestFactory_Invoices.createIM2IDDJunction(imTps.Id, idd2.Id);
        ijTPS2CA.State__c = 'CA;NY';
        ijTPS2CA.Invoice_Type__c = 'Interconnect';
        ijTPS2CA.System_Type__c = 'AC;DC';
        ijTPS2CA.Document_Upload_Location__c = 'Opportunity';
        ijTPS1CA.Document_Owner__c = 'IP';

        IDD_Junction__c ijTPS3CA = TestFactory_Invoices.createIM2IDDJunction(imTps.Id, idd3.Id);
        ijTPS3CA.State__c = 'CA';
        ijTPS3CA.Invoice_Type__c = 'Install';
        ijTPS3CA.System_Type__c = 'AC;DC';
        ijTPS3CA.Document_Upload_Location__c = 'Residential Project';
        ijTPS1CA.Document_Owner__c = 'IP';

        IDD_Junction__c ijTPS4CA = TestFactory_Invoices.createIM2IDDJunction(imTps.Id, idd1.Id);
        ijTPS4CA.State__c = 'CA';
        ijTPS4CA.Invoice_Type__c = 'Origination';
        ijTPS4CA.System_Type__c = 'AC;DC';
        ijTPS4CA.Document_Upload_Location__c = 'Account';
        ijTPS4CA.Document_Owner__c = 'IP';
        ijTPS4CA.Partner_Account__c = pa.Id;
        ijTPS4CA.Installation_Model__c = NULL;

        IDD_Junction__c ijTPS5CA = TestFactory_Invoices.createIM2IDDJunction(imTps.Id, idd1.Id);
        ijTPS5CA.State__c = 'CA';
        ijTPS5CA.Invoice_Type__c = 'Interconnect';
        ijTPS5CA.System_Type__c = 'AC;DC';
        ijTPS5CA.Document_Upload_Location__c = 'Account';
        ijTPS5CA.Document_Owner__c = 'IP';
        ijTPS5CA.Partner_Account__c = pa.Id;
        ijTPS5CA.Installation_Model__c = NULL;

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

        //adding IDD junction for the TPS IP & DRIP Installlation Model
        
        IDD_Junction__c ijTPSIpDrip1CA = TestFactory_Invoices.createIM2IDDJunction(imTpsIpDrip.Id, idd1.Id);
        ijTPS3CA.State__c = 'CA';
        ijTPS3CA.Invoice_Type__c = 'Install';
        ijTPS3CA.System_Type__c = 'AC;DC';
        ijTPS3CA.Document_Upload_Location__c = 'Residential Project';
        ijTPS1CA.Document_Owner__c = 'IP';

        IDD_Junction__c ijTPSIpDrip2CA = TestFactory_Invoices.createIM2IDDJunction(imTpsIpDrip.Id, idd4.Id);
        ijTPS4CA.State__c = 'CA';
        ijTPS4CA.Invoice_Type__c = 'Origination';
        ijTPS4CA.System_Type__c = 'AC;DC';
        ijTPS4CA.Document_Upload_Location__c = 'Account';
        ijTPS4CA.Document_Owner__c = 'DRIP';
        ijTPS4CA.Partner_Account__c = pa.Id;

        List<IDD_Junction__c> iddjList = new List<IDD_Junction__c>{ijTPS1CA, ijTPS2CA, ijTPS3CA, ijTPS4CA, ijTPS5CA, ijTPS1NJ, ijSPD1CA,ijTPSIpDrip1CA,ijTPSIpDrip2CA};
        insert iddjList;

        Quote qt = TestFactory_StandardObjects.getProposalQuote();
        qt.Installation_Model__c = imTps.Id;
        qt.Inverter_Count__c = 0;
        update qt;
    }

    @isTest
    public static void rollups_Count_test(){
        Id accountId = [SELECT Id FROM Account LIMIT 1].Id;
        Id opportunityId = [SELECT Id FROM Opportunity LIMIT 1].Id;
        Id quoteId = [SELECT Id FROM Quote LIMIT 1].Id;
        Id imSpdId = [SELECT Id, Name FROM Installation_Model__c WHERE Name = 'TPS Lease IP Only' LIMIT 1].Id;

        Test.startTest();
            Residential_project__c rp = TestFactory_ResidentialProjMgmt.createSPDProject(accountId, opportunityId, quoteId);
            rp.Installation_Model__c = imSpdId;
            insert rp;
        Test.stopTest();

        LeasePayment__c lp1 = TestFactory_Invoices.createLeasePayment(accountId, opportunityId, quoteId);
        insert lp1;

        List<Invoice_Compliance_document__c> icdList = new List<Invoice_Compliance_document__c>();
        for(Invoice_Compliance_document__c icd : [SELECT Id, Name, Invoice_Type__c, Financial_Payment__c FROM Invoice_Compliance_document__c]) {
            icd.Financial_Payment__c = lp1.Id;
            if(icd.Invoice_type__c == 'Interconnect') icd.Status__c = 'Approved';
            if(icd.Invoice_type__c == 'Install') icd.Status__c = 'Pending';
            icdList.add(icd);
        }
        if(icdList.size() > 0) update icdList;
        System.assertEquals(2, [SELECT Id, Name, Approved_Interconnect_Docs__c FROM LeasePayment__c WHERE Id = :lp1.Id].Approved_Interconnect_Docs__c);
        System.assertEquals(1, [SELECT Id, Name, Submitted_Install_Docs__c FROM LeasePayment__c WHERE Id = :lp1.Id].Submitted_Install_Docs__c);
    }

    @isTest
    public static void checkICDs() {
        Id imId = [SELECT Id FROM Installation_Model__c WHERE Name = 'TPS Lease IP Only' LIMIT 1].Id;
        String recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        Id paId = [SELECT Id FROM Account WHERE RecordTypeId = :recTypeId LIMIT 1].Id;

        Test.startTest();
            Residential_project__c rp = TestFactory_ResidentialProjMgmt.getSPDProjectWithTemplate();
            rp.Installation_Model__c = imId;
            update rp;

            LeasePayment__c lp1 = TestFactory_Invoices.createLeasePayment(rp.Account__c, rp.Opportunity__c, rp.Quote__c);
            insert lp1;

            List<Alliance_Partner__c> apList = [SELECT Partner_Account__c FROM Alliance_Partner__c WHERE Residential_Project__c = :rp.Id AND Role__c = 'IP'];
            for(Alliance_Partner__c ap : apList) {
                ap.Partner_Account__c = paId;
            }
            update apList;
        Test.stopTest();

        List<Invoice_Compliance_document__c> icdList = [SELECT Id, Invoice_Type__c, Financial_Payment__c, Mosaic_Status__c, Responsible_Partner__c, Document_Owner__c, Documents_in_File__c, Notes_to_Partner__c, Residential_Project__c FROM Invoice_Compliance_document__c WHERE Residential_Project__c = :rp.Id];

        System.assertEquals(4, icdList.size());

        for(Invoice_Compliance_document__c icd : icdList) {
            icd.Financial_Payment__c = lp1.Id;
            icd.Mosaic_Status__c = 'Upload Success';
            icd.Status__c = 'Approved';
        }
        update icdList;

        for(Invoice_Compliance_document__c icd : icdList) {
            icd.Status__c = NULL;
        }
        update icdList;

        for(Invoice_Compliance_document__c icd : icdList) {
            icd.Status__c = 'Rejected';
        }
        update icdList;
        delete apList;
    }
    
    @isTest
    public static void testInstallationModelChanged (){

        Id accountId = [SELECT Id FROM Account LIMIT 1].Id;
        Id opportunityId = [SELECT Id FROM Opportunity LIMIT 1].Id;
        Id quoteId = [SELECT Id FROM Quote LIMIT 1].Id;
        Id imTpsId,imTpsIpDripId;
        for(Installation_Model__c ip :[select Id,Name from Installation_Model__c where Name IN ('TPS Lease IP Only','TPS Lease (IP & DRIP)')]){
            if(ip.Name == 'TPS Lease IP Only') imTpsId = ip.Id;
            if(ip.Name == 'TPS Lease (IP & DRIP)') imTpsIpDripId = ip.Id;
        }
        system.debug('--imTpsId---'+ imTpsId + '---imTpsIpDripId--' + imTpsIpDripId); 
        Test.StartTest(); 
        Residential_project__c rp = TestFactory_ResidentialProjMgmt.createSPDProject(accountId, opportunityId, quoteId);
        rp.Installation_Model__c = imTpsIpDripId;
        rp.RecordTypeId = Schema.SObjectType.Residential_Project__c.getRecordTypeInfosByName().get('TPS').getRecordTypeId();
        insert rp;
        Test.StopTest();
        // Created the ICD based on iDD junction object.
        System.assertEquals(2, [SELECT Id, Name, Invoice_Type__c, Financial_Payment__c FROM Invoice_Compliance_document__c where Residential_Project__c =:rp.Id].size());
        rp.Installation_Model__c = imTpsId;
        update rp;
        // new records added based on new installation model
        System.assertEquals(3, [SELECT Id, Name, Invoice_Type__c, Financial_Payment__c FROM Invoice_Compliance_document__c where Residential_Project__c =:rp.Id].size());
        // Sing Proposal records has been deleted as it was not there in New installation model
        System.assertEquals(0, [SELECT Id, Name, Invoice_Type__c, Financial_Payment__c FROM Invoice_Compliance_document__c where Name LIKE '%Signed Copy of Proposal%'].size());
        
    } 
    
    @isTest
    public static void testProjectTaskOnICD(){

        Id accountId = [SELECT Id FROM Account LIMIT 1].Id;
        Id opportunityId = [SELECT Id FROM Opportunity LIMIT 1].Id;
        Id quoteId = [SELECT Id FROM Quote LIMIT 1].Id;
        Id imTpsId,imTpsIpDripId;
        for(Installation_Model__c ip :[select Id,Name from Installation_Model__c where Name IN ('TPS Lease IP Only','TPS Lease (IP & DRIP)')]){
            if(ip.Name == 'TPS Lease IP Only') imTpsId = ip.Id;
            if(ip.Name == 'TPS Lease (IP & DRIP)') imTpsIpDripId = ip.Id;
        }
            
        Residential_Project__c projectTemplate = TestFactory_ResidentialProjMgmt.getProjectTemplate();
        //relating the document with the template task and IDD object. Query to get the data in context.
        projectTemplate = [SELECT Id ,(SELECT Id from Documents__r),(SELECT Id from Project_Tasks__r) from Residential_Project__c where Id =: projectTemplate.Id Limit 1];
        List<Invoice_Document_Data__c> iddList = [select Id,Name from Invoice_document_Data__c Limit 5];

        for(integer i =0;i<5;i++){
            projectTemplate.Documents__r[i].Project_Task__c = projectTemplate.project_tasks__r[i].Id;
            projectTemplate.Documents__r[i].Invoice_Document_Data__c = iddList[i].Id;
        }

        update projectTemplate.Documents__r;
        Test.startTest();
            Residential_project__c rp = TestFactory_ResidentialProjMgmt.createSPDProject(accountId, opportunityId, quoteId);
            rp.Project_Template__c = projectTemplate.Id;
            rp.Installation_Model__c = imTpsIpDripId;
            insert rp;
        Test.stopTest();
        system.assertEquals(2, [SELECT Id, Name, Invoice_Type__c, Financial_Payment__c FROM Invoice_Compliance_document__c WHERE Project_Task__c <> Null].size());
        rp.Installation_Model__c = imTpsId;
        update rp;
        system.assertEquals(3, [SELECT Id, Name, Invoice_Type__c, Financial_Payment__c FROM Invoice_Compliance_document__c WHERE Project_Task__c <> Null].size());
    }

    @isTest
    public static void testICDUploadAndDelete(){
        Id accountId = [SELECT Id FROM Account LIMIT 1].Id;
        Id opportunityId = [SELECT Id FROM Opportunity LIMIT 1].Id;
        Id quoteId = [SELECT Id FROM Quote LIMIT 1].Id;
        Id imSpdId = [SELECT Id, Name FROM Installation_Model__c WHERE Name = 'TPS Lease IP Only' LIMIT 1].Id;

        Test.startTest();
            Residential_project__c rp = TestFactory_ResidentialProjMgmt.createSPDProject(accountId, opportunityId, quoteId);
            rp.Installation_Model__c = imSpdId;
            insert rp;
        Test.stopTest();

        LeasePayment__c lp1 = TestFactory_Invoices.createLeasePayment(accountId, opportunityId, quoteId);
        insert lp1;

        List<Invoice_Compliance_document__c> icdList = new List<Invoice_Compliance_document__c>();
        
        // uploading the documents
        for(Invoice_Compliance_document__c icd : [SELECT Id, Name, Invoice_Type__c, Financial_Payment__c FROM Invoice_Compliance_document__c]) {
            icd.Financial_Payment__c = lp1.Id;
            icd.Link_to_attachment__c = 'Test Link';
            icdList.add(icd);
        }
        
        if(!icdList.isEmpty()){ 
            // Manually assigning the submitted date to a record.
            icdList[0].Document_submitted__c = Date.today();
            // updating the ICD for uploading the document scenario
             update icdList;
        }
        
        system.assertEquals(0, [SELECT Id, Name, Invoice_Type__c, Financial_Payment__c FROM Invoice_Compliance_document__c WHERE Status__c != 'Pending'].size());

        icdList.Clear();
             
        
        // updating the link to attachment to replicate teh document deleted scenario  
        for(Invoice_Compliance_document__c icd : [SELECT Id, Name, Invoice_Type__c, Financial_Payment__c FROM Invoice_Compliance_document__c]) {
            icd.Financial_Payment__c = lp1.Id;
            icd.Link_to_attachment__c = Null;
            icdList.add(icd);
        }

        // updating the ICD for document deleted scenario.
        if(!icdList.isEmpty()) update icdList;
        system.assertEquals(0, [SELECT Id, Name, Invoice_Type__c, Financial_Payment__c FROM Invoice_Compliance_document__c WHERE Status__c != 'Not Submitted'].size());
         
    }

    @isTest
    public static void testICDRejection(){
        Id accountId = [SELECT Id FROM Account LIMIT 1].Id;
        Id opportunityId = [SELECT Id FROM Opportunity LIMIT 1].Id;
        Id quoteId = [SELECT Id FROM Quote LIMIT 1].Id;
        Id imSpdId = [SELECT Id, Name FROM Installation_Model__c WHERE Name = 'TPS Lease IP Only' LIMIT 1].Id;

        Test.startTest();
            Residential_project__c rp = TestFactory_ResidentialProjMgmt.createSPDProject(accountId, opportunityId, quoteId);
            rp.Installation_Model__c = imSpdId;
            insert rp;
        Test.stopTest();

        LeasePayment__c lp1 = TestFactory_Invoices.createLeasePayment(accountId, opportunityId, quoteId);
        insert lp1;

        List<Invoice_Compliance_Document__c> icdList = new List<Invoice_Compliance_Document__c>();
        
        // uploading the documents
        for(Invoice_Compliance_Document__c icd : [SELECT Id, Name, Invoice_Type__c, Financial_Payment__c FROM Invoice_Compliance_Document__c]) {
            icd.Financial_Payment__c = lp1.Id;
            icd.Link_to_attachment__c = 'Test Link';
            icdList.add(icd);
        }
        update icdList;

        List<Invoice_Compliance_Document__c> docs = [SELECT Id, Name, Financial_Payment__c, Document_Submitted__c, Link_to_attachment__c, Status__c, Response_Date__c FROM Invoice_Compliance_Document__c WHERE Financial_Payment__c =: lp1.Id];
        system.assertEquals(docs[0].Status__c, 'Pending');
        system.assertEquals(docs[0].Document_Submitted__c, system.today());

        Id rejectedDoc = docs[0].Id;
        
        docs[0].Status__c = 'Rejected';
        docs[0].Notes_To_Partner__c = 'Incorrect Document Submitted';
        update docs[0];

        Invoice_Compliance_Document__c doc = [SELECT Id, Name, Financial_Payment__c, Document_Submitted__c, Link_to_attachment__c, Status__c, Response_Date__c, (SELECT Document_Submitted__c, Link_to_Document__c, Notes_To_Partner__c, Response_Date__c FROM ICD_Status_Changed_Reasons__r) FROM Invoice_Compliance_Document__c WHERE Id =: rejectedDoc];

        system.assertEquals(doc.Status__c, 'Rejected');
        system.assertEquals(doc.Document_Submitted__c, NULL);
        system.assertEquals(doc.Link_to_Attachment__c, NULL);
        system.assertEquals(doc.Response_Date__c, system.today());
        system.assertEquals(doc.ICD_Status_Changed_Reasons__r.size(), 1);
        system.assertEquals(doc.ICD_Status_Changed_Reasons__r[0].Document_Submitted__c, system.today());
        system.assertEquals(doc.ICD_Status_Changed_Reasons__r[0].Notes_to_Partner__c, 'Incorrect Document Submitted');
        system.assertEquals(doc.ICD_Status_Changed_Reasons__r[0].Link_to_Document__c, 'Test Link');
         
    }
}