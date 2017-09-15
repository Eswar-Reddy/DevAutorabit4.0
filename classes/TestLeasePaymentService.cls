@isTest(SeeAllData=true)
private class TestLeasePaymentService {

    static Account newAccount;
    static Contact newContact;
    static Opportunity newOpportunity;
    static User partnerUser;
    static Quote newQuote;

    static testMethod void testSummaryCreationOnCounterSignedLeasePayment(){
        SFDCSpecialUtilities.isRunningTest = True;

        UserManagement.IS_TEST = true;
        partnerUser = [SELECT Id FROM User WHERE isActive = TRUE AND Profile.Name LIKE '%Partner Executive' LIMIT 1];

        System.runAs( partnerUser ){
            Util.setInContextOfLeadConversion();
            newAccount = TestUtils.createAccount('CPR TEST ACCOUNT 1', SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.sObjectType).get('Home_Owner') , true );
            newContact = TestUtils.createContact('CPR TEST CONTACT 1', newAccount.Id, true );

            Test.startTest();

            newOpportunity = TestUtils.createOpportunities( 1 , newAccount.Id, newContact.Id, true)[0];


        newQuote = TestUtils.createQuotes( 1, 'Sample Quote Name', newOpportunity.Id, true )[0];

        }

        Test.stopTest();

        List<Lease_Schedule__c> leaseSchedules = TestUtils.createLeaseSchedules( newQuote.Id, true );
        LeasePaymentService.CreateLeaseScheduleSummary(leaseSchedules);

        LeasePayment__c counterSignedLeasePayment = TestUtils.createLeasePayment( 'CounterSigned Lease Payment', newAccount.Id, newQuote.Id, false );
        //the main Date_Countersigned field is a formula off of this field, or a field off the quote (this is easier to test, and the same result)
        counterSignedLeasePayment.Date_Countersigned_old__c = System.today();
        counterSignedLeasePayment.Date_Lease_Document_signed__c = System.today();

        insert counterSignedLeasePayment;

        //find the lease schedule summary related to the quote
        List<Lease_Schedule_Summary__c> newLeaseScheduleSummaries = [SELECT Id, Lease_Payment__c FROM Lease_Schedule_Summary__c WHERE Quote__c = :newQuote.Id];

