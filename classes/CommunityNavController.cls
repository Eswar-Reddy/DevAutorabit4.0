global with sharing class CommunityNavController {
    public static String                userAccountId               { get; set; }
    public List<NavObject>              navObjectList               { get; set; }
    public static List<NavObject>       navOverflowObjectList       { get; set; }
    public Boolean                      displayMyAccountLink        { get; set; }
    // Max number of items to display on main top nav bar
    private static Integer MAX_NAV_ITEMS_TO_DISPLAY = 6;
    private static String profileName;

    private static Set<Community_Tab_Configuration__c> navTabs;//contains labels or sobject names of tabs to be displayed

    public CommunityNavController() {
        profileName = [SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId()].Name;
        navTabs = new Set<Community_Tab_Configuration__c>();
        Set<String> userPermissionSetNames = new Set<String>();

        for(PermissionSetAssignment psa : [
            select Id
                 , PermissionSet.Name
              from PermissionSetAssignment
             where AssigneeId = :UserInfo.getUserId()
        ]) {
            userPermissionSetNames.add(psa.PermissionSet.Name);
        }

        for(Community_Tab_Configuration__c tab : [Select Id, Name, URL__c , SObject_Name__c, Enabled_Profiles__c, Enabled_Permission_Sets__c from Community_Tab_Configuration__c order by View_Order__c ASC]){
            Boolean hasPermissionSet = false;
            if(String.isNotBlank(tab.Enabled_Permission_Sets__c)) {
                String permissionSet_noSpaces = tab.Enabled_Permission_Sets__c.remove(' ');
                for(String eps : permissionSet_noSpaces.split(';')) {
                    if(userPermissionSetNames.contains(eps)) {
                        hasPermissionSet = true;
                        break;
                    }
                }
            }
            else {
                hasPermissionSet = true;
            }

            Boolean hasProfile = false;
            if(String.isNotBlank(tab.Enabled_Profiles__c)) {
                String profiles_noSpaces = tab.Enabled_Profiles__c.remove(' ').remove('\r').remove('\n');
                String profileName_noSpaces = profileName.remove(' ');
                for(String eps : profiles_noSpaces.split(';')) {
                    if(eps == profileName_noSpaces) {
                        hasProfile = true;
                        break;
                    }
                }
            }
            else {
                hasProfile = true;
            }

            if(hasProfile && hasPermissionSet)
                navTabs.add(tab);
            else continue;

        }
        navObjectList = getTabs();
        // Display my account link and set user account id
        displayMyAccountLink = displayMyAccount();
    }

    private static Boolean displayMyAccount() {
        if (profileName == 'Partner Delegated Administrator' || profileName == 'Partner Executive') {
            User portalUser = [SELECT ContactId, Contact.Name, Contact.AccountId, Profile_Text__c  from User
                               WHERE id = :Userinfo.getUserId() LIMIT 1];
            userAccountId = portalUser.Contact.AccountId;
            return true;
        } else {
            return false;
        }
    }

    @RemoteAction
    global static List<List<NavObject>> getTabs(List<String> tabApiNames) {
        List<NavObject> tempNavObjectList = new List<NavObject>();
        List<NavObject> tempOverflowObjectList = new List<NavObject>();
        List<List<NavObject>> result = new List<List<NavObject>>();
        Set<String> tabKeySet = new Set<String>();
        Set<String> tabsToDisplay = new Set<String>();
        for (String tabApi : tabApiNames) {
            String label = tabApi.toLowerCase().replace('_', ' ');
            tabsToDisplay.add(label);
        }
        for (DescribeTabSetResult dtsr : Schema.describeTabs()) {
            for (DescribeTabResult dtr : dtsr.getTabs()) {
                String label = dtr.getLabel();
                String url = dtr.getUrl();
                String objectName = dtr.getSObjectName();
                if (!tabKeySet.contains(label + url) && (tabsToDisplay.contains(label.toLowerCase()) || tabsToDisplay.contains(objectName.toLowerCase()))) {
                    if (tempNavObjectList.size() < MAX_NAV_ITEMS_TO_DISPLAY) {
                        tempNavObjectList.add(new NavObject(label, url));
                    } else {
                        tempOverflowObjectList.add(new NavObject(label, url));
                    }
                    tabKeySet.add(label + url);
                }
            }
        }
        result.add(tempNavObjectList);
        result.add(tempOverflowObjectList);

        return result;
    }

    //public static List<NavObject> getTabs() {
    //    List<NavObject> result = new List<NavObject>();
    //    navOverflowObjectList = new List<NavObject>();
    //    Set<String> tabKeySet = new Set<String>();
    //    Map<String, DescribeTabResult> labelToTabMap = new Map<String, DescribeTabResult>();//for deduping - we always prefer the tab with the URL over one without
    //    for (DescribeTabSetResult dtsr : Schema.describeTabs()) {
    //        for (DescribeTabResult dtr : dtsr.getTabs()) {
    //            String label = dtr.getLabel().toLowerCase();
    //            String objectName = dtr.getSObjectName().toLowerCase();
    //            if(navTabs.contains(label) || navTabs.contains(objectName)){
    //                if(labelToTabMap.containsKey(label)){
    //                    if(labelToTabMap.get(label).getUrl().contains('servlet')){//we want custom tabs
    //                        //we want to keep the custom tabs over the others
    //                        continue;
    //                    }
    //                    else{
    //                        labelToTabMap.put(label, dtr);
    //                    }
    //                }
    //                else{
    //                    labelToTabMap.put(label, dtr);
    //                }
    //            }
    //        }
    //    }
    //    for(DescribeTabResult dtr : labelToTabMap.values()){
    //        String label = dtr.getLabel();
    //        String url = dtr.getUrl();
    //        String objectName = dtr.getSObjectName();
    //        if (!tabKeySet.contains(label + url)) {
    //            NavObject no = new NavObject(label, url);
    //            if (result.size() < MAX_NAV_ITEMS_TO_DISPLAY) {
    //                result.add(no);
    //            } else {
    //                navOverflowObjectList.add(no);
    //            }
    //            tabKeySet.add(label + url);
    //        }
    //    }

    //    return result;
    //}

    public static List<NavObject> getTabs(){
        List<NavObject> result = new List<NavObject>();
        navOverflowObjectList = new List<NavObject>();
        for(Community_Tab_Configuration__c tab : navTabs){
            NavObject no = new NavObject(tab.Name, tab.URL__c);
            if (result.size() < MAX_NAV_ITEMS_TO_DISPLAY) {
                result.add(no);
            } else {
                navOverflowObjectList.add(no);
            }
        }
        return result;
    }

    global class NavObject {
        global String  tabLabel   {get; set;}
        global String  tabUrl     {get; set;}

        global NavObject(String label, String url) {
            this.tabLabel = label;
            this.tabUrl = url;
        }
    }
}