public class PortalHomepage {
    
    
    public String userId {
     get {
        if(userId == null)
          userId = UserInfo.getUserId();
        return userId;      
      }
      set;
    }


    public String userName {
     get {
        if(userName == null)
          userName = UserInfo.getName();
        return userName ;      
      }
      set;
    }    
     
         
  
    
    public boolean isPartnerUser {
        get {
            String userType =  UserInfo.getUserType();
            if (UserType.contains('PowerPartner')) {
                return true;
            } else {
                return false;
            }
        }
        set;
    }
       
    public boolean isEUPartnerAccount {
    get {
        String userId= UserInfo.getUserID(); 
        boolean isEUPartner = false;
        List<User> listUser = [Select u.Id, u.Profile.Name, u.Contact.AccountId from User u where u.Id= :userId ];
        if (listUser.size() > 0 ) {
            String profileName = listUser[0].Profile.Name;
            if (profileName != null && (profileName.StartsWith('EU Partner') || profileName.StartsWith('EU Residential'))  ) {
                isEUPartner = true;
            }
        }
        return isEUPartner ;
     }
     set;
     }  
     
     public boolean isItalian {
    get {
        String userLocale= UserInfo.getLocale();
        boolean isLocaleItalian = false;        
        if(userLocale =='it' || userLocale=='IT'){
            isLocaleItalian =true;
        }
        return isLocaleItalian ;
     }
     set;
     }  
     
     public boolean isSpanish {
    get {
        String userLocale= UserInfo.getLocale();
        boolean isLocaleSpanish = false;        
        if(userLocale =='es' || userLocale=='ES'){
            isLocaleSpanish =true;
        }
        return isLocaleSpanish ;
     }
     set;
     }  
     
     public boolean isGerman {
    get {
        String userLocale= UserInfo.getLocale();
        boolean isLocaleGerman = false;        
        if(userLocale =='de' || userLocale=='DE'){
            isLocaleGerman =true;
        }
        return isLocaleGerman ;
     }
     set;
     }  
     
     //begin: for case no: 00069105
      public boolean isDutch {
    get {
        String userLocale= UserInfo.getLocale();
        boolean isLocaleDutch = false;        
        if(userLocale =='nl_BE' || userLocale=='nl_BE'){
            isLocaleDutch =true;
        }
        return isLocaleDutch ;
     }
     set;
     } 
     
     
     public boolean isFrenchBE {
    get {
        String userLocale= UserInfo.getLocale();
        boolean isLocaleFrenchBE = false;        
        if(userLocale =='fr_BE' || userLocale=='FR_BE'){
            isLocaleFrenchBE =true;
        }
        return isLocaleFrenchBE ;
     }
     set;
     } 
//end: for case nO:00069105

     
     
     public boolean isFrench {
    get {
        String userLocale= UserInfo.getLocale();
        boolean isLocaleFrench = false;        
        if(userLocale =='fr' || userLocale=='FR'){
            isLocaleFrench =true;
        }
        return isLocaleFrench ;
     }
     set;
     } 
     
     
     
     
    public boolean isPremierPartnerAccount {
    get {
        boolean isPremier = false;
        if(AccountType != null && AccountType.StartsWith('Premier')) {
          isPremier = true;
        }
        return isPremier;
     }
     set;
     }   
     
    public boolean isCommercialAccount {
    get {
        boolean isCommercial= false;
        if(AccountType != null && AccountType.contains('Commercial')) {
          isCommercial= true;
        }
        return isCommercial;
     }
     set;
     }   
     
    public boolean isAuthorizedAccount {
    get {
        boolean isAuthorized= false;
        if(AccountType != null && AccountType.contains('Authorized')) {
          isAuthorized= true;
        }
        return isAuthorized;
     }
     set;
     }        
          
     
     public String AccountType {
        get {
            String returnAccountType = '';
            if (AccountType == null) {
                List<User> listUser = [Select u.Id, u.Contact.AccountId from User u where u.Id= :userId ];
                if ( listUser.Size() > 0 ) {
                    String myAccountId = ListUser[0].Contact.AccountId;
                    if (myAccountId != null) {
                        List<Account> listAccounts = [Select a.Id, a.Type
                          From Account a  
                          Where a.Id = :myAccountId]; 
                        if ( listAccounts.Size() > 0 && listAccounts[0].Type != null) {
                            returnAccountType = listAccounts[0].Type;
                        }
                    }
                }
            } else {
              return AccountType;
            }
            return returnAccountType;
         }
         set;     
     }
     
   
     
    String accId{get;set;}


    

}