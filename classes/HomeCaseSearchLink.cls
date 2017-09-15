Public class HomeCaseSearchLink
{
    public string theTextInput{get;set;}
    public Case cs{get;set;}
    public List<Case> searchResults {get;set;}
    public boolean ResultTableRenderer {get;set;}
    Public HomeCaseSearchLink()
    {
        ResultTableRenderer = false;
        cs = new Case();
    }
     
     public PageReference search()
     {      
       searchResults = DataBase.query(getQueryString());
       if(searchResults != null && searchResults.size() > 0) 
       {
           ResultTableRenderer = true; 
       }   
       return null;
     }
     private String getQueryString () 
     {    
       boolean flag = false;
       String queryString = 'Select Id,CaseNumber,Serial_Num__c,Origin,Status from Case';          
       if(theTextInput!= null)
       {           
         String text= theTextInput.replace('*', '%') + '%';         
         queryString = queryString + ' where CaseNumber like \'' + text +'\'' + 'or Serial_Num__c like \'' + text +'\'' + 'Limit 100';        
         flag = true;
         system.debug(queryString + '------queryString -');
       }     
            
       return queryString;
     }

}