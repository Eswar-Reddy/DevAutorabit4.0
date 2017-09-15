/* **************************************************************************************
* Class Name     : Residential_ProjectBeforeDeleteHandler
* Version        : 1.0
* Created Date   : 09 feb 2017
* Function       : Function execute on Residential Project after delete. 

* Modification Log    :
* Developer             Date                   Description
* ----------------------------------------------------------------------------
* Ankit                 09 feb 2017         Original Version
*************************************************************************************/
public class Residential_ProjectBeforeDeleteHandler  extends TriggerHandlerBase{

  List<Document__c> relatedDocuments = new List<Document__c> ();
  List<Residential_Project__c> deletedrecords = new List<Residential_Project__c> ();
  
  public Residential_ProjectBeforeDeleteHandler(){}
  
   public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
           Diagnostics.push('Residential_ProjectBeforeDeleteHandler qualifyStartingRecords');  
               deletedRecords = (List<Residential_Project__c>) oldList;
               system.debug('--deleted Records--' + deletedRecords);          
  }

  public override void start(){
  if(deletedRecords.size()>0)  
    for(Residential_Project__c objRP : [select Id,(Select Id from Documents__r) 
                                        from Residential_Project__c 
                                        where Id IN : deletedRecords]){
         relatedDocuments.addAll(objRP.Documents__r);                               
       }
       
     if(relatedDocuments <> Null && relatedDocuments.size()>0) 
          delete relatedDocuments; 
    }
  
  public override void finish(Boolean fromStart) {
        if(fromStart) {
          
        }
        Diagnostics.pop();
    }
    
}