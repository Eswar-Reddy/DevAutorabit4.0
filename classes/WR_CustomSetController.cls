public class WR_CustomSetController{
    
  private transient List<WR_StagingSelection__c> allRecords;// This will initilize across all request.Querying this on each request to decrese view state size. 
  private Integer pagesize;
  private Integer totalRecords;
  private Integer currentPage;
  private Integer totalPages;
  private String query;
  private DateTime currentStagingDataTimeStamp;
  public List<WR_StagingSelection__c> pageRecords;
  
  public WR_CustomSetController(){
    allRecords = new List<WR_StagingSelection__c>();
    currentPage = 1;
    totalRecords = pageSize = totalPages = 0;
  }
  
  public WR_CustomSetController(ID warrantyID,Boolean IsInSelectedList,Integer pageSize, string sortField, string sortOrder){
    query = 'Select id,Customer_Name__c,IsDrafted__c,IsInSelectedList__c , WR_Line_Item__r.Warranty_Registration__c, '+
                            'isNew__c,isRegistered__c,ISselected__c,Warranty_Registration__c, '+
                            'WR_FDS_Product__c,WR_Line_Item__c,WR_FDS_Product__r.Converted_To_Asset__c,WR_FDS_Product__r.Serial_Number__c, '+
                            'WR_FDS_Product__r.WR_ORACLE_SalesOrder__r.Purchase_Order__c,WR_FDS_Product__r.Product_Name__c, '+
                            'WR_FDS_Product__r.Product_Type__c,isManuallyRegistered__c  '+
                        ' From WR_StagingSelection__c '+
                        'Where Warranty_Registration__c = \''+warrantyID+'\''
                        +' And IsInSelectedList__c = '+IsInSelectedList+' Order by '+String.escapeSingleQuotes(SortField)+' '+sortOrder +' Limit 9000';
    System.debug('Staging Query ==>'+query);                            
    //allRecords = Database.query(query);
    allRecords = new List<WR_StagingSelection__c>();
    for(WR_StagingSelection__c items : Database.query(query)){
            allRecords.add(items);
    }
    totalRecords = allRecords.size();
    this.query = query;
    this.pageSize = pageSize;
    this.currentPage = 1;
    totalPages = totalRecords/pageSize;
    Integer modVal = Math.mod(totalRecords,pageSize);
    if(modVal != 0)
        totalPages++;   
    //allRecords.clear();
  }  
  
  public WR_CustomSetController(ID warrantyID,Boolean IsInSelectedList,Integer pageSize, string sortField, string sortOrder,DateTime currentStagingDataTimeStamp){
    query = 'Select id,Customer_Name__c,IsDrafted__c,IsInSelectedList__c , WR_Line_Item__r.Warranty_Registration__c, '+
                            'isNew__c,isRegistered__c,ISselected__c,Warranty_Registration__c, '+
                            'WR_FDS_Product__c,WR_Line_Item__c,WR_FDS_Product__r.Converted_To_Asset__c,WR_FDS_Product__r.Serial_Number__c, '+
                            'WR_FDS_Product__r.WR_ORACLE_SalesOrder__r.Purchase_Order__c,WR_FDS_Product__r.Product_Name__c, '+
                            'WR_FDS_Product__r.Product_Type__c,isManuallyRegistered__c  '+
                        ' From WR_StagingSelection__c '+
                        'Where Warranty_Registration__c = \''+warrantyID+'\''
                        +' And IsInSelectedList__c = '+IsInSelectedList+' AND TimeStamp__c >= :currentStagingDataTimeStamp Order by '+String.escapeSingleQuotes(SortField)+' '+sortOrder +' Limit 9000';
    System.debug('Staging Query ==>'+query);                            
    //allRecords = Database.query(query);
    allRecords = new List<WR_StagingSelection__c>();
    for(WR_StagingSelection__c items : Database.query(query)){
            allRecords.add(items);
    }
    totalRecords = allRecords.size();
    this.query = query;
    this.pageSize = pageSize;
    this.currentPage = 1;
    totalPages = totalRecords/pageSize;
    Integer modVal = Math.mod(totalRecords,pageSize);
    if(modVal != 0)
        totalPages++;   
    this.currentStagingDataTimeStamp = currentStagingDataTimeStamp;
    //allRecords.clear();
  }
  
  //cdevarapall -- new method to do double sort so that locked products alway appear at the bottom
  public WR_CustomSetController(ID warrantyID,Boolean IsInSelectedList,Integer pageSize, string sortField, string sortOrder,DateTime currentStagingDataTimeStamp,String lockslast){
    query = 'Select id,Customer_Name__c,IsDrafted__c,IsInSelectedList__c , WR_Line_Item__r.Warranty_Registration__c, '+
                            'isNew__c,isRegistered__c,ISselected__c,Warranty_Registration__c, '+
                            'WR_FDS_Product__c,WR_Line_Item__c,WR_FDS_Product__r.Converted_To_Asset__c,WR_FDS_Product__r.Serial_Number__c, '+
                            'WR_FDS_Product__r.WR_ORACLE_SalesOrder__r.Purchase_Order__c,WR_FDS_Product__r.Product_Name__c, '+
                            'WR_FDS_Product__r.Product_Type__c,isManuallyRegistered__c  '+
                        ' From WR_StagingSelection__c '+
                        'Where Warranty_Registration__c = \''+warrantyID+'\''
                        +' And IsInSelectedList__c = '+IsInSelectedList+' AND TimeStamp__c >= :currentStagingDataTimeStamp Order by defaultSortOrder__c ASC,'+String.escapeSingleQuotes(SortField)+' '+sortOrder +' Limit 9000';
    System.debug('Staging Query ==>'+query);                            
    //allRecords = Database.query(query);
    allRecords = new List<WR_StagingSelection__c>();
    for(WR_StagingSelection__c items : Database.query(query)){
            allRecords.add(items);
    }
    totalRecords = allRecords.size();
    this.query = query;
    this.pageSize = pageSize;
    this.currentPage = 1;
    totalPages = totalRecords/pageSize;
    Integer modVal = Math.mod(totalRecords,pageSize);
    if(modVal != 0)
        totalPages++;   
    this.currentStagingDataTimeStamp = currentStagingDataTimeStamp;
    //allRecords.clear();
  }
  public List<WR_StagingSelection__c> getRecords(){
    if(allRecords == null || allRecords.size() ==0){
        if(query == null)
            allRecords = new List<WR_StagingSelection__c>();
        else{
            allRecords = new List<WR_StagingSelection__c>();
            for(WR_StagingSelection__c items : Database.query(query)){
                allRecords.add(items);
            }   
        }
    }
    pageRecords = new List<WR_StagingSelection__c>();
    if(allRecords.size() > 0){ system.debug('currentPage:::' + currentPage);
        for(Integer i = (currentPage-1)*pageSize; i < totalRecords && i < currentPage*pageSize; i++ ){
                pageRecords.add(allRecords.get(i));     
        }  
    }
    allRecords.clear();
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
    public Integer getCurrentPage(){
        return currentPage;
    }    
    
    public List<List<WR_StagingSelection__c>> getAllStagingRecords(){
        system.debug('query::::' + query);
        List<List<WR_StagingSelection__c>> allRecordsTemp;
        if(query == null)
            allRecordsTemp = new List<List<WR_StagingSelection__c>>();
        else{
           allRecordsTemp = new List<List<WR_StagingSelection__c>>();
           List<WR_StagingSelection__c> allRecordsInnerList = new List<WR_StagingSelection__c>();
           for(WR_StagingSelection__c items: Database.query(query)){
                allRecordsInnerList.add(items);
                if(allRecordsInnerList.size() >= 1000){
                    allRecordsTemp.add(allRecordsInnerList);
                    allRecordsInnerList = new List<WR_StagingSelection__c>(); 
                }
                
           }
          if(!allRecordsInnerList.isEmpty())
            allRecordsTemp.add(allRecordsInnerList);             
        }
        return allRecordsTemp;
   }
}