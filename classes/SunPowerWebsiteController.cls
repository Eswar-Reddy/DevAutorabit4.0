public class SunPowerWebsiteController {
	
	public String siteLink{get;set;}
	
	public SunPowerWebsiteController(){
		if(UserInfo.getLocale().equals('de') || UserInfo.getLocale().equals('DE'))
			siteLink = 'http://www.sunpowercorp.de';
		else if(UserInfo.getLocale().equals('it') || UserInfo.getLocale().equals('IT'))
			siteLink ='http://www.sunpowercorp.it';
		else if(UserInfo.getLocale().equals('es')|| UserInfo.getLocale().equals('ES'))
			siteLink ='http://www.sunpowercorp.es';
		else if(UserInfo.getLocale().equals('fr')|| UserInfo.getLocale().equals('FR'))
			siteLink ='http://www.sunpowercorp.fr';
		//Start for Case# 00088934
		else if (UserInfo.getLocale().equalsIgnoreCase('nl_BE')|| UserInfo.getLocale().equalsIgnoreCase('fr_BE')){			
			if(Userinfo.getLanguage().equals('nl_NL')){
				siteLink ='http://nl.sunpowercorp.be/';
			}else if(Userinfo.getLanguage().equals('fr')){
				siteLink ='http://fr.sunpowercorp.be/';
			}
		}
		else if(UserInfo.getLocale().equalsIgnoreCase('en_GB'))
			siteLink ='http://www.sunpowercorp.co.uk/';
		//End for Case# 00088934
	}

}