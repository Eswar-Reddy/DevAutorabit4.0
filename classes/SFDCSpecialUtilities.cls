/**
 * @name SFDCSpecialUtilities
 * @description Speclia Utitlity Class catered for custom made methods that are essential but not available in SFDC API
 * @author Michelle Magsarili
 * @company: Cloud Sherpas
 * @date 12.FEB.2014
 *
 * HISTORY
 * - 12.FEB.2014    Michelle Magsarili      Created.
 * -                                        New method named GetRecordTypeIdsByDeveloperName which is used for the Dealer Compliance Change Request
 * -                                        Under OpportunityAfterInsertTrigger and OpportunityAfterUpdateTrigger
 * -
 * -7/22/2015	Crystal, RedPoint	Added new method to get user profile by name
 * - 									Used in ALR, SPD version
 * -
 * -
 * -
 */
public class SFDCSpecialUtilities{
    public static boolean isRunningTest = false; //Used to bypass certain errors

    // Returns a map of active, user-available RecordType IDs for a given SObjectType,
    // keyed by each RecordType's unique, unchanging DeveloperName

    static Map<String, Map<String, Id>> cache {
        get {
            if(cache == null) {
                cache = new Map<String, Map<String, Id>>();

                List<RecordType> recordTypes = [
                    SELECT SobjectType, DeveloperName
                    FROM RecordType
                    WHERE IsActive = TRUE
                ];

                Map<String, List<RecordType>> sobjectTypeToRecordTypes = GroupBy.strings('SobjectType', recordTypes);

                for(String sobjectType : sobjectTypeToRecordTypes.keySet()) {
                    Map<String, Id> developerNameToId = new Map<String, Id>();

                    for(RecordType recordType : sobjectTypeToRecordTypes.get(sobjectType)) {
                        developerNameToId.put(recordType.DeveloperName, recordType.Id);
                    }

                    cache.put(sobjectType, developerNameToId);
                }
            }

            return cache;
        }

        private set;
    }
    
    // Returns a map of Profile Ids based on name
    // keyed by profile name, used to compare specific profiles to UserInfo 
    static Map<String, Id> profilecache {
        get {
            if(profilecache == null) {
                profilecache = new Map<String, Id>();

                List<Profile> profiles = [SELECT Id, Name FROM Profile];

                if(profiles != null && !profiles.isEmpty()) {
                    for(Profile p : profiles) {
                        profilecache.put(p.Name, p.Id);
                    }
                }
            }
            return profilecache;
        }
        private set;
    }

    public static Map<String, Id> GetRecordTypeIdsByDeveloperName(Schema.SObjectType sobjectType) {
        String sobjectDeveloperName = String.valueOf(sobjectType);

        return cache.containsKey(sobjectDeveloperName) ? cache.get(sobjectDeveloperName) : new Map<String, Id>();
    }
    
    public static Id getProfileIdByName(String profileName) {

        return profilecache.containsKey(profileName) ? profilecache.get(profileName) : null;
    }
        
}