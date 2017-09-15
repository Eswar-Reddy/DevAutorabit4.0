/***
Class Name: WR_CustomSetController_Test
Description: Controller Class orginally with a _Test Name

Revision History:
MAM 16.JUN.2015 - Commented out test class since this is a duplicate of WR_CustomSetController
***/
@isTest
public with sharing class WR_CustomSetController_Test {
/*  
  private transient List<WR_StagingSelection__c> allRecords;// This will initilize across all request.Querying this on each request to decrese view state size. 
  private Integer pagesize;
  private Integer totalRecords;
  private Integer currentPage;
  private Integer totalPages;
  private String query;
  private List<WR_StagingSelection__c> pageRecords;
  
  
  public WR_CustomSetController_Test(ID warrantyID,Boolean IsInSelectedList,Integer pageSize, string sortField, string sortOrder){
    query = 'Select id,Customer_Name__c,IsDrafted__c,IsInSelectedList__c, '+
                            'isNew__c,isRegistered__c,ISselected__c,Warranty_Registration__c, '+
                            'WR_FDS_Product__c,WR_Line_Item__c,WR_FDS_Product__r.Converted_To_Asset__c,WR_FDS_Product__r.Serial_Number__c, '+
                            'WR_FDS_Product__r.WR_ORACLE_SalesOrder__r.Purchase_Order__c,WR_FDS_Product__r.Product_Name__c, '+
                            'WR_FDS_Product__r.Product_Type__c '+
                        ' From WR_StagingSelection__c '+
                        'Where Warranty_Registration__c = :warrantyID '+
                        'And IsInSelectedList__c = :IsInSelectedList Order by '+String.escapeSingleQuotes(SortField)+' '+sortOrder +' limit 10000';
                            
    allRecords = Database.query(query);
    totalRecords = allRecords.size();
    this.query = query;
    this.pageSize = pageSize;
    this.currentPage = 1;
    totalPages = totalRecords/pageSize;
    Integer modVal = Math.mod(totalRecords,pageSize);
    if(modVal != 0)
        totalPages++;   
  }
  public List<WR_StagingSelection__c> getRecords(){
    if(allRecords == null){
        allRecords = Database.query(query);
    }
    pageRecords = new List<WR_StagingSelection__c>();
    for(Integer i = (currentPage-1)*pageSize; i < totalRecords && i < currentPage*pageSize; i++ ){
            pageRecords.add(allRecords.get(i));     
    }  
    return pageRecords; 
  }
  public void next(){
        update pageRecords;
        currentPage++;  
    }
    public void previous(){
        update pageRecords;
        currentPage--;
    }
    public void first(){
        update pageRecords;
        currentPage = 1 ;
    }
    public void last(){
        update pageRecords;
        currentPage = totalPages;
    } 
    public Boolean getHasNext(){
        if(currentPage != totalPages && totalPages != 0 )
            return true;
        else
            return false;
    }
    public Boolean getHasPrevious(){
        if(currentPage != 1)
            return true;
        else
            return false;   
    }   
    public void save(){
        update pageRecords;
    } 
    public Integer getResultSize(){
        return totalRecords;
    } 
*/ 
}