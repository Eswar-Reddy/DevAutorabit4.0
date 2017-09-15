/*
    Created By: Delivery Team
    Created On: Feb 2017

    Functions
    -----------------------------
    Create Purchase Order
    Submit PO to Oracle
*/
public class ResidentialProjectPurchaseOrder {
	public String projectId;
	public Residential_Project__c resProject;
	public List<StandardLineItem__c> lines {get; set;}
	public Ship_to_Site__c sts {get; set;}
	public Bill_To_Site__c bts {get; set;}
	public Purchase_Order__c purchaseOrder {get; set;}
	public String poId;
    public Integer numLines {get; set;}
    public Boolean hasPOLines = false;
    public Boolean showSubmitButton {get; private set;}
    public List<Purchase_Order_Line__c> poLines {get; set;}

	public ResidentialProjectPurchaseOrder(ApexPages.StandardController controller) {
		// set the number of lines
		numLines = 0;

		// hide submit button
		showSubmitButton = false;

		// get the residential project record id
		projectId = ApexPages.currentPage().getParameters().get('ProjectId');

		if(String.isNotBlank(projectId)) {
			try {
				// check to see if user is allowed to create purchase orders
				if(!ResidentialProjectValidationUtility.canCreate(projectId, 'Purchase_Order__c')) {
					SObjectException e = new SObjectException();
					e.setMessage('You do not have rights to create a purchase order for this project because you are not assigned to proper team member role.');
					throw e;
				}

				// get project details
				resProject = [SELECT Purchase_Order__c, Module_Configuration__c, Module_Configuration__r.Name, Number_of_Panels__c, Storage_Configuration__c, Storage_Configuration__r.Name, MonitoringIncluded__c, Mounting_Type__c, Community__r.Builder__c, Community__r.Builder__r.Name, Community__r.Builder__r.Primary_PSR__c, Community__r.Builder__r.RSM__c, Community__r.Builder__r.ParentId, Installation_Model__c, AdditionalBuilderServicesWoValue__c, Solar_Rebate_Actual__c, Rough_Wire_WO_Value__c, Builder_WO_Value__c, AddersValue__c, Rough_Labor_Pricing__c, Trim_Labor_Pricing__c FROM Residential_Project__c WHERE Id = :projectId];

				// check to make sure there isn't already a purchase order
				if(String.isNotBlank(resProject.Purchase_Order__c)) {
					SObjectException e = new SObjectException();
					e.setMessage('A Purchase Order has already been created for this Project!');
					throw e;
				}
				// check to make sure there's an installation model
				if(String.isBlank(resProject.Installation_Model__c)) {
					SObjectException e = new SObjectException();
					e.setMessage('There is no Installation Model for this Project. Please add one and retry.');
					throw e;
				}
				// setup the po
				purchaseOrder = new Purchase_Order__c();
				//Defaults
				purchaseOrder.Order_Status__c = 'New';
				purchaseOrder.Order_Type__c = 'NH SPEC';
				purchaseOrder.Sales_Type__c = 'Cash';
        		purchaseOrder.Number_of_Systems__c = 1;

				// calc delivery date placeholder
				Integer yr = Date.today().year();
				purchaseOrder.Requested_Delivery_Date__c = Date.newInstance(yr+1, 12, 31);

				purchaseOrder.Module_Quantity__c = resProject.Number_of_Panels__c;
				purchaseOrder.Dealer_Account__c = resProject.Community__r.Builder__c;

				if(String.isNotBlank(resProject.Community__r.Builder__r.Primary_PSR__c)) {
					purchaseOrder.Assigned_DSR__c = resProject.Community__r.Builder__r.Primary_PSR__c;
				}
				if(String.isNotBlank(resProject.Community__r.Builder__r.RSM__c)) {
					purchaseOrder.Assigned_RSM__c = resProject.Community__r.Builder__r.RSM__c;
				}
				// setup modules
				if(String.isNotBlank(resProject.Module_Configuration__c)) {
					purchaseOrder.Module_Type__c = resProject.Module_Configuration__r.Name;
					purchaseOrder.Module_Quantity__c = resProject.Number_of_Panels__c;
				} else {
					purchaseOrder.Module_Type__c = null;
					purchaseOrder.Module_Quantity__c = 0;
				}
				// check for monitoring
				if(resProject.MonitoringIncluded__c == 'Yes') {
					purchaseOrder.Monitoring_Quantity__c = 1;
					purchaseOrder.Monitoring_Opt_Out__c = false;
				} else {
					purchaseOrder.Monitoring_Quantity__c = 0;
				}
				// check for racking
				if(resProject.Mounting_Type__c == 'InvisiMount' || resProject.Mounting_Type__c == 'SolarMount') {
					purchaseOrder.Racking_Opt_Out__c = false;
		            purchaseOrder.Racking_Type__c = resProject.Mounting_Type__c;
		            purchaseOrder.Racking_Quantity__c = 1;
				} else {
					purchaseOrder.Racking_Opt_Out__c = true;
		            purchaseOrder.Racking_Type__c = null;
		            purchaseOrder.Racking_Quantity__c = 0;
				}
				// check for storage
				if(String.isNotBlank(resProject.Storage_Configuration__c)) {
					purchaseOrder.Storage__c = resProject.Storage_Configuration__r.Name;
				} else {
					purchaseOrder.Storage__c = null;
				}

				// check the ship to site
				Id stsId;
				Id installerAccountId;
				for(Alliance_Partner__c ap : [SELECT Partner_Account__c, Partner_Account__r.Default_Dealer_Warehouse_Shipping_Site__c FROM Alliance_Partner__c WHERE Residential_Project__c = :projectId AND Role__c = 'IP' ORDER BY LastModifiedDate DESC LIMIT 1]) {
					stsId = ap.Partner_Account__r.Default_Dealer_Warehouse_Shipping_Site__c;
					installerAccountId = ap.Partner_Account__c;
					purchaseOrder.Installer__c = installerAccountId;
				}
				if(String.isNotBlank(stsId)) {
					for(Ship_to_Site__c ss : [SELECT Id, Address__c, Address1__c, Address2__c, City__c, SiteID__c, State__c, Status__c, Zip__c FROM Ship_To_Site__c WHERE Id = :stsId]) {
						sts = ss;
						purchaseOrder.Ship_to_Site__c = ss.Id;
					}
				}
				if(sts == null) {
					ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'The Installer Account does NOT have a valid Ship to Site!');
                	ApexPages.addMessage(errorMsg);
				}

				// get/set the ship to contact
				if(String.isNotBlank(installerAccountId)) {
					for(AccountContactRole acr : [SELECT ContactId FROM AccountContactRole WHERE AccountId = :installerAccountId AND Role = 'Shipping Contact' ORDER BY IsPrimary DESC, LastModifiedDate DESC LIMIT 1]) {
						purchaseOrder.Ship_To_Contact__c = acr.ContactId;
						if(String.isNotBlank(acr.ContactId)) {
							for(Contact c : [SELECT Name, Phone FROM Contact WHERE Id = :acr.ContactId]) {
								purchaseOrder.Ship_To_Contact__r = c;
							}
						}
					}
				}
				// check the ship to contact
				if(String.isBlank(purchaseOrder.Ship_To_Contact__c)) {
					ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'The Installer Account does NOT have a valid Ship to Contact!');
            		ApexPages.addMessage(errorMsg);
				}

				// get/check the bill to site
				String btId;
				Boolean isParent = false;
				if(String.isNotBlank(resProject.Community__r.Builder__r.ParentId)) {
					btId = resProject.Community__r.Builder__r.ParentId;
 					isParent = true;
 				} else btId = purchaseOrder.Dealer_Account__c;
				if(String.isNotBlank(btId)) {
					for(Bill_To_Site__c b : [SELECT Id, Address1__c, City__c, State__c, Site_ID__c, Zip__c FROM Bill_To_Site__c WHERE Dealer_Account__c = :btId AND Active__c = true AND Site_ID__c > '0' AND Oracle_Operating_Unit_Code__c = 'SPEB OU' ORDER BY LastModifiedDate DESC LIMIT 1]) {
						bts = b;
						purchaseOrder.Bill_to_Site__c = b.Id;
					}
					// set the dealer account
					if(!isParent) {
 						for(Account a : [SELECT Name FROM Account WHERE Id = :btId]) {
 							purchaseOrder.Dealer_Account__r = a;
 						}
 					} else {
 						for(Account a : [SELECT Name FROM Account WHERE Id = :purchaseOrder.Dealer_Account__c]) {
 							purchaseOrder.Dealer_Account__r = a;
 						}
					}
				}
				if(bts == null) {
					ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'The Builder Account does NOT have a valid Bill to Site!');
            		ApexPages.addMessage(errorMsg);
				}
				// get the item lines from the project
				lines = [SELECT Item__r.Item_ID__c, Item__r.Description__c, Quantity__c FROM StandardLineItem__c WHERE Residential_Project__c = :projectId ORDER BY Name];
				// reset the number of lines
				numLines = lines.size();
				// initalize the po lines
				poLines = new List<Purchase_Order_Line__c>();
			}
			catch(Exception e) {
				System.debug(e.getStackTraceString());
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() + ' - ' + e.getStackTraceString());
                ApexPages.addMessage(errorMsg);
			}
		} else {
			ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'The Project Id is missing! Please close the page and try again.');
            ApexPages.addMessage(errorMsg);
		}
	}

	public PageReference init() {
		if(ApexPages.hasMessages()) return null;
		try {
			if(purchaseOrder != null) {
				// check for lines
				if(numLines == 0) {
					SObjectException e = new SObjectException();
					e.setMessage('There are no standard line items for this Project. Please either click the Create Material Lines button or manually add the lines to the Project and try again.');
					throw e;
				}
				// insert the purchase order
				insert purchaseOrder;
				poId = purchaseOrder.Id;
                // create the service lines from the installation model
				createServiceLines();
                // create the material lines
                createMaterialLines();
                // make sure lines got created
				if(!hasPOLines) {
					SObjectException e = new SObjectException();
					e.setMessage('Sorry we are not able to create Purchase Order Lines for this order. Please manually add the lines to the Project and try again.');
					throw e;
				} else {
					showSubmitButton = true;
				}
			} else {
				SObjectException e = new SObjectException();
				e.setMessage('Sorry we are not able to create a Purchase Order for this Project.');
				throw e;
			}
		}
		catch(Exception e) {
			ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() + ' - ' + e.getStackTraceString());
            ApexPages.addMessage(errorMsg);
		}
		return null;
	}

	public PageReference createServiceLines() {
		Integer lineNum = 1;
		// get the service lines from the installation model
		for(POLineFeeSetup__c l : [SELECT Percentage__c, Item__c, Item__r.Description__c, Item__r.Item_ID__c, Value_From__c FROM POLineFeeSetup__c WHERE Model__c = :resProject.Installation_Model__c AND Item__c != null AND Value_From__c != null]) {
			// get the amount from the project record
			Decimal percent = l.Percentage__c != null ? l.Percentage__c : 100;
			Decimal amount = (Decimal)resProject.get(l.Value_From__c);
			if(amount > 0) {
				amount = amount * percent/100;
				// create service line
				Purchase_Order_Line__c pol = new Purchase_Order_Line__c();
				pol.Purchase_Order__c = poId;
				pol.Oracle_Item_ID__c = l.Item__c;
				pol.Quantity__c = amount.round(System.RoundingMode.UP);
				pol.Unit_Price__c = 1;
				pol.Price__c = amount.round(System.RoundingMode.UP);
				pol.Item_Description__c = l.Item__r.Description__c;
				pol.Item_ID__c = l.Item__r.Item_ID__c;
				pol.Item_Number__c = l.Item__r.Item_ID__c;
				pol.Order_Line_Number__c = String.valueOf(lineNum);
				poLines.add(pol);
				lineNum++;
			}
		}
		return null;
	}

	public PageReference createMaterialLines() {
		try {
			// setup po lines
			Integer lineNum = poLines.size()+1;
			for(StandardLineItem__c sli : lines) {
				Purchase_Order_Line__c pol = new Purchase_Order_Line__c();
				pol.Purchase_Order__c = poId;
				pol.Oracle_Item_ID__c = sli.Item__c;
				pol.Quantity__c = sli.Quantity__c;
				pol.Item_Description__c = sli.Item__r.Description__c;
				pol.Item_ID__c = sli.Item__r.Item_ID__c;
				pol.Item_Number__c = sli.Item__r.Item_ID__c;
				pol.Order_Line_Number__c = String.valueOf(lineNum);
				poLines.add(pol);
				lineNum++;
			}
			// insert po lines
			if(poLines.size() > 0) {
				numLines = poLines.size();
				insert poLines;
				hasPOLines = true;
			}
		}
		catch(Exception e) {
			ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() + ' - ' + e.getStackTraceString());
            ApexPages.addMessage(errorMsg);
		}
		return null;
	}

    public PageReference psrSubmitOrder() {
    	if(ApexPages.hasMessages()) return null;
        try {
        	update purchaseOrder;
        	resProject.Purchase_Order__c = purchaseOrder.Id;
        	update resProject;
            PageReference pg = new PageReference('/apex/OracleOrderSubmission?poId='+purchaseOrder.Id+'&projectId='+projectId);
            return pg.setRedirect(true);

        } catch(Exception e) {
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() + ' - ' + e.getStackTraceString());
            ApexPages.addMessage(errorMsg);
        }
        return null;
    }
}