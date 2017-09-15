trigger UpdateQuotefromLeasePayment on LeasePayment__c (Before Insert, Before Update) 
{
    List<Id> QuoteId = new List<Id>();
    List<Id> LPId = new List<Id>();
    List<Quote> updateQt = new List<Quote>();
    List<Quote> lstQte = new  List<Quote>();
    
    for(LeasePayment__c LP : Trigger.new)
    {
        if(Trigger.isinsert){
            if(LP.Payment_Date_Interconnect__c != null ){
                 QuoteId.add(LP.Quote__c);
                 LPId.add(LP.Id);
            }     
        }
        if(Trigger.isupdate){
          for(LeasePayment__c OLP : Trigger.old){
            if(LP.Payment_Date_Interconnect__c != null && OLP.Payment_Date_Interconnect__c == null ){
                 QuoteId.add(LP.Quote__c);
                 LPId.add(LP.Id);
            } 
          }
        }
    }
    //List<LeasePayment__c> lstLP = [SELECT Id, Payment_Date_Interconnect__c, Quote__c, Quote__r.Trigger_Checkbox__c FROM LeasePayment__c WHERE Id IN : LPId AND Quote__c IN : QuoteId];
    
      //List<Quote> lstQte = [SELECT Id, Send_Lien_Waiver_Agreement__c, Trigger_Checkbox__c, (SELECT Id, Payment_Date_Interconnect__c FROM Lease_Payments__r) FROM Quote WHERE Id IN : QuoteId];
       if(!QuoteId.isempty()){
           lstQte = [SELECT Id, Send_Lien_Waiver_Agreement__c, Trigger_Checkbox__c FROM Quote WHERE Id IN : QuoteId];
       }
       else{
           return;
       }
     // Map<Id,Quote> MapQte = [SELECT Id, Send_Lien_Waiver_Agreement__c, Trigger_Checkbox__c, (SELECT Id, Payment_Date_Interconnect__c FROM Lease_Payments__r) FROM Quote WHERE Id IN : QuoteId];
       
      for(LeasePayment__c LP : Trigger.new){
        for(Quote qt : lstQte ){
            if(Lp.Quote__c == qt.Id){
              qt.Trigger_Checkbox__c = True;
              qt.Send_Lien_Waiver_Agreement__c = True;
              updateQt.add(qt);
            }
       
        }
      }
      
      update updateQt;
      
      
      
      /**
      List<LeasePayment__c> lstLP = lstQte[0].Lease_Payments__r;
      
      if(lstLP[0].Payment_Date_Interconnect__c != Null)
      {
          lstQte[0].Trigger_Checkbox__c = True;
          lstQte[0].Send_Lien_Waiver_Agreement__c = True;
      }
    **/

}