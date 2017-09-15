/**
 * An apex test class for MetaSearchTool 
 * History:
 *        07/31/14  Kevin Huang  created. 
 */
 
@IsTest(seeAllData=true)
public with sharing class MetaSearchToolTest {

    @IsTest
    public static void MetaSearchToolInstanceTest(){
        MetaSearchTool mst = new MetaSearchTool();
        System.assert(mst.mInstanceUrl.contains('salesforce.com'));     
    }

    @IsTest
    public static void searchApexFoldersTest()
    {
        Integer count = [SELECT count() FROM folder WHERE type = 'Report'];
        List<Folder> listFolder = new List<Folder>();
        listFolder = MetaSearchTool.searchApexFolders('Report');
        System.assert(count == listFolder.size());
    }   

    @IsTest
    public static void searchApexClassWithIdTest()
    {
        List<Id> listIds = new List<Id>(new Map<Id, ApexClass>([SELECT id from ApexClass Limit 10]).keySet());
        
        list<ApexClass> listAC = MetaSearchTool.searchApexClassWithId(listIds);
        System.assertEquals(listIds.size(), listAC.size());     
    }   

    @IsTest
    public static void searchApexPageWithIdTest()
    {
        List<Id> listIds = new List<Id>(new Map<Id, ApexPage>([SELECT id from ApexPage Limit 10]).keySet());
        
        list<ApexPage> listAP = MetaSearchTool.searchApexPageWithId(listIds);
        System.assertEquals(listIds.size(), listAP.size());     
    }   

    @IsTest
    public static void searchApexTriggerWithIdTest()
    {
        List<Id> listIds = new List<Id>((new Map<Id, ApexTrigger>([SELECT id from ApexTrigger Limit 10])).keySet());
        
        list<ApexTrigger> listAT = MetaSearchTool.searchApexTriggerWithId(listIds);
        System.assertEquals(listIds.size(), listAT.size());     
    }   

    @IsTest
    public static void searchApexClassTest()
    {
        List<ApexClass> listApexClass = [select id from ApexClass LIMIT 10];
        List<ApexClass> listAC = MetaSearchTool.searchApexClass();
        System.assert(listApexClass.size() <= listAC.size());
    }   

    @IsTest
    public static void searchApexPageTest()
    {
        List<ApexPage> listApexPage = [select id from ApexPage LIMIT 10];
        List<ApexPage> listAP = MetaSearchTool.searchApexPage();
        System.assert(listApexPage.size() <= listAP.size());
    }   

    @IsTest
    public static void searchApexTriggerTest()
    {
        List<ApexTrigger> listApexTrigger = [select id from ApexTrigger LIMIT 10];
        List<ApexTrigger> listAT = MetaSearchTool.searchApexTrigger();
        System.assert(listApexTrigger.size() <= listAT.size());
    }   

    @IsTest
    public static void searchApexClassIdTest()
    {
        List<ApexClass> listApexClass = [select id from ApexClass LIMIT 10];
        List<ApexClass> listAC        = MetaSearchTool.searchApexClassId();
        System.assert(listApexClass.size() <= listAC.size());
    }   

    @IsTest
    public static void searchApexPageIdTest()
    {
        List<ApexPage> listApexPage = [select id from ApexPage LIMIT 10];
        List<ApexPage> listAP        = MetaSearchTool.searchApexPageId();
        System.assert(listApexPage.size() <= listAP.size());
    }   

    @IsTest
    public static void searchApexTriggerIdTest()
    {
        List<ApexTrigger> listApexTrigger = [select id from ApexTrigger LIMIT 10];
        List<ApexTrigger> listAT        = MetaSearchTool.searchApexTriggerId();
        System.assert(listApexTrigger.size() <= listAT.size());
    }   

    @IsTest
    public static void searchReportNamesTest()
    {
        List<Report> lsReport = [select developerName from Report LIMIT 10];
        List<Report> lsR = MetaSearchTool.searchReportNames();
        System.assert(lsReport.size() <= lsR.size());
    }   

    @IsTest
    public static void searchEmailTemplateNamesTest()
    {
        List<EmailTemplate> lsEmailTemplate = [select developerName from EmailTemplate LIMIT 10];
        List<EmailTemplate> lsE = MetaSearchTool.searchEmailTemplateNames();
        System.assert(lsEmailTemplate.size() <= lsE.size());
    }   
}