/**
 * Created by cdevarapalli on 4/6/17.
 */

@IsTest
private class Batch_RetrofitQuotesforEDDiE_TEST {

    @testSetup
    static void dataSetup() {


        insert new List<Loan_Callout_Settings__c>{
                new Loan_Callout_Settings__c(Name ='ServiceObjects',
                                             BackupZipCodeUrl__c = 'http://ws.serviceobjects.com/ft/FastTax.asmx/GetTaxInfoByZip_V2?PostalCode=',
                                             ZipCodeUrl__c = 'http://ws.serviceobjects.com/ft/FastTax.asmx/GetTaxInfoByZip_V2?PostalCode=',
                                             Client_ID__c = 'WS19-GFX1-JVR3',
                                             BackupURL__c = 'http://ws.serviceobjects.com/gcr/GeoCoder.asmx/GetBestMatch_V3?Address=',
                                             NameSpace__c = 'http://www.serviceobjects.com/')
        };

        List<Quote> quotesList = new List<Quote>();
        List<Roof_Details__c> roofDetailsList = new List<Roof_Details__c>();

        Inverter_Configuration__c ic = TestFactory_Configurations.createInverterConfiguration();
        insert ic;

        Module_Configuration__c mc = TestFactory_Configurations.createModuleConfiguration();
        insert mc;

        Quote qt1 = TestFactory_StandardObjects.createProposalQuote(null);
        qt1.Quote_Wizard__c = null;
        qt1.is_Locked__c = true;
        qt1.Name = 'Test';
        qt1.Sector__c = 'Residential';
        qt1.QuoteType__c = 'Lease';
        qt1.installDate__c = 'December 2017';
        qt1.Description__c = 'dec Test';
        qt1.Optional_Incentives__c = 'Use All';


        qt1.System_Cost__c =30000;
        qt1.System_Price__c = 22000.00;

        //Roof1
        qt1.Modules_Per_String_Roof1__c = 8;
        qt1.Total_Parallel_Strings_Roof1__c = 2;
        qt1.Inverter_Quantity__c = 2;
        qt1.Inverter_Model__c = ic.Name;
        qt1.Inverter_Manufacturer_Roof1__c = ic.Inverter_Manufacturer__c;

        //Roof2
        qt1.Modules_Per_String_Roof2__c = 0;
        qt1.Total_Parallel_Strings_Roof2__c = 0;
        qt1.Inverter_Model_2__c = ic.Name;
        qt1.Inverter_Manufacturer_Roof2__c = ic.Inverter_Manufacturer__c;
        qt1.Inverter_Quantity_2__c = 0;

        //Roof3
        qt1.Modules_Per_String_Roof3__c = 0;
        qt1.Total_Parallel_Strings_Roof3__c = 0;
        qt1.Inverter_Model_3__c = ic.Name;
        qt1.Inverter_Manufacturer_Roof3__c = ic.Inverter_Manufacturer__c;
        qt1.Inverter_Quantity_3__c = 0;

        //Roof4
        qt1.Modules_Per_String_Roof4__c = 0;
        qt1.Total_Parallel_Strings_Roof4__c = 0;
        qt1.Inverter_Model_4__c = ic.Name;
        qt1.Inverter_Manufacturer_Roof4__c = ic.Inverter_Manufacturer__c;
        qt1.Inverter_Quantity_4__c = 0;

        qt1.Monitoring_System__c = 'PVS5 production Monitoring';
        qt1.Mounting_Description__c = 'InvisiMount';
        qt1.System_Model__c = mc.Name;
        qt1.Buydown_Override__c = true;
        qt1.PBI_Override__c = true;
        qt1.Design_Factor__c = 'Specified';
        quotesList.add(qt1);


        //Quote 2
        Quote qt2 = TestFactory_StandardObjects.createProposalQuote(null);
        qt2.Quote_Wizard__c = null;
        qt2.is_Locked__c = true;
        qt2.Name = 'Test';
        qt2.Sector__c = 'Residential';
        qt2.QuoteType__c = 'Lease';
        qt2.installDate__c = 'December 2017';
        qt2.Description__c = 'dec Test';
        qt2.Optional_Incentives__c = 'Use All';
        quotesList.add(qt2);

        insert quotesList;

        Roof_Details__c qt1rDet1 = TestFactory_Sales_Residential.createRoofDetail(qt1.Id);
        qt1rDet1.Name = 'Roof 1';
        roofDetailsList.add(qt1rDet1);

        Roof_Details__c qt1rDet2 = TestFactory_Sales_Residential.createRoofDetail(qt1.Id);
        qt1rDet2.Name = 'Roof 2';
        roofDetailsList.add(qt1rDet2);

        Roof_Details__c qt1rDet3 = TestFactory_Sales_Residential.createRoofDetail(qt1.Id);
        qt1rDet3.Name = 'Roof 3';
        roofDetailsList.add(qt1rDet3);

        Roof_Details__c qt1rDet4 = TestFactory_Sales_Residential.createRoofDetail(qt1.Id);
        qt1rDet4.Name = 'Roof 4';
        roofDetailsList.add(qt1rDet4);

        Roof_Details__c qt2rDet1 = TestFactory_Sales_Residential.createRoofDetail(qt2.Id);
        qt2rDet1.Name = 'Roof';
        roofDetailsList.add(qt2rDet1);

        Roof_Details__c qt2rDet2 = TestFactory_Sales_Residential.createRoofDetail(qt2.Id);
        qt2rDet2.Name = 'Roof';
        roofDetailsList.add(qt2rDet2);

        Roof_Details__c qt2rDet3 = TestFactory_Sales_Residential.createRoofDetail(qt2.Id);
        qt2rDet3.Name = 'Roof';
        roofDetailsList.add(qt2rDet3);

        Roof_Details__c qt2rDet4 = TestFactory_Sales_Residential.createRoofDetail(qt2.Id);
        qt2rDet4.Name = 'Roof';
        roofDetailsList.add(qt2rDet4);

        insert roofDetailsList;

        List<Quote> quoteList = new List<Quote>([SELECT Quote_Wizard__c, Is_Locked__c from Quote]);
        quoteList[0].Is_Locked__c = true;
        quoteList[1].Is_Locked__c = true;
        update quoteList;

    }

