/**************************************************
** PR- 01923
**Created By- Linda Evans
**Created On- July 31 2009
**Last Modified- 
**Last Modified On-   
**Desciption- Test class for controller LeadManagement
*****************************************************/
 
public class TestLeadManagement {
  @isTest
  public static void checkInsertUpdateLead(){
    Lead lstLead = new Lead();
    
    //Check for Lead insert
    lstLead.FirstName = 'Test';
    lstLead.LastName = 'Commercial';
    lstLead.Lead_Type__c='Commercial';
    lstLead.Company = 'TEST Company A';
    lstLead.Country = 'North America';
    lstLead.Email = 'testEmail@test123.com';
    lstLead.Phone = '09829098290';
    lstLead.LeadSource = 'Web';
    insert lstLead;
    
    //Check for Lead update
    lstLead.Lead_Type__c='Residential';   
    lstLead.Company = 'TEST Company B';
    update lstLead;    
  }
  
  @isTest
  public static void checkInsertUpdateLeadForLeadValidation(){
    
    //Select RecordType
    RecordType rtype = [select id,name from recordType where name Like 'System%' and SobjectType='Lead'];
   
    Lead lstLead = new Lead();
    
    //Check for Lead insert
    lstLead.FirstName = 'Test';
    lstLead.LastName = 'Commercial';
    lstLead.Lead_Type__c='Commercial';
    lstLead.Company = 'TEST Company A';
    lstLead.Country = 'North America';
    lstLead.Email = 'testEmail@test123.com';
    lstLead.Phone = '09829098290';
    lstLead.LeadSource = 'Web';
    lstLead.RecordTypeId=rtype.id;
    insert lstLead;
    
    //Check for Lead update
    lstLead.Lead_Type__c='Residential';   
    lstLead.Company = 'TEST Company B';
    update lstLead;    
  }
  
