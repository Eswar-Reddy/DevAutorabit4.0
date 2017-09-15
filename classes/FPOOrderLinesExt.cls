/* **************************************************************************************
* Class Name     : FPOOrderLinesExt
* Version        : 1.0 
* Created Date   : Sep 30 2015
* Function       : It's a utility class for TPS Document related functioanlity. 
                        
* Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Ankit                      Sep 30 2015          Original Version
*************************************************************************************/

public class FPOOrderLinesExt {

    private LeasePayment__c oLease;
    public List<FPO_Order_Line__c> lFPOOrderLines{get;set;}
    
    public FPOOrderLinesExt(ApexPages.StandardController controller) {
          this.oLease = (LeasePayment__c)controller.getRecord(); 
          string sPartnerRole = fIdentifyCurrentUserRole();
          if(sPartnerRole <> Null)
              lFPOOrderLines = [SELECT Id,Lease_Payment__c,MileStone__c,Name,Payment_Amount__c,
                                   Payment_Date__c,PO_Amount__c,PO_Creation_Date__c,PO_Receipt_Date__c,
                                   PO_Receipt__c,PO__c,Schedule_Payment_Date__c,Supplier_Invoice__c,
                                   Vendor_Type__c,Vendor__c 
                                   FROM FPO_Order_Line__c where vendor_Type__c =:sPartnerRole AND Lease_Payment__c =:oLease.Id];
                                     
        }
        
    public static String fIdentifyCurrentUserRole(){
        User U = [select Contact.Account.NH_SSE_Type__c from user where Id =: Userinfo.getUserId()];
          if(!String.isEmpty(U.Contact.Account.NH_SSE_Type__c)){
                if(U.Contact.Account.NH_SSE_Type__c.Contains('TPS'))
                     return 'TPS';
                else if (U.Contact.Account.NH_SSE_Type__c.Contains('Permit'))
                     return 'DRIP';
                else if (U.Contact.Account.NH_SSE_Type__c.Contains('Install'))
                     return 'IP';  
               }
             return null ;
    }    

}