@isTest
public class TestTaskAfterUpdate
{

 static testMethod  void Test_TaskAfterUpdate()
 {
        Set<Id> tskForEmail = new Set<Id>();
        Set<Id> sOwnerandCreator = new Set<Id>();
        String username ='testbh@world.com';
        User userObj = new User(LastName = 'Hello222' ,FirstName = 'W');
        userObj.Username = username;
        userObj.Alias = 'yoo1';
        userObj.CommunityNickname = username.subString(0,7);
        userObj.TimeZoneSidKey = 'America/Los_Angeles';
        userObj.EmailEncodingKey = 'ISO-8859-1';
        userObj.LanguageLocaleKey = 'en_US';
        userObj.Email ='t@test.com';
        userObj.LocaleSidKey = 'en_US';
        userObj.Country_Domain__c='rvar-us';
        userObj.Country='United States';
        userObj.Division='IT';
        userObj.ByPassValidation__c=True;
        List<Profile> lstProfile = [select Id from Profile where Name = 'System Administrator'];
        if(lstProfile.Size()>0){
            userObj.ProfileId = lstProfile[0].Id;
            insert userObj;
        }
        List<RecordType> Rd =[SELECT id FROM RecordType WHERE Name = 'Call Task'];
   Task taskObj = new Task();
   if(Rd.Size()>0)
   {
   taskObj.RecordTypeId=Rd[0].Id;
   }
   taskObj.OwnerId =userObj.Id;
   taskObj.Status='Not Started';
   taskObj.Priority='Normal';
   taskObj.Subject='Call';
   taskObj.Send_Email_When_Task_Is_Completed__c=False;
   insert taskObj;
   taskObj.Send_Email_When_Task_Is_Completed__c=true;
   taskObj.Status='Completed';
   Update taskObj;
   Task tsk=[Select id, CreatedById from Task where id =:taskObj.Id];
   sOwnerandCreator.add(taskObj.OwnerId);
   sOwnerandCreator.add(tsk.CreatedById);
   system.debug('Owener'+taskObj.OwnerId);
   system.debug('Createdby'+tsk.CreatedById);
   tskForEmail.add(taskObj.Id);
   if(!sOwnerandCreator.isEmpty()){
        Map<Id, User> mUsr = new Map<Id, User>([SELECT id, email, name FROM User WHERE id IN: sOwnerandCreator]);
       string OwnerEmail= mUsr.get(taskObj.OwnerId).Email;
       string createdEmail=mUsr.get(tsk.CreatedById).Email;
       system.debug('+++++'+OwnerEmail);
       system.debug('++++++'+createdEmail);
        List<Messaging.SingleEmailMessage> sendMail = new List<Messaging.SingleEmailMessage>();
        system.debug('*****'+mUsr);  
        for(Id tId: tskForEmail){
            Task tempT = new Task();
            tempT.Id=tId;
            string fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + tempT.Id;
            
            Messaging.SingleEmailMessage taskMail = new Messaging.SingleEmailMessage();
                taskMail.setToAddresses(new String[]{ OwnerEmail,createdEmail });

                taskMail.setSubject(tempT.Subject);
                string str='Hello';
                 taskMail.setHTMLBody(str);
            sendMail.add(taskMail);     
            }
            system.debug('Not Enter Here');
            if(!sendMail.isEmpty()){
            system.debug('Enter Here');
            Messaging.sendEmail(sendMail);
System.debug('>>> Task Email Sent.\nTotal Email: ' + sendMail.size() + '\nsendMail: ' + sendMail);          
        }
        }
   
 }
}