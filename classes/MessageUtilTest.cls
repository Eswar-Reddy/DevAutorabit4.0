/*
===========================================================================================================================================
  Date      Owner       Comment
===========================================================================================================================================
1-27-2015      Niket      Written Test class : MessageUtil    
*/
@isTest
private class MessageUtilTest {

  public static testMethod void MessageUtilTestMethod(){
        MessageUtil err = new MessageUtil();
        err.Success = false;
        
        MessageUtil eError = new MessageUtil();
        eError = MessageUtil.DebugLog('Data saved successfully');
        MessageUtil errMessage = MessageUtil.LogError('Error occured while Saving!!');
        MessageUtil errMessageFail = MessageUtil.LogSuccess('Data saved successfully'); 
        
        Contact contactNew = new Contact();
        contactNew.MailingState = 'CA';
        contactNew.MailingPostalCode = '94965';
        contactNew.LastName = 'test';
        
        Database.SaveResult saveResult = Database.insert(contactNew);
        
        try{
            MessageUtil.LogSaveResult(saveResult, '');
            throw new MessageUtil.MessageException('test');
        }
        catch(Exception ex){
            MessageUtil.LogException(ex);
        }
    }
}