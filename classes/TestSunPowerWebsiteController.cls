/**************************************************
** PR- 01923
**Created By- Anuradha
**Created On- December 21 , 2010
**Desciption- Test class for controller SunPowerWebsiteController 
*****************************************************/

public class TestSunPowerWebsiteController  {
  @isTest
  public static void testSunPowerWebsiteController (){
         User u = new User(id = userinfo.getUserID());
         u.LocaleSidKey = 'de';
         update u;
         SunPowerWebsiteController sunpower = new SunPowerWebsiteController();
         
         /*u.LocaleSidKey = 'de';
         update u;
         sunpower = new SunPowerWebsiteController();*/
         System.assertEquals('http://www.sunpowercorp.de', sunpower.siteLink);
         
         u.LocaleSidKey = 'it';
         update u;
         sunpower = new SunPowerWebsiteController();
         System.assertEquals('http://www.sunpowercorp.it', sunpower.siteLink);
         
         u.LocaleSidKey = 'es';
         update u;
         sunpower = new SunPowerWebsiteController();
         System.assertEquals('http://www.sunpowercorp.es', sunpower.siteLink);
         
         u.LocaleSidKey = 'fr';
         update u;
         sunpower = new SunPowerWebsiteController();
         System.assertEquals('http://www.sunpowercorp.fr', sunpower.siteLink);
         
         u.LocaleSidKey = 'nl_BE';
         u.LanguageLocaleKey = 'nl_NL';
         update u;
         sunpower = new SunPowerWebsiteController();
         System.assertEquals('http://nl.sunpowercorp.be/', sunpower.siteLink);
         
         u.LocaleSidKey = 'fr_BE';
         u.LanguageLocaleKey = 'fr';
         update u;
         sunpower = new SunPowerWebsiteController();
         System.assertEquals('http://fr.sunpowercorp.be/', sunpower.siteLink);
         
         u.LocaleSidKey = 'en_GB';
         update u;
         sunpower = new SunPowerWebsiteController();
         System.assertEquals('http://www.sunpowercorp.co.uk/', sunpower.siteLink);
   
  }
}