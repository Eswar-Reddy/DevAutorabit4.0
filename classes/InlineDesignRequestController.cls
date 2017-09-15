public with sharing class InlineDesignRequestController {

  private final Opportunity record;
  public boolean auroraUser {
    get {
      if(auroraUser == null) {
        auroraUser = false;
      }
      return auroraUser;
    }
    set;
  }
  
  @TestVisible
  List<Site_Information_Form__c> siteList {
        get {
            if(siteList == null) {
                siteList = new List<Site_Information_Form__c>();
            }
            return siteList;
        }
        set;
    }
    public Map<String, Site_Information_Form__c> siteInfoMap {get;set;}
    public Map<String, List<Design__c>> siteToDesignMap {get;set;}
    public Map<String, Boolean> siteToRevisionMap {get;set;}

    //Constructor
    public InlineDesignRequestController(ApexPages.StandardController stdController) {
        // init
        siteToDesignMap = new Map<String, List<Design__c>>();
        siteInfoMap = new Map<String, Site_Information_Form__c>();
        Set<Id> siteIds = new Set<Id>();
        siteToRevisionMap = new Map<String, Boolean>();
        
        this.record = (Opportunity)stdController.getRecord();
        String partnerAccount = '';
        
        User currentUser = [SELECT Business_Function__c, AccountId FROM User WHERE Id =: UserInfo.getUserId()];
        Account partner_Acct = [SELECT Design_Tool_Organization_Id__c FROM Account WHERE Id =: currentUser.AccountId];
        String functions = currentUser.Business_Function__c;        
        boolean hasAuroraTenantId = false;
        
        if (partner_Acct == null) {
            hasAuroraTenantId = true;            
        } else if (partner_Acct.Design_Tool_Organization_Id__c != null) {
            hasAuroraTenantId = true;
        }
        
        if(String.isNotBlank(functions)) {
          if(functions.containsIgnoreCase('Commercial Aurora Design Licensee') && hasAuroraTenantId)
            auroraUser = true;
        } else {
          auroraUser = false;
        }

        for(Opportunity o : [SELECT Id, PartnerAccountId, AccountId,
                                    (SELECT Id, Name, Site_Name__c, Account__c, Site_Address__c,
                            Site_City__c,
                            Site_State__c,
                            Site_Country__c,
                            Site_Zip_Postal_Code__c,
                                            Opportunity_del__c, Opportunity_del__r.AccountId  
                                     FROM R00N30000000t6dPEAQ__r) 
                             FROM Opportunity WHERE Id =: record.Id LIMIT 1]) {
            partnerAccount = o.PartnerAccountId;

            for(Site_Information_Form__c s : o.R00N30000000t6dPEAQ__r) {
                siteToDesignMap.put(s.Name, new List<Design__c>());
                siteToRevisionMap.put(s.Name, false);
                siteInfoMap.put(s.Name, s);
                siteIds.add(s.Id);
            }
        }

        for(Design__c d : [SELECT Id, Name, Export_Status__c,
                            Actual_System_Size__c,
                            Dealer_Status__c, 
                            Design_Package_Type__c, 
                            Design_Originated_By__c,
                            Roof_Design__r.Design_DesignId__c, 
                            Final_Design__c,
                            Site__r.Name, Step_Number__c,
                            Site__r.Opportunity_del__r.Partner_Account_id__r.name, Site__c,                             
                            Site__r.Site_Name__c,                             
                            Submitted__c, HelixDesignType__c
                           FROM Design__c
                           WHERE Site__c IN: siteIds
                           AND DealerName__c != null
                           AND DealerName__c =: partnerAccount
                           AND ((Design_Originated_By__c = 'Indirect' AND Roof_Design__c != null)
                              OR Design_Originated_By__c = 'Request')
                           ORDER BY CreatedDate DESC]) {
            siteToDesignMap.get(d.Site__r.Name).add(d);            
            if (d.Dealer_Status__c == 'Design Delivered' || (d.Dealer_Status__c == 'Design Exported' && d.Submitted__c == false)) {
                siteToRevisionMap.put(d.Site__r.Name, true);
            }
        }
    } //End Constructor

}