@isTest
private class PartnerTimelineControllerTest {

    final static String FIRST_LEASE_STAGE = 'Fully Signed Contract';
    final static String SECOND_LEASE_STAGE = 'Material Delivered and Submitting Install Invoice Documents';
    final static String CUSTOM_SETTING_LEASE_STAGE = 'Lease_Stage__c';
    final static String AGREEMENT_RECORDTYPE_NAME = 'Lease_Contract';
    
    @TestSetup
    static void testDataSetup() {
        TestClassFactory.createAndInsertLeaseAgreementSettings();
    }

    static void setupCustomSettings() {
        Lease_Stage_Ordering__c leaseOrderCustomSetting1 = new Lease_Stage_Ordering__c();
        Lease_Stage_Ordering__c leaseOrderCustomSetting2 = new Lease_Stage_Ordering__c();
        Lease_Stage_Ordering__c leaseOrderCustomSetting3 = new Lease_Stage_Ordering__c();

        leaseOrderCustomSetting1.Order__c = 1;
        leaseOrderCustomSetting1.Name = 'leasestage1';
        leaseOrderCustomSetting1.Lease_Stage__c = FIRST_LEASE_STAGE;
        leaseOrderCustomSetting1.Show_Agreement__c = true;
        leaseOrderCustomSetting1.Country__c = 'India';
        leaseOrderCustomSetting1.Agreement_RecordType__c = AGREEMENT_RECORDTYPE_NAME;

        leaseOrderCustomSetting2.Order__c = 2;
        leaseOrderCustomSetting2.Name = 'leasestage2';
        leaseOrderCustomSetting2.Lease_Stage__c = SECOND_LEASE_STAGE;
        leaseOrderCustomSetting2.Show_Agreement__c = true;
        leaseOrderCustomSetting2.SLA_field_API_Name__c = 'SLA_Install_Status__c';
        leaseOrderCustomSetting2.Country__c = 'India';
        leaseOrderCustomSetting2.Agreement_RecordType__c = AGREEMENT_RECORDTYPE_NAME;

        leaseOrderCustomSetting3.Order__c = 3;
        leaseOrderCustomSetting3.Name = 'leasestage3';
        leaseOrderCustomSetting3.Lease_Stage__c = SECOND_LEASE_STAGE;
        leaseOrderCustomSetting3.Show_Agreement__c = true;
        leaseOrderCustomSetting3.SLA_field_API_Name__c = 'SLA_Install_Status__c';
        leaseOrderCustomSetting3.Country__c = 'TESTCOUNTRY';
        leaseOrderCustomSetting3.Agreement_RecordType__c = AGREEMENT_RECORDTYPE_NAME;


        System.runAs(TestUtils.ADMIN_USER) {
            insert new List<Lease_Stage_Ordering__c>{leaseOrderCustomSetting1, leaseOrderCustomSetting2, leaseOrderCustomSetting3};
        }

        TestUtils.createLeaseCreationCustomSetting();
        setupTimelineCountryCustomSettings();
    }

    static void setupTimelineCountryCustomSettings() {
        Country_To_Lease_Stage__c countryCustomSetting = new Country_To_Lease_Stage__c();
        countryCustomSetting.Name = 'India';
        countryCustomSetting.Lease_Stage_API_Name__c = CUSTOM_SETTING_LEASE_STAGE;

        System.runAs(TestUtils.ADMIN_USER) {
            insert countryCustomSetting;
        }
    }

    static testMethod void leaseStageFieldTest() {
        setupCustomSettings();
        TestLeasePaymentSetup.setup();

        Test.startTest();

            String actualLeaseStage;
            System.runAs(TestLeasePaymentSetup.partnerUser) {
                PartnerTimelineController controller = new PartnerTimelineController();
                actualLeaseStage = controller.leaseStageField;
            }

        Test.stopTest();

        System.assertEquals(CUSTOM_SETTING_LEASE_STAGE, actualLeaseStage, 'The correct lease stage should be returned');
    }

    static testMethod void getStagesToShowTest() {
        setupCustomSettings();
        TestLeasePaymentSetup.setup();

        Test.startTest();

            Set<String> agreementStages;

            System.runAs(TestLeasePaymentSetup.partnerUser) {
                PartnerTimelineController controller = new PartnerTimelineController();
                agreementStages = controller.getStagesToShow('Show_Agreement__c');
            }

        Test.stopTest();

        System.assertEquals(2, agreementStages.size(), 'Two stages should be returned');
        System.assert(agreementStages.contains(FIRST_LEASE_STAGE), 'The first lease stage should be returned');
        System.assert(agreementStages.contains(SECOND_LEASE_STAGE), 'The second lease stage should be returned');
    }

