public without sharing class AuroraAPIUtil {

    public static Site_Information_Form__c getSite(String siteId) {
        Site_Information_Form__c site = new Site_Information_Form__c();
        if (String.IsNotBlank(siteId)) {
            List <Site_Information_Form__c> siteList = [SELECT Id, Name,
                    Account__c,
                    External_Project_Id__c,
                    Internal_Project_Id__c,
                    Site_Name__c, //KCM_02212017: Pivotal 140102229
                    Site_Address__c,
                    Site_City__c,
                    Site_State__c,
                    Site_Zip_Postal_Code__c,
                    Site_Country__c,
                    Site_Latitude_Y_coordinate__c,
                    Site_Longitude_X_coordinate__c
                FROM Site_Information_Form__c WHERE Id = :siteId];
            if (siteList.size() > 0) {
                site = siteList[0];
            } 
        }   
        return site;
    }
    
    public static Design__c getDesign(String designId) {
        Design__c design = new Design__c();
        if (String.IsNotBlank(designId)) {
            List <Design__c> designList = [SELECT Id, Name,
                    Deal_Status__c, 
                    RecordType.DeveloperName,
                    Revision_Letter__c,
                    Roof_Design__c,
                    Roof_Design__r.Design_DesignId__c,
                    Site__c,
                    Site__r.External_Project_Id__c, 
                    Site__r.Internal_Project_Id__c 
                FROM Design__c WHERE Id = :designId];
            if (designList.size() > 0) {
                design = designList[0];
            }
        }
        return design;
    }

    public static Roof_Design__c getRoofDesign(String roofDesignId) {
        Roof_Design__c roofDesign = new Roof_Design__c();
        if (String.IsNotBlank(roofDesignId)) {
            List <Roof_Design__c> roofDesignList = [SELECT Id, Design_DesignId__c FROM Roof_Design__c WHERE Id = :roofDesignId];
            if (roofDesignList.size() > 0) {
                roofDesign = roofDesignList[0];
            }
        }
        return roofDesign;
    }
    
    
    public static User getUser(String userId) {
        User u = new User();
        if (String.IsNotBlank(userId)) {
            List <User> uList = [SELECT Id, Name, ContactId, Contact.Account.Design_Tool_Organization_Id__c 
                FROM User WHERE Id = :userId];
            if (uList.size() > 0) {
                u = uList[0];
            }
        }
        return u;
    }
    
    public static Account getAccount(String accountId) {
        Account acc = new Account();
        if (String.IsNotBlank(accountId)) {
            List <Account> accList = [SELECT Id, Name,
                    ShippingStreet,
                    ShippingCity,
                    ShippingState,
                    ShippingPostalCode,
                    ShippingCountry
                FROM account WHERE Id = :accountId];
            if (accList.size() > 0) {
                acc = accList[0];
            } 
        }   
        return acc;
    }
    
    public static List <Contact> getContactList(String accountId) {
        List <Contact> conList = new List <Contact>();
        if (String.IsNotBlank(accountId)) {
            conList = [SELECT Id, FirstName, LastName, Salutation FROM Contact WHERE AccountId = :accountId];
        }
        return conList;
    }
    
    public static String getCustomerAddress(Account acc) {
        String address = '';
        address = (acc.ShippingStreet != null ? acc.ShippingStreet : '').trim();
        address += ',' + (acc.ShippingCity != null ? acc.ShippingCity : '').trim();
        address += ',' + (acc.ShippingState != null ? acc.ShippingState : '').trim();
        address += ',' + (acc.ShippingPostalCode != null ? acc.ShippingPostalCode : '').trim();
        address += ',' + (acc.ShippingCountry != null ? acc.ShippingCountry : '').trim();

        return address.trim();
    }
    
    public static String getSiteAddress(Site_Information_Form__c site) {
        String address = '';
        address = (site.Site_Address__c != null ? site.Site_Address__c : '').trim();
        address += ',' + (site.Site_City__c != null ? site.Site_City__c : '').trim();
        address += ',' + (site.Site_State__c != null ? site.Site_State__c : '').trim();
        address += ',' + (site.Site_Zip_Postal_Code__c != null ? site.Site_Zip_Postal_Code__c : '').trim();
        address += ',' + (site.Site_Country__c != null ? site.Site_Country__c : '').trim();

        return address.trim();
    }
    
    public static String getTimestamp() {
        String timestamp = datetime.now().format('yyyy-MM-dd HH:mm:ss', 'UTC') + ' UTC';
        return timestamp;
    }
    
    public static String getUrlEncoded(String str) {
        String retStr = '';
        System.debug('STRING BEFORE CLEANING: ' + str);

        // cannot pass null or empty string
        if (str != null && str != '') {
            retStr = EncodingUtil.urlEncode(str, 'UTF-8'); // not working. need to replace some chars

            System.debug('ENCODED: ' + retStr);

            retStr = retStr.replace('+', '%20');
            retStr = retStr.replace('%21', '!');
            retStr = retStr.replace('%24', '$');
            retStr = retStr.replace('%26', '&');
            retStr = retStr.replace('%27', '\'');
            retStr = retStr.replace('%28', '(');
            retStr = retStr.replace('%29', ')');
            retStr = retStr.replace('%2B', '+');
            retStr = retStr.replace('%2C', ',');
            retStr = retStr.replace('%2F', '/');
            retStr = retStr.replace('%3A', ':');
            retStr = retStr.replace('%3B', ';');
            retStr = retStr.replace('%3D', '=');
            retStr = retStr.replace('%3F', '?');
            retStr = retStr.replace('%40', '@');
            retStr = retStr.replace('%5B', '[');
            retStr = retStr.replace('%5D', ']');
            retStr = retStr.replace('%7E', '~');
        }
        System.debug('FINAL: ' + retStr);
        return retStr;
    }

    public static String generateHmacSHA256Signature(String saltValue, String secretKeyValue) {
        String algorithmName = 'HmacSHA256';
        Blob hmacData = Crypto.generateMac(algorithmName, Blob.valueOf(saltValue), Blob.valueOf(secretKeyValue));
        return EncodingUtil.base64Encode(hmacData);
    }
    
    public static CustomSetting getCustomSetting() {
        CustomSetting setting = new CustomSetting();
    
        // get from custom settings
        Map <String, Loan_Callout_Settings__c> csMap = Loan_Callout_Settings__c.getAll();
        if (csMap != null && csMap.containsKey('Aurora')) {
            Loan_Callout_Settings__c cs = csMap.get('Aurora');
            
            setting.AuroraKey = cs.Key__c;
            setting.tenant_Id = cs.Tenant_Id__c;
            setting.client_Secret = cs.Client_Secret__c;
            if (Userinfo.getUserType() != 'Standard') {
                setting.userType = cs.UserType_Partner__c;
            } else {
                setting.userType = cs.UserType_Internal__c;
            }
            if (runningInSandbox()) {
                setting.endpoint_URL = cs.Endpoint_URL_Sandbox__c;
                setting.auroraAuthURL = cs.AuthURL_Sandbox__c;
                setting.auroraRedirectURI = cs.Redirect_URI_Sandbox__c;
            } else {
                setting.endpoint_URL = cs.Endpoint_URL__c;
                setting.auroraAuthURL = cs.AuthURL_Production__c ;
                setting.auroraRedirectURI = cs.Redirect_URI_Production__c;
            }
        }
    
        return setting;
    }
    
    private static Boolean runningInSandbox() {
        return [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
    }
    
    public class CustomSetting {
        public String AuroraKey;
        public String tenant_Id;
        public String client_Secret;
        public String auroraAuthURL;
        public String userType;
        public String auroraRedirectURI; 
        public String endpoint_URL;   
    }

    public without sharing class SpectrumLog {
        public List <Sunpower_Spectrum_Debug_Log__c> logList = new List<Sunpower_Spectrum_Debug_Log__c>(); 
        public Sunpower_Spectrum_Debug_Log__c getLog(SpectrumLogParams param) { 
            Sunpower_Spectrum_Debug_Log__c log = new Sunpower_Spectrum_Debug_Log__c();
            log.Site__c = param.siteId;
            log.Design__c = param.designId;
            log.JSON_Payload__c = param.jsonPayload;
            log.Response__c = param.response;
            log.Response_Status_Code__c = param.responseStatusCode;
            log.Service__c = param.service;
            return log;
        }
        public void insertLog() {
            insert this.logList;
        }
        
    }
    
    public class SpectrumLogParams {
        public String siteId;    
        public String designId;
        public String jsonPayload;
        public String response;
        public Decimal responseStatusCode;
        public String service;
    }

}