/*** Created by: Accenture
* Date : 1/24/2010 
* Purpose: This Controller contains variable names for all the Automated metric.
* Modified Date: 11/25/2010
* Modified By: Hemant Garg(Appirio offshore)
* Purpose: Added new constants and modified existing for Sunrise 2B
**/ 

public class PerformanceEvalCst{
    
    //Partner Tier
    public static final String PA_TIER_AUTHORIZED = 'Authorized';//for case # 00053810
    //Customer Satisfaction
    public static final String  CSAT_SCORE ='Homeowner customer satisfaction score';
    public static final String  CSAT_SCORE_EU ='CSAT survey score';
    public static final String CSAT_SURVEY_REQ ='CSAT Survey Requirement';
    //it is for NA
    public static final String  SITE_INSPECTION ='Residential Installation Inspections';
    //it is for EU
    public static final String  SITE_INSPECTION_EU ='Installation Inspections'; //Site inspection';
    public static final String  CUSTOMER_COMPLAINTS ='Customer Complaints';
    public static final String  PERCENT_INSTALL_CRM ='SunPower installations Registered';
    public static final String  SITE_INSPECTION_NON_COMP ='Site Inspection - Non Compliance';
    
    //start: Added by PRakash for CVAR 
    public static final String  CSAT_SCORE_CVAR ='Customer Satisfaction Score';
    public static final String  T5_T10_Power_CVAR ='T5, T10 and PowerGuard installation inspections Passed (90% Score)';
    public static final String  WARRANTY_CARDS_CVAR='Warranty Card Received';
    public static final String  INSTALLATIONS_REGISTERED_CVAR = 'SunPower Installations Registered at CRM';
    public static final String  TRAINING_ASS_INSTALL_CVAR ='Training:  Attended Fundamentals of Commercial Installation';
    public static final String  TRAINING_ASS_SALES_CVAR ='Training:  Attended Fundamentals of Commercial Sales';
    public static final String  TRAINING_ASS_DESIGN_CVAR ='Training:  Attended Fundamentals of Commercial Design';
    public static final String  TRAINING_ASS_SALES_CERT_CVAR ='Bonus for Extra Training - No. certified with Associate Commercial Sales';
    public static final String  TRAINING_ASS_DESIGN_CERT_CVAR ='Bonus for Extra Training - No. certified with Associate Commercial Design';
    public static final String  TRAINING_ASS_INSTALL_CERT_CVAR ='Bonus for Extra Training - No. certified with Associate Commercial Install';
    public static final String  PBP_SUNPOWER_SHARE_OF_ACCOUNTS_CVAR = 'SunPower Share of Account (PV purchases in kW)';
    public static final String  PBP_CREDIT_LINE_MAINTAINED_CVAR = 'Credit Limit Maintained';
    public static final String  PBP_BONUS_PURCHASE_TARGET = 'Bonus for Meeting 6 Month Purchase Target(kW)';
    public static final String  PBP_ACTIVE_DEALER_CVAR = 'Must be an Active Dealer (50 kW or 2 Systems Installed)';
    public static final String  PBP_ACTIVE_DEALER_CVAR_50KW = '50 kW Systems Installed';
    public static final String  PBP_ACTIVE_DEALER_CVAR_2SYSTEM = '2 Systems Installed';
    //public static final String  PBP_SUNPOWER_DEALER_GROWTH_PLAN_CVAR = 'Must be an Active Dealer (50 kW or 2 Systems Installed)';
    public static final String  PBP_SUNPOWER_DEALER_GROWTH_PLAN_CVAR = 'SunPower and Dealer Growth Plan signed and submitted on time';
    //End: Added by PRakash for Commercial 
    
    // code added for Sunrise phase2a on 28Apr10 
    //Warranty cards is new metric for RVAR-NA(Sunrise2b)
    public static final String  WARRANTY_CARDS_NA ='Warranty Cards';
    //public static final String  WARRANTY_CARDS_NA ='Warranty card received NA';
    public static final String  WARRANTY_CARDS_EU ='Warranty card received EU';
    
