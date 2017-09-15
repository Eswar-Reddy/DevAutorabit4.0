/**
 * Created by devarapalli on 8/22/17.
 */

@IsTest
private class SetOrderForMonth_Test {

    static testMethod void test_SetOrderForMonth() {
        List<Electric_Bill_Detail__c> ebdInsertList = new List<Electric_Bill_Detail__c>();

        Test.startTest();
        Electric_Bill_Summary__c objElecBill = new Electric_Bill_Summary__c();
        //objElecBill.Quote__c = quoteID;
        Insert objElecBill;

        Electric_Bill_Detail__c  objEBD01 = new Electric_Bill_Detail__c();
        objEBD01.Current_Quantity_kWh__c = 101;
        objEBD01.New_Quantity_kWh__c = 101;
        objEBD01.month__c =  'January';
        objEBD01.orderofmonth__c = 1;
        //objEBD01.Quote__c =quoteID;
        objEBD01.Electric_Bill_Summary__c = objElecBill.id;
        objEBD01.Tier__c = 'Monthly Tier 1';
        ebdInsertList.add(objEBD01);

        Electric_Bill_Detail__c  objEBD02 = new Electric_Bill_Detail__c();
        objEBD02.Current_Quantity_kWh__c = 102;
        objEBD02.New_Quantity_kWh__c = 102;
        objEBD02.month__c =  'February';
        objEBD02.orderofmonth__c = 2;
        //objEBD02.Quote__c =quoteID;
        objEBD02.Electric_Bill_Summary__c = objElecBill.id;
        objEBD02.Tier__c = 'Monthly Tier 1';
        ebdInsertList.add(objEBD02);

        Electric_Bill_Detail__c  objEBD03 = new Electric_Bill_Detail__c();
        objEBD03.Current_Quantity_kWh__c = 103;
        objEBD03.New_Quantity_kWh__c = 103;
        objEBD03.month__c =  'March';
        objEBD03.orderofmonth__c = 3;
        //objEBD03.Quote__c =quoteID;
        objEBD03.Electric_Bill_Summary__c = objElecBill.id;
        objEBD03.Tier__c = 'Monthly Tier 3';
        ebdInsertList.add(objEBD03);

        Electric_Bill_Detail__c  objEBD04 = new Electric_Bill_Detail__c();
        objEBD04.Current_Quantity_kWh__c = 104;
        objEBD04.New_Quantity_kWh__c = 104;
        objEBD04.month__c =  'April';
        objEBD04.orderofmonth__c = 4;
        //objEBD04.Quote__c =quoteID;
        objEBD04.Electric_Bill_Summary__c = objElecBill.id;
        objEBD04.Tier__c = 'Monthly Tier 4';
        ebdInsertList.add(objEBD04);

        Electric_Bill_Detail__c  objEBD05 = new Electric_Bill_Detail__c();
        objEBD05.Current_Quantity_kWh__c = 105;
        objEBD05.New_Quantity_kWh__c = 105;
        objEBD05.month__c =  'May';
        objEBD05.orderofmonth__c = 5;
        //objEBD05.Quote__c =quoteID;
        objEBD05.Electric_Bill_Summary__c = objElecBill.id;
        objEBD05.Tier__c = 'Monthly Tier 1';
        ebdInsertList.add(objEBD05);

        Electric_Bill_Detail__c  objEBD06 = new Electric_Bill_Detail__c();
        objEBD06.Current_Quantity_kWh__c = 106;
        objEBD06.New_Quantity_kWh__c = 106;
        objEBD06.month__c =  'June';
        objEBD06.orderofmonth__c = 6;
        //objEBD06.Quote__c =quoteID;
        objEBD06.Electric_Bill_Summary__c = objElecBill.id;
        objEBD06.Tier__c = 'Monthly Tier 1';
        ebdInsertList.add(objEBD06);

        Electric_Bill_Detail__c  objEBD07 = new Electric_Bill_Detail__c();
        objEBD07.Current_Quantity_kWh__c = 107;
        objEBD07.New_Quantity_kWh__c = 107;
        objEBD07.month__c =  'July';
        objEBD07.orderofmonth__c = 7;
        //objEBD07.Quote__c =quoteID;
        objEBD07.Electric_Bill_Summary__c = objElecBill.id;
        objEBD07.Tier__c = 'Monthly Tier 1';
        ebdInsertList.add(objEBD07);

        Electric_Bill_Detail__c  objEBD08 = new Electric_Bill_Detail__c();
        objEBD08.Current_Quantity_kWh__c = 108;
        objEBD08.New_Quantity_kWh__c = 108;
        objEBD08.month__c =  'August';
        objEBD08.orderofmonth__c = 8;
        //objEBD08.Quote__c =quoteID;
        objEBD08.Electric_Bill_Summary__c = objElecBill.id;
        objEBD08.Tier__c = 'Monthly Tier 1';
        ebdInsertList.add(objEBD08);

        Electric_Bill_Detail__c  objEBD09 = new Electric_Bill_Detail__c();
        objEBD09.Current_Quantity_kWh__c = 109;
        objEBD09.New_Quantity_kWh__c = 109;
        objEBD09.month__c =  'September';
        objEBD09.orderofmonth__c = 9;
        //objEBD09.Quote__c =quoteID;
        objEBD09.Electric_Bill_Summary__c = objElecBill.id;
        objEBD09.Tier__c = 'Monthly Tier 1';
        ebdInsertList.add(objEBD09);

        Electric_Bill_Detail__c  objEBD10 = new Electric_Bill_Detail__c();
        objEBD10.Current_Quantity_kWh__c = 110;
        objEBD10.New_Quantity_kWh__c = 110;
        objEBD10.month__c =  'October';
        objEBD10.orderofmonth__c = 10;
        //objEBD10.Quote__c =quoteID;
        objEBD10.Electric_Bill_Summary__c = objElecBill.id;
        objEBD10.Tier__c = 'Monthly Tier 1';
        ebdInsertList.add(objEBD10);

        Electric_Bill_Detail__c  objEBD11 = new Electric_Bill_Detail__c();
        objEBD11.Current_Quantity_kWh__c = 111;
        objEBD11.New_Quantity_kWh__c = 111;
        objEBD11.month__c =  'November';
        objEBD11.orderofmonth__c = 11;
        //objEBD11.Quote__c =quoteID;
        objEBD11.Electric_Bill_Summary__c = objElecBill.id;
        objEBD11.Tier__c = 'Monthly Tier 1';
        ebdInsertList.add(objEBD11);

        Electric_Bill_Detail__c  objEBD12 = new Electric_Bill_Detail__c();
        objEBD12.Current_Quantity_kWh__c = 112;
        objEBD12.New_Quantity_kWh__c = 112;
        objEBD12.month__c =  'December';
        objEBD12.orderofmonth__c = 12;
        //objEBD12.Quote__c =quoteID;
        objEBD12.Electric_Bill_Summary__c = objElecBill.id;
        objEBD12.Tier__c = 'Monthly Tier 1';
        ebdInsertList.add(objEBD12);

        insert ebdInsertList;
        Test.stopTest();
    }
}