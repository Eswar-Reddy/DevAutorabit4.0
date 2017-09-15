public with sharing class EnergyProductionSummaryController {

	public Design__c record {get;set;}
    public EnergyProductionYr1__c ep {get;set;}
    public Boolean isEditMode {get;set;}

    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public EnergyProductionSummaryController(ApexPages.StandardController stdController) {
        this.record = (Design__c)stdController.getRecord();
        ep = new EnergyProductionYr1__c();
        isEditMode = false;

        for(Design__c d : [SELECT Id, Roof_Design__c FROM Design__c WHERE Id =: record.Id]) {
            record = d;
            break;
        }

        if(record.Roof_Design__c != null) {
            for(EnergyProductionYr1__c e : [SELECT Design__c, Annual__c, Jan__c, Feb__c, Mar__c, Apr__c, 
                                                        May__c, Jun__c, Jul__c, Aug__c, Sep__c, Oct__c, Nov__c, Dec__c 
                                                FROM EnergyProductionYr1__c 
                                                WHERE RoofDesign__c =: record.Roof_Design__c
                                                ORDER BY LastModifiedDate DESC LIMIT 1]) {
                ep = e;
                break;
            }
            if(ep.Id == null) {
                for(EnergyProductionYr1__c e : [SELECT Design__c, Annual__c, Jan__c, Feb__c, Mar__c, Apr__c, 
                                                        May__c, Jun__c, Jul__c, Aug__c, Sep__c, Oct__c, Nov__c, Dec__c 
                                                FROM EnergyProductionYr1__c 
                                                WHERE Design__c =: record.Id
                                                ORDER BY LastModifiedDate DESC LIMIT 1]) {
                    ep = e;
                    break;
                }
            }
        } else {
            for(EnergyProductionYr1__c e : [SELECT Design__c, Annual__c, Jan__c, Feb__c, Mar__c, Apr__c, 
                                                        May__c, Jun__c, Jul__c, Aug__c, Sep__c, Oct__c, Nov__c, Dec__c 
                                                FROM EnergyProductionYr1__c 
                                                WHERE Design__c =: record.Id
                                                ORDER BY LastModifiedDate DESC LIMIT 1]) {
                ep = e;
                break;
            }
        }
    }

    public PageReference save() {
        isEditMode = false;
        if(ep.Design__c == null) {
            ep.Design__c = record.Id;
        }
        upsert ep;
        return Page.EnergyProductionSummary;
    }

    public PageReference edit() {
        isEditMode = true;
        return null;
    }

    public PageReference cancel() {
        isEditMode = false;
        return Page.EnergyProductionSummary;
    }

}