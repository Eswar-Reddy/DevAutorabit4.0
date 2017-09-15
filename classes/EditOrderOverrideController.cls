public with sharing class EditOrderOverrideController {
    private ApexPages.StandardController stdCnt {get;set;}
    private Purchase_Order__c purchaseOrder {get;set;}
    public Boolean isPartnerUser {get;set;}
    public static String POID_KEY = 'POID';
    private User currUser {get;set;}
    
    public EditOrderOverrideController( ApexPages.StandardController stdCnt ) {
        
        this.stdCnt = stdCnt;
        this.purchaseOrder = (Purchase_Order__c)stdCnt.getRecord();
        this.isPartnerUser = [SELECT Id, IsPortalEnabled FROM User WHERE Id = :UserInfo.getUserId()].IsPortalEnabled;
        currUser = [SELECT Profile.Name, ContactId, Contact.AccountId, Contact.Authorized_to_Order__c, Contact.Account.Online_Order_Access__c
                   FROM User WHERE Id =: UserInfo.getUserId()]; 
    }
    
    public PageReference redirect() {
        
        PageReference orderPage;
        System.debug(purchaseOrder.Lease__c + ' ' + purchaseOrder.Id);
        if(currUser.ContactId == null || currUser.Contact.AccountId == null 
           || currUser.Contact.Authorized_to_Order__c == false || currUser.Contact.Account.Online_Order_Access__c == false) {
               
               if(isPartnerUser) {
                   orderPage = Page.SPCommunityOrderErrors;
                   orderPage.setRedirect(true);
                   return orderPage;
               } else {
                   if (purchaseOrder.Lease__c == TRUE || purchaseOrder.Sales_Type__c == 'Loan'){//cdevarapalli Loan Backend
                       orderPage = Page.LeaseOrderWizard;
                       orderPage.getParameters().put( POID_KEY, purchaseOrder.Id );
                       orderPage.setRedirect(true);
                       return orderPage;
                   }
                   else if(purchaseOrder.Order_Type__c == null) {
                       orderPage = Page.PurchaseOrderWizard;
                       orderPage.getParameters().put( POID_KEY, purchaseOrder.Id);
                   }
                   else if (purchaseOrder.Order_Type__c != null && purchaseOrder.Order_status__c != 'New') {
                       orderPage = Page.OrderSubmissionDetails;
                       orderPage.getParameters().put( POID_KEY, purchaseOrder.Id );
                   } else {
                       ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardAccessPermissionsErrorMsg);
                       ApexPages.addMessage(errorMsg); 
                       return null;
                   }
                   orderPage.setRedirect(true);
                   return orderPage;
               }
           }
        else {            
            if(currUser.Profile.Name != null && currUser.Profile.Name.startsWith('AU')) {
                if ( purchaseOrder.Lease__c == null || purchaseOrder.Lease__c == false ){
                    orderPage = Page.PurchaseOrderWizard;
                    orderPage.getParameters().put( POID_KEY, purchaseOrder.Id );
                }
                else {
                    orderPage = Page.LeaseOrderWizard;
                    orderPage.getParameters().put( POID_KEY, purchaseOrder.Id );
                }
            }
            else if(Userinfo.getLocale() != 'en_US') {
                if (purchaseOrder.Order_Type__c != null && purchaseOrder.Order_Status__c != 'New'){
                    orderPage = Page.EMEAOrderSubmissionDetails;
                    orderPage.getParameters().put( POID_KEY, purchaseOrder.Id );
                }
                else if (purchaseOrder.Order_Type__c == null && purchaseOrder.Order_Status__c != 'New' && !String.isBlank(purchaseOrder.Order_Status__c)){
                    orderPage = Page.PurchaseOrderWizard;
                    orderPage.getParameters().put( POID_KEY, purchaseOrder.Id );                
                }
                else{
                    orderPage = Page.EMEAAlaCartePage;
                    orderPage.getParameters().put( POID_KEY, purchaseOrder.Id );
                }
            }
            
            else if (purchaseOrder.Order_Type__c != null && purchaseOrder.Order_status__c != 'New') {
                orderPage = Page.OrderSubmissionDetails;
                orderPage.getParameters().put( POID_KEY, purchaseOrder.Id );
            }
            //else if (purchaseOrder.Order_Type__c != null && purchaseOrder.Order_status__c != 'Submitted'){// only cash order redesign uses Order_type__c field and populates with single/multi systems
            else if(purchaseOrder.Order_Type__c != null && purchaseOrder.Order_Status__c == 'New') {
                orderPage = Page.OrderShipping;
                if(purchaseOrder.Id != null)
                    orderPage.getParameters().put( POID_KEY, purchaseOrder.Id );
                
            } else {
                
                if ( (purchaseOrder.Lease__c == null || purchaseOrder.Lease__c == false) && purchaseOrder.Sales_Type__c!='Loan'){//cdevarapalli Loan Backend
                    if(purchaseOrder.Id != null)
                        orderPage = Page.PurchaseOrderWizard;
                    else
                        orderPage = Page.OrderTypeSelection;
                    orderPage.getParameters().put( POID_KEY, purchaseOrder.Id );
                }
                
                else if(purchaseOrder.Lease__c == true || purchaseOrder.Sales_Type__c=='Loan'){//cdevarapalli Loan Backend
                    orderPage = Page.LeaseOrderWizard;
                    orderPage.getParameters().put( POID_KEY, purchaseOrder.Id );
                }
            }
        }
            
        orderPage.setRedirect(true);
        return orderPage;
    }
}