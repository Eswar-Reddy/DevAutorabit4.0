/*** Class added in Sunpower TPO Phase 1 -- 20/10/2013, to create Lease payment ***/
public class TPO_CreateLP_FR {/*
   
   // Method is used to create lease payment
   public PageReference CreateLP() 
    {
      List<Quote> lstQuot = new List<Quote>();
      List<LeasePayment__c> lstLP = new List<LeasePayment__c>();
    
      FR_Record_Type__c frt1 = FR_Record_Type__c.getValues('FR RecordType Id');
      String leasePaymentRTId  = frt1.FR_LeasePayment_RT_Id__c;
      
      Try
      {
      if(apexpages.currentpage().getparameters().get('qid') != null)
      {
        Quote qq = [select id, name,Opportunity.Id,Account__c,Interconnect__c,Installation_Fee__c,Account__r.Name,PrimaryContact__c,Account__r.ParentId,Partner_Account_Id__c from Quote where id =: apexpages.currentpage().getparameters().get('qid') ];
        lstLP.add(new LeasePayment__c(name= qq.Account__r.Name,       
                                            Quote__c= qq.ID,
                                            Opportunity__c = qq.OpportunityID,
                                            Account__c = qq.Account__c, //Partner_Account__c = qq.Account__r.ParentId,
                                            End_Customer_Account__c = qq.Account__c,
                                            RecordTypeId =leasePaymentRTId,
                                            Contact__c = qq.PrimaryContact__c,
                                            Date_Lease_Document_signed__c = Date.Today(),
                                            Partner_Account__c = qq.Partner_Account_Id__c,
                                            Interconnection_Fees__c = qq.Interconnect__c,
                                            Installation_Fees__c = qq.Installation_Fee__c
                                             )); 
                                             
           }
       upsert lstLP;
      }
      Catch(Exception e)
      {
       // ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Lease Payment is Already created fot this account.');
       // ApexPages.addMessage(myMsg);
       // return null;
       }
       
      // Update Quote LOI Status Field to maintain the state and to change the formule field to Create lease Docs.
      if(apexpages.currentpage().getparameters().get('qid') != null)
      {
       for(Quote qq : [select id, name,Quote_LOI_Status__c,Account__c from Quote where id =: apexpages.currentpage().getparameters().get('qid')])
       {
        qq.Quote_LOI_Status__c = 'LOI';
        lstQuot.add(qq);
        }
      }
      
      Upsert lstQuot;
      
      PageReference Accpage= new PageReference('/'+ lstQuot[0].Account__c);
      Accpage.setRedirect(true);
      return Accpage;
    }
*/
}