public with sharing class CHomeController {
    public string userAccountId {get;set;}
    public string currentUserId {get;set;}
    public APPR_PUB__Headline__c b1{get;set;}

    public APPR_PUB__Headline__c s1{get;set;}
    public APPR_PUB__Headline__c s2{get;set;}
    public APPR_PUB__Headline__c s3{get;set;}
    
    public List<APPR_PUB__Headline__c> AllSections;
public List<APPR_PUB__Headline__c> MainSections{get;set;}
    public List<APPR_PUB__Headline__c> TempSections;
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
    public boolean showLPS {get;set;}
    public boolean showDPF {get;set;}
    public boolean showMRC {get;set;}
    public boolean showACC {get;set;}
    
    public string LPSDisplayName {get;set;}
    public string DPFDisplayName {get;set;}
    public string MRCDisplayName {get;set;}
    public string ACCDisplayName {get;set;}
    
    //public string LPSURL {get;set;}
    //public string DPFURL {get;set;}
    //public string MRCURL {get;set;}
    
    Public CHomeController(){
        User portalUser = [SELECT ContactId,Contact.Name, 
                           Contact.AccountId, Profile_Text__c  from User 
                           where id=:Userinfo.getUserId() LIMIT 1];
        userAccountId = portalUser.Contact.AccountId;
        currentUserId = Userinfo.getUserId();
        string ProfileName = portalUser.Profile_Text__c;
        
        
        
        Banners = [select id, name, APPR_PUB__Long_Description__c, APPR_PUB__Image_Path__c, 
                        APPR_PUB__Image_Url__c, APPR_PUB__Tab__c, APPR_PUB__Sort_Order__c, 
                        APPR_PUB__Active__c from APPR_PUB__Headline__c where Section__c = 'Banner' AND 
                        APPR_PUB__Tab__c='CHome' AND APPR_PUB__Active__c = True order by APPR_PUB__Sort_Order__c ASC ];
            if(Banners != null && Banners.size() > 0){
                b1 = Banners[0];                
            }
        TempSections = [select id, name, Display_Name__c, APPR_PUB__Long_Description__c, 
                            APPR_PUB__Image_Path__c, APPR_PUB__Image_Url__c, APPR_PUB__Tab__c,
                            APPR_PUB__Sort_Order__c, APPR_PUB__Active__c from APPR_PUB__Headline__c
                            where APPR_PUB__Sort_Order__c = 1 AND APPR_PUB__Tab__c='CHome' AND 
                            APPR_PUB__Active__c = True limit 1];
        if(TempSections != null && TempSections.size() > 0){
                s1 = TempSections[0];                
            }
        
        system.debug('-------s1-----'+s1);
        system.debug('-------s2-----'+s2);
        system.debug('-------s3-----'+s3);
        system.debug('-------b1-----'+b1);
                
                

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
        MainSections = new list<APPR_PUB__Headline__c>();
        system.debug('-------all --'+AllSections);
        for(APPR_PUB__Headline__c a: AllSections){
            if(a.APPR_PUB__Sort_Order__c == 2){
                s2 = a;
                system.debug('-------sort order 2 ------'+a);
                MainSections.add(a);
            }else if(a.APPR_PUB__Sort_Order__c == 3 ){
                s3 = a;
                system.debug('-------sort order 3 ------'+a);
                MainSections.add(a);
            }else if(a.APPR_PUB__Sort_Order__c == 4){
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
            }else if(a.APPR_PUB__Sort_Order__c == 12){
                s12 = a;
            }else if(a.APPR_PUB__Sort_Order__c == 13){
                s13 = a;
            }else if(a.APPR_PUB__Sort_Order__c == 14){
                s14 = a;
            }else if(a.APPR_PUB__Sort_Order__c == 15){
                s15 = a;
            }else if(a.Section__c == 'Banner'){
                //Banners.add(a);
            }
        }
system.debug('-------MainSections ------'+MainSections);
        
        
        list<APPR_PUB__Headline_Link__c> SSOLinks = [select Name, APPR_PUB__Display_Name__c,APPR_PUB__Active__c, APPR_PUB__URL__c, APPR_PUB__Open_In_New_Window__c, SSO_Active__c from APPR_PUB__Headline_Link__c where SSO_Active__c = True ORDER BY APPR_PUB__Sort_Order__c ASC];
        for(APPR_PUB__Headline_Link__c hl: SSOLinks){
            if(hl.name == 'Lead Performance Score'){
                showLPS = True;
                LPSDisplayName = hl.APPR_PUB__Display_Name__c;
                //LPSURL = h1.APPR_PUB__URL__c;
            }else if(hl.name == 'Dealer Program Fund' ){
                showDPF = True;
                DPFDisplayName = hl.APPR_PUB__Display_Name__c;
                //DPFURL = h1.APPR_PUB__URL__c;
            }else if(hl.name == 'Marketing Resource Center' ){
                showMRC = True;
                MRCDisplayName = hl.APPR_PUB__Display_Name__c;
                //MRCURL = h1.APPR_PUB__URL__c;
            }else if(hl.name == 'My Account' ){
                showACC = True;
                ACCDisplayName = hl.APPR_PUB__Display_Name__c;
                //MRCURL = h1.APPR_PUB__URL__c;
            }
        }
        
        if(profileName =='Partner SSE Installer'){
            showDPF = false;
        }else{
            //showACC = False;
        }
        
        if( (ProfileName == 'Partner Delegated Administrator') || (profileName == 'Partner Executive')  || (profileName == 'System Administrator')){
            showACC = True;
            showLPS = True;
        }else{
            showACC = False;
            showLPS = False;
        }
           

        sr = [SELECT Id,IsActive,Name,NetworkId,Phone,ProfileId,UserRoleId FROM RecentlyViewed WHERE Type IN ('Account','Opportunity') ORDER BY LastViewedDate DESC limit 6];
                //Map<ID, RecentlyViewed> sr_map = new Map<ID, RecentlyViewed>([SELECT Id,IsActive,Name,NetworkId,Phone,ProfileId,UserRoleId FROM RecentlyViewed WHERE Type IN ('Account', 'Opportunity', 'oe_order_headers__c','Warranty_Registration__c','ContentDocument','Purchase_Order__c') ORDER BY LastViewedDate DESC  limit 10]);
                //sr = sr_map.values(); trim Internal links
        


    }
    
      public PageReference redirect(){
    String ProfileName = [SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId()].Name;
    system.debug('SG-Profile NAme='+ ProfileName);
      if(ProfileName.startsWith('EU')) {

            PageReference pageRef = new PageReference('/home/home.jsp');
            return pageRef;
        }
        else{
            return null;
        } 
}

}