    //Training
    /*Metric Names Changed by hemant: according to Sunrise 2B*/
    public static final String  TRAINING_ASS_DESIGN = 'Training Attendance:  Associate Design';//'Training:  Associate Design Certification';
    public static final String  TRAINING_ASS_INSTALL = 'Training Attendance:  Associate Install';//'Training:  Associate Installation Certification';
    public static final String  TRAINING_ASS_SALES = 'Training Attendance:  Associate Sales';//'Training:  Associate Sales Certification';
    public static final String  TRAINING_ADV_DESIGN = 'Training Attendance:  Advanced Design';//'Training: Advanced Design Certification';
    public static final String  TRAINING_ADV_INSTALL = 'Training Attendance:  Advanced Install';//'Training: Advanced Installation Certification';
    public static final String  TRAINING_ADV_SALES = 'Training Attendance:  Advanced Sales';//'Training: Advanced Sales Certification';
    public static final String  TRAINING_EXTRA_BONUS = 'Bonus for Extra Training';
    //for NA(added by hemant)
    public static final String  BONUS_FOR_ONLINE_ORDERING = 'Bonus for Online Ordering';
    public static final String  BONUS_FOR_MEETING_ALL_TIER_REQUIREMENTS = 'Bonus for Meeting ALL tier requirements';
    
    // code added for SunrisePhase2a on 19Apr10 
    public static final String  TRAINING_EXTRA_BONUS_I = 'Bonus for Extra Training - No. certified for Adv. Design';
    public static final String  TRAINING_EXTRA_BONUS_II = 'Bonus for Extra Training - percent of Sales People with Adv Training';
    public static final String  TRAINING_EXTRA_BONUS_III = 'Bonus for Extra Training - No. certified for Adv. Install';
    
    public static final String  ADVANCE_PROD_TRAINING = 'Advanced Product Training';
    public static final String  ADVANCE_TRAINING_EU = 'Advanced design and Installation';
    public static final String  ADVANCE_TRAINING_EU_CLONE = 'Advanced product training';
    public static final String  BASIC_TRAINING_EU = 'Fundamental Design and Installation';
    public static final String  BASIC_TRAINING_EU_CLONE = 'Basic training';
        
    //Performance to BP
    //Identified for NA
    public static final String  ACTIVE_DEALER ='Must be an Active Dealer';
    public static final String  CREDIT_LIMIT ='Good Credit';
    public static final String  CREDIT_LIMIT_EU = 'Minimum Premier credit or bank guarantee'; // ;Credit Limit maintained greater 90 days
    public static final String CREDIT_LIMIT_SRI = 'Credit Limit SRI';
    public static final String  SIX_MONTHS_AS_AUTH_WITH_TWENTY_INSTALL ='6 mo as Authorized with 20 installs';
    public static final String  MIN_EXP_EU='Minimum experience';
    
    public static final String  SIX_MONTHS_AS_AUTH ='6 months as Authorized';
    public static final String  TWENTY_INSTALLS_AS_AUTH ='20 Installs';
    public static final String  SIX_MONTHS_AS_PREM ='6 months as Premier';
    public static final String  HUNDRED_INSTALLS_AS_PREM ='100 Installs';
    public static final String  MIN_EXP_SIX_MONTHS_EU='Minimum experience (6 months as Authorized)';
    public static final String  MIN_EXP_TWENTY_INSTALLS_EU='Minimum experience (20 Installs Or 200 Kws)';
    
    public static final String  RETROFIT_SOLAR_SYS ='SunPower Residential Retrofit Experience';
    
    public static final String  BGSM_SCORECARD_EU ='BGSM Scorecard';
    public static final String  BGSM_SCORECARD_EU_CLONE ='BGSM Scorecard (Direct Authorized Partner)';
    
    public static final String  MIN_QUAT_SALES_EU ='Minimum quarterly sales as SRI';
    public static final String  MIN_QUAT_SALES_EU_CLONE ='Minimum quarterly sales';
    
    // Done for case # 00060774
    //public static final String  MIN_SALES_AUTHZ_EU='Minimum sales and experience (SRI to Authorized)';
    public static final String  MIN_SALES_AUTHZ_EU='Minimum sales and experience';
    
    public static final String  SIX_MONTHS_TARGET='Bonus for Meeting 6 Month Revenue Target';
    public static final String  KW_TARGET_EU='Kw agreed target';
    
    //All SPWR Sol
    public static final String  SEVENTY_SALES_KITS ='Bonus for SmartPack Usage'; // for
    public static final String  OPP_CLOSE_RATE ='Opportunity Close rate for SunPower Opportunities';

