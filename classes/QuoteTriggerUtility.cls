/* **************************************************************************************
* Class Name     : QuoteBeforeInsertUtility
* Version        : 1.0
* Created Date   : 12 Aug 2015
* Function       : Class to accomodate all the functionalities for QuoteBeforeInsert.

* Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
* Ankit                        12 Aug 2015          Original Version
*************************************************************************************/

public class QuoteTriggerUtility {

 static Boolean hasRun = false;
 

/*
@Name        :  UpdateLineItems
@description :  Update the Opportunity Line items 
@parameters  :  List <Quote> lQuote
*/

public static void UpdateLineItems (List<Quote> lstQuote){
   for(integer i=0;i < lstQuote.size();i++){
        lstQuote[i].LineItemsFromOpp__c=true;
    }
}

/*
@Name        :  UpdateQuoteInverterValues
@description :  Update the Inveter Brand , Model and Qunatity on Quote
@parameters  :  List <Quote> lQuote
*/

public static void UpdateQuoteInverterValues (List<Quote> lstQuote){
   for(Quote qot : lstQuote){
    
    Map<String, Integer> mapInvVals = new Map<String, Integer>();
    if(qot.Inverter_Brand__c != null && qot.Inverter_Model__c != null &&  (qot.Inverter_Quantity__c != null && qot.Inverter_Quantity__c > 0))
    {
      if(mapInvVals.containsKey(qot.Inverter_Brand__c + '-' + qot.Inverter_Model__c))
        mapInvVals.put(qot.Inverter_Brand__c + '-' + qot.Inverter_Model__c, mapInvVals.get(qot.Inverter_Brand__c + '-' + qot.Inverter_Model__c) + Integer.valueOf(qot.Inverter_Quantity__c));
      else
        mapInvVals.put(qot.Inverter_Brand__c + '-' + qot.Inverter_Model__c, Integer.valueOf(qot.Inverter_Quantity__c));    
    }
    if(qot.Inverter_Brand_2__c != null && qot.Inverter_Model_2__c != null &&  (qot.Inverter_Quantity_2__c != null && qot.Inverter_Quantity_2__c > 0))
    {
      if(mapInvVals.containsKey(qot.Inverter_Brand_2__c + '-' + qot.Inverter_Model_2__c))
        mapInvVals.put(qot.Inverter_Brand_2__c + '-' + qot.Inverter_Model_2__c, mapInvVals.get(qot.Inverter_Brand_2__c + '-' + qot.Inverter_Model_2__c) + Integer.valueOf(qot.Inverter_Quantity_2__c));
      else
        mapInvVals.put(qot.Inverter_Brand_2__c + '-' + qot.Inverter_Model_2__c, Integer.valueOf(qot.Inverter_Quantity_2__c));      
    }
    if(qot.Inverter_Brand_3__c != null && qot.Inverter_Model_3__c != null &&  (qot.Inverter_Quantity_3__c != null && qot.Inverter_Quantity_3__c > 0))
    {
      if(mapInvVals.containsKey(qot.Inverter_Brand_3__c + '-' + qot.Inverter_Model_3__c))
        mapInvVals.put(qot.Inverter_Brand_3__c + '-' + qot.Inverter_Model_3__c, mapInvVals.get(qot.Inverter_Brand_3__c + '-' + qot.Inverter_Model_3__c) + Integer.valueOf(qot.Inverter_Quantity_3__c));
      else
        mapInvVals.put(qot.Inverter_Brand_3__c + '-' + qot.Inverter_Model_3__c, Integer.valueOf(qot.Inverter_Quantity_3__c));      
    }
    if(qot.Inverter_Brand_4__c != null && qot.Inverter_Model_4__c != null &&  (qot.Inverter_Quantity_4__c != null && qot.Inverter_Quantity_4__c > 0))
    {
      if(mapInvVals.containsKey(qot.Inverter_Brand_4__c + '-' + qot.Inverter_Model_4__c))
        mapInvVals.put(qot.Inverter_Brand_4__c + '-' + qot.Inverter_Model_4__c, mapInvVals.get(qot.Inverter_Brand_4__c + '-' + qot.Inverter_Model_4__c) + Integer.valueOf(qot.Inverter_Quantity_4__c));
      else
        mapInvVals.put(qot.Inverter_Brand_4__c + '-' + qot.Inverter_Model_4__c, Integer.valueOf(qot.Inverter_Quantity_4__c));      
    }
    if(!mapInvVals.isEmpty())
    {
      qot.Quote_Inverter_Values__c = '';
      for(String str : mapInvVals.keySet())
       qot.Quote_Inverter_Values__c = qot.Quote_Inverter_Values__c + str + '(' + String.valueOf(mapInvVals.get(str)) + '), ';
       
      qot.Quote_Inverter_Values__c = qot.Quote_Inverter_Values__c.substring(0, qot.Quote_Inverter_Values__c.length() -2); 
    }   
 }

}

/*
@Name        :  UpdateQuoteSystemModelField
@description :  Update System Model on Quote.
@parameters  :  List <Quote> lQuote
*/

public static void UpdateQuoteSystemModelField (List<Quote> lstQuote){
    for(Quote qt : lstQuote){
       qt.System_Model__c  = qt.Copy_SM_Before_Lock__c;     
     }
}

/*
@Name        :  CreatePurchaseOrderandPurchaseOrderLine
@description :  Create PO and FPO 
@parameters  :  List <Quote> lQuote
*/

public static void CreatePurchaseOrderandPurchaseOrderLine(List<ID> lstQIDs){
        System.debug('$$$'+lstQIDs.Size());
        if(!lstQIDs.isEmpty()){
            UtilQuote obj=new UtilQuote();
            obj.CreatePOLines(lstQIDs);        
         }
    }

/*
@Name        :  updateOppStage
@description :  Update the Opportunity stage,business and RLC 
@parameters  :  List <Quote> lQuote
*/

public static void updateOppStage (List<Quote> lstQuote){
      List<Opportunity> oppToUpdate = new List<Opportunity>();
      for (Quote Q : lstQuote){
         oppToUpdate.add(new Opportunity(Id = Q.Opportunity_ID__c, Lease__c = TRUE,StageName = 'Contract Signed',Business_Unit__c ='RLC',RLC_Type__c = 'Residential'));    
      }
     if(!hasRun && !oppToUpdate.isEmpty()) {
        Update oppToUpdate;
        hasRun = true;
      }  
  }

/*
@Name        :  QuoteforAgreement
@description :  Update the Opportunity stage,business and RLC 
@parameters  :  List <Quote> lQuote
*/  
  public static void QuoteforAgreement(List<Quote> lstQuote){
      List<Id> lstOppIds = new List<Id>();  
     List<Id> lstAcctIds = new List<Id>();  
     Map<Id, String> mapSEmail = new Map<Id, String>();
     Map<Id, String> mapAccCountry = new Map<Id, String>();   //New Code -- Sunpower TPO Phase 1 -- 20/10/2013
      for(Quote qot : lstQuote)
        lstOppIds.add(qot.OpportunityId);
    
      Map<Id,Opportunity> mOpp = new Map<Id,Opportunity>([SELECT id, AccountId FROM Opportunity WHERE id IN : lstOppIds]);
      for( Opportunity a : mOpp.values())
        lstAcctIds.add(a.AccountId);    

      Map<Id, Account> mAcc = new Map<Id, Account>([SELECT id,Orc_Vend_Email_Formula__c,BillingCountry,   //Modified Code -- Sunpower TPO Phase 1 -- 20/10/2013
                                                       (SELECT id, Name, 
                                                               Primary__c, 
                                                               Include_in_Lease_Doc__c 
                                                        FROM Contacts
                                                        WHERE Include_in_Lease_Doc__c = true 
                                                        ORDER BY Primary__c DESC, CreatedDate ASC) 
                                               FROM Account where ID IN: lstAcctIds  ]);
      for(Account a : mAcc.values()){   
        mapSEmail.put(a.Id, a.Orc_Vend_Email_Formula__c) ; 
        mapAccCountry.put(a.Id, a.BillingCountry) ;    //New Code -- Sunpower TPO Phase 1 -- 20/10/2013
      }
    
      for(Quote qot : lstQuote){
        qot.Account__c = (mOpp.get(qot.OpportunityId)).AccountId;
    
        qot.Oracle_Vendor_email_field_value__c  = mapSEmail.get((mOpp.get(qot.OpportunityId)).AccountId); 
        String accCountry = mapAccCountry.get((mOpp.get(qot.OpportunityId)).AccountId);   //New Code -- Sunpower TPO Phase 1 -- 20/10/2013
        if ( mOpp.get( qot.OpportunityId) != null && mAcc.get((mOpp.get(qot.OpportunityId)).AccountId) != null && qot.QuoteType__c <> 'Loan' ){     
            List<Contact> lstTempCon = mAcc.get((mOpp.get(qot.OpportunityId)).AccountId).Contacts;
        
        if(!lstTempCon.isEmpty())
            {
              if(lstTempCon.size() == 1)   
                //New Code -- Sunpower TPO Phase 1 -- 20/10/2013
                if (accCountry.equalsIgnoreCase('France'))
                {
                    qot.PrimaryContact__c = lstTempCon[0].Id;
                }
                else if (accCountry.equalsIgnoreCase('Australia'))  //If Country is Australia, Update Primary Contact on Quote
                {
                    qot.PrimaryContact__c = lstTempCon[0].Id;
                    qot.Temp_Contact_1__c = lstTempCon[0].Name;
                }            
                else 
                {
                //End New Code -- Sunpower TPO Phase 1 -- 20/10/2013
                    qot.Temp_Contact_1__c = lstTempCon[0].Name;
                } //New Code -- Sunpower TPO Phase 1 -- 20/10/2013        
              else if(lstTempCon.size() >= 2)          
              { 
                //New Code -- Sunpower TPO Phase 1 -- 20/10/2013
                if (accCountry.equalsIgnoreCase('France'))
                {
                 qot.PrimaryContact__c   = lstTempCon[0].Id;
                 qot.SecondaryContact__c = lstTempCon[1].Id;
                }
                else if (accCountry.equalsIgnoreCase('Australia'))  //If Country is Australia, Update Primary Contact on Quote
                {
                    qot.PrimaryContact__c = lstTempCon[0].Id;
                    qot.Temp_Contact_1__c = lstTempCon[0].Name;
                    qot.Temp_Contact_2__c = lstTempCon[1].Name;
                }                        
                else
                {
                //End New Code -- Sunpower TPO Phase 1 -- 20/10/2013
                 qot.Temp_Contact_1__c = lstTempCon[0].Name;
                 qot.Temp_Contact_2__c = lstTempCon[1].Name;
                }    //New Code -- Sunpower TPO Phase 1 -- 20/10/2013
              }   
            }
        }
    //01-Jul-2014 : Birlasoft : GPP : Update Amendment Type for Amended Quote & Lease to be Amended fields on Quote.
        if(qot.Amended_Lease_number__c!=null && qot.Amended_Lease_number__c!=''){
            qot.AmmendmentType_AmdQuote__c=qot.Amendment_Type__c;
            qot.Lease_tobe_Amended__c=qot.Amended_Lease_number__c;
        }
      }  
  
  } 
 /*
@Name        :  QuoteSummaryIsLocked
@description :  This code will show the locked quote in CPR in Locked Scenario field of Quote Summary 
@parameters  :  List<Id> lstQSId
*/ 
  public static void QuoteSummaryIsLocked(List<Id> lstQSId){
    
    Map<Id, Set<Quote_Summary__c>> mapQS = new Map<Id, Set<Quote_Summary__c>>();
    if(!lstQSId.isEmpty()) {
        Map<Id, Quote_Summary__c> mapIdvsQS = new Map<Id, Quote_Summary__c>([SELECT q.Locked_Scenario__c, q.Id, 
                                                                            (SELECT Id, Is_Locked__c, Quote_Summary__c FROM Quotes__r) 
                                                                             FROM Quote_Summary__c q 
                                                                             WHERE q.Id IN: lstQSId]);
                                                                                     
        if(mapIdvsQS != null && !mapIdvsQS.isEmpty()) {
            for(Id qsId: mapIdvsQS.keySet()) {
                List<Quote> lstQ = (mapIdvsQS.get(qsId)).Quotes__r;
                System.debug('---Inside For Loop---' + lstQ);
                if(!lstQ.isEmpty()) {
                    for(Quote q: lstQ) {
                        if(q.is_Locked__c) {
                            if(!mapQS.isEmpty() && mapQS.containsKey(q.Quote_Summary__c)) {
                                //Set<Quote_Summary__c> setQSTemp = mapQS.get(q.Quote_Summary__c); Amit 11 May.
                                Set<Quote_Summary__c> setQSTemp ;
    
                                setQSTemp.add(new Quote_Summary__c(id= q.Quote_Summary__c, Locked_Scenario__c= q.Id));
                                mapQS.put(q.Quote_Summary__c, setQSTemp);
                            }
                            else
                                mapQS.put(q.Quote_Summary__c ,new Set<Quote_Summary__c>{new Quote_Summary__c(id= q.Quote_Summary__c, Locked_Scenario__c= q.Id)});
                        } 
                    }
                }
            }
            
            if(!mapQS.isEmpty()) {
                List<Quote_Summary__c> lstTemp = new List<Quote_Summary__c>();
                for(Set<Quote_Summary__c> sQS: mapQS.values()) {
                    for(Quote_Summary__c qs: sQS) {
                        lstTemp.add(qs);
                    }
                }
                if(lstTemp != null && !lstTemp.isEmpty()) {
                    update lstTemp;
                }
            }
        }
    }


  } 
 /*
@Name        :  updateAmendmentType
@description :  Update the Quote with amendmentType of the previou Quote
@parameters  :  List <Quote> lQuote
*/ 
  public static void updateAmendmentType (List<Quote> lstQuote){
     Quote q1 = [select Id, Amendment_Type__c, Amended_Lease__c, AmmendmentType_AmdQuote__c from Quote where Id=:lstQuote[0].Amended_Lease__c limit 1];
        if(q1 != null) {
            q1.AmmendmentType_AmdQuote__c = lstQuote[0].Amendment_Type__c;
            update q1;
        } 
  }
  
