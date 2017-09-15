/*
    Created By: Sita Reeves - Residential Installation Project Mgmt
    Created On: March 2016

    Functions
    -----------------------------
    Template Creation
    Roof Details
    Alliance Partner Creation
    Applying Notes and Documents from Opp to Project

*/
public class Residential_ProjectAfterInsertHandler extends TriggerHandlerBase{
    // -------- Constants --------
    Id ptId = ProjectTaskUtility.ptId; // Project Task 'Project Task' RecordTypeId
    Id spdId = ResidentialProjectUtility.spdId; // RecordTypeId of 'SPD' for Residential Project
    Id tpsId = ResidentialProjectUtility.tpsId; // RecordTypeId of 'TPS' for Residential Project
    Id nhId = ResidentialProjectUtility.nhId; // RecordTypeId of 'New Home' for Residential Project
    Id indirectId = ResidentialProjectUtility.indirectId; //RecordTypeId of 'Indirect' for Residential Project
    Id papId = Schema.SObjectType.Alliance_Partner__c.getRecordTypeInfosByName().get('Project Alliance Partner').getRecordTypeId();

    // -------- Variables --------
    List<Document__c>     documentsToUpdate;
    List<Note>            notesToInsert;
    Map<Id, Id>           projectSPD;
    Map<Id, Id>           projectTPS;
    Map<Id, Id>           projectNH;
    Map<Id, Id>           projectsOpp;
    Map<Id, Id>           projectsQuote;
    Map<Id, Id>           tpsPartner;
    Set<Id>               ipSet;
    Set<Id>               comSet;
    Map<Id, Id>           projectsIM;
    Map<Id, Id>           communityProject;
    List<Alliance_Partner__c> apToInsert;
    Map<Id, Id>           qModelAssignment;
    List<Quote>           quoteModels;
    Set<Id> projectsICD;
    Set<Id> indirectRPs;
    Set<Id> spdRPs;
    Map<Id, Residential_Project__c> apRPs;

    // -------- Constructor --------
    public Residential_ProjectAfterInsertHandler() {}

    //Begin processing
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('ResidentialProjectAfterInsertHandler qualifyStartingRecords');

        List<Residential_Project__c> newRecords = (List<Residential_Project__c>)newList;

        projectSPD      = new Map<Id, Id>();
        projectTPS      = new Map<Id, Id>();
        projectNH       = new Map<Id, Id>();
        projectsQuote   = new Map<Id, Id>();
        projectsOpp     = new Map<Id, Id>();
        ipSet           = new Set<Id>();
        comSet          = new Set<Id>();
        projectsIM      = new Map<Id, Id>();
        communityProject = new Map<Id, Id>();
        tpsPartner      = new Map<Id, Id>();
        qModelAssignment  = new Map<Id, Id>();
        quoteModels     = new List<Quote>();
        projectsICD     = new Set<Id>();
        indirectRPs     = new Set<Id>();
        spdRPs          = new Set<Id>();

        for(Residential_Project__c rp : newRecords){
            /* Template Creation */
            if(rp.Project_Template__c != NULL) {
                if(rp.RecordTypeId == spdId){
                    projectSPD.put(rp.Id, rp.Project_Template__c);
                    if(rp.Installation_Partner__c != NULL) ipSet.add(rp.Installation_Partner__c);
                }
                if(rp.RecordTypeId == tpsId){
                    projectTPS.put(rp.Id, rp.Project_Template__c);
                }
                if(rp.RecordTypeId == nhId){
                    projectNH.put(rp.Id, rp.Project_Template__c);
                    if(rp.Community__c != NULL) comSet.add(rp.Community__c);
                }
            }

            /* Projects with Opportunities */
            if(rp.Opportunity__c != NULL) projectsOpp.put(rp.Id, rp.Opportunity__c);

            /* Projects with Quote */
            if(rp.Quote__c != NULL) projectsQuote.put(rp.Id, rp.Quote__c);

            /* Alliance Partner Creation */
            if(rp.RecordTypeId == tpsId && rp.Opportunity__c != NULL) tpsPartner.put(rp.Id, rp.Opportunity__c);
            if(rp.RecordTypeId == tpsId && rp.Installation_Model__c != NULL) projectsIM.put(rp.Id, rp.Installation_Model__c);
            if(rp.RecordTypeId == nhId && rp.Community__c != NULL ) communityProject.put(rp.Community__c, rp.Id);
            if(rp.RecordTypeId == indirectId) indirectRPs.add(rp.Id);
            if(rp.RecordTypeId == spdId) spdRPs.add(rp.Id);


            /* Installation Model Assignment */
            if(rp.RecordTypeId == tpsId && rp.Installation_Model__c != NULL) {
                if(rp.Quote__c != NULL) qModelAssignment.put(rp.Quote__c, rp.Installation_Model__c);
            }
            // get projects that need invoice compliance docs
            if(String.isNotBlank(rp.Installation_Model__c) && String.isNotBlank(rp.Quote__c)) {
                projectsICD.add(rp.Id);
            }
        }

