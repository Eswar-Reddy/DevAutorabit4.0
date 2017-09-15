public class HelixPPADocGen {

    public static Response getResponse(Request request) {
        Response response = new Response();
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
            writeStringField(gen, 'apiKey', request.apiKey);
            writeStringField(gen, 'sector', request.sector);
            writeStringField(gen, 'templateName', request.templateName);        
            writeStringField(gen, 'fileType', request.fileType);        
            writeStringField(gen, 'watermark', request.watermark);        
            
            // TODO nameValueDictionary
            gen.writeFieldName('nameValueDictionary');
                gen.writeStartObject();
                gen.writeEndObject();
            
            // nameValuePairs
            gen.writeFieldName('nameValuePairs');
                gen.writeStartArray();
                    for (NameValuePair nameValuePair : request.nameValuePairs) {
                        gen.writeStartObject();
                            writeStringField(gen, 'name', nameValuePair.name);
                            nameValuePair.writeValue(gen);
                        gen.writeEndObject();
                    }
                gen.writeEndArray();

            // dynamicImages
            gen.writeFieldName('dynamicImages');
                gen.writeStartArray();
                    for (DynamicImage dynamicImage : request.dynamicImages) {
                        gen.writeStartObject();
                            writeStringField(gen, 'base64encodedImage', dynamicImage.base64encodedImage);
                            writeStringField(gen, 'imageUrl', dynamicImage.imageUrl);
                            writeStringField(gen, 'imageKey', dynamicImage.imageKey);
                        gen.writeEndObject();
                    }
                gen.writeEndArray();

            // dynamicTables
            gen.writeFieldName('dynamicTables');
                gen.writeStartArray();
                    for (DynamicTable dynamicTable : request.dynamicTables) {
                        gen.writeStartObject();
                            writeStringField(gen, 'tableKey', dynamicTable.tableKey);
                            // columncolumnTokenNames
                            gen.writeFieldName('columnTokenNames');
                                gen.writeStartArray();
                                    for (String tokenName : dynamicTable.dynamicTableColumn.columnTokenNames) {
                                        gen.WriteString(tokenName);
                                    }
                                gen.writeEndArray();
                            // rowValues
                            gen.writeFieldName('rowValues');
                                gen.writeStartArray();
                                    for (DynamicTableRow rowValue : dynamicTable.rowValues) {
                                        gen.writeStartArray();
                                            for (String columnValue : rowValue.columnValues) {
                                                gen.WriteString(columnValue);
                                            }
                                        gen.writeEndArray();
                                    }
                                gen.writeEndArray();
                        gen.writeEndObject();
                    }
                gen.writeEndArray();
            
            // TODO
            if ((request.ringChartList == null || request.ringChartList.size() == 0) || 
               (request.barChartList == null || request.barChartList.size() == 0)) {
                gen.writeNullField('chartPayload');
            } else {
                gen.writeFieldName('chartPayload');
                gen.writeStartObject();
                    //ringChartList
                    gen.writeFieldName('ringChartList');
                                   
                    gen.writeStartArray();
                    for (ringChart rChart: request.ringChartList) {
                        gen.writeStartObject();
                            writeStringField(gen, 'chartName', rChart.chartName);
                            writeNumberField(gen, 'comparisonSeries', rChart.comparisonSeries);
                            writeNumberField(gen, 'mainSeries', rChart.mainSeries);
                        gen.writeEndObject();
                    }
                    gen.writeEndArray();
                    
                    //barChartList
                    gen.writeFieldName('barChartList');
                    
                    gen.writeStartArray();
                    for (barChart bChart: request.barChartList) {
                        gen.writestartObject();
                            writeStringField(gen, 'chartName', bChart.chartName);
                            gen.writeFieldName('dataSet');
                            
                            gen.writeStartArray();
                            if (bChart.dataSet != null) {
                                for (barChartDataSet dataSet: bChart.dataSet){
                                    gen.writeStartObject();
                                        writeNumberField(gen, 'domain', dataSet.domain);
                                        writeStringField(gen, 'domainLabel', dataSet.domainLabel);
                                        gen.writeFieldName('seriesList');
                                        
                                        gen.writeStartArray();
                                        if (dataSet.seriesList != null) {
                                            for (barChart_DataSet_SeriesList seriesList: dataSet.seriesList){
                                                gen.writeStartObject();
                                                    writeStringField(gen, 'group', seriesList.groupLabel);
                                                    writeStringField(gen, 'key', seriesList.key);
                                                    writeNumberField(gen, 'order', seriesList.order);
                                                    writeNumberField(gen, 'value', seriesList.value);
                                                    writeStringField(gen, 'legend', seriesList.legend);
                                                gen.writeEndObject();
                                            }
                                        }
                                        gen.writeEndArray();
                                    gen.writeEndObject();
                                }
                            }
                            gen.writeEndArray();
                        gen.writeEndObject();   
                    }
                    gen.writeEndArray();
                gen.writeEndObject(); //end chartPayload 
            }
            
            gen.writeNullField('proposalPayload');
            
        gen.writeEndObject();

        response.jsonGenerator = gen;
        return response;        
    }
    
    public class Request {
        public String apiKey;    
        public String sector;    
        public String templateName; 
        public String fileType;   
        public String watermark; 
        public List <NameValuePair> nameValuePairs;
        public List <DynamicImage> dynamicImages;
        public List <DynamicTable> dynamicTables;
        public List <ringChart> ringChartList;
        public List <barChart> barChartList;
        public Request() {
            this.nameValuePairs = new List <NameValuePair>();
            this.dynamicImages = new List <DynamicImage>();
            this.dynamicTables = new List <DynamicTable>();
        }   
    }
    public class Response {
        public JSONGenerator jsonGenerator;
    }
    
    public class NameValuePair {
        public String name;    
        public Object value;    
        public String type; 
        public String format; 
        public NameValuePair(String name, Object value, String type) {
            this.name = name;
            this.value = value;
            this.type = type;
        } 
        public NameValuePair(String name, Object value, String type, String format) {
            this.name = name;
            this.value = value;
            this.type = type;
            this.format = format;
        } 
        public void writeValue(JSONGenerator gen) {
            writeValue(gen, this.value, this.type, this.format); 
        }  
    }
    
    public class ringChart{
        public String chartName;
        public Integer comparisonSeries,
                       mainSeries;
    
        public ringChart(String chartName, Integer comparisonSeries, Integer mainSeries) {
                this.chartName = chartName;
                this.comparisonSeries = comparisonSeries;
                this.mainSeries = mainSeries;
        }   
    }
    
    public class barChart{
        public String chartName;
        public List<barChartDataSet> dataSet;
        
        public barChart(String chartName, List<barChartDataSet> dataSet){
            this.chartName = chartName;
            this.dataSet = dataSet;
        }
    }
    
    public class barChartDataSet{
        public Decimal domain;
        public String domainLabel;
        public List<barChart_DataSet_SeriesList> seriesList;
        
        public barChartDataSet(Decimal domain, String domainLabel, List<barChart_DataSet_SeriesList> seriesList) {
            this.domain = domain;
            this.domainLabel = domainLabel;
            this.seriesList = seriesList;
        }
    }
    
    public class barChart_DataSet_SeriesList{
        public String groupLabel,
                      key,
                      legend;
        public Decimal order,
                       value;
                       
        public barChart_DataSet_SeriesList(String groupLabel, String key, Decimal order, Decimal value, String legend){
            this.groupLabel = groupLabel;
            this.key = key;
            this.legend = legend;
            this.order = order;
            this.value = value;
        }
    }
    
    public class DynamicImage {
        public String base64encodedImage;
        public String imageUrl;
        public String imageKey;
    }
    public class DynamicTable {
        public String tableKey;
        public DynamicTableColumn dynamicTableColumn;
        public List <DynamicTableRow> rowValues;
        public DynamicTable(List <String> columnTokenNames) {
            this.dynamicTableColumn = new DynamicTableColumn(columnTokenNames);
            this.rowValues = new List <DynamicTableRow>();
        }
    }
    public class DynamicTableColumn {
        public List <String> columnTokenNames; 
        public DynamicTableColumn(List <String> columnTokenNames) {
            this.columnTokenNames = new List <String>();
            for (String columnTokenName : columnTokenNames) {
                this.columnTokenNames.add(columnTokenName);
            }
        }   
    }
    public class DynamicTableRow {
        public List <String> columnValues;    
        public DynamicTableRow(List <String> columnValues) {
            this.columnValues = new List <String>();
            for (String columnValue : columnValues) {
                this.columnValues.add(columnValue);
            }
        }
    }
    
    public static String formatNumber(Object obj, Integer scale) {
        String retValue;

        if (obj != null) {
            String sign = String.valueOf(obj).startsWith('-') ? '-' : ''; 
            Decimal d;
            if (scale != null) {
                d = Decimal.valueOf(String.valueOf(obj)).setScale(scale).abs();
            } else {
                d = Decimal.valueOf(String.valueOf(obj)).abs();
            } 
            String value = String.valueOf(d);
            String separator = value.contains(',') ? ',' : '.';
            String integerString = value.substringBefore(separator);
            String decimalString = value.substringAfter(separator);
            String decimalStringPadded = String.IsNotBlank(decimalString) ? decimalString : '';
            if (scale != null) {
                Integer decimalStringLength = String.IsNotBlank(decimalString) ? decimalString.length() : 0;
                for (Integer i=decimalStringLength; i<scale; i++) {
                    decimalStringPadded += '0';
                }
            } 
            
            // add sign, format integer part, separator and add decimal string
            Long integerValue = String.isNotBlank(integerString) ? Long.valueOf(integerString) : 0L;
            if (scale <= 0 || scale == null && String.IsBlank(decimalString)) {
                retValue = sign + integerValue.format();
            } else {
                retValue = sign + integerValue.format() + separator + decimalStringPadded;
            }
        }
        
        return retValue;    
    }
    
    private static void writeStringField(JSONGenerator gen, String fieldName, String stringValue) {
        if (stringValue != null) {
            gen.writeStringField(fieldName, stringValue);
        } else {
            gen.writeNullField(fieldName);
        }
    }

    private static void writeNumberField(JSONGenerator gen, String fieldName, Decimal decimalValue) {
        if (decimalValue != null) {
            gen.writeNumberField(fieldName, decimalValue);
        } else {
            gen.writeNullField(fieldName);
        }
    }

    private static void writeValue(JSONGenerator gen, Object value, String type, String format) {
        if (value != null) {
            if (String.IsNotBlank(format)) {
                Integer scale;
                Boolean scaleAuto = false;
                List <String> parts = format.split(';');
                for (String part : parts) {
                    if (String.IsNotBlank(part)) {
                        List <String> options = part.split(':');
                        if (options.size() > 0 && String.IsNotBlank(options[0])) {
                            if (options[0].trim() == 'scale') {
                                if (options.size() > 1 && String.IsNotBlank(options[1])) {
                                    if (options[1].trim() == 'auto') {
                                        scaleAuto = true;
                                    } else {
                                        scale = Integer.valueOf(options[1].trim());
                                    }
                                }
                            }
                        }
                    }
                }
                if (type == 'Integer' || type == 'Decimal' || type == 'Number' ||type == 'Currency' || type == 'Percent') {
                    if (scaleAuto) {
                        gen.writeStringField('value', formatNumber(value, null));
                    } else if (scale != null) {
                        gen.writeStringField('value', formatNumber(value, scale));
                    }
                }
            } else {
                if (type == 'Integer') {
                    gen.writeNumberField('value', Integer.valueOf(value));
                } else if (type == 'Decimal' || type == 'Number') {
                    gen.writeNumberField('value', (Decimal)(value));
                } else if (type == 'Currency') {
                    gen.writeNumberField('value', (Decimal)(value));
                } else if (type == 'LongTextArea') {
                    gen.writeStringField('value', String.valueOf(value).replace('\r', ''));
                } else if (type == 'Date') {
                    gen.writeStringField('value', Datetime.valueOf(value).date().format());
                } else {
                    gen.writeStringField('value', String.valueOf(value));
                }
            }
        } else {
            gen.writeNullField('value');
        }
    }
    
}