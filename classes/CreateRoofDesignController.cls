//Controller class for CreateRoofDesing visualforce page
public without sharing class CreateRoofDesignController {
    
    public Account acc{get;set;}
    public boolean notesRequired{get;set;}
    public Roof_Design__c roofDesign{get;set;}
	public Boolean IsPartner {get;set;}
    public String action = null;
    public boolean isRequestDesign{get; set;}
    public boolean showExpedited {get; set;}

    public CreateRoofDesignController(ApexPages.StandardController controller) {
        roofDesign = new Roof_Design__c();
        notesRequired = false;
        acc = (Account)controller.getRecord();
		acc = [ SELECT
                Id,
                Name,
                Partner_Account__r.Special_Programs__c
        FROM Account
        WHERE id=:acc.Id];

        if(acc.Partner_Account__r.Special_Programs__c != null &&
                acc.Partner_Account__r.Special_Programs__c.contains('Expedite Design Requests')){
            showExpedited = true;
        }
        else{
            showExpedited = false;
        }
        IsPartner = SPCommunityUtility.isPartnerUser();
        action = apexpages.currentpage().getparameters().get('action');
    }
    
    public PageReference actionRedirect(){

        if(action == 'CreateDesign'){
            return createRoofDesign();
        }else if(action == 'RequestDesign'){
            isRequestDesign = true;
            Id rdMaxFitRecordTypeId = Schema.SObjectType.Roof_Design__c.getRecordTypeInfosByName().get('Residential MaxFit Designs').getRecordTypeId();

            List<Roof_Design__c> rDesignList = new List<Roof_Design__c>([select Id,Status__c,Type__c,Active__c from Roof_Design__c where Account_Name__c=:acc.Id and RecordTypeId=:rdMaxFitRecordTypeId and Active__c = true and Status__c='Completed']);
            System.debug('rDesignList----->'+rDesignList);

            if(!rDesignList.isEmpty()){
                notesRequired = true;
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.WARNING, Label.CompletedDesignWarning) );
            }
            return null;
        }
        else{
            return null;
        }
    }
    
    public PageReference createRoofDesign(){
        CreateRoofDesign.RoofDesign rDesign = CreateRoofDesign.checkandCreateRD(acc.Id, 'CreateDesign', roofDesign);
        if(rDesign.error != null){
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, rDesign.error) );
            return null;
        }  
        else if(rDesign.roofDesignId != null){
            PageReference rdpageRef = new PageReference('/'+rDesign.roofDesignId);
            return rdpageRef;
        }
        else{
            return null;
        }
    }

    public PageReference requestRoofDesign(){
        CreateRoofDesign.RoofDesign rDesign = CreateRoofDesign.checkandCreateRD(acc.Id,'RequestDesign',roofDesign);
        if(rDesign.error != null){
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, rDesign.error) );
            return null;
        }
        else{
            PageReference accpageRef = new PageReference('/'+acc.Id);
            return accpageRef;
        }
    }

}