    static testMethod void test_Batch_RetrofitQuotesforEDDiE() {
        List<Quote> insertedQuotes = new List<Quote>([SELECT Quote_Wizard__c, Is_Locked__c from Quote]);
        System.debug('insertedQuotes ----->'+insertedQuotes);
        test.startTest();
        Batch_RetrofitQuotesforEDDiE brq = new Batch_RetrofitQuotesforEDDiE('Select Id, Name, (Select Id,Name From Equinox_Designs__r), AccountId, Inverter_Manufacturer_Roof1__c, Inverter_Manufacturer_Roof2__c, Inverter_Manufacturer_Roof3__c, Inverter_Manufacturer_Roof4__c, Modules_Per_String_Roof1__c, Modules_Per_String_Roof2__c, Modules_Per_String_Roof3__c, Modules_Per_String_Roof4__c, Total_Parallel_Strings_Roof1__c, Total_Parallel_Strings_Roof2__c, Total_Parallel_Strings_Roof3__c, Total_Parallel_Strings_Roof4__c, Inverter_Model__c, Inverter_Model_2__c, Inverter_Model_3__c, Inverter_Model_4__c, Inverter_Quantity__c, Inverter_Quantity_2__c, Inverter_Quantity_3__c, Inverter_Quantity_4__c, Quote_Wizard__c,CreatedBy.Name,CreatedDate FROM Quote where Quote_Wizard__c = null  order by createddate asc', false, false, false, false);
        Id brId = Database.executeBatch(brq);
        test.stopTest();
    }

    static testMethod void test_Batch_UpdateRoofDetNametoRoofIdentifier() {
        List<Quote> insertedQuotes = new List<Quote>([SELECT Quote_Wizard__c, Is_Locked__c from Quote]);
        System.debug('insertedQuotes ----->'+insertedQuotes);
        test.startTest();
        Batch_UpdateRoofDetNametoRoofIdentifier burdn = new Batch_UpdateRoofDetNametoRoofIdentifier('SELECT Quote_Id__c, Name, Description__c,CreatedDate from Roof_Details__c where  Quote_Id__c!=null and Country__c != \'France\' and  Name != \'Roof 1\' and Name != \'Roof 2\' and Name != \'Roof 3\' and Name != \'Roof 4\' ORDER BY Quote_Id__c,CreatedDate ASC',true);
        Id burdnId = Database.executeBatch(burdn);
        test.stopTest();
    }

    static testMethod void test_Batch_Cleanup_ElectricUsageInput(){
        insert new Electric_Rate_Usage_Input__c(Usage__c = 'AB', Annual_Usage__c = 1000.00, Annual_Bill__c = 100.00);
        test.startTest();
        Batch_Cleanup_ElectricUsageInput bceui = new Batch_Cleanup_ElectricUsageInput('select Id from Electric_Rate_Usage_Input__c',true);
        Id bceuiId = Database.executeBatch(bceui);
        test.stopTest();
    }
}