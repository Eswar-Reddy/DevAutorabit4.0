public class InvoiceComplianceDocAfterDeleteHandler extends TriggerHandlerBase {
  // -------- Constants --------

  // -------- Variables --------
  Map<Id, Invoice_Compliance_Document__c> oldICDmap;

  // -------- Constructor --------
  public InvoiceComplianceDocAfterDeleteHandler() {}

  // Cast and determine qualified records
  public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
    Diagnostics.push('InvoiceComplianceDocAfterDeleteHandler qualifyStartingRecords');

    oldICDmap = (Map<Id, Invoice_Compliance_Document__c>)oldMap;

    Diagnostics.pop();
  }

    public override void start() {
      Diagnostics.push('InvoiceComplianceDocBeforeInsertHandler start');

      InvoiceComplianceDocumentUtility.rollups_Count(Null, oldICDmap);

      Diagnostics.pop();
    }

    public override void finish(Boolean fromStart) {
        Diagnostics.push('InvoiceComplianceDocBeforeInsertHandler finish');

        if(fromStart) {

        }
        Diagnostics.pop();
    }
}