        if(!projectsQuote.isEmpty()) ResidentialProjectUtility.attachRoofDetails(projectsQuote);
    }

    public override void start() {
        notesToInsert       = new List<Note>();
        documentsToUpdate   = new List<Document__c>();

        if(!projectsOpp.isEmpty()) {
            // Get Notes and Documents from Opportunity
            List<Document__c>   documents   = [SELECT Id, Opportunity__c, Residential_Project__c FROM Document__c WHERE Opportunity__c IN: projectsOpp.values()];
            List<Note>          notes       = [SELECT Title, Body, ParentId FROM Note WHERE ParentId IN: projectsOpp.values()];

            for(Id rpId : projectsOpp.keyset()){
                for(Note n : notes){
                    if(n.ParentId == projectsOpp.get(rpId)){
                        Note nn = new Note();
                        nn.ParentId = rpId;
                        nn.Body = n.Body;
                        nn.Title = n.Title;
                        notesToInsert.add(nn);
                    }
                }
                for(Document__c d : documents){
                    if(d.Opportunity__c == projectsOpp.get(rpId)){
                        d.Residential_Project__c = rpId;
                        documentsToUpdate.add(d);
                    }
                }
            }
        }

        /* Alliance Partner Creation */
        apToInsert = new List<Alliance_Partner__c>();
        // alliance partners for new homes
        if(!communityProject.isEmpty()) {
            for(Alliance_Partner__c ap : [SELECT Id, Role__c, Partner_Account__c, RecordTypeId, Community__c FROM Alliance_Partner__c WHERE Community__c IN: communityProject.keyset()]){
                Alliance_Partner__c nap = new Alliance_Partner__c();
                nap.RecordTypeId = papId;
                nap.Role__c = ap.Role__c;
                nap.Partner_Account__c = ap.Partner_Account__c;
                nap.Residential_Project__c = communityProject.get(ap.Community__c);
                apToInsert.add(nap);
            }
        }

        // alliance partners for indirect & spd
        apRPs = new Map<Id, Residential_Project__c>();
        if(!indirectRPs.isEmpty() || !spdRPs.isEmpty()) {
            for(Residential_Project__c rp : [SELECT Id, Account__r.Partner_Account__c, Installation_Partner__c FROM Residential_Project__c WHERE Id IN :indirectRPs OR Id IN :spdRPs]) {
                apRPs.put(rp.Id, rp);
            }
        }
        addDealerIP(indirectRPs, indirectId);
        addDealerIP(spdRPs, spdId);

        /* Installation Model on Quote */
        // If the installation model is assigned, assign IM on the related Quote
        if(qModelAssignment.size() > 0){
            for(Id qId : qModelAssignment.keyset()){
                Quote q = new Quote();
                q.Id = qId;
                q.Installation_Model__c = qModelAssignment.get(qId);
                quoteModels.add(q);
            }
        }
    }

    public override void finish(Boolean fromStart) {
        if(fromStart) {
            update documentsToUpdate;
            insert notesToInsert;
            insert apToInsert;
            update quoteModels;

            /* TEMPLATE CREATION */
            if(projectSPD.size() > 0){
                // Find User Assignment records
                Map<Id, Map<String,Id>> spdUserAssignment = new Map<Id, Map<String,Id>>();
                if(ipSet.size() > 0) spdUserAssignment = ResidentialProjectUtility.spdUserAssignment(ipSet);
                // Create Template records
                ResidentialProjectUtility.createTemplate(projectSPD, spdUserAssignment);
            }

            if(projectNH.size() > 0){
                // Find User Assignment records
                Map<Id, Map<String,Id>> nhUserAssignment = new Map<Id, Map<String,Id>>();
                if(comSet.size() > 0) nhUserAssignment = ResidentialProjectUtility.nhUserAssignment(comSet);
                // Create Template records
                ResidentialProjectUtility.createTemplate(projectNH, nhUserAssignment);
            }

            // Create Template records
            if(projectTPS.size() > 0) ResidentialProjectUtility.createTemplate(projectTPS, NULL);

            /* Alliance Partner Creation */
            if(projectsIM.size() > 0) ResidentialProjectTPSUtility.createAlliancePartners(projectsIM);
            if(tpsPartner.size() > 0) ResidentialProjectTPSUtility.assignTPSPartner(tpsPartner);

            // create invoice compliance docs
            if(!projectsICD.isEmpty()) {
                InvoiceComplianceDocumentUtility.createInvoiceComplianceDocuments(projectsICD);
            }
        }
        Diagnostics.pop();
    }

    private void addDealerIP(Set<Id> ids, Id rt) {
        for(Id i : ids) {
            // dealer ap
            Alliance_Partner__c dap = new Alliance_Partner__c();
            dap.RecordTypeId = papId;
            dap.Role__c = 'Dealer';
            dap.Residential_Project__c = i;
            dap.Partner_Account__c = apRPs.get(i).Account__r.Partner_Account__c;
            apToInsert.add(dap);
            // ip ap
            Alliance_Partner__c ipap = new Alliance_Partner__c();
            ipap.RecordTypeId = papId;
            ipap.Role__c = 'IP';
            ipap.Residential_Project__c = i;
            ipap.Partner_Account__c = rt == indirectId ? apRPs.get(i).Account__r.Partner_Account__c : rt == spdId ? apRPs.get(i).Installation_Partner__c : null;
            apToInsert.add(ipap);
        }
    }
}