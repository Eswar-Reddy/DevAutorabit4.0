public class PartnerApplicationTopMsgController {
    public String msg {get; private set;}
    
    public PartnerApplicationTopMsgController(ApexPages.StandardController stdController) {
        msg = '';
        List<Partner_Application__c> partnerAppList = [Select RSM__c, Area_Sales_Manager__c,
                Director_of_Sales__c, Status__c,
                Address__c,city__c,zip__c,Contract_Signatory__c,Contract_Signatory_Email__c, 
                RecordType.Name,Country__c//for case #00039606 
                From Partner_Application__c where Id=:stdController.getId() limit 1];
        
        if (partnerAppList.Size() == 0) {
            return;
        }
        
        Integer count = 0;
        Partner_Application__c partnerApp = partnerAppList.get(0);
        
        if (partnerApp.RecordType.Name == 'NA Partner Application'
                && partnerApp.Area_Sales_Manager__c == null) {
            msg = 'Area Sales Manager';
            count++;
        } else if (partnerApp.RecordType.Name == 'EU Partner Application'
            //for case #00039606 
                || partnerApp.RecordType.Name == 'AUS Partner Application'
                || partnerApp.RecordType.Name == 'JP Partner Application') {
            if (partnerApp.RSM__c == null) {
                msg = 'RSM';
                count++;
            }
            
            if (partnerApp.Director_of_Sales__c == null) {
                if (count > 0) {
                    msg += ' and ';
                }
                
                msg += 'Director of Sales';
                count++;
            }
        }
        
        if (partnerApp.Status__c == 'Approved') {
            msg = 'Application has been Approved.';
        }
        else if (count == 0) {
            msg = 'Application can be submitted for approval.';
        } else {
            msg += ' must be filled before submitting for approval.';
        }
    }
}