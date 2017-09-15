public without sharing class InvoiceComplianceDocumentUtility {
    public static final String INSTALL_TYPE = 'Install';
    public static final String INTERCONNECT_TYPE = 'Interconnect';
    public static final String ORIGINATION_TYPE = 'Origination';

    // used by the residential project after insert & update handlers to create icd's
    @future
    public static void createInvoiceComplianceDocuments(Set<Id> rpIds) {
        List<Residential_Project__c> projects = new List<Residential_Project__c>();
        List<Id> imList = new List<Id>(); // List of installation model Ids from lease payment's quote
        Map<Id, List<Alliance_Partner__c>> partnerMap = new Map<Id, List<Alliance_Partner__c>>();
        Set<Id> partnerIds = new Set<Id>();
        Map<Id, List<IDD_Junction__c>> imJunctionMap = new Map<Id, List<IDD_Junction__c>>(); //Key: Installation Model Id, Value: List of related IDD Junctions
        Map<Id, List<IDD_Junction__c>> paJunctionMap = new Map<Id, List<IDD_Junction__c>>(); //Key: Partner Account Id, Value: List of related IDD Junctions
        List<Invoice_Compliance_Document__c> invDocsToInsert = new List<Invoice_Compliance_Document__c>();
		// Variables to associate the Project Task to Invoice Compliance Document.
        Set<Id> templateIds = new Set<Id>();
        Map<Id,Map<Id,Id>> templateWithIDDandTemplateTask = new Map<Id,Map<Id,Id>>();
        Map<Id,Map<Id,Id>> templateTaskWithProjectTask = new Map<Id,Map<Id,Id>>();

        try {
	        for(Residential_Project__c rp : [SELECT Installation_Model__c, Quote__r.Account.Partner_Account__r.iSupplier__c, Quote__r.Consolidated_Lease_Number__c, Quote__r.System_Model__c, Quote__r.Account.BillingState,Project_Template__c,(SELECT Id,Name,Template_Task__c FROM Project_Tasks__r) FROM Residential_Project__c WHERE Id IN :rpIds]) {
	            projects.add(rp);
	            imList.add(rp.Installation_Model__c);
				if(rp.Project_Template__c != Null)templateIds.add(rp.Project_Template__c);
	            // populate map
	            if(!partnerMap.containsKey(rp.Id)) {
	                partnerMap.put(rp.Id, new List<Alliance_Partner__c>());
	            }
				if(!templateTaskWithProjectTask.containsKey(rp.Id)) templateTaskWithProjectTask.put(rp.Id,new Map<Id,Id>());
                for(Project_Task__c pt : rp.Project_Tasks__r){
                    templateTaskWithProjectTask.get(rp.Id).put(pt.Template_Task__c,pt.Id);
                }
	        }
	        // get list of partners
	        for(Alliance_Partner__c ap : [SELECT Partner_Account__c, Residential_Project__c, Role__c FROM Alliance_Partner__c WHERE Residential_Project__c IN :rpIds]) {
	            // add partner id
	            partnerIds.add(ap.Partner_Account__c);
	            // populate map
	            partnerMap.get(ap.Residential_Project__c).add(ap);
	        }

			// getting the Template Task Id based on the templateIds.
            if(!templateIds.isEmpty()) templateWithIDDandTemplateTask = templateWithIDDandTemplateTask(templateIds);

	        // Query for all junction records based on the installation model from the imList above
	        for(IDD_Junction__c iddj : [SELECT  Id, Installation_Model__c, Installation_Model__r.Country__c, Installation_Model__r.Financing_Option__c, Invoice_Document_Data__c, Invoice_Document_Data__r.Not_Required_For_Approval__c, Invoice_Document_Data__r.Name, Invoice_Document_Data__r.Sharing_Type__c, Shared_With__c, Partner_Account__c, Partner_Account__r.BillingCountry, Document_Owner__c, State__c, Invoice_Type__c, System_Type__c, Document_Upload_Location__c,iSupplier__c
	            FROM IDD_Junction__c
	            WHERE Installation_Model__c IN: imList OR Partner_Account__c IN: partnerIds]){

	            // Populate map with all Junction records related to an Installation Model
	            if(String.isNotBlank(iddj.Installation_Model__c)){
	                if(imJunctionMap.containsKey(iddj.Installation_Model__c)) {
	                    imJunctionMap.get(iddj.Installation_Model__c).add(iddj);
	                } else {
	                    imJunctionMap.put(iddj.Installation_Model__c, new List<IDD_Junction__c>{iddj});
	                }
	            } else if(String.isNotBlank(iddj.Partner_Account__c)){
	                if(paJunctionMap.containsKey(iddj.Partner_Account__c)){
	                    paJunctionMap.get(iddj.Partner_Account__c).add(iddj);

	                } else {
	                    paJunctionMap.put(iddj.Partner_Account__c, new List<IDD_Junction__c>{iddj});
	                }
	            }
	        }

	        for(Residential_Project__c rp : projects) {
	            // Define list of Junctions related to this lease payments installation model or partner account
	            Map<Id, IDD_Junction__c> junctions = new Map<Id, IDD_Junction__c>(); // put in a map to weed out duplicates
	            if(imJunctionMap.containsKey(rp.Installation_Model__c)) {
	                for(IDD_Junction__c iddj : imJunctionMap.get(rp.Installation_Model__c)){
	                    junctions.put(iddj.Id, iddj);
	                }
	            }

	            if(partnerMap.containsKey(rp.Id)) {
	                for(Alliance_Partner__c ap : partnerMap.get(rp.Id)) {
	                    if(!paJunctionMap.isEmpty() && ap.Partner_Account__c != NULL){
	                        for(IDD_Junction__c iddj : paJunctionMap.get(ap.Partner_Account__c)){
	                          junctions.put(iddj.Id, iddj);
	                        }
	                    }
	                }
	            }

	            // Run IDDs through criteria filter
	            List<IDD_Junction__c> validJunctions = iddCriteriaUtility(junctions.values(), rp, partnerMap.containsKey(rp.Id) ? partnerMap.get(rp.Id) : null);

	            for(IDD_Junction__c junc : validJunctions){
	                // create icds
	                Invoice_Compliance_Document__c invDoc = new Invoice_Compliance_Document__c();
	                String name = rp.Quote__r.Consolidated_Lease_Number__c + ' [' + junc.Invoice_Document_Data__r.Name + ']';
					invDoc.Name                         = name.length() > 80 ? name.left(80) : name;
	                invDoc.Documents_in_File__c         = junc.Invoice_Document_Data__r.Name;
	                invDoc.FinancingType__c             = junc.Installation_Model__r.Financing_Option__c;
	                invDoc.Invoice_Type__c              = junc.Invoice_Type__c;
	                invDoc.Document_Owner__c            = junc.Document_Owner__c;
	                invDoc.Shared_With__c               = junc.Shared_With__c;
	                invDoc.Not_Required_For_Approval__c = junc.Invoice_Document_Data__r.Not_Required_For_Approval__c;
	                invDoc.Residential_Project__c       = rp.Id;
					invDoc.Invoice_Document_Data__c     = junc.Invoice_Document_Data__c;
					if(!templateTaskWithProjectTask.isEmpty() && !templateWithIDDandTemplateTask.isEmpty() && templateTaskWithProjectTask.containskey(rp.Id) && templateWithIDDandTemplateTask.containsKey(rp.Project_Template__c) && templateWithIDDandTemplateTask.get(rp.Project_Template__c).containsKey(junc.Invoice_Document_Data__c) && templateTaskWithProjectTask.get(rp.Id).containsKey(templateWithIDDandTemplateTask.get(rp.Project_Template__c).get(junc.Invoice_Document_Data__c))){
                        invDoc.Project_Task__c          = templateTaskWithProjectTask.get(rp.Id).get(templateWithIDDandTemplateTask.get(rp.Project_Template__c).get(junc.Invoice_Document_Data__c));
                    }
					// set responsible parter if possible
                    if(partnerMap.containsKey(rp.Id)) {
	                    for(Alliance_Partner__c ap : partnerMap.get(rp.Id)) {
	                        if(String.isNotBlank(ap.Partner_Account__c) && ap.Role__c == junc.Document_Owner__c) {
	                        	invDoc.Responsible_Partner__c = ap.Partner_Account__c;
	                        }
	                    }
	                }
	                invDocsToInsert.add(invDoc);
	            }
	        }
	        insert invDocsToInsert;
	    } catch(Exception e) {
	    	ExLog.log(e);
	    }
    }

    public static List<IDD_Junction__c> iddCriteriaUtility(List<IDD_Junction__c> idds, Residential_Project__c rp, List<Alliance_Partner__c> aps){
        String installationModel = rp.Installation_Model__c;
        String systemModel = rp.Quote__r.System_Model__c;
        String rpState = rp.Quote__r.Account.BillingState;

        // Loop through each junction and identify if it meets additional criteria
        List<IDD_Junction__c> validJunctions = new List<IDD_Junction__c>();
        for(IDD_Junction__c junc : idds){
            Boolean valid = TRUE;

            // Discard Junciton records if the Installation Model doesn't match the Installation Model defined on the residential project
            if(String.isNotBlank(junc.Installation_Model__c)){
                if(installationModel != junc.Installation_Model__c) valid = FALSE;
            }

            // Discard Junction if Country = United States and State doesn't match
            if(String.isNotBlank(junc.State__c) && (String.isNotBlank(junc.Installation_Model__c) && junc.Installation_Model__r.Country__c == 'United States' || String.isNotBlank(junc.Partner_Account__c) && junc.Partner_Account__r.BillingCountry == 'United States')){
                if(String.isBlank(rpState)) {
                    valid = FALSE;
                } else if(!junc.State__c.contains(rpState)) {
                    valid = FALSE;
                }
            }

            // Discard Junction if the System Type doesn't match
            if(String.isNotBlank(junc.System_Type__c)){
                if(String.isBlank(systemModel)) {
                    valid = FALSE;
                } else {
                    String systemType = systemModel.contains('-AC') ? 'AC' : 'DC';
                    if(!junc.System_Type__c.contains(systemType)) valid = FALSE;
                }
            }

            // Discard Junction records if the Partner Account doesn't match one the alliance partner accounts
            if(String.isNotBlank(junc.Partner_Account__c)){
                Boolean partnerMatch = FALSE;
                if(aps != null) {
                    for(Alliance_Partner__c ap : aps) {
                        if(junc.Partner_Account__c == ap.Partner_Account__c && junc.Document_Owner__c == ap.Role__c) partnerMatch = TRUE;
                    }
                }
                if(!partnerMatch) valid = FALSE;
            }

            if(rp.Quote__r.Account.Partner_Account__r.iSupplier__c && junc.iSupplier__c == 'NO') valid = FALSE;

            if(!rp.Quote__r.Account.Partner_Account__r.iSupplier__c && junc.iSupplier__c == 'YES') valid = FALSE;

            if(valid) validJunctions.add(junc);
        }
        return validJunctions;
    }

    /*
        @Name        : rollups_Count
        @description : calculate the count of different fields in invoice complinace and update the lease payment.
        @parameters  : oldList,newList,newMap,oldmap
        @returns     : Null
    */
    public static void rollups_Count(Map<Id, Invoice_Compliance_Document__c> oldMap, Map<Id, Invoice_Compliance_Document__c> newMap) {
        Set<Id> idFpo = new Set<Id>();
        List<LeasePayment__c> fpo_lst = new List<LeasePayment__c>();
        integer installApproved = 0,installSubmitted = 0,installTotal = 0, originationApproved = 0,originationSubmitted =0,originationTotal = 0, interConnectApproved = 0,interConnectSubmitted = 0,interConnectTotal = 0;

        try {
	        for(Invoice_Compliance_Document__c icd : newMap.values()) {
	            idFpo.add(icd.Financial_Payment__c);
	        }

	        for(LeasePayment__c fpo : [SELECT Id, Name, Approved_Install_Docs__c, Approved_Origination_Docs__c, Approved_Interconnect_Docs__c, Submitted_Install_Docs__c, Submitted_Origination_Docs__c, Submitted_Interconnect_Docs__c, Total_Install_Docs__c, Total_Origination_Docs__c, Total_Interconnect_Docs__c, (SELECT Id,  Invoice_Type__c, Status__c FROM Invoice_Compliance_Documents__r) FROM LeasePayment__c WHERE Id IN: idFpo]){
	            for(Invoice_Compliance_Document__c icd : fpo.Invoice_Compliance_Documents__r) {
	                if(icd.Invoice_type__c == 'Install') {
	                    installTotal = installTotal + 1;
	                	if(icd.status__c == 'Approved') installApproved++;
	                	if(icd.status__c == 'Pending'|| icd.status__c == 'Approved') installSubmitted++;
	                }
	                if(icd.Invoice_type__c == 'Origination') {
	                    originationTotal++;
	                	if(icd.status__c == 'Approved') originationApproved++;
	                	if(icd.status__c == 'Pending'|| icd.status__c=='Approved') originationSubmitted++;

	                }
	                if(icd.Invoice_type__c == 'Interconnect') {
	                    interConnectTotal++;
	                	if(icd.status__c == 'Approved') interConnectApproved++;
	                	if(icd.status__c == 'Pending'|| icd.status__c == 'Approved') interConnectSubmitted++;
	                }
	            }

	            if(fpo.Approved_Install_Docs__c != installApproved || fpo.Approved_Origination_Docs__c != originationApproved || fpo.Approved_Interconnect_Docs__c != interConnectApproved || fpo.Submitted_Install_Docs__c != installSubmitted || fpo.Submitted_Origination_Docs__c != originationSubmitted || fpo.Submitted_Interconnect_Docs__c != interConnectSubmitted || fpo.Total_Install_Docs__c != installTotal || fpo.Total_Origination_Docs__c != originationTotal || fpo.Total_Interconnect_Docs__c != interConnectTotal) {

	            	fpo_lst.add(new LeasePayment__c(Id = fpo.Id, Approved_Install_Docs__c = installApproved, Approved_Origination_Docs__c = originationApproved, Approved_InterConnect_Docs__c = interConnectApproved, Submitted_Install_Docs__c = installSubmitted, Submitted_Origination_Docs__c = originationSubmitted,Submitted_InterConnect_Docs__c = interConnectSubmitted, Total_Install_Docs__c = installTotal, Total_Origination_Docs__c = originationTotal, Total_InterConnect_Docs__c = interConnectTotal));
	            }
	        }

	       if(!fpo_lst.isEmpty()){
	            Database.SaveResult[] srList = Database.update(fpo_lst, FALSE);
	            // Iterate through each returned result
	            for (Database.SaveResult sr : srList) {
	                // Operation failed, so get all errors
	                for(Database.Error err : sr.getErrors()) {
	                    newMap.get(sr.getId()).addError(err.getMessage());
	                }
	            }
	        }
	    } catch(Exception e) {
	    	ExLog.log(e);
	    }
    }

    public static Map<String, String> typeToField {
        get {
            if(typeToField == NULL) {
                typeToField = new Map<String, String>();
                typeToField.put(INSTALL_TYPE, 'Install_Pymnt_Apprvd__c');
                typeToField.put(INTERCONNECT_TYPE, 'Intrcnct_Pymnt_Apprvd__c');
                typeToField.put(ORIGINATION_TYPE, 'Origination_Payment_Approved__c');
            }
            return typeToField;
        }
        private set;
    }

    public static void setApprovedField(List<Invoice_Compliance_Document__c> approvedDocs) {
		try {
			Set<Id> leaseIds = new Set<Id>();
			Map<Id, LeasePayment__c> leasesToUpdate = new Map<Id, LeasePayment__c>();

			for(Invoice_Compliance_Document__c doc : approvedDocs){
				if(String.isNotBlank(doc.Financial_Payment__c)) leaseIds.add(doc.Financial_Payment__c);
			}

			if(!leaseIds.isEmpty()){
				for(LeasePayment__c lp : [SELECT Id, Install_Pymnt_Apprvd__c, Intrcnct_Pymnt_Apprvd__c, Origination_Payment_Approved__c, (SELECT Invoice_Type__c, Status__c FROM Invoice_Compliance_Documents__r WHERE Not_Required_for_Approval__c = false) FROM LeasePayment__c WHERE Id IN :leaseIds]) {

					Map<String, Boolean> typeToAllApproved = new Map<String, Boolean>();

					for(Invoice_Compliance_Document__c doc : lp.Invoice_Compliance_Documents__r){
						Boolean previousApproved = (typeToAllApproved.containsKey(doc.Invoice_Type__c)) ? typeToAllApproved.get(doc.Invoice_Type__c) : TRUE;
						typeToAllApproved.put(doc.Invoice_Type__c, doc.Status__c == 'Approved' && previousApproved);
					}
					if(!leasesToUpdate.containsKey(lp.Id)) {
						leasesToUpdate.put(lp.Id, lp);
					}
					lp = leasesToUpdate.get(lp.Id);

					for(String invoiceType : typeToField.keySet()) {
						if(lp.get(typeToField.get(invoiceType)) == NULL && typeToAllApproved.containsKey(invoiceType) && typeToAllApproved.get(invoiceType)) {
							lp.put(typeToField.get(invoiceType), Date.today());
						}
					}
				}
				if(!leasesToUpdate.isEmpty()) update leasesToUpdate.values();
			}
		} catch(Exception e) {
			ExLog.log(e);
		}
	}

	public static void removeApprovedField(List<Invoice_Compliance_Document__c> unApprovedDocs) {
		try {
			Map<Id, LeasePayment__c> fpoToUpdateMap = new Map<Id, LeasePayment__c>();

			for(Invoice_Compliance_Document__c doc : unApprovedDocs) {
				if(!fpoToUpdateMap.containsKey(doc.Financial_Payment__c)) {
					fpoToUpdateMap.put(doc.Financial_Payment__c, new LeasePayment__c(Id = doc.Financial_Payment__c));
				}
				LeasePayment__c lp = fpoToUpdateMap.get(doc.Financial_Payment__c);

				if(typeToField.containsKey(doc.Invoice_Type__c))  lp.put(typeToField.get(doc.Invoice_Type__c), NULL);
			}
			if(!fpoToUpdateMap.isEmpty()) update fpoToUpdateMap.values();
		} catch(Exception e) {
			ExLog.log(e);
		}
	}

	public static void createRejectionReasons(List<Invoice_Compliance_Document__c> rejectedICDs, Map<Id, Invoice_Compliance_Document__c> oldICDMap) {
        try {
            //Create a empty list for insert
            List<ICD_Status_Changed_Reason__c> newRejectedReasons = new List<ICD_Status_Changed_Reason__c>();

            //Set each field of rejectedReason
            for(Invoice_Compliance_Document__c rejectedICD : rejectedICDs){
                ICD_Status_Changed_Reason__c rejectedReason = new ICD_Status_Changed_Reason__c();
                rejectedReason.Invoice_Compliance_Document__c = rejectedICD.Id;
                rejectedReason.Name = (rejectedICD.Number_of_Times_Rejected__c + 1).format();
                rejectedReason.Document_Submitted__c = oldICDMap.get(rejectedICD.Id).Document_Submitted__c;
                rejectedReason.Notes_to_Partner__c = rejectedICD.Notes_to_Partner__c;
                rejectedReason.Response_Date__c = Date.today();
                rejectedReason.Link_to_Document__c = oldICDMap.get(rejectedICD.Id).Link_to_Attachment__c;

                newRejectedReasons.add(rejectedReason);
            }
            if(!newRejectedReasons.isEmpty()) insert newRejectedReasons;
        } catch(Exception e) {
            ExLog.log(e);
        }
    }

    // Expecting a list of ICD records that are newly approved
    public static void setRequiredDocumentsApprovedFlag(List<Invoice_Compliance_Document__c> icds) {
        Set<String> lpIdSet     = new Set<String>();
        Set<String> rpIdSet     = new Set<String>();
        Set<String> invTypeSet  = new Set<String>();
        Set<String> keySet      = new Set<String>();
        Set<String> approvedKeySet = new Set<String>();
        Map<Id, Invoice_Compliance_Document__c> icdMap = new Map<Id, Invoice_Compliance_Document__c>();

        try {
	        for(Invoice_Compliance_Document__c doc : icds) {
	            if(String.isNotBlank(doc.Financial_Payment__c))    lpIdSet.add(doc.Financial_Payment__c);
	            if(String.isNotBlank(doc.Invoice_Type__c))          invTypeSet.add(doc.Invoice_Type__c);
	            if(String.isNotBlank(doc.Responsible_Partner__c))  rpIdSet.add(doc.Responsible_Partner__c);
	            icdMap.put(doc.Id, doc);
	        }

	        // Query a list of documents that meet criteria and are required for approval but not Approved
	        // Create a set of keys where at least one record in that key is required for approval but is not Approved
	        if(!lpIdSet.isEmpty()) {
	            for(LeasePayment__c lp :    [SELECT Id, (SELECT Id, Invoice_Type__c, Financial_Payment__c, Not_Required_for_Approval__c, Responsible_Partner__c, Status__c
	                                        FROM Invoice_Compliance_Documents__r
	                                        WHERE Invoice_Type__c IN: invTypeSet AND Not_Required_for_Approval__c = false AND Status__c != 'Approved' AND Responsible_Partner__c IN: rpIdSet)
	                                        FROM LeasePayment__c
	                                        WHERE Id IN :lpIdSet]){
	                for(Invoice_Compliance_Document__c doc : lp.Invoice_Compliance_Documents__r) {
	                	if(!icdMap.containsKey(doc.Id)) keySet.add(getKey(doc));
	                }
	            }

	            // If newly Approved ICD is the last ICD in it's key to be approved, mark Approved Notification to true.
	            // Only one ICD in each key needs to be marked Approved Notification
	            for(Invoice_Compliance_Document__c doc : icds){
	                String key = getKey(doc);
	                if(!keySet.contains(key) && !approvedKeySet.contains(key)) {
	                    doc.Approved_Notification__c = true;
	                    approvedKeySet.add(key);
	                }
	            }
	        }
	    } catch(Exception e) {
	    	ExLog.log(e);
	    }
    }

    private static String getKey(Invoice_Compliance_Document__c doc) {
        String key;
        if(String.isNotBlank(doc.Financial_Payment__c) && String.isNotBlank(doc.Responsible_Partner__c) && String.isNotBlank(doc.Invoice_Type__c)) {
            key = doc.Financial_Payment__c + '_' + doc.Responsible_Partner__c + '_' + doc.Invoice_Type__c;
        }
        return key;
    }

    // called by the alliance partner after update & after insert handlers
    @future
    public static void setICDforAPs(Set<Id> apIds) {
        Map<Id, List<Alliance_Partner__c>> apList = new Map<Id, List<Alliance_Partner__c>>();
        List<Invoice_Compliance_Document__c> icds = new List<Invoice_Compliance_Document__c>();

        try {
	        // get all the alliance parters for projects
	        for(Alliance_Partner__c ap : [SELECT Residential_Project__c, Partner_Account__c, Role__c FROM Alliance_Partner__c WHERE Id IN :apIds]) {
	            if(apList.containsKey(ap.Residential_Project__c)) {
	                apList.get(ap.Residential_Project__c).add(ap);
	            } else {
	                apList.put(ap.Residential_Project__c, new List<Alliance_Partner__c>{ap});
	            }
	        }
	        if(!apList.isEmpty()) {
	            // get all the valid icds for projects
	            for(Invoice_Compliance_Document__c icd : [SELECT Residential_Project__c, Document_Owner__c, Responsible_Partner__c FROM Invoice_Compliance_Document__c WHERE  Residential_Project__c IN : apList.keySet() AND (Document_Owner__c != NULL OR Document_Owner__c != '')]) {
	                // loop over alliance partners to match up doc owner & role
	                for(Alliance_Partner__c ap : apList.get(icd.Residential_Project__c)) {
	                    if(icd.Document_Owner__c == ap.Role__c) {
	                        icd.Responsible_Partner__c = ap.Partner_Account__c;
	                        icds.add(icd);
	                    }
	                }
	            }
	        }
	        if(!icds.isEmpty()) update icds;
	    } catch(Exception e) {
	    	ExLog.log(e);
	    }
    }

    // called by the alliance parter after delete handler
    public static void updateICDs4DeletedAPs(Map<Id, Map<Id, String>> apRPs) {
        List<Invoice_Compliance_Document__c> icds = new List<Invoice_Compliance_Document__c>();

        try {
	        // get a set of rp ids to narrow query
	        Set<Id> rpIds = new Set<Id>();
	        for(Map<Id, String> rpRole : apRPs.values()) {
	            rpIds.addAll(rpRole.keySet());
	        }

	        // update the icds with null responsible party for deleted partners
	        for(Invoice_Compliance_Document__c icd : [SELECT Id, Document_Owner__c, Responsible_Partner__c, Residential_Project__c FROM Invoice_Compliance_Document__c WHERE Responsible_Partner__c IN :apRPs.keySet() AND Residential_Project__c IN :rpIds]) {
	            // get the map of rp id / role for deleted ap
	            Map<Id, String> rpRole = apRPs.get(icd.Responsible_Partner__c);
	            for(Id rpId : rpRole.keySet()) {
	                // make sure the project and role match then null the responsible partner
	                if(icd.Residential_Project__c == rpId && icd.Document_Owner__c == rpRole.get(icd.Residential_Project__c)) {
	                    icd.Responsible_Partner__c = null;
	                    icds.add(icd);
	                }
	            }
	        }
	        if(!icds.isEmpty()) update icds;
	    } catch(Exception e) {
	    	ExLog.log(e);
	    }
    }

	public class isICDExist {
        public Invoice_Compliance_Document__c icd;
        public boolean isICDExist;
        public boolean reqUpdate;

        public isICDExist(Invoice_Compliance_Document__c icd,boolean isICDExist,boolean reqUpdate){
            this.icd = icd;
            this.isICDExist = isICDExist;
            this.reqUpdate = reqUpdate;
        }
    }

    /*
	@Name        :  InvoiceComplianceDocDelta
	@description :  To insert or delete the invoice Compliance document based on the changed installation model
	@parameters  :  Map of the residential Project with Installation model
	@returns     :
	*/
    public static void InvoiceComplianceDocDelta (Map<Id, Id> newIMMap){
        // maps to store ICD related to residential Project.
        Map<Id,map<Id,Id>> rpWithICD = new Map<Id,map<Id,Id>>();
        // maps to store ICD related to new installation model.
        Map<Id,List<IDD_Junction__c>> iddWithIM = new Map<Id,List<IDD_Junction__c>>();
       // map of all the ICD with the Existence Flag.
        Map<Id,isICDExist> icdExist = new Map<Id,isICDExist>();
        Map<Id, List<Alliance_Partner__c>> partnerMap = new Map<Id, List<Alliance_Partner__c>>();
        // field to compare between junction and ICD
        Set<String> fieldsTocompare = new Set<String>{'Shared_With__c','Invoice_Type__c','Document_Owner__c'};
        Map<Id,Residential_Project__c> rpMap = new Map<Id,Residential_Project__c>();
        List<Invoice_Compliance_Document__c> invDocsToUpsert = new List<Invoice_Compliance_Document__c>();
        List<Invoice_Compliance_Document__c> invDocsToDelete = new List<Invoice_Compliance_Document__c>();
		// varible to related ICD record with Project Task.
		Set<Id> templateIds = new Set<Id>();
        Map<Id,Map<Id,Id>> templateWithIDDandTemplateTask;
        Map<Id,Map<Id,Id>> templateTaskWithProjectTask = new Map<Id,Map<Id,Id>>();


        try{
            for(Alliance_Partner__c ap : [SELECT Partner_Account__c, Residential_Project__c, Role__c FROM Alliance_Partner__c WHERE Residential_Project__c IN :newIMMap.Keyset()]) {
                if(!partnerMap.ContainsKey(ap.Residential_Project__c)) partnerMap.put(ap.Residential_Project__c,new List<Alliance_Partner__c>());
                partnerMap.get(ap.Residential_Project__c).add(ap);
            }

            for(Residential_Project__c rp :  [SELECT Id,Installation_Model__c, Quote__r.Account.Partner_Account__r.iSupplier__c, Quote__r.Consolidated_Lease_Number__c, Quote__r.System_Model__c, Quote__r.Account.BillingState,Project_Template__c,
                                              (SELECT Id,Name,Invoice_Type__c,Invoice_Document_Data__c,Shared_With__c,Document_Owner__c,FinancingType__c,Not_Required_for_Approval__c FROM Invoice_Compliance_Documents__r),
											  (SELECT Id,Name,Template_Task__c FROM Project_Tasks__r)
                                              FROM Residential_Project__c
                                              WHERE Id IN : newIMMap.Keyset()]){
                for(Invoice_Compliance_Document__c icd : rp.Invoice_Compliance_Documents__r){
                    if(!rpwithICD.containsKey(rp.Id)) rpwithICD.put(rp.Id,new map<Id,Id>());
                    if(icd.Invoice_Document_Data__c != null)rpWithICD.get(rp.Id).put(icd.Invoice_Document_Data__c,icd.Id);
                    icdExist.put(icd.Id,new isICDExist(icd,false,false));
                }
                rpMap.put(rp.Id,rp);
				templateIds.add(rp.Project_Template__c);
                if(!templateTaskWithProjectTask.containsKey(rp.Id)) templateTaskWithProjectTask.put(rp.Id,new Map<Id,Id>());
                for(Project_Task__c pt : rp.Project_Tasks__r){
                    templateTaskWithProjectTask.get(rp.Id).put(pt.Template_Task__c,pt.Id);
                }
            }

			// getting the Template Task Id based on the templateIds.
            if(!templateIds.isEmpty()) templateWithIDDandTemplateTask =  templateWithIDDandTemplateTask(templateIds);

            for(IDD_Junction__c iddJunction :[SELECT Id, Installation_Model__c, Installation_Model__r.Country__c, Installation_Model__r.Financing_Option__c, Invoice_Document_Data__c, Invoice_Document_Data__r.Not_Required_For_Approval__c, Invoice_Document_Data__r.Name, Invoice_Document_Data__r.Sharing_Type__c, Shared_With__c, Partner_Account__c, Partner_Account__r.BillingCountry, Document_Owner__c, State__c, Invoice_Type__c, System_Type__c, Document_Upload_Location__c,iSupplier__c
                                              FROM IDD_Junction__c
                                              WHERE installation_Model__c IN : newIMMap.values()]){
                if(!iddWithIM.containsKey(iddJunction.installation_Model__c))
                    iddWithIM.put(iddJunction.installation_Model__c,new List<IDD_Junction__c>());
                iddWithIM.get(iddJunction.installation_Model__c).add(iddJunction);
            }

            for(Id rpId : newIMMap.keyset()){
				if(iddWithIM.get(newIMMap.get(rpId)) != null){
					List<IDD_Junction__c> newIddJunctionstemp = new List<IDD_Junction__c>();
					for(IDD_Junction__c iddJunction : iddCriteriaUtility(iddWithIM.get(newIMMap.get(rpId)), rpMap.get(rpId), partnerMap.containsKey(rpId) ? partnerMap.get(rpId) : null)){
						if(!rpWithICD.isEmpty() && !rpWithICD.get(rpId).isEmpty() && rpWithICD.get(rpId).containsKey(iddJunction.invoice_Document_Data__c)){
							Invoice_Compliance_Document__c icd = icdExist.get(rpWithICD.get(rpId).get(iddJunction.invoice_Document_Data__c)).icd;
							icdExist.get(icd.Id).isICDExist = true;
							if(icd.Not_Required_For_Approval__c != iddJunction.Invoice_Document_Data__r.Not_Required_For_Approval__c){
								icd.Not_Required_For_Approval__c = iddJunction.Invoice_Document_Data__r.Not_Required_For_Approval__c;
								icdExist.get(icd.Id).reqUpdate = true;
							}
							if(icd.FinancingType__c != iddJunction.Installation_Model__r.Financing_Option__c){
								icd.FinancingType__c = iddJunction.Installation_Model__r.Financing_Option__c;
								icdExist.get(icd.Id).reqUpdate = true;
							}
							for(string s : fieldsTocompare){
								if(icd.get(s) != iddJunction.get(s)){
									icd.put(s,iddJunction.get(s));
									icdExist.get(icd.Id).reqUpdate = true;
								}
							}
						}
						else{
							newIddJunctionstemp.add(iddJunction);
						}
					}
					for(IDD_Junction__c iddJunction : newIddJunctionstemp){
						Invoice_Compliance_Document__c invDoc = new Invoice_Compliance_Document__c();
						invDoc.Name                         = rpMap.get(rpId).Quote__r.Consolidated_Lease_Number__c + ' [' + iddJunction.Invoice_Document_Data__r.Name + ']';
						invDoc.Documents_in_File__c         = iddJunction.Invoice_Document_Data__r.Name;
						invDoc.FinancingType__c             = iddJunction.Installation_Model__r.Financing_Option__c;
						invDoc.Invoice_Type__c              = iddJunction.Invoice_Type__c;
						invDoc.Document_Owner__c            = iddJunction.Document_Owner__c;
						invDoc.Shared_With__c               = iddJunction.Shared_With__c;
						invDoc.Not_Required_For_Approval__c = iddJunction.Invoice_Document_Data__r.Not_Required_For_Approval__c;
						invDoc.Residential_Project__c       = rpId;
						invDoc.Invoice_Document_Data__c     = iddJunction.Invoice_Document_Data__c;
						if(!templateTaskWithProjectTask.isEmpty() && !templateWithIDDandTemplateTask.isEmpty() && templateTaskWithProjectTask.containskey(rpId) && templateWithIDDandTemplateTask.containsKey(rpMap.get(rpId).Project_Template__c) && templateWithIDDandTemplateTask.get(rpMap.get(rpId).Project_Template__c).containsKey(iddJunction.Invoice_Document_Data__c) && templateTaskWithProjectTask.get(rpId).containsKey(templateWithIDDandTemplateTask.get(rpMap.get(rpId).Project_Template__c).get(iddJunction.Invoice_Document_Data__c))){
							invDoc.Project_Task__c          = templateTaskWithProjectTask.get(rpId).get(templateWithIDDandTemplateTask.get(rpMap.get(rpId).Project_Template__c).get(iddJunction.Invoice_Document_Data__c));
						}
						invDocsToUpsert.add(invDoc);
					}
				}
            }

            for(isICDExist icdrecord : icdExist.values()){
                if(icdrecord.reqUpdate) invDocsToUpsert.add(icdrecord.icd);
                if(!icdrecord.isICDExist)  invDocsToDelete.add(icdrecord.icd);
            }

            if(invDocsToUpsert.size () > 0){
                Database.UpsertResult[] srListUpsert = Database.Upsert(invDocsToUpsert, false);
                // Iterate through each returned result
                for (Database.UpsertResult sr : srListUpsert) {
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    }
                }
            }
            if(invDocsToDelete.size () > 0){
                Database.DeleteResult[] srListDelete = Database.Delete(invDocsToDelete, false);
                // Iterate through each returned result
                for (Database.DeleteResult sr : srListDelete) {
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    }
                }
            }
        }
        catch(Exception e){
          ExLog.log(e);
        }
    }

	// called from the icd after insert & after update handlers
	public static void updateLastDocSubmissionDate(Set<Id> lpIds) {
		try {
			List<LeasePayment__c> lpToUpdate = new List<LeasePayment__c>();
			for(LeasePayment__c lp : [SELECT Id, Last_Install_Doc_Submission__c, Last_Interconnect_Doc_Submission__c FROM LeasePayment__c WHERE Id IN :lpIds]) {
				lp.Last_Install_Doc_Submission__c = DATE.today();
				lp.Last_Interconnect_Doc_Submission__c = DATE.today();
				lpToUpdate.add(lp);
			}
			if(!lpToUpdate.isEmpty()) update lpToUpdate;
		}
		catch(Exception e) {
			ExLog.log(e);
		}
	}

	// function to create the map with templateId , IDD and Template Task
    public static Map<Id,Map<Id,Id>> templateWithIDDandTemplateTask (Set<Id> templateIds) {
        try {
            // Query for all the templates
            Map<Id,Map<Id,Id>> templateWithIDDandTemplateTask = new Map<Id,Map<Id,Id>>();
            for(Residential_Project__c templaterp : [SELECT Id,Name, (SELECT Id,Invoice_Document_Data__c,Project_Task__c FROM Documents__r) FROM Residential_Project__c WHERE Id IN: templateIds]){
                if(!templateWithIDDandTemplateTask.containsKey(templaterp.Id)) templateWithIDDandTemplateTask.put(templaterp.Id,new Map<Id,Id>());
                for(Document__c doc : templaterp.Documents__r){
                    templateWithIDDandTemplateTask.get(templaterp.Id).put(doc.Invoice_Document_Data__c,doc.Project_Task__c);
                }
            }
            return templateWithIDDandTemplateTask;
        }
        catch(Exception e) {
            ExLog.log(e);
            return null;
        }
    }

	// function to perform operation when the document is uploaded
    public static void icdDocumentUploaded(List<Invoice_Compliance_Document__c> icdList) {
		for(Invoice_Compliance_Document__c icd : icdList){
			icd.status__c = 'Pending';
			if(icd.Document_Submitted__c == null) icd.Document_Submitted__c = Date.today();
		}
    }

   	// function to perform operation when the document is deleted
    public static void icdDocumentDeleted(List<Invoice_Compliance_Document__c> icdList) {
		for(Invoice_Compliance_Document__c icd : icdList){
			icd.status__c = 'Not Submitted';
			icd.Document_Submitted__c = Null;
		}
    }

    // flag all icds for rp that need sharing logic run due to ap changes
    public static void flagICDsForSharing(Set<Id> rpIds) {
    	if(System.isFuture()) {
    		flagICDsNonFuture(rpIds);
    	} else flagICDsFuture(rpIds);
    }

    private static void flagICDsNonFuture(Set<Id> rpIds) {
    	flagICDs(rpIds);
    }

    @future
    private static void flagICDsFuture(Set<Id> rpIds) {
    	flagICDs(rpIds);
    }

    private static void flagICDs(Set<Id> rpIds) {
    	try {
    		// list for updates
    		List<Invoice_Compliance_Document__c> icds = new List<Invoice_Compliance_Document__c>();
    		// flag all icds
    		for(Invoice_Compliance_Document__c icd : [SELECT Id, UpdateSharing__c FROM Invoice_Compliance_Document__c WHERE Residential_Project__c IN :rpIds]) {
    			Invoice_Compliance_Document__c i = new Invoice_Compliance_Document__c();
    			i.Id = icd.Id;
    			i.UpdateSharing__c = true;
    			icds.add(i);
    		}
    		if(!icds.isEmpty()) update icds;
    	}
    	catch (Exception e) {
    		ExLog.log(e);
    	}
    }
}