    static testMethod void leaseStatusToStatusColumnTest() {
        
        SFDCSpecialUtilities.isRunningTest = True; 
    
        setupCustomSettings();
        TestLeasePaymentSetup.setup();

        final String BAD_STATUS = 'badStatus';

        List<LeasePayment__c> leasePayments = TestUtils.createLeasePayments(3, TestLeasePaymentSetup.newAccount.Id, false);
        LeasePayment__c firstLease = leasePayments[0];
        LeasePayment__c secondLease = leasePayments[1];
        LeasePayment__c inactivefirstLease = leasePayments[2];

        Id partnerAccountId = [SELECT Contact.AccountId FROM User WHERE Id = :TestLeasePaymentSetup.partnerUser.Id][0].Contact.AccountId;

        firstLease.Date_Countersigned_old__c = TestLeasePaymentSetup.currentDate;
        firstLease.Date_Delivered__c = null;
        firstLease.Partner_Account__c = partnerAccountId;
        firstLease.Status__c = TimelineServices.ACTIVE_STATUS;

        inactivefirstLease.Date_Countersigned_old__c = TestLeasePaymentSetup.currentDate;
        inactivefirstLease.Date_Delivered__c = null;
        inactivefirstLease.Partner_Account__c = partnerAccountId;
        inactivefirstLease.Status__c = BAD_STATUS;

        secondLease.Date_Countersigned_old__c = TestLeasePaymentSetup.currentDate;
        secondLease.Date_Delivered__c = TestLeasePaymentSetup.currentDate;
        secondLease.Partner_Account__c = partnerAccountId;
        secondLease.Install_Pymnt_Apprvd__c = null;
        secondLease.Status__c = TimelineServices.ACTIVE_STATUS;

        insert leasePayments;

        Map<String, PartnerTimelineController.StageColumn> actualLeaseStageToStageColumn;
        Test.startTest();

            System.runAs(TestLeasePaymentSetup.partnerUser) {
                PartnerTimelineController controller = new PartnerTimelineController();
                actualLeaseStageToStageColumn = controller.getLeaseStageToStageColumn();
            }

        Test.stopTest();

        PartnerTimelineController.StageColumn firstColumn = actualLeaseStageToStageColumn.get(FIRST_LEASE_STAGE);
        PartnerTimelineController.StageColumn secondColumn = actualLeaseStageToStageColumn.get(SECOND_LEASE_STAGE);

        System.assertEquals(2, actualLeaseStageToStageColumn.size(), 'The size of the map should be 2');

        System.assertEquals(FIRST_LEASE_STAGE, firstColumn.leaseStage, 'The first lease stage column should match the stage name');
        System.assertEquals(1, firstColumn.noSLA.size(), 'One lease payment should be in the first lease stage');
        System.assertEquals(firstLease.Id, firstColumn.noSLA[0].Id, 'the first lease should be populated for the first stage');

        System.assertEquals(SECOND_LEASE_STAGE, secondColumn.leaseStage, 'The second lease stage column should match the stage name');
        System.assertEquals(1, secondColumn.greenSLA.size(), 'Only one lease should be in the second lease stage');
        System.assertEquals(secondLease.Id, secondColumn.greenSLA[0].Id, 'the second lease should be populated for the second stage');

    }

