/***
    Created By: Michelle Magsarili
    Company: Cloudsherpas
    Date: 02/12/2014
    Purpose: Test Class for SFDCSpecialUtilities.
***/

@isTest
public class SFDCSpecialUtilities_Test {

    public static testMethod void testGetRecordTypeIdsByDeveloperName() {

        Test.startTest();

        //Get Account RecordTypes
        Map<String,Id> accRTs = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.SObjectType);
        System.assertEquals(accRTs.isEmpty(), false);

        //Get Dealer Compliance RecordTypes
        Map<String,Id> dcrRTs = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Dealer_Compliance_Requirement__c.SObjectType);
        System.assertEquals(dcrRTs.isEmpty(), true);

        Test.stopTest();

    }
}