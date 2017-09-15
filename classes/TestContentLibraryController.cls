/*********************************************
**PR-01772
**By- Kapil Goutam
**On- May 21 2009
**Description- Test Class for Controller Class
****************************************
**************************************/
public class TestContentLibraryController{
  @isTest
  public static void Test_ContentLibraryController(){
    ApexPages.StandardController controller = new ApexPages.StandardController(new Content__c());
    ContentLibraryController obj = new ContentLibraryController(controller);
    ContentLibraryController.Content c = new ContentLibraryController.Content();
    String  monthname = c.getMonthName(1);
    String selectedTab = obj.getSelectedTabForRedirection();
    String tab = obj.getSelectedTab();
    obj.setSelectedTab(tab);
    obj.getListEvent();
    obj.getListAnnouncements();
    obj.getListTaining();
    obj.getIsSunPowerSuperUser();
    obj.FillPopularDoclist();
    obj.FillRecentDoclist();
    obj.FillKnowledgeBaseDoclist();
    obj.FillTechnicalDocBySearch();
    obj.FillMarketingDocBySearch();
    obj.FillDoclistBySearch();
    obj.populateEvents();
    obj.populateTraining();
    obj.populateAnnouncement();
    obj.remove();
    obj.ShowHideArchiveData();
    obj.SearchString='test';
    obj.FillDoclistBySearch();
    obj.strClickedTechnical='First';
    obj.strClickedMarketing='First';
    obj.strClicked='First';
    obj.SetPagingForKnowledgeBase();
    obj.SetPagingForMarketing();
    obj.SetPagingForTechnical();
    Boolean isInclude = obj.getIsIncludeArchive();
    obj.setIsIncludeArchive(isInclude);
    obj.populateClips();
    String str = obj.getSelectedSubTab();
    obj.setSelectedSubTab(str);
    obj.getlistClips();
    
    ContentLibraryController.Content contObj = new ContentLibraryController.Content();
    for(Integer iter = 1; iter < 13; iter++){
      contObj.getMonthName(iter);
    }
  }
}