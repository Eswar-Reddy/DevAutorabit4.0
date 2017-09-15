public class CampPartnerClone {

    public CampPartnerClone(ApexPages.StandardController controller) {
     
    
    //:ApexPages.currentPage().getParameters().get('Id')];

    }
    
    public PageReference CloneCamp(){
        Campaign OrigCamp = [select id, Name from campaign where id = :ApexPages.currentPage().getParameters().get('Id')];
        Campaign CloneCamp = OrigCamp.clone(false,true);
        insert CloneCamp ;
        
       
        // copy over the campaign Partners 
             List<Campaign_Partner__c> CampPartners = [SELECT Name, CurrencyIsoCode,  Campaign__c, Disable_Date__c, Enable_Date__c, Enabled__c, Partner__c, Opportunity_Roll_Up__c from Campaign_Partner__c where Campaign__c = :ApexPages.currentPage().getParameters().get('Id')];
              List<Campaign_Partner__c> CampPartnersNew = new List<Campaign_Partner__c>();
             
             for (Campaign_Partner__c CP : CampPartners) {
                  Campaign_Partner__c newCP = CP.clone(false,true);
                  newCP.Campaign__c = CloneCamp.id;
                  CampPartnersNew.add(newCP);
             }
             insert CampPartnersNew;
        
        return new PageReference('/'+CloneCamp.id+'/e?retURL=%2F'+CloneCamp.id);
        // return null;
    }

}