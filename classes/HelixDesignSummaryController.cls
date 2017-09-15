public with sharing class HelixDesignSummaryController {

    public Design__c design {get;set;}
    public transient EnergyProductionYr1__c energyOutput {get;set;}
    public transient List<Document__c> documents {get;set;}
    public transient List<Attachment> atts {get;set;}
    public String imageDisplayURL {get;set;}
    public Boolean useVFMap {get;set;}
    public String addressString {get;set;}
    
    @TestVisible private String pngURL, mapURL;

    public HelixDesignSummaryController(ApexPages.StandardController stdController) {
        //init
        documents = new List<Document__c>();
        atts = new List<Attachment>();
        imageDisplayURL = '';
        useVFMap = false;

        design = getDesign(stdController.getId());
		addressString = design.Site__r.Site_Address__c + ', ' + design.Site__r.Site_City__c + ', ' + design.Site__r.Site_State__c;
        Set<Id> documentIds = new Set<Id>();
        if(design.Documents__r != null && design.Documents__r.size() > 0) {
            for(Document__c d : design.Documents__r) {
                if(d.Bucket_Name__c != null) {
                    documents.add(d);
                    if(String.isBlank(pngURL) && d.Content_Type__c == 'application/png') {
                        pngURL = 'https://'+d.Bucket_Name__c+'.s3.amazonaws.com/'+d.File_Name__c;
                    }
                } else {
                    documentIds.add(d.Id);                    
                }
            }
        }
        //build URL string if needed
        if(String.isBlank(pngURL)) {
           // mapURL = getGoogleMapURL(design);
           useVFMap = true;
        }
        
        if (String.IsNotBlank(pngURL)) {
            imageDisplayURL = pngURL;
        } else {
           // imageDisplayURL = mapURL;
           useVFMap = true;
        }

        atts = getAttachments(documentIds, design.Id);
        energyOutput = getEnergyProduction(design.Roof_Design__c);
    }
    
    /*private static String getGoogleMapURL(Design__c design) {
        String mapUrl;

        List<String> arrayParams = new String[]{design.Site__r.Site_Address__c, design.Site__r.Site_City__c, design.Site__r.Site_State__c};
        String temp = 'https://maps.googleapis.com/maps/api/staticmap?center={0} {1}, {2}&zoom=17&size=600x400&scale=2&maptype=hybrid&key=AIzaSyDlMho2gSPS8vhquCCtSKwv1p9dckBKQLQ';//&key=KqPvcbeFBeskJcQubr-9U-s3-N4=
        String temp2 = String.format(temp, arrayParams);
        mapUrl = temp2.replaceAll(' ', '%20');//EncodingUtil.urlEncode(temp2, 'UTF-8');
        
        return mapUrl;
    }*/
    
    private static List <Attachment> getAttachments(Set <Id> parentIdSet, Id dId) {
        return [SELECT Id, Name, CreatedDate 
                FROM Attachment 
                WHERE ((ParentId IN :parentIdSet) OR 
                       (Name = '8760.csv' AND ParentId =: dId))
                ORDER BY CreatedDate DESC ];
    }
    
    private static EnergyProductionYr1__c getEnergyProduction(String roofDesignId) {
        EnergyProductionYr1__c ep = new EnergyProductionYr1__c();

        List <EnergyProductionYr1__c> epList = [SELECT Jan__c, Feb__c, Mar__c, Apr__c, May__c, Jun__c, Jul__c,
                Aug__c, Sep__c, Oct__c, Nov__c, Dec__c 
            FROM EnergyProductionYr1__c 
            WHERE RoofDesign__c = :roofDesignId 
            ORDER BY CreatedDate DESC 
            LIMIT 1];
        if (epList != null && epList.size() > 0) {
            ep = epList[0];
        } 
           
        return ep;    
    }
    
    private static Design__c getDesign(String designId) {
        Design__c design = new Design__c();

        List <Design__c> designList = [SELECT Id, 
            Actual_Annual_Production__c, 
            Actual_System_Size__c, 
            Design_Package_Type__c, 
            HelixDesignType__c, 
            Module_Quantity__c,
            Module_Type__c, 
            Site__r.Opportunity_del__c, 
            Site__r.Site_Address__c, 
            Site__r.Site_City__c, 
            Site__r.Site_State__c, 
            Site__r.Site_Zip_Postal_Code__c, 
            Roof_Design__c, 
            (SELECT Id, 
                Bucket_Name__c, 
                Content_Type__c, 
                CreatedDate,  
                Design__c,
                Document_Link__c, 
                File_Name__c 
            FROM Documents__r ORDER BY CreatedDate DESC)
        FROM Design__c WHERE Id = :designId];
    
        if (designList.size() > 0) {
            design = designList[0];
        }
        
        return design;    
    }

}