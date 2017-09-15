/***
    Created By: Michelle Magsarili 
    Company: Cloudsherpas
    Date: 02/12/2014
    Purpose: Test Class for DealerComplianceUtility. 
***/

@isTest (seeAllData=true) 
public class DealerComplianceUtility_Test {

    public static testMethod void testDealerCompliance() {

        Test.startTest();
        
        //Get Partner Portal User
        String partnerProfileName = 'Partner Delegated Administrator';
        String activePartnerPortal = 'Yes';
        
        List<User> userList = Database.query('SELECT id, Name, Contact.AccountId, Contact.Name FROM User WHERE Profile.Name LIKE \'%' + partnerProfileName + '%\' AND isActive = true AND Contact.Active_Partner_Portal_User__c = \'' + activePartnerPortal + '\'' + ' LIMIT 2');  
        User partnerPortalUser = new User();
        
        if(userList.size()>0){
            partnerPortalUser = userList.get(0);
        
            System.debug('+++ partnerPortalUser :'+partnerPortalUser.Name);
            System.debug('+++ Portal Contact : '+partnerPortalUser.Contact.Name);
            
            Account customerAcct;
            Opportunity customerOpp;
            List<Dealer_Compliance_Requirement__c> DCRrecordsCreated = new List<Dealer_Compliance_Requirement__c> ();
            
            //System.runAs(partnerPortalUser){
                
                Set<Id> oppHomeOwnerId = new Set<Id>(); //Set of Opportunity Ids
                Map<String,Id> accRTs = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.SObjectType); //Get Account RecordTypes
                Map<String,Id> oppRTs = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Opportunity.SObjectType); //Get Opportunity RecordTypes
                Id accountRtId = accRTs.get('Home_Owner'); 
                Id oppRtId = OpportunityUtilities.homeOwnerRecordTypeId;
                List<opportunity> oppList = new List<Opportunity>();
                
                //Insert Customer Account record as Partner Portal User
                customerAcct = new Account (
                    RecordTypeId = accountRtId,
                    Name = 'Customer Account Test',
                    BillingPostalCode = '95008',
                    BillingStreet = 'Kenneth',
                    BillingCity = 'Campbell',
                    BillingState = 'CA',
                    BillingCountry = 'United States',
                    Phone = '1111111',
                    Theater__c = 'North America',
                    Partner_Account__c = partnerPortalUser.Contact.AccountId
                );
                insert customerAcct;
                System.debug('+++ customerAcct: '+customerAcct.Partner_Account__c);
                
                //Insert Customer Opportunity record
                customerOpp = new Opportunity (
                    recordTypeId = oppRtId,
                    AccountId = customerAcct.Id,
                    Name = 'Customer Account Test',
                    StageName = 'New Opportunity',
                    CloseDate = date.Today(),
                    Theater__c = 'North America',
                    Partner_Account_Id__c = partnerPortalUser.Contact.AccountId
                );
           Opportunity customerOpp1 = new Opportunity (
                    recordTypeId = oppRtId,
                    AccountId = customerAcct.Id,
                    Name = 'Customer Account Test',
                    StageName = 'New Opportunity',
                    CloseDate = date.Today(),
                    Theater__c = 'Australia',
                    Partner_Account_Id__c = partnerPortalUser.Contact.AccountId
                );
                oppList.add(customerOpp);
            	oppList.add(customerOpp1);
                

                if(DealerComplianceUtility.isValidForDealerCompliance(customerOpp, customerAcct.Id, oppRtId))
                {
                    system.debug('to check the record type');
                }
                if(DealerComplianceUtility.isOppAssignedToNewDealer(customerOpp,customerOpp))
                {
                    system.debug('to check the opportunity assigned to new dealer');
                }
               // insert customerOpp;
               insert oppList;
                
                
                /* Ralph Alega - 19.MAR.2014 -  Removed Assertion for Insert since OpportunityAfterInsertTrigger is inactive and will not be used.*/
                //List of Dealer Compliance Requirement records created via trigger
                //DCRrecordsCreated = Database.query('SELECT Id, Opportunity__c, Dealer_Name__c, Opportunity__r.Name, Compliance_Description__c, Compliance_Completed__c, Status__c, Date_Completed__c, Completed_By__c FROM Dealer_Compliance_Requirement__c WHERE Opportunity__c =\'' + customerOpp.Id + '\'');

                //Assertion to check if 2 Dealer Compliance Requirement records are created
                //System.assertEquals(DCRrecordsCreated.size(), 2);
                
            //}  
                
            //Delete DCR records to have them re-created on Oppty update
            delete DCRrecordsCreated;
            
            //To Insert Dealer Compliance via Opportunity update - reassign oppty to to a different partner user; 
            customerOpp.OwnerId = userList.get(1).id;
            update customerOpp;
        
            DCRrecordsCreated = Database.query('Select id from Dealer_Compliance_Requirement__c  where Opportunity__c =\'' + customerOpp.Id + '\'');

          //  System.assertEquals(DCRrecordsCreated.size(), 2);
        }   
        Test.stopTest();
        
    }    
}