public with sharing class Warranty_SearchFDSAdminClass {
    // for standard list controllers
    
    public String searchKey{get;set;}
    public String searchValue{get;set;}   
    public ApexPages.StandardSetController setCon{get;set;}
    public List<WR_FDS_Product__c> products{get;set;}
    private String query;
    
    public class Warranty_SearchFDS_Wrapper{
    	public String warrantyNumber {get;set;}
    	
    	public String warrantyStatus {get;set;}
    	
    	public String warrantyDate {get;set;}
    	
    	public WR_FDS_Product__c product {get;set;} 
    	 
    	
    }
    
    public list<Warranty_SearchFDS_Wrapper> prodWarrantyWrapperLst;
    
    public Warranty_SearchFDSAdminClass(Apexpages.StandardController controller){
        
    }
    
    public PageReference searchRecords(){
        List<String> searchValues = searchValue.split('[,:; ]');
        String search='';
        for(String s : searchValues) 
          search += '\'' + s + '\',';                
        //query ='Select w.Alternate_Packing_Slip__c,w.WR_ORACLE_SalesOrder__r.Purchase_Order__c, w.WR_ORACLE_SalesOrder__r.Theater__c, w.LastModifiedDate, w.WR_ORACLE_SalesOrder__r.Sales_Order__c,w.WR_ORACLE_SalesOrder__c,w.WR_ORACLE_SalesOrder__r.LastModifiedDate, w.Third_PL_Name__c, w.Serial_Number__c, w.Product_Type__c, w.Product_Name__c, w.PickUpDate__c, w.Packing_Slip__c, w.Name, w.Manufacturer__c, w.Id, w.Dealer_Name__c From WR_FDS_Product__c w where ' + searchKey + ' IN(' + search.substring(0,search.length()-1) + ')';
        
        query ='Select (Select id,Warranty_Registration__r.Warranty_Number__c, Warranty_Registration__r.status__c, Warranty_Registration__r.delivery_date__c From WR_Line_Items__r), w.Alternate_Packing_Slip__c,w.WR_ORACLE_SalesOrder__r.Purchase_Order__c, w.WR_ORACLE_SalesOrder__r.Theater__c, w.LastModifiedDate, w.WR_ORACLE_SalesOrder__r.Sales_Order__c,w.WR_ORACLE_SalesOrder__c,w.WR_ORACLE_SalesOrder__r.LastModifiedDate, w.Third_PL_Name__c, w.Serial_Number__c, w.Product_Type__c, w.Product_Name__c, w.PickUpDate__c, w.Packing_Slip__c, w.Name, w.Manufacturer__c, w.Id, w.Dealer_Name__c From WR_FDS_Product__c w where ' + searchKey + ' IN(' + search.substring(0,search.length()-1) + ')';
        
        //query = 'Select (Select id,Warranty_Registration__r.Warranty_Number__c, Warranty_Registration__r.status__c, Warranty_Registration__r.delivery_date__c From WR_Line_Items__r), w.Alternate_Packing_Slip__c,w.WR_ORACLE_SalesOrder__r.Purchase_Order__c, w.WR_ORACLE_SalesOrder__r.Theater__c, w.LastModifiedDate, w.WR_ORACLE_SalesOrder__r.Sales_Order__c,w.WR_ORACLE_SalesOrder__c,w.WR_ORACLE_SalesOrder__r.LastModifiedDate, w.Third_PL_Name__c, w.Serial_Number__c, w.Product_Type__c, w.Product_Name__c, w.PickUpDate__c, w.Packing_Slip__c, w.Name, w.Manufacturer__c, w.Id, w.Dealer_Name__c From WR_FDS_Product__c w where w.id=\'a1NS0000003I5T5\'';
        if(searchKey.equals('w.Packing_Slip__c')){
            query = query + ' OR Alternate_Packing_Slip__c IN(' + search.substring(0,search.length()-1) + ')';
        }      
        setCon = new ApexPages.StandardSetController(Database.query(query + ' Limit 5000'));
        setCon.setPageSize(30);
        return null;
    }
    // Initialize setCon and return a list of records
    public List<WR_FDS_Product__c> getFdsRecords() {
        if(setCon != null)
            return (List<WR_FDS_Product__c>) setCon.getRecords();
        return null;
    } 
    
    // Initialize setCon and return a list of records
    public List<Warranty_SearchFDS_Wrapper> getProdWarrantyWrapperLst() {
    	prodWarrantyWrapperLst = new list<Warranty_SearchFDS_Wrapper>();
    	Warranty_SearchFDS_Wrapper prodWrapper;
        if(setCon != null){
        	products = setCon.getRecords();
        	
        	for (WR_FDS_Product__c prod : products){
        		prodWrapper = new Warranty_SearchFDS_Wrapper();
        		prodWrapper.product = prod;
        		if (prod.WR_Line_Items__r.size()>0){
        			prodWrapper.warrantyNumber = prod.WR_Line_Items__r.get(0).Warranty_Registration__r.Warranty_Number__c;
        			prodWrapper.warrantyStatus = prod.WR_Line_Items__r.get(0).Warranty_Registration__r.status__c;
        			prodWrapper.warrantyDate = String.valueOf(prod.WR_Line_Items__r.get(0).Warranty_Registration__r.delivery_date__c);
        		}else{
        			prodWrapper.warrantyNumber = '';
        			prodWrapper.warrantyStatus = '';
        			prodWrapper.warrantyDate = '';
        		}
        		prodWarrantyWrapperLst.add(prodWrapper);	
        	}	
        		
            return prodWarrantyWrapperLst;
        }
        return null;
    } 
     // Initialize setCon and return a list of records
    public  PageReference exportCSV() {
        if(query != null)
            products = Database.query(query +' Limit 1000');
        return new Pagereference('/apex/WR_SearchFDS_Export');
    }      
}