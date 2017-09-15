@isTest
public class HelixPPAFinEngTest {
    private static final String sampleResponseXml =
    '<?xml version="1.0" encoding="utf-8"?>' +
    '<abc>' +
        '<batchoutput id="1">' +
            '<output name="PPA Rate">' +
                '<value>0.106347618279</value>' +
                '<value>0.107411094461</value>' +
            '</output>' +
            '<output name="Net Savings">' +
                '<value>124044.790518</value>' +
                '<value>133475.662952</value>' +
            '</output>' +
            '<output name="Utility Bill Savings">' +
                '<value>13874.4507284</value>' +
                '<value>14019.6815414</value>' +
            '</output>' +
            '<output name="PPA Payment">' +
                '<value>297882.487798</value>' +
                '<value>300852.003848</value>' +
            '</output>' +
            '<output name="Net Savings NPV 3%">' +
                '<value>-4606851.23438</value>' +
            '</output>' +
            '<output name="Net Savings NPV 5%">' +
                '<value>-3835193.65493</value>' +
            '</output>' +
            '<output name="Net Savings NPV 8%">' +
                '<value>-2995419.76527</value>' +
            '</output>' +
            '<output name="PPA Revenue">' +
                '<item>' +
                    '<date>2017‐12‐31T00:00:00</date>' +
                    '<value>57.4958826938</value>' +
                '</item>' +
                '<item>' +
                    '<date>2018‐03‐31T00:00:00</date>' +
                    '<value>61.4337223034</value>' +
                '</item>' +
            '</output>' +
            '<output name="System Price">' +
                '<value>3792.10849941</value>' +
            '</output>' +
        '</batchoutput>' +
    '</abc>';

    private static testMethod void test_parseResponseXml() {
        HelixPPAFinEng.Response response = HelixPPAFinEng.parseResponseXml(sampleResponseXml);
        system.assertEquals(null, response.errorMessage);    
        system.assertEquals(true, response.isSuccess);    

        system.assertEquals(1, response.batchoutputs.size());    
        system.assertEquals('1', response.batchoutputs[0].id);    

        system.assertEquals(2, response.batchoutputs[0].ppaRate.values.size());    
        system.assertEquals('0.106347618279', response.batchoutputs[0].ppaRate.values[0]);    
        system.assertEquals('0.107411094461', response.batchoutputs[0].ppaRate.values[1]);    

        system.assertEquals(2, response.batchoutputs[0].netSavings.values.size());    
        system.assertEquals('124044.790518', response.batchoutputs[0].netSavings.values[0]);    
        system.assertEquals('133475.662952', response.batchoutputs[0].netSavings.values[1]);    

        system.assertEquals(2, response.batchoutputs[0].utilityBillSavings.values.size());    
        system.assertEquals('13874.4507284', response.batchoutputs[0].utilityBillSavings.values[0]);    
        system.assertEquals('14019.6815414', response.batchoutputs[0].utilityBillSavings.values[1]);    

        system.assertEquals(2, response.batchoutputs[0].ppaPayment.values.size());    
        system.assertEquals('297882.487798', response.batchoutputs[0].ppaPayment.values[0]);    
        system.assertEquals('300852.003848', response.batchoutputs[0].ppaPayment.values[1]);    

        system.assertEquals(2, response.batchoutputs[0].ppaRevenue.items.size());    
        system.assertEquals('2017‐12‐31T00:00:00', response.batchoutputs[0].ppaRevenue.items[0].revenueDate);    
        system.assertEquals('57.4958826938', response.batchoutputs[0].ppaRevenue.items[0].value);    
        system.assertEquals('2018‐03‐31T00:00:00', response.batchoutputs[0].ppaRevenue.items[1].revenueDate);    
        system.assertEquals('61.4337223034', response.batchoutputs[0].ppaRevenue.items[1].value);    

        system.assertEquals('3792.10849941', response.batchoutputs[0].systemPrice.value);    
        system.assertEquals('-4606851.23438', response.batchoutputs[0].netSavingsNPV3.value);    
        system.assertEquals('-3835193.65493', response.batchoutputs[0].netSavingsNPV5.value);    
        system.assertEquals('-2995419.76527', response.batchoutputs[0].netSavingsNPV8.value);    
    }

    private static testMethod void test_getRequestXml() {
        Loan_Callout_Settings__c s_1 = new Loan_Callout_Settings__c(Name = 'FinEng', Username__c = 'xxxxx', Password__c = 'yyyyy');
        insert new List <Loan_Callout_Settings__c>{s_1};
        
        HelixPPAFinEng.Request request = new HelixPPAFinEng.Request();
            
        request.elements.add(new HelixPPAFinEng.Element('username', 'admin'));
        request.elements.add(new HelixPPAFinEng.Element('password', '0123456789'));
        request.elements.add(new HelixPPAFinEng.Element('version', '2'));
        
        // input command
        HelixPPAFinEng.InputCommand inputCommand = new HelixPPAFinEng.InputCommand('APIInput');
        
        // inputs
        inputCommand.elements.add(new HelixPPAFinEng.Element('Quote ID', '123456'));
        inputCommand.elements.add(new HelixPPAFinEng.Element('Timestamp', '2015‐09‐27T00:00:00.000‐0500'));
        
        // items
        HelixPPAFinEng.Item item;
        
        item = new HelixPPAFinEng.Item('Item');
        item.elements.add(new HelixPPAFinEng.Element('Panel Name', 'module name 1'));
        item.elements.add(new HelixPPAFinEng.Element('Panel ID', 'module ID 1'));
        inputCommand.items.add(item);
        
        item = new HelixPPAFinEng.Item('Item');
        item.elements.add(new HelixPPAFinEng.Element('Panel Name', 'module name 2'));
        item.elements.add(new HelixPPAFinEng.Element('Panel ID', 'module ID 2'));
        inputCommand.items.add(item);
        
        // output command
        HelixPPAFinEng.OutputCommand outputCommand = new HelixPPAFinEng.OutputCommand('APIOutput');
        outputCommand.options.add(new HelixPPAFinEng.OutputOption(''));

        // batches
        HelixPPAFinEng.Batch batch;
        
        batch = new HelixPPAFinEng.Batch('1');
        batch.inputCommand = inputCommand;
        batch.outputCommand = outputCommand;
        request.batches.add(batch);

        String xmlOutput = HelixPPAFinEng.getRequestXml(request);
        
    }
    
}