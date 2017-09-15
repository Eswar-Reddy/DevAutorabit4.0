public with sharing class ReportsListController{
    public List<Report> reportData = new List<Report>();
    public String folderName;
    
   public List<APPR_PUB__Headline__c> AllSections;
   public APPR_PUB__Headline__c s4{get;set;}
   public APPR_PUB__Headline__c s5{get;set;}
   public APPR_PUB__Headline__c s6{get;set;}
   public APPR_PUB__Headline__c s7{get;set;}
   
    public ReportsListController(){
       AllSections = [select id, name, Display_Name__c,
                              APPR_PUB__Tab__c, APPR_PUB__Image_Path__c,
                              APPR_PUB__Long_Description__c,
                              APPR_PUB__Sort_Order__c, Section__c,
                              APPR_PUB__Active__c,
                                  (select APPR_PUB__Display_Name__c,
                                   APPR_PUB__Active__c, APPR_PUB__URL__c,
                                   APPR_PUB__Open_In_New_Window__c,
                                   SSO_Active__c from APPR_PUB__Headline_Links__r
                                   where APPR_PUB__Active__c = True AND SSO_Active__c = False
                                   ORDER BY APPR_PUB__Sort_Order__c ASC)
                              from APPR_PUB__Headline__c where APPR_PUB__Tab__c='CHome'
                                   AND APPR_PUB__Active__c = True
                              ORDER BY APPR_PUB__Sort_Order__c ASC];
      
       system.debug('-------all --'+AllSections);
       for(APPR_PUB__Headline__c a: AllSections){
           if(a.APPR_PUB__Sort_Order__c == 4){
               s4 = a;
           }else if(a.APPR_PUB__Sort_Order__c == 5 ){
               s5 = a;
           }else if(a.APPR_PUB__Sort_Order__c == 6){
               s6 = a;
           }else if(a.APPR_PUB__Sort_Order__c == 7){
               s7 = a;
           }else{
            }
       }
    
    }
    
    public List<Report> getreportData(){
    
        folder[] ff = [select id from folder where developername = 'Report_Dashboard_Community_Tab'];
        if(!ff.isEmpty()){
            folderName = ff[0].id;
            report[] rpts = [select id, name, description from report where ownerid = : folderName and ownerid != null order by name];
            return rpts;
        }else{
            return reportData;
        }

    }
}