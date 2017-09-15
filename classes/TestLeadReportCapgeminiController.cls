/************************************************************************************
Name    : TestLeadReportCapgeminiController
Date    : Feb 20, 2010
Author  : Aashish Mathur
Purpose : Test class of apex class LeadReportCapgeminiController.
************************************************************************************/

@isTest
private class TestLeadReportCapgeminiController {
    @isTest
    public static void testController() {
        Test.startTest();
        LeadReportCapgeminiController controller = new LeadReportCapgeminiController();
        controller.Governor_Limit = 500;
        controller.doSearch();
        
        controller.company = 'Company';
        controller.commaSeparatedRoles = 'Role';
        controller.LEAD_FOR_FROM_DATE.CSAT_last_reponse_date__c =
                controller.LEAD_FOR_TO_DATE.CSAT_last_reponse_date__c = Datetime.now();
        controller.doSearch();
        
        List<LeadHistory> leadHistoryList = [SELECT CreatedDate, CreatedBy.Email, CreatedBy.UserRole.Name
                FROM LeadHistory WHERE CreatedBy.IsActive = true LIMIT 1];
        
        if (leadHistoryList.size() == 0) {
            return;
        }
        
        controller.company = leadHistoryList[0].CreatedBy.Email;
        controller.commaSeparatedRoles = leadHistoryList[0].CreatedBy.UserRole.Name;
        controller.LEAD_FOR_FROM_DATE.CSAT_last_reponse_date__c =
                controller.LEAD_FOR_TO_DATE.CSAT_last_reponse_date__c = leadHistoryList[0].CreatedDate;
        controller.doSearch();
        
        controller.exportToCSV();
        Test.stopTest();
    }
    
    @isTest
     // when Lead data returned on search
    public static void testController1() {
        Test.startTest();
        LeadReportCapgeminiController controller = new LeadReportCapgeminiController();
        List<String> roleList = new List<String>(); 
        for( UserRole u : [select id, name,PortalType from UserRole where PortalType='None' order by name limit 5]){  
            roleList.add(u.name);
        }
        
        controller.commaSeparatedRoles = 'Role';
        controller.LEAD_FOR_FROM_DATE.CSAT_last_reponse_date__c =
                controller.LEAD_FOR_TO_DATE.CSAT_last_reponse_date__c = Datetime.now();
    
        
        List<LeadHistory> leadHistoryList = [SELECT CreatedDate, CreatedBy.Email, CreatedBy.UserRole.Name
                FROM LeadHistory WHERE CreatedBy.IsActive = true AND CreatedBy.UserRole.Name IN: roleList LIMIT 1];
        
        if (leadHistoryList.size() == 0) {
            return;
        }
        
        controller.lstSelectedRoles.addALL(roleList);
        controller.company = 'sunpower';
        controller.commaSeparatedRoles = leadHistoryList[0].CreatedBy.UserRole.Name;
        controller.LEAD_FOR_FROM_DATE.CSAT_last_reponse_date__c = DateTime.newInstance(2010,1,1,0,0,0);
        controller.LEAD_FOR_TO_DATE.CSAT_last_reponse_date__c = DateTime.newInstance(2010,07,1,0,0,0);

        controller.doSearch();
        controller.exportToCSV();
        controller.clearSearch();                
        Test.stopTest();                        
    }
    
    @isTest
    // when NO Lead data returned on search
    public static void testController2() {
        Test.startTest();
        LeadReportCapgeminiController controller = new LeadReportCapgeminiController();
        List<String> roleList = new List<String>(); 
        for( UserRole u : [select id, name,PortalType from UserRole where PortalType='None' order by name limit 5]){  
            roleList.add(u.name);
        }
        
        controller.commaSeparatedRoles = 'Role';
        controller.LEAD_FOR_FROM_DATE.CSAT_last_reponse_date__c =
                controller.LEAD_FOR_TO_DATE.CSAT_last_reponse_date__c = Datetime.now();
    
        
        List<LeadHistory> leadHistoryList = [SELECT CreatedDate, CreatedBy.Email, CreatedBy.UserRole.Name
                FROM LeadHistory WHERE CreatedBy.IsActive = true AND CreatedBy.UserRole.Name IN: roleList LIMIT 1];
        
        if (leadHistoryList.size() == 0) {
            return;
        }
        
        controller.lstSelectedRoles.addALL(roleList);
        controller.company = 'testxyz';
        controller.commaSeparatedRoles = leadHistoryList[0].CreatedBy.UserRole.Name;

        controller.doSearch();
        System.assertEquals('There is not any users of given Company and Roles.',controller.errorMsg);
        controller.exportToCSV();
        controller.clearSearch();                
        Test.stopTest();                                    
    }
    
    //madhuri
   
    @isTest
    public static void testController3() {
           Test.startTest();
        LeadReportCapgeminiController controller = new LeadReportCapgeminiController();
        List<String> roleList = new List<String>(); 
        for( UserRole u : [select id, name,PortalType from UserRole where PortalType='None' order by name limit 5]){  
            roleList.add(u.name);
        }
        
        controller.commaSeparatedRoles = 'Role';
        controller.LEAD_FOR_FROM_DATE.CSAT_last_reponse_date__c =
                controller.LEAD_FOR_TO_DATE.CSAT_last_reponse_date__c = Datetime.now();
    
        
        List<LeadHistory> leadHistoryList = [SELECT CreatedDate, CreatedBy.Email, CreatedBy.UserRole.Name
                FROM LeadHistory WHERE CreatedBy.IsActive = true AND CreatedBy.UserRole.Name IN: roleList LIMIT 1];
        
        if (leadHistoryList.size() == 0) {
            return;
        }
        
        controller.lstSelectedRoles.addALL(roleList);
        controller.company = 'sunpower';
        controller.commaSeparatedRoles = leadHistoryList[0].CreatedBy.UserRole.Name;
        controller.LEAD_FOR_FROM_DATE.CSAT_last_reponse_date__c = DateTime.newInstance(2011,1,1,0,0,0);
        controller.LEAD_FOR_TO_DATE.CSAT_last_reponse_date__c = DateTime.newInstance(2011,08,1,0,0,0);

        controller.doSearch();
        controller.exportToCSV();
        controller.clearSearch();                
        Test.stopTest();             
    }
   
 }