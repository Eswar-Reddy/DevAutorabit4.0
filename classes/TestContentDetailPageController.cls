/**************************************************
** PR- 01923
**Created By- Kapil Goutam
**Created On- June 10 2009
**Last Modified- 
**Last Modified On-   
**Desciption- Test class for Controller 

*****************************************************/
public class TestContentDetailPageController {
    @isTest
    public static void Test_ContentDetailPageController(){
        Content__c contentObj = new Content__c();
        contentObj.Title__c = 'test content';
        contentObj.External_Id__c = 'test12';
        insert contentObj;
        Apexpages.currentPage().getParameters().put('cId', contentObj.Id);
        PageReference pr = new PageReference('/'+ contentObj.Id);
        Apexpages.currentPage().getParameters().put('retUrl', String.valueOf(pr));
        
        Apexpages.Standardcontroller controller = new Apexpages.Standardcontroller(contentObj);
        ContentDetailPageController contentController = new ContentDetailPageController(controller);
        contentController.insertTrackerObject();
        
    } 
}