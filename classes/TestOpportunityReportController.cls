// ************************************************************/
// Name : TestOpportunityReportController 
// Created On : 21 Dec 2010
// Created By : Jitendra Kothari
// Implementation: Test class for Opportunity Report Controller class.
//  This Class has been implemented under case : 
// ***** *******************************************************/
public class TestOpportunityReportController {
    @IsTest
    public static void testOppReportController(){
        Test.startTest();
        OpportunityReportController orc = new OpportunityReportController();
        List<String> input = new List<String>();
        input.add('UPP Intl');
        orc.setBusiUnits(input);
        orc.getData();
        orc.exportToExcel();
        orc.exportToPdf();
        orc.sendEmailToUser = 'test@test.com';
        orc.exportToPDFAndEmail();
        input.add('RLC');
        orc.setBusiUnits(input);    
        input.clear();
        input.add('Australia');
        input.add('China');
        input.add('France');
        orc.setRegions(input);
        input.clear();
        input.add('PACA');
        orc.setSubRegions(input);
        input.clear();
        input.add('01 – Assess Opportunity');
        orc.setSalesStages(input);  
        input.clear();
        input.add('75.0');
        orc.setProbs(input);    
        orc.getData();
        orc.strEmailDealerBcc = 'test@test.com';
        orc.strEmailDealerCC = 'test@test.com';
        orc.exportToPDFAndEmail();
        orc.getListBusiUnits();
        orc.getListRegion();
        orc.getListSubRegion();         
        orc.getListSalesStage();
        orc.getListProb();
        orc.getBusiUnits();
        orc.getRegions();
        orc.getProbs();
        orc.getSubRegions();
        orc.getSalesStages();       
        Test.stopTest();
    }
}