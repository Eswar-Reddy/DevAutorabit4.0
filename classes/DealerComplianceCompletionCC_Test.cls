/***
    Created By: Ralph Alega 
    Company: Cloudsherpas
    Date: 02/04/2014
    Purpose: Test Class for DealerComplianceCompletionCC. 
***/

@isTest(seeAllData=true)
public class DealerComplianceCompletionCC_Test {

    public static testMethod void testDCRsubmit() {
        
        //Get Partner Portal User
        String partnerProfileName = 'Partner Delegated Administrator';
        String activePartnerPortal = 'Yes';
        User partnerPortalUser = Database.query('SELECT id, Name, Contact.AccountId, Contact.Name FROM User WHERE Profile.Name =\'' + partnerProfileName + '\'' +' AND isActive = true AND Contact.Active_Partner_Portal_User__c = \'' + activePartnerPortal + '\'' + ' LIMIT 1');  
        
        System.debug('+++ partnerPortalUser :'+partnerPortalUser.Name);
        System.debug('+++ Portal Contact : '+partnerPortalUser.Contact.Name);
        
        System.runAs(partnerPortalUser){
            
            //Partner Portal User Creates Customer Account through Partner Portal
            Id accountRtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Residential Customer').getRecordTypeId();
            
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
                Theater__c = 'North America',
                Partner_Account__c = partnerPortalUser.Contact.AccountId
            );
            
            insert customerAcct;
            
            System.debug('+++ customerAcct: '+customerAcct.Partner_Account__c);
            
            Id oppRtId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Home Owner').getRecordTypeId();
            
            //Insert Customer Opportunity record
            Opportunity customerOpp = new Opportunity (
                recordTypeId = oppRtId,
                AccountId = customerAcct.Id,
                Name = 'Customer Account Test',
                StageName = 'New Opportunity',
                CloseDate = date.Today(),
                Theater__c = 'North America',
                Partner_Account_Id__c = partnerPortalUser.Contact.AccountId
            );
            
            insert customerOpp;
            
            //List of Dealer Compliance Requirement records created via trigger
            List<Dealer_Compliance_Requirement__c> DCRrecordsCreated = Database.query('SELECT Id, Opportunity__c, Dealer_Name__c, Opportunity__r.Name, Compliance_Description__c, Compliance_Completed__c, Status__c, Date_Completed__c, Completed_By__c FROM Dealer_Compliance_Requirement__c WHERE Opportunity__c =\'' + customerOpp.Id + '\'');

            //Assertion to check if 2 Dealer Compliance Requirement records are created
            System.assertEquals(DCRrecordsCreated.size(), 2);
            
            Test.startTest();
            
            //Set The Visual Force Page
            PageReference pageRef = page.DealerComplianceCompletion;
            Test.setCurrentPage(pageRef);
            
            //Put the Dealer Compliance Requirement record Id as page parameter
            ApexPages.currentPage().getParameters().put('id', DCRrecordsCreated[0].Id);
            
            //Instantiate Controller Class
            DealerComplianceCompletionCC controller = new DealerComplianceCompletionCC(new ApexPages.StandardController(new Dealer_Compliance_Requirement__c()));
            
            //Create Map of Dealer Compliance Requirement record
            Map<Id, Dealer_Compliance_Requirement__c> dealerComplianceMap = new Map<Id, Dealer_Compliance_Requirement__c>();
            dealerComplianceMap.put(DCRrecordsCreated[0].id, DCRrecordsCreated[0]);
            
            //Call the controller methods to execute the tests
            controller.DCompReq = DCRrecordsCreated[0];
            controller.getDCompReq();
            dealerComplianceMap.get(DCRrecordsCreated[0].Id).Compliance_Completed__c = true;    //Set the checkbox to true
            controller.dealerComplianceReqToUpdate = dealerComplianceMap;
            controller.parentOppId = customerOpp.Id;
            controller.saveBtn();
            controller.cancelBtn();
            System.assertEquals(dealerComplianceMap.get(DCRrecordsCreated[0].Id).Compliance_Completed__c , true);
            
            //Update the Dealer Compliance Record Compliance_Completed__c field to false
            dealerComplianceMap.get(DCRrecordsCreated[0].Id).Compliance_Completed__c = false;    //Set the checkbox to false
            controller.saveBtn();
            System.assertEquals(dealerComplianceMap.get(DCRrecordsCreated[0].Id).Compliance_Completed__c , false);
            
            
            Test.stopTest();
            
        }  
    }    
}