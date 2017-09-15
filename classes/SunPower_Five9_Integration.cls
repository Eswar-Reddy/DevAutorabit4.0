global class SunPower_Five9_Integration {

    //Response wrapper class
    global class SalesforceResponse {
        webservice String sfId = '0';
        webservice String sfPopId = '0';
        webservice String PSRId = '0';
        webservice String multId = '0';
        webservice String errorMsg = 'No Error';
        
    }

    //Method to find AccountId and PSRId based on the phone number
    webService static SalesforceResponse findAccountbyPhone(String phone) {
        SalesforceResponse sr = new SalesforceResponse();
        
        String origphonenumber = phone.replace('%20',' ');
        System.debug('origphonenumber -----' + origphonenumber);
        
        // remove all non numeric
        String phonenumber = origphonenumber.replaceAll('[^0-9]','');
        
        if(String.IsNotBlank(phonenumber)){
            String formattedPhoneNumber = phonenumber;
            
            if(phonenumber.length() == 11 && phonenumber.substring(0,1) == '1'){
                formattedPhoneNumber = phonenumber.substring(1,11);
            }    
            
            try{
                List<List<SObject>> searchList = [FIND :formattedPhoneNumber IN Phone FIELDS 
                    RETURNING Contact(Id,Name,Phone,MobilePhone,AccountId,Account.RecordType.Name,Account.Primary_PSR__r.UserName),
                        Account(Id,Name,Phone,RecordType.Name,Primary_PSR__r.UserName)
                    ];

                if (searchList != null && searchList.size() > 0) {
                    List<Contact> contactList = (List<Contact>)searchList[0];
                    System.debug('contactList -----'+contactList);
                    
                    if(contactList != null && contactList.size() > 0){
                        sr = getResponse(contactList);
                    }
                }
                
                if (sr.sfId == '0') {
                    if (searchList != null && searchList.size() > 1) {
                        List <Account> accountList = (List<Account>)searchList[1];
                        if (accountList != null && accountList.size() > 0) {
                            sr = getResponse(accountList);
                        }                    
                    }
                }
                
           }catch(Exception e){
               sr.errorMsg = e.getMessage();
           }
        }
        else{
            sr.errorMsg = 'Phone Number is blank';
        }
           
        System.debug('sr -----' + sr);

        return sr;
    }
    
    private static SalesforceResponse getResponse(List <Contact> contactList) {
        SalesforceResponse sr = new SalesforceResponse();
        
        Contact selectedContact;
        Set<Id> accountIdSet = new Set<Id>();
        for(Contact con : contactList){
            if(con.AccountId != null) {
                accountIdSet.add(con.AccountId);
                selectedContact = con;
            }    
        }
        
        System.debug('accountIdSet Size -----' + accountIdSet.size());
        if(accountIdSet.size() == 1){
            sr.sfId = selectedContact.AccountId;
            sr.sfPopId = selectedContact.AccountId;
            System.debug('selectedContact.Account.Primary_PSR__r.UserName -----' + selectedContact.Account.Primary_PSR__r.UserName);
            if(selectedContact.Account.RecordType.Name == 'Partner' && selectedContact.Account.Primary_PSR__r.UserName != null){
                sr.psrId=selectedContact.Account.Primary_PSR__r.UserName;
            }
        }
        System.debug('accountIdSet -----' + accountIdSet);
        
        sr.multId=String.valueOf(accountIdSet.size());
    
        return sr;    
    }

    private static SalesforceResponse getResponse(List <Account> accountList) {
        SalesforceResponse sr = new SalesforceResponse();
        
        System.debug('accountList Size -----' + accountList.size());
        if(accountList.size() == 1){
            sr.sfId = accountList[0].Id;
            sr.sfPopId = accountList[0].Id;
            if(accountList[0].RecordType.Name == 'Partner' && accountList[0].Primary_PSR__r.UserName != null){
                sr.psrId = accountList[0].Primary_PSR__r.UserName;
            }
        }
        
        sr.multId=String.valueOf(accountList.size());
    
        return sr;    
    }
    
}