    public static final String  SEVENTY_RES_KITS_EU ='greater than 70 of  Residential sales are systems';
    public static final String  SEVENTY_COM_INVTR_EU ='greater than 70 of  Commercial sales include Inverter';
    
    //Marketing
    public static final String EXCEP_FOREST = 'Exceptional Forecast Accuracy';
    
    //Composite Metric
    public static final String  BASIC_TRAINING ='Basic Product training';
    public static final String  MEET_SIX_SWPR ='If 6 or more of the above are met';
    public static final String  MEET_SIX_MARKET ='All 6 of the above';
    
    public static final String  ALL_SWPR_EU ='Meet all SPWR Solutions';
    public static final String  THREE_MARKET_EU ='3 Marketing requirements met';
    public static final String  FOUR_MARKET_EU ='4 Marketing requirements met';
    public static final String  SIX_MARKET_EU ='6 Marketing requirements met';
    public static final String  SEVEN_MARKET_EU ='7 Marketing requirements met';
    
    public static final String  RSM_OBJECTIVES ='Dealer Bonuses for meeting Business Objectives';
    public static final String  RSM_OBJECTIVES_EU ='3 Agreed Upon RSM Objectives';
    //SPWR SPWR M1 CHILDS
    public static final String SPWR_M1='SunPower Solar Loan OR Same-As-cash loan applications';
    public static final String SPWR_M2='Opportunity Close rate for SunPower Opportunities';
    public static final String SPWR_M3='Demo Product Purchase';
    public static final String SPWR_M4='Alliance Partner Lead';
    public static final String SPWR_M5='Attend instructor led class';
    public static final String SPWR_M6='SunPower Foundation alliance';
    public static final String SPWR_M7='New Product Introduction';
    public static final String SPWR_M8='SmartMount Installation';
    public static final String SPWR_M9='Consulting Seminar/ Peer Group Meeting';
    
    
    //MARKET M1 USA CHILDS
    public static final String MARKET_USA_M1='Adhere to Brand Guidelines';
    public static final String MARKET_USA_M2='Local events';
    //Changed by hemant
    public static final String MARKET_USA_M3 = 'SunPower Dealer Webpage and Logo Usage - 1 of 4';//'SunPower Dealer Webpage and Logo Usage';
    public static final String MARKET_USA_M4 = 'Co-branded sales and installation apparel';
    public static final String MARKET_USA_M5 = 'Display panels/cells in showroom';
    public static final String MARKET_USA_M6 = 'Advertising';
    //CHILD FOR EU
    
    public static final String MARKET_EU_AUTH_THREE_M1='Compliance to logo/brand style guide';
    public static final String MARKET_EU_AUTH_THREE_M2='Local events';
    public static final String MARKET_EU_AUTH_THREE_M3='Partner business cards/letterheads';
    
    public static final String MARKET_EU_AUTH_FOUR_M1='SPWR Template on web site';
    public static final String MARKET_EU_AUTH_FOUR_M2='Local events';
    public static final String MARKET_EU_AUTH_FOUR_M3='Partner business cards/letterheads';
    public static final String MARKET_EU_AUTH_FOUR_M4='Partner website - logo & link';
    
    public static final String MARKET_EU_PREM_SIX_M1='Compliance to logo/brand style guide';
    public static final String MARKET_EU_PREM_SIX_M2='Local events';
    public static final String MARKET_EU_PREM_SIX_M3='Partner business cards/letterheads';
    public static final String MARKET_EU_PREM_SIX_M4='Partner website - logo & link';
    public static final String MARKET_EU_PREM_SIX_M5='SPWR Template on web site';
    public static final String MARKET_EU_PREM_SIX_M6='Co-branded Apparel';
    
    public static final String MARKET_EU_PREM_SEV_M1='Flags/Stickers';
    public static final String MARKET_EU_PREM_SEV_M2='Local events';
    public static final String MARKET_EU_PREM_SEV_M3='Partner business cards/letterheads';
    public static final String MARKET_EU_PREM_SEV_M4='Partner website - logo & link';
    public static final String MARKET_EU_PREM_SEV_M5='SPWR Template on web site';
    public static final String MARKET_EU_PREM_SEV_M6='Co-branded Apparel';
    public static final String MARKET_EU_PREM_SEV_M7='Display panels/cells in showroom';
    
