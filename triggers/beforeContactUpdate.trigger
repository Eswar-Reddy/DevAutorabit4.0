trigger beforeContactUpdate on Contact (before update) {
 
//START - BIRLASOFT - Paritosh - July-30-2012
//Added this condition below to check if the context is of Lead Conversion then this trigger will not execute anyfurther.
 if(util.isInContextOfLeadConversion()){
 return;
 }
//END - BIRLASOFT - Paritosh
 
 if(util.isSkipTrigger())
    {
            return;
    }
   /*if(UserInfo.getUserId()=='00580000003XtZw' || UserInfo.getUserId()=='00580000003Xtm2' ||UserInfo.getUserId()=='00580000003XrG4')
    {
        return;
    }*/
    
    if(UserInfo.getUserId()=='00580000003XrG4AAK' || UserInfo.getUserId()=='00580000003XtZwAAK' ||UserInfo.getUserId()=='00580000003Xtm2AAC')
    {
        return;
    }
   ContactManagement.beforeContactUpdate(Trigger.newMap, Trigger.new);
   Map<ID,Contact> mapTrigger = new Map<ID,Contact>();
   mapTrigger = Trigger.newMap;
   
   //Done against the case-00013554
   //Case-00013554-Trigger to set the owner of the Contact same as the owner of Account 'DO NOT USE - Former Partner Employees' whenever Contact's account is changed to 'DO NOT USE - Former Partner Employees'.(if Contact old owner is portal user)
   //Preapare the set of Contact's owner
   Set<String> setOwner = new Set<String>();
   for(Contact c:Trigger.New){
           setOwner.Add(c.ownerID);
   }
   //Create the set of those Contact's owner who are portal user
   Set<String> setPortalOwner = new Set<String>();
   for(User u:[Select id,ContactID from User where ID in :setOwner and ContactID!=null]){
           setPortalOwner.Add(u.ID);
   }
   
   //Prepare a set of Account 
    Set<String> setAccount = new Set<String>();
    for(Contact c:Trigger.new){
        if(c.LMS_Role__c=='B-Owner/Training Liaison' || c.LMS_Role__c=='TL-Training Liason'){
            setAccount.Add(c.AccountID);
        }
    }
    
    Account accFormerEmployee = null;
    for(Account acc:[Select id,ownerID,isPartner,name,(Select id,LMS_Role__c from Contacts where LMS_Role__c='B-Owner/Training Liaison' or LMS_Role__c='TL-Training Liason') from Account where (id in :SetAccount and isPartner=true) or (name='DO NOT USE - Former Partner Employees')]){
        if(setAccount.contains(acc.ID) && acc.isPartner){
            List<Contact> lstC = new List<Contact>();
            lstC = acc.Contacts;
            if(lstC.size()>0){ 
               if(!mapTrigger.containsKey(lstC[0].ID)){             
                   Trigger.new[0].LMS_Role__c.AddError('Only 1 contact may have have a B or TL LMS Function. You already have a contact with a B or TL LMS Function assigned to this account');
               }
            }
        }
        if(acc.name=='DO NOT USE - Former Partner Employees'){
            accFormerEmployee = acc;
        }
    }
    
    /* Changed for Sunpower Case # 00040180 */
    if (accFormerEmployee == null) {
        return;
    }
    
    Set<ID> deactContactIds = new Set<ID>();
    Set<ID> actContactIds = new Set<ID>();
    
    for (ID contactId : Trigger.newMap.keySet()) {
        Contact newContact = Trigger.newMap.get(contactId);
        Contact oldContact = Trigger.oldMap.get(contactId);
        
        // Set the owner of the Contact same as the owner of
        // Account 'DO NOT USE - Former Partner Employees' whenever Contact's account
        // is changed to 'DO NOT USE - Former Partner Employees' (if Contact old owner is portal user)
        if (newContact.AccountID == accFormerEmployee.Id && setPortalOwner.contains(newContact.ownerID)) {
            newContact.ownerID = accFormerEmployee.ownerID;
        }
        
        if (newContact.AccountID != oldContact.AccountID) {
            if (newContact.AccountID == accFormerEmployee.Id) {
                deactContactIds.add(contactId);
            } else if (oldContact.AccountID == accFormerEmployee.Id) {
                actContactIds.add(contactId);
            }
        }
    }
    
    List<Certification__c> oldCertifications = [Select Id, Name, Attended_ILC__c,
            PartnerContact__c, Curriculum_Level__c, Curriculum_Role__c, IntegrationExternalID__c,
            Is_Certified__c, Account__c, CurrencyIsoCode
            From Certification__c Where PartnerContact__c In :deactContactIds
            Or PartnerContact__c In :actContactIds];
    List<Certification__c> newCertifications = new List<Certification__c>();
    
    for (Certification__c oldCert : oldCertifications) {
        Certification__c newCert = new Certification__c();
        newCert.Name = oldCert.Name;
        newCert.Attended_ILC__c = oldCert.Attended_ILC__c;
        newCert.PartnerContact__c = oldCert.PartnerContact__c;
        newCert.Curriculum_Level__c = oldCert.Curriculum_Level__c;
        newCert.Curriculum_Role__c = oldCert.Curriculum_Role__c;
        newCert.IntegrationExternalID__c = oldCert.IntegrationExternalID__c;
        newCert.Is_Certified__c = oldCert.Is_Certified__c;
        newCert.CurrencyIsoCode = oldCert.CurrencyIsoCode;
        
        if (deactContactIds.contains(oldCert.PartnerContact__c)) {
            newCert.Account__c = accFormerEmployee.Id;
        } else {
            newCert.Account__c = Trigger.newMap.get(oldCert.PartnerContact__c).AccountID;
        }
        
        newCertifications.add(newCert);
    }
    
    delete oldCertifications;
    insert newCertifications;
    /**************************************/
}