  /*
@Name        :  updateLeaseDoc
@description :  Update the QuoteSummary with the new Lease number
@parameters  :  List <Quote> lQuote
*/ 
  public static void updateLeaseDoc(List<Quote> lstQuote){
       List<Quote_Summary__c> QTS = new list<Quote_Summary__c>();
       QTS = [select Id,  Lease_Doc_Signed__c FROM Quote_Summary__c where Locked_Scenario__c=:lstQuote[0].Id limit 1 ];
        if(QTS != null && QTS.size()>0 ) {
            QTS[0].Lease_Doc_Signed__c = lstQuote[0].Lease_Doc_Signed__c;
          update QTS;
        }  
 
  }
/*@Name        :  reassignDownStreamObject
@description :  Update the downstream objects with new amended Quote Id
@parameters  :  Map<id,Id> amendedQuotemap
*/ 
  public static void reassignDownStreamObject (Map<Id,Id> amendedQuotemap){
    List<sObject> objectsToUpdate = new List<sObject>();
    for(Quote q : [select id,
                   (select Id from Lease_Payments__r),
                   (select Id from Purchase_Orders__r),
                   (select Id from Residential_Projects__r) 
                   from Quote where Id IN: amendedQuotemap.keyset()]){
          for(LeasePayment__c Lp : q.Lease_Payments__r){
                Lp.Quote__c = amendedQuotemap.get(q.Id);
				Lp.Create_Lease_Summary__c = true;
                objectsToUpdate.add(Lp);
          }
           for(Residential_Project__c rp : q.Residential_Projects__r){
                rp.Quote__c = amendedQuotemap.get(q.Id);
                objectsToUpdate.add(rp);
          }
     }
     System.debug('---objectsToUpdate---' + objectsToUpdate);
     update objectsToUpdate;
  }

    //Populate Lessee on Locked Quotes
    public static void populateLessee(List<Quote> lockedQuotes){

        Set<Id> accountIdSet = new Set<Id>();


        for(Quote qt : lockedQuotes){
            if(qt.Account__c != null){
                accountIdSet.add(qt.Account__c);
            }
        }

        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id,
                                                                    (SELECT Id FROM Contacts WHERE Primary__c = true)
                                                                    FROM Account where Id in :accountIdSet]);

        for(Quote Q : lockedQuotes){
            if(accountMap != null && accountMap.containsKey(Q.Account__c)){
                List<Contact> primaryContactList = new List<Contact>();
                primaryContactList = accountMap.get(Q.Account__c).Contacts;
                if(primaryContactList != null && !primaryContactList.isEmpty()){
                    Q.Lessee__c = primaryContactList[0].Id;
                }
            }
        }
    }

}