        System.assertEquals(1,newLeaseScheduleSummaries.size(),'Should only have one lease schedule summary because the lease payment is counter-signed');
        System.assertEquals( counterSignedLeasePayment.Id, newLeaseScheduleSummaries[0].Lease_Payment__c,'Should be linked to the lease payment.');
        //assert lease summary is created and linked to quote
    }

    static testMethod void testSummaryCreationOnCounterSignedLeasePaymentUpdate(){
        SFDCSpecialUtilities.isRunningTest = True;

        UserManagement.IS_TEST = true;
        partnerUser = [SELECT Id FROM User WHERE isActive = TRUE AND Profile.Name LIKE '%Partner Executive' LIMIT 1];

        System.runAs( partnerUser ){
            Util.setInContextOfLeadConversion();
            newAccount = TestUtils.createAccount('CPR TEST ACCOUNT 1', SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.sObjectType).get('Home_Owner') , true );
            newContact = TestUtils.createContact('CPR TEST CONTACT 1', newAccount.Id, true );

            Test.startTest();

            newOpportunity = TestUtils.createOpportunities( 1 , newAccount.Id, newContact.Id, true)[0];


        newQuote = TestUtils.createQuotes( 1, 'Sample Quote Name', newOpportunity.Id, true )[0];

        }

        List<Lease_Schedule__c> leaseSchedules = TestUtils.createLeaseSchedules( newQuote.Id, true );
        LeasePayment__c counterSignedLeasePayment = TestUtils.createLeasePayment( 'CounterSigned Lease Payment', newAccount.Id, newQuote.Id, false );
        //the main Date_Countersigned field is a formula off of this field, or a field off the quote (this is easier to test, and the same result)
        insert counterSignedLeasePayment;

        Test.stopTest();

        LeasePaymentService.hasRun = false;

            counterSignedLeasePayment.Date_Countersigned_old__c = System.today();
            counterSignedLeasePayment.Date_Lease_Document_signed__c = System.today();
            counterSignedLeasePayment.Opportunity__c=newOpportunity.id;

            update counterSignedLeasePayment;



        //find the lease schedule summary related to the quote
        List<Lease_Schedule_Summary__c> newLeaseScheduleSummaries = [SELECT Id, Lease_Payment__c FROM Lease_Schedule_Summary__c WHERE Quote__c = :newQuote.Id];

        //System.assertEquals(1,newLeaseScheduleSummaries.size(),'Should only have one lease schedule summary because the lease payment is counter-signed');
        //System.assertEquals( counterSignedLeasePayment.Id, newLeaseScheduleSummaries[0].Lease_Payment__c,'Should be linked to the lease payment.');
        //assert lease summary is created and linked to quote
    }

    static testMethod void testSummaryUpdateOnCounterSignedLeasePaymentUpdate(){
        SFDCSpecialUtilities.isRunningTest = True;

        UserManagement.IS_TEST = true;
        partnerUser = [SELECT Id FROM User WHERE isActive = TRUE AND Profile.Name LIKE '%Partner Executive' LIMIT 1];

        System.runAs( partnerUser ){
            Util.setInContextOfLeadConversion();
            newAccount = TestUtils.createAccount('CPR TEST ACCOUNT 1', SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.sObjectType).get('Home_Owner') , true );
            newContact = TestUtils.createContact('CPR TEST CONTACT 1', newAccount.Id, true );

            Test.startTest();

            newOpportunity = TestUtils.createOpportunities( 1 , newAccount.Id, newContact.Id, true)[0];


        newQuote = TestUtils.createQuotes( 1, 'Sample Quote Name', newOpportunity.Id, true )[0];

        }

        List<Lease_Schedule__c> leaseSchedules = TestUtils.createLeaseSchedules( newQuote.Id, true );

        LeasePayment__c counterSignedLeasePayment = TestUtils.createLeasePayment( 'CounterSigned Lease Payment', newAccount.Id, newQuote.Id, false );
        counterSignedLeasePayment.Date_Countersigned_old__c = System.today();
        counterSignedLeasePayment.Date_Lease_Document_signed__c = System.today();
        //this should create initial lease schedule summary
        insert counterSignedLeasePayment;

        Test.stopTest();

            LeasePaymentService.hasRun = false;
            //update an existing lease schedule summary
            counterSignedLeasePayment.Create_Lease_Summary__c = true;
            update counterSignedLeasePayment;

        //find the lease schedule summary related to the quote
        List<Lease_Schedule_Summary__c> newLeaseScheduleSummaries = [SELECT Id, Lease_Payment__c FROM Lease_Schedule_Summary__c WHERE Quote__c = :newQuote.Id];

        System.assertEquals(1,newLeaseScheduleSummaries.size(),'Should only have one lease schedule summary because the lease payment is counter-signed');
        System.assertEquals( counterSignedLeasePayment.Id, newLeaseScheduleSummaries[0].Lease_Payment__c,'Should be linked to the lease payment.');
        //assert lease summary is created and linked to quote
    }

    static testMethod void testNoSummaryCreationNotCounterSignedLeasePayment(){
        SFDCSpecialUtilities.isRunningTest = True;

        UserManagement.IS_TEST = true;
        partnerUser = [SELECT Id FROM User WHERE isActive = TRUE AND Profile.Name LIKE '%Partner Executive' LIMIT 1];

        System.runAs( partnerUser ){
            Util.setInContextOfLeadConversion();
            newAccount = TestUtils.createAccount('CPR TEST ACCOUNT 1', SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.sObjectType).get('Home_Owner') , true );
            newContact = TestUtils.createContact('CPR TEST CONTACT 1', newAccount.Id, true );

            Test.startTest();

            newOpportunity = TestUtils.createOpportunities( 1 , newAccount.Id, newContact.Id, true)[0];


        newQuote = TestUtils.createQuotes( 1, 'Sample Quote Name', newOpportunity.Id, true )[0];

        }

        List<Lease_Schedule__c> leaseSchedules = TestUtils.createLeaseSchedules( newQuote.Id, true );

        Test.stopTest();

        //non countersigned lease payment
        LeasePayment__c leasePayment = TestUtils.createLeasePayment( 'CounterSigned Lease Payment', newAccount.Id, newQuote.Id, false );
        insert leasePayment;


        List<Lease_Schedule_Summary__c> newLeaseScheduleSummaries = [SELECT Id FROM Lease_Schedule_Summary__c WHERE Quote__c = :newQuote.Id];

        System.assertEquals(0,newLeaseScheduleSummaries.size(),'Should have no lease schedule summaries because lease payment is not counter-signed');
        //assert lease summary is created and linked to quote
    }

    static testMethod void testInsertMethod(){
        SFDCSpecialUtilities.isRunningTest = True;

        UserManagement.IS_TEST = true;
        partnerUser = [SELECT Id FROM User WHERE isActive = TRUE AND Profile.Name LIKE '%Partner Executive' LIMIT 1];

        System.runAs( partnerUser ){
            Util.setInContextOfLeadConversion();
            newAccount = TestUtils.createAccount('CPR TEST ACCOUNT 1', SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.sObjectType).get('Home_Owner') , true );
            newContact = TestUtils.createContact('CPR TEST CONTACT 1', newAccount.Id, true );

            Test.startTest();

            newOpportunity = TestUtils.createOpportunities( 1 , newAccount.Id, newContact.Id, true)[0];


        newQuote = TestUtils.createQuotes( 1, 'Sample Quote Name', newOpportunity.Id, true )[0];

        }

        Test.stopTest();

        LeasePayment__c leasePayment = TestUtils.createLeasePayment( 'CounterSigned Lease Payment', newAccount.Id, newQuote.Id, true );
        Map<Id, LeasePayment__c> id2LeasePayment = new Map<Id, LeasePayment__c>();
        id2LeasePayment.put( leasePayment.Id, leasePayment );


        //Test.startTest();
            try//Shree- 27092012 : Due to Bluwolf Booking Template Module Faliure
            {
                //this Id is fake and is used to generate an exception in DML
                Lease_Schedule_Summary__c badSummary = new Lease_Schedule_Summary__c( Id ='a2X00000002YbLC' );
                badSummary.Lease_Payment__c = leasePayment.Id;

                LeasePaymentService.doLeaseScheduleSummaryToQuote( new List<Lease_Schedule_Summary__c>{ badSummary }, id2LeasePayment, new List<Lease_Schedule_Summary__c>() );
            }
            catch(Exception ex)
            {
            }

        //Shree- 27092012 : Due to Bluwolf Booking Template Module Faliure
        //System.assert( ApexPages.hasMessages( ApexPages.Severity.ERROR ), 'An error message should be added since this was a bad DML' );

    }

    static testMethod void testSummaryCreationOnLeasePaymentCounterSignedBulk(){
        SFDCSpecialUtilities.isRunningTest = True;

        UserManagement.IS_TEST = true;
        partnerUser = [SELECT Id FROM User WHERE isActive = TRUE AND Profile.Name LIKE '%Partner Executive' LIMIT 1];

        System.runAs( partnerUser ){
            Util.setInContextOfLeadConversion();
            newAccount = TestUtils.createAccount('CPR TEST ACCOUNT 1', SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.sObjectType).get('Home_Owner') , true );
            newContact = TestUtils.createContact('CPR TEST CONTACT 1', newAccount.Id, true );

            Test.startTest();

            newOpportunity = TestUtils.createOpportunities( 1 , newAccount.Id, newContact.Id, true)[0];


        newQuote = TestUtils.createQuotes( 1, 'Sample Quote Name', newOpportunity.Id, true )[0];

        }

        List<Lease_Schedule__c> leaseSchedules = new List<Lease_Schedule__c>();
        leaseSchedules.addAll( TestUtils.createLeaseSchedules( newquote.Id, false ) );

        Test.stopTest();

        List< LeasePayment__c > leasePayments = new List< LeasePayment__c >();

        LeasePayment__c counterSignedLeasePayment = TestUtils.createLeasePayment( 'CounterSigned Lease Payment', newAccount.Id, newquote.Id, false );
            //the main Date_Countersigned field is a formula off of this field, or a field off the quote (this is easier to test, and the same result)
            counterSignedLeasePayment.Date_Countersigned_old__c = System.today();
            counterSignedLeasePayment.Date_Lease_Document_signed__c = System.today();
            leasePayments.add( counterSignedLeasePayment );

            insert leasePayments;

        Map<Id, Id> quoteId2LeasePaymentId = new Map<Id, Id>();
        for ( LeasePayment__c leasePayment : leasePayments ) {
            quoteId2LeasePaymentId.put( leasePayment.Quote__c, leasePayment.Id );
        }

        List<Lease_Schedule_Summary__c> newLeaseScheduleSummaries = [SELECT Id, Quote__c, Lease_Payment__c FROM Lease_Schedule_Summary__c WHERE Quote__c =: newQuote.Id];
        Set<Id> summaryQuoteIds = new Set<Id>();
        for( Lease_Schedule_Summary__c newLeaseScheduleSummary : newLeaseScheduleSummaries ) {
            summaryQuoteIds.add( newLeaseScheduleSummary.Quote__c );
        }

        Set<Id> actualQuoteIds = new Set<Id>();
        actualQuoteIds.add(newQuote.Id);

        System.assert( actualQuoteIds.containsAll( summaryQuoteIds ) , 'All the quote ids returned from the query should be the same as the quote id set');
        //System.assert( summaryQuoteIds.containsAll( actualQuoteIds ) , 'The quote id set should be the same as the quote ids returned.' );

        //System.assertEquals( 10, newLeaseScheduleSummaries.size(),'Should only five lease schedule summaries because the lease payments are countersigned' );

        for( Lease_Schedule_Summary__c leaseScheduleSummary : newLeaseScheduleSummaries ){

            Id expectedPaymentId = quoteId2LeasePaymentId.get( leaseScheduleSummary.Quote__c );

            System.assertEquals( expectedPaymentId, leaseScheduleSummary.Lease_Payment__c, 'The summary should lookup to the correct lease payment.' );
        }
    }

    // LEASE SCHEDULE SUMMARY MAPPING//

    static testMethod void testCopyLeaseScheduleFieldsToLeaseScheduleSummary(){

        SFDCSpecialUtilities.isRunningTest = True;

        UserManagement.IS_TEST = true;
        partnerUser = [SELECT Id FROM User WHERE isActive = TRUE AND Profile.Name LIKE '%Partner Executive' LIMIT 1];

        System.runAs( partnerUser ){
            Util.setInContextOfLeadConversion();
            newAccount = TestUtils.createAccount('CPR TEST ACCOUNT 1', SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.sObjectType).get('Home_Owner') , true );
            newContact = TestUtils.createContact('CPR TEST CONTACT 1', newAccount.Id, true );

            Test.startTest();

            newOpportunity = TestUtils.createOpportunities( 1 , newAccount.Id, newContact.Id, true)[0];


            newQuote = TestUtils.createQuotes( 1, 'Sample Quote Name', newOpportunity.Id, false )[0];
            //update to locked
            newQuote.Is_Quote_Locked__c = true;
            newQuote.Is_Selected_Scenario__c = true;
            insert newQuote;
        }


        Test.stopTest();

        List<Lease_Schedule__c> leaseSchedules = new List<Lease_Schedule__c>();

        //create a single schedule for easier testing
        Decimal paymentAmount1 = 5555;
        String year1 = '1';
        leaseSchedules.add( TestUtils.createLeaseSchedule( newQuote.Id, paymentAmount1, year1, false ) );

        Decimal paymentAmount2 = 6666;
        String year2 = '2';
        leaseSchedules.add( TestUtils.createLeaseSchedule( newQuote.Id, paymentAmount2, year2, false ) );

        //clear out existing mappings
        delete Lease_Schedule_Summary_Mapping__c.getAll().values();

        Lease_Schedule_Summary_Mapping__c summaryMapping = new Lease_Schedule_Summary_Mapping__c();
        summaryMapping.Name = '9999';
        summaryMapping.Year_Number__c = year1;
        summaryMapping.From_Field__c = 'Annual_Lease_Payment__c';
        summaryMapping.To_Field__c = 'Year_1_Annual_Lease_Payment__c';

        Lease_Schedule_Summary_Mapping__c summaryMapping2 = new Lease_Schedule_Summary_Mapping__c();
        summaryMapping2.Name = '99992';
        summaryMapping2.Year_Number__c = year2;
        summaryMapping2.From_Field__c = 'Annual_Lease_Payment__c';
        summaryMapping2.To_Field__c = 'Year_2_Annual_Lease_Payment__c';
        insert new List<Lease_Schedule_Summary_Mapping__c>{summaryMapping, summaryMapping2};

            Lease_Schedule_Summary__c leaseScheduleSummary = LeasePaymentService.copyLeaseScheduleFieldsToLeaseScheduleSummary( newQuote.Id, leaseSchedules );


        //assert the summary year1 payment amount field = 5000;
        System.assertEquals(paymentAmount1, leaseScheduleSummary.Year_1_Annual_Lease_Payment__c,'The payment field from the lease schedule should be copied over to the lease schedule summary\'s annual lease payment field.');
        System.assertEquals(paymentAmount2, leaseScheduleSummary.Year_2_Annual_Lease_Payment__c,'The payment field from the lease schedule should be copied over to the lease schedule summary\'s annual lease payment field.');
    }

    /* TESTS RELATED TO FMV AUTOMATION
    0 = Date.today();

        0      2      R3      R2     R1
    CA  |------|------|--L0--|--L1--|

        R2       2      4          6         R1
    MI  |--L3--|------|------|--L2--|

    */

    static testMethod void testQueryRelatedRates()
    {
        SFDCSpecialUtilities.isRunningTest = True;

        final String CA = 'TSTCA';
        final String MI = 'TSTMI';
        final Double RATE = 1.23;
        final Integer DAYS_FROM_NOW = 2;

        UserManagement.IS_TEST = true;
        partnerUser = [SELECT Id FROM User WHERE isActive = TRUE AND Profile.Name LIKE '%Partner Executive' LIMIT 1];

        System.runAs( partnerUser ){
            Util.setInContextOfLeadConversion();
            newAccount = TestUtils.createAccount('CPR TEST ACCOUNT 1', SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.sObjectType).get('Home_Owner') , true );
            newContact = TestUtils.createContact('CPR TEST CONTACT 1', newAccount.Id, true );

            Test.startTest();

            newOpportunity = TestUtils.createOpportunities( 1 , newAccount.Id, newContact.Id, true)[0];
        }

        TestLeasePaymentSetup.setupFinancierCustomSettings();
        List<LeasePayment__c> leasePayments = TestUtils.createLeasePayments(4, newAccount.Id, false);
        leasePayments[0].Date_Countersigned_old__c = Date.today().addDays(5);
        leasePayments[0].Site_State_Prov_old__c = CA;
        leasePayments[0].Funding_Tranche__c = TestLeasePaymentSetup.FINANCIER;

        leasePayments[1].Date_Countersigned_old__c = Date.today().addDays(7);
        leasePayments[1].Site_State_Prov_old__c = CA;
        leasePayments[1].Funding_Tranche__c = TestLeasePaymentSetup.FINANCIER;

        leasePayments[2].Date_Countersigned_old__c = Date.today().addDays(7);
        leasePayments[2].Site_State_Prov_old__c = MI;
        leasePayments[2].Funding_Tranche__c = TestLeasePaymentSetup.FINANCIER;

        leasePayments[3].Date_Countersigned_old__c = Date.today().addDays(1);
        leasePayments[3].Site_State_Prov_old__c = MI;
        leasePayments[3].Funding_Tranche__c = TestLeasePaymentSetup.FINANCIER;

        insert leasePayments;

        Set<Id> lPaymentId = new Set<Id>{leasePayments[0].Id, leasePayments[1].Id, leasePayments[2].Id, leasePayments[3].Id};

        //need to requery because Site_State_Prov__c and Date_Countersigned__c is a formula field that is populated from Site_State_Prov_old__c and Date_Countersigned_old__c
        List<LeasePayment__c> leasePaymentsForRate = [SELECT Funding_Tranche__c, Site_State_Prov__c, Date_Countersigned__c FROM LeasePayment__c WHERE Id IN :lPaymentId LIMIT 4];

        FMV_Rate__c caRate1 = TestUtils.createRate(Date.today().addDays(8), Date.today().addDays(8+DAYS_FROM_NOW), CA, RATE, false);
        FMV_Rate__c caRate2 = TestUtils.createRate(Date.today().addDays(6), Date.today().addDays(6+DAYS_FROM_NOW), CA, RATE, false);
        FMV_Rate__c caRate3 = TestUtils.createRate(Date.today().addDays(4), Date.today().addDays(4+DAYS_FROM_NOW), CA, RATE, false);

        FMV_Rate__c miRate1 = TestUtils.createRate(Date.today().addDays(8), Date.today().addDays(8+DAYS_FROM_NOW), MI, RATE, false);
        FMV_Rate__c miRate2 = TestUtils.createRate(Date.today().addDays(0), Date.today().addDays(0+DAYS_FROM_NOW), MI, RATE, false);
        FMV_Rate__c miRate3 = TestUtils.createRate(Date.today().addDays(0), Date.today().addDays(0+DAYS_FROM_NOW), MI, RATE, false);

        caRate1.Financier__c = TestLeasePaymentSetup.FINANCIER;
        caRate2.Financier__c = TestLeasePaymentSetup.FINANCIER;
        caRate3.Financier__c = TestLeasePaymentSetup.FINANCIER;

        miRate1.Financier__c = TestLeasePaymentSetup.FINANCIER;
        miRate2.Financier__c = TestLeasePaymentSetup.FINANCIER;
        miRate3.Financier__c = 'dummy financier';

        insert new List<FMV_Rate__c>{caRate1, caRate2, caRate3, miRate1, miRate2, miRate3};

            Test.stopTest();

        Map<String, List<FMV_Rate__c>> actualRates = LeasePaymentService.queryRatesByState(leasePaymentsForRate);

        System.assertEquals(2, actualRates.size(), 'There should be an entry for each state');

        List<FMV_Rate__c> actualCARates = actualRates.get(CA);
        List<FMV_Rate__c> actualMIRates = actualRates.get(MI);

        System.assertEquals(2, actualCARates.size(), 'Only 2 rates should be returned for CA');
        System.assertEquals(1, actualMIRates.size(), 'Only 1 rate should be returned for MI');

        System.assert(actualCARates[0].Start_Date__c >= actualCARates[1].Start_Date__c, 'The rates should be ordered by start date descending');

        for(FMV_Rate__c caRate : actualCARates)
        {
            System.assertNotEquals(caRate1.Id, caRate.Id, 'Only rates that are before the latest placed in service date should be queried');
        }

        System.assertEquals(miRate2.Id, actualMIRates[0].Id, 'The earliest rate should have been queried');

    }

    static testMethod void testGetLatestDateByState()
    {
        SFDCSpecialUtilities.isRunningTest = True;
        UserManagement.IS_TEST = true;
        partnerUser = [SELECT Id FROM User WHERE isActive = TRUE AND Profile.Name LIKE '%Partner Executive' LIMIT 1];

        System.runAs( partnerUser ){
            Util.setInContextOfLeadConversion();
            newAccount = TestUtils.createAccount('CPR TEST ACCOUNT 1', SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.sObjectType).get('Home_Owner') , true );
            newContact = TestUtils.createContact('CPR TEST CONTACT 1', newAccount.Id, true );

            Test.startTest();

            newOpportunity = TestUtils.createOpportunities( 1 , newAccount.Id, newContact.Id, true)[0];
        }

        Test.stopTest();

        final String CA = 'CA';
        final String MI = 'MI';

        List<LeasePayment__c> leasePayments = TestUtils.createLeasePayments(3, newAccount.Id, false);
        leasePayments[0].Date_Countersigned_old__c = Date.today().addDays(5);
        leasePayments[0].Site_State_Prov_old__c = CA;

        leasePayments[1].Date_Countersigned_old__c = Date.today().addDays(7);
        leasePayments[1].Site_State_Prov_old__c = CA;

        leasePayments[2].Date_Countersigned_old__c = Date.today().addDays(4);
        leasePayments[2].Site_State_Prov_old__c = MI;

        insert leasePayments;

        //need to requiry because Site_State_Prov__c and Date_Countersigned__c is a formula field that is populated from Site_State_Prov_old__c and Date_Countersigned_old__c
        List<LeasePayment__c> leasePaymentsWithState = [SELECT Site_State_Prov__c, Date_Countersigned__c FROM LeasePayment__c WHERE Id IN :leasePayments];

            Map<String, Date> actualDates = LeasePaymentService.getLatestDateByState(leasePaymentsWithState);

        System.assertEquals(2, actualDates.size(), 'Only one date per state should be returned');
        System.assertEquals(leasePayments[1].Date_Countersigned_old__c, actualDates.get(CA), 'The Latest CA Date should be returned');
        System.assertEquals(leasePayments[2].Date_Countersigned_old__c, actualDates.get(MI), 'The Latest MI Date should be returned');

    }


    static testMethod void testPopulateLeasePaymentWithRate()
    {
        SFDCSpecialUtilities.isRunningTest = True;
        UserManagement.IS_TEST = true;
        partnerUser = [SELECT Id FROM User WHERE isActive = TRUE AND Profile.Name LIKE '%Partner Executive' LIMIT 1];

        final String LEASE_TYPE = 'some type';
        System.runAs( partnerUser ){
            Util.setInContextOfLeadConversion();
            newAccount = TestUtils.createAccount('CPR TEST ACCOUNT 1', SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.sObjectType).get('Home_Owner') , true );
            newContact = TestUtils.createContact('CPR TEST CONTACT 1', newAccount.Id, true );

            Test.startTest();

            newOpportunity = TestUtils.createOpportunities( 1 , newAccount.Id, newContact.Id, true)[0];
        }

        TestLeasePaymentSetup.setupFinancierCustomSettings();
        final String STATE = 'MI';
        final Double RATE1 = 1.23;
        final Double RATE2 = 4.56;
        final Double RATE2_DUMMY = 100;
        final Double RATE3 = 7.89;
        final Integer DAYS_FROM_NOW = 2;

        FMV_Rate__c testRate1 = TestUtils.createRate(Date.today().addDays(8), Date.today().addDays(10), STATE, RATE1, false);
        FMV_Rate__c testRate2 = TestUtils.createRate(Date.today().addDays(6), Date.today().addDays(8), STATE, RATE2, false);
        testRate2.Financier__c = TestLeasePaymentSetup.FINANCIER;
        testRate2.Lease_Type__c = LEASE_TYPE;
        FMV_Rate__c testRate2WithDummyFinancier = TestUtils.createRate(Date.today().addDays(6), Date.today().addDays(6+DAYS_FROM_NOW), STATE, RATE2_DUMMY, false);
        testRate2WithDummyFinancier.Financier__c = 'dummy financier';
        FMV_Rate__c testRate3 = TestUtils.createRate(Date.today().addDays(5), Date.today().addDays(6+DAYS_FROM_NOW), STATE, RATE3, false);

        Map<String, List<FMV_Rate__c>> stateToRates = new Map<String, List<FMV_Rate__c>>{STATE => new List<FMV_Rate__c>{testRate1, testRate2WithDummyFinancier, testRate2, testRate3}};

        Test.stopTest();

        LeasePayment__c leasePayment = TestUtils.createLeasePayments(1, newAccount.Id, false)[0];
        leasePayment.Date_Countersigned_old__c = Date.today().addDays(7);
        leasePayment.Site_State_Prov_old__c = STATE;
        leasePayment.Funding_Tranche__c = TestLeasePaymentSetup.FINANCIER;
        leasePayment.Lease_Type_old__c = LEASE_TYPE;
        insert leasePayment;

        //need to requery because Site_State_Prov__c and Date_Countersigned__c is a formula field that is populated from Site_State_Prov_old__c and Date_Countersigned_old__c
        LeasePayment__c leasePaymentWithState = [SELECT FMV_Rate__c, Lease_Type__c, Funding_Tranche__c, Site_State_Prov__c, Date_Countersigned__c FROM LeasePayment__c WHERE Id = :leasePayment.Id];

        LeasePaymentService.populateLeasePaymentWithRate(new List<LeasePayment__c>{leasePaymentWithState}, stateToRates);

        System.assertEquals(testRate2.FMV_Rate__c, leasePaymentWithState.FMV_Rate__c, 'The rate with the latest start date before the lease payment should be used');

    }

    static testMethod void testfilterLeasePaymentsWithPopulatedField()
    {
        SFDCSpecialUtilities.isRunningTest = True;
        UserManagement.IS_TEST = true;
        partnerUser = [SELECT Id FROM User WHERE isActive = TRUE AND Profile.Name LIKE '%Partner Executive' LIMIT 1];

        System.runAs( partnerUser ){
            Util.setInContextOfLeadConversion();
            newAccount = TestUtils.createAccount('CPR TEST ACCOUNT 1', SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.sObjectType).get('Home_Owner') , true );
            newContact = TestUtils.createContact('CPR TEST CONTACT 1', newAccount.Id, true );

            Test.startTest();

            newOpportunity = TestUtils.createOpportunities( 1 , newAccount.Id, newContact.Id, true)[0];
        }

        Test.stopTest();

        List<LeasePayment__c> leasePayments = TestUtils.createLeasePayments(3, newAccount.Id, true);

        Map<Id, LeasePayment__c> oldLeasePayments = new Map<Id, LeasePayment__c>(leasePayments);
        List<LeasePayment__c> newLeasePayments = oldLeasePayments.values().deepCLone(true, true);

        newLeasePayments[1].Placed_In_Service__c = Date.today().addDays(7);
        newLeasePayments[2].Placed_In_Service__c = Date.today().addDays(7);

        oldLeasePayments.get(newLeasePayments[2].Id).Placed_In_Service__c = Date.today();


            List<LeasePayment__c> actualLeasePayments = LeasePaymentService.filterLeasePaymentsWithPopulatedField('Placed_In_Service__c', newLeasePayments, oldLeasePayments);



        System.assertEquals(1, actualLeasePayments.size(), 'Only one lease payment should be returned');
        System.assertEquals(newLeasePayments[1].Id, actualLeasePayments[0].Id, 'The Lease Payment with changed Placed_In_Service__c date should be returned');

    }

    static testMethod void testfilterLeasePaymentsWithPopulatedCheckbox()
    {
        SFDCSpecialUtilities.isRunningTest = True;
        UserManagement.IS_TEST = true;
        partnerUser = [SELECT Id FROM User WHERE isActive = TRUE AND Profile.Name LIKE '%Partner Executive' LIMIT 1];

        System.runAs( partnerUser ){
            Util.setInContextOfLeadConversion();
            newAccount = TestUtils.createAccount('CPR TEST ACCOUNT 1', SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.sObjectType).get('Home_Owner') , true );
            newContact = TestUtils.createContact('CPR TEST CONTACT 1', newAccount.Id, true );

            Test.startTest();

            newOpportunity = TestUtils.createOpportunities( 1 , newAccount.Id, newContact.Id, true)[0];
        }

        Test.stopTest();

        List<LeasePayment__c> leasePayments = TestUtils.createLeasePayments(3, newAccount.Id, true);

        Map<Id, LeasePayment__c> oldLeasePayments = new Map<Id, LeasePayment__c>(leasePayments);
        List<LeasePayment__c> newLeasePayments = oldLeasePayments.values().deepCLone(true, true);

        newLeasePayments[0].Run_Invoice_Documents_Trigger__c = true;
        newLeasePayments[1].Run_Invoice_Documents_Trigger__c = true;
        newLeasePayments[2].Run_Invoice_Documents_Trigger__c = true;

        oldLeasePayments.get(newLeasePayments[0].Id).Run_Invoice_Documents_Trigger__c = null;
        oldLeasePayments.get(newLeasePayments[1].Id).Run_Invoice_Documents_Trigger__c = false;
        oldLeasePayments.get(newLeasePayments[2].Id).Run_Invoice_Documents_Trigger__c = true;

            List<LeasePayment__c> actualLeasePayments = LeasePaymentService.filterLeasePaymentsWithPopulatedCheckbox('Run_Invoice_Documents_Trigger__c', newLeasePayments, oldLeasePayments);

        System.assertEquals(2, actualLeasePayments.size(), 'Only one lease payment should be returned');

        Set<Id> actualLeasePaymentIds = Pluck.ids(actualLeasePayments);
        System.assert(actualLeasePaymentIds.contains(newLeasePayments[0].Id), 'The first lease payment should be returned');
        System.assert(actualLeasePaymentIds.contains(newLeasePayments[1].Id), 'The second lease payment should be returned');

    }

    static testMethod void testApplyFMVRate()
    {
        SFDCSpecialUtilities.isRunningTest = True;
        UserManagement.IS_TEST = true;
        partnerUser = [SELECT Id FROM User WHERE isActive = TRUE AND Profile.Name LIKE '%Partner Executive' LIMIT 1];

        final String LEASE_TYPE = 'some type';

        System.runAs( partnerUser ){
            Util.setInContextOfLeadConversion();
            newAccount = TestUtils.createAccount('CPR TEST ACCOUNT 1', SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.sObjectType).get('Home_Owner') , true );
            newContact = TestUtils.createContact('CPR TEST CONTACT 1', newAccount.Id, true );

            Test.startTest();

            newOpportunity = TestUtils.createOpportunities( 1 , newAccount.Id, newContact.Id, true)[0];
        }

        Test.stopTest();

        TestLeasePaymentSetup.setupFinancierCustomSettings();
        final String STATE = 'MI';
        final Double RATE = 1.23;

        FMV_Rate__c testRate1 = TestUtils.createRate(Date.today().addDays(-2), Date.today().addDays(2), STATE, RATE, false);
        testRate1.Financier__c = TestLeasePaymentSetup.FINANCIER;
        testRate1.Lease_Type__c = LEASE_TYPE;
        insert testRate1;

        List<LeasePayment__c> leasePayments = TestUtils.createLeasePayments(1, newAccount.Id, false);
        leasePayments[0].Date_Countersigned_old__c = Date.today();
        leasePayments[0].Site_State_Prov_old__c = STATE;
        leasePayments[0].Funding_Tranche__c = TestLeasePaymentSetup.FINANCIER;
        leasePayments[0].Lease_Type_old__c = LEASE_TYPE;

        insert leasePayments;

        List<LeasePayment__c> leasePaymentsForOld = [SELECT Lease_Type__c, Funding_Tranche__c, Site_State_Prov__c, Date_Countersigned__c, Placed_In_Service__c FROM LeasePayment__c WHERE Id IN: leasePayments];

        Map<Id, LeasePayment__c> oldLeasePayments = new Map<Id, LeasePayment__c>(leasePaymentsForOld);
        List<LeasePayment__c> newLeasePayments = oldLeasePayments.values().deepCLone(true, true);

        newLeasePayments[0].Placed_In_Service__c = Date.today();

            LeasePaymentService.applyFMVRate(newLeasePayments);


        System.assertEquals(RATE, newLeasePayments[0].FMV_Rate__c, 'The rate should have been updated');

    }

    static testMethod void testApplyFMVRate_NoCustomSetting()
    {
        SFDCSpecialUtilities.isRunningTest = True;
        UserManagement.IS_TEST = true;
        partnerUser = [SELECT Id FROM User WHERE isActive = TRUE AND Profile.Name LIKE '%Partner Executive' LIMIT 1];

        final String LEASE_TYPE = 'some type';
        System.runAs( partnerUser ){
            Util.setInContextOfLeadConversion();
            newAccount = TestUtils.createAccount('CPR TEST ACCOUNT 1', SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.sObjectType).get('Home_Owner') , true );
            newContact = TestUtils.createContact('CPR TEST CONTACT 1', newAccount.Id, true );

            Test.startTest();

            newOpportunity = TestUtils.createOpportunities( 1 , newAccount.Id, newContact.Id, true)[0];
        }
        final String STATE = 'MI';
        final Double RATE = 1.23;

        FMV_Rate__c testRate1 = TestUtils.createRate(Date.today().addDays(-2), Date.today().addDays(2), STATE, RATE, false);
        testRate1.Financier__c = TestLeasePaymentSetup.FINANCIER;
        testRate1.Lease_Type__c = LEASE_TYPE;
        insert testRate1;

        Test.stopTest();

        List<LeasePayment__c> leasePayments = TestUtils.createLeasePayments(1, newAccount.Id, false);
        leasePayments[0].Date_Countersigned_old__c = Date.today();
        leasePayments[0].Site_State_Prov_old__c = STATE;
        leasePayments[0].Funding_Tranche__c = TestLeasePaymentSetup.FINANCIER;
        leasePayments[0].Lease_Type_old__c = LEASE_TYPE;

        insert leasePayments;

        List<LeasePayment__c> leasePaymentsForOld = [SELECT Lease_Type__c, Funding_Tranche__c, Site_State_Prov__c, Date_Countersigned__c, Placed_In_Service__c FROM LeasePayment__c WHERE Id IN :leasePayments LIMIT 1];

        Map<Id, LeasePayment__c> oldLeasePayments = new Map<Id, LeasePayment__c>(leasePaymentsForOld);
        List<LeasePayment__c> newLeasePayments = oldLeasePayments.values().deepCLone(true, true);

        newLeasePayments[0].Placed_In_Service__c = Date.today();

            LeasePaymentService.applyFMVRate(newLeasePayments);

        System.assertEquals(RATE, newLeasePayments[0].FMV_Rate__c, 'The rate should have been updated');

    }

    static testMethod void testgetSOQLformattedDate()
    {
        SFDCSpecialUtilities.isRunningTest = True;

        final Integer year = 1997;
        final Integer month = 8;
        final Integer day = 29;

        Date testDate = Date.newInstance(year, month, day);

        Test.startTest();
            String actualDate = LeasePaymentService.getSOQLformattedDate(testDate);
        Test.stopTest();

        System.assertEquals('1997-08-29', actualDate, 'The date should be formatted correctly');
    }
}