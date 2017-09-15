public class performMetricPageCls {
    List<Performance_Metric__c> PMetricList = new List<Performance_Metric__c>();
    public final static String USA='USA';
    public final static String ITALY='Italy';
    public final static String GERMANY='Germany';
    public final static String FRANCE='France';
    String roleId = UserInfo.getUserRoleId();
    UserRole userrole = [select name from UserRole where id=: this.roleId];
    String profileId = UserInfo.getProfileId(); 
    Profile userprofile = [select name from Profile where id=: this.profileId];
    //String UserId = userInfo.getuserId();
    User u = new User();
    
    Boolean showAdminView;
    public String str1='';
    
    /**Flag to indicate if the user is  System Admin**/
    public Boolean getShowAdminView(){
        if(userprofile.Name.equals('System Administrator')||userprofile.Name.equals('Amministratore del sistema')||userprofile.Name.equals('Systemadministrator')
                                                 ||userprofile.Name.equals('Sunrise Administrator') || userprofile.Name.equals('Sunrise Administrator - Advance')){
            return true;
        }
        else{
            return false;
        }
    }
    
    /** Standard Constructor **/
    public performMetricPageCls(ApexPages.StandardController controller) {
    
     User u = [Select name,Country_Domain__c from User where Id =: UserId];
     String strCountryDomain = u.Country_Domain__c;
     String strDomain =null;
     String str2=null;
     if(strCountryDomain!=null)
     {   
         Integer strIndex = strCountryDomain .indexOf('-'); //new code
         strDomain = strCountryDomain.substring(0,strIndex);
         //strDomain = strCountryDomain.substring(0,4);
         str2 = strCountryDomain .substring(strCountryDomain .indexOf('-')+1,strCountryDomain .length());
     }    
     System.debug('$$Sagar After - ='+ str2);
     if(userrole.Name.equals('Business Development Manager')){
         if((str2!=null && str2 == 'us')){
             PMetricList = [select Name,Channel__c,Peformance_Metric_Name__c,Id from Performance_Metric__c where Performance_Metric__c.Thea__c = 'North America' ];                    
         }
         else if(str2!=null && (str2=='it' || str2 == 'de')){
             PMetricList = [select Name,Channel__c,Peformance_Metric_Name__c,Id from Performance_Metric__c where Performance_Metric__c.Thea__c = 'Europe' ];                    
         }
     }
     else{
         if(userprofile.Name.equals('System Administrator')||userprofile.Name.equals('Amministratore del sistema')||userprofile.Name.equals('Systemadministrator')
                                                ||userprofile.Name.equals('Sunrise Administrator')|| userprofile.Name.equals('Sunrise Administrator - Advance')  ){
           PMetricList = [select Name,Channel__c,Peformance_Metric_Name__c,Id from Performance_Metric__c ];                    
         }
         else{

             //show selected records     
             if((strDomain!=null && (strDomain == 'rvar' || strDomain == 'cvar' || strDomain == 'combo')) && (str2!=null && str2 == 'us'))  {
                 checkCountry(USA);
                 //PMetricList = [select Name,Id from Performance_Metric__c where Channel__c ='Residential' and Country__c ='USA' ];    
             }
             else if((str2!=null && str2 =='it')){
                 checkCountry(ITALY);
                 //PMetricList = [select Name,Id from Performance_Metric__c where Channel__c ='Residential'and Country__c ='Italy' ];    
             }
             else if ((str2!=null && str2 == 'de')){
                 checkCountry(GERMANY);            
                 //PMetricList = [select Name,Id from Performance_Metric__c where Channel__c ='Residential' and Country__c ='Germany' ];    
             }
             // Done for the case # 00059054
             else if ((str2!=null && str2 == 'fr')){
                 checkCountry(FRANCE);            
             }   
           }
        }   
    }
    /** Records filtered by User Id **/
    String UserId = userInfo.getuserId();
    public List<Performance_Metric__c> getPMlist(){
        //PMetricList = [select Name,Id from Performance_Metric__c where Owner.Id=:UserId ];
        //PMetricList = [select Name,Id from Performance_Metric__c ];    
        return PMetricList;
    }
    
    public void checkCountry(String countryNew){
        PMetricList = [select Name,Channel__c,Peformance_Metric_Name__c,Id from Performance_Metric__c where Country__c =: countryNew ];    
        System.debug('$$Sagar complete list='+ PMetricList );
    }
    
    /** Navigating to sysAdminPerformMetric Page **/
    public pageReference SysAdminLink(){
    
        //PageReference pageLink = new PageReference('/apex/sysAdminPerformMetric');
        PageReference pageLink = new PageReference('/a1R/e');
        return pageLink ;
    }   
}