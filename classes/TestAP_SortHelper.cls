/**************************************************
** PR- 01923
**Created By- Harsh Mathur
**Created On- June 11 2009
**Last Modified- 
**Last Modified On-   
**Desciption- Test class for controller AP_SortHelper
*****************************************************/

public class TestAP_SortHelper 
{
    @isTest
    private static void Test_AP_SortHelper()
    {
       AP_SortHelper contoller = new AP_SortHelper();
       List<sObject> sObj= contoller.getSortedList(Database.Query('select Id , Name from Account limit 500'),'Name',true); 
    }
}