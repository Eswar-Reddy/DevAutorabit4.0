/*
Sample Record for Testing == /services/apexrest/SPWRPartnerService/GetPartnerPermissions?UserId=005S0000004JOpX
*/
//@RestResource(urlMapping='/GPPPartnerService/GetPartnerPermissions/*')
@RestResource(urlMapping='/SPWRPartnerService/GetPartnerPermissions/*')

global with sharing class GPPServicesPartner
{
    @HttpGet
    global static PartnerPermissionInformation GetPartnerPermissions()
    {
      PartnerPermissionInformation cWC;
      RestRequest req = RestContext.request;
      try
        {
            if(String.isNotBlank(req.params.get('UserId')))
            {
                String sWhereClause= 'WHERE ContactId <> null AND ID=\'' + req.params.get('UserId') + '\' AND isActive= true';
                List<User> lstUsr= GPPQueryHelper.GetUsers(sWhereClause);
                
                if(lstUsr != null && !lstUsr.isEmpty()){
                    cWC = new PartnerPermissionInformation(lstUsr[0]);            
                    return cWC; 
                }                          
            }
        } catch (exception e) {}
      return null;    
    }
    //Wrapper Class- 
    Global class PartnerPermissionInformation 
    {
        global String PartnerTier;
        global String LOB;
        global String Lease = 'N';
        global String Cash = 'N';
        global String Loan;
        global String Country;
        global String Locale;
        global String SpecializedSeller; 
        global String sellerName;
        global String sellerPhoneNumber;
        global String sellerEmail;
        global String sellerProfile;
//        global String SpecializedInstaller;        
                
        public PartnerPermissionInformation(User xUsr)
        {
            this.PartnerTier = xUsr.Contact.Account.Dealer_Tier__c;
            this.LOB = xUsr.Contact.Account.Line_of_Business__c;
            //this.Country = xUsr.Contact.Country_Domain__c;
            this.Country = xUsr.Contact.Account.BillingCountry;         
            this.Locale = xUsr.LanguageLocaleKey;
            this.SpecializedSeller = xUsr.Contact.Account.Specialized_Seller__c;
            this.sellerName = xUsr.Contact.Account.Name;
            this.sellerPhoneNumber = xUsr.Contact.Account.Phone;
            this.sellerEmail = xUsr.Contact.Account.Email__c;
            this.sellerProfile = xUsr.Contact.Account.Partner_facts__c;
//            this.SpecializedInstaller = xUsr.Contact.Account.Specialized_Installer__c;
            
            /****CHECKING LOAN TYPE***/
            if(xUsr.Contact.Account.Same_as_Cash_Program_Partner__c == true)
             this.Loan = 'DCU';
            if(xUsr.Contact.Account.Can_Sell_SunPower_20yr_Loan__c == true)
             this.Loan = 'Enerbank' ;
            if(xUsr.Contact.Account.Can_Sell_SunPower_20yr_Loan__c == true && xUsr.Contact.Account.Can_Sell_SunPower_20yr_Loan__c == true)
             this.Loan = 'DCU,Enerbank' ;
                 
            if(string.isNotBlank(xUsr.Contact.Account.Business_Function__c) && string.isNotBlank(xUsr.Business_Function__c))
            {
               Set<String> sAcctBF = new Set<String>();
               Set<String> sUsrBF = new Set<String>();
               sAcctBF.addAll(xUsr.Contact.Account.Business_Function__c.split(';'));
               sUsrBF.addAll(xUsr.Business_Function__c.split(';'));
                /* COMMENT-Logic Provided by Paul Huynh -3/15/2014
                   SFDCAccountSetting  && SFDCUserSetting = GPPUserSetting
                Examples:
                   True && True = True
                   False && True = False
                   True && False = False
                */              
              if(sAcctBF.contains('Lease') == true && sUsrBF.contains('Create Lease Quote') == true )
              {  this.Lease = 'Y'; }
              else if(sAcctBF.contains('Lease') == false && sUsrBF.contains('Create Lease Quote') == true ) {  this.Lease = 'N'; }
              else if(sAcctBF.contains('Lease') == true && sUsrBF.contains('Create Lease Quote') == false ) {  this.Lease = 'N';}

               if(sAcctBF.contains('Cash') == true && sUsrBF.contains('Create Cash Quote') == true )        {  this.Cash = 'Y'; }
              else if(sAcctBF.contains('Cash') == false && sUsrBF.contains('Create Cash Quote') == true )   {  this.Cash = 'N'; }
              else if(sAcctBF.contains('Cash') == true && sUsrBF.contains('Create Cash Quote') == false )   {  this.Cash = 'N';}
            }               
        }     
    }//END
    
}