    static testMethod void buildColumnsTest() {
        setupCustomSettings();
        Date currentDate = Date.today();
        User partnerUser = TestUtils.createLeasePartnerInfo();
        insert partnerUser;

        List<Account> accounts = TestUtils.createAccounts(3, true);
        Set<Id> accountIds =  Pluck.ids(new List<Account>{accounts[0], accounts[1]});

        List<echosign_dev1__SIGN_Agreement__c> agreements = TestUtils.createAgreements(accountIds , false);
        for(echosign_dev1__SIGN_Agreement__c agreement : agreements) {
            agreement.echosign_dev1__Status__c = TimelineServices.AGREEMENT_STATUS;
            agreement.RecordTypeId = TestUtils.leaseContactRecordType.Id;
            agreement.OwnerId = partnerUser.Id;
        }
        agreements[0].echosign_dev1__SignedPDF__c = 'test';

        insert agreements;

        List<Attachment> attachments = TestUtils.createAttachments(1, 'testname', false);
        attachments[0].ParentId = agreements[1].Id;
        insert attachments;

        List<LeasePayment__c> leasePayments = TestUtils.createLeasePayments(3, accounts[2].Id, false);
        LeasePayment__c firstLease = leasePayments[0];
        LeasePayment__c secondLease = leasePayments[1];
        LeasePayment__c thirdLease = leasePayments[2];

        //Green sla - first stage
        firstLease.Date_Countersigned_old__c = currentDate;
        firstLease.Date_Delivered__c = null;
        firstLease.End_Customer_Account__c = agreements[0].Account__c;

        //Green sla - first stage
        thirdLease.Date_Countersigned_old__c = currentDate;
        thirdLease.Date_Delivered__c = null;
        thirdLease.End_Customer_Account__c = accounts[2].Id;

        //yellow sla - second stage
        secondLease.Date_Countersigned_old__c = currentDate;
        secondLease.Date_Delivered__c = currentDate.addDays(-26);
        secondLease.End_Customer_Account__c = agreements[1].Account__c;
        secondLease.Install_Pymnt_Apprvd__c = null;
        
        Test.startTest();
        insert leasePayments;
        leasePayments = [SELECT End_Customer_Account__c, Lease_Stage__c, SLA_Install_Status__c FROM LeasePayment__c WHERE Id IN :leasePayments];

        Map<String, PartnerTimelineController.StageColumn> actualLeaseStageToStageColumn;
       

            System.runAs(partnerUser) {
                PartnerTimelineController controller = new PartnerTimelineController();
                actualLeaseStageToStageColumn = controller.buildColumns(leasePayments);
            }

        Test.stopTest();

        PartnerTimelineController.StageColumn firstColumn = actualLeaseStageToStageColumn.get(FIRST_LEASE_STAGE);
        PartnerTimelineController.StageColumn secondColumn = actualLeaseStageToStageColumn.get(SECOND_LEASE_STAGE);

        System.assertEquals(2, actualLeaseStageToStageColumn.size(), 'The size of the map should be 2');

        System.assertEquals(FIRST_LEASE_STAGE, firstColumn.leaseStage, 'The first lease stage column should match the stage name');
        System.assertEquals(2, firstColumn.noSLA.size(), 'Two lease payments should be in the first lease stage');
        System.assert(firstColumn.redSLA.isEmpty(), 'No lease payment should have red sla');
        System.assert(firstColumn.yellowSLA.isEmpty(), 'No lease payment should have yellow sla');
        System.assertEquals(firstLease.Id, firstColumn.noSLA[0].Id, 'the first lease should be populated for the first stage');
        System.assertEquals(thirdLease.Id, firstColumn.noSLA[1].Id, 'the third lease should be populated for the first stage');
        System.assertEquals(2, firstColumn.leaseIdToSignature.size(), 'there should be 2 signatures in the map');
        System.assert(firstColumn.leaseIdToSignature.containsKey(firstLease.Id), 'The map should contain the first lease id');

        echosign_dev1__SIGN_Agreement__c actualAgreement = firstColumn.leaseIdToSignature.get(firstLease.Id).agreement;
        System.assertEquals(agreements[0].Id, actualAgreement.Id, 'The correct agreement should be in the map');

        System.assertEquals(SECOND_LEASE_STAGE, secondColumn.leaseStage, 'The second lease stage column should match the stage name');
        System.assert(secondColumn.noSLA.isEmpty(), 'No lease payment should have no sla');
        System.assert(secondColumn.redSLA.isEmpty(), 'No lease payment should have red sla');
        System.assertEquals(1, secondColumn.yellowSLA.size(), 'one leae payment should have a yellow sla');
        System.assertEquals(secondLease.Id, secondColumn.yellowSLA[0].Id, 'the second lease should be populated for the second stage');
        System.assertEquals(1, secondColumn.leaseIdToSignature.size(), 'One agreement should be in the map');
        System.assertEquals(agreements[1].Id, secondColumn.leaseIdToSignature.values()[0].agreement.Id, 'An empty agreement should be in the map');
        System.assertEquals(attachments[0].Id, secondColumn.leaseIdToSignature.values()[0].attachment.Id, 'An attachment should be returned');

    }

