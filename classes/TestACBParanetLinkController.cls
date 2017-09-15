/**************************************************
** PR- 01923
**Created By- Kapil Goutam
**Created On- June 10 2009
**Last Modified- 
**Last Modified On-   
**Desciption- Test class for Controller ACBParanetLinkController
*****************************************************/
public class TestACBParanetLinkController{
  @isTest
  public static void Test_ACBParanetLinkController(){    
    List<User> listUser = new List<User>([Select Id, Name from User where Profile.Name like '%Partner%' and isActive = true limit 1]);
    if(listUser.Size() > 0){
      System.runAs(listUser.get(0)){
        ACBParanetLinkController linkController = new ACBParanetLinkController();   
        linkController.getUserId();
      }
    }         
    listUser = new List<User>([Select Id, Name from User where Profile.Name in ('SunPower User','SunPower Super User','System Administrator') and isActive = true limit 1]);
    if(listUser.Size() > 0){
      System.runAs(listUser.get(0)){
        ACBParanetLinkController linkController = new ACBParanetLinkController();   
      }
    }        
  }    
}