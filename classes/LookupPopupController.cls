//
// Custom controller for lookup example popup page
//
public with sharing class LookupPopupController 
{
    public String query {get; set;}
    public List<Account> accounts {get; set;}
    public List<sObject> sObj {get; set;}
    public String ObjectName {get;set;}
    public String FieldName {get;set;}
    public String messageString {get;set;}
    
    public LookupPopupController(){
        ObjectName='';
        FieldName='';
        messageString = '';
        if(apexpages.currentpage().getparameters().get('ObjectName')!=null && apexpages.currentpage().getparameters().get('ObjectName')!=''){
            ObjectName = apexpages.currentpage().getparameters().get('ObjectName') ;   
        }
        if(apexpages.currentpage().getparameters().get('FieldName')!=null && apexpages.currentpage().getparameters().get('FieldName')!=''){
            FieldName = apexpages.currentpage().getparameters().get('FieldName') ;   
        }
    
    }
    
    public void runQuery()
    {
             
        if(FieldName!='' && ObjectName!=''){
        String val='\'%' + String.escapeSingleQuotes(query.trim()) + '%\'';
        String searchquery='SELECT Id,' + FieldName + ' FROM '+ObjectName+' WHERE '+FieldName+' Like '+val; 
        sOBj = Database.query(searchquery);
        if(sObj.size()>0){
            messageString = '';
        }else{
            messageString = 'No Results Found';
        }
        system.debug('===>'+sObj);
        }
        //List<List<sObject>> searchResults=[FIND :query IN ALL FIELDS RETURNING Account (id, name, billingstreet, billingcity, billingpostalcode)];
        //sObj=searchResults[0];
        //return null;
    }
}