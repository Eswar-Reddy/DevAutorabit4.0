/*
    Created By: Delivery Team
    Created On: Feb 2017

    Functions
    -----------------------------
    Submit PO to Oracle
	Resubmit PO to Oracle on error
*/
public with sharing class OracleOrderSubmissionController {
	public Ship_to_Site__c sts {get; set;}
	public Bill_To_Site__c bts {get; set;}
	public Purchase_Order__c purchaseOrder {get; set;}
	public List<Purchase_Order_Line__c> lines {get; set;}
	public String poId;
    public String projectId;
	public Integer retries {get; private set;}
    public Integer numLines {get; set;}
    public Boolean showSubmitButton {get; private set;}

	public OracleOrderSubmissionController(ApexPages.StandardController controller) {
		// set retries for real time ordering
		retries = 0;

		// set the number of lines
		numLines = 0;

		// hide submit button
		showSubmitButton = false;

		// get the po record id
		poId = ApexPages.currentPage().getParameters().get('poId');
        // get the project id
        projectId = ApexPages.currentPage().getParameters().get('projectId');

		if(String.isNotBlank(poId)) {
			try {
				// get/set po details
				for(Purchase_Order__c p : [SELECT Ship_To_Contact__c, Ship_To_Contact__r.Name, Special_Instructions__c, Name, Id, Contact_ID__c, Oracle_Order_Number__c, Order_Status_Interface_Message__c, Ship_To_Contact__r.Phone, Order_Total__c, Requested_Delivery_Date__c, Bill_to_site__c, Ship_to_site__c, Dealer_Account__r.Name, Order_Status__c, Interface_Status__c, Bill_To_Contact__r.Oracle_Contact_id__c, Ship_To_Contact__r.Oracle_Contact_id__c, (SELECT Order_Line_Number__c, Item_ID__c, Item_Description__c, Quantity__c, Unit_Price__c, Price__c FROM Purchase_Order_Lines__r) FROM Purchase_Order__c WHERE Id = :poId]) {
                	purchaseOrder = p;
                	// get the line items
					lines = p.Purchase_Order_Lines__r;
					// reset the number of lines
					numLines = lines.size();
                    // get the ship to site details
                    for(Ship_to_Site__c ss : [SELECT Id, Address__c, Address1__c, City__c, SiteID__c, State__c, Status__c, Zip__c FROM Ship_To_Site__c WHERE Id = :purchaseOrder.Ship_to_site__c]) {
                        sts = ss;
                    }
                    // get the bill to site details
                    for(Bill_To_Site__c b : [SELECT Id, Address1__c, City__c, State__c, Site_ID__c, Zip__c FROM Bill_To_Site__c WHERE Id = :purchaseOrder.Bill_To_Site__c]) {
                        bts = b;
                    }
                }
			}
			catch(Exception e) {
				System.debug(e.getStackTraceString());
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
                ApexPages.addMessage(errorMsg);
			}
		} else {
			ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'The Purchase Order Id is missing! Please close the page and try again.');
            ApexPages.addMessage(errorMsg);
		}
	}

	public PageReference init() {
		if(ApexPages.hasMessages()) return null;
		try {
			if(String.isBlank(purchaseOrder.Oracle_Order_Number__c) && numLines > 0) {
				ResultMessage result = OracleOrderUtility.SendNewResidentialProjectOrder(poId, projectId);
	            checkResult(result);
			}
		}
		catch(Exception e) {
			ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(errorMsg);
		}
		return null;
	}

    public PageReference reSubmitOrder() {
        // check retries
        if(retries < 2) {
            retries++;
            ResultMessage result = OracleOrderUtility.SendNewResidentialProjectOrder(poId, projectId);
            checkResult(result);
            if(String.isNotBlank(purchaseOrder.Oracle_Order_Number__c)) {
                PageReference pg = new PageReference('/apex/OracleOrderSubmission?poId='+purchaseOrder.Id+'&projectId='+projectId);
                return pg.setRedirect(true);
            }
        }
        return null;
    }

    public PageReference checkResult(ResultMessage result){
        //SAMPLE Result.message {"sales_order_response": {"status": "S", "status_message": "Successfully Processed", "sales_order_response_header": {"order_number": "12217702"}}}
        try{
            // insert logs
            if(!result.logs.isEmpty()) {
                SpectrumDebugUtility.generateDebugLog(result.logs);
            }
            // check result
            if(result.success) {
                // deserialize the message
                OracleOrderUtility.InformaticaCreateOrderResponse response = (OracleOrderUtility.InformaticaCreateOrderResponse)JSON.deserialize(result.message, OracleOrderUtility.InformaticaCreateOrderResponse.class);
                // set vars
                String status = response.sales_order_response.status;
                String statusMessage = response.sales_order_response.status_message;
                String orderNumber = response.sales_order_response.sales_order_response_header.order_number;
                String oracleId = response.sales_order_response.sales_order_response_header.header_id;

                // setup the project record for potential update
                Residential_Project__c resProject = new Residential_Project__c();
                resProject.Id = projectId;

                // check the Oracle status
                if(status == 'S' || status == 'E' && String.isNotBlank(orderNumber)) {
                    purchaseOrder.Oracle_Order_Number__c = orderNumber;
                    purchaseOrder.OracleOrderHeaderId__c = oracleId;
                    purchaseOrder.Order_Status__c = 'Processed';
                    purchaseOrder.Order_Status_Interface_Message__c = statusMessage;
                    resProject.OracleOrderHeaderId__c = oracleId;
                    resProject.Sales_Order_Number__c = orderNumber;
                    update resProject;
                } else {
                    // Oracle error
                    purchaseOrder.Order_Status__c = 'Error';
                    purchaseOrder.Order_Status_Interface_Message__c = statusMessage;
                }
            } else {
                // check for timeout error
                if(result.message.containsIgnoreCase('timeout') || result.message.containsIgnoreCase('timed out')) {
                    purchaseOrder.Order_Status__c = 'Timeout Error';
                    purchaseOrder.Order_Status_Interface_Message__c = result.message;
                } else {
                    purchaseOrder.Order_Status__c = 'Error';
                    purchaseOrder.Order_Status_Interface_Message__c = result.message;
                }
            }
            // update the purchase order
            update purchaseOrder;

            if(purchaseOrder.Order_Status__c == 'Error') {
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, purchaseOrder.Order_Status_Interface_Message__c);
                ApexPages.addMessage(errorMsg);
            }
        }
        catch(Exception e){
            String strError = e.getMessage() + ' - ' + e.getStackTraceString();

            if(purchaseOrder != null) {
                purchaseOrder.Order_Status__c = 'Error';
                purchaseOrder.Order_Status_Interface_Message__c = strError;
                update purchaseOrder;
            }

            if(String.isNotBlank(poId)) {
                SpectrumDebugUtility.createExceptionLog(e.getMessage(), e.getStackTraceString(), 'SO Oracle Order Error', poId);
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, strError);
                ApexPages.addMessage(errorMsg);
            } else {
                SpectrumDebugUtility.createExceptionLog(e.getMessage(), e.getStackTraceString(), 'SO Oracle Order Error');
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, strError);
                ApexPages.addMessage(errorMsg);
            }
        }
        return null;
    }
}