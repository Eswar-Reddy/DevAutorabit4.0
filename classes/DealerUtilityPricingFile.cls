public class DealerUtilityPricingFile {

    public static String getPricingFile(Account acc, String utilityCode, String state, String utilityDescription) {
        String pricingFile;      

        List <Dealer_Utility_Pricing_File__c> dupfList = [SELECT Id, 
                Dealer__c, 
                State__c, 
                Utility__c,
                Utility_Code__c, 
                Pricing_File_Name__c 
            FROM Dealer_Utility_Pricing_File__c
            WHERE 
                Pricing_File_Name__c != null
            ORDER BY CreatedDate ASC];
        
        // load utility codes
        Set <String> utilityCodeIdSet = new Set <String>();
        Map <String, Utility_Code__c> nameUtilityCodeMap = new Map <String, Utility_Code__c>();
        for (Dealer_Utility_Pricing_File__c dupf : dupfList) {
            if (dupf.Utility_Code__c != null) {
                utilityCodeIdSet.add(dupf.Utility_Code__c);
            }
        }
        if (utilityCodeIdSet.size() > 0) {
            for (Utility_Code__c uc : [SELECT Id, Name FROM Utility_Code__c WHERE Id IN :utilityCodeIdSet]) {
                nameUtilityCodeMap.put(uc.Name.toUpperCase(), uc);
            }
        }
                    
        final String GRP_DEALER_UTILITY_CODE = 'GRP_DEALER_UTILITY_CODE';    
        final String GRP_DEALER_UTILITY_DESC_STATE = 'GRP_DEALER_UTILITY_DESC_STATE';    
        final String GRP_UTILITY_CODE = 'GRP_UTILITY_CODE';
        final String GRP_UTILITY_DESC_STATE = 'GRP_UTILITY_DESC_STATE';    
        final String GRP_DEALER_STATE = 'GRP_DEALER_STATE';    
        final String GRP_STATE = 'GRP_STATE';    
                
        List <String> groupingList = new List <String>();
        groupingList.add(GRP_DEALER_UTILITY_CODE);
        groupingList.add(GRP_DEALER_UTILITY_DESC_STATE);
        groupingList.add(GRP_UTILITY_CODE);
        groupingList.add(GRP_UTILITY_DESC_STATE);
        groupingList.add(GRP_DEALER_STATE);
        groupingList.add(GRP_STATE);

        Map <String, Map <String, Dealer_Utility_Pricing_File__c>> groupingMap = new Map <String, Map <String, Dealer_Utility_Pricing_File__c>>();
        for (String grouping : groupingList) {
            groupingMap.put(grouping, new Map <String, Dealer_Utility_Pricing_File__c>());
        }
        
        for (Dealer_Utility_Pricing_File__c dupf : dupfList) {
            if (dupf.Dealer__c != null && dupf.Utility_Code__c != null) {
                groupingMap.get(GRP_DEALER_UTILITY_CODE).put(getKey(dupf.Dealer__c, dupf.Utility_Code__c), dupf);
            }
            if (dupf.Dealer__c != null && dupf.Utility__c != null && dupf.State__c != null) {
                groupingMap.get(GRP_DEALER_UTILITY_DESC_STATE).put(getKey(dupf.Dealer__c, dupf.Utility__c, dupf.State__c), dupf);
            }
            if (dupf.Dealer__c == null && dupf.Utility_Code__c != null) {
                groupingMap.get(GRP_UTILITY_CODE).put(getKey(dupf.Utility_Code__c), dupf);
            }
            if (dupf.Dealer__c == null && dupf.Utility__c != null && dupf.State__c != null) {
                groupingMap.get(GRP_UTILITY_DESC_STATE).put(getKey(dupf.Utility__c, dupf.State__c), dupf);
            }
            if (dupf.Dealer__c != null && dupf.Utility_Code__c == null && dupf.Utility__c == null && dupf.State__c != null) {
                groupingMap.get(GRP_DEALER_STATE).put(getKey(dupf.Dealer__c, dupf.State__c), dupf);
            }
            if (dupf.Dealer__c == null && dupf.Utility_Code__c == null && dupf.Utility__c == null && dupf.State__c != null) {
                groupingMap.get(GRP_STATE).put(getKey(dupf.State__c), dupf);
            }
        }

        List <String> codeList = new List <String>();
        if (nameUtilityCodeMap.size() > 0) {
            codeList = new List <String>(nameUtilityCodeMap.keySet());
            // sort the list. we will match the logner code in the for loop
            // example: OH_COLUMBUS, OH_COLUMBUS_SOUTHERN
            // last one will match. i am not breaking for loop after first match
            codeList.sort();
        }
        // GRP_DEALER_UTILITY_CODE
        if (acc != null && acc.Partner_Account__c != null && String.IsNotBlank(utilityCode)) {
            Map <String, Dealer_Utility_Pricing_File__c> fileMap = groupingMap.get(GRP_DEALER_UTILITY_CODE);
            for (String code : codeList) {
                if (utilityCode.startsWithIgnoreCase(code)) {
                    Utility_Code__c uc = nameUtilityCodeMap.get(code);
                    String key = getKey(acc.Partner_Account__c, uc.Id);
                    if (fileMap.containsKey(key)) {
                        pricingFile = fileMap.get(key).Pricing_File_Name__c;
                    }    
                }
            }
        }
        if (String.IsNotBlank(pricingFile)) {
            return pricingFile;
        }
        // GRP_DEALER_UTILITY_DESC_STATE
        if (acc != null && acc.Partner_Account__c != null && String.IsNotBlank(utilityDescription) && acc.Billingstate != null) {
            Map <String, Dealer_Utility_Pricing_File__c> fileMap = groupingMap.get(GRP_DEALER_UTILITY_DESC_STATE);
            String key = getKey(acc.Partner_Account__c, utilityDescription, acc.Billingstate);
            if (fileMap.containsKey(key)) {
                pricingFile = fileMap.get(key).Pricing_File_Name__c;
            }    
        }
        if (String.IsNotBlank(pricingFile)) {
            return pricingFile;
        }
        // GRP_UTILITY_CODE
        if (String.IsNotBlank(utilityCode)) {
            Map <String, Dealer_Utility_Pricing_File__c> fileMap = groupingMap.get(GRP_UTILITY_CODE);
            for (String code : codeList) {
                if (utilityCode.startsWithIgnoreCase(code)) {
                    Utility_Code__c uc = nameUtilityCodeMap.get(code);
                    String key = getKey(uc.Id);
                    if (fileMap.containsKey(key)) {
                        pricingFile = fileMap.get(key).Pricing_File_Name__c;
                    }    
                }
            }
        }
        if (String.IsNotBlank(pricingFile)) {
            return pricingFile;
        }
        // GRP_UTILITY_DESC_STATE
        if (acc != null && String.IsNotBlank(utilityDescription) && acc.Billingstate != null) {
            Map <String, Dealer_Utility_Pricing_File__c> fileMap = groupingMap.get(GRP_UTILITY_DESC_STATE);
            String key = getKey(utilityDescription, acc.Billingstate);
            if (fileMap.containsKey(key)) {
                pricingFile = fileMap.get(key).Pricing_File_Name__c;
            }    
        }
        if (String.IsNotBlank(pricingFile)) {
            return pricingFile;
        }
        // GRP_DEALER_STATE
        if (acc != null && acc.Partner_Account__c != null && acc.Billingstate != null) {
            Map <String, Dealer_Utility_Pricing_File__c> fileMap = groupingMap.get(GRP_DEALER_STATE);
            String key = getKey(acc.Partner_Account__c, acc.Billingstate);
            if (fileMap.containsKey(key)) {
                pricingFile = fileMap.get(key).Pricing_File_Name__c;
            }    
        }
        if (String.IsNotBlank(pricingFile)) {
            return pricingFile;
        }
        // GRP_STATE
        if (acc != null && acc.Billingstate != null) {
            Map <String, Dealer_Utility_Pricing_File__c> fileMap = groupingMap.get(GRP_STATE);
            String key = getKey(acc.Billingstate);
            if (fileMap.containsKey(key)) {
                pricingFile = fileMap.get(key).Pricing_File_Name__c;
            }    
        }
        if (String.IsNotBlank(pricingFile)) {
            return pricingFile;
        }
        // default
        if (String.IsBlank(pricingFile)) {
            pricingFile = Label.CPRToABCFileName;
        }
        return pricingFile;
    }
            
    private static String getKey(String val_1) {
        String key;
        if (String.IsNotBlank(val_1)) {
            key = val_1.toUpperCase();
        }
        return key;
    }
    private static String getKey(String val_1, String val_2) {
        String key;
        if (String.IsNotBlank(val_1) && String.IsNotBlank(val_2)) {
            key = val_1.toUpperCase() + '_' + val_2.toUpperCase();
        }
        return key;
    }
    private static String getKey(String val_1, String val_2, String val_3) {
        String key;
        if (String.IsNotBlank(val_1) && String.IsNotBlank(val_2) && String.IsNotBlank(val_3)) {
            key = val_1.toUpperCase() + '_' + val_2.toUpperCase()  + '_' + val_3.toUpperCase();
        }
        return key;
    }
                
}