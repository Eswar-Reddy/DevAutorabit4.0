/* **************************************************************************************
* Class Name     : DocGenEconomicAmendmentRequest
* Version        : 1.0
* Created Date   : 30 April 2017
* Function       : It's a class to make call to DocGen for Economic document creation.
* Change Orders - June 2017
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
* Ankit                      30 April 2017          Original Version
*************************************************************************************/

public class DocGenEconomicAmendmentRequest {

  public static Quote Qt;
  public static Account customerAccount;
  public static map<string,Contact> customerContacts;
  public Static List<Roof_Design__c> roofDesigns;
  public static string invList;
  private static boolean calloutSuccess;

  public static ResultMessage createAgreementRecord(Id QuoteId,Id agreementrecordTypeId, string additionalRecipient,string notes,string changeOrderType,string documentType){
    ResultMessage result = new ResultMessage();
    try{
        // Querying all the relevant data.
        queryData(QuoteId);
        // request body
        string requestBody = createRequest(changeOrderType,documentType);
        // calling the function to make call to Docgen
        HttpResponse response = sendRequestToDocGen(requestBody);
       // setting the response from result.message
         result.success = calloutSuccess;
         result.message = response.getBody();
         
        // inserting the log for debuging
        SpectrumDebugUtility.debugLog lg = new SpectrumDebugUtility.debugLog();
        lg.service =  changeOrderType + '-DocGen Service';
        lg.jsonPayload = requestBody;
        lg.response = response.getBody();
        lg.accountId = customerAccount.Id;
        lg.quoteId = Qt.Id;
        // inserting the
        SpectrumDebugUtility.generateDebugLog(lg);

        // return result message in case of failure
        if(!result.success){
           return result;
        }

      // inser
        echosign_dev1__SIGN_Agreement__c newAgreement = new echosign_dev1__SIGN_Agreement__c();
        newAgreement.recordTypeId = agreementrecordTypeId;
        newAgreement.Quote__c = qt.Id;
        newAgreement.Account__c = qt.Account__c;
        newAgreement.Agreement_Name__c = newAgreement.Name = customerAccount.Name + '-' + changeOrderType + '-' + qt.Consolidated_Lease_Number__c + '-' + String.valueOf(System.today()) + '.pdf';
        newAgreement.echosign_dev1__Status__c = 'Draft';
        newAgreement.echosign_dev1__Recipient__c = customerContacts.get('primary').Id;
        newAgreement.echosign_dev1__Recipient2__c = customerContacts.containskey('coSignee') ? customerContacts.get('coSignee').Id : null;
        newAgreement.echosign_dev1__More_Recipients__c = additionalRecipient;
        newAgreement.Notes__c = notes;
        newAgreement.Change_Order_Type__c = changeOrderType;
        system.debug('---New Agreement----' + newAgreement);

        // inserting the new agreement
        insert newAgreement;

       // Overwrite the message with new agreement Id to return it parent class
        result.message = newAgreement.Id;

        // creating the attachment and attaching it to the agreement record and also creating the request as an attachment to Quote
        List<Attachment> attachmentList = new List<Attachment>();

        // Attachment of the response to the agreement record
        Attachment newAttachment = new Attachment();
        newAttachment.ParentId = newAgreement.Id;
        //newAttachment.Body = Blob.toPDF(responsebody);
        newAttachment.Body = response.getBodyAsBlob();
        newAttachment.Name = newAgreement.Name;
        attachmentList.add(newAttachment);

        insert attachmentList;
        system.debug(LoggingLevel.INFO, '---' + newAgreement);
        return result;
   }
  catch(Exception e) {
        system.debug('-----Exception----' + e + '- &&&--'+e.getStackTraceString() + '----' + e.getCause() + '--' + e.getLineNumber());
        SpectrumDebugUtility.createExceptionLog(e.getMessage(), e.getStackTraceString(), 'DocGenEconomicAmendmentRequest');
       // returing the result object.
        result.success = false;
        result.message = e.getMessage() + ' - ' + e.getStackTraceString();
        return result;
        }
}


