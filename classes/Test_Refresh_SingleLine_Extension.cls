Public Class Test_Refresh_SingleLine_Extension 
{
@isTest
public static void testSingle()
 {
 Test.startTest();
 
 ApexPages.StandardController con6 = new ApexPages.StandardController(new Single_Line__c());
 Refresh_SingleLine_Extension singleLine = new Refresh_SingleLine_Extension(con6);
 
 Refresh_SingleLine_Extension design3 = new Refresh_SingleLine_Extension(con6);
 
 Single_Line__c single = new Single_Line__c();
 single.Status__c = 'Active';
 single.Refresh_Count__c = 2;
 single.Single_Line_Tracking__c = System.Today();
 single.Single_Line_Completed__c = System.Today();
 insert single;

 
 singleLine.SingleLineid = single.id;
 singleLine.Refresh();
 
 ApexPages.currentPage().getParameters().put('id', single.id);
 
 
  //estimate.Refresh();
    
 Test.stopTest();
 
 }
 
}