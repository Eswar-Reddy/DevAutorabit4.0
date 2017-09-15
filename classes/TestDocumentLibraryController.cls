/**************************************************
**Created By- Anuradha Suthar
**Created On- July 22 2009
**Last Modified- 
**Last Modified On- July 22 2009  
**Desciption- Test class for class DocumentLibraryController
**************************************************
*****************************************************/
public class TestDocumentLibraryController{
  
  @isTest
  public static void checkDocumentLibraryController(){
      //Create object of controller class
      DocumentLibraryController objCocLib = new DocumentLibraryController();
      
      //Create content record
      Content__c c = new Content__c(title__c='TestContent',External_ID__c=String.valueOf(DateTime.now()));
      insert c;      
      
      //Start test
      Test.startTest();
      //Call methods for paging
      objCocLib.SetPagingForKnowledgeBase();
      objCocLib.SetPagingForProcess();
      objCocLib.SetPagingForMarketing();
      objCocLib.SetPagingForTechnical();
      
      //Method for searching content
      objCocLib.FillKnowledgeDoclistBySearch();     
      objCocLib.FillProcessDocBySearch();
      objCocLib.FillMarketingDocBySearch();
      objCocLib.FillTechnicalDocBySearch();
      
      //Method to show all knowledge base data
      objCocLib.FillKnowledgeBaseDoclist();
      //Method to show recent contents
      objCocLib.FillRecentDoclist();
      //Method to show popular contents
      objCocLib.FillPopularDoclist();
      //Method to show and hide archival contents
      objCocLib.ShowHideArchiveData();
      
      //Call remove method
      objCocLib.idToDelete = String.valueOf(c.id);
      objCocLib.remove();
      //Stop test
      Test.stopTest();
  }
}