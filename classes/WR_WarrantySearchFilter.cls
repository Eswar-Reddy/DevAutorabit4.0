/*
* This is wrapper class for Waranty Search search parameters.
* @Author Anjali Khandelwal (Appiro offshore)
*/
public with sharing class WR_WarrantySearchFilter {
	
	public String customerName{get;set;}
        
    public Date startDate{get;set;}
    
    public Date endDate{get;set;}
    
    public String status{get;set;}
    
    public String warrantyNumber{get;set;}
    
    public string previousSortField = 'Name';
    
    public boolean isAscending {get;set;}
    
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