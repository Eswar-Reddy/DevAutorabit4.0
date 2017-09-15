/*
* EMEAOrderSubmissionDetails - controller for post-submit details from cash based ordering system
* SFDC Release - https://na29.salesforce.com/a5B34000000xp2Y
*
* Pivotal Tracker Updates:
* ID #114709951 - Add Contact Phone to the Order Submission Screen - 3/18/16
* ID #114738873 - Purchase Order Re-submission (SFDC) - 4/16/2016
* ID #121852503 - Remove Ok to Ship  - 6/23/2016
* ID #114921295 - Remove Shipping Method Selection - WW32
*
*
*
*
*/

global with sharing class EMEAOrderSubmissionDetails extends PageControllerBase {

    //variables etc...
    global Purchase_Order__c purchaseOrder {get;set;}
    global User currentUser {get; set;}
    global String oppId {get; set;}
    global Opportunity opp {get; set;}
    global List<Purchase_Order_Line__c> orderLines {get;set;}
    global Bill_To_Site__c bts {get;set;}
    global Ship_To_Site__c sts {get;set;}
    global String shipContactName {get;set;}
    global String poName{get;set;}
    global String OppName{get;set;}
    global String poID;
    global Integer retries {get; private set;}
    global Integer numLines {get; set;}

    //constructor
    // #121852503 - remove Ok to Ship
    // #114921295 - removed ship to method validation - 07/10/2016
    global EMEAOrderSubmissionDetails(ApexPages.StandardController controller) {
        retries = 0;
        poID = ApexPages.currentPage().getParameters().get('POID');

        if(poID != null){
            for(Purchase_Order__c p:[Select p.OwnerID, p.Ship_To_Contact__c, p.Ship_To_Contact__r.Name, p.Is_Taxible_Order__c,
                                            p.Opportunity__c, p.Opportunity__r.Name, p.Opportunity__r.Id,
                                            p.Special_Instructions__c, p.Name, p.Id, p.Contact_ID__c,
                                            p.Oracle_Order_Number__c, p.Order_Status_Interface_Message__c,p.Ship_To_Contact__r.Phone,
                                            p.Order_Total__c,p.Requested_Delivery_Date__c, p.Bill_to_site__c, p.Ship_to_site__c,
                                            p.Dealer_Account__r.Name, Order_Status__c, p.Accept_Terms__c, p.Interface_Status__c,
                                            p.Bill_To_Contact__r.Oracle_Contact_id__c, p.Ship_To_Contact__r.Oracle_Contact_id__c
                                     From Purchase_Order__c p
                                     where p.Id =:poID]){
                purchaseOrder = p;

                //bill to site
                try {
                    bts = [SELECT Id, Address1__c, City__c, State__c, Site_ID__c, Zip__c FROM Bill_To_Site__c WHERE id =: p.Bill_to_site__c];
                }  catch(Exception e) {
                    System.debug('BTS ERROR: ' + e.getMessage());
                }

                //ship to site
                try {
                    sts = [SELECT Id, Address__c, Address1__c, City__c, Country__c, Dealer_Account__c, Oracle_County__c, SiteID__c, State__c, Status__c, Zip__c FROM Ship_To_Site__c WHERE id =: p.Ship_to_site__c];
                }  catch(Exception e) {
                    System.debug('STS ERROR: ' + e.getMessage());
                }
            }
            try {
                orderLines = [SELECT Item_Description__c, Item_ID__c, Quantity__c FROM Purchase_Order_Line__c where Purchase_Order__c=:poID];
                numLines = orderLines.size();
            } catch(Exception e) {
                System.debug('orderLines error: ' + e.getMessage() + ' - ' + e.getStackTraceString());
            }
        }

        currentUser = [Select Id, Name, Profile.Name, UserType, Contact.Country_Domain__c, Contact.Account.RSM__c,
                              ContactId, Contact.AccountID, Contact.Authorized_to_Order__c, Contact.Account.Primary_PSR__c,
                              Contact.Account.Oracle_Operating_Unit__c, Contact.Account.Online_Order_Access__c,
                              Contact.Account.AccountNumber, Contact.Account.Name,
                              Contact.Account.Oracle_Account_Number__c, CurrencyISOCode
                       From User Where Id =: UserInfo.getUserId()];

    } //end of constructor

    //#114738873
    global PageReference psrSubmitOrder() {
        if(currentUser.Contact.AccountId == null) {
            if(purchaseOrder.Accept_Terms__c && purchaseOrder.Bill_To_Site__c != null && purchaseOrder.Ship_to_Site__c != null) {
                purchaseOrder.Order_Status__c = 'Submitted';
                purchaseOrder.Interface_Status__c = 'New';

                try {
                    update purchaseOrder;

                } catch(Exception e) {
                    System.debug('EXCEPTION: ' + e);
                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
                    ApexPages.addMessage(errorMsg);
                    return null;
                }
            }
        }
        PageReference pg = new PageReference('/apex/EMEAOrderSubmissionDetails?POID='+purchaseOrder.Id);
        return pg.setRedirect(true);
    }
}