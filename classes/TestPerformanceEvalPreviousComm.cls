/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestPerformanceEvalPreviousComm {
public static testMethod void testPreviousPerformanceComm1(){
        Account selectedAcc;
        List<Account> listAccs = [select Id, Name from account where type like '%Elite-Partner-Combo%' and Theater__c='North America' and status__c='active' limit 1];
        if(listAccs != null && listAccs.size() > 0){
            selectedAcc = listAccs.get(0);
        }
        Test.startTest();
        Test.setCurrentPage(Page.PerformanceEvalPreviousComm);
        ApexPages.currentPage().getParameters().put('accId',selectedAcc.ID);
        ApexPages.currentPage().getParameters().put('period','2');
        ApexPages.currentPage().getParameters().put('year','2010');
        PerformanceEvalPreviousCommController prevController = new PerformanceEvalPreviousCommController();
        prevController.getPartnerExecutive();
        prevController.getHideHeaderForPartner();
        prevController.getDisableEditButton();
        prevController.getDisableButton();
        prevController.setDisableButton(true);
        prevController.getparamExpDate();
        prevController.getperformanceMetricID();
        prevController.getparamStartDate();
        prevController.getparamEndDate();
        prevController.getaccountId();
        prevController.getvalidExpToDate();
        prevController.getcustomer_Satisfaction_Current();
        prevController.getperformance_to_business_Plan_Current();
        prevController.gettraining_Current();
       // prevController.gettraining_Current_Clone();
        //prevController.getmarketing_Current();
        //prevController.getall_spwr_solutions_Current();
        //prevController.getall_spwr_solutions_Next();
       // prevController.getcustomer_Satisfaction_Next();
       // prevController.getperformance_to_business_Plan_Next();
      //  prevController.gettraining_Next();
        //prevController.getmarketing_Next();
       // prevController.getpartnerTier();
       // prevController.getAccountName();
       // prevController.getPartnerType();
       // prevController.getValidEvalFromDate();
       // prevController.getValidEvalToDate();
        prevController.getShowNextTab();
        prevController.getTierStartDate();
        prevController.getisExecutiveManager();
        prevController.getAccTheatre();
        prevController.enableInputFields();
        prevController.getShowLink();
       // prevController.getSPWRCurrentFlag();
       // prevController.getSPWRNextFlag();
       
        prevController.getIsPortalUser();
        prevController.expandChildren();
        prevController.updateEvaluation();
        prevController.getpartnerTier();
        prevController.getAccountName();
        prevController.getPartnerType();
        prevController.getValidEvalFromDate();
        prevController.getValidEvalToDate();
        PerformanceEvalPreviousCommController prevController1 = new PerformanceEvalPreviousCommController(selectedAcc.id);
        ApexPages.StandardController stdController = new ApexPages.StandardController (selectedAcc);
        PerformanceEvalPreviousCommController extPrevController1 = new PerformanceEvalPreviousCommController(stdController);

        Test.stopTest();
    }
    
    public static testMethod void testPreviousPerformance2(){
        Account selectedAcc;
        List<Account> listAccs = [select Id, Name from account where type like '%Premier-Partner-Combo%' and Theater__c='North America' and status__c='active' limit 1];
        if(listAccs != null && listAccs.size() > 0){
            selectedAcc = listAccs.get(0);
        }
        Test.startTest();
        Test.setCurrentPage(Page.PerformanceEvalPreviousComm);
        ApexPages.currentPage().getParameters().put('accId',selectedAcc.ID);
        ApexPages.currentPage().getParameters().put('period','2');
        ApexPages.currentPage().getParameters().put('year','2010');
        PerformanceEvalPreviousCommController prevController = new PerformanceEvalPreviousCommController();     
        Test.stopTest();
    }
    
    public static testMethod void testPreviousPerformance3(){
        Account selectedAcc;
        List<Account> listAccs = [select Id, Name from account where type like '%Authorized-Partner-Combo%' and Theater__c='North America' and status__c='active' limit 1];
        if(listAccs != null && listAccs.size() > 0){
            selectedAcc = listAccs.get(0);
        }
        Test.startTest();
        Test.setCurrentPage(Page.PerformanceEvalPreviousComm);
        ApexPages.currentPage().getParameters().put('accId',selectedAcc.ID);
        ApexPages.currentPage().getParameters().put('period','2');
        ApexPages.currentPage().getParameters().put('year','2010');
        PerformanceEvalPreviousCommController prevController = new PerformanceEvalPreviousCommController();     
        Test.stopTest();
   }
   /* public static testMethod void testPreviousPerformanceComm1(){
        Account selectedAcc;
        List<Account> listAccs = [select Id, Name from account where type like '%Elite-Partner-Combo%' and Theater__c='North America' and status__c='active' limit 1];
        if(listAccs != null && listAccs.size() > 0){
            selectedAcc = listAccs.get(0);
        }
        Test.startTest();
        Test.setCurrentPage(Page.PerformanceEvalPreviousComm);
        ApexPages.currentPage().getParameters().put('accId',selectedAcc.ID);
        ApexPages.currentPage().getParameters().put('period','2');
        ApexPages.currentPage().getParameters().put('year','2010');
        PerformanceEvalPreviousCommController prevController = new PerformanceEvalPreviousCommController();
        prevController.getPartnerExecutive();
        prevController.getHideHeaderForPartner();
        prevController.getDisableEditButton();
        prevController.getDisableButton();
        prevController.setDisableButton(true);
        prevController.getparamExpDate();
        prevController.getperformanceMetricID();
        prevController.getparamStartDate();
        prevController.getparamEndDate();
        prevController.getaccountId();
        prevController.getvalidExpToDate();
        prevController.getcustomer_Satisfaction_Current();
        prevController.getperformance_to_business_Plan_Current();
        prevController.gettraining_Current();
        prevController.gettraining_Current_Clone();
        //prevController.getmarketing_Current();
        prevController.getall_spwr_solutions_Current();
        prevController.getall_spwr_solutions_Next();
        prevController.getcustomer_Satisfaction_Next();
        prevController.getperformance_to_business_Plan_Next();
        prevController.gettraining_Next();
        //prevController.getmarketing_Next();
        prevController.getpartnerTier();
        prevController.getAccountName();
        prevController.getPartnerType();
        prevController.getValidEvalFromDate();
        prevController.getValidEvalToDate();
        prevController.getShowNextTab();
        prevController.getTierStartDate();
        prevController.getisExecutiveManager();
        prevController.getAccTheatre();
        prevController.enableInputFields();
        prevController.getShowLink();
        prevController.getSPWRCurrentFlag();
        prevController.getSPWRNextFlag();
        Test.stopTest();
    }
    
    public static testMethod void testPreviousPerformance2(){
        Account selectedAcc;
        List<Account> listAccs = [select Id, Name from account where type like '%Premier-Partner-Combo%' and Theater__c='North America' and status__c='active' limit 1];
        if(listAccs != null && listAccs.size() > 0){
            selectedAcc = listAccs.get(0);
        }
        Test.startTest();
        Test.setCurrentPage(Page.PerformanceEvalPreviousComm);
        ApexPages.currentPage().getParameters().put('accId',selectedAcc.ID);
        ApexPages.currentPage().getParameters().put('period','2');
        ApexPages.currentPage().getParameters().put('year','2010');
        PerformanceEvalPreviousCommController prevController = new PerformanceEvalPreviousCommController();     
        Test.stopTest();
    }
    
    public static testMethod void testPreviousPerformance3(){
        Account selectedAcc;
        List<Account> listAccs = [select Id, Name from account where type like '%Authorized-Partner-Combo%' and Theater__c='North America' and status__c='active' limit 1];
        if(listAccs != null && listAccs.size() > 0){
            selectedAcc = listAccs.get(0);
        }
        Test.startTest();
        Test.setCurrentPage(Page.PerformanceEvalPreviousComm);
        ApexPages.currentPage().getParameters().put('accId',selectedAcc.ID);
        ApexPages.currentPage().getParameters().put('period','2');
        ApexPages.currentPage().getParameters().put('year','2010');
        PerformanceEvalPreviousCommController prevController = new PerformanceEvalPreviousCommController();     
        Test.stopTest();
    }*/
}