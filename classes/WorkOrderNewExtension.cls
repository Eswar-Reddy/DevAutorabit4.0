public class WorkOrderNewExtension {
    private final WorkOrder wo;
    private String rmaField_lkid;
    
    public WorkOrderNewExtension(ApexPages.StandardController stdController) {
        this.wo = (WorkOrder)stdController.getRecord();
    }
    
    private void loadCustomSettings() {
         List <Service_Request_Settings__c> settingList = [SELECT Name, Default_Value__c 
            FROM Service_Request_Settings__c 
            WHERE Name LIKE 'SR_%'
            ORDER BY Name ASC];    
        for (Service_Request_Settings__c setting : settingList) {
            if (String.IsNotBlank(setting.Default_Value__c)) {
                if (setting.Name.equalsIgnoreCase('SR_WorkOrder_RMA__c_Field_lkid')) {
                    rmaField_lkid = setting.Default_Value__c;
                }
            }
        }
    }
    
    public PageReference redirectPage() {
        PageReference pr; 
        
        loadCustomSettings();   

        String woId = ApexPages.currentPage().getParameters().get('id');    // coming from standard edit override
        // new button from related list of case detail page
        String case_lkid = ApexPages.currentPage().getParameters().get('Case_lkid');    
        // new button from related list of RMA detail page
        String rmaId;
        if (String.IsNotBlank(rmaField_lkid)) {
            rmaId = ApexPages.currentPage().getParameters().get(rmaField_lkid);
        }
        String retURL = ApexPages.currentPage().getParameters().get('retURL');    // save and new button
        String caseKeyPrefix = Case.SObjectType.getDescribe().getKeyPrefix();        
        String rmaKeyPrefix = RMA__c.SObjectType.getDescribe().getKeyPrefix();        
        String woKeyPrefix = WorkOrder.SObjectType.getDescribe().getKeyPrefix(); 
        
        if (String.IsNotBlank(woId)) {
            List <WorkOrder> woList = [SELECT Id FROM WorkOrder WHERE Id = :woId LIMIT 1];
            if (woList.size() > 0) {
                pr = Page.ServiceRequest;
                pr.getParameters().put('Id', woId); 
                pr.setRedirect(true);       
            }        
        } else if (String.IsNotBlank(rmaId)) {
            String parentId = rmaId.left(15);
            if (parentId.startsWith(rmaKeyPrefix)) {        
                List <RMA__c> rmaList = [SELECT Id FROM RMA__c WHERE Id = :parentId LIMIT 1];                
                if (rmaList.size() > 0) {
                    pr = Page.ServiceRequest;
                    pr.getParameters().put('Id', parentId); 
                    pr.setRedirect(true);       
                }
            }
        } else if (String.IsNotBlank(case_lkid)) {
            String parentId = case_lkid.left(15);
            if (parentId.startsWith(caseKeyPrefix)) {        
                List <Case> cList = [SELECT Id FROM Case WHERE Id = :parentId LIMIT 1];                
                if (cList.size() > 0) {
                    pr = Page.ServiceRequest;
                    pr.getParameters().put('Id', parentId); 
                    pr.setRedirect(true);       
                }
            }
        }  else if (String.IsNotBlank(retURL)) {
            if (retURL.startsWith('/')) {
                retURL = retURL.subString(1, retURL.length());            
            } 
            String parentId = retURL.left(15);      
            if (parentId.startsWith(woKeyPrefix) || parentId.startsWith(caseKeyPrefix)) { 
                List <WorkOrder> woList = [SELECT Id FROM WorkOrder WHERE Id = :parentId LIMIT 1];
                if (woList.size() > 0) {
                    pr = Page.ServiceRequest;
                    pr.getParameters().put('Id', parentId); 
                    pr.setRedirect(true);       
                } else {
                    List <Case> cList = [SELECT Id FROM Case WHERE Id = :parentId LIMIT 1];                
                    if (cList.size() > 0) {
                        pr = Page.ServiceRequest;
                        pr.getParameters().put('Id', parentId); 
                        pr.setRedirect(true);       
                    }
                }       
            }
        }       

        return pr;    
    }

}