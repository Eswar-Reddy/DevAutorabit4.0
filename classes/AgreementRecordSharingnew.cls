public with sharing class AgreementRecordSharingnew 
{
	public static AgreementApexSharing__c AgreementApexSharing = AgreementApexSharing__c.getInstance('AgreementApexSharing'); 
	
	public static void AgreementRoleBaseSharing(list<echosign_dev1__SIGN_Agreement__c> lstAgreement)
	{
		if(lstAgreement.isEmpty()) return;
		
		lstAgreement = getAgreementbyId(lstAgreement);
		
		map<Id,Id> mapOfAgreeAcc = new map<Id,Id>();
		
		for(echosign_dev1__SIGN_Agreement__c objAgreeement : lstAgreement){
			
			system.debug('1.  '+objAgreeement.Account__c);
			system.debug('2.  '+objAgreeement.Account__r.ParentId);
			system.debug('3.  '+objAgreeement.Account__r.Partner_Account__c);
			
			if(objAgreeement.Account__c == null) continue;
			if(objAgreeement.Account__r.Partner_Account__c == null) continue;
			
			
			
			mapOfAgreeAcc.put(objAgreeement.Id,objAgreeement.Account__r.Partner_Account__c);
		}
		
		
		
		system.debug('mapOfAgreeAcc 1 ==============>'+mapOfAgreeAcc); 
		 
		if(mapOfAgreeAcc.IsEmpty()) return;
		
		//Collect Role By Account by Acc Id
		map<Id,String> mapAccountRole = getAccountRoleMapByAccId(mapOfAgreeAcc);
		
		system.debug('mapAccountRole 2 ==============>'+mapAccountRole);
		
		// Collect Role Name Vs GroupId
		map<String,Id> mapRoleVsGrpId = getRoleNameVsGroupId(mapAccountRole);
		
		system.debug('mapRoleVsGrpId 3 ==============>'+mapRoleVsGrpId);
		
		// Creatin sharing 
		
		list<echosign_dev1__SIGN_Agreement__Share> lstShare = createAgreementShare(lstAgreement,mapAccountRole,mapRoleVsGrpId);
		
		system.debug('lstShare =============>'+lstShare);
		
		if(!lstShare.IsEmpty())
		insert lstShare;
	}
	
	public static list<echosign_dev1__SIGN_Agreement__Share> createAgreementShare(list<echosign_dev1__SIGN_Agreement__c> lstAgreement, 
																			map<Id,String> mapAccountRole, 
																			map<String,Id> mapRoleVsGrpId)
	{
		list<echosign_dev1__SIGN_Agreement__Share> lstAgreementShare = new list<echosign_dev1__SIGN_Agreement__Share>();
		set<String> sExistShare = getExistingShare(lstAgreement);
		
		system.debug('sExistShare ====>'+sExistShare);
		
		for(echosign_dev1__SIGN_Agreement__c objAggrement : lstAgreement)
		{
			// get Account and get Role Name 
			if(objAggrement.Account__r.Partner_Account__c == null) continue;
			
			if(mapAccountRole.get(objAggrement.Account__r.Partner_Account__c) != null)
			{
				//get group id by role name
				if(mapRoleVsGrpId.get(mapAccountRole.get(objAggrement.Account__r.Partner_Account__c)) != null)
				{
					Id grpId = mapRoleVsGrpId.get(mapAccountRole.get(objAggrement.Account__r.Partner_Account__c));
					
					system.debug('grpId ===============>'+grpId);
					
					if(!sExistShare.Contains(objAggrement.Id + '-' + grpId))
					{
						lstAgreementShare.add(new echosign_dev1__SIGN_Agreement__Share(ParentId = objAggrement.Id,
                                                                                       AccessLevel = 'Edit',
                                                                                       UserOrGroupId = grpId)); 
					}
				}
			}
		}
		
		
		return lstAgreementShare;
	}
	
	
	public static Set<String> getExistingShare(list<echosign_dev1__SIGN_Agreement__c> lstAgreement)
	{
		map<Id,echosign_dev1__SIGN_Agreement__c> mapAgreement = new map<Id,echosign_dev1__SIGN_Agreement__c>();
		mapAgreement.putAll(lstAgreement);
		
		/* Set of existing Shares for Agreement in consideration */
        Set<String> sExistShare = new Set<String>();
        for(echosign_dev1__SIGN_Agreement__Share eagrSha : [SELECT ParentId, UserOrGroupId, Id 
                                                            FROM echosign_dev1__SIGN_Agreement__Share 
                                                            WHERE ParentId IN: mapAgreement.keySet()])
            sExistShare.add(eagrSha.ParentId + '-' + eagrSha.UserOrGroupId);
       
       return sExistShare;     
	}
	
	
	public static map<String,Id> getRoleNameVsGroupId(map<Id,String> mapAccountRole)
	{
		map<String,Id> mapRoleNameVSgrpId = new map<String,Id>();
		
		// Collect UserRoleName 
		map<String, Id> mRoleNamevsId = new Map<String, Id>();
		for(UserRole usRole : [SELECT id, name
                                   FROM UserRole
                                   WHERE Name IN: mapAccountRole.values()])
               mRoleNamevsId.put(usRole.Name, usRole.Id);
				
               Map<Id, Id> mRoleIdvsGroupId = new Map<Id, Id>(); //Role Id vs Group Id
         
         
         system.debug('########### '+mRoleNamevsId.values());
         
         for(Group grp: [SELECT ID, RelatedID
                                FROM Group
                                WHERE RelatedId IN: mRoleNamevsId.values() 
                                and Type='RoleandSubordinates'])
                    mRoleIdvsGroupId.put(grp.RelatedId , grp.Id);
        
        
        //================= Creating MAP FOR ROLE NAME VS GROUP ID =====================
        for(String strRoleName : mRoleNamevsId.KeySet())
        {
        	// Get Role Id by Name
        	Id roleId = mRoleNamevsId.get(strRoleName);
        	
        	system.debug('==Role Name =='+strRoleName+'===roleId=='+roleId);
        	system.debug('******** mRoleIdvsGroupId.containsKey(roleId) **'+mRoleIdvsGroupId.get(roleId));
        	
        	
        	if(mRoleIdvsGroupId.containsKey(roleId))
        		mapRoleNameVSgrpId.put(strRoleName,mRoleIdvsGroupId.get(roleId));
        	else{
        		system.debug('************* Not matching rule Id with Grp ******************');
        	}
        }
        
        return mapRoleNameVSgrpId;
	}
	
	public static map<Id,String> getAccountRoleMapByAccId(map<Id,Id> mapOfAgreeAcc){
		
		map<Id,String> mapAccountRole = new map<Id,String>();
		for(Account objAccount : ([SELECT id, 
										OwnerId,
										name, 
										Owner.UserRole.Name 
								   FROM Account 
								   WHERE id IN: mapOfAgreeAcc.values() 
								   AND Owner.IsActive =TRUE])){
			mapAccountRole.put(objAccount.Id, objAccount.name + ' '+AgreementApexSharing.RoleName__c);
		}
		
		return mapAccountRole;
	}
	
	public static List<echosign_dev1__SIGN_Agreement__c> getAgreementbyId(List<echosign_dev1__SIGN_Agreement__c> lstAgreement)
	{
		return [Select e.Account__r.Partner_Account__c,e.echosign_dev1__Trigger_Process_Template__c, e.echosign_dev1__Sync_Data_Mapping__c, e.echosign_dev1__Status__c, e.echosign_dev1__StatusVisible__c, e.echosign_dev1__SignedPDF__c, e.echosign_dev1__SignatureType__c, e.echosign_dev1__SignatureOrder__c, e.echosign_dev1__Sender_User__c, e.echosign_dev1__SenderSigns__c, e.echosign_dev1__ReturnURL__c, e.echosign_dev1__ReturnURL_Text__c, e.echosign_dev1__Result__c, e.echosign_dev1__RemindRecipient__c, e.echosign_dev1__Recipient__c, e.echosign_dev1__Recipient_User__c, e.echosign_dev1__Recipient_Signing_Order__c, e.echosign_dev1__Recipient_Lead__c, e.echosign_dev1__Recipient_Lead4__c, e.echosign_dev1__Recipient_Lead3__c, e.echosign_dev1__Recipient_Lead2__c, e.echosign_dev1__Recipient_Addresses__c, e.echosign_dev1__Recipient4__c, e.echosign_dev1__Recipient3__c, e.echosign_dev1__Recipient2__c, e.echosign_dev1__Rebuild_Recipient_List__c, e.echosign_dev1__Process_Template__c, e.echosign_dev1__PreferFax__c, e.echosign_dev1__Percent_Signed__c, e.echosign_dev1__Password__c, e.echosign_dev1__PasswordProtectSign__c, e.echosign_dev1__PasswordProtectPDF__c, e.echosign_dev1__Opportunity__c, e.echosign_dev1__NewPassword__c, e.echosign_dev1__More_Recipients__c, e.echosign_dev1__Minutes_Until_Signed__c, e.echosign_dev1__Message__c, e.echosign_dev1__Merge__c, e.echosign_dev1__Merge_Mapping__c, e.echosign_dev1__Merge_Mapping_Result__c, e.echosign_dev1__Merge_Mapping_Error__c, e.echosign_dev1__Legacy_Record_ID__c, e.echosign_dev1__LastEventId__c, e.echosign_dev1__ErrorMessage__c, e.echosign_dev1__EncodedPassword__c, e.echosign_dev1__Enable_Revisions__c, e.echosign_dev1__Enable_Hosted_Signing__c, e.echosign_dev1__Enable_Automatic_Reminders__c, e.echosign_dev1__Document__c, e.echosign_dev1__Document_Key__c, e.echosign_dev1__DaysUntilSigningDeadline__c, e.echosign_dev1__DaysUntilSigned__c, e.echosign_dev1__DaysUnsigned__c, e.echosign_dev1__DateViewed__c, e.echosign_dev1__DateViewedDate__c, e.echosign_dev1__DateSigned__c, e.echosign_dev1__DateSignedDate__c, e.echosign_dev1__DateSent__c, e.echosign_dev1__DateSentDate__c, e.echosign_dev1__Data_Mapping_Result__c, e.echosign_dev1__Data_Mapping_Error__c, e.echosign_dev1__Contract__c, e.echosign_dev1__Cc__c, e.echosign_dev1__Background_Action__c, e.echosign_dev1__AutoUpdate__c, e.echosign_dev1__Authoring__c, e.echosign_dev1__Attachment_ID_Order__c, e.echosign_dev1__AgreementLocale__c, e.echosign_dev1__Additional_Recipient_3_User__c, e.echosign_dev1__Additional_Recipient_2_User__c, e.echosign_dev1__Additional_Recipient_1_User__c, e.echosign_dev1__AdditionalOptions__c, e.echosign_dev1__Account__c, e.Welcome_Email__c, e.Welcome_Call__c, e.Validation_Status__c, e.Underwriting_Approval_Email__c, e.UnderWriting__c, e.TownHall_Address__c, e.TPO_Represent_Name__c, e.SystemModstamp, e.Status__c, e.Signed_Within_5_Days__c, e.Reviewer__c, e.Reviewed_Reject_Document__c, e.Related_Account__c, e.RecordTypeId, e.Reason_for_Rejection__c, e.Ready_to_send__c, e.Ready_to_Sign__c, e.Quote__c, e.Quote_Expiration_date__c, e.Proposal_Design_Review_Status__c, e.Proposal_Design_Review_Passed__c, e.Password__c, e.Partner_Application__c, e.OwnerId, e.Oracle_Vendor_email_field_value__c, e.Opportunity__c, e.Name, e.Lease_Number__c, e.LastModifiedDate, e.LastModifiedById, e.IsDeleted, e.Installer_Email__c, e.Id, e.Delivery_Receipt_Record_Date__c, e.Days_Unsigned_No_Weekend_Estimate__c, e.CurrencyIsoCode, e.Credit_Check_Status__c, e.Created_Date_Time__c, e.Created_By_Partner_Poratl_User__c, e.CreatedDate, e.CreatedById, e.Country_Domain__c, e.Contract_Type__c, e.Contract_Status__c, e.ConnectionSentId, e.ConnectionReceivedId, e.Cancellation_Reason__c, e.Approved__c, e.Approved_By_Partner__c, e.Amendment_Quote_ID__c, e.Agreement_Type_2__c, e.Agreement_Status_History__c, e.Agreement_Name__c, e.Agg_created_through__c, e.Account__r.ParentId, e.Account__c 
		From echosign_dev1__SIGN_Agreement__c e 
		where Id in: lstAgreement];
	}
    
    
    @future
    public static void futureAgreementSharing(Set<Id> agreementIds) {
        Map<Id, Id> mAgrvsCA = new map<Id, Id>(); //Agreement Id vs related Customer Account
        Map<Id, Id> mAgrIdvsUId = new Map<Id, Id>();
        
        
        Map<Id, echosign_dev1__SIGN_Agreement__c> agreementDataMap = new Map<Id, echosign_dev1__SIGN_Agreement__c>([SELECT Id, OwnerId, Account__c 
                                                                                                                    FROM echosign_dev1__SIGN_Agreement__c
                                                                                                                    WHERE Id IN: agreementIds]);
        for(echosign_dev1__SIGN_Agreement__c agr : agreementDataMap.values()){
            if(agr.Account__c != null){
                mAgrvsCA.put(agr.Id, agr.Account__c);
                mAgrIdvsUId.put(agr.Id, agr.OwnerId);
            }
        }
        
        Map<Id, Account> mCvsP = new Map<Id, Account>(); //Customer Account Id and its Owner Id
        
        if(!mAgrvsCA.isEmpty())
            mCvsP = new Map<Id, Account>([SELECT id, OwnerId, Owner.UserRole.Name FROM Account WHERE id IN: mAgrvsCA.values() AND Owner.IsActive =TRUE]);     
        
        if(!mCvsP.isEmpty())
        {
            Map<Id, User> mapUsr = new Map<Id, User>([SELECT id, UserRole.Name FROM User WHERE id IN : mAgrIdvsUId.values()]);
            
            /* Set of existing Shares for Agreement in consideration */
            Set<String> sExistShare = new Set<String>();
            for(echosign_dev1__SIGN_Agreement__Share eagrSha : [SELECT ParentId, UserOrGroupId, Id 
                                                                FROM echosign_dev1__SIGN_Agreement__Share 
                                                                WHERE ParentId IN: agreementDataMap.keySet()])
                sExistShare.add(eagrSha.ParentId + '-' + eagrSha.UserOrGroupId);
            
            /* Place Holder for share record to be inserted */
            List<echosign_dev1__SIGN_Agreement__Share> lstagrShareInsert = new List<echosign_dev1__SIGN_Agreement__Share>(); 
            
            for(echosign_dev1__SIGN_Agreement__c agr : agreementDatamap.values()) {
                if(mCvsP.containsKey(agr.Account__c))  {
                    
                    if( ((mCvsP.get(agr.Account__c).Owner.UserRole.Name.contains('Partner Manager') || 
                          mCvsP.get(agr.Account__c).Owner.UserRole.Name.contains('Partner User')) && 
                         mapUsr.get(mAgrIdvsUId.get(agr.Id)).UserRole.Name.contains('Partner Executive')) 
                       
                       ||( mCvsP.get(agr.Account__c).Owner.UserRole.Name.contains('Partner User') && 
                          mapUsr.get(mAgrIdvsUId.get(agr.Id)).UserRole.Name.contains('Partner Manager')) ) 
                    {
                        
                        if(!sExistShare.isEmpty() && !sExistShare.contains(agr.Id + '-' + mCvsP.get(agr.Account__c).OwnerId) 
                           || !sExistShare.isEmpty() && !sExistShare.contains(agr.Id + '-' + mapUsr.get(mAgrIdvsUId.get(agr.Id)).UserRoleId)) {//If share record do not exist
                               lstagrShareInsert.add(new echosign_dev1__SIGN_Agreement__Share(ParentId = agr.Id,
                                                                                              AccessLevel = 'Edit',
                                                                                              UserOrGroupId = mCvsP.get(agr.Account__c).OwnerId));
                           }                         
                        
                        else if(sExistShare.isEmpty()){ //If there is not share record all together
                            lstagrShareInsert.add(new echosign_dev1__SIGN_Agreement__Share(ParentId = agr.Id,
                                                                                           AccessLevel = 'Edit',
                                                                                           UserOrGroupId = mCvsP.get(agr.Account__c).OwnerId));                          
                        }
                    }
                }
            }       
            
            /* Insert the share records */
            if(!lstagrShareInsert.isEmpty())
                insert lstagrShareInsert;
            
            // Sharing agreement with partne Executive
            AgreementRecordSharingnew.AgreementRoleBaseSharing(agreementDataMap.values());     
        }
        
    }
}