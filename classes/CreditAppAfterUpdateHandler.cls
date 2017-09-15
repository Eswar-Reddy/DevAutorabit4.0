global  class  CreditAppAfterUpdateHandler {
    private List< Credit_Check_Request__c > newList;
    public CreditAppAfterUpdateHandler() {
        System.debug('Ravi Debug');
    }
    
    @future(callout=true)
    public static void callLoanPath(ID cca){
            Credit_Check_Request__c ccr = [Select id,Email_Counter__c, Name,Opportunity__c from Credit_Check_Request__c where id = :cca];
              Boolean isNewHomes = false;
              Opportunity opp = new Opportunity();
              String result_status = '';
              String partnerUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/services/Soap/u/22.0/' + UserInfo.getOrganizationId();
              User user = [SELECT id, country_domain__c, name FROM User WHERE id=:UserInfo.getUserId()];

              opp = [select Id,CampaignId from Opportunity where id = :ccr.Opportunity__c LIMIT 1];
              Campaign camp = new Campaign();
              if(opp.id != null && opp.CampaignId != null){
                  system.debug('opp');
                  camp = [select Id,NH_Community__c from Campaign where id =: opp.CampaignId];
                  if(camp.id != null && camp.NH_Community__c != null){
                      system.debug('camp');
                     isNewHomes = true; 
                  }
              }
              system.debug('Debug1:'+ccr.Email_Counter__c+isNewHomes+PartnerUrl);
              if(isNewHomes){
                  result_status = TPSSF.TPConnectorService.SubmitExt(
                                                     'Credit_Check_Request__c',
                                                      cca,
                                                       '' ,
                                                       '' ,
                                                      'save',
                                                      '' ,
                                                      '',
                                                      UserInfo.getUserId(),
                                                      UserInfo.getSessionId(),
                                                      PartnerUrl, 
                                                      UserInfo.getUserName(), 
                                                      'ReSendEmail',
                                                      user.country_domain__c.substring(user.country_domain__c.indexOf('-')+1),
                                                      'NewHome,true');
               }
               else{
                   result_status = TPSSF.TPConnectorService.SubmitExt(
                                                     'Credit_Check_Request__c',
                                                      cca,
                                                       '' ,
                                                       '' ,
                                                      'save',
                                                      '' ,
                                                      '',
                                                      UserInfo.getUserId(),
                                                      UserInfo.getSessionId(),
                                                      PartnerUrl, 
                                                      UserInfo.getUserName(), 
                                                      'ReSendEmail',
                                                      user.country_domain__c.substring(user.country_domain__c.indexOf('-')+1),
                                                      'NewHome,false');
               }
                    
      }                               
    
    
}