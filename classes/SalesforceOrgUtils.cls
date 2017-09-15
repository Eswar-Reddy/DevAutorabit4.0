/*
    Class :        Salesforce Org Utils
    Created by :   Appirio (Rob s)
    Modified Date: 21 May 2009
    Calling :      
    Purpose:       Utility methods 
                 IsProductionOrg () can be used to determine if the 
                       current SFDC environment is a sandbox or production system.
    Last Modified By :- Jitendra Appirio
    Purpose:- No changes done. deployed only for updating the last modified by on this class
    Revision History:
    18.JUN.2015 MAM Revised the codes to version 33.0 in Apex API; Added Running Test condition;
*/


public class SalesforceOrgUtils {

private static string SECRET_KEY=Label.LMSSecretKey;//'cfTzz2B1yeeIhyj3GVQjjA==';
   
   /* isProductionOrg() 
      Will return true if the current org is a Production org
      Will return false if this is a sandbox org
      '00D80000000ZF1L' is the SunPower production org ID
   */
    public static boolean isProductionOrg  () {
       /*String urlStg = URL.getSalesforceBaseUrl().toExternalForm();
       if(urlStg.contains('na'))
             return true;
        else
             return false;           
        */                
        String currentOrgID = UserInfo.getOrganizationId();
        if (currentOrgID.contains('00D80000000ZF1L')) {
            return true;
        } 
        return false;
        
   }
   
   
   /*  getPlateauSSOLoginURL ()
      Will return the single-sign-on url the the plateau LMS system
      The URL contains an encrypted user id and timestamp 
      This URL will point to the staging instance if this org is a sandbox org
   *//*
    public static String getPlateauSSOLoginURL  () {
        String session =  UserInfo.getSessionId();
        String sfURL;
        
        String test_sfAPI = 'https://c.cs24.visual.force.com/services/Soap/c/14.0';                
        String testLoginPage = 'https://staging2.plateau.com/sunpower/user/login.jsp';
        //String testURLBase= 'https://sunpower2-stage.plateau.com/learning/user/ssoLogin.do?userID=';
        String testURLBase = Label.SunpowerUniversitySandboxURL;
        

        String prod_sfAPI = 'https://c.na29.visual.force.com/services/Soap/c/15.0/00D80000000ZF1L';        
        String prodURLBase = Label.LMSProdURLBase;//'https://www.sunpoweruniversity.com/plateau/user/ssoLogin.do?userID=';
        String prodLoginPage = Label.SunpowerUniversityProductionURL;


       // testURLBase = prodURLBase ;
       // testLoginPage = prodLoginPage ;
              
        if (isPRoductionOrg()) {
            sfURL= prodURLBase;
        }else {
            sfURL= testURLBase;
        }
        
        
      String plateauid = [SELECT Plateau_Id__c from user WHERE id=:UserInfo.getUserId() LIMIT 1].Plateau_Id__c;
       if(Test.isRunningTest()){
          plateauid = 'Test';
      }
    
       Blob IV= Blob.valueOf('Example of IV123');      
        Blob b64decKey = EncodingUtil.base64Decode(SECRET_KEY);
        // Generate the data to be encrypted.
        Blob data = Blob.valueOf(plateauid);
               
      // Encrypt the data and have Salesforce.com generate the initialization vector
        Blob encryptedData = Crypto.encrypt('AES128',b64decKey ,IV, data);
        String b64EncryptedData = EncodingUtil.base64Encode(encryptedData);
        system.debug('b64EncryptedData ='+b64EncryptedData);
        
        system.debug('url being called= '+ testURLBase + encryptedData.toString());
        return sfURL+ EncodingUtil.URLEncode(b64EncryptedData,'UTF-8');
                            
        //return testLoginPage;
   }*/
   
   
}