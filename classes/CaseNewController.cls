//*********************************************************************
//Name : CaseNewController
//Created On : 17th April,2009
//Created By : Appirio (Kirtesh)
//Implementation:
// Controller class for Case_New Page. 
// Check for Record type of New Case if case is of Inspection Type then redirect 
// page to VF inspectionReport page else native salesforce page.
//**********************************************************************

public class CaseNewController {
  private final Case cCase;
  
  //------------------------Constructor-------------------------------------//        
  public CaseNewController(ApexPages.StandardController stdcontroller) {
    this.cCase = (Case)stdcontroller.getRecord();
    if(this.cCase.Id != null) {
      this.cCase.RecordTypeId = [Select RecordTypeId FROM Case where Id = :this.cCase.Id Limit 1].RecordTypeId;
    
    }
  }
  
  public string getRedirectUrl() {
    if( IsNewRecord() && checkIfNewRecordTypeIsInspectionType() )
       return '/apex/InspectionReport?' + ApexPages.currentPage().getUrl().replace('/apex/Case_New?','');
    else{
       string recordType = System.currentPageReference().getParameters().get('RecordType');
       return '/500/e?retURL=%2F500%2Fo&RecordType=' + recordType + '&cancelURL=%2F500%2Fo&ent=Case&nooverride=1';  
    }
  }    
                 
  //-------------------------------------------------------------------------// 
  // Check if the New Record Type is of  Inspection Type
  //------------------------------------------------------------------------//                        
  private Boolean checkIfNewRecordTypeIsInspectionType() {
    string queryStringId = System.currentPageReference().getParameters().get('RecordType');
    
    //if(queryStringId == RetrieveRecordTypeId('Inspection')) {
    if(queryStringId == RetrieveRecordTypeId('Light Commercial Project – Inspection Case')) {
      return true;
    }
    return false;
  }
  
  //-------------------------------------------------------------------------// 
  // Retrieve Record TypeId 
  //------------------------------------------------------------------------//                      
  private string RetrieveRecordTypeId(string RecordName) {
    List<RecordType> lstRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Case' And Name =: RecordName];
    string recordTypeId = '';
    if(lstRecordType.size() > 0) {
      recordTypeId = lstRecordType[0].Id;
      recordTypeId = recordTypeId.subString(0,15);
    }
    return recordTypeId;
  }
  
  //-------------------------------------------------------------------------// 
  // Check For New Record
  //------------------------------------------------------------------------//  
  private Boolean IsNewRecord() {
    string recordType = System.currentPageReference().getParameters().get('RecordType');
    if(recordType != null)
      return true;
    
    return false;
  }
  
}