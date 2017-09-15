@RestResource(urlMapping='/getPartnerPermissions/*')
/*Usage:  /services/apexrest/getPartnerPermissions?UserId=00580000003Z0MS&State='CA' */
global with sharing class PartnerPermissionREST {

    @HttpGet
    global static Response doGet() {
        Response r = new Response();
    
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Map <String, String> params = req.params;
        
        String userId, state;
        if (params != null) {
            for (String param : params.keySet()) {
                String value = params.get(param); 
                r.requestParams.add(new RequestParam(param, value));
                if (param == 'userId') {
                    userId = value;
                } else if (param == 'state') {
                    state = value;
                }           
            }
        }
        
        // validate
        if (String.IsBlank(userId)) {
            r.errors.add(ProdConfigurationError.getError(800));
        }
        if (String.IsBlank(state)) {
            r.errors.add(ProdConfigurationError.getError(801));
        }
        if (r.errors.size() > 0) {
            return r;
        } else {
            r.success = true;
        }
        
        Map <String, String> businessFuntion_offering_map = new Map <String, String>{
            'Create Cash Quote' => 'Cash',
            'Create Lease Quote' => 'Lease',
            'Create Loan Quote' => 'Loan'
        };
        
        if (String.IsNotBlank(userId)) {
            User u = getUser(userId);
            if (u != null) {
                Set <String> offerings = new Set <String>();
                if (u.Business_Function__c != null) {
                    List <String> businessFunctions = u.Business_Function__c.split(';');
                    r.businessFunctions = businessFunctions;
                    for (String bf : businessFunctions) {
                        if (businessFuntion_offering_map.containsKey(bf)) {
                            offerings.add(businessFuntion_offering_map.get(bf));
                        }
                    }
                } else {
                
                }
                if (u.Contact.AccountId != null) {
                    Account a = getAccount(u.Contact.AccountId);
                    if (a != null) {
                        Set <String> states = new Set <String>();
                        for (Business_Registration__c br : a.Business_Registrations__r) {
                            states.add(br.State__c);
                            BusinessRegistration busReg = new BusinessRegistration();
                            busReg.licenseState = br.State__c;
                            busReg.licenseNumber = br.License_Number__c;
                            r.businessRegistrations.add(busReg);
                            //r.brList.add(new Business_Registration__c(State__c = busReg.licenseState, License_Number__c = busReg.licenseNumber));
                        
                            //Map <String, String> brMap = new Map <String, String>();
                            //brMap.put('State__c', br.State__c);
                            //brMap.put('License_Number__c', br.License_Number__c);
                            //r.brMapList.add(brMap);
                        }
                        if (states.contains(state)) {
                            r.quoteCreation = getSectors(state, offerings);
                        }
                    }
                }
            }
        }
        
        return r;    
    }
    
    private static List <Sector> getSectors(String state, Set <String> offerings) {
        List <Sector> sectorList = new List <Sector>();
        Map <String, Set <String>> sector_offeringSet_map = new Map <String, Set <String>>();
        for (SPWR_Financial_Offering__c fo : [SELECT Financial_Offering__c, Sector__c, State__c FROM SPWR_Financial_Offering__c]) {
            if (fo.State__c != null) {
                for (String s : fo.State__c.split(';')) {
                    if (s == state) {
                        if (fo.Financial_Offering__c != null && fo.Sector__c != null) {
                            Set <String> offeringSet = new Set <String>();
                            if (sector_offeringSet_map.containsKey(fo.Sector__c)) {
                                offeringSet = sector_offeringSet_map.get(fo.Sector__c);
                            }
                            if (offerings.contains(fo.Financial_Offering__c)) {
                                offeringSet.add(fo.Financial_Offering__c);
                            }
                            sector_offeringSet_map.put(fo.Sector__c, offeringSet);
                        }
                    }
                }
            }
        }
        
        for (String sec : sector_offeringSet_map.keySet()) {
            Sector s = new Sector();
            s.sector = sec;
            s.financialOfferings = new List <String>(sector_offeringSet_map.get(sec));
            sectorList.add(s);
        }
        return sectorList;
    }
    
    private static Account getAccount(String accountId) {
        Account a;    
        List <Account> aList = [SELECT Id, 
            (SELECT Id, Billing_State__c, Is_License_Valid__c, License_Number__c, State__c 
                FROM Business_Registrations__r WHERE Is_License_Valid__c = true) 
            FROM Account WHERE Id = :accountId];
        if (aList.size() > 0) {
            a = aList[0];
        }
        return a;    
    }

    private static User getUser(String userId) {
        User u;
        List <User> uList = [SELECT Id, ContactId, Contact.AccountId, Business_Function__c FROM User WHERE Id = :userId];
        if (uList.size() > 0) {
            u = uList[0];
        }  
        return u; 
    }
    
    global class Response {
        Boolean success = false;
        List <RequestParam> requestParams = new List <RequestParam>();
        List <String> businessFunctions = new List <String>();
        List <BusinessRegistration> businessRegistrations = new List <BusinessRegistration>();
        List <Sector> quoteCreation = new List <Sector>();
        List <ProdConfigurationError.Error> errors = new List <ProdConfigurationError.Error>();
        //List <Business_Registration__c> brList = new List <Business_Registration__c>();
        //List <Map <String, String>> brMapList = new  List <Map <String, String>>();
    }
    private class RequestParam {
        String name;
        String value;
        RequestParam(String name, String value) {
            this.name = name;
            this.value = value;
        }
    } 
    private class BusinessRegistration {
        String licenseState;    
        String licenseNumber;    
    }
    private class Sector {
        String sector;    
        List <String> financialOfferings = new List <String>();
    }
    
}