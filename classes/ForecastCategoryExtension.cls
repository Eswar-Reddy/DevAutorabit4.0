public class ForecastCategoryExtension
{

  public Boolean status {get;set;}
  Opportunity oppor;
  public ID opporId = ApexPages.currentPage().getParameters().get('id');
  
  public ForecastCategoryExtension(ApexPages.StandardController stdController)     
  {        
    this.oppor = (Opportunity )stdController.getRecord();   
   hide();     
  }
  
  public Boolean strshow {get;set;}
  public Boolean strHide {get;set;}
 
  
  public void hide()
  {
  
  
  List<String> lstProfile = new List<String>();
  lstProfile.add('Sales Analyst');
  lstProfile.add('Sales Management');
  lstProfile.add('Sales Management - Components');
  lstProfile.add('Sales Analyst - EU');
  lstProfile.add('Sales Person - EU');
  lstProfile.add('Sales Management - EU');
  lstProfile.add('System Administrator');
  lstProfile.add('Global Sales Ops');
  lstProfile.add('Sales Ops');
  lstProfile.add('Sales Person');
  lstProfile.add('Sales Person - Components');
  lstProfile.add('SunPower Administrator');
  
  //Raul's Request case#00092712 BEGIN
 lstProfile.add('Sales Ops - UPP');
 //case#00092712 END
 
  

  List<String> lstTeamRole = new List<String>();
  lstTeamRole.add('Sales Person');
  lstTeamRole.add('Sales Analyst');
  lstTeamRole.add('Sales Manager');
  lstTeamRole.add('Business Development Rep');

  
  List<ID> proId = New List<ID>();
  List<ID> RoleId = New List<ID>();

   strHide = true ;

  User user1 = [Select id,Name,ProfileId,UserRoleId from User where id =: UserInfo.getUserId()];

  List<Profile> pro = [Select id,Name from Profile where Name in: lstProfile];
  
  for(Profile nextPro :pro)
  {
       
      If(user1.ProfileId == nextPro.id)
      {
        strshow = True;
        strHide = false ;
      }
  }
  
  
  

  List<OpportunityTeamMember> lstOppTeamMem = [Select id,userid,teammemberrole from OpportunityTeamMember 
                                      where opportunityid=:oppor.Id and userid=:user1.id
                                      and teammemberrole in:lstTeamRole];

  if(lstOppTeamMem.size()>0){
         strshow = True;
        strHide = false ;
    }
  
 
  
  }
 
  
  
  //public PageReference Refresh()
  public  void Refresh()

  { 
  try{ 
   Update oppor;
   status = true ;
   
   }catch(exception ex){
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getDmlMessage(0)));
   }
  
  }
  
  public PageReference goBack(){
   PageReference opporPage = new ApexPages.StandardController(oppor).view();
   opporPage.setRedirect(true);
   return opporPage ;
  }
  
}