  //Check AssignmentRule functionality
  @isTest
  public static void checkInsertUpdateLead2(){
    String username ='hello1010@world.com';
    User user = new User(LastName = 'Hello222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
    user.Username = username;
    user.Alias = 'yoo123';
    user.Country_Domain__c ='rvar-fr';
    user.Country = 'Italy';
    user.Country_Domain__c = 'rvar-us';
    user.Division ='SunPower EU';
    user.CommunityNickname = username.subString(0,7);
    user.TimeZoneSidKey = 'America/Los_Angeles';
    user.EmailEncodingKey = 'ISO-8859-1';
    user.LanguageLocaleKey = 'en_US';
    user.Email = 'testLeadManage@tt.com';
    user.LocaleSidKey = 'en_US';
    user.Web_User__c = True;
    //List<Profile> lstProfile = [select Id from Profile where Name = 'Marketing User'];
        //if(lstProfile.Size()>0){
           // user.ProfileId = lstProfile[0].Id;
            //insert user;
        //}
    ID userID = Userinfo.getUserId();    
    List<Profile> lstProfile = [select Id from Profile where Name = 'SunPower Super User'];
        if(lstProfile.Size()>0){
            user.ProfileId = lstProfile[0].Id;
            user.Case_Number__c ='123';
            insert user;
        }
        
       System.runAs(user){
        Lead lstLead = new Lead();
        //Check for Lead insert
        lstLead.FirstName = 'Test';
        lstLead.LastName = 'Commercial';
        lstLead.Lead_Type__c='Commercial';
        lstLead.Company = 'TEST Company A';
        lstLead.Country = 'North America';
        lstLead.Theater__c ='Asia Pacific';
        lstLead.Email = 'testEmail@test3.com';
        lstLead.Phone = '09829098290';
        lstLead.LeadSource = 'Web';
        lstLead.Date_Time_First_follow_up__c = Datetime.now();
        lstLead.Date_Time_second_follow_up__c = Datetime.now();
        lstLead.Date_Time_third_follow_up__c = Datetime.now();
        lstLead.Date_Time_Fourth_follow_up__c = Datetime.now();
        lstLead.Date_Time_Fifth_follow_up__c = Datetime.now();
        //insert lstLead;
    }
  }
   //Check AfetrLeadStatusUpdate functionality
  @isTest
  public static void checkLeadStatusUpdate(){
    RecordType rtype = [select id,name from recordType where name Like 'System%' and SobjectType='Lead'];
    RecordType rtype1 = [select id,name from recordType where name Like 'Partner' and SobjectType='Lead'];
    
    String username ='hello1010@world.com';
    User user = new User(LastName = 'Hello222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
    user.Username = username;
    user.Alias = 'yoo123';
    user.Country_Domain__c ='rvar-fr';
    user.Country = 'Italy';
    user.Country_Domain__c = 'rvar-us';
    user.Division ='SunPower EU';
    user.CommunityNickname = username.subString(0,7);
    user.TimeZoneSidKey = 'America/Los_Angeles';
    user.EmailEncodingKey = 'ISO-8859-1';
    user.LanguageLocaleKey = 'en_US';
    user.Email = 'testLeadManage@tt.com';
    user.LocaleSidKey = 'en_US';
    user.Web_User__c = True;
    ID userID = Userinfo.getUserId();    
    List<Profile> lstProfile = [select Id from Profile where Name = 'SunPower Super User'];
        if(lstProfile.Size()>0){
            user.ProfileId = lstProfile[0].Id;
            user.Case_Number__c ='123';
            insert user;
        }
        
       System.runAs(user){
       
        Lead lead1 = new Lead();
        //Check for Lead insert
        lead1.FirstName = 'Test';
        lead1.LastName = 'Commercial';
        lead1.lead_Type__c='Commercial';
        lead1.Company = 'TEST Company A';
      //  lead1.Country = 'North America';
        lead1.Theater__c ='Asia Pacific';
        lead1.Email = 'testEmail@test3.com';
        lead1.Phone = '09829098290';
        lead1.leadSource = 'Web';
        lead1.RecordTypeId =rtype1.id;
        lead1.Business_Unit__c = 'NA Commercial';
        insert lead1;
        
        
        //creating  Site_Information_Form_c
        
         Site_Information_Form__c site = new Site_Information_Form__c();
         site.Lead__c = lead1.id;
         site.Site_Address__c='123-link road';
         site.Site_City__c='london';
         site.Site_Zip_Postal_Code__c='12345';
         site.Site_State__c='London';
         insert site;
             
       
         List<Lead> lstLead = new List<Lead>();
        lstLead.add(lead1);
        
        List<Lead> fetchLead =new List<Lead>([select State,First_follow_up__c,Second_follow_up__c,Third_follow_up__c,Fourth_follow_up__c,Fifth_follow_up__c,Promo_Code__c,RLC_Type__c,Business_Unit__c,status,IsConverted,RecordTypeId from lead where id=:lead1.id]);
        List<lead> newlstLead = new List<lead>();
        //Check for Lead update
        for(Lead l:fetchLead){
        l.status='Qualified';   
       // l.IsConverted = false;
        l.RecordTypeId =rtype.id;
        l.Promo_Code__c='12345';
        l.Business_Unit__c = 'RLC';
        l.RLC_Type__c = 'Light Commercial';
        l.First_follow_up__c =true;
        l.Second_follow_up__c=true;
        l.Third_follow_up__c=true;
        l.Fourth_follow_up__c=true;
        l.Fifth_follow_up__c=true;
        l.State = 'testState';
        l.country='UK';
        newlstLead.add(l);
        }
        LeadManagement.setLeadFields(newlstLead);
        LeadManagement.updateFollowUpDateTimeAtInsertion(newlstLead);
        LeadManagement.updateFollowUpDateTime(newlstLead,lstLead);
        LeadManagement.setCampaign(newlstLead);
        LeadManagement.shareLeadRecordsAfterInsertAndUpdate(newlstLead,new Map<id,Lead>(lstLead));
        LeadManagement.AfetrLeadStatusUpdate(newlstLead,new Map<id,Lead>(lstLead));
    }
  }
    
}