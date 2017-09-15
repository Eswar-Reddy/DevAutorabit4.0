public class OpportunityPatnerAccountController {
    
  public String oppID {get; set;}
  public String oppPer {get; set;}
  public Opportunity OppObj {
    get {
      System.debug('Debug: oppId ' + oppId);
      
      if (OppObj != null) {
        return OppObj;
      }
      
      if (oppId != null && oppId != '') {
        OppObj = [Select Account.Name, PartnerAccount.Website, PartnerAccount.Phone, PartnerAccount.Name, PartnerAccount.BillingStreet, PartnerAccount.BillingCity, PartnerAccount.BillingPostalCode, PartnerAccount.BillingState, PartnerAccount.BillingCountry from Opportunity o Where Id = :oppId];
       
      }
      
      return OppObj;
    }
    set;
  }

}