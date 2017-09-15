@isTest
  public class TestUpdateOppOnAcctOwnerChange
  {
 
 public static Testmethod void TestUpdateOppOnAcctOwnerChange()
    {
        Account acct = getPartnerAccount();
        User u =getPartnerPortalUser(acct); 
        
        Test.startTest();
        Opportunity opp = new Opportunity(Name='opp'+String.valueOf(DateTime.Now()),AccountID=acct.id,stagename='50% - Value Proposition',closedate=date.today());
        opp.Probability =50;
        insert opp;    
        
        Test.stoptest();   
        acct.ownerId=u.id;//We are assigning user id to account owner id
        //update acct;
       
        
        /**
        If(Util.HasTriggerRun())
        return; 
               if(acct.id!=null)
               {    
                Opportunity op = createOpp(acct,u);
                
                 if(op!=null) 
                 {
                op.Dummy_Update_on_Opportunity__c=true;  
                Util.setTriggerHasRun();
                update op;
                }
                
               }                                       
        **/   
                    
      }

    
    private static Account getPartnerAccount(){
        String recType ='';
        for(RecordType r:[select id,Name from RecordType where sObjectType ='Account' and name ='Residential Customer' LIMIT 1])
             recType = r.ID;             
        Account acct = new Account(name='test',recordTypeID=recType,Type='Home Owner');       
        acct.BillingCity = 'Agra';
        acct.BillingStreet = 'Gandhi Nagar';
        acct.BillingCountry = 'India';
        acct.BillingState='UP';
        acct.BillingPostalCode ='282003';
        acct.OwnerId=UserInfo.getUserId();     
        
        insert acct;        
        return acct;                     
    }
      
     private static User getPartnerPortalUser(Account acct){
     User user = null;
     for(User u:[select id,UserType,Name,contactId,Contact.AccountID, Contact.Account.Id,Contact.Account.AccountNumber,Contact.Account.Name from User where UserType='PowerPartner' and IsActive=True limit 1])
     {
        user =u;
      }
     if(user != null) 
     return user;
     if(acct == null)
     {
      acct =  getPartnerAccount();
     }
        Contact cont = new Contact(AccountID = acct.id,FirstName='testconbybh',LastName='testconbybh');
        cont.Email ='te@test.com';
        cont.Authorized_to_Order__c = true;
        insert cont;        
        String username ='testbh@world.com';
        user = new User(LastName = 'Hello222' ,FirstName = 'W');
        user.ContactId = cont.Id;
        user.Username = username;
        user.Alias = 'yoo1';
        user.CommunityNickname = username.subString(0,7);
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.Email = cont.Email;
        user.LocaleSidKey = 'en_US';     
        List<Profile> lstProfile = [select Id from Profile where Name = 'Partner Executive'];
        if(lstProfile.Size()>0){
            user.ProfileId = lstProfile[0].Id;
            insert user;
        }
        if(user.Id != null)
            for(User u:[select id,UserType,Name,contactId,Contact.AccountID, Contact.Account.Id,Contact.Account.AccountNumber,Contact.Account.Name from User where id =:user.ID and UserType='PowerPartner' LIMIT 1])
                user = u; 
        return user;
        }
        
        public static Opportunity createOpp(Account acct,User u)
        {
        Opportunity opp1 = new Opportunity();
        opp1.AccountId = acct.ID;
        opp1.Name = 'testOpp1';
        opp1.StageName = 'New Opportunity';
        opp1.ownerId = acct.OwnerId;
        opp1.Probability =10;
        opp1.Dummy_Update_on_Opportunity__c=false;
        opp1.CloseDate = System.today();
        Insert opp1;
        return opp1;
       }
        
    }