    //Child for RSM Objectives
    public static final String RSM_OBJ_1 = 'RSM Objective1';
    public static final String RSM_OBJ_2 ='RSM Objective2';
    public static final String RSM_OBJ_3 ='RSM Objective3';
    
    public static final String MARKETADV='Advertising';
    public static final String MARKETPR='PR template';
    public static final String MARKETLogo='Logos on cars (magnets)';
    public static final String MARKET_BANNER='Co-branded scaffolding banners';
    public static final String MARKET_WRAP='Co-branded Vehicle Wraps';
    public static final String MARKET_JOB='Co-branded Signs at job-site';
    public static final String MARKET_SALEKIT='Bonus for In-Home Sales Kit and Proposal Tool';
    public static final String MARKET_CERT='Display of SunPower Training Certificates';
    
    //New Marketing metric added by hemant
    /*hemant:start*/
    public static final String MARKET_CO_BRANDING_RVAR = 'Co Branding';
    public static final String SPWR_DEALER_LOGO_ON_HOMEPAGE = 'Use of SunPower Dealer Logo on Home Page';
    public static final String SPWR_DEALER_LOGO_ON_PRODUCTS_PAGE = 'Use of SunPower Dealer Logo on Products Page';
    public static final String SPWR_DEALER_LOGO_ON_ABOUTUS_PAGE = 'Use of SunPower Dealer Logo on About Us Page';
    public static final String MAINTAINS_WEBPAGE_CONSUMER_ADVANTAGE = 'Maintains a webpage which notes the consumer advantages of working with a SunPower Dealer';
    
    public static final String MARKET_SHOWROOM_DISPLAY_RVAR = 'SunPower Showroom Display';
    public static final String MARKET_CO_BRANDED_ALL_VEHICLES_RVAR = 'Co-branded All Vehicles';
    public static final String MARKET_CO_BRANDED_BUSINESS_CARDS_RVAR = 'Co-branded Business Cards';
    public static final String MARKET_CO_BRANDED_SALES_INSTALLATION_APPAREL_RVAR = 'Co-branded sales and installation apparel';
    public static final String MARKET_LOCAL_EVENTS_RVAR = 'Local events';
    
    /*hemant:end*/
        
    // List of Profiles
    public static final Set<String> profileShowLink = new set<String>{'EU Partner Delegated Administrator','EU Partner Executive','Partner Delegated Administrator','Partner Executive','EU Residential Installer','EU Partner Operations','EU Partner Restricted','EU Partner Sales','EU Partner Technical','Partner Technical','Partner Operations','Partner Restricted','Partner Sales'};
    public static final Set<String> profilePartnerExecutive = new set<String>{'EU Partner Delegated Administrator','EU Partner Executive','Partner Delegated Administrator','Partner Executive','EU Residential Installer'};
    /* Done for the case # 00055915 on 9Feb 2011 */
    public static final Set<String> profileHideHeaderForPartner = new set<String>{'EU UAT Online Warranty','EU Partner Delegated Administrator','EU Partner Executive','Partner Delegated Administrator','Partner Executive','EU Residential Installer','EU Partner Operations','EU Partner Restricted','EU Partner Sales','EU Partner Technical','Partner Technical','Partner Operations','Partner Restricted','Partner Sales'};
    public static final Set<String> profileDisableEditButton = new set<String>{'EU Partner Operations','EU Partner Restricted','EU Partner Sales','EU Partner Technical','Partner Technical','Partner Operations','Partner Restricted','Partner Sales'};
    /*added by hemant for CVAR-Access*/
    /* Done for case # 00050543 on 19Feb2011 */
    // public static final Set<String> roleEditButton = new set<String>{'Regional Sales Manager','SSO','AA','Channel Manager'};
    public static final Set<String> roleEditButton = new set<String>{'Residential Regional Sales Manager NA','Commercial Regional Sales Manager NA','Regional Sales Manager Australia','Regional Sales Manager Europe','SSO','AA','Channel Manager'};
    
    // List of Country
    public static final Map<String,String> countryMap = new Map<String,String>{'us' => 'USA','de' =>'Germany','it' => 'Italy','fr' => 'France'  };
    public static final Map<String,String> comingSoonMap = new Map<String,String>{'us' => 'Coming Soon','de' =>'Bald kommen','it' => 'Venuta presto' };
    // List of Tiers used
    /* Done for the case # 00051450 */
    // List of US Theaters
    public static final Map<String,String> usTheatersMap = new Map<String,String>{'North America' => 'North America','Central America and the Caribbean' => 'North America'};
    
