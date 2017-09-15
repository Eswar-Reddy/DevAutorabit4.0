/*
===========================================================================================================================================
  Date      Owner       Comment
===========================================================================================================================================
1-27-2015      Niket      Written Util class : To show error , Instructional text , and debug statement on Page.    
*/
public with sharing class MessageUtil 
{
  
  public class MessageException extends Exception
    {
      
    }
    
    public MessageUtil()
    {
      Success = true;
      ErrorMessage = new ApexPages.Message(ApexPages.Severity.Info ,'Success!'); 
    }
      
    public Boolean Success {get; set;}
    private ApexPages.Message ErrorMessage = new ApexPages.Message(ApexPages.Severity.Info ,'Success!'); 

    /* Returns: MessageUtil */
    /* Parameters: SaveResult, String */
    /* This method create object of MessageUtil class depending on the parameters passed to it and
       returns the same.*/
    public static MessageUtil LogSaveResult(Database.SaveResult saveResult, String strSuccessMessage)
    {
        Database.Error[] arrErrors = saveResult.getErrors();
        String strErrorMessage = '';
        for(Database.Error errCurrent : arrErrors)
        {
            strErrorMessage += errCurrent.getMessage() + '<br/>';
        }
        MessageUtil err = new MessageUtil();
        err.Success = saveResult.isSuccess(); 
        if(saveResult.isSuccess())
            err.ErrorMessage = new ApexPages.Message(ApexPages.Severity.Info ,strSuccessMessage); 
        else
            err.ErrorMessage = new ApexPages.Message(ApexPages.Severity.Error  ,strErrorMessage); 
        apexPages.addMessage(err.ErrorMessage);
        return err;        
    }
    
    /* Returns: MessageUtil */
    /* Parameters: String */
    /* This method create object of MessageUtil class depending on the parameters passed to it and
       returns the same.*/
    public static MessageUtil DebugLog(String strMsg)
    {
        MessageUtil err = new MessageUtil();
        err.Success = true;
                    
        err.ErrorMessage = new ApexPages.Message(ApexPages.Severity.Info ,strMsg); 
        apexPages.addMessage(err.ErrorMessage);
        
        return err;
    }
    
    /* Returns: MessageUtil */
    /* Parameters: Boolean, Exception */
    /* This method create object of MessageUtil class depending on the parameters passed to it and
       returns the same.*/
    public static MessageUtil LogException(Exception ex)
    {
        MessageUtil err = new MessageUtil();
        err.Success = false;
                    
        err.ErrorMessage = new ApexPages.Message(ApexPages.Severity.Error  , ex.getMessage()); 
        apexPages.addMessage(err.ErrorMessage);
        return err;        
    }
    
    /* Returns: MessageUtil */
    /* Parameters: Boolean, String */
    /* This method create object of MessageUtil class depending on the parameters passed to it and
       returns the same.*/
    public static MessageUtil LogError(String strMsg)
    {
        MessageUtil err = new MessageUtil();
        err.Success = false;
        
        err.ErrorMessage = new ApexPages.Message(ApexPages.Severity.Error  ,strMsg); 
        apexPages.addMessage(err.ErrorMessage);
        
        return err;        
    }
    
    /* Returns: MessageUtil */
    /* Parameters: Boolean, String */
    /* This method create object of MessageUtil class depending on the parameters passed to it and
     returns the same.*/
    public static MessageUtil LogSuccess(String strMsg)
    {
        MessageUtil err = new MessageUtil();
        err.Success = true;
        
        err.ErrorMessage = new ApexPages.Message(ApexPages.Severity.Info ,strMsg); 
        
        apexPages.addMessage(err.ErrorMessage);
        return err;        
    }
}