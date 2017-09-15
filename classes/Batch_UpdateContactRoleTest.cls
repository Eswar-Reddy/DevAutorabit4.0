@isTest(SeeAllData=false)
                                
private class Batch_UpdateContactRoleTest {
    static testmethod void test() {
	 			Set<Id> oppHomeOwnerId = new Set<Id>(); //Set of Opportunity Ids
                Map<String,Id> accRTs = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.SObjectType); //Get Account RecordTypes
                Map<String,Id> oppRTs = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Opportunity.SObjectType); //Get Opportunity RecordTypes
                Id accountRtId = accRTs.get('Home_Owner');
        		String activePartnerPortal = 'Yes';
        		String partnerProfileName = 'Partner Delegated Administrator';
                Id oppRtId = OpportunityUtilities.homeOwnerRecordTypeId;
                List<User> userList = Database.query('SELECT id, Name, Contact.AccountId, Contact.Name FROM User WHERE Profile.Name LIKE \'%' + partnerProfileName + '%\' AND isActive = true AND Contact.Active_Partner_Portal_User__c = \'' + activePartnerPortal + '\'' + ' LIMIT 2');  
        		
            	//User partnerPortalUser = userList.get(0);
                //Insert Customer Account record as Partner Portal User
                Account customerAcct = new Account (
                    RecordTypeId = accountRtId,
                    Name = 'Customer Account Test',
                    BillingPostalCode = '95008',
                    BillingStreet = 'Kenneth',
                    BillingCity = 'Campbell',
                    BillingState = 'CA',
                    BillingCountry = 'United States',
                    Phone = '1111111',
                    Theater__c = 'North America'
                    
                );
                
                insert customerAcct;
                
                System.debug('+++ customerAcct: '+customerAcct.Partner_Account__c);
                
                //Insert Customer Opportunity record
                Opportunity customerOpp = new Opportunity (
                    recordTypeId = oppRtId,
                    AccountId = customerAcct.Id,
                    Name = 'Customer Account Test',
                    StageName = 'New Opportunity',
                    CloseDate = date.Today(),
                    Theater__c = 'North America'
                );
                
                insert customerOpp;	
         	Contact objcontact = new Contact(AccountID = customerAcct.id,FirstName='testconbyPO2',LastName='testconbyPO2');
            objcontact.Email ='te@test.com';
            insert objcontact;
        
        	OpportunityContactRole  objOpportunityContactRole= new OpportunityContactRole ();
        	objOpportunityContactRole.IsPrimary= true;
            objOpportunityContactRole.Role= null;
        	objOpportunityContactRole.opportunityid = customerOpp.id;
    		objOpportunityContactRole.ContactId = objcontact.id;
		    insert objOpportunityContactRole;

        Test.startTest();
        Batch_UpdateContactRole c = new Batch_UpdateContactRole();
        Database.executeBatch(c);
        Test.stopTest();
    
    }
    
}