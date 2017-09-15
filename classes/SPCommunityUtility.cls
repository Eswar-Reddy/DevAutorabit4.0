public without sharing class SPCommunityUtility {
    private static final Set<String> portalLicenseNames = new Set<String>{'Gold Partner'};
    private static Map <String, Set <String>> userCustomPermissionsMap = new Map <String, Set <String>>();

    public static Boolean isPartnerUser() {
        Boolean result = false;
        User currentUser = [Select Profile.Name, UserType from User where ID = :userInfo.getUserId()];
        if(portalLicenseNames.contains(currentUser.UserType) || currentUser.Profile.Name.startsWithIgnoreCase('partner')){
            result = true;
        }
        return result;
    }
    
    public static Boolean isNewUIUser(String userId) {
        Boolean result = false;
        Set <String> permissions = getUserCustomPermissions(userId);
        if (permissions.contains('New_UI_User')) {
            result = true;
        }
        return result;    
    }

    private static Set <String> getUserCustomPermissions(String userId) {
        Set <String> permissions = new Set <String>();
        if (String.IsNotBlank(userId)) {
            if (userCustomPermissionsMap != null && userCustomPermissionsMap.containsKey(userId)) {
                // return from cache
                permissions = userCustomPermissionsMap.get(userId);
            } else {
                Map <String, CustomPermission> permissionsMap = getCustomPermissionsMap();
                if (permissionsMap != null && permissionsMap.size() > 0) {
                    List <SetupEntityAccess> seaList = [SELECT SetupEntityId FROM SetupEntityAccess 
                        WHERE SetupEntityId IN :permissionsMap.keySet() AND ParentId IN (SELECT PermissionSetId FROM PermissionSetAssignment
                            WHERE AssigneeId = :userId)];
                    for (SetupEntityAccess sea : seaList) {
                        if (permissionsMap.containsKey(sea.SetupEntityId)) {
                            permissions.add(permissionsMap.get(sea.SetupEntityId).DeveloperName);
                        }
                    }
                    userCustomPermissionsMap.put(userId, permissions);
                }   
            }
        }
        return permissions;
    }
    private static Map <String, CustomPermission> getCustomPermissionsMap() {
        return new Map <String, CustomPermission>([SELECT Id, DeveloperName FROM CustomPermission WHERE NamespacePrefix = NULL]);
    }

}