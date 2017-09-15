@isTest
public class  TestFactory_Invoices {

    private static LeasePayment__c newLeasePayment;
    private static Installation_Model__c newInstallationModel;
    private static Invoice_Document_Data__c newInvoiceDocumentData;
	private static IDD_Junction__c newIM2IDDJunction;
    private static IDD_Junction__c newPartner2IDDJunction;
    private static Invoice_Compliance_Document__c newInvoiceComplianceDocument;

    public static Installation_Model__c getInstallationModel(){
    	if(newInstallationModel == NULL){
    		Installation_Model__c im = createInstallationModel();
    		insert im;
    		newInstallationModel = im; 
    	}
    	return newInstallationModel;
    }

    public static Installation_Model__c createInstallationModel(){
    	Installation_Model__c im = (Installation_Model__c)SmartFactory.createSObject('Installation_Model__c',false);
    	return im;
    }

    public static LeasePayment__c getLeasePayment(){
        if(newLeasePayment == NULL){
            LeasePayment__c lp = createLeasePayment(NULL, NULL, NULL);
            insert lp;
            newLeasePayment = lp;
        }
        return newLeasePayment;
    }

	public static LeasePayment__c createLeasePayment(Id accountId, Id opportunityId, Id quoteId){
        if(accountId == NULL) 		accountId 		= TestFactory_StandardObjects.getResidentialCustomerAccount().Id;
        if(opportunityId == NULL) 	opportunityId 	= TestFactory_StandardObjects.getHomeOwnerOpportunity().Id;
   		if(quoteId == NULL) 		quoteId 		= TestFactory_StandardObjects.getProposalQuote().Id;
				
		LeasePayment__c lp = (LeasePayment__c)SmartFactory.createSObject('LeasePayment__c',false);
		lp.Account__c		= accountId;
		lp.Opportunity__c	= opportunityId;
		lp.Quote__c			= quoteId;

		return lp;
	}	

    public static Invoice_Document_Data__c getInvoiceDocumentData(){
    	if(newInvoiceDocumentData == NULL){
    		Invoice_Document_Data__c idd = createInvoiceDocumentData();
    		insert idd;
    		newInvoiceDocumentData = idd;
    	}
    	return newInvoiceDocumentData;
    }

    public static Invoice_Document_Data__c createInvoiceDocumentData(){
    	Invoice_Document_Data__c id = (Invoice_Document_Data__c)SmartFactory.createSObject('Invoice_Document_Data__c',false);
    	return id;
    }

    public static Invoice_Compliance_Document__c getInvoiceComplianceDoc(){
        if(newInvoiceComplianceDocument == NULL){
            Invoice_Compliance_Document__c icd = createInvoiceComplianceDoc();
            insert icd;
            newInvoiceComplianceDocument = icd;
        }
        return newInvoiceComplianceDocument;
    }

    public static Invoice_Compliance_Document__c createInvoiceComplianceDoc(){
        Invoice_Compliance_Document__c icd = (Invoice_Compliance_Document__c)SmartFactory.createSObject('Invoice_Compliance_Document__c',false);
        return icd;
    }

    public static IDD_Junction__c getIM2IDDJunction(){
    	if(newIM2IDDJunction == NULL){
    		IDD_Junction__c iddj = createIM2IDDJunction(null, null);
    		insert iddj;
    		newIM2IDDJunction = iddj;
    	}
    	return newIM2IDDJunction;
    }

	public static IDD_Junction__c createIM2IDDJunction(Id installationModelId, Id invoiceDocumentDataId){
        if(installationModelId == NULL) 	installationModelId 	= getInstallationModel().Id;
        if(invoiceDocumentDataId == NULL) 	invoiceDocumentDataId 	= getInvoiceDocumentData().Id;

		IDD_Junction__c iddj 			= (IDD_Junction__c)SmartFactory.createSObject('IDD_Junction__c',false);
		iddj.Installation_Model__c		= installationModelId;
		iddj.Invoice_Document_Data__c	= invoiceDocumentDataId;

		return iddj;
	}

    public static IDD_Junction__c getPartner2IDDJunction(){
        if(newPartner2IDDJunction == NULL){
            IDD_Junction__c iddj = createPartner2IDDJunction(null, null);
            insert iddj;
            newPartner2IDDJunction = iddj;
        }
        return newPartner2IDDJunction;
    }

    public static IDD_Junction__c createPartner2IDDJunction(Id partnerId, Id invoiceDocumentDataId){
        if(partnerId == NULL)               partnerId               = TestFactory_StandardObjects.getPartnerAccount().Id;
        if(invoiceDocumentDataId == NULL)   invoiceDocumentDataId   = getInvoiceDocumentData().Id;

        IDD_Junction__c iddj            = (IDD_Junction__c)SmartFactory.createSObject('IDD_Junction__c',false);
        iddj.Partner_Account__c         = partnerId;
        iddj.Invoice_Document_Data__c   = invoiceDocumentDataId;

        return iddj;
    }
}