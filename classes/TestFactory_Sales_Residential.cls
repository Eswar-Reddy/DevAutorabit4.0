/**
 * Created by cdevarapalli on 4/6/17.
 * Test Factory for Sales Residential
 */
@isTest
public class TestFactory_Sales_Residential {

    //Create Roof Detail
    public static Roof_Details__c createRoofDetail(Id quoteId){
        if(quoteId == NULL) quoteId = TestFactory_StandardObjects.getProposalQuote().Id;
        Roof_Details__c rDet = new Roof_Details__c();
        rDet.Quote_Id__c = quoteId;
        return rDet;
    }

    //Create Quote Summary
    public static Quote_Summary__c createQuoteSummary(Quote q){
        if(q == NULL) q = TestFactory_StandardObjects.getProposalQuote();
        Quote_Summary__c qs = new Quote_Summary__c();
        qs.Locked_Scenario__c = q.Id;
        return qs;
    }
}