/**************************************************
** PR- 01923
**Created By- Harsh Mathur
**Created On- May 13 2009
**Last Modified- Harsh Mathur
**Last Modified On-  June 17 2009 
**Desciption- Test class for controller AfterAccountGeographyDelete
*****************************************************/

public class TestContractManagement {
    @isTest
    public static void checkInsertUpdateContract(){
        Test.startTest();
        List<Contract> conts = new List<Contract>();
        List<Contract> oldConts = new List<Contract>();        
        try{
        Account acc = new Account(name= 'test222' + String.ValueOf(DateTime.Now()));
        acc.Type ='Commercial';
        acc.billingCity = 'TestCity';
	    acc.BillingCountry = 'TestCountry';
	    acc.BillingPostalCode = '12345';
	    acc.BillingState = 'TestState';
	    acc.BillingStreet = 'TestStreet';
        insert acc;
        Contact cont = new Contact (firstname='test'+ String.ValueOf(DateTime.Now()) ,lastname= 'test'+ String.ValueOf(DateTime.Now()));
        cont.Email= 'helloContract'+ +'@world.com';
        cont.accountId=acc.Id;
        insert cont;
        acc.isPartner= true;
        upsert acc;
        User user = new User();
        	List<User> userList = new List<User>([SELECT Id,LastName, FirstName, ContactId, Username, Alias, CommunityNickname, TimeZoneSidKey, EmailEncodingKey, LanguageLocaleKey, Email, LocaleSidKey, Profile.Name  from User where Profile.Name = 'EU Partner Sales' and IsActive = true limit 1]);
        	if(userList.size()>0){
        		user = userList.get(0);
        }else{
	        String username =cont.Email;
	        user = new User(LastName = 'Hello222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
	        user.ContactId = cont.Id;
	        user.Username = username;
	        user.IsActive = true;
	        user.Alias = 'zxc';
	        user.CommunityNickname = username.subString(0,7);
	        user.TimeZoneSidKey = 'America/Los_Angeles';
	        user.EmailEncodingKey = 'ISO-8859-1';
	        user.LanguageLocaleKey = 'en_US';
	        user.Email = cont.Email;
	        user.LocaleSidKey = 'en_US';
	        List<Profile> lstProfile = [select Id from Profile where Name = 'EU Partner Sales'];
	         
	        if(lstProfile.Size()>0){
	            user.ProfileId = lstProfile[0].Id;            
	            insert user;                    
	        }
        }  
          
        //Check for Contarct insert
        //Account acc = new Account(Name='TestAcc'+Datetime.now().format());
        //insert acc;
        Contract con = new Contract(Name='TestContract'+Datetime.now().format(),AccountID=acc.id); 
        con.CustomerSignedID = cont.ID;        
        con.X30_Days_Before_Contract_Deadline__c =false;
        con.X7_Days_Before_Contract_Deadline__c = false;
        con.X15_Days_Before_Contract_Deadline__c = false;
        conts.Add(con);
        con.X45_Days_Before_Contract_Deadline__c =false;
        insert conts;
        }  
         catch(Exception ex){
        } 
        try{
	               
	        //Check for Contarct update
	        date myDate = date.newInstance(2009, 5, 13);
	        //conts[0].EndDate=myDate;    
	        conts[0].X30_Days_Before_Contract_Deadline__c =true;
	       
	        update conts;
	        
	        conts[0].X7_Days_Before_Contract_Deadline__c = true;
	        update conts;
	        conts[0].X45_Days_Before_Contract_Deadline__c = true;
	        update conts;
	        conts[0].X15_Days_Before_Contract_Deadline__c = true;
	        update conts;
	        
	       
        }
        catch(Exception ex){
        }
        Test.stopTest();
    }
}