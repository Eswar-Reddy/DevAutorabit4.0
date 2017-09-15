public class HelixPPAFinEng {

//------------------------------------------------------------------------
// Request
//------------------------------------------------------------------------

    public static String getRequestXml(Request request) {
        // add serverside elements
        addElements(request);
        
        XmlStreamWriter w = new XmlStreamWriter();
    
        w.writeStartDocument(null, '1.0');
        w.writeStartElement(null, 'abc', null);
        w.writeAttribute(null,null,'xmlns','http://www.warren-selbert.com');
        w.writeAttribute(null,null,'xmlns:xsi','http://www.w3.org/2001/XMLSchema-instance');
        
        for (Element element : request.elements) {
            w.writeStartElement(null, element.name, null);
            w.writeCharacters(element.value != null ? element.value : '');
            w.writeEndElement();    
        }

        for (Batch batch : request.batches) {
            w.writeStartElement(null, 'batch', null);
            w.writeAttribute(null, null, 'id', batch.id);
            
            // input command
            w.writeStartElement(null, 'inputcommand', null);
            w.writeAttribute(null, null, 'name', batch.inputCommand.name);
            // input command elements
            for (Element element : batch.inputCommand.elements) {
                w.writeStartElement(null, 'input', null);
                w.writeAttribute(null, null, 'name', element.name);
                w.writeCharacters(element.value != null ? element.value : '');
                w.writeEndElement();    
            }
            // items
            for (Item item : batch.inputCommand.items) {
                w.writeStartElement(null, 'input', null);
                w.writeAttribute(null, null, 'name', item.name);
                for (String c : item.comments) {
                    w.writeComment(c);
                }
                for (Element e : item.elements) {
                    w.writeStartElement(null, 'item', null);
                    w.writeAttribute(null, null, 'name', e.name);
                    w.writeCharacters(e.value != null ? e.value : '');
                    w.writeEndElement();    // item
                }
                w.writeEndElement();  // input  
            }
            w.writeEndElement();    // inputcommand

            // output command
            w.writeStartElement(null, 'outputcommand', null);
            w.writeAttribute(null, null, 'name', batch.outputcommand.name);
            // output command options
            for (outputoption option : batch.outputcommand.options) {
                w.writeStartElement(null, 'outputoption', null);
                w.writeCharacters(option.value != null ? option.value : '');
                w.writeEndElement();     // option   
            }
            w.writeEndElement();    // outputcommand

            w.writeEndElement();    // batch
        }
        
        w.writeEndElement();    // abc
        w.writeEndDocument();
        
        String xmlOutput = w.getXmlString();
        system.debug('xmlOutput: ' + xmlOutput);
        w.close();
        return xmlOutput;
    }

    private static void addElements(Request request) {
        Loan_Callout_Settings__c lcs = Loan_Callout_Settings__c.getInstance('FinEng');
        request.elements.add(new Element('username', lcs.Username__c));
        request.elements.add(new Element('password', lcs.Password__c));
        request.elements.add(new Element('version', '2'));
        
        String sDate = system.now().format('yyyy-MM-dd');
        String sTime  = system.now().format('HH:mm:ss.SSSZ');
        
        for (Batch batch : request.batches) {
            batch.inputCommand.elements.add(new Element('Timestamp', sDate + 'T' + sTime));
            batch.inputCommand.elements.add(new Element('Business Sector', 'Commercial'));
            batch.inputCommand.elements.add(new Element('Channel', 'Indirect'));
            batch.inputCommand.elements.add(new Element('Financial Option', 'ppa'));
        }
    }
    
    public class Request {
        public List <Element> elements;
        public List <Batch> batches;
        public Request() {
            elements = new List <Element>();
            batches = new List <Batch>();
        }
    }
    public class Batch {
        public String id;
        public InputCommand inputCommand;
        public OutputCommand outputCommand;
        public Batch(String id) {
            this.id = id;
        }
    }
    public class InputCommand {
        public String name;    
        public List <Element> elements;
        public List <Item> items;
        public InputCommand(String name) {
            this.name = name;
            elements = new List <Element>();
            items = new List <Item>();
        }
    }
    public class Item {
        public String name;   
        public List <String> comments; 
        public List <Element> elements;
        public Item(String name) {
            this.name = name;
            this.comments = new List <String>();
            this.elements = new List <Element>();
        }
    }
    public class Element {
        public String name;    
        public String value;
        public String unit;    
        public List <String> options; 
        public SObject sobj;
        public String fieldName; 
        public Element() {
            options = new List <String>();
        }   
        public Element(String name, String value) {
            options = new List <String>();
            this.name = name;
            this.value = value;
        }   
        public Element(String name, String value, String unit) {
            options = new List <String>();
            this.name = name;
            this.value = value;
            this.unit = unit;
        }   
        public Element(String name, String value, String unit, List <String> options) {
            options = new List <String>();
            this.name = name;
            this.value = value;
            this.unit = unit;
            this.options = options;
        }   
    }
    public class OutputCommand {
        public String name;    
        public List <OutputOption> options;
        public OutputCommand(String name) {
            this.name = name;
            options = new List <OutputOption>();
        }
    }
    public class OutputOption {
        public String value; 
        public OutputOption(String value) {
            this.value = value;
        }   
    }

//------------------------------------------------------------------------
// Response
//------------------------------------------------------------------------

    public static Response parseResponseXml(String xml) {
        Response response = new Response();    
        
        if(String.isBlank(xml)) return response;

        Boolean isSuccess = true;
        String errorMessage;
        
        try {
        Dom.Document doc = new Dom.Document();
        doc.load(xml);
        Dom.XMLNode abcNode = doc.getRootElement();
        for(Dom.XMLNode batchoutputNode : abcNode.getChildElements()) {
            String batchoutput_id = batchoutputNode.getAttribute('id', null);
            Batchoutput batchoutput = new Batchoutput(batchoutput_id);
            response.batchoutputs.add(batchoutput);
            for(Dom.XMLNode outputNode : batchoutputNode.getChildElements()) {
                String output_name = outputNode.getAttribute('name', null);
                if (output_name == 'PPA Rate') {
                    PPARate ppaRate = new PPARate();
                    batchoutput.ppaRate = ppaRate;
                    for(Dom.XMLNode valueNode : outputNode.getChildElements()) {
                        if (valueNode.getName() == 'value') {
                            ppaRate.values.add(valueNode.getText());
                        } else {
                            isSuccess = false;
                            errorMessage = 'Unknown element in PPA Rate: ' + valueNode.getName();
                        }
                    }
                } else if (output_name == 'Net Savings') {
                    NetSavings netSavings = new NetSavings();
                    batchoutput.netSavings = netSavings;
                    for(Dom.XMLNode valueNode : outputNode.getChildElements()) {
                        if (valueNode.getName() == 'value') {
                            netSavings.values.add(valueNode.getText());
                        } else {
                            isSuccess = false;
                            errorMessage = 'Unknown element in Net Savings: ' + valueNode.getName();
                        }
                    }
                } else if (output_name == 'Utility Bill Savings') {
                    UtilityBillSavings utilityBillSavings = new UtilityBillSavings();
                    batchoutput.utilityBillSavings = utilityBillSavings;
                    for(Dom.XMLNode valueNode : outputNode.getChildElements()) {
                        if (valueNode.getName() == 'value') {
                            utilityBillSavings.values.add(valueNode.getText());
                        } else {
                            isSuccess = false;
                            errorMessage = 'Unknown element in Utility Bill Savings: ' + valueNode.getName();
                        }
                    }
                } else if (output_name == 'PPA Payment') {
                    PPAPayment ppaPayment = new PPAPayment();
                    batchoutput.ppaPayment = ppaPayment;
                    for(Dom.XMLNode valueNode : outputNode.getChildElements()) {
                        if (valueNode.getName() == 'value') {
                            ppaPayment.values.add(valueNode.getText());
                        } else {
                            isSuccess = false;
                            errorMessage = 'Unknown element in PPA Payment: ' + valueNode.getName();
                        }
                    }
                } else if (output_name == 'PPA Revenue') {
                    PPARevenue ppaRevenue = new PPARevenue();
                    batchoutput.ppaRevenue = ppaRevenue;
                    
                    for(Dom.XMLNode itemNodes : outputNode.getChildElements()) {
                        PPARevenueItem item = new PPARevenueItem();
                        batchoutput.ppaRevenue.items.add(item);
                        for(Dom.XMLNode itemNode : itemNodes.getChildElements()) {
                            if (itemNode.getName() == 'date') {
                                item.revenueDate = itemNode.getText();
                            } else if (itemNode.getName() == 'value') {
                                item.value = itemNode.getText();
                            } else {
                                isSuccess = false;
                                errorMessage = 'Unknown PPA Revenue Item: ' + itemNode.getName();
                            }
                        }
                    }
                } else if (output_name == 'System Price') {
                    SystemPrice systemPrice = new SystemPrice();
                    batchoutput.systemPrice = systemPrice;
                    List <Dom.XMLNode> valueNodeList = outputNode.getChildElements();
                    if (valueNodeList.size() == 1) {
                        systemPrice.value = valueNodeList[0].getText();
                    } else {
                        isSuccess = false;
                        errorMessage = 'There are ' + valueNodeList.size() + ' System Price values. Expected 1 value.';
                    }
                } else if (output_name == 'Net Savings NPV 3%') {
                    NetSavingsNPV3 netSavingsNPV3 = new NetSavingsNPV3();
                    batchoutput.netSavingsNPV3 = netSavingsNPV3;
                    List <Dom.XMLNode> valueNodeList = outputNode.getChildElements();
                    if (valueNodeList.size() == 1) {
                        netSavingsNPV3.value = valueNodeList[0].getText();
                    } else {
                        isSuccess = false;
                        errorMessage = 'There are ' + valueNodeList.size() + ' Net Savings NPV 3% values. Expected 1 value.';
                    }
                } else if (output_name == 'Net Savings NPV 5%') {
                    NetSavingsNPV5 netSavingsNPV5 = new NetSavingsNPV5();
                    batchoutput.netSavingsNPV5 = netSavingsNPV5;
                    List <Dom.XMLNode> valueNodeList = outputNode.getChildElements();
                    if (valueNodeList.size() == 1) {
                        netSavingsNPV5.value = valueNodeList[0].getText();
                    } else {
                        isSuccess = false;
                        errorMessage = 'There are ' + valueNodeList.size() + ' Net Savings NPV 5% values. Expected 1 value.';
                    }
                } else if (output_name == 'Net Savings NPV 8%') {
                    NetSavingsNPV8 netSavingsNPV8 = new NetSavingsNPV8();
                    batchoutput.netSavingsNPV8 = netSavingsNPV8;
                    List <Dom.XMLNode> valueNodeList = outputNode.getChildElements();
                    if (valueNodeList.size() == 1) {
                        netSavingsNPV8.value = valueNodeList[0].getText();
                    } else {
                        isSuccess = false;
                        errorMessage = 'There are ' + valueNodeList.size() + ' Net Savings NPV 8% values. Expected 1 value.';
                    }
                } else {
                    isSuccess = false;
                    errorMessage = 'Unknown output_name: ' + output_name;
                }
            }
        }
        
        } catch(Exception e) {
            isSuccess = false;
            errorMessage = 'Error while parsing response xml: ' + e.getMessage();
        }
        response.isSuccess = isSuccess;
        response.errorMessage = errorMessage;
        return response;    
    }
    
    public class Response {
        public Boolean isSuccess;
        public String errorMessage;
        public List <Batchoutput> batchoutputs;
        public Response() {
            isSuccess = false;
            batchoutputs = new List <Batchoutput>();
        }
    }

    public class Batchoutput {
        public String id;
        public PPARate ppaRate;    
        public NetSavings netSavings;    
        public UtilityBillSavings utilityBillSavings;    
        public PPAPayment ppaPayment; 
        public NetSavingsNPV3 netSavingsNPV3;   
        public NetSavingsNPV5 netSavingsNPV5;   
        public NetSavingsNPV8 netSavingsNPV8;   
        public PPARevenue ppaRevenue;
        public SystemPrice systemPrice;
        public Batchoutput(String id) {
            this.id = id;
        }
    }
    public class PPARate {
        public List <String> values; 
        public PPARate() {
            values = new List <String>();
        }   
    }
    public class NetSavings {
        public List <String> values;    
        public NetSavings() {
            values = new List <String>();
        }   
    }
    public class UtilityBillSavings {
        public List <String> values;    
        public UtilityBillSavings() {
            values = new List <String>();
        }   
    }
    public class PPAPayment {
        public List <String> values;    
        public PPAPayment() {
            values = new List <String>();
        }   
    }
    public class NetSavingsNPV3 {
        public String value;
    } 
    public class NetSavingsNPV5 {
        public String value;
    } 
    public class NetSavingsNPV8 {
        public String value;
    } 
    public class PPARevenue {
        public List <PPARevenueItem> items;
        public PPARevenue() {
            items = new List <PPARevenueItem>();
        }
    }
    public class PPARevenueItem {
        public String revenueDate;
        public String value;
    }
    public class SystemPrice {
        public String value;
    } 
       
}