  public static void queryData (Id quoteId){

    Id roofDesignRecTypeId = Schema.SObjectType.Roof_Design__c.getRecordTypeInfosByName().get('Residential Actual Design').getRecordTypeId();
    // Querying the quote information and related object.
        qt =  [ select Id,sector__c,QuoteType__c,Maximum_Rated_Capacity__c,Module_Count__c,System_Model__c,Mounting_Description__c,Monitoring_System__c,Consolidated_Lease_Number__c,
                 Solar_Rebate_Amount__c,Progress_Payment__c,Final_Payment__c,RoundOff_First_Monthly_Payment__c,Final_First_Monthly_Total_Tax__c,RoundOff_First_Monthly_Payment_Estimate__c,
                 Full_PrePayment_Amount_Base_Amount__c ,Full_PrePayment_Amount_Estimated_Tax_on__c,Full_PrePayment_Amount_Estimated_Paymen__c,Account__c,amended_lease__r.Consolidated_Lease_Number__c,
                 System_Cost__c,Total_Contract_Price__c,Down_Payment__c,RoundOff_First_Monthly_Payment_Base_Amo__c,
             (select Total_Energy__c,System_Size_AC__c,System_Size_AC_Watts__c,Percentage_Electricity_Produced__c,Monthly_Electric_Bill_saving_year1__c,Net_Monthly_Savings_Year_1__c,
                   Monthly_Electric_Bill_Without_PV_year1__c from System_Production__r),
             (select Id,Guarantee_Year__c,Guaranteed_Range_of_Annual_Production__c,Roundoff_Rate_Per_KWH__c,Final_Base_Monthly_Payment__c,Final_Estimated_Tax_on_Monthly__c,Final_Estimated_Monthly_W_Tax_No_ACH__c,
                  Final_Estimated_Monthly_W_Tax_W_ACH__c,Temp_Monthly_Lease_Payments__c from Lease_Progress__r),
             (select Id,Account_Name__c,Active__c,Status__c,Type__c  from Equinox_Designs__r where recordTypeId =: roofDesignRecTypeId)
                 from Quote where Id =: quoteId];
    // Querying the roof details and inverterlist

    if(qt <> null && qt.Equinox_Designs__r <> null && qt.Equinox_Designs__r.size()>0)
       roofDesigns = [select Id,
                     (select Id,Inverter_List__c,inverter_Model__c,inverter_Count__c from Roof_Details__r),
                     (select EDDiE_Retrofit__c,Index__c,InverterConfiguration__r.Name from Design_Inverter_List__r)
                     from Roof_Design__c where Id =: qt.Equinox_Designs__r[0].Id];

   // Querying the account and other related objects.
    if(qt <> null && qt.Account__c <> null)
       customerAccount =   [select Id,Name,Phone,Email__c,BillingStreet,BillingCity,BillingState,BillingCountry,BillingPostalCode,
                           Partner_Account__r.Name,Partner_Account__r.BillingStreet,Partner_Account__r.BillingCity,Partner_Account__r.BillingState,
                           Partner_Account__r.BillingPostalCode,Partner_Account__r.Contractors_License__c,
                           (select Id,Name,Email,Phone,Primary__c,Include_in_Lease_Doc__c from Contacts where Primary__c = true OR Include_in_Lease_Doc__c = true)
                           from Account where Id =: qt.Account__c];

     system.debug('----qt---' + qt + '--roofDesigns----'+  roofDesigns + '--customer account---' + customerAccount + '--Contacts--' + customerAccount.Contacts);

     if(customerAccount <> null && customerAccount.Contacts.size()>0)
           customerContacts = new map<string,Contact>();
           for(Contact c : customerAccount.contacts){
                if(c.Primary__c)
                   customerContacts.put('primary',c);
                else
                   customerContacts.put('coSignee',c);
            }

     
     if(roofDesigns <> null && roofDesigns[0].Design_Inverter_List__r.size()>0)
       for(InverterList__c inv : roofDesigns[0].Design_Inverter_List__r){
            if(invList == null)
                 invList = inv.InverterConfiguration__r.Name ;
            else
              invList =  invList + ',' + inv.InverterConfiguration__r.Name ;
        }
 }

  public class requestJSON {
        public String apiKey = 'DC97-20AF-567E';
        public Object sector;
        public String watermark = 'Off';
        public List<NameValuePairs> nameValuePairs;
        public List<DynamicTables> dynamicTables;
    }

  public class NameValuePairs {
        public String name;
        public String value;

