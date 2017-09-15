/**
 ** Developed- Birlasoft
 ** Rest Request Format: /services/apexrest/SPWRCustomerAPI/GetCustomerInfo/?QuoteId=<QuoteNumber>
 ** From the workbench we can test by using url in Rest Explorer- /services/apexrest/SPWRCustomerAPI/GetCustomerInfo/?QuoteId=00630610
 **/

@RestResource(urlMapping='/SPWRCustomerAPI/GetCustomerInfo/*')
global class GPPServicesCustomer
{
/******* SERVICE : GET : start *******/

    @HttpGet
    global static CustomerInformation GetCustomerInfo()
    {
        CustomerInformation cWC;
        RestRequest req = RestContext.request;
        try
        {
            if(String.isNotBlank(req.params.get('QuoteId')))
            {
                String sWhereClauseQuote= 'WHERE QuoteNumber= \'' + req.params.get('QuoteId') + '\'';
                List<Quote> lstQot= GPPQueryHelper.GetQuotes(sWhereClauseQuote);
                if(lstQot != null && !lstQot.isEmpty())
                {
                    String sWhereClauseAccount= 'WHERE Id =\'' + lstQot[0].Opportunity.Account.Id + '\'';
                    List<Account> lstAcc= GPPQueryHelper.GetAccounts(sWhereClauseAccount);
                    List<Account> listInstaller= new List<Account>();
                    if(lstQot[0].Installer__r.Id != null){
                        String sWhereClauseInstallerAccount= 'WHERE Id =\'' + lstQot[0].Installer__r.Id + '\'';
                        listInstaller= GPPQueryHelper.GetAccounts(sWhereClauseInstallerAccount);
                       } 
                    if(lstAcc != null && !lstAcc.isEmpty())
                    {
                        List<Contact> lstC = lstAcc[0].Contacts;
                        List<Opportunity> lstO= lstAcc[0].Opportunities;
                        cWC = new CustomerInformation(lstAcc[0], lstC, lstO,listInstaller);
                        return cWC;
                    }
                }
            }
        } catch (exception e){}
        return null;
    }//ENd Func GetCustomerInfo
    
/******** SERVICE : GET : end ********/

/****** WRAPPER : start ******/

    //Wrapper Class-Customer information 
    global class CustomerInformation 
    {
        global String CustomerName;
        global String Address1;
        global String Address2;
        global String City;
        global String State;            //  sangita added
        global String Country;      
        global String PostalCode;       //  global String Zipcode;//March 21-Changed Zip Code to Postal Code
        
        global Double Longitude;
        global Double Latitude;
         
        global Double SalesTaxRate;     //  sangita 
        global String LeadSource;       //  CR: Chris: 11th Apr 2014: Include Lead Source
        global String NMI;              //  CR: Sangita: 28th Apr 2014: Include NMI Code 
        
        global List<CustomerContactInformation> Contacts= new List<CustomerContactInformation>();      
        global List<CustomerInstallerInformation> Installers= new List<CustomerInstallerInformation>();  
        
        
        
        public CustomerInformation(Account xacc, List<Contact> xContacts, List<Opportunity> xOpportunities,List<Account> xInstaller)
        {
            this.CustomerName = xacc.Name; 
            this.Address1 = xacc.BillingStreet; 
            this.Address2 = '';  
            this.City = xacc.BillingCity;
            this.State = xacc.BillingState;         
            this.Country = xacc.BillingCountry;
            this.PostalCode = xacc.BillingPostalCode;

            this.Longitude = xacc.Log__c;
            this.Latitude = xacc.Lat__c;

            this.SalesTaxRate = xacc.Sales_Tax_Rate__c;            //Sangita commented  
            
            
            
            if(xContacts != null && !xContacts.isEmpty()){
                for(Contact con: xContacts)
                    Contacts.add(new CustomerContactInformation(con));
            }
            
            if(xOpportunities != null && !xOpportunities.isEmpty()){
                for(Opportunity opp: xOpportunities){
                    this.LeadSource= opp.Lead_Manufacturer__c;
                    this.NMI= opp.NMI__c;
                }
            }
            if(xInstaller != null && !xInstaller.isEmpty()){
                for(Account objAccount: xInstaller)
                    Installers.add(new CustomerInstallerInformation(objAccount));
            }           
        }
    }//END Class CustomerInformation
    
    //Wrapper Class- Contact Information
    global class CustomerContactInformation 
    {
        global String ContactType;
        global String FirstName;        
        global String LastName;
        global String PhoneNumber;
        global String Email; 
                                       
        public CustomerContactInformation(Contact xCon)
        {
            this.FirstName = xCon.FirstName; 
            this.LastName = xCon.LastName; 
            this.PhoneNumber = xCon.Phone;
            this.Email = xCon.Email;  
            if(xCon.Primary__c ==True)
            {
              this.ContactType = 'Primary';
            }else if (xCon.Primary__c !=True && xCon.Include_in_Lease_Doc__c == True)
            {
              this.ContactType = 'co-applicant';
            }else if (xCon.Primary__c !=True && xCon.Include_in_Lease_Doc__c != True)
            {
              this.ContactType = '';
            }
        }     
    }//END Class CustomerContactInformation

    //Wrapper Class- Installer Information
    global class CustomerInstallerInformation 
    {
        global String InstallerName;
        global list<CustomerContactInformation> Contacts;
        global String InstallerPhoneNumber;
        global String InstallerEmail; 
        global String InstallerProfile;
        global String InstallerFeeLatitude;
        global String InstallerFeeLongitude;    
//        global String InstallerPartnerDescription;
        global String SpecializedInstaller;       

        public CustomerInstallerInformation(Account objAccount)
        {   
            Contacts = new list<CustomerContactInformation>();
            this.InstallerName = objAccount.Name; 
            for(Contact objContact : objAccount.Contacts){
                System.debug('------------------------objContact'+objContact);
                 Contacts.add(new CustomerContactInformation(objContact));   
            }
           // this.InstallerPartnerDescription = objAccount.Description;
            this.InstallerFeeLongitude = objAccount.Fee_Cal_Longitude__c;
            this.InstallerFeeLatitude = objAccount.Fee_Cal_Latitude__c;
            this.SpecializedInstaller = objAccount.Specialized_Installer__c ; 
           this.InstallerProfile= objAccount.Partner_Facts__c;
           this.InstallerEmail = objAccount.Email__c;
           this.InstallerPhoneNumber = objAccount.Phone;
        }     
    }//END Class CustomerContactInformation
    
/****** WRAPPER : end ******/   

}//End Class GPPServicesCustomer