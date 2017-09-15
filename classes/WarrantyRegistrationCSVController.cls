public with sharing class WarrantyRegistrationCSVController {
    public transient Warranty_Registration__c warranty{get;set;}
    public transient String FileName{get;set;}
    //Start for case#00068822  
    public transient List<csvWrapper> thousandBlocks{get;set;}
    //End for case#00068822
         
    public WarrantyRegistrationCSVController(){
       try{ 
        warranty = [SELECT Name,Customer_SFDC_ID__r.Name,Customer_SFDC_ID__r.PersonMobilePhone,Customer_SFDC_ID__r.Email__c, Customer_SFDC_ID__r.Phone, Customer_SFDC_ID__r.BillingStreet, Customer_SFDC_ID__r.BillingCity, Customer_SFDC_ID__r.BillingState, Customer_SFDC_ID__r.BillingPostalCode,
        Partner_SFDC_ID__r.Name, Partner_SFDC_ID__r.PersonMobilePhone,Partner_SFDC_ID__r.Email__c, Partner_SFDC_ID__r.Phone, Partner_SFDC_ID__r.BillingStreet, Partner_SFDC_ID__r.BillingCity, Partner_SFDC_ID__r.BillingState, Partner_SFDC_ID__r.BillingPostalCode,
        Delivery_Date__c,
        (Select Id, WR_FDS_Product__r.Product_Name__c,WR_FDS_Product__r.Product_Type__c, WR_FDS_Product__r.Serial_Number__c From WR_Line_Items__r ORDER BY WR_FDS_Product__r.Product_Type__c DESC)
        FROM Warranty_Registration__c where ID=:apexpages.currentpage().getParameters().get('warrantyId')];

        String currentTimeStamp = (String.valueOf(System.now()).replace(':', '-')).replace(' ','_');       
        FileName = warranty.Customer_SFDC_ID__r.Name +  '-' + warranty.Partner_SFDC_ID__r.Name + '_' + currentTimeStamp + '.csv';       
        //FileName = FileName.replaceAll(' ','');
        FileName = FileName.replaceAll('\\s','');       
        FileName = EncodingUtil.urlEncode(FileName,'UTF-8');
        
        //Start for case#00068822        
        thousandBlocks = new List<csvWrapper>();
        Long MAX_HEAP_SIZE = Limits.getLimitHeapSize();
        Integer counter = 0;
        Integer loopCount = 0;
        Boolean isAdded = true;
        List<WR_Line_Item__c> tmpLines = new List<WR_Line_Item__c>();
        for(WR_Line_Item__c wrline : warranty.WR_Line_Items__r){
            if(Limits.getHeapSize() <= MAX_HEAP_SIZE){
	            if(counter < 1000){
	                tmpLines.add(wrline);
	                isAdded = false;
	                counter++;	                
	            }else{
	                thousandBlocks.add(new csvWrapper(tmpLines,++loopCount));
	                isAdded = true;
	                tmpLines = new List<WR_Line_Item__c>();
	                tmpLines.add(wrline);	                
	                counter = 0;	                
	            }
            }             
        }
        
        if(!isAdded)
            thousandBlocks.add(new csvWrapper(tmpLines,++loopCount));
        System.debug('Heap Size->'+Limits.getHeapSize());
        //End for case#00068822        
       }catch(Exception ex){
            System.debug('------ Unexpected error ----'+ex.getMessage());
       }
    }
    //Start for case#00068822  
	public class csvWrapper{
        public List<WR_Line_Item__c> wrLines {get;set;}
        public Integer blockNumber {get;set;}
        public csvWrapper(List<WR_Line_Item__c> wrLines, Integer i){
            this.wrLines = wrLines;
            this.blockNumber = i;
        }        
    }
    //End for case#00068822  
}