        public NameValuePairs(string name,string value){
             this.name = name;
             this.value = value;
          }
    }

public class DynamicTables {
        public String tableKey;
        public List<String> columnTokenNames;
        public List<List<String>> rowValues;
}

public static string createRequest(string changeOrderType,string documentType){
      Map<Integer,String> monthMap = new map<Integer,String>{1 => 'January',2 => 'February',3=>'March',4 =>'April',5=>'May',6=>'June',7=>'July',8=>'August',9=>'September',10=>'October',11=>'November',12=>'December'};
      requestJSON reqJson = new requestJSON();
      reqJson.sector = Qt.Sector__c;
      // Creating differents keys for name values pair.
      reqJson.nameValuePairs = new List<nameValuePairs>();
      reqJson.nameValuePairs.add(new NameValuePairs('date',MonthMap.get(Date.today().month()) + ' ' +  Date.today().day() + ' ' + Date.today().year()));
      reqJson.nameValuePairs.add(new NameValuePairs('contractNum',qt.amended_lease__r.Consolidated_Lease_Number__c));     
      // reqJson.nameValuePairs.add(new NameValuePairs('contractNum',qt.Consolidated_Lease_Number__c));
      reqJson.nameValuePairs.add(new NameValuePairs('changeOrderType',changeOrderType));
      reqJson.nameValuePairs.add(new NameValuePairs('documentType',documentType));
      reqJson.nameValuePairs.add(new NameValuePairs('dealType',qt.QuoteType__c));
      reqJson.nameValuePairs.add(new NameValuePairs('customerName',customerAccount.Name));
      reqJSON.nameValuePairs.add(new NameValuePairs('customerNameCo',customerContacts.containskey('coSignee') ? customerContacts.get('coSignee').Name : ''));
      reqJson.nameValuePairs.add(new NameValuePairs('customerStreetAddress',customerAccount.BillingStreet));
      reqJson.nameValuePairs.add(new NameValuePairs('customerCity',customerAccount.BillingCity));
      reqJson.nameValuePairs.add(new NameValuePairs('customerState',customerAccount.BillingState));
      reqJson.nameValuePairs.add(new NameValuePairs('customerPostalCode',customerAccount.BillingPostalCode));
      reqJSON.nameValuePairs.add(new NameValuePairs('customerPhoneNum',customerAccount.Phone));
      reqJSON.nameValuePairs.add(new NameValuePairs('customerEmailAddr',customerAccount.Email__c));
      //-----------------------------------------------------------------------------------------
      
      
      reqJson.nameValuePairs.add(new NameValuePairs('netSystemPrice',formatCurrency(qt.System_Cost__c))); 
      reqJson.nameValuePairs.add(new NameValuePairs('netContractPrice',formatCurrency(qt.Total_Contract_Price__c)));
      reqJson.nameValuePairs.add(new NameValuePairs('copayment',formatCurrency(qt.Down_Payment__c)));
      //reqJson.nameValuePairs.add(new NameValuePairs('note','--'));
      reqJson.nameValuePairs.add(new NameValuePairs('40ofTotalContrPrice',formatCurrency(qt.Progress_Payment__c)));
      reqJson.nameValuePairs.add(new NameValuePairs('remainingBalance',formatCurrency(qt.Final_Payment__c)));
     
      
      //----------------------------------------------------------------------------------------
      reqJson.nameValuePairs.add(new NameValuePairs('systemSize',String.valueof(qt.Maximum_Rated_Capacity__c)));
      reqJson.nameValuePairs.add(new NameValuePairs('panelCount',String.valueof(qt.Module_Count__c.intValue())));
      reqJson.nameValuePairs.add(new NameValuePairs('panelModel',String.valueof(qt.System_Model__c)));
      reqJson.nameValuePairs.add(new NameValuePairs('panelBrand','SunPower'));
      reqJson.nameValuePairs.add(new NameValuePairs('inverters',invList));
      reqJson.nameValuePairs.add(new NameValuePairs('rackingEquipment',qt.Mounting_Description__c));
      reqJson.nameValuePairs.add(new NameValuePairs('monitoringSystem',qt.Monitoring_System__c));
      
      // -----------------------------------------------------------------------------------------
      reqJSON.nameValuePairs.add(new NameValuePairs('solarRebateAmount',formatCurrency(qt.Solar_Rebate_Amount__c)));
      reqJSON.nameValuePairs.add(new NameValuePairs('firstMonthlyPaymentBase',string.valueof(qt.RoundOff_First_Monthly_Payment_Base_Amo__c)));
      reqJson.nameValuePairs.add(new NameValuePairs('finalFirstMonthlyTotalTax',string.valueof(qt.Final_First_Monthly_Total_Tax__c)));
      reqJson.nameValuePairs.add(new NameValuePairs('FirstMonthlyPaymentEst',string.valueOf(qt.RoundOff_First_Monthly_Payment_Estimate__c)));
      //  -----------------------------------------------------------------------------------------
      reqJson.nameValuePairs.add(new NameValuePairs('fullPrepaymentAmountBaseAmount',string.valueOf(qt.Full_PrePayment_Amount_Base_Amount__c)));
      reqJson.nameValuePairs.add(new NameValuePairs('fullPrepaymentAmountEstTax', string.valueOf(qt.Full_PrePayment_Amount_Estimated_Tax_on__c)));
      reqJson.nameValuePairs.add(new NameValuePairs('fullPrepaymentAmountEstPayment',string.valueOf(qt.Full_PrePayment_Amount_Estimated_Paymen__c)));
      //-------------------------------------------------------------------------------------------
      reqJson.nameValuePairs.add(new NameValuePairs('dealerName',customerAccount.Partner_Account__r.Name));
      reqJson.nameValuePairs.add(new NameValuePairs('dealerStreet',customerAccount.Partner_Account__r.BillingStreet));
      reqJson.nameValuePairs.add(new NameValuePairs('dealerCity',customerAccount.Partner_Account__r.BillingCity));
      reqJson.nameValuePairs.add(new NameValuePairs('dealerState',customerAccount.Partner_Account__r.BillingState));
      reqJson.nameValuePairs.add(new NameValuePairs('dealerPostalCode',customerAccount.Partner_Account__r.BillingPostalCode));
      reqJson.nameValuePairs.add(new NameValuePairs('dealerContractLicenseNumber',customerAccount.Partner_Account__r.Contractors_License__c));

      //-------- Creating rows for dynamic table---------
      if(Qt.QuoteType__c == 'Lease'){
          reqJson.dynamicTables = new List<DynamicTables>();
            DynamicTables dt = new DynamicTables();
              dt.tableKey = 'Guarantee table';
              dt.columnTokenNames = new List<String> {'prodGuaranteeYr','guaranteedRangeAnnualProd','ratePerKwh'};
              dt.rowvalues = new List<List<string>> ();
              for(Lease_Schedule__c leaseSch : Qt.Lease_Progress__r){
                     List<string> tempValues = new List<string> { leaseSch.Guarantee_Year__c,
                                                                  leaseSch.Guaranteed_Range_of_Annual_Production__c,
                                                                  string.valueOf(leaseSch.Roundoff_Rate_Per_KWH__c)
                                                                };
                     dt.rowValues.add(tempValues);
               }
            reqJson.dynamicTables.add(dt);

            DynamicTables dt1 = new DynamicTables();
            dt1.tableKey = 'Monthly Lease Payment';
            dt1.columnTokenNames = new List<String> {'tempMonthlyLeasePayment','finalBaseMonthlyPayment','finalEstTaxonMonthlyPayment','finalEstMonthlyWithTaxNoACH','finalEstMonthlyWithTaxWithACH'};
            dt1.rowvalues = new List<List<string>> ();
              for(Lease_Schedule__c leaseSch : Qt.Lease_Progress__r){
                     List<string> tempValues = new List<string> { leaseSch.Temp_Monthly_Lease_Payments__c,
                                                                  string.valueof(leaseSch.Final_Base_Monthly_Payment__c),
                                                                  string.valueof(leaseSch.Final_Estimated_Tax_on_Monthly__c),
                                                                  string.valueof(leaseSch.Final_Estimated_Monthly_W_Tax_No_ACH__c),
                                                                  String.valueof(leaseSch.Final_Estimated_Monthly_W_Tax_W_ACH__c)
                                                                };
                     dt1.rowValues.add(tempValues);
               }
          reqJson.dynamicTables.add(dt1);
       }
      system.debug('-------------' + JSON.serialize(reqJson));
      return JSON.serialize(reqJson);
}

public static String formatCurrency(Decimal i) {
    if (i == null || Math.abs(i) < 0.005) return '0.00';
    String s = (i.setScale(2) + (i >= 0 ? 0.001 : -0.001)).format();
    return s.substring(0, s.length() - 1);
}

public static HttpResponse sendRequestToDocGen(string requestBody){

    HttpRequest request = new HttpRequest();
    request.setEndpoint(DocGen_Callout_Settings__c.getAll().get('DocGen').EndPoint_Contract__c);
    request.setMethod('POST');
    request.setHeader('Content-Type', 'application/json');
    request.setTimeout(60000);
    request.setBody(requestBody);
    Http http1 = new Http();
    HttpResponse res;
    res = http1.send(request);
    if(res.getStatusCode() == 200) {
       calloutSuccess = true;
    }
    else {
       calloutSuccess = false;
     }
    return res; 
 }

}