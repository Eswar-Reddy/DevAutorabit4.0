public class Util {
    public static User currentUser;
    
    // START -BIRLASOFT-Paritosh
    // Code section below added to check if the Context is of Lead Conversion or not
    private static boolean IsLeadConversionContext = false;
    private static boolean isTriggerDueToUpdateQuoteFieldasPerContact = false;
    public static boolean isTestnonGethealthyCode = false;
    Public static boolean isCoverageAreaReverseGeocode = false;
    
    Public static boolean TrgCoverageAreaZipcode = false;
    
    public static boolean isInContextOfLeadConversion() {
    System.debug('lead COnvert**'+IsLeadConversionContext);
        return IsLeadConversionContext ;
    }
    
    public static void setInContextOfLeadConversion() {
        IsLeadConversionContext = true;
    }
    
    // Code section below to prevent recurssion of trigger "UpdateOppOnAcctOwnerChange" on Account
    private static boolean HastriggerRun = false;
    public static boolean HasTriggerRun() {
    //System.debug('TRIGGER UpdateOppOnAcctOwnerChange on Account has run **'+HastriggerRun);
        return HastriggerRun ;
    }
    public static void setTriggerHasRun() {
        HastriggerRun = true;
    }
    // END -BIRLASOFT-Paritosh

    
    // START -BIRLASOFT-Prashant
    // static variable to control the firing of trigger - CopyQuoteValuesUpdate
    public static boolean isContextOfUpdateQuoteFieldasPerContact()
    {return isTriggerDueToUpdateQuoteFieldasPerContact; }
    
    public static void setContextOfUpdateQuoteFieldasPerContact()
    {isTriggerDueToUpdateQuoteFieldasPerContact = true;} 
    // END -BIRLASOFT-Prashant
    
    static {
        currentUser = [SELECT Id, Name,ProfileID,Bypass_Lead_Validation__c,ByPassValidation__c, Web_User__c FROM User WHERE Id =:UserInfo.getUserId() LIMIT 1];
    }
    
    public static Boolean byPassValidation() {
        return currentUser.ByPassValidation__c;
    }

    //Change for Case#00075371
    public static Boolean byPassLeadValidation() {
        return currentUser.Bypass_Lead_Validation__c;
    }
    
    public static Set<String> UsersToSkipTrigger{get;set;}
    
    public static Boolean isSkipTrigger(){
        if(UsersToSkipTrigger == null || UsersToSkipTrigger.size() == 0){
            UsersToSkipTrigger = new Set<String>();
            for(UsersToSkipTrigger__c usrToSkipTrigger : UsersToSkipTrigger__c.getAll().values()){
                UsersToSkipTrigger.Add(usrToSkipTrigger.Name);
            }
        }
        if(UsersToSkipTrigger.Contains(userinfo.getUserid())){
            return true;
        }
        else{
            return false;
        }
    }
    
    public static Boolean isValidId(String s) {
    Id validId;
    try {
       validId = s;
       return true; 
    } catch (Exception ex) {
        return false;
    }
    }
    public static List<RecordType> getRecordTypeForobject(String objectName){
        list<RecordType> listRecordType = [Select id,DeveloperName,name from RecordType where SobjectType=:objectName];
        return listRecordType;     
    }
    public static Map<String,Trigger_By_Pass__c> mapTriggerByPassCustSetting{get;set;}
    public static Map<String,String> mapTriggerPassUsersIDs{get;set;}
    public static Map<String,String> mapTriggerPassProfileIDs{get;set;}

    public static Boolean isSkipTrigger(String handlerName,ID RecordTypeID){
        String settingName = null;
       
        if(mapTriggerByPassCustSetting == null ||  mapTriggerByPassCustSetting.isEmpty()){
            mapTriggerByPassCustSetting = new Map<String,Trigger_By_Pass__c>();
            mapTriggerPassUsersIDs = new Map<String,String>();
            mapTriggerPassProfileIDs = new Map<String,String>();
            list<Trigger_By_Pass__c> listTrigger =Trigger_By_Pass__c.getAll().values();
            /*if(listTrigger.isEmpty() || listTrigger.size()==0)
                return nonGethealthyTestSwitch();*/
            for(Trigger_By_Pass__c custSettingTriggerByPass  : listTrigger){
                 settingName = custSettingTriggerByPass.Name;
                if(custSettingTriggerByPass.Name.contains('__'))
                     settingName = settingName.substring(0,settingName.indexOf('__'));
                //System.debug('-----------------------------------settingName'+settingName);     
                mapTriggerByPassCustSetting.put(settingName,custSettingTriggerByPass);
                if(custSettingTriggerByPass.UserIDs__c != null){
                    if(mapTriggerPassUsersIDs.containsKey(settingName))
                        mapTriggerPassUsersIDs.put(settingName,mapTriggerPassUsersIDs.get(settingName)+custSettingTriggerByPass.UserIDs__c);
                    else    
                        mapTriggerPassUsersIDs.put(settingName,custSettingTriggerByPass.UserIDs__c);
                    }
                if(custSettingTriggerByPass.ProfileIDs__c != null){
                    if(mapTriggerPassProfileIDs.containsKey(settingName))
                        mapTriggerPassProfileIDs.put(settingName,mapTriggerPassProfileIDs.get(settingName)+custSettingTriggerByPass.ProfileIDs__c);
                    else
                        mapTriggerPassProfileIDs.put(settingName,custSettingTriggerByPass.ProfileIDs__c);
                }
            }
        }
        //System.debug('-----------------------------------mapTriggerByPassCustSetting='+mapTriggerByPassCustSetting); 
        //System.debug('-----------------------------------mapTriggerPassUsersIDs='+mapTriggerPassUsersIDs); 
        settingName = handlerName;
        if(settingName.contains('__'))
            settingName = settingName.substring(0,settingName.indexOf('__'));
        //System.debug('-----------------------------------settingName='+settingName);
        //System.debug('-----------------------------------mapTriggerByPassCustSetting.get(settingName).Is_Active__c ='+mapTriggerByPassCustSetting.get(settingName).Is_Active__c );
        if(mapTriggerByPassCustSetting.containsKey(settingName) 
                && (!mapTriggerByPassCustSetting.get(settingName).Is_Active__c 
                        || (mapTriggerByPassCustSetting.get(settingName).RecrodType__c != null 
                            && mapTriggerByPassCustSetting.get(settingName).RecrodType__c.contains(RecordTypeID))
                   )
          ){
                                //System.debug('------------------1');
            return True;
                                }
        else if(mapTriggerPassUsersIDs != null && mapTriggerPassUsersIDs.containsKey(settingName) 
                    && mapTriggerPassUsersIDs.get(settingName) != null 
                && mapTriggerPassUsersIDs.get(settingName).contains(userinfo.getUserid())){
                    //System.debug('------------------2');
            return True;
                    }
        else if(mapTriggerPassProfileIDs != null && mapTriggerPassProfileIDs.containsKey(settingName)
                && mapTriggerPassProfileIDs.get(settingName) != null 
                && mapTriggerPassProfileIDs.get(settingName).contains(userinfo.getprofileID())){
                    //System.debug('------------------3');
            return True;    
                    }
        else return false;    
    }
    public boolean isWeekendDate(Date dateCRP){
        Set<String> weekendDaysSet = new Set<String>{'saturday','sunday'} ;
            String dayCalculated = dateCRP.year() + '-' + dateCRP.month() + '-' + dateCRP.day() + ' ' + '00:00:00';
            dayCalculated = Datetime.valueOf(dayCalculated).formatGmt('EEEE');
            //System.debug('--------------------------dayCalculated'+dayCalculated);
            if(weekendDaysSet.contains(dayCalculated.toLowerCase() ))
               return true;
            else 
                return false;
    }
    
    public static boolean nonGethealthyTestSwitch(){
        if(test.isRunningTest() && ! Util.isTestnonGethealthyCode)
            return true;
        else
            return false;
    }
    public static boolean gethealthyTestSwitch(){
        if(test.isRunningTest() && Util.isTestnonGethealthyCode)
            return true;
        else
            return false;
    }
    private static Map<Schema.SObjectType,Map<String,Id>> rtypesCache;

    static {
        rtypesCache = new Map<Schema.SObjectType,Map<String,Id>>();
    }
    // Returns a map of active, user-available RecordType IDs for a given SObjectType,
    // keyed by each RecordType's unique, unchanging DeveloperName
    public static Map<String, Id> GetRecordTypeIdsByDeveloperName(
        Schema.SObjectType token) {
    // Do we already have a result?
    Map<String, Id> mapRecordTypes = rtypesCache.get(token);
    
    // If not, build a map of RecordTypeIds keyed by DeveloperName
    if (mapRecordTypes == null) {
        mapRecordTypes = new Map<String, Id>();
        rtypesCache.put(token,mapRecordTypes);
    } else {
       // If we do, return our cached result immediately!
       return mapRecordTypes;
    }
 
    // Get the Describe Result
    Schema.DescribeSObjectResult obj = token.getDescribe();
 
    // Obtain ALL Active Record Types for the given SObjectType token
    // (We will filter out the Record Types that are unavailable
    // to the Running User using Schema information)
    String soql =
        'SELECT Id, Name, DeveloperName '
        + 'FROM RecordType '
        + 'WHERE SObjectType = \'' + String.escapeSingleQuotes(obj.getName()) + '\' '
        + 'AND IsActive = TRUE';
    List<SObject> results;
    try {
        results = Database.query(soql);
    } catch (Exception ex) {
        results = new List<SObject>();
    }
 
    // Obtain the RecordTypeInfos for this SObjectType token
    Map<Id,Schema.RecordTypeInfo> recordTypeInfos = obj.getRecordTypeInfosByID();
 
    // Loop through all of the Record Types we found,
    //      and weed out those that are unavailable to the Running User
    for (SObject rt : results) { 
        if (recordTypeInfos.get(rt.Id).isAvailable()) {
            // This RecordType IS available to the running user,
            //      so add it to our map of RecordTypeIds by DeveloperName
            mapRecordTypes.put(String.valueOf(rt.get('DeveloperName')),rt.Id);
        }
    }
 
    return mapRecordTypes;
    }
}