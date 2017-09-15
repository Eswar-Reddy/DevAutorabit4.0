public with sharing class OpportunityRolesUtility {

    // -------- Constructor --------
    public OpportunityRolesUtility() {}

    
    // -------- Constants --------
    public static Id systemsOppRecTypeId = SFDCSpecialUtilities.getRecordTypeIdsByDeveloperName(Opportunity.sObjectType).get('Systems');
    public static Id oppRoleRecTypeId = SFDCSpecialUtilities.getRecordTypeIdsByDeveloperName(Document_Data_Matrix__c.sObjectType).get('Opportunity_Role');  
    

    public static Map<String, String> dealTypeToContractTypeMap = new Map<String, String>{
        'PPA (including EPC)' => 'PPA', 'EPC' => 'EPC'
    };    
    public static Map<String, String> statusToDocTypeMap = new Map<String, String>{
        'Not Selected' => 'Firm Offer Approval', 'Approved (PR1)' => 'Customer Deal Approval', 'Approved (PR2)' => 'Standard Contract'
    };
    

    // -------- Variables --------    
    
    
    // -------- Properties --------


    //Methods
    //#120127355
    public static void processOppRoleDocumentCreation(Set<Id> roleIdsForDocCreation) {

        System.debug(roleIdsForDocCreation.size() + ' potential records for document creation');
        //Process necessary roles based on opportunity data and additional roles
        if(roleIdsForDocCreation == null || roleIdsForDocCreation.isEmpty())
            return;

        List<UC_Document__c> docsToCreate = new List<UC_Document__c>();
        Map<Id, Opportunity_Role__c> oppRolesForDocs = new Map<Id, Opportunity_Role__c>();//opp roles requiring docs
        Set<Id> oppIds = new Set<Id>();
        
        for(Opportunity_Role__c r : [SELECT Id, Name, Contract_Type__c, Status__c,
                                            Opp_Name__r.RecordTypeId, SPWR_Deal_Type_text__c
                                     FROM Opportunity_Role__c
                                     WHERE Id IN: roleIdsForDocCreation
                                     AND Opp_Name__r.RecordTypeId =: systemsOppRecTypeId]) {
            oppRolesForDocs.put(r.Id, r);                                            
        }

        System.debug('matched ' + oppRolesForDocs.size() + ' records for docs');
        if(oppRolesForDocs.isEmpty()) return;
        
        Set<String> contractTypes = new Set<String>();
        Set<String> dealTypes = new Set<String>();
        for(Opportunity_Role__c r : oppRolesForDocs.values()) {
            contractTypes.add(r.Contract_Type__c);
            dealTypes.add(r.SPWR_Deal_Type_text__c);
        }
        
        Map<String, List<Document_Data_Matrix__c>> docTypeToDataMap = new Map<String, List<Document_Data_Matrix__c>>();
        for(Document_Data_Matrix__c d : [SELECT Id, Name, Contract_Type__c, Deal_Type__c, Document_Type__c, Required_for_Approval__c
                                         FROM Document_Data_Matrix__c 
                                         WHERE RecordTypeId =: OpportunityRolesUtility.oppRoleRecTypeId
                                         AND Contract_Type__c IN: contractTypes
                                         AND Deal_Type__c IN: dealTypes
                                         AND Effective_End_Date__c >=: Date.Today()
                                         AND Effective_Start_Date__c <=: Date.Today()]) {
            if(docTypeToDataMap.containsKey(d.Contract_Type__c)) {
                docTypeToDataMap.get(d.Contract_Type__c).add(d);
            } else {
                docTypeToDataMap.put(d.Contract_Type__c, new List<Document_Data_Matrix__c>());
                docTypeToDataMap.get(d.Contract_Type__c).add(d);
            }
        }

        //Return if nothing matches parameters
        if(docTypeToDataMap == null || docTypeToDataMap.isEmpty())
            return;
        
        //pass to doc mapping
        for(Opportunity_Role__c r : oppRolesForDocs.values()) {//all the matching roles
            for(String s : docTypeToDataMap.keySet()) {//the contract types
                if(r.Contract_Type__c == s) {//match
                    for(Document_Data_Matrix__c d : docTypeToDataMap.get(s)) {//all the available document configurations
                        if(d.Document_Type__c == OpportunityRolesUtility.statusToDocTypeMap.get(r.Status__c) 
                            && r.SPWR_Deal_Type_text__c == d.Deal_Type__c) {
                            //match the status and deal type to the right set of documents
                            //Create Docs here
                            docsToCreate.add(new UC_Document__c(
                                name = (r.Name + ' - ' + d.Name), 
                                Opportunity_Role__c = r.Id,
                                Required_For_Approval__c = d.Required_for_Approval__c,
                                Document_Type__c = d.Document_Type__c));
                        }
                    }
                }
            }
        }

        if(docsToCreate != null && !docsToCreate.isEmpty()) {
            insert docsToCreate;
        }
    }




}