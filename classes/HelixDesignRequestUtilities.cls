global with sharing class HelixDesignRequestUtilities {

    public transient Map<Decimal, APPR_PUB__Headline__c> headlines {get;set;}
    @TestVisible private final String none = '--None--';

    //Select Options//
    public List<SelectOption> gcrOptions {
        get {
            if(gcrOptions == null) {
                gcrOptions = new List<SelectOption>();
                gcrOptions.add(new SelectOption('', none));
                for(Schema.PicklistEntry p : Design__c.GCR_Requirement__c.getDescribe().getPicklistValues()) {
                    gcrOptions.add(new SelectOption(p.getValue(), p.getLabel()));
                }
            }
            return gcrOptions;
        }
        set;
    }
    public List<SelectOption> roofTypeOptions {
        get {
            if(roofTypeOptions == null) {
                roofTypeOptions = new List<SelectOption>();
                roofTypeOptions.add(new SelectOption('', none));
                for(Schema.PicklistEntry p : Roof_Details__c.Roof_Type__c.getDescribe().getPicklistValues()) {
                    roofTypeOptions.add(new SelectOption(p.getValue(), p.getLabel()));
                }
            }
            return roofTypeOptions;
        }
        set;
    }
    public List<SelectOption> roofMembraneOptions {
        get {
            if(roofMembraneOptions == null) {
                roofMembraneOptions = new List<SelectOption>();
                roofMembraneOptions.add(new SelectOption('', none));
                for(Schema.PicklistEntry p : Roof_Details__c.Roof_Membrane__c.getDescribe().getPicklistValues()) {
                    roofMembraneOptions.add(new SelectOption(p.getValue(), p.getLabel()));
                }
            }
            return roofMembraneOptions;
        }
        set;
    }
    public List<SelectOption> airBarrierOptions {
        get {
            if(airBarrierOptions == null) {
                airBarrierOptions = new List<SelectOption>();
                airBarrierOptions.add(new SelectOption('', none));
                for(Schema.PicklistEntry p : Roof_Details__c.Functional_Air_Barrier__c.getDescribe().getPicklistValues()) {
                    airBarrierOptions.add(new SelectOption(p.getValue(), p.getLabel()));
                }
            }
            return airBarrierOptions;
        }
        set;
    }


    public HelixDesignRequestUtilities (ApexPages.StandardController controller) {
        headlines = new Map<Decimal, APPR_PUB__Headline__c>();

        for(APPR_PUB__Headline__c headline : [SELECT Id, Name, Display_Name__c, 
                                                     APPR_PUB__Long_Description__c, 
                                                     APPR_PUB__Image_Path__c, 
                                                     APPR_PUB__Image_Url__c, 
                                                     APPR_PUB__Tab__c,
                                                     APPR_PUB__Sort_Order__c, 
                                                     APPR_PUB__Active__c 
                                              FROM APPR_PUB__Headline__c
                                              WHERE APPR_PUB__Tab__c = 'DesignRequestForm' 
                                              AND APPR_PUB__Active__c = True]) {
            headlines.put(headline.APPR_PUB__Sort_Order__c, headline);
        }
    }


    /* Remote Action Methods:
    * fetchDesignDocuments() - get the attachments for the design record being referenced 
    *  createNewSite(String siteJSON) - creates new site from JSON payload/JS google map
    * 
    * 
    */

    @RemoteAction
    global static ResultMessage createNewSite(String siteJSON) { //TODO: 

        System.debug('JSON: ' + siteJSON);
        ResultMessage result = new ResultMessage();
        result.success = false;
        result.payloadMap.put('newsite', '');

        try {
            Site_Information_Form__c site = (Site_Information_Form__c)JSON.deserializeStrict(siteJSON, Site_Information_Form__c.class);
            //site.OwnerId = UserInfo.getUserId();  KM_07142017: removing OwnerId field as Opportunity_del__c type was changed to Master-Detail
            site.RecordTypeId = SFDCSpecialUtilities.getRecordTypeIdsByDeveloperName(Site_Information_Form__c.sObjectType).get('Standard_Site');
            site.Account__c = [SELECT AccountId FROM Opportunity WHERE Id =: site.Opportunity_del__c].AccountId;
            insert site;
            result.success = true;
            result.payloadMap.put('newsite', site);
        } catch(Exception e) {
            result.payloadMap.put('error', e.getMessage());
        }
        return result;
    }



    @RemoteAction
    global static ResultMessage fetchDesignDocuments(String designId) {


        String deliveredStatus = 'Design Delivered';
        ResultMessage result = new ResultMessage();
        result.success = true;

        try {
            Design__c des = [SELECT Id, Dealer_Status__c FROM Design__c WHERE Id =: designId];

            result.payloadMap.put('attachments', new List<Attachment>());

            Set<String> docIds = new Set<String>(); 
            for(Document__c d : [SELECT Id, Document_Type__c, CreatedBy.UserType FROM Document__c WHERE Design__c =: designId]) {
                
                if(des.Dealer_Status__c == deliveredStatus && d.Document_Type__c == 'Commercial Design Deliverables')
                    docIds.add(d.Id);
                else {
                    if(d.CreatedBy.UserType == 'PowerPartner')
                        docIds.add(d.Id);
                }
            }
            if(docIds.isEmpty()) {
                return result;
            } else {    
                result.payloadMap.put('attachments', [SELECT Id, Name, ContentType, ParentId, Parent.Name 
                                                      FROM Attachment 
                                                      WHERE ParentId IN: docIds]);                   
                return result;
            }
        } catch(Exception e) {
            result.success = false;
            result.payload.add(e);
        }

        return result;
    }

    public String docIdToDelete {get;set;}
    public PageReference deleteDesignDocuments() {
        System.debug('docIdToDelete: ' + docIdToDelete);

        try {
            delete [SELECT Id FROM Document__c WHERE Id =: docIdToDelete];
        } catch(Exception e) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(msg);
            System.debug('MSG ERROR DELETE: ' + e);
        }
        return null;
    }
    
}