/* **************************************************************************************
* Class Name     : OracleCancellationUtility
* Version           : 1.0
* Created Date   :    December 12 2016
* Function       :

* Modification Log :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
* Ankit                        12 JAN 2017          Original Version
*************************************************************************************/

public class OracleCancellationUtility {
   public static List<Quote> Qt;
   public static ResultMessage fSendRequestToOracle(String sRequest,string url,string sRequestType) {
        try {

        // setup the request
            Http h = new Http();
            HttpRequest req = new HttpRequest();
          if(sRequestType == 'Cancel')  
            req.setMethod('PUT');
          if(sRequestType == 'HOLD')
            req.setMethod('POST');
              
            req.setHeader('Content-Type', 'application/json');
            req.setTimeout(60000);
            req.setEndpoint(url);
            req.setBody(sRequest);
            system.debug('--req---' + req);
        // send the request
            HttpResponse res = h.send(req);
            String sResponse = req.getBody();
        // set response
           ResultMessage result;
           if(res.getStatusCode() == 200) {
                system.debug('--response body----' + res.getBody());
                result = new ResultMessage(true, res.getBody());
            }
             else {
                 result = new ResultMessage(false, res.getBody());
            }
          system.debug(LoggingLevel.Error + '-@@-' + result);
          return result;
        }
        catch (Exception e) {
            SpectrumDebugUtility.createExceptionLog(e.getMessage(), e.getStackTraceString(), 'Oracle Order Cancellation');
            return new ResultMessage(false, e.getMessage() + ' ' + e.getStackTraceString());
           }
    }


   public static string fCreateCancellationRequestString (echosign_dev1__SIGN_Agreement__c agreement){

           cls_sales_order  InformaticaHeader = new cls_sales_order();

           InformaticaHeader.sales_order_header.sales_type = Qt[0].QuoteType__c.toUpperCase();   //
           InformaticaHeader.sales_order_header.order_number =  Qt[0].Purchase_Orders__r[0].Oracle_Order_Number__c; //
           InformaticaHeader.sales_order_header.cancelled_flag = 'Y'; // defaulted to Yes.
           InformaticaHeader.sales_order_header.cust_po_number = Qt[0].Purchase_Orders__r[0].Name;
           InformaticaHeader.sales_order_header.operation = 'UPDATE';  // defaulted to UPDATE
           InformaticaHeader.sales_order_header.change_requester = UserInfo.getUserName() == 'Standard'?'Internal' : 'External';
           InformaticaHeader.sales_order_header.change_reason = agreement.Cancellation_Reason__c;  //
           InformaticaHeader.sales_order_header.channel_type = 'RVAR'; //Qt[0].Purchase_Orders__r[0].Dealer_account__r.Channel__c; // Channel on Partner Account
           InformaticaHeader.sales_order_header.cust_acct_number = Qt[0].Purchase_Orders__r[0].Dealer_account__r.Oracle_Account_Number__c; // Oralce Acc# on Parnter
           InformaticaHeader.sales_order_header.psr_email_id = Qt[0].Purchase_Orders__r[0].Primary_PSR_Email__c;
           InformaticaHeader.sales_order_header.header_id = '';    // Not available in Salesforce.

           InformaticaCancealltionRequest objRequest = new InformaticaCancealltionRequest();
           objRequest.processorderrequest.sales_order_collection.sales_order.add(InformaticaHeader);

           return (JSON.serialize(objRequest));
    }

