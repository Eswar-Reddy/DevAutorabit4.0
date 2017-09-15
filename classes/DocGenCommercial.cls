public with sharing class DocGenCommercial {

    @TestVisible public Map<String,Map<String,String>> sObjectFieldMap {get; set;}
    @TestVisible public Map<String,DocGenCommercial__c> jsonFieldAPIMap {get; set;}
    @TestVisible public List<DocGenCommercial__c> settings {get; set;}
    @TestVisible public Opportunity opptyRecordToSend {get;set;}
    @TestVisible public List<OpportunityLineItem> opptyLineItemRecordToSend {get;set;}
	@TestVisible public Id opptyId{get;set;}
	public String request;
	@TestVisible public Decimal designProdEPCScore;
	@TestVisible public Decimal businessCaseScore;
	@TestVisible public Id attachmentId ; 
    public DocGenCommercial(){
        loadSettings();
        request = null;    
    }

    public void loadSettings(){ 
        sObjectFieldMap = new Map<String,Map<String,String>>();
        jsonFieldAPIMap = new Map<String,DocGenCommercial__c>();


        //Instance method of List Custom Settings to get all in the list
        settings = DocGenCommercial__c.getAll().values();
        for(DocGenCommercial__c ss : settings){
			if(ss.Type__c == 'PR0'){
	            // sObjectFieldMap
	            if(!sObjectFieldMap.containsKey(ss.sObject_Name__c)) 
	                sObjectFieldMap.put(ss.sObject_Name__c,new Map<String,String>());
	            //Populates Map with JsonString and actual apiname. then, we will insert this map to sObjectFieldMap
	            Map<String,String> jsonFieldMap = sObjectFieldMap.get(ss.sObject_Name__c);
	            if(ss.Name != null)
	                jsonFieldMap.put(ss.Name,ss.Field_API_Name__c); 
	            else
	                jsonFieldMap.put(ss.Field_API_Name__c,ss.Field_API_Name__c);
	            sObjectFieldMap.put(ss.sObject_Name__c,jsonFieldMap);
	            // jsonFieldAPIMap
	            jsonFieldAPIMap.put(ss.Name,ss);
	        }
        }
    }  
    //sendDataToDocGen('0068A000003TtdR','No','Commercial','PR0');
	 public Id sendDataToDocGen(Id opptyId,String waterMark,String sector,string documentType){
        try{
            this.opptyId = opptyId;
            populateRecords();
            request = buildJSON(waterMark,sector,documentType);
            attachmentId = handleRequest(request,opptyRecordToSend,sector,documentType);
        }
        catch(Exception e){        	
            system.debug('Error is '+e.getMessage()+ ' and stack trace is '+e.getStackTraceString());
        }
       return attachmentId;
    }

    public void populateRecords(){
	    opptyRecordToSend = Database.query(buildQuery('SELECT Id,','Opportunity',' FROM Opportunity WHERE Id = :opptyId'));
    	opptyLineItemRecordToSend = Database.query(buildQuery('SELECT Id,','OpportunityLineItem',' FROM OpportunityLineItem WHERE OpportunityId = :opptyId'));
    	
    	List<AggregateResult> somme = [select SUM(Category_Score_Formulea__c)score,SUM(Max_Score__c)maxscore,Main_Category__c 
    	 								from Opportunity_Score__c 
    	 								where Opportunity__c=:opptyId 
    	 								group by Main_Category__c,CreatedBy.Name
    	 								order by Main_Category__c DESC];
	  	for(AggregateResult ar : somme){		  
  		  	if((Object)ar.get('Main_Category__c') == 'Design/Product/EPC'){
		    	designProdEPCScore = (Decimal) ar.get('score') ;		  
		  	}  	
	 		if((Object)ar.get('Main_Category__c') == 'Business Case'){
		    	businessCaseScore = (Decimal) ar.get('score') ;		  
		  	}
		}
		System.debug('opptyLineItemRecordToSend==>'+opptyLineItemRecordToSend);
	 }

    public String buildJSON(String waterMark,String sector,string documentType){
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('apiKey',String.valueOf(DocGen_Callout_Settings__c.getAll().get('DocGen').apiKey__c));        
        gen.writeStringField('documentType',documentType);
        gen.writeStringField('sector',sector);
        gen.writeStringField('templateName','');
        gen.writeStringField('watermark',waterMark);
        
        gen.writeFieldName('nameValuePairs');
        gen.writeStartArray();
        
	        gen.writeStartObject();
	            gen.writeStringField('name', 'sector');
	            gen.writeStringField('value', sector);
	        gen.writeEndObject();
	        
	        gen.writeStartObject();
	            gen.writeStringField('name', 'documentType');
	            gen.writeStringField('value', documentType);
	        gen.writeEndObject();        
	       
			 gen.writeStartObject();
	            gen.writeStringField('name', 'Design/Product/EPC');
	           if(designProdEPCScore != null)
	            gen.writeNumberField('value', designProdEPCScore);
	           else
	            gen.writeStringField('value', ''); 
	        gen.writeEndObject();  
	        
	         gen.writeStartObject();
	            gen.writeStringField('name', 'BusinessCase');
	          if(businessCaseScore != null) 
	            gen.writeNumberField('value', businessCaseScore);
	          else
	           gen.writeStringField('value', '');
	        gen.writeEndObject();  			
	       
	        // code used to send Oppty & OpptyLineItems record and settings to build the JSON string
	        System.debug('*8settings==>'+settings);
	        for(DocGenCommercial__c nhc : settings){
	            if(nhc.sObject_Name__c != null && nhc.sObject_Name__c == 'Opportunity'){
	                gen.writeStartObject();
	                if(opptyRecordToSend.get(nhc.Field_API_Name__c) != null){ 	                	
	                	gen.writeStringField('name', nhc.Name);
	                 	  settingValues(nhc,String.valueOf(opptyRecordToSend.get(nhc.Field_API_Name__c)),gen);	                
	                }else{
	                	System.debug('value=API=else=>'+nhc.Field_API_Name__c);
	                	gen.writeStringField('name', nhc.Name);
	                    gen.writeStringField('value',''); 
	                }
	                gen.writeEndObject();
	            }
	            else if(nhc.sObject_Name__c == null){
	                gen.writeStartObject();
	                gen.writeStringField('name',nhc.Name);
	                gen.writeStringField('value',nhc.Field_API_Name__c);
	                gen.writeEndObject();
	            }
	        }       
        gen.writeEndArray(); // end Array of Oppty json
        
        //List of Products on opportunity 
      //  if(!opptyLineItemRecordToSend.isEmpty()){
            gen.writeFieldName('dynamicTables');
   			gen.writeStartArray();
               
	            gen.writeStartObject();
			        gen.writeStringField('tableKey','ProductDynamicTemplate');		        
			        gen.writeFieldName('columnTokenNames');
			        gen.writeStartArray();
			        	gen.writeString('productType');   
			        	gen.writeString('product');   
			        	gen.writeString('quantity');   
			        	gen.writeString('cost$/w');
			        gen.writeEndArray();
	         gen.writeFieldName('rowValues');
	   		 gen.writeStartArray();
   		        for(OpportunityLineItem prdLI : opptyLineItemRecordToSend){
               	System.debug('LI=>'+prdLI.get(sobjectFieldMap.get('OpportunityLineItem').get('productType')));
	             gen.writeStartArray();
 	    	       if(prdLI.get(sobjectFieldMap.get('OpportunityLineItem').get('productType')) != null){
                       gen.writeString(String.valueOf(prdLI.get(sobjectFieldMap.get('OpportunityLineItem').get('productType'))));
                   } else if(prdLI.get(sobjectFieldMap.get('OpportunityLineItem').get('productType')) == null){
                       gen.writeString('');
                   }
				   if(prdLI.get(sobjectFieldMap.get('OpportunityLineItem').get('product')) != null){
                       gen.writeString(String.valueOf(prdLI.get(sobjectFieldMap.get('OpportunityLineItem').get('product'))));
                       
                   }else if(prdLI.get(sobjectFieldMap.get('OpportunityLineItem').get('product')) == null){
                       gen.writeString('');
                   }
					if(prdLI.get(sobjectFieldMap.get('OpportunityLineItem').get('quantity')) != null ){
                       gen.writeString(String.valueOf(prdLI.get(sobjectFieldMap.get('OpportunityLineItem').get('quantity'))));
                       
                   }else if(prdLI.get(sobjectFieldMap.get('OpportunityLineItem').get('quantity')) == null ){
                       gen.writeString('');
                   }
                   if(prdLI.get(sobjectFieldMap.get('OpportunityLineItem').get('cost$/w')) != null ){
                      gen.WriteNumber(Decimal.valueOf(String.valueOf(prdLI.get(sobjectFieldMap.get('OpportunityLineItem').get('cost$/w')))).setScale(2));
              
                   }else if(prdLI.get(sobjectFieldMap.get('OpportunityLineItem').get('cost$/w')) == null ){
                       gen.writeString('');
                   }else
                       gen.writeString('');   
                gen.writeEndArray(); //end of rowValues
		     }
	   	    		 
		    gen.writeEndArray(); //end of rowValues
	   		  
       	gen.writeEndObject(); 
       	gen.writeEndArray();    
      // }        
      gen.writeEndObject(); 
	  gen.close();
      System.debug('GEN: ' + gen.getAsString());   
      return gen.getAsString();
    }

    public void settingValues(DocGenCommercial__c docGen,String value,JSONGenerator gen){
        if(docGen.Field_Type__c == null || docGen.Field_Type__c == 'String'){
            gen.writeStringField('value', value);
        }
        else if(docGen.Field_Type__c == 'Integer'){
            gen.writeNumberField('value', Integer.valueOf(value));
        }
        else if(docGen.Field_Type__c == 'Decimal'){
            gen.writeNumberField('value', Decimal.valueOf(value));
        }
        else if(docGen.Field_Type__c == 'Currency'){
            gen.writeStringField('value', formatCurrency(Double.valueOf(value).format()));
        } 
        else if(docGen.Field_Type__c == 'LongTextArea'){
            gen.writeStringField('value', value.replace('\r', ''));
        }
        else if(docGen.Field_Type__c == 'Date'){        	
            gen.writeStringField('value', Datetime.valueOf(value).date().format());
        }
        else{
            gen.writeStringField('value', value);
        }
    }

    public static String formatCurrency(String s) {
        s = + s;
        if (!s.contains('.')) {
            s = s + '.00';
        } else {
          Integer dPos = s.indexOf('.');
          if (s.length() - dPos < 3) { s = s + '0'; }
        }
        return s;
    }
    public String buildQuery(String selectStatement,String objectName,String finalString){
        Set<String> fields = new Set<String>();
        Map<String,String> jsonNameFieldAPIName = new Map<String,String>();
        jsonNameFieldAPIName = sObjectFieldMap.get(objectName);
        system.debug('field map is '+jsonNameFieldAPIName);
        if(jsonNameFieldAPIName != null){
            for(String field : jsonNameFieldAPIName.values()){
                fields.add(field.toLowerCase());
            }
            for(String s :fields){
                selectStatement += s + ',';
            }
        }


        //Remove the hanging comma from the query
        selectStatement = selectStatement.subString(0,selectStatement.length() - 1);
        selectStatement += finalString;
        system.debug('selectStatement is '+selectStatement);
        return selectStatement;
        
    }

    public Id handleRequest(String requestBody, Opportunity objOppty,String sector,string documentType){
        HttpRequest request = new HttpRequest();
        request.setEndpoint(DocGen_Callout_Settings__c.getAll().get('DocGen').EndPoint_Contract__c);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setTimeout(60000);
        request.setBody(requestBody);
        Http http1 = new Http();
        HttpResponse res; 

        if(!Test.isRunningTest()){
            res = http1.send(request);
            if(res.getStatusCode() != 200){
                system.debug('Response is '+res.getStatus());
            }           
        }
        if((res != null && res.getStatusCode() == 200) || Test.isRunningTest()){
            // Attachment of the response to the Oppty record
            Attachment newAttachment = new Attachment();
            newAttachment.ParentId = objOppty.Id;
            newAttachment.Body = Test.isRunningTest()? Blob.valueOf(requestBody) : res.getBodyAsBlob();
            newAttachment.Name = 'PR0-'+objOppty.Name+'.pdf';
            insert newAttachment;
            attachmentId = newAttachment.Id;
        }
        return attachmentId;
    } // end of http handleRequest method
    
} // end of class