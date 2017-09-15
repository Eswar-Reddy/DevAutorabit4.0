public class DesignToolsController 
{

  //  public PageReference resetIntTab() {
       // return null;
  //  }
//public String theSelectedTab{get;set;}
    
/****************************

Created By:    Vamshi Medi 
Email   vamshim@intelligroup.com

This controller is used for the Design Tools visualforce tab
It includes checks for users access to the following Tools:
 - String Sizer
 - Smart Pack
 - Electronic Catalog
 - Smart Finance
*****************************/
    
    
    String strLocale = null;
    User userObj = null;
    //final static String PORTAL_QA_URL='https://10.2.10.52';
    //Changes made by Ram till the Paid version of QA certificate is going to be installed on  NA Staging environment. 
    //For Queries call Ramachandran
    //final static String PORTAL_QA_URL='https://192.168.50.141';
    //Changed by Aria: please don't change these properties without prior confirmation from the development team! thanks
    //MAM 20.NOV.2014 - update string to get value from the Custom Setting start
    //Tertiary operator to ensure that the Base URL has a value even if the Custom Setting was not setup
    final static String PORTAL_QA_URL =  String.IsNotEmpty(Java_Server_Settings__c.getInstance('Java Servers').PORTAL_QA_URL__c)? Java_Server_Settings__c.getInstance('Java Servers').PORTAL_QA_URL__c : 'https://uat.sunpowersupport.com';
    final static String PORTAL_PROD_URL= String.IsNotEmpty(Java_Server_Settings__c.getInstance('Java Servers').PORTAL_PROD_URL__c)? Java_Server_Settings__c.getInstance('Java Servers').PORTAL_PROD_URL__c : 'https://www.sunpowersupport.com';
    //MAM 20.NOV.2014 end
    public Boolean isPartnerUser { get; set; }
    public Boolean isEUPartnerUser { get; set; }
    public Boolean ifAccountHasOnlineAccess { get; set; }
    //Created by Appirio Offshore (Prakash) as on Feb 11, 2010
    //public Boolean isNAPartnerUser{get; set;}
    public Boolean isNAPremAuth { get; set; }
    public Boolean isResidentialInstaller { get; set; }
    //sangita added for TPS
    public Boolean isTPSUser { get; set; }
//Case# 00030375    
    /* Added for Sunpower Case # 00030375 */
    public final Boolean isFrenchPortalUser { get; private set;}
    /**************************************/
    
//Case# 00087202
// public String activeTab{get;set;}
  
//Case# 00037089
    //Orders tab should be hidden for following profiles
    Set<String> setRestrictedProfile = new Set<String>{'EU Partner Operations',
                                                       'EU Partner Sales',
                                                       'EU Partner Technical'};
    public Boolean isRestrictedProfile { get; set; }
    public Account partnerAcc{get;set;}//Ok To Ship
    
    public DesignToolsController()
    {
        isRestrictedProfile = false;
        isNAPremAuth=false  ; 
        strLocale = Userinfo.getLanguage();
        String myName = Userinfo.getUserName();
        
//Case# 00087202
        activeTab = 'Order Details';
        if(ApexPages.currentPage().getParameters().get('pg:POSelectedView:fcf')!=null ||
           ApexPages.currentPage().getParameters().get('pg:POSelectedView:lsi')!=null)
       {
           activeTab = 'PurchaseOrders';
       }
        System.debug('========='+activeTab);
       
       
    //Start// Added by Thirupathi
       Cookie counter = ApexPages.currentPage().getCookies().get('counter');

        // If this is the first time the user is accessing the page,   
        // create a new cookie with name 'counter', an initial value of '1',   
        // path 'null', maxAge '-1', and isSecure 'false'.   
            if (counter ==null) {
                counter = new Cookie('counter','tab1',null,999,false);
                // Set the new cookie for the page  
                ApexPages.currentPage().setCookies(new Cookie[]{counter});
            } else {
        // If this isn't the first time the user is accessing the page  
        // create a new cookie, incrementing the value of the original count by 1  
            
                ActiveTab = String.valueOf(counter.getValue());
            }
        
//End// Added by Thirupathi
//Case# 00030375    
        /* Added Profile.UserLicense.Name and changed WHERE Condition in query for Sunpower Case # 00030375 */
        userObj = [SELECT Country_Domain__c, Id, 
                          LocaleSidKey, ManagerId, 
                          Profile.UserLicense.Name, ProfileId, 
                          UserRoleId, UserType, 
                          Username, User.UserRole.Name, 
                          User.Profile.Name,ContactId
                   FROM User 
                   WHERE Id = :UserInfo.getUserId()];   //FROM User WHERE Username = :myName];

//Case# 00030375        
        /* Added for Sunpower Case # 00030375 */
        if(userObj.Country_Domain__c != null && 
           userObj.Country_Domain__c.contains('-fr') && 
           userObj.Profile.UserLicense.Name == 'Gold Partner') 
        {
            isFrenchPortalUser = true;
        } 
        else 
            isFrenchPortalUser = false;
        
        /**************************************/
        ifAccountHasOnlineAccess = false;
        getIsUserAuthorizedToOrder(); 
        
        if(userObj.UserType == 'PowerPartner')
            isPartnerUser= true;
        else
            isPartnerUser= false;                   
                       
        if(userObj.profile.name.startsWith('EU') && userObj.UserType == 'PowerPartner')
        {
            isEUPartnerUser = true;
            //Added by Appirio Offshore (Prakash) as on Feb 11, 2010
            //isNAPartnerUser=false;
        } 
        else 
        {
            isEUPartnerUser = false;
            //Added by Appirio Offshore (Prakash) as on Feb 11, 2010
            //if(userObj.profile.name.contains('Partner') && userObj.UserType == 'PowerPartner'){
            //isNAPartnerUser=true;
            //} 
        }
        
        if(setRestrictedProfile.contains(userObj.profile.name))
            isRestrictedProfile = true;
        
        if(userObj.profile.name.startsWith('EU Residential Installer') && userObj.UserType == 'PowerPartner')
            isResidentialInstaller= true;
        else 
            isResidentialInstaller= false;
        
        //Ok To Ship
        if(userObj.ContactId!=null){
            Id AccId  = [Select AccountID from Contact where id =: userObj.ContactId].AccountId;
            partnerAcc = [select Country_Domain__c, Partner_Opt_Out_Ok_To_Ship__c, NH_SSE_TYPE__c from Account where Id=:AccId];//sangita added for TPS
            if (partnerAcc.Nh_SSE_TYPE__c != null && partnerAcc.NH_SSE_TYPE__C.contains('TPS') || (userObj.profile.name.contains('TPS')  )) { isTPSUser=true ;} else { isTPSUser=false;}
        }
        
    }//End Construct DesignToolsController
    public string ActiveTab  { get; set; }
    
    public String getUserLocale()
    {
        return Userinfo.getLocale();
    }//End prop getUserLocale
    
    public String getUserRoleName()
    {
        return userObj.UserRole.Name;   
    }//End prop getUserRoleName
    
    public String getProfileName()
    {
        return userObj.Profile.Name;
    }//End prop getProfileName
    
    public String getUserDomain()
    {//System.debug('User domain set for user '+userObj.Country_Domain__c);  
        return userObj.Country_Domain__c;
    }//End prop getUserDomain   
    
    public String designToolsBaseURL
    {
        get 
        {
            if(SalesforceOrgUtils.isPRoductionOrg())
                return PORTAL_PROD_URL;
            else
                 return PORTAL_QA_URL;
        }       
        set;
    }//End prop designToolsBaseURL
    
    public String designToolsBOMBaseURL
    {
        get 
        {	
			Base_URL__c BOMURL = Base_URL__c.getInstance();
            if(SalesforceOrgUtils.isPRoductionOrg()){
                system.debug('---1----'+BOMURL.Invisimount_PORTAL_PROD_URL__c);
                return String.ValueOf(BOMURL.Invisimount_PORTAL_PROD_URL__c);
            }
            else
            {                 
                system.debug('---2----'+BOMURL.Invisimount_PORTAL_QA_URL__c);
                
                return String.ValueOf(BOMURL.Invisimount_PORTAL_QA_URL__c);
                }
        }       
        set;
    }//End prop designToolsBOMBaseURL
    
    public string currentSessionID
    {
        get 
        {
            String profileId = UserInfo.getProfileId();
            String sessionID =  UserInfo.getSessionId();
            return sessionID; 
        }
        set;
    }//End prop currentSessionID

    public string currentOrgID
    {
        get 
        {
            String currentOrgID= UserInfo.getOrganizationId();
            return currentOrgID; 
        }
        set;
    }//End prop currentOrgID
  
    public String getTTL()
    {
        String TTLText = null;
        
        if(strLocale != null)
        {
            if(strLocale.startsWith('de'))
                TTLText = '';
            else if(strLocale.startsWith('en'))
                TTLText = '';
            else if(strLocale.startsWith('es'))
                TTLText = '';
            else if(strLocale.startsWith('it'))
                TTLText = 'CONDIZIONI FINANZIARIE ESCLUSIVE DI PRESTITEMPO PER I SISTEMI FOTOVOLTAICI<br>';
            else if(strLocale.startsWith('fr'))
                TTLText = '';
        }
        else
            TTLText = '';
        
        return TTLText; 
    }//End Func getTTL
    
    public String getBAS()
    {
        String BASText = null;
        
        if(strLocale != null)
        {
            if(strLocale.startsWith('de'))
            {
                BASText = '<table> <tr><td style=\'text-align: justify;\'>';
                BASText += 'Sunpower kennt die Herausforderungen sehr gut, mit welchen man beim Management des Geschäftsverkehrs konfrontiert wird. Für Sie ist es sehr wichtig, Flexibilität und Zahlungsfähigkeit gegenüber ihren Kunden beizubehalten, und Sunpower möchte Sie dabei unterstützen. ';
                BASText += '<br></br><br></br> Sunpower arbeitet mit erstklassigen Finanzinstituten, welche auf Photovoltaik spezialisiert sind. Auf diese Weise können Ihre Kunden Photovoltaik-Anlagen finanzieren und Sie sich auf das Wesentliche konzentrieren: das Wachstum Ihres Unternehmens. ';
                BASText += '<br></br><br></br> Wir haben Finanzinstitute gewählt, welche über eine solide Erfahrung in der Finanzierung von Photovoltaik-Projekten verfügen. In Kürze werden wir Ihnen zusätzliche Programme und Einrichtungen bereit stellen, welche eine optimale und flexible Finanzierung anbieten und in unserer Branche spezialisiert sind. ';
                BASText += '</td></tr> </table> <table> <tr style=\'vertical-align: top;\'>';
                BASText += '<td> <ul>  <li><a href=\'http://www.dkb.de/privat/privat/energie.php\' target=\'blank\'>DKB Deutsche Kreditbank AG</a></li> ';
                BASText += '<li><a href=\'http://www.volksbank-main-tauber.de/bank/3energieumwelt/index.htm\' target=\'blank\'>Volksbank Main-Tauber eG</a></li> ';
                BASText += '</td> </tr> </table>';
            }
            else if(strLocale.startsWith('en'))
            {
                BASText = 'Not available in English.  Only available in Spanish, Italian or German';
            }
            else if(strLocale.startsWith('es'))
            {
                BASText = 'Producto de financiación para clientes particulares de SunPower, para la adquisición de sistemas con modulo e inversor SunPower (incluida línea Serengeti).<br /><br />';
                BASText += '<b>Descargas:</b><br />';
                BASText += '<ul><li><a href=\'https://www.sunpowersupport.com/documents/DEUTSCHE%20BANK.ppt\' target=\'blank\'><b>Presentación de producto SunPower – Deutsche Bank</b></a></li>';
                BASText += '<li><a href=\'https://www.sunpowersupport.com/documents/Solicitud%20SunPower.pdf\' target=\'blank\'><b>Documento de solicitud SunPower – Deutsche Bank</b></a></li></ul>';
            }
            else if(strLocale.startsWith('it'))
            {
//Case# 00075863            
                // Done for Case # 00075863 Changing conditions 
                BASText = 'Grazie alla collaborazione tra Prestitempo e SunPower, i clienti privati avranno accesso a condizioni finanziarie vantaggiose per l’aquisto di un sistema SunPower.<br/><br/>I vantaggi di questo accordo sono:<br/><ul><li>Finanziamento fino al 100% del ';
                BASText += 'valore dell’impianto<li>Finanziamento fino a 12 anni per il solo fotovoltaico<li>Nessuna garanzia ipotecaria<li>No "Cessione del Credito" dei proventi derivanti dal GSE<li>Piano finanziario calibrato sugli incentivi percepiti<li>Nessuna Garanzia obbligatoria ';
                BASText += 'sull’impianto (danni diretti/altro)<li>Prima rata al cliente dopo 180 giorni<li>No apertura C/C obbligatoria<li>Rata fissa per tutta la durata del finanziamento<li>Nessuna Spesa di istruttoria<li>Esiti veloci<li>Possibilità di finanziamento anche per il Condominio<li>';
                BASText += 'Possibilità di polizza All Risks</ul>Le attuali condizioni dell’offerta sono le seguenti:<ul><li>Tasso Standard con credit protection da 12 a 144 mesi 6.80% </li><li>  Tasso Standard senza credit protection da 12 a 144 mesi 6.99% </li>';
                BASText += '<br/><li>Fino a € 5.000 la durata massima è 60 mesi + MAX 6 mesi di procrastinazione. </li><li>Fino a € 10.000 la durata massima è 84 mesi + MAX 6 mesi di procrastinazione. </li><li>Fino a € 55.000 la durata massima è 144 mesi + MAX 6 mesi di procrastinazione.</li></ul>Per ottenere ulteriori informazioni su ';
                BASText += 'Prestitempo e le sue offerte, visitate <a href=\'http://www.prestitempo.it/DealerSUNPOWER.htm\' target=\'blank\'><font color="red">il loro sito</font></a> dove troverete anche un utile strumento per la simulazione della vostra offerta.<br/><br/>Cliccare <a href=\'http://www.prestitempo.it/images/Contratto_Fotovoltaico_9-2008_final.pdf\' target=\'blank\'>qui</a>';
                BASText += ' per scaricare il modulo di richiesta.';
            } 
            else if(strLocale.startsWith('fr')) 
            {
                BASText = 'Le prêt résidentiel de SunPower permet aux partenaires de fournir un service à valeur ajoutée à leurs clients avec un produit d\'emprunt haut de gamme. En partenariat avec FranFinance, une division de Société Générale, SunPower permet à tous ses partenaires de pouvoir proposer aux clients finaux un prêt dédié à l\'installation de projets photovoltaïques.<br /><br />';
                BASText += '<b>Caractéristiques du crédit résidentiel de SunPower souscrit auprès de FranFinance</b><br />';
                BASText += '<ul><li>Montant maximum 55.000 €</li>';
                BASText += '<li>Financement disponible jusqu\'à 100 % de la valeur de l\'installation</li>';
                BASText += '<li>Aucune caution hypothécaire n\'est exigée</li>';                
                BASText += '<li>Plan financier échelonné sur la base des aides financières perçues</li>';
                BASText += '<li>Première échéance à payer après un délai maximum de 180 jours</li>';
                BASText += '<li>Sans obligation d\'ouverture d\'un compte courant</li>';
                BASText += '<li>Un taux fixe pendant toute la durée de la période de financement</li></ul>';
                BASText += 'SunPower a négocié les meilleures conditions d\'emprunt sur le marché français pour ce type de prêt. La souscription à ce programme est gratuite et vous permet de conserver votre ligne de crédit avec SunPower sans frais et de pouvoir, dans le même temps, fournir les matériaux pour l\'installation. Le dispositif s\'inscrit également dans le cadre du <a href=\'http://www.sunpowercorp.fr/newsletter/january11/sunrise.html\' target=\'blank\'><b>programme Sunrise de SunPower</b></a> afin de vous assurer que son utilisation procurera encore plus d\'avantages à votre société.<br /><br />';
                BASText += '<b>Téléchargements</b><br />';
                BASText += '<ul><li><a href=\'https://www.sunpowersupport.com/documents/SIMULATEUR_SUNPOWER.zip\' target=\'blank\'><b>Simulateur SunPower Residential Loan</b></a><br /></li>';
                BASText += '<li><a href=\'https://www.sunpowersupport.com/documents/SIMULATEUR_FRANFINANCE-GUIDE.pdf\' target=\'blank\'><b>Guide de l’utilisateur</b></a><br /></li>';
                BASText += '<li><a href=\'https://www.sunpowersupport.com/documents/OPC_380_multi_palier.pdf\' target=\'blank\'><b>Formulaire pour l’offre préalable de crédit</b></a><br /></li></ul>';
            }
        }
        else
            BASText = '';
        
        return BASText; 
    }//End Func getBAS
    
    public Boolean getSFVisible()
    {
        String userCountryDomain = userObj.Country_Domain__c;
//Case# 00050644
//Case# 00072314        
        //Added Belgium CD to the euDomain set for case 00050644
        //Added UK to euDomainList for Case # 00072314
        Set<String> euDomainsList = new Set<String>{'rvar-it',
                                                    'rvar-es',
                                                    'rvar-de',
                                                    'cvar-it',
                                                    'cvar-es',
                                                    'cvar-de',
                                                    'combo-es',
                                                    'combo-de',
                                                    'combo-it',
                                                    'rvar-fr',
                                                    'cvar-fr',
                                                    'combo-fr',
                                                    'rvar-be',
                                                    'cvar-be',
                                                    'combo-be',
                                                    'rvar-uk',
                                                    'cvar-uk',
                                                    'combo-uk'};
        System.debug('The userCountryDomain is -> '+userCountryDomain);
        
        if(userCountryDomain!=null)
        {
            if(euDomainsList.contains(userCountryDomain))
               return true;
            else
                return false;
        }
        else
           return false;
    }//End Func getSFVisible
    
    public Boolean getECVisible()
    {
//Case# 00075918    
        // Done for Case # 00075918 [Removing role Partner Experience Manager ]
        // Set<String> rolesList = new Set<String> {'Partner Experience Manager', 'Applications Engineering Manager','Applications Engineering', 'Executive Management','IT Help Desk'};
        Set<String> rolesList = new Set<String> {'Applications Engineering Manager',
                                                 'Applications Engineering', 
                                                 'Executive Management',
                                                 'IT Help Desk',
                                                 'Product Engineering Manager'};
        if(rolesList.contains(getUserRoleName()))
            return true;
        else
            return false;  
    }//End Func getECVisible
    
    // Changes made by Sreedhar. Method commented and aA new method to ensure Smartpack visibility to only NA rvar users is written below
    /*
        public Boolean getSPVisible()
        {
            Set<String> profileList = new Set<String> {'SunPower User','SunPower Partner Ambassador','SunPower Super User','System Administrator','Partner Associate User','Partner Premier User'};
            Boolean profileStatus=false;
            if (profileList.contains(getProfileName())){
                profileStatus=true;
            }
            Boolean countryDomainStatus = false;
            String userCountryDomain = userObj.Country_Domain__c;
            if(UserCountryDomain!=null){
                if(userCountryDomain.contains('US')){
                    countryDomainStatus=true;
                }
            }else{
                countryDomainStatus=true;
            }
            String userType = userObj.UserType;
            String partnerType=null;
            if (userType.equals('PowerPartner')){
                partnerType='Power';
            }
            return false;
        }
    */
    
    /**  Flag to determine if the NA smartPack tool is visible
    **/
    public Boolean getSmartPackVisible()
    {
        return getIsNADomain();
    }//End Func getSmartPackVisible
    
    public Boolean getIsNADomain() 
    {
        String userCountryDomain = userObj.Country_Domain__c;
        Set<String> naDomainsList = new Set<String>{'rvar-us','combo-us', 'cvar-us'};
        
        System.debug('The userCountryDomain is -> '+userCountryDomain);
        
        if(userCountryDomain!=null)
        {
            if(naDomainsList.contains(userCountryDomain))
               return true;
            else
               return false;
        }
        else
            return false;
    }//End Func getIsNADomain
    
    /** This flag is used  to check whether the current logged-in user is a 
     *  partner user authorised to place orders 
     */
    public Boolean getIsUserAuthorizedToOrder() 
    {
        String userID = UserInfo.getUserID();
        Boolean isUserAuthorized = false;
        for(User u: [SELECT id, User.Profile.Name, 
                            UserType, Contact.Authorized_to_Order__c, 
                            Contact.Account.Type, Contact.Account.Theater__c, 
                            Contact.Account.Online_Order_Access__c 
                     FROM User 
                     WHERE id =: userID AND 
                           ContactID != null 
                     LIMIT 1])
        {           
            if(u != null && u.Contact != null && u.Contact.Account != null)
            {//check whether the user is partner or non-partner
                if(u.UserType == 'PowerPartner')
                {
                    if(u.Contact.Account.Online_Order_Access__c)
                        ifAccountHasOnlineAccess = true;
                    if(u.Contact.Authorized_to_Order__c && u.Contact.Account.Online_Order_Access__c)                               
                        isUserAuthorized = true;                                                    
                }
                String accType =u.Contact.Account.Type; 
                
                if(!u.profile.name.startsWith('EU') && 
                   accType != null && 
                   PriceListItemUtility.getValidNAAccountType().contains(accType) && 
                   (u.Contact.Account.Theater__c == 'North America' || u.Contact.Account.Theater__c == 'Central America and the Caribbean' ))
                {
                    isNAPremAuth =true;
                } 
            }
        }//End For
        return isUserAuthorized;
    }//End Func getIsUserAuthorizedToOrder      
    
    public String getInitPage()
    {
        String userCountryDomain = userObj.Country_Domain__c;
//Case# 00050644
//Case# 00072314        
        //Added Belgium CD to the euDomain set for case 00050644
        //Added UK to euDomainList for Case # 00072314
        Set<String> euDomainsList = new Set<String>{'rvar-it',
                                                    'rvar-es',
                                                    'rvar-de',
                                                    'cvar-it',
                                                    'cvar-es',
                                                    'cvar-de',
                                                    'combo-es',
                                                    'combo-de',
                                                    'combo-it',
                                                    'rvar-fr',
                                                    'cvar-fr',
                                                    'combo-fr',
                                                    'rvar-be',
                                                    'cvar-be',
                                                    'combo-be',
                                                    'rvar-uk',
                                                    'cvar-uk',
                                                    'combo-uk'};
//Case# 00105774 
        //Start 00105774
        //Set<String> usDomainsList = new Set<String>{'rvar-us','cvar-us','combo-us'};
        Set<String> usDomainsList = new Set<String>{'rvar-us',
                                                    'cvar-us',
                                                    'combo-us', 
                                                    'rvar-au',
                                                    'cvar-au',
                                                    'combo-au'};
        //End 00105774
        
        String euPage = 'projectData.jsf';
        String naPage = 'projectData_NA.jsf';
        
        if(userCountryDomain!=null)
        {
            if(euDomainsList.contains(userCountryDomain))
               return euPage;
            else if(usDomainsList.contains(userCountryDomain))
               return naPage;
            else
               return euPage;
        }
        else
           return euPage;        
    }//End Func getInitPage       
    
    public String getSpTabName()
    {
        String userCountryDomain = userObj.Country_Domain__c;
//Case# 00050644
//Case# 00072314        
        //Added Belgium CD to the euDomain set for case 00050644
        //Added UK to euDomainList for Case # 00072314
        Set<String> euDomainsList = new Set<String>{'rvar-it',
                                                    'rvar-es',
                                                    'rvar-de',
                                                    'cvar-it',
                                                    'cvar-es',
                                                    'cvar-de',
                                                    'combo-es',
                                                    'combo-de',
                                                    'combo-it',
                                                    'rvar-fr',
                                                    'cvar-fr',
                                                    'combo-fr',
                                                    'rvar-be',
                                                    'cvar-be',
                                                    'combo-be',
                                                    'rvar-uk',
                                                    'cvar-uk',
                                                    'combo-uk'};
//Case# 00105774                                                    
        //Start 00105774
        //Set<String> usDomainsList = new Set<String>{'rvar-us','cvar-us','combo-us'};
        Set<String> usDomainsList = new Set<String>{'rvar-us',
                                                    'cvar-us',
                                                    'combo-us', 
                                                    'rvar-au',
                                                    'cvar-au',
                                                    'combo-au'};
        //End 00105774
        String euName = 'EU Smart Pack';
        String naName = 'Smart Pack 2';
        if(userCountryDomain!=null)
        {
            if(euDomainsList.contains(userCountryDomain))
               return euName ;
            else if(usDomainsList.contains(userCountryDomain))
               return naName ;
            else
               return euName ;
        }
        else
           return euName ;
    }//End Func getSpTabName   
    
    public boolean getRedirectUser(){
        
        //Map<String, Account_Types__c> accountTypes = new Map<String, Account_Types__c>();
        User loggedInUser = [select id, Profile.Name, contact.Account.Country_Domain__c, PVSIM_Access_Key__c, Contact.Account.Type, Contact.Account.Name from User where ID =: UserInfo.getUserId() limit 1];
        Map<String, Account_Country_Domains__c> countryDomains = Account_Country_Domains__c.getAll();
        Map<String, Account_Types__c> accountType = Account_Types__c.getAll();
        boolean isUserValid = false;
                        
        if(countryDomains.keySet().size() ==  0){
            system.debug('############## checking countryDomains.keySet().size()...');
            isUserValid = false;
        }
                               
        if(loggedInUser.contact.Account.Country_Domain__c != null && loggedInUser.contact.Account.type != null){
            if((countryDomains.get(loggedInUser.contact.Account.Country_Domain__c) != null && accountType.get(loggedInUser.contact.Account.type) != null) && accountType.get(loggedInUser.contact.Account.type).is_valid__c.equalsIgnoreCase('y') && countryDomains.get(loggedInUser.contact.Account.Country_Domain__c).is_valid__c.equalsIgnoreCase('y')){
                system.debug('############## checking countryDomains exists');
                isUserValid = true;        
            }else{
                system.debug('############## checking countryDomains does not exists');
                isUserValid = false;
            }    
        } 
        return isUserValid; 
    }
    //sangita added for TPS
    
 }