   public static String fCreateHoldRequestString (){

         InformaticaHoldRequest objRequest = new InformaticaHoldRequest();
         objRequest.process_hold_request.hold_order_header.po_number = Qt[0].Purchase_Orders__r[0].Name;
         objRequest.process_hold_request.hold_order_header.cust_acct_number = Qt[0].Purchase_Orders__r[0].Dealer_account__r.Oracle_Account_Number__c;
         objRequest.process_hold_request.hold_order_header.order_number = Qt[0].Purchase_Orders__r[0].Oracle_Order_Number__c;
         objRequest.process_hold_request.hold_order_header.org_id = '';

         objRequest.process_hold_request.hold_info_line.hold_info_line_item.line_id = '';
         objRequest.process_hold_request.hold_info_line.hold_info_line_item.hold_name = 'PCHOLD';
         objRequest.process_hold_request.hold_info_line.hold_info_line_item.hold_level = 'ORDER';
         objRequest.process_hold_request.hold_info_line.hold_info_line_item.action = 'APPLY';
         objRequest.process_hold_request.hold_info_line.hold_info_line_item.hold_comments = 'hold applied from api';

         return (JSON.serialize(objRequest));
    }
   @future(callout = true)
   public static void fCallToOralce(Id aggreementId,Id QuoteId,string sRequestType){
         Qt = [select Id,Quote_type__c,QuoteType__c,
                         (select Id,Name,Oracle_Order_Status__c,Order_Status__c,Dealer_account__r.Channel__c,Order_Type__c,
                          Oracle_Order_Number__c,Primary_PSR_Email__c,Dealer_account__r.Oracle_Account_Number__c from Purchase_Orders__r),
                          (select Id,Oracle_Cancellation_Status__c from Lease_Payments__r),
                          (select Id,echosign_dev1__Status__c,Cancellation_Reason__c  from Agreements__r where Id =: aggreementId)
                          from Quote where Id =: QuoteId];
        System.debug('-----Qutoe Q----' + Qt + 'Qt.Purchase_Orders__r---@@' + Qt[0].Purchase_Orders__r);
        if(Qt == null || Qt[0].Purchase_Orders__r == null || Qt[0].Purchase_Orders__r.size() == 0 || Qt[0].Purchase_Orders__r[0].Order_Status__c == 'New')
           return;
         string url;
         string sRequest;
         ResultMessage saveResult;
         //system.debug(LoggingLevel.Error + '-@@-sRequestType--' + sRequestType + '----aggreement.echosign_dev1__Status__c--' + Qt[0].Agreements__r[0].echosign_dev1__Status__c);
         if(Qt[0].Agreements__r[0].echosign_dev1__Status__c == 'Signed' && Qt[0].Lease_Payments__r[0].Oracle_Cancellation_Status__c == 'Hold' && sRequestType == 'Cancel'){
            // send a request to cancel the order.
                sRequest  = fCreateCancellationRequestString(Qt[0].Agreements__r[0]);
                system.debug('------Cancel Request------' + sRequest);
                saveResult = fSendRequestToOracle(sRequest,'callout:InformaticaOracleOrders','CANCEL');

          }
         else if (Qt[0].Agreements__r[0].echosign_dev1__Status__c == 'Out for Signature' && sRequestType == 'Hold') {
            // Send a request to hold the order.
               sRequest  = fCreateHoldRequestString();
               system.debug('------Hold Request------' + sRequest);
               saveResult =  fSendRequestToOracle(sRequest,'callout:Informatica_Oracle_Order_Cancellation','HOLD');
          }

         LeasePayment__c objLp = new LeasePayment__c(Id = Qt[0].Lease_Payments__r[0].Id);
         List<Attachment> lstAttach = new List<Attachment>();
         if(saveResult.success){
                if(sRequestType == 'Hold'){
                    InformaticaHoldResponse  infoResponse = (InformaticaHoldResponse) JSON.deserialize(saveResult.message, InformaticaHoldResponse.Class);
                     system.debug(LoggingLevel.Error,'--Hold----' + infoResponse);
                     if(infoResponse.process_oracle_hold_response.status == 'S')
                          objLp.Oracle_Cancellation_Status__c = 'Hold';
                     else if(infoResponse.process_oracle_hold_response.status == 'E')
                          objLp.Oracle_Cancellation_Status__c = 'Cannot Hold.Shipped already';
                   }
                if(sRequestType == 'Cancel'){
                     InformaticaCancelResponse  infoResponse = (InformaticaCancelResponse) JSON.deserialize(saveResult.message, InformaticaCancelResponse.Class);
                      system.debug(LoggingLevel.Error,'--Cancel----' + infoResponse);
                     if(infoResponse.process_order_response.sales_order_response_collection.sales_order_response.status == 'S')
                          objLp.Oracle_Cancellation_Status__c = 'Cancelled';
                     else if(infoResponse.process_order_response.sales_order_response_collection.sales_order_response.status == 'E')
                          objLp.Oracle_Cancellation_Status__c = 'Error';
                 }
            }
            else {
                objLP.Oracle_Cancellation_Status__c = 'Error';
            }


           lstAttach.add(new Attachment(name='Oracle'+ sRequestType +'Request.pdf', parentid= Qt[0].Agreements__r[0].Id,body =Blob.toPDF(sRequest)));
           lstAttach.add(new Attachment(name='Oracle'+ sRequestType +'Response.pdf', parentid= Qt[0].Agreements__r[0].Id,body =Blob.toPDF(saveResult.message)));

         insert lstAttach;
         Update objLp;
       }
//  Oracle Hold Request *****************
    class InformaticaHoldRequest {
         public cls_process_hold_request process_hold_request;
         public InformaticaHoldRequest(){
            process_hold_request = new cls_process_hold_request();
         }
       }

