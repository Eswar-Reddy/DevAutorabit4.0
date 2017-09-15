/**
 * An apex custom controller class to support MetaData search and used by  
 * MetaSearchTool.page  
 * History:
 *        07/31/14  Kevin Huang  created. 
 */
public with sharing class MetaSearchTool {
    
    public String mInstanceUrl {get;set;}
    
    public MetaSearchTool(){
        mInstanceUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/';
    }
        
    @RemoteAction
    public static List<Folder> searchApexFolders(String folderType)
    {
        List<Folder> listFolder = new List<Folder>();
        listFolder = [SELECT Id, DeveloperName, Name FROM folder WHERE type= :folderType];
        return listFolder;
    }   

    @RemoteAction
    public static List<ApexClass> searchApexClassWithId(List<Id> listId)
    {
        List<ApexClass> listApexClass = new List<ApexClass>();
        listApexClass = [select id, name, body from ApexClass where id IN :listId];
        //return JSON.serialize(listApexClass);
        return listApexClass;
    }   

    @RemoteAction
    public static List<ApexPage> searchApexPageWithId(List<Id> listId)
    {       
        List<ApexPage> listApexPage = new List<ApexPage>();
        listApexPage = [select id, name, Markup from ApexPage where Id IN :listId];
        //System.debug(pageList);
        return listApexPage;
    }   

    @RemoteAction
    public static List<ApexTrigger> searchApexTriggerWithId(List<Id> listId)
    {
        List<ApexTrigger> listApexTrigger = new List<ApexTrigger>();
        listApexTrigger = [select id, name, Body from ApexTrigger where id IN :listId];
        return listApexTrigger;
    }   

    @RemoteAction
    public static List<ApexClass> searchApexClass()
    {
        List<ApexClass> listApexClass = new List<ApexClass>();
        listApexClass = [select id, name, body from ApexClass];
        //return JSON.serialize(listApexClass);
        return listApexClass;
    }   

    @RemoteAction
    public static List<ApexPage> searchApexPage()
    {
        List<ApexPage> listApexPage = new List<ApexPage>();
        listApexPage = [select id, name, Markup from ApexPage];
        return listApexPage;
    }   

    @RemoteAction
    public static List<ApexTrigger> searchApexTrigger()
    {
        List<ApexTrigger> listApexTrigger = new List<ApexTrigger>();
        listApexTrigger = [select id, name, Body from ApexTrigger];
        return listApexTrigger;
    }   

    @RemoteAction
    public static List<ApexClass> searchApexClassId()
    {
        List<ApexClass> listApexClass = new List<ApexClass>();
        listApexClass = [select id from ApexClass];
        //return JSON.serialize(listApexClass);
        return listApexClass;
    }   

    @RemoteAction
    public static List<ApexPage> searchApexPageId()
    {
        List<ApexPage> listApexPage = new List<ApexPage>();
        listApexPage = [select id from ApexPage];
        return listApexPage;
    }   

    @RemoteAction
    public static List<ApexTrigger> searchApexTriggerId()
    {
        List<ApexTrigger> listApexTrigger = new List<ApexTrigger>();
        listApexTrigger = [select id from ApexTrigger];
        return listApexTrigger;
    }   

    @RemoteAction
    public static List<Report> searchReportNames()
    {
        List<Report> lsReport = new List<Report>();
        lsReport = [select developerName from Report];
        return lsReport;
    }   

    @RemoteAction
    public static List<EmailTemplate> searchEmailTemplateNames()
    {
        List<EmailTemplate> lsTp = new List<EmailTemplate>();
        lsTp = [select developerName from EmailTemplate];
        return lsTp;
    }   
}