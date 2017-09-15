public without sharing class InvoiceComplianceDocSharingUtility {

	// Use this method when creating to ICD records
	public static void newICDSharing(Set<Id> docIds) {
		try {
			insert runShareCriteria(docIds);
		}
		catch(Exception e) {
			ExLog.log(e);
		}
	}

	// Use this method when the Document Owner or Shared With values change on ICD records
	public static void updateICDSharing(Set<Id> docIds) {
		if(System.isFuture()) {
			updateICDSharingNonFuture(docIds);
		} else updateICDSharingFuture(docIds);
	}

	private static void updateICDSharingNonFuture(Set<Id> docIds) {
		runICDSharing(docIds);
	}

	@future
	private static void updateICDSharingFuture(Set<Id> docIds) {
		runICDSharing(docIds);
	}

	private static void runICDSharing(Set<Id> docIds) {
		try {
			// Delete old custom sharing and insert new sharing records
			delete [SELECT Id, ParentId, UserorGroupId, RowCause, AccessLevel FROM Invoice_Compliance_Document__Share WHERE ParentId IN: docIds AND (RowCause =: Schema.Invoice_Compliance_Document__Share.RowCause.Document_Owner_Partner__c OR RowCause =: Schema.Invoice_Compliance_Document__Share.RowCause.Shared_With_Partner__c) ];
			insert runShareCriteria(docIds);
		} catch(Exception e){
			Exlog.log(e);
		}
	}

	// Method that shares ICD records within any Partner Executive role
	public static List<Invoice_Compliance_Document__Share> exec2exec(List<Invoice_Compliance_Document__Share> shares){
		Map<Id, Invoice_Compliance_Document__Share> userMap = new Map<Id, Invoice_Compliance_Document__Share>();
		Map<String, Id> roles = new Map<String, Id>();
		List<Invoice_Compliance_Document__Share> sharesToReturn = new List<Invoice_Compliance_Document__Share>();

		for(Invoice_Compliance_Document__Share share : shares){
			userMap.put(share.UserorGroupId, share);
		}
		if(!userMap.isEmpty()){

			for(User u : [SELECT Id, UserRole.Name FROM User WHERE Id IN: userMap.keyset() AND isActive = TRUE AND UserRole.PortalType = 'Partner' AND UserRole.Name LIKE '%Partner Executive%']){
				roles.put(u.UserRole.Name, u.Id);
			}

			for(User u : [SELECT Id, UserRole.Name FROM User WHERE UserRole.Name IN: roles.keyset() AND isActive = TRUE AND UserRole.PortalType = 'Partner']){
				Invoice_Compliance_Document__Share copyShare = userMap.get(roles.get(u.UserRole.Name));

				Invoice_Compliance_Document__Share icdShare = new Invoice_Compliance_Document__Share();
				icdShare.ParentId 		= copyShare.ParentId;
				icdShare.UserorGroupId 	= u.Id;
				icdShare.RowCause 		= copyShare.RowCause;
				icdShare.AccessLevel 	= copyShare.AccessLevel;
				sharesToReturn.add(icdShare);
			}
		}
		return sharesToReturn;
	}

	// Method gives Edit access to all project team member users who are associated to the responsible partner account
	// Method gives Read access to all project team member users who are associated to an account in the shared with roles
	public static List<Invoice_Compliance_Document__Share> runShareCriteria(Set<Id> docIds){
		Set<Id> projects 						= new Set<Id>();
		Map<Id, Map<Id, List<Id>>> memberMap 	= new Map<Id, Map<Id, List<Id>>>();
		Map<Id, Map<String, Id>> apMap 			= new Map<Id, Map<String, Id>>();
		List<Invoice_Compliance_Document__Share> sharesToInsert = new List<Invoice_Compliance_Document__Share>();

		try{
			List<Invoice_Compliance_Document__c> invDocs = [SELECT Id, Document_Owner__c, Responsible_Partner__c, Shared_With__c, Residential_Project__c FROM Invoice_Compliance_Document__c WHERE Id IN: docIds];

			for(Invoice_Compliance_Document__c doc : invDocs){
				if(String.isNotBlank(doc.Residential_Project__c)) projects.add(doc.Residential_Project__c);
			}

			if(!projects.isEmpty()){
				// Create map of account assigned to roles for each residential project
				for(Alliance_Partner__c ap : [SELECT Id, Role__c, Partner_Account__c, Residential_Project__c FROM Alliance_Partner__c WHERE Residential_Project__c IN: projects AND RecordType.Name = 'Project Alliance Partner']){
					if(!apMap.containsKey(ap.Residential_Project__c)) apMap.put(ap.Residential_Project__c, new Map<String, Id>());
					apMap.get(ap.Residential_Project__c).put(ap.Role__c, ap.Partner_Account__c);
				}

				// Create a map with key project Id and value map <PTM Account, PTM User>
				for(Project_Team_Member__c ptm : [SELECT Residential_Project__c, User__c, User__r.UserRoleId, User__r.UserRole.PortalType, User__r.ContactId, User__r.Contact.AccountId FROM Project_Team_Member__c WHERE Residential_Project__c IN: projects AND User__c != NULL AND User__r.UserRole.PortalType = 'Partner' AND User__r.isActive = TRUE]){
					if(!memberMap.containsKey(ptm.Residential_Project__c)) memberMap.put(ptm.Residential_Project__c, new Map<Id, List<Id>>());
					if(!memberMap.get(ptm.Residential_Project__c).containsKey(ptm.User__r.Contact.AccountId)) memberMap.get(ptm.Residential_Project__c).put(ptm.User__r.Contact.AccountId, new List<Id>());
					memberMap.get(ptm.Residential_Project__c).get(ptm.User__r.Contact.AccountId).add(ptm.User__c);
				}

				for(Invoice_Compliance_Document__c doc : invDocs){
					// NULL protection
					if(!String.isBlank(doc.Responsible_Partner__c) && memberMap.containsKey(doc.Residential_Project__c) && memberMap.get(doc.Residential_Project__c).containsKey(doc.Responsible_Partner__c)){
						// Get all project team members users from the responsible partner account
						List<Id> docOwners = memberMap.get(doc.Residential_Project__c).get(doc.Responsible_Partner__c);

						// Give Edit access to all PTM users in the responsible partner account
						for(Id uId: docOwners){
							Invoice_Compliance_Document__Share icdShare = new Invoice_Compliance_Document__Share();
							icdShare.ParentId 		= doc.Id;
							icdShare.UserorGroupId 	= uId;
							icdShare.RowCause 		= Schema.Invoice_Compliance_Document__Share.RowCause.Document_Owner_Partner__c;
							icdShare.AccessLevel 	= 'Edit';
							sharesToInsert.add(icdShare);
						}
					}
					// NULL protection
					if(!String.isBlank(doc.Shared_With__c) && apMap.containsKey(doc.Residential_Project__c)){
						// Create list of all roles this doc should be shared with
						List<String> roles = doc.Shared_With__c.split(';');
						for(String role : roles){
							// NULL protection
							if(apMap.get(doc.Residential_Project__c).containsKey(role)){
								// NULL protection
								if(memberMap.containsKey(doc.Residential_Project__c) && apMap.containsKey(doc.Residential_Project__c) && apMap.get(doc.Residential_Project__c).containsKey(role) && memberMap.get(doc.Residential_Project__c).containsKey(apMap.get(doc.Residential_Project__c).get(role))){
									// Get all project team member users from account with this role
									List<Id> sharedUsers = memberMap.get(doc.Residential_Project__c).get(apMap.get(doc.Residential_Project__c).get(role));
									// Give Read access to all PTM users in the an account with Shared With role
									for(Id uId: sharedUsers){
										Invoice_Compliance_Document__Share icdShare = new Invoice_Compliance_Document__Share();
										icdShare.ParentId 		= doc.Id;
										icdShare.UserorGroupId 	= uId;
										icdShare.RowCause 		= Schema.Invoice_Compliance_Document__Share.RowCause.Shared_With_Partner__c;
										icdShare.AccessLevel 	= 'Read';
										sharesToInsert.add(icdShare);
									}
								}
							}
						}
					}
				}
			}
			sharesToInsert.addAll(exec2exec(sharesToInsert));
			return sharesToInsert;
		}
		catch(Exception e) {
			ExLog.log(e);
			return null;
		}
	}
}