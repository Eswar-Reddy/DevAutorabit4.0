// ************************************************************/
// Name : TestSIFReportController 
// Created On : 21 Dec 2010
// Created By : Jitendra Kothari
// Implementation: Test class for SIF Report Controller class.
//  This Class has been implemented under case : 
// ***** *******************************************************/
public class TestSIFReportController {
    @IsTest
    public static void testSIFReportController(){               
        Test.startTest();
        SIFReportController sr = new SIFReportController();
        List<String> input = new List<String>();
        input.add('UPP Intl');
        sr.setBusiUnits(input);
        sr.getData();
        sr.exportToExcel();
        sr.exportToPdf();
        sr.sendEmailToUser = 'test@test.com';
        sr.exportToPDFAndEmail();
        input.add('RLC');
        sr.setBusiUnits(input);
        input.clear();
        input.add('Australia');
        input.add('China');
        input.add('France');
        sr.setRegions(input);
        input.clear();
        input.add('PACA');
        sr.setSubRegions(input);        
        input.clear();
        input.add('01 – Assess Opportunity');
        sr.setSalesStages(input);
        sr.getData();
        sr.strEmailDealerBcc = 'test@test.com';
        sr.strEmailDealerCC = 'test@test.com';
        sr.exportToPDFAndEmail();
        sr.getListBusiUnits();
        sr.getListRegion();
        sr.getListSubRegion();          
        sr.getListSalesStage();
        sr.getListSiteStatus();
        sr.getBusiUnits();
        sr.getRegions();
        sr.getSitestatus();
        sr.getSubRegions();
        sr.getSalesStages();
        input.clear();
        sr.setsitestatus(input);
        Test.stopTest();
    }
}