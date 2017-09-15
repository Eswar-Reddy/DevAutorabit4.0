/**
 * Created by cdevarapalli on 8/2/17.
 */
@isTest
public class AdhocLDAUtility_Test {

    @testSetup
    static void dataSetup(){
        Lease_2_1_PO_Creation__c lease21PoC = TestFactory_Custom_Settings.createLease21POCreation();
        insert lease21PoC;
    }

    static testMethod void adhocCreateLDA(){

        Quote testQuote = TestFactory_StandardObjects.createProposalQuote(null);
        insert testQuote;

        Quote_Summary__c testQuoteSummary = TestFactory_Sales_Residential.createQuoteSummary(testQuote);
        insert testQuoteSummary;

        echosign_dev1__SIGN_Agreement__c testAgreement = TestFactory_Ordering.createAgreement(testQuote);
        insert testAgreement;

        test.startTest();
        String alertString = AdhocLDAUtility.adhocCreateLDA(testAgreement.Id);
        test.stopTest();

    }
}