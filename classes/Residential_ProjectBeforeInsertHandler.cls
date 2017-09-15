/*

    Created By: Sita Reeves - Residential Installation Project Mgmt
    Created On: March 2016

    Functions
    -----------------------------
    IP Auto Assignment - SPD
    Template Auto Assignment - SPD
    IM Auto Assignment - TPS
    Template Auto Assignment - TPS
    Populate Current and Post Solar Rate Schedule
*/

public class Residential_ProjectBeforeInsertHandler  extends TriggerHandlerBase{
    // -------- Constants --------
    Id spdId = ResidentialProjectUtility.spdId; // RecordTypeId for 'SPD' on Residential Project
    Id tpsId = ResidentialProjectUtility.tpsId; // RecordTypeId for 'TPS' on Residential Project
    Id nhId = ResidentialProjectUtility.nhId; // RecordTypeId for 'New Home' on Residential Project
    Id indirectId = ResidentialProjectUtility.indirectId; // RecordTypeId for 'Indirect' on Residential Project
    Id iprId = ResidentialProjectUtility.iprId; // RecordTypeId for 'IP Region' on Project Installation Settings

    // -------- Variables --------
    Map<Residential_Project__c, String> autoAssignIP;
    Map<Residential_Project__c, Id> autoAssignTemplate;
    List<Residential_Project__c> tpsIM;
    List<Residential_Project__c> rateProjects;
    Map<Residential_Project__c, Id> tpsTemplate;
    Set<Id> newHomesInstallationModelIds;

    // -------- Constructor --------
    public Residential_ProjectBeforeInsertHandler() {}

    //Begin processing
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('Residential_ProjectBeforeInsertHandler qualifyStartingRecords');

        List<Residential_Project__c> newRecords = (List<Residential_Project__c>)newList;

        autoAssignIP                    = new Map<Residential_Project__c, String>();
        autoAssignTemplate              = new Map<Residential_Project__c, Id>();
        tpsIM                           = new List<Residential_Project__c>();
        rateProjects                    = new List<Residential_Project__c>();
        tpsTemplate                     = new Map<Residential_Project__c,Id>();
        newHomesInstallationModelIds    = new Set<Id>();

        // get the new homes installation models
        for(Installation_Model__c im : [SELECT Id FROM Installation_Model__c WHERE Partner__c = 'New Homes Project']) {
            newHomesInstallationModelIds.add(im.Id);
        }

        // create new home map for setting defaults
        Set<Id> newHomeIds = new Set<Id>();
        for(Residential_Project__c rp : newRecords){
            if (rp.RecordTypeId == nhId && String.isNotBlank(rp.Community__c)) newHomeIds.add(rp.Community__c);
        }
        Map<Id, NH_Community__c> newHomeMap = new Map<Id, NH_Community__c>();
        if(!newHomeIds.isEmpty()) {
            for(NH_Community__c nh : [SELECT Id, Sheet_Size__c, Total_Number_of_Sets__c FROM NH_Community__c WHERE Id IN :newHomeIds]) {
                newHomeMap.put(nh.Id, nh);
            }
        }

        for(Residential_Project__c rp : newRecords){
            // SPD specific processes
            if(rp.RecordTypeId == spdId ){
                /* IP Auto Assignment */
                // Collect Customer Zip codes so they can be crossed reference against IP regions and IP can be automatically assigned
                if(rp.Installation_Partner__c == NULL && String.isNotEmpty(rp.Customer_Zip__c)){
                    autoAssignIP.put(rp, rp.Customer_Zip__c);
                }
                /* Template Auto Assignment */
                if(rp.Installation_Partner__c != NULL && rp.Project_Template__c == NULL){
                    autoAssignTemplate.put(rp, rp.Installation_Partner__c);
                }
            }
            // TPS specific processes
            if(rp.RecordTypeId == tpsId){
                if(rp.Account__c != NULL && rp.Project_Template__c == NULL){
                    tpsTemplate.put(rp, rp.Account__c);
                }
            }
            /* Current and Post Solar Rate Schedule */
            if(rp.Account__c != NULL){
                rateProjects.add(rp);
            }
            // New Homes specific processes
            if(rp.RecordTypeId == nhId) {
                // calculate the total sales order value for new homes projects
                Decimal bwo = rp.Builder_WO_Value__c != null ? rp.Builder_WO_Value__c : 0;
                Decimal rw = rp.Rough_Wire_WO_Value__c != null ? rp.Rough_Wire_WO_Value__c : 0;
                Decimal abs = rp.AdditionalBuilderServicesWoValue__c != null ? rp.AdditionalBuilderServicesWoValue__c : 0;
                rp.TotalSOValue__c =  bwo + rw + abs;

                // check installation model for new homes
                if(String.isNotBlank(rp.Installation_Model__c) && !newHomesInstallationModelIds.contains(rp.Installation_Model__c)) {
                    rp.addError('The selected Installation Model is NOT valid for a New Homes Project');
                }

                // Default Sheet Size to NH Community Sheet Size.
                if(String.isNotBlank(rp.Community__c)){
                    if (String.isNotBlank(newHomeMap.get(rp.Community__c).Sheet_Size__c)) rp.Sheet_Size_Proj__c = newHomeMap.get(rp.Community__c).Sheet_Size__c;
                    if (newHomeMap.get(rp.Community__c).Total_Number_of_Sets__c != null) rp.Total_Number_of_Sets_Proj__c = newHomeMap.get(rp.Community__c).Total_Number_of_Sets__c;
                }
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
        /* SPD IP Auto Assignment */
        if(autoAssignIP.size() >0){
            Map<String, Id> zipMap = new Map<String, Id>();

            for(Project_Installation_Setting__c meta : [SELECT Id, Installation_Partner__c, Zip_Code__c FROM Project_Installation_Setting__c WHERE RecordTypeId =: iprId AND Zip_Code__c IN: autoAssignIP.values()]){
                zipMap.put(meta.Zip_Code__c, meta.Installation_Partner__c);
            }

            for(Residential_Project__c rp : autoAssignIP.keyset()){
                if(zipMap.containsKey(rp.Customer_Zip__c)) rp.Installation_Partner__c = zipMap.get(rp.Customer_Zip__c);
                if(rp.Project_Template__c == NULL ) autoAssignTemplate.put(rp, rp.Installation_Partner__c);
            }
        }

        /* SPD Template Auto Assignment */
        if(!autoAssignTemplate.isEmpty()) ResidentialProjectUtility.findTemplate(autoAssignTemplate);

        /* TPS Template Auto Assignment */
        if(!tpsTemplate.isEmpty()) ResidentialProjectTPSUtility.findTPSTemplate(tpsTemplate);

        /* Current and Post Solar Rate Schedule */
        if(!rateProjects.isEmpty()) ResidentialProjectUtility.getSolarRateSchedule(rateProjects);
    }

    public override void finish(Boolean fromStart) {
        if(fromStart) {}
        Diagnostics.pop();
    }
}