    static testMethod void assignSLATest() {
    
        SFDCSpecialUtilities.isRunningTest = True; 
        
        setupCustomSettings();
        TestLeasePaymentSetup.setup();
        Date currentDate = Date.today();

        PartnerTimelineController.StageColumn stageColumn = new PartnerTimelineController.StageColumn(FIRST_LEASE_STAGE);

        List<LeasePayment__c> leasePayments = TestUtils.createLeasePayments(3, TestLeasePaymentSetup.newAccount.Id, false);
        LeasePayment__c redLeasepayment = leasePayments[0];
        LeasePayment__c yellowLeasepayment = leasePayments[1];
        LeasePayment__c greenLeasepayment = leasePayments[2];

        redLeasepayment.Date_Delivered__c = currentDate.addDays(-31);
        redLeasepayment.Install_Pymnt_Apprvd__c = currentDate;

        yellowLeasepayment.Date_Delivered__c = currentDate.addDays(-26);
        yellowLeasepayment.Install_Pymnt_Apprvd__c = currentDate;

        greenLeasepayment.Date_Delivered__c = currentDate.addDays(-23);
        greenLeasepayment.Install_Pymnt_Apprvd__c = currentDate;

        insert leasePayments;

        Map<Id, LeasePayment__c> leasePaymentMap = new Map<Id, LeasePayment__c>([SELECT Id, SLA_Install_Status__c FROM LeasePayment__c WHERE Id IN :leasePayments]);


        Test.startTest();

            System.runAs(TestLeasePaymentSetup.partnerUser) {
                PartnerTimelineController controller = new PartnerTimelineController();

                controller.assignSLA(stageColumn, leasePaymentMap.get(redLeasepayment.Id), 'SLA_Install_Status__c');
                controller.assignSLA(stageColumn, leasePaymentMap.get(yellowLeasepayment.Id), 'SLA_Install_Status__c');
                controller.assignSLA(stageColumn, leasePaymentMap.get(greenLeasepayment.Id), 'SLA_Install_Status__c');
            }

        Test.stopTest();

        System.assertEquals(1, stageColumn.redSLA.size(), 'One lease payment should be in the red sla list');
        System.assertEquals(1, stageColumn.yellowSLA.size(), 'One lease payment should be in the yellow sla list');
        System.assertEquals(1, stageColumn.greenSLA.size(), 'One lease payment should be in the no sla list');

        System.assertEquals(redLeasePayment.Id, stageColumn.redSLA[0].Id, 'The red leasepayment should be in the redsla list');
        System.assertEquals(yellowLeasepayment.Id, stageColumn.yellowSLA[0].Id, 'The yellow leasepayment should be in the yellowsla list');
        System.assertEquals(greenLeasepayment.Id, stageColumn.greenSLA[0].Id, 'The green leasepayment should be in the no list');

    }

    static testMethod void getSLAValueTest() {
    
        SFDCSpecialUtilities.isRunningTest = True; 
    
        setupCustomSettings();
        TestLeasePaymentSetup.setup();
        Date currentDate = Date.today();


        List<LeasePayment__c> leasePayments = TestUtils.createLeasePayments(3, TestLeasePaymentSetup.newAccount.Id, false);
        LeasePayment__c redLeasepayment = leasePayments[0];
        LeasePayment__c yellowLeasepayment = leasePayments[1];
        LeasePayment__c greenLeasepayment = leasePayments[2];

        redLeasepayment.Date_Delivered__c = currentDate.addDays(-31);
        redLeasepayment.Install_Pymnt_Apprvd__c = currentDate;

        yellowLeasepayment.Date_Delivered__c = currentDate.addDays(-26);
        yellowLeasepayment.Install_Pymnt_Apprvd__c = currentDate;

        greenLeasepayment.Date_Delivered__c = currentDate.addDays(-23);
        greenLeasepayment.Install_Pymnt_Apprvd__c = currentDate;

        insert leasePayments;

        Map<Id, LeasePayment__c> leasePaymentMap = new Map<Id, LeasePayment__c>([SELECT Id, SLA_Install_Status__c FROM LeasePayment__c WHERE Id IN :leasePayments]);


        Test.startTest();

            PartnerTimelineController.SLA actualRedSLA;
            PartnerTimelineController.SLA actualYellowSLA;
            PartnerTimelineController.SLA actualGreenSLA;

            System.runAs(TestLeasePaymentSetup.partnerUser) {
                PartnerTimelineController controller = new PartnerTimelineController();

                actualRedSLA = controller.getSLAValue(leasePaymentMap.get(redLeasepayment.Id), 'SLA_Install_Status__c');
                actualYellowSLA = controller.getSLAValue(leasePaymentMap.get(yellowLeasepayment.Id), 'SLA_Install_Status__c');
                actualGreenSLA = controller.getSLAValue(leasePaymentMap.get(greenLeasepayment.Id), 'SLA_Install_Status__c');
            }

        Test.stopTest();

        System.assertEquals(PartnerTimelineController.SLA.RED, actualRedSLA, 'The RED SLA enum should be returned');
        System.assertEquals(PartnerTimelineController.SLA.YELLOW, actualYellowSLA, 'The YELLOW SLA enum should be returned');
        System.assertEquals(PartnerTimelineController.SLA.GREEN, actualGreenSLA, 'The GREEN SLA enum should be returned');

    }

