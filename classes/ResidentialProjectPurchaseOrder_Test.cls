@isTest
public class ResidentialProjectPurchaseOrder_Test {

    @testsetup
    static void testDataSetup(){
        // create installer account
        Account installer = TestFactory_StandardObjects.getInstallerAccount();
        // create installer contact
        Contact shipToContact = TestFactory_StandardObjects.createPartnerContact(installer.Id);
        insert shipToContact;
        // create account contact role for ship to contact
        AccountContactRole acr = TestFactory_StandardObjects.createAccountContactRole();
        acr.AccountId = installer.Id;
        acr.ContactId = shipToContact.Id;
        acr.IsPrimary = true;
        acr.Role = 'Shipping Contact';
        insert acr;
        // create builder account
        Account builder = TestFactory_StandardObjects.getInstallerAccount();
        builder.Primary_PSR__c = UserInfo.getUserId();
        builder.RSM__c = UserInfo.getUserId();
        update builder;
        // create community
        NH_Community__c community = TestFactory_ResidentialProjMgmt.createNHCommunity(installer.Id, builder.Id);
        insert community;
        // setup configuraitons
        Module_Configuration__c mc = TestFactory_Configurations.createModuleConfiguration();
        insert mc;
        Racking_Configuration__c rc = TestFactory_Configurations.createRackingConfiguration();
        rc.Type__c = 'InvisiMount';
        rc.Kit_Size__c = 30;
        insert rc;
        ModuleRackingJunction__c mrj = (ModuleRackingJunction__c)SmartFactory.createSObject('ModuleRackingJunction__c');
        mrj.Module_Configuration__c = mc.Id;
        mrj.Racking_Configuration__c = rc.Id;
        insert mrj;
        Item__c i = TestFactory_Configurations.getItem();
        Racking_Item_Junction__c rij = (Racking_Item_Junction__c)SmartFactory.createSObject('Racking_Item_Junction__c');
        rij.Item__c = i.Id;
        rij.Racking_Configuration__c = rc.Id;
        rij.Quantity__c = 10;
        insert rij;
        Inverter_Configuration__c ic = TestFactory_Configurations.createInverterConfiguration();
        ic.Start_Date__c = System.today().toStartOfMonth();
        ic.End_Date__c = System.today().addYears(1);
        insert ic;
        Storage_Configuration__c sc = TestFactory_Configurations.createStorageConfiguration();
        insert sc;
        // setup IM
        Installation_Model__c im = TestFactory_ResidentialProjMgmt.createInstallationModelIP();
        im.Partner__c = 'New Homes Project';
        insert im;
        // setup PO Fee Lines for IM
        POLineFeeSetup__c polfs = TestFactory_ResidentialProjMgmt.createPOLineFeeSetup();
        polfs.Model__c = im.Id;
        polfs.Value_From__c = 'Builder_WO_Value__c';
        insert polfs;
        // setup PO
        insert new Lease_2_1_PO_Creation__c(Name='Lease_2_1_Bypass', Lease_2_1_Test_Method_Bypass__c = true);
        Purchase_Order__c po = TestFactory_Ordering.createPurchaseOrder();
        insert po;

        Residential_Project__c rp1 = TestFactory_ResidentialProjMgmt.createNewHomeProjectNoAccountQuoteOpp(community.Id);
        rp1.Name = 'CompleteDataIM';
        rp1.Installation_Model__c = im.Id;
        rp1.Module_Configuration__c = mc.Id;
        rp1.Number_of_Panels__c = 16;
        rp1.Inverter_Configuration__c = ic.Id;
        rp1.Inverter_Quantity__c = 1;
        rp1.MonitoringIncluded__c = 'Yes';
        rp1.Mounting_Type__c = 'InvisiMount';
        rp1.Storage_Configuration__c = sc.Id;
        rp1.Builder_WO_Value__c = 9500;
        insert rp1;

        Residential_Project__c rp2 = TestFactory_ResidentialProjMgmt.createNewHomeProjectNoAccountQuoteOpp(community.Id);
        rp2.Name = 'CompleteDataSM';
        rp2.Installation_Model__c = im.Id;
        rp2.Module_Configuration__c = mc.Id;
        rp2.Number_of_Panels__c = 16;
        rp2.Inverter_Configuration__c = ic.Id;
        rp2.Inverter_Quantity__c = 1;
        rp2.MonitoringIncluded__c = 'No';
        rp2.Mounting_Type__c = 'SolarMount';
        rp2.Storage_Configuration__c = sc.Id;
        insert rp2;

        Residential_Project__c rp3 = TestFactory_ResidentialProjMgmt.createNewHomeProjectNoAccountQuoteOpp(community.Id);
        rp3.Name = 'NoIM';
        rp3.Module_Configuration__c = mc.Id;
        rp3.Number_of_Panels__c = 24;
        rp3.Inverter_Configuration__c = ic.Id;
        rp3.Inverter_Quantity__c = 1;
        rp3.MonitoringIncluded__c = 'Yes';
        rp3.Mounting_Type__c = 'InvisiMount';
        rp3.Storage_Configuration__c = sc.Id;
        insert rp3;

        Residential_Project__c rp4 = TestFactory_ResidentialProjMgmt.createNewHomeProjectNoAccountQuoteOpp(community.Id);
        rp4.Name = 'NoModule';
        rp4.Installation_Model__c = im.Id;
        rp4.Number_of_Panels__c = 24;
        rp4.Inverter_Configuration__c = ic.Id;
        rp4.Inverter_Quantity__c = 1;
        rp4.MonitoringIncluded__c = 'Yes';
        rp4.Mounting_Type__c = 'InvisiMount';
        rp4.Storage_Configuration__c = sc.Id;
        insert rp4;

        Residential_Project__c rp5 = TestFactory_ResidentialProjMgmt.createNewHomeProjectNoAccountQuoteOpp(community.Id);
        rp5.Name = 'PO';
        rp5.Purchase_Order__c = po.Id;
        insert rp5;

        Residential_Project__c rp6 = TestFactory_ResidentialProjMgmt.createNewHomeProjectNoAccountQuoteOpp(community.Id);
        rp6.Name = 'NoRacking';
        rp6.Installation_Model__c = im.Id;
        rp6.Module_Configuration__c = mc.Id;
        rp6.Number_of_Panels__c = 16;
        rp6.Inverter_Configuration__c = ic.Id;
        rp6.Inverter_Quantity__c = 1;
        rp6.MonitoringIncluded__c = 'Yes';
        rp6.Storage_Configuration__c = sc.Id;
        insert rp6;

        Residential_Project__c rp7 = TestFactory_ResidentialProjMgmt.createNewHomeProjectNoAccountQuoteOpp(community.Id);
        rp7.Name = 'NoStorage';
        rp7.Installation_Model__c = im.Id;
        rp7.Module_Configuration__c = mc.Id;
        rp7.Number_of_Panels__c = 16;
        rp7.Inverter_Configuration__c = ic.Id;
        rp7.Inverter_Quantity__c = 1;
        rp7.MonitoringIncluded__c = 'Yes';
        rp7.Mounting_Type__c = 'InvisiMount';
        insert rp7;
    }

