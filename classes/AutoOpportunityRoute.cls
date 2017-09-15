public class AutoOpportunityRoute {
 private static boolean IsLeadConversionContext = false;
  public static boolean isContextOfLeadConversion() {
    System.debug('lead COnvert**'+IsLeadConversionContext);
        return IsLeadConversionContext ;
    }
    
    public static void setContextOfLeadConversion() {
        IsLeadConversionContext = true;
    }

@future (callout=false)
public static void Checkprecedence(ID Oppid){
List<ALR_Metadata__c> Data = new List<ALR_Metadata__c>();
List<Account> Acc = new List<Account>();
Boolean Result;
    Acc = [SELECT id, Name, BillingState, BillingCountry,CurrencyIsoCode,Theater__c from Account where id IN (select AccountId from opportunity where id = :Oppid )];
    
   // ALR_Metadata__c Data = [select Id, OwnerId, IsDeleted, Name, CurrencyIsoCode, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, ConnectionReceivedId, ConnectionSentId, Distance_Radius__c, Precedence10__c, Precedence11__c, Precedence12__c, Precedence13__c, Precedence14__c, Precedence15__c, Precedence16__c, Precedence17__c, Precedence18__c, Precedence19__c, Precedence1__c, Precedence20__c, Precedence2__c, Precedence3__c, Precedence4__c, Precedence5__c, Precedence6__c, Precedence7__c, Precedence8__c, Precedence9__c, Type__c, Country__c, Theatre__c from ALR_Metadata__c where State__c = Acc.BillingState and Type__c = 'Home Owner'];
      //if(ALR_Metadata__c == null)
      if(Acc.size()<1){
          system.debug('Returning no Account');
          return;
      }
      Data = [select Id, OwnerId, IsDeleted, Name, CurrencyIsoCode, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, ConnectionReceivedId, ConnectionSentId, Distance_Radius__c,Distance_Unit__c, Precedence10__c, Precedence11__c, Precedence12__c, Precedence13__c, Precedence14__c, Precedence15__c, Precedence16__c, Precedence17__c, Precedence18__c, Precedence19__c, Precedence1__c, Precedence20__c, Precedence2__c, Precedence3__c, Precedence4__c, Precedence5__c, Precedence6__c, Precedence7__c, Precedence8__c, Precedence9__c, Type__c, Country__c, Theatre__c from ALR_Metadata__c where Theatre__c = :Acc[0].Theater__c AND Country__c = :Acc[0].BillingCountry and State__c = :Acc[0].BillingState and Type__c = 'Home Owner' ];
      if(Data.size() < 1){
          Data = [select Id, OwnerId, IsDeleted, Name, CurrencyIsoCode, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, ConnectionReceivedId, ConnectionSentId, Distance_Radius__c,Distance_Unit__c, Precedence10__c, Precedence11__c, Precedence12__c, Precedence13__c, Precedence14__c, Precedence15__c, Precedence16__c, Precedence17__c, Precedence18__c, Precedence19__c, Precedence1__c, Precedence20__c, Precedence2__c, Precedence3__c, Precedence4__c, Precedence5__c, Precedence6__c, Precedence7__c, Precedence8__c, Precedence9__c, Type__c, Country__c, Theatre__c from ALR_Metadata__c where Theatre__c = :Acc[0].Theater__c AND Country__c = :Acc[0].BillingCountry and State__c = null and Type__c = 'Home Owner' ];
      }
      system.debug('inside Checkprecedence' + Data.size() );
      if(Data.size() > 0){
      
        Result = Checkcriteria(Data[0].Precedence1__c,Data[0],Oppid);
          if (!Result)
            Result = Checkcriteria(Data[0].Precedence2__c,Data[0],Oppid);
          if (!Result)
            Result = Checkcriteria(Data[0].Precedence3__c,Data[0],Oppid);
          if (!Result)
            Result = Checkcriteria(Data[0].Precedence4__c,Data[0],Oppid);
          if (!Result)
            Result = Checkcriteria(Data[0].Precedence5__c,Data[0],Oppid);
          if (!Result)
            Result = Checkcriteria(Data[0].Precedence6__c,Data[0],Oppid);
          if (!Result)
            Result = Checkcriteria(Data[0].Precedence7__c,Data[0],Oppid);
          if (!Result)
            Result = Checkcriteria(Data[0].Precedence8__c,Data[0],Oppid);
          if (!Result)                                                
            Result = Checkcriteria(Data[0].Precedence9__c,Data[0],Oppid);
          if (!Result)
            Result = Checkcriteria(Data[0].Precedence10__c,Data[0],Oppid);
          if (!Result)
            Result = Checkcriteria(Data[0].Precedence11__c,Data[0],Oppid);
          if (!Result)
            Result = Checkcriteria(Data[0].Precedence12__c,Data[0],Oppid);
          if (!Result)
            Result = Checkcriteria(Data[0].Precedence13__c,Data[0],Oppid);
          if (!Result)
            Result = Checkcriteria(Data[0].Precedence14__c,Data[0],Oppid);
          if (!Result)
            Result = Checkcriteria(Data[0].Precedence15__c,Data[0],Oppid);   
          if (!Result)
            Result = Checkcriteria(Data[0].Precedence16__c,Data[0],Oppid);
          if (!Result)
            Result = Checkcriteria(Data[0].Precedence17__c,Data[0],Oppid);
          if (!Result)
            Result = Checkcriteria(Data[0].Precedence18__c,Data[0],Oppid);
          if (!Result)
            Result = Checkcriteria(Data[0].Precedence19__c,Data[0],Oppid);
          if (!Result)
            Result = Checkcriteria(Data[0].Precedence20__c,Data[0],Oppid);
      }else {
          // throw an error if multiple rows are selected
      }
}
public static boolean Checkcriteria(String criteria,ALR_Metadata__c Mdata, ID OpId){
        Boolean rslt = false;
             if(criteria == 'Alliance Lead Random'){
                system.debug('Alliance Random API' );
                rslt = AutoOppRoutAPI.AssignAllianceLeadPartnerRandom(Mdata,OpId);
               // rslt  = Alliancelead.AssignPartner(radius,OpId);
            }
            if(criteria == 'Campaign Lead Random'){
                 system.debug('Campaign Random API' );
                 //rslt = AutoOppRoutAPI.AssignPartnerInDist(radius,OpId);
                  rslt = AutoOppRoutAPI.AssignCampaignLeadPartnerRandom(Mdata,OpId);
            }
            if(criteria == 'Alliance Lead'){
                system.debug('Alliance API' );
                rslt = AutoOppRoutAPI.AssignAllianceLeadPartner(Mdata,OpId);
               // rslt  = Alliancelead.AssignPartner(radius,OpId);
            }
            //added by abhishek on date 02-07-2013
            if(criteria == 'Alliance Lead by Distance'){
                system.debug('Alliance Lead by Distance');
                rslt = AutoOppRoutAPI.AllianceLeadbyDistance(Mdata,OpId);
               // rslt  = Alliancelead.AssignPartner(radius,OpId);
            }
            if(criteria == 'Exclusivity'){
                 system.debug('Exclusivity API' );
                 rslt = AutoOppRoutAPI.AssignExclusivityPartner(Mdata,OpId);
            }
            if(criteria == 'Campaign Lead'){
                 system.debug('Campaign API' );
                 //rslt = AutoOppRoutAPI.AssignPartnerInDist(radius,OpId);
                  rslt = AutoOppRoutAPI.AssignCampaignLeadPartner(Mdata,OpId);
            }
            if(criteria == 'Dealer Locator'){
                system.debug('Dealer API');
                rslt = AutoOppRoutAPI.AssignDealerPartner(Mdata,OpId);
                //rslt = DealerLocatorPartner.dealerPartner(OpId);
            }
            if(criteria == 'Distance'){
                 system.debug('Distance API' );
                rslt = AutoOppRoutAPI.AssignPartnerInDist(Mdata,OpId);
            }
        return rslt;
          
}
}