    class cls_process_hold_request {
        public cls_hold_order_header hold_order_header;
        public cls_hold_info_line hold_info_line;

        public cls_process_hold_request(){
            this.hold_order_header = new cls_hold_order_header ();
            this.hold_info_line = new cls_hold_info_line ();
        }
    }
    class cls_hold_order_header {
        public String po_number;    // Name of the purchase Order
        public String cust_acct_number; // Oracle_Account_Number__c on the Partner Account
        public String order_number; //
        public String header_id;    //
        public String org_id;   //
    }
    class cls_hold_info_line {
        public cls_hold_info_line_item hold_info_line_item;

        public cls_hold_info_line (){
            this.hold_info_line_item = new cls_hold_info_line_item ();
        }
    }
    class cls_hold_info_line_item {
        public String line_id;  //
        public String hold_name;    //PCHOLD
        public String hold_level;   //ORDER
        public String action;   //HOLD
        public String hold_comments;    //hold applied from api
    }
// End -- Informatica Old Request *****************

// Informatica Hold Response *****************
    public class InformaticaHoldResponse {
       public cls_process_oracle_hold_response process_oracle_hold_response;
       public InformaticaHoldResponse(){
          this.process_oracle_hold_response = new cls_process_oracle_hold_response();
       }
     }
     public class cls_process_oracle_hold_response {
        public String status_message;   //Order is partially shipped.Not eligible for update:
        public String oracle_hold_response; //
        public String status;   //E
      }
// End -- Informatica hOld Request *****************
// Informatica Cancellation Request *****************
public class InformaticaCancealltionRequest {
    public cls_processorderrequest processorderrequest;
    public InformaticaCancealltionRequest(){
        this.processorderRequest = new cls_processorderrequest();
    }
}

    class cls_processorderrequest {
        public cls_message_header message_header;
        public cls_sales_order_collection sales_order_collection;

        public cls_processorderrequest (){
            this.message_header = new cls_message_header();
            this.sales_order_collection = new cls_sales_order_collection();
        }
    }
    class cls_message_header {
        public String source_system_id ; //SFDC
        public String transaction_id;   //cbf34064-dc1b-4b2d-aadf-3cbdd148bd14

      public cls_message_header (){
         this.source_system_id = 'SFDC';
         this.transaction_id = generateGUID();
      }
    }
    class cls_sales_order_collection {
        public List<cls_sales_order> sales_order;
        public cls_sales_order_collection (){
            this.sales_order = new List<cls_sales_order> ();
        }
    }
    class cls_sales_order {
        public cls_sales_order_header sales_order_header;
        public cls_sales_order () {
            this.sales_order_header = new cls_sales_order_header ();
        }
    }
    class cls_sales_order_header {
        public String sales_type;   //LEASE
        public String order_number; //11246268
        public String cancelled_flag;   //Y
        public String cust_po_number;   //858583
        public String operation;    //UPDATE
        public String change_requester; //EXTERNAL
        public String change_reason;    //Testing
        public String channel_type; //RVAR
        public String cust_acct_number; //123456
        public String psr_email_id; //rdoddi@sunpower.com
        public String header_id;    //
    }
// End -- Informatica Cancellation Request *****************
// Informatica Cancellation Response *****************
  public class InformaticaCancelResponse{
      public cls_process_order_response process_order_response;
      public InformaticaCancelResponse (){
            this.process_order_response = new cls_process_order_response();
        }
    }
  public class cls_process_order_response {
    public cls_sales_order_response_collection sales_order_response_collection;
  }
  public class cls_sales_order_response_collection {
    public cls_sales_order_response sales_order_response;
  }
  public class cls_sales_order_response {
    public String status_message;
    public String status; //E
  }
 //  End --Informatica Cancellation Response *****************
   // Method to generate the Random ID.
    public static String generateGUID() {
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        return guid;
    }


}