    public static final Map<String,String> tierMap = new Map<String,String>{'Authorized' => 'Premier','Premier' => 'Elite', 'SRI' =>'Authorized'};
    //Partner types
    public static final Set<String> PARTNER_TYPE_COMBO = new set<String>{'Authorized-Partner-Combo','Premier-Partner-Combo','Elite-Partner-Combo'};
    public static final Set<String> PARTNER_TYPE_COMM = new set<String>{'Partner-Commercial','Commercial'};
    public static final Set<String> PARTNER_TYPE_RESI = new set<String>{'Authorized-Partner-Residential','Elite-Partner-Residential','Home Owner','Premier-Partner-Residential','Residential Installer',''};
    
    public static final String UP_TO_DATE_PAYMENT_EU_RVAR = 'Up to date with payments';
    public static final String RESIDENTIAL_LOAN_PA_EU_RVAR = 'Residential Loan Program Applications';
    public static final String SPWR_RESIDENTIAL_LOAN_PS_EU_RVAR = 'Sunpower Residential Loan Program Signed';
    public static final String SHARE_OF_ACCOUNT_BONUS = 'Share of Account Bonus';
    
    //EU Training Metrics
    // Done for case # 00060258
    // public static final String FUNDAMENTAL_TRAINING_DESIGN_SPFR_EU = 'Fundamentals of Residential Design';
    public static final String FUNDAMENTAL_TRAINING_DESIGN_SPFR_EU = 'Fundamental Design';
    public static final String FUNDAMENTAL_TRAINING_SAL_CORE_EU = 'New with SunPower "Part of the Commercial and Product Training"';
    public static final String FUNDAMENTAL_TRAINING_SMARTER_SELLING_EU = 'Smarter selling';
    // Done for case # 00060258
    public static final String FUNDAMENTAL_TRAINING_INSTALLATION_EU = 'Fundamentals of Installation';    
    
    public static final Set<String> countryDomains = new Set<String>{'rvar-it','rvar-fr','rvar-us','rvar-de','cvar-it','cvar-fr','cvar-us','cvar-de','combo-it','combo-fr','combo-us','combo-de'};
    public static String findPreviousType(String accId, DateTime startDT, DateTime endDT){
        String prevType ;
        
        List<AccountHistory> accHistoryBetweeen_SD_and_ED = [Select AccountId, CreatedDate, Field, OldValue, NewValue From AccountHistory where AccountId=:accId and Field='Type' and (createdDate <=:endDT and createdDate >=:startDT) order by createdDate desc limit 1];
        if(accHistoryBetweeen_SD_and_ED!=null && accHistoryBetweeen_SD_and_ED.size()>0)
            prevType = (String)accHistoryBetweeen_SD_and_ED[0].NewValue;
        else{
            List<AccountHistory> accHistoryBetweeen_ED_and_Today = [Select AccountId, CreatedDate, Field, OldValue, NewValue From AccountHistory where AccountId=:accId and Field='Type' and (createdDate <=:date.today() and createdDate >=:endDT) order by createdDate asc limit 1];
            if(accHistoryBetweeen_ED_and_Today!=null && accHistoryBetweeen_ED_and_Today.size()>0){
                prevType = (String)accHistoryBetweeen_ED_and_Today[0].OldValue; 
            }else{
                return null;
            }
        } 
        
        System.debug('============prevType=============' + prevType);
        /*for(AccountHistory accHist : [Select AccountId, CreatedDate, Field, OldValue, NewValue From AccountHistory where AccountId=:accId and Field='Type' and (createdDate <=:endDT and createdDate >=:startDT) order by createdDate desc limit 1]){
           System.debug('========accHist==========='+accHist);
           prevType = (String)accHist.NewValue;
        }*/
        return prevType;
    }
    
    /* Done for the case # 00049203 on 3Feb2011 */
    // Set of the users who can update the partner metrics even after Performance Metrics Cut off date
    public static final Set<String> exemptedUsersSet = new set<String>{'John Pearson','Beverly Villanueva','Bill Green','Ria Madejas','Oscar Cepas','Ria Campos','Alma Malabayabas'};
}