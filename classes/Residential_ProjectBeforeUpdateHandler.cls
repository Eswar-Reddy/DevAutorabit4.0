/*

    Created By: Sita Reeves - Residential Installation Project Mgmt
    Created On: March 2016

    Functions
    -----------------------------
    Field Validation - Uses ResidentialProjectValidationUtility class
    Populate Current and Post Solar Rate Schedule
    Auto Assign Template - SPD - Installation Partner
    Auto Assign Template - TPS - Installation Model
    Project Off Hold - Clear Hold Justification
*/

public class Residential_ProjectBeforeUpdateHandler  extends TriggerHandlerBase{
    // -------- Constants --------
    Id spdId = ResidentialProjectUtility.spdId; // RecordTypeId for 'SPD' on Residential Project
    Id tpsId = ResidentialProjectUtility.tpsId; // RecordTypeId for 'TPS' on Residential Project
	Id nhId = ResidentialProjectUtility.nhId; // RecordTypeId for 'New Home' on Residential Project
    Id indirectId = ResidentialProjectUtility.indirectId; // RecordTypeId for 'Indirect' on Residential Project

    // -------- Variables --------
    List<Residential_Project__c> projectsOffHold;
    List<Residential_Project__c> rateProjects;
    Map<Residential_Project__c, Id> autoAssignSPDTemplate;
    Map<Residential_Project__c, Id> autoAssignTPSTemplate;
    Set<Id> fieldValidate;
    List<Id> imChange;
    Map<Id, Residential_Project__c> newMapRecords;
	Set<Id> newHomesInstallationModelIds;

    // -------- Constructor --------
    public Residential_ProjectBeforeUpdateHandler() {}

    //Begin processing
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('Residential_ProjectBeforeUpdateHandler qualifyStartingRecords');

        List<Residential_Project__c> newRecords = (List<Residential_Project__c>)newList;
        Map<Id, Residential_Project__c> oldMapRecords = (Map<Id, Residential_Project__c>)oldMap;
        newMapRecords = (Map<Id, Residential_Project__c>)newMap;

        projectsOffHold       = new List<Residential_Project__c>();
        rateProjects          = new List<Residential_Project__c>();
        fieldValidate         = new Set<Id>();
        autoAssignSPDTemplate = new Map<Residential_Project__c, Id>();
        autoAssignTPSTemplate = new Map<Residential_Project__c, Id>();
        imChange              = new List<Id>();
		newHomesInstallationModelIds    = new Set<Id>();

        // get the new homes installation models
        for(Installation_Model__c im : [SELECT Id FROM Installation_Model__c WHERE Partner__c = 'New Homes Project']) {
            newHomesInstallationModelIds.add(im.Id);
        }

        /* Field Update Validation */
        Map<Id, String> errorMap = new Map<Id, String>();
        if(ResidentialProjectUtility.runValidation == TRUE) errorMap = ResidentialProjectValidationUtility.fieldValidation(newRecords, oldMapRecords);

        for(Residential_Project__c rp : newRecords){
            Residential_Project__c oldRP = oldMapRecords.get(rp.Id);

			// new homes checks/updates
            if(rp.RecordTypeId == nhId) {
                // calculate the total sales order value for new homes projects
                Decimal bwo = rp.Builder_WO_Value__c != null ? rp.Builder_WO_Value__c : 0;
                Decimal rw = rp.Rough_Wire_WO_Value__c != null ? rp.Rough_Wire_WO_Value__c : 0;
                Decimal abs = rp.AdditionalBuilderServicesWoValue__c != null ? rp.AdditionalBuilderServicesWoValue__c : 0;
                rp.TotalSOValue__c =  bwo + rw + abs;

                // check installation model for new homes
                if(String.isNotBlank(rp.Installation_Model__c) && !newHomesInstallationModelIds.contains(rp.Installation_Model__c)) {
                    errorMap.put(rp.Id, 'The selected Installation Model is NOT valid for a New Homes Project');
                }
            }
            // Throw error if field validation failed
            if(errorMap.containsKey(rp.Id)) rp.addError(errorMap.get(rp.Id));

            /* Project Off Hold */
            if(oldRP.Status__c == 'Hold' && rp.Status__c != 'Hold') projectsOffHold.add(rp);

            /* Current and Post Solar Rate Schedule */
            if(rp.Account__c != NULL && rp.Account__c != oldRP.Account__c){
                rateProjects.add(rp);
            }
            if(rp.Account__c == NULL && rp.Account__c != oldRP.Account__c){
                rp.Current_Rate_Plan__c = NULL;
                rp.Proposed_Rate_Plan__c = NULL;
            }

            /* Auto Assign Template */
            // If IP is assigned and project template is NULL and record type = 'SPD' try to auto assign template
            if(rp.Project_Template__c == NULL && rp.Installation_Partner__c != NULL && rp.RecordTypeId == spdId) autoAssignSPDTemplate.put(rp, rp.Installation_Partner__c);

            // If Account is assigned and project template is NULL and record type = 'TPS' try to auto assign template
            if(rp.Project_Template__c == NULL && rp.Account__c != NULL && rp.RecordTypeId == tpsId) autoAssignTPSTemplate.put(rp, rp.Account__c);

            /* Installation Model Change */
            if(rp.Installation_Model__c != oldRP.Installation_Model__c && oldRP.Installation_Model__c != NULL){
                imChange.add(rp.Id);
            }

            // set the installation model on the project if possible
            String rpType = rp.RecordTypeId == spdId ? 'SPD' : rp.RecordTypeId == tpsId ? 'TPS' : rp.RecordTypeId == nhId ? 'New Home' : rp.RecordTypeId == indirectId ? 'Indirect' : null;
            if(String.isBlank(rp.Installation_Model__c) && String.isNotBlank(rp.Quote__c) && String.isNotBlank(rp.Quote__r.Installation_Model__c)) {
                if(rp.RecordTypeId == nhId) {
                    if(newHomesInstallationModelIds.contains(rp.Quote__r.Installation_Model__c)) rp.Installation_Model__c = rp.Quote__r.Installation_Model__c;
                } else {
                    rp.Installation_Model__c = rp.Quote__r.Installation_Model__c;
                }
            } else if(String.isBlank(rp.Installation_Model__c) && String.isNotBlank(rpType) && String.isNotBlank(rp.SPWR_Deal_Type__c)) {
                rp.Installation_Model__c = InvoiceDocumentUtility.findInstallationModel(rp.SPWR_Deal_Type__c, rpType, rp.Customer_Country__c);
            }
        }
    }

    public override void start() {
        // Remove Hold Justification for project that has gone out of the hold status
        for(Residential_Project__c rp : projectsOffHold) {
            rp.Hold_Justification__c = NULL;
        }

        /* Auto Assign Template */
        // SPD
        if(autoAssignSPDTemplate.size() > 0) ResidentialProjectUtility.findTemplate(autoAssignSPDTemplate);
        // TPS
        if(autoAssignTPSTemplate.size() > 0) ResidentialProjectTPSUtility.findTPSTemplate(autoAssignTPSTemplate);

        /* Current and Post Solar Rate Schedule */
        if(!rateProjects.isEmpty()) ResidentialProjectUtility.getSolarRateSchedule(rateProjects);

    }

    public override void finish(Boolean fromStart) {
        if(fromStart) {}
        Diagnostics.pop();
    }
}