    static testMethod void PTCTest() {
        setupCustomSettings();
        TestLeasePaymentSetup.setup();

        Test.startTest();

            System.runAs(TestLeasePaymentSetup.partnerUser) {
                PartnerTimelineController controller = new PartnerTimelineController();
                Boolean isStage = controller.isStageSelected;
                String curSym = controller.currencySymbol;
                String negClass = controller.negativeClass; 
                Boolean redLegend = controller.showRedLegend; 
                Boolean yellowLegend = controller.showYellowLegend; 
                Boolean greenLegend = controller.showGreenLegend;
                controller.assignCellToShow();                
                String analytics = controller.ANALYTICS_ID;
                String lsf = controller.leaseStageField;
                String jsn = controller.jsonData;
            }

        Test.stopTest();

    }
    
    private static testMethod void test_currencySymbol() {
        setupCustomSettings();
        TestLeasePaymentSetup.setup();

        System.runAs(TestLeasePaymentSetup.partnerUser) {
            PartnerTimelineController controller = new PartnerTimelineController();
            String currencySymbol = controller.currencySymbol;
        }  
    }

    private static testMethod void test_isStageSelected() {
        setupCustomSettings();
        TestLeasePaymentSetup.setup();

        System.runAs(TestLeasePaymentSetup.partnerUser) {
            PartnerTimelineController controller = new PartnerTimelineController();
            Boolean isStageSelected = controller.isStageSelected;
        }  
    }

    private static testMethod void test_negativeClass() {
        setupCustomSettings();
        TestLeasePaymentSetup.setup();

        System.runAs(TestLeasePaymentSetup.partnerUser) {
            PartnerTimelineController controller = new PartnerTimelineController();
            String negativeClass = controller.negativeClass;
        }  
    }

    private static testMethod void test_showLegend() {
        setupCustomSettings();
        TestLeasePaymentSetup.setup();

        System.runAs(TestLeasePaymentSetup.partnerUser) {
            PartnerTimelineController controller = new PartnerTimelineController();
            Boolean showRedLegend = controller.showRedLegend;
            Boolean showYellowLegend = controller.showYellowLegend;
            Boolean showGreenLegend = controller.showGreenLegend;
            
            controller.newStageSelected = FIRST_LEASE_STAGE;
            controller.selectedStage = FIRST_LEASE_STAGE;
            String redLegendCustomLabel = controller.redLegendCustomLabel;
            String yellowLegendCustomLabel = controller.yellowLegendCustomLabel;
            String greenLegendCustomLabel = controller.greenLegendCustomLabel;
        }  
    }

    private static testMethod void test_ANALYTICS_ID() {
        setupCustomSettings();
        TestLeasePaymentSetup.setup();

        System.runAs(TestLeasePaymentSetup.partnerUser) {
            PartnerTimelineController controller = new PartnerTimelineController();
            String ANALYTICS_ID = controller.ANALYTICS_ID;
        }  
    }

    private static testMethod void test_SignatureModel() {
        setupCustomSettings();
        TestLeasePaymentSetup.setup();

        System.runAs(TestLeasePaymentSetup.partnerUser) {
            PartnerTimelineController.SignatureModel model = new PartnerTimelineController.SignatureModel(new Attachment(), new echosign_dev1__SIGN_Agreement__c());
            Boolean hasAgreement = model.hasAgreement;
            String echosignUrl = model.echosignUrl;
            Boolean hasAttachment = model.hasAttachment;
        }  
    }

    private static testMethod void test_StageColumn() {
        setupCustomSettings();
        TestLeasePaymentSetup.setup();

        System.runAs(TestLeasePaymentSetup.partnerUser) {
            PartnerTimelineController.StageColumn stageColumn = new PartnerTimelineController.StageColumn(FIRST_LEASE_STAGE);
            Boolean isPopulated = stageColumn.isPopulated;
            List<Schema.FieldSetMember> leaseFields = stageColumn.leaseFields;
            List<LeasePayment__c> leasePayments = stageColumn.leasePayments;
            
            PartnerTimelineController controller = new PartnerTimelineController();
            controller.assignLeaseName();
            controller.leaseStage_Beginning();
            controller.leaseStage_End();
            controller.leaseStage_Next();
            controller.leaseStage_End();
            controller.getleaseStage_DisableNext();
            controller.getleaseStage_DisablePrevious();
        }  
    }

}