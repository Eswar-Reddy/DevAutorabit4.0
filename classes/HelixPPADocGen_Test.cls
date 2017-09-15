@isTest
public class HelixPPADocGen_Test {

    @isTest
    private static void test_getResponse() {
        HelixPPADocGen.Request request = new HelixPPADocGen.Request();
        
        // name value pairs
        request.nameValuePairs.add(new HelixPPADocGen.NameValuePair('annualPPAEscalator', 1.5, 'Percent', 'scale:2'));
        request.nameValuePairs.add(new HelixPPADocGen.NameValuePair('annualProduction', 2000.50, 'Number', 'scale:auto'));
        request.nameValuePairs.add(new HelixPPADocGen.NameValuePair('integerToken', 100, 'Integer'));
        request.nameValuePairs.add(new HelixPPADocGen.NameValuePair('decimalToken', 100.50, 'Decimal'));
        request.nameValuePairs.add(new HelixPPADocGen.NameValuePair('currencyToken', 19.99, 'Currency'));
        request.nameValuePairs.add(new HelixPPADocGen.NameValuePair('longTextAreaToken', 'test\rtest', 'LongTextArea'));
        request.nameValuePairs.add(new HelixPPADocGen.NameValuePair('dateToken', system.now(), 'Date'));
        request.nameValuePairs.add(new HelixPPADocGen.NameValuePair('stringToken', 'test', 'String'));
        request.nameValuePairs.add(new HelixPPADocGen.NameValuePair('nullFieldToken', null, 'String'));
        
        // dynamic image
        HelixPPADocGen.DynamicImage di_1 = new HelixPPADocGen.DynamicImage();
        di_1.base64encodedImage = 'TWFuIGlzIGRpc3RpaXNByZWFzb24sIGJ1dCBieSB0aGl...';
        di_1.imageUrl = '';
        di_1.imageKey = 'picture1';
        request.dynamicImages.add(di_1);
        
        // dynamic table
        HelixPPADocGen.DynamicTable dt_1 = new HelixPPADocGen.DynamicTable(new List <String>{'quantity', 'partNo', 'description', 'cost'});
        dt_1.tableKey = 'miketable';
        HelixPPADocGen.DynamicTableRow dtr_1 = new HelixPPADocGen.DynamicTableRow(new List <String>{'cellValue1', 'cellValue2', 'cellValue3', 'cellValue4'});
        dt_1.rowValues.add(dtr_1);
        request.dynamicTables.add(dt_1);
        
        // ring chart
        HelixPPADocGen.RingChart rc_1 = new HelixPPADocGen.RingChart('rc_1', 1, 2);
        request.ringChartList = new List <HelixPPADocGen.RingChart>{rc_1};
        
        // bar chart
        HelixPPADocGen.barChart_DataSet_SeriesList bcdssl_1 = new HelixPPADocGen.barChart_DataSet_SeriesList('', 'Utility Bill Savings', 1, 80000.0, '');
        List <HelixPPADocGen.barChart_DataSet_SeriesList> seriesList = new List <HelixPPADocGen.barChart_DataSet_SeriesList>{bcdssl_1};
        HelixPPADocGen.BarChartDataSet bcds_1 = new HelixPPADocGen.BarChartDataSet(1, '1', seriesList);
        List <HelixPPADocGen.BarChartDataSet> dataSet = new List <HelixPPADocGen.BarChartDataSet>{bcds_1};
        HelixPPADocGen.BarChart bc_1 = new HelixPPADocGen.BarChart('bc_1', dataSet);
        request.barChartList = new List <HelixPPADocGen.BarChart>{bc_1};
        
        HelixPPADocGen.Response response = HelixPPADocGen.getResponse(request);
    } 

}