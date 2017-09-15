public class CHome {

        public APPR_PUB__Headline__c b1{get;set;}

    public APPR_PUB__Headline__c s1{get;set;}
    public APPR_PUB__Headline__c s2{get;set;}
    public APPR_PUB__Headline__c s3{get;set;}
    
        public List<APPR_PUB__Headline__c> AllSections;
    
        public List<APPR_PUB__Headline__c> Banners;
    

    public APPR_PUB__Headline__c s4{get;set;}
    public APPR_PUB__Headline__c s5{get;set;}
    public APPR_PUB__Headline__c s6{get;set;}
    public APPR_PUB__Headline__c s7{get;set;}
    
    public list<RecentlyViewed> sr{get;set;}
    
        public APPR_PUB__Headline__c s8{get;set;}
    public APPR_PUB__Headline__c s9{get;set;}
    public APPR_PUB__Headline__c s10{get;set;}
    public APPR_PUB__Headline__c s11{get;set;}
  
    public APPR_PUB__Headline__c s12{get;set;}
    public APPR_PUB__Headline__c s13{get;set;}
    public APPR_PUB__Headline__c s14{get;set;}
    public APPR_PUB__Headline__c s15{get;set;}
    
    
        public APPR_PUB__Headline__c s16{get;set;}
    
    Public CHome(){
                Banners = [select id, name, APPR_PUB__Long_Description__c, APPR_PUB__Image_Path__c, APPR_PUB__Image_Url__c, APPR_PUB__Tab__c, APPR_PUB__Sort_Order__c from APPR_PUB__Headline__c where Section__c = 'Banner' AND APPR_PUB__Tab__c='CHome' order by APPR_PUB__Sort_Order__c ASC ];
        b1 = Banners[0];                

        s1 = [select id, name, APPR_PUB__Long_Description__c, APPR_PUB__Image_Path__c, APPR_PUB__Image_Url__c, APPR_PUB__Tab__c, APPR_PUB__Sort_Order__c from APPR_PUB__Headline__c where APPR_PUB__Sort_Order__c = 1 AND APPR_PUB__Tab__c='CHome' limit 1];
        s2 = [select id, name, APPR_PUB__Long_Description__c, APPR_PUB__Image_Path__c, APPR_PUB__Image_Url__c, APPR_PUB__Tab__c, APPR_PUB__Sort_Order__c, (select APPR_PUB__Display_Name__c, APPR_PUB__URL__c, APPR_PUB__Open_In_New_Window__c from APPR_PUB__Headline_Links__r ORDER BY APPR_PUB__Sort_Order__c ASC) from APPR_PUB__Headline__c where APPR_PUB__Sort_Order__c = 2 AND APPR_PUB__Tab__c='CHome' limit 1];
        s3 = [select id, name, APPR_PUB__Long_Description__c, APPR_PUB__Image_Path__c, APPR_PUB__Image_Url__c, APPR_PUB__Tab__c, APPR_PUB__Sort_Order__c, (select APPR_PUB__Display_Name__c, APPR_PUB__URL__c, APPR_PUB__Open_In_New_Window__c from APPR_PUB__Headline_Links__r ORDER BY APPR_PUB__Sort_Order__c ASC) from APPR_PUB__Headline__c where APPR_PUB__Sort_Order__c = 3 AND APPR_PUB__Tab__c='CHome' limit 1];

                AllSections = [select id, name, APPR_PUB__Tab__c, APPR_PUB__Sort_Order__c, Section__c, (select APPR_PUB__Display_Name__c, APPR_PUB__URL__c, APPR_PUB__Open_In_New_Window__c from APPR_PUB__Headline_Links__r ORDER BY APPR_PUB__Sort_Order__c ASC) from APPR_PUB__Headline__c where APPR_PUB__Tab__c='CHome'];
        for(APPR_PUB__Headline__c a: AllSections){
            if(a.APPR_PUB__Sort_Order__c == 4){
                s4 = a;
            }else if(a.APPR_PUB__Sort_Order__c == 5 ){
                s5 = a;
            }else if(a.APPR_PUB__Sort_Order__c == 6){
                s6 = a;
            }else if(a.APPR_PUB__Sort_Order__c == 7){
                s7 = a;
            }else if(a.APPR_PUB__Sort_Order__c == 8){
                s8 = a;
            }else if(a.APPR_PUB__Sort_Order__c == 9 ){
                s9 = a;
            }else if(a.APPR_PUB__Sort_Order__c == 10){
                s10 = a;
            }else if(a.APPR_PUB__Sort_Order__c == 11){
                s11 = a;
            }else if(a.Section__c == 'Banner'){
                //Banners.add(a);
            }
        }
        
        
        //sr = [SELECT Id,IsActive,Name,NetworkId,Phone,ProfileId,UserRoleId FROM RecentlyViewed WHERE Type IN ('Account','Opportunity', 'oe_order_headers__c','Warranty_Registration__c','ContentDocument') ORDER BY LastViewedDate DESC  limit 6];
        //        Map<ID, RecentlyViewed> sr_map = new Map<ID, RecentlyViewed>([SELECT Id,IsActive,Name,NetworkId,Phone,ProfileId,UserRoleId FROM RecentlyViewed WHERE Type IN ('Account', 'Opportunity', 'oe_order_headers__c','Warranty_Registration__c','ContentDocument') ORDER BY LastViewedDate DESC  limit 10]);
                
                //sr = sr_map.values();
        


    }
    
    Public List<Opportunity> optyList {get;set;}
 Public List<contact> conList{get;set;}
 Public List<account> accList{get;set;}
  
 Public String searchStr{get;set;}
   
  
  Public void soslDemo_method(){
   optyList = New List<Opportunity>();
   conList = New List<contact>();
   accList = New List<account>();
   if(searchStr.length() > 1){
   String searchStr1 = '*'+searchStr+'*';
   String searchQuery = 'FIND \'' + searchStr1 + '\' IN ALL FIELDS RETURNING  Account (Id,Name,type LIMIT 5),Contact(name,email LIMIT 5),Opportunity(name,StageName LIMIT 5)';
   List<List <sObject>> searchList = search.query(searchQuery);
   accList = ((List<Account>)searchList[0]);
   conList  = ((List<contact>)searchList[1]);
   optyList = ((List<Opportunity>)searchList[2]);
   if(accList.size() == 0 && conList.size() == 0 && optyList.size() == 0){
       apexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'Sory, no results returned with matching string..'));
       return;
   }
   }
   else{
   apexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'Please enter at least two characters..'));
   return;
   }
  }

}