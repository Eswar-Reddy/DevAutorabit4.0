/*
* Wrapper class for customer search Search Parameters
* @Author Anjali Khandelwal (Appiro offshore)
*/
public with sharing class WR_customerFilter {
    
    public String dealerID{get;set;}
        
    public String countryDomain{get;set;}
    
    public String searchText{get;set;}
    
    //cdevarapalli -- Warranty Registration Process - SSE -- Adding new parameters to capture filter text and click search
    public String filterText{get;set;}
    public boolean isSearchByClick{get; set;}
    
    public string previousSortField = 'Name';
    
    public boolean isAscending {get;set;}
    
    public ID homeOwnerRecordTypeID{get;set;}
    
    public ID commercialRecordTypeID{get;set;}
    
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