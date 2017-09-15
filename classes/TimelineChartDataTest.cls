@isTest
private class TimelineChartDataTest {

    final static String FIRST_LEASE_STAGE = 'Fully Signed Contract';
    final static String SECOND_LEASE_STAGE = 'Material Delivered';

    static testMethod void buildGoogleVizTest() {

        SFDCSpecialUtilities.isRunningTest = True; 
        
        TestLeasePaymentSetup.setup();

        List<LeasePayment__c> leasePayments = TestUtils.createLeasePayments(2, TestLeasePaymentSetup.newAccount.Id, false);
        LeasePayment__c firstLease = leasePayments[0];
        LeasePayment__c secondLease = leasePayments[1];

        Id partnerAccountId = [SELECT Contact.AccountId FROM User WHERE Id = :TestLeasePaymentSetup.partnerUser.Id][0].Contact.AccountId;

        firstLease.Date_Countersigned_old__c = TestLeasePaymentSetup.currentDate;
        firstLease.Date_Delivered__c = null;
        firstLease.Partner_Account__c = partnerAccountId;

        secondLease.Date_Countersigned_old__c = TestLeasePaymentSetup.currentDate;
        secondLease.Date_Delivered__c = TestLeasePaymentSetup.currentDate;
        secondLease.Partner_Account__c = partnerAccountId;

        insert new List<LeasePayment__c>{firstLease, secondLease};

        PartnerTimelineController.StageColumn firstColumn = new PartnerTimelineController.StageColumn(FIRST_LEASE_STAGE);
        firstColumn.noSLA.add(firstLease);

        PartnerTimelineController.StageColumn secondColumn = new PartnerTimelineController.StageColumn(SECOND_LEASE_STAGE);
        secondColumn.noSLA.add(secondLease);

        Map<String, PartnerTimelineController.StageColumn> stageToStageColumn = new Map<String, PartnerTimelineController.StageColumn> {
            FIRST_LEASE_STAGE => firstColumn,
            SECOND_LEASE_STAGE => secondColumn
        };

        List<String> orderedLeaseStages = new List<String>{FIRST_LEASE_STAGE, SECOND_LEASE_STAGE};

        GoogleViz actualGoogleViz;
        Test.startTest();
        
            String JSONMessage = TimelineChartData.getJSON(orderedLeaseStages, stageToStageColumn); //MAM 24.APR.2015 call getJSON
            actualGoogleViz = TimelineChartData.buildGoogleViz(orderedLeaseStages, stageToStageColumn);

        Test.stopTest();

        System.assertEquals(7, actualGoogleViz.Cols.size(), '7 columns should be created');
        System.assertEquals(TimelineChartData.STAGE, actualGoogleViz.Cols[0].label, 'The first column should be set correctly');
        System.assertEquals(TimelineChartData.SLA_NONE, actualGoogleViz.Cols[1].label, 'The second column should be set correctly');
        System.assertEquals(TimelineChartData.SELECTED, actualGoogleViz.Cols[2].label, 'The third column should be set correctly');
        System.assertEquals(TimelineChartData.SLA_RED, actualGoogleViz.Cols[3].label, 'The fourth column should be set correctly');
        System.assertEquals(TimelineChartData.SLA_YELLOW, actualGoogleViz.Cols[4].label, 'The fifth column should be set correctly');
        System.assertEquals(TimelineChartData.SLA_GREEN, actualGoogleViz.Cols[5].label, 'The sixth column should be set correctly');
        System.assertEquals(TimelineChartData.TOTAL, actualGoogleViz.Cols[6].label, 'The seventh column should be set correctly');

        System.assertEquals(2, actualGoogleViz.Rows.size(), 'two rows should be created');
        GoogleViz.Row firstRow = actualGoogleViz.Rows[0];
        GoogleViz.Row secondRow = actualGoogleViz.Rows[1];

        System.assertEquals(7, firstRow.c.size(), 'seven cells should be created for the first row');
        System.assertEquals(7, secondRow.c.size(), 'seven cells should be created for the second row');


        System.assertEquals(FIRST_LEASE_STAGE, String.valueOf(firstRow.c[0].v), 'The stage name of the first cell of the first row should be set correctly');
        System.assertEquals(1, Integer.valueOf(firstRow.c[1].v), 'The red sla value of the second cell of the first row should be set correctly');
        System.assertEquals(-1, Integer.valueOf(firstRow.c[2].v), 'The selected sla value of the third cell of the first row should be set correctly');
        System.assertEquals(0, Integer.valueOf(firstRow.c[3].v), 'The yellow column value of the fourth cell of the first row should be set correctly');
        System.assertEquals(0, Integer.valueOf(firstRow.c[4].v), 'The no sla value of the fifth cell of the first row should be set correctly');
        System.assertEquals(0, Integer.valueOf(firstRow.c[5].v), 'The green sla value of the fifth cell of the first row should be set correctly');
        System.assertEquals(1, Integer.valueOf(firstRow.c[6].v), 'The total value of the sixth cell of the first row should be set correctly');


        System.assertEquals(SECOND_LEASE_STAGE, String.valueOf(secondRow.c[0].v), 'The stage name of the first cell of the second row should be set correctly');
        System.assertEquals(1, Integer.valueOf(secondRow.c[1].v), 'The red sla value of the second cell of the second row should be set correctly');
        System.assertEquals(-1, Integer.valueOf(secondRow.c[2].v), 'The selected sla value of the third cell of the second row should be set correctly');
        System.assertEquals(0, Integer.valueOf(secondRow.c[3].v), 'The yellow column value of the fourth cell of the second row should be set correctly');
        System.assertEquals(0, Integer.valueOf(secondRow.c[4].v), 'The no sla value of the fifth cell of the second row should be set correctly');
        System.assertEquals(0, Integer.valueOf(secondRow.c[5].v), 'The green sla value of the fifth cell of the second row should be set correctly');
        System.assertEquals(1, Integer.valueOf(secondRow.c[6].v), 'The total value of the sixth cell of the second row should be set correctly');



    }
}