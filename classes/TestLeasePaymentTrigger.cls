@isTest
private class TestLeasePaymentTrigger {
    static testMethod void testApplyFMVRateOnUpdate()
    {
        SFDCSpecialUtilities.isRunningTest = True;  
        
        final String LEASE_TYPE = 'some type';
        final String STATE = 'MI';
        final Double RATE = 1.23;

        TestLeasePaymentSetup.setup();
        TestLeasePaymentSetup.setupFinancierCustomSettings();

        FMV_Rate__c testRate1 = TestUtils.createRate(TestLeasePaymentSetup.currentDate.addDays(-2), TestLeasePaymentSetup.currentDate.addDays(2), STATE, RATE, false);
        testRate1.Financier__c = TestLeasePaymentSetup.FINANCIER;
        testRate1.Lease_Type__c = LEASE_TYPE;
        insert testRate1;

        List<LeasePayment__c> leasePayments = TestUtils.createLeasePayments(1, TestLeasePaymentSetup.newAccount.Id, false);
        leasePayments[0].Date_Countersigned_old__c = TestLeasePaymentSetup.currentDate;
        leasePayments[0].Site_State_Prov_old__c = STATE;
        leasePayments[0].Funding_Tranche__c = TestLeasePaymentSetup.FINANCIER;
        leasePayments[0].Lease_Type_old__c = LEASE_TYPE;

        insert leasePayments;
        leasePayments = [SELECT Lease_Type__c, Funding_Tranche__c, Site_State_Prov__c, Date_Countersigned__c, Placed_In_Service__c FROM LeasePayment__c WHERE Id IN :leasePayments];
        
        Test.startTest();
            leasePayments[0].Placed_In_Service__c = TestLeasePaymentSetup.currentDate;
            update leasePayments;        
        Test.stopTest();
        
        List<LeasePayment__c> actualLeasePayments = [SELECT FMV_Rate__c FROM LeasePayment__c WHERE Id IN :leasePayments];
        //System.assertEquals(RATE, actualLeasePayments[0].FMV_Rate__c, 'The rate should have been updated');
    }

    static testMethod void testApplyFMVRateOnUpdate_Bulk()
    {
        SFDCSpecialUtilities.isRunningTest = True;  
        
        final String LEASE_TYPE = 'some type';
        final String STATE = 'MI';
        final Double RATE = 1.23;
        final Integer NUM_LEASEPAYMENTS = 50;

        TestLeasePaymentSetup.setup();
        TestLeasePaymentSetup.setupFinancierCustomSettings();

        FMV_Rate__c testRate1 = TestUtils.createRate(TestLeasePaymentSetup.currentDate.addDays(-2), TestLeasePaymentSetup.currentDate.addDays(2), STATE, RATE, false);
        testRate1.Financier__c = TestLeasePaymentSetup.FINANCIER;
        testRate1.Lease_Type__c = LEASE_TYPE;
        insert testRate1;

        List<LeasePayment__c> leasePayments = TestUtils.createLeasePayments(NUM_LEASEPAYMENTS, TestLeasePaymentSetup.newAccount.Id, false);
        for(LeasePayment__c leasePayment : leasePayments) {
            leasePayment.Date_Countersigned_old__c = TestLeasePaymentSetup.currentDate;
            leasePayment.Site_State_Prov_old__c = STATE;
            leasePayment.Funding_Tranche__c = TestLeasePaymentSetup.FINANCIER;
            leasePayment.Lease_Type_old__c = LEASE_TYPE;
        }

        insert leasePayments;

        leasePayments = [SELECT Lease_Type__c, Funding_Tranche__c, Site_State_Prov__c, Date_Countersigned__c, Placed_In_Service__c FROM LeasePayment__c WHERE Id IN :leasePayments];

        Test.startTest();
            for(LeasePayment__c leasePayment : leasePayments) {
                leasePayment.Placed_In_Service__c = TestLeasePaymentSetup.currentDate;
            }
            update leasePayments;
        Test.stopTest();
        
        List<LeasePayment__c> actualLeasePayments = [SELECT FMV_Rate__c FROM LeasePayment__c WHERE Id IN :leasePayments];
        //System.assertEquals(NUM_LEASEPAYMENTS, actualLeasePayments.size(), 'None of the lease payments should be deleted');
        /*for(LeasePayment__c leasePayment : actualLeasePayments) {
            System.assertEquals(RATE, leasePayment.FMV_Rate__c, 'The rate should have been updated');
        }*/
        
    }
}