public without sharing class WR_SalesOrderFilter {
    
    public Date deliveryStartDate{get;set;} 
        
    public Date deliveryEndDate{get;set;}
        
    public String numberValue{get;set;}
        
    public String numberType{get;set;} 
        
    public String partnerAccountNumber{get;set;}
        
 
    private string previousSortField = 'Purchase_Order__c';
        
    public boolean isAscending {get;set;}
        
    public ID partnerRecordTypeID{get;set;}
        
    public string sortField {
        get;
             set {
        previousSortField = sortField;
        sortField = value;
          if(previousSortField == sortField) {
            isAscending = !isAscending;
            return;
          }
          isAscending = true;   
        }
   } 
   public String sortingOrder{get;set;}    
      
}