Public Class Test_Refresh_Design_Extension 
{
@isTest
public static void test1()
 {
	Test.startTest();
	PageReference pageRef = Page.Refresh_Design;
	
	Design__c des = new Design__c();
	des.Status__c = 'Cancelled';
	des.Refresh_Count__c = 2;
	insert des;
	 
	ApexPages.currentPage().getParameters().put('id', des.id);
	ApexPages.StandardController con = new ApexPages.StandardController(des);
	Refresh_Design_Extension design1 = new Refresh_Design_Extension(con);
	design1.Refresh();
	
	List<Design__c> designExpectedList = [select id, status__c,Refresh_Count__c , Date_Design_Completed__c from Design__c where id = :des.Id];
	
	if(designExpectedList.size() > 0){
		Design__c designExpected = designExpectedList[0];
		System.assertEquals(designExpected.Refresh_Count__c , 3);
		System.assertEquals(designExpected.Date_Design_Completed__c , null);
	}
	    
	Test.stopTest();
 }
 
 
 
 
}