    public static testmethod void CompleteDataIM(){
        Test.startTest();
            List<Residential_Project__c> rp = [SELECT Id, Community__c, Community__r.Installer__c FROM Residential_Project__c WHERE Name = 'CompleteDataIM' limit 1];
            // setup alliance partner
            Alliance_Partner__c ap = TestFactory_ResidentialProjMgmt.createProjectAlliancePartner(rp[0].Id, rp[0].Community__r.Installer__c);
            ap.Role__c = 'IP';
            insert ap;
            // setup project team member
            Project_Team_Member__c tm = TestFactory_ResidentialProjMgmt.getTeamMember(rp[0].Id, 'Partner Support Representative');
            // create lines
            ResidentialProjectCreateLines.createStandardLineItemsForProject(rp[0].Id);

            Test.setCurrentPage(Page.ResidentialProjectPurchaseOrder);
            ApexPages.currentPage().getParameters().put('ProjectId', rp[0].Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(rp[0]);
            ResidentialProjectPurchaseOrder controller = new ResidentialProjectPurchaseOrder(sc);
            controller.init();
            controller.psrSubmitOrder();
        Test.stopTest();
    }

    public static testmethod void CompleteDataSM(){
        Test.startTest();
            List<Residential_Project__c> rp = [SELECT Id, Community__c, Community__r.Installer__c, Installation_Model__c FROM Residential_Project__c WHERE Name = 'CompleteDataSM' limit 1];
            // setup alliance partner
            Alliance_Partner__c ap = TestFactory_ResidentialProjMgmt.createProjectAlliancePartner(rp[0].Id, rp[0].Community__r.Installer__c);
            ap.Role__c = 'IP';
            insert ap;
            // setup project team member
            Project_Team_Member__c tm = TestFactory_ResidentialProjMgmt.getTeamMember(rp[0].Id, 'Partner Support Representative');

            List<POLineFeeSetup__c> polfs = new List<POLineFeeSetup__c>();
            for(POLineFeeSetup__c pol : [SELECT Id FROM POLineFeeSetup__c WHERE Model__c = :rp[0].Installation_Model__c]) {
                polfs.add(pol);
            }
            delete polfs;

            Test.setCurrentPage(Page.ResidentialProjectPurchaseOrder);
            ApexPages.currentPage().getParameters().put('ProjectId', rp[0].Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(rp[0]);
            ResidentialProjectPurchaseOrder controller = new ResidentialProjectPurchaseOrder(sc);
            controller.init();
        Test.stopTest();
    }

    public static testmethod void NoIM(){
        Test.startTest();
            List<Residential_Project__c> rp = [SELECT Id FROM Residential_Project__c WHERE Name = 'NoIM' limit 1];
            // setup project team member
            Project_Team_Member__c tm = TestFactory_ResidentialProjMgmt.getTeamMember(rp[0].Id, 'Partner Support Representative');

            Test.setCurrentPage(Page.ResidentialProjectPurchaseOrder);
            ApexPages.currentPage().getParameters().put('ProjectId', rp[0].Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(rp[0]);
            ResidentialProjectPurchaseOrder controller = new ResidentialProjectPurchaseOrder(sc);
        Test.stopTest();
    }

    public static testmethod void NoProjectId(){
        Test.startTest();
            List<Residential_Project__c> rp = [SELECT Id FROM Residential_Project__c WHERE Name = 'NoIM' limit 1];
            // setup project team member
            Project_Team_Member__c tm = TestFactory_ResidentialProjMgmt.getTeamMember(rp[0].Id, 'Partner Support Representative');

            Test.setCurrentPage(Page.ResidentialProjectPurchaseOrder);
            ApexPages.StandardController sc = new ApexPages.StandardController(rp[0]);
            ResidentialProjectPurchaseOrder controller = new ResidentialProjectPurchaseOrder(sc);
        Test.stopTest();
    }

    public static testmethod void NoModule(){
        Test.startTest();
            List<Residential_Project__c> rp = [SELECT Id FROM Residential_Project__c WHERE Name = 'NoModule' limit 1];
            // setup project team member
            Project_Team_Member__c tm = TestFactory_ResidentialProjMgmt.getTeamMember(rp[0].Id, 'Partner Support Representative');

            Test.setCurrentPage(Page.ResidentialProjectPurchaseOrder);
            ApexPages.currentPage().getParameters().put('ProjectId', rp[0].Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(rp[0]);
            ResidentialProjectPurchaseOrder controller = new ResidentialProjectPurchaseOrder(sc);
        Test.stopTest();
    }

    public static testmethod void POAlready(){
        Test.startTest();
            List<Residential_Project__c> rp = [SELECT Id FROM Residential_Project__c WHERE Name = 'PO' limit 1];
            // setup project team member
            Project_Team_Member__c tm = TestFactory_ResidentialProjMgmt.getTeamMember(rp[0].Id, 'Partner Support Representative');

            Test.setCurrentPage(Page.ResidentialProjectPurchaseOrder);
            ApexPages.currentPage().getParameters().put('ProjectId', rp[0].Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(rp[0]);
            ResidentialProjectPurchaseOrder controller = new ResidentialProjectPurchaseOrder(sc);
        Test.stopTest();
    }

    public static testmethod void NoRacking(){
        Test.startTest();
            List<Residential_Project__c> rp = [SELECT Id FROM Residential_Project__c WHERE Name = 'NoRacking' limit 1];
            // setup project team member
            Project_Team_Member__c tm = TestFactory_ResidentialProjMgmt.getTeamMember(rp[0].Id, 'Partner Support Representative');

            Test.setCurrentPage(Page.ResidentialProjectPurchaseOrder);
            ApexPages.currentPage().getParameters().put('ProjectId', rp[0].Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(rp[0]);
            ResidentialProjectPurchaseOrder controller = new ResidentialProjectPurchaseOrder(sc);
        Test.stopTest();
    }

    public static testmethod void NoStorage(){
        Test.startTest();
            List<Residential_Project__c> rp = [SELECT Id FROM Residential_Project__c WHERE Name = 'NoStorage' limit 1];
            // setup project team member
            Project_Team_Member__c tm = TestFactory_ResidentialProjMgmt.getTeamMember(rp[0].Id, 'Partner Support Representative');

            Test.setCurrentPage(Page.ResidentialProjectPurchaseOrder);
            ApexPages.currentPage().getParameters().put('ProjectId', rp[0].Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(rp[0]);
            ResidentialProjectPurchaseOrder controller = new ResidentialProjectPurchaseOrder(sc);
        Test.stopTest();
    }

    public static testmethod void NoBillTo(){
        Test.startTest();
            List<Residential_Project__c> rp = [SELECT Id, Community__r.Builder__c FROM Residential_Project__c WHERE Name = 'NoStorage' limit 1];
            // setup project team member
            Project_Team_Member__c tm = TestFactory_ResidentialProjMgmt.getTeamMember(rp[0].Id, 'Partner Support Representative');

            List<Bill_To_Site__c> bts = new List<Bill_To_Site__c>();
            for(Bill_To_Site__c b : [SELECT Id FROM Bill_To_Site__c WHERE Dealer_Account__c = :rp[0].Community__r.Builder__c]) {
                bts.add(b);
            }
            delete bts;

            Test.setCurrentPage(Page.ResidentialProjectPurchaseOrder);
            ApexPages.currentPage().getParameters().put('ProjectId', rp[0].Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(rp[0]);
            ResidentialProjectPurchaseOrder controller = new ResidentialProjectPurchaseOrder(sc);
        Test.stopTest();
    }

    public static testmethod void OracleOrderSubmission(){
        Test.startTest();
            List<Residential_Project__c> rp = [SELECT Id, Community__c, Community__r.Installer__c FROM Residential_Project__c WHERE Name = 'CompleteDataIM' limit 1];
            // setup alliance partner
            Alliance_Partner__c ap = TestFactory_ResidentialProjMgmt.createProjectAlliancePartner(rp[0].Id, rp[0].Community__r.Installer__c);
            ap.Role__c = 'IP';
            insert ap;
            // setup project team member
            Project_Team_Member__c tm = TestFactory_ResidentialProjMgmt.getTeamMember(rp[0].Id, 'Partner Support Representative');

            ResidentialProjectCreateLines.createStandardLineItemsForProject(rp[0].Id);

            Test.setCurrentPage(Page.ResidentialProjectPurchaseOrder);
            ApexPages.currentPage().getParameters().put('ProjectId', rp[0].Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(rp[0]);
            ResidentialProjectPurchaseOrder controller = new ResidentialProjectPurchaseOrder(sc);
            controller.init();
            controller.psrSubmitOrder();

            Test.setCurrentPage(Page.OracleOrderSubmission);
            ApexPages.currentPage().getParameters().put('poId', controller.poId);
            ApexPages.currentPage().getParameters().put('ProjectId', controller.projectId);
            sc = new ApexPages.StandardController(controller.purchaseOrder);
            OracleOrderSubmissionController controller2 = new OracleOrderSubmissionController(sc);
            controller2.init();

            //controller2.reSubmitOrder();
            ResultMessage rm = new ResultMessage();
            rm.success = true;
            rm.message = '{"sales_order_response": {"status": "S", "status_message": "Successfully Processed", "sales_order_response_header": {"order_number": "12217702"}}}';
            controller2.checkResult(rm);
            rm.message = '{"sales_order_response": {"status": "E", "status_message": "Timeout Error", "sales_order_response_header": {"order_number": ""}}}';
            controller2.checkResult(rm);
            rm.success = false;
            controller2.checkResult(rm);
            controller2.checkResult(new ResultMessage());
        Test.stopTest();
    }

    public static testmethod void OracleOrderSubmission2(){
        Test.startTest();
            List<Residential_Project__c> rp = [SELECT Id, Community__c, Community__r.Installer__c FROM Residential_Project__c WHERE Name = 'CompleteDataIM' limit 1];
            // setup alliance partner
            Alliance_Partner__c ap = TestFactory_ResidentialProjMgmt.createProjectAlliancePartner(rp[0].Id, rp[0].Community__r.Installer__c);
            ap.Role__c = 'IP';
            insert ap;
            // setup project team member
            Project_Team_Member__c tm = TestFactory_ResidentialProjMgmt.getTeamMember(rp[0].Id, 'Partner Support Representative');

            ResidentialProjectCreateLines.createStandardLineItemsForProject(rp[0].Id);

            Test.setCurrentPage(Page.ResidentialProjectPurchaseOrder);
            ApexPages.currentPage().getParameters().put('ProjectId', rp[0].Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(rp[0]);
            ResidentialProjectPurchaseOrder controller = new ResidentialProjectPurchaseOrder(sc);
            controller.init();
            controller.psrSubmitOrder();

            Test.setCurrentPage(Page.OracleOrderSubmission);
            ApexPages.currentPage().getParameters().put('ProjectId', controller.projectId);
            sc = new ApexPages.StandardController(controller.purchaseOrder);
            OracleOrderSubmissionController controller2 = new OracleOrderSubmissionController(sc);
        Test.stopTest();
    }
}