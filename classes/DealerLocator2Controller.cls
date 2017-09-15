public without sharing class DealerLocator2Controller {

    public String BusinessUnit {get; set;}
    public String street            {get; set;}
    public String city          {get; set;}
    public String state             {get; set;}
    public String postalCode    {get; set;}
    public String country       {get; set;}
    public String score       {get; set;}   

    public String leadStreet            {get; set;}
    public String leadCity              {get; set;}
    public String leadState             {get; set;}
    public String leadPostalCode    {get; set;}
    public String leadCountry       {get; set;}   

    public String FirstName {get; set;}     
    public String LastName  {get; set;}         
    public String Company       {get; set;}      
    public String Email         {get; set;}  
        
    public String lat               {get; set;}  
    public String lon               {get; set;}  
    
    list<DealerLocatorService.ResultRow> drows;

    public list<DealerLocatorService.ResultRow> getdealerRows() {
        return drows;
    }
    
    public DealerLocator2Controller() {
        dRows       = new List<DealerLocatorService.ResultRow>();
        street      ='387 Corona St';
        city            ='Denver';
        state           ='CO';
        postalCode  ='80218';
        country     ='United States';
        
    }         
     
    public void doGetDealers() {
        List<DealerLocatorService.ResultRow> resultRows = new List<DealerLocatorService.ResultRow>();
        //drows = DealerLocatorService.findDealers( this.street,  this.city,  this.state,  this.postalCode,  this.country, '');
        drows = DealerLocatorService.fetchDealers(this.postalCode, 100, BusinessUnit);
        
        
        //This is redundant - just for testing
        String cleanAddress = GeocodeAsyncHandler.cleanAddress( null,  null,  null,  this.postalCode,  'United States');
        GeocodeAsyncHandler.GeoInfo  info = GeocodeAsyncHandler.GeoCodeWithZipCodeFilter(cleanAddress, this.postalCode);
        
        if (info.lat != null) {
            lat = string.valueOf(info.lat);
            lon = string.valueOf(info.lon);
        }
        else {
            lat = '';
            lon = '';
        }
    }

    public void doGetAllDealers() {
        List<DealerLocatorService.ResultRow> resultRows = new List<DealerLocatorService.ResultRow>();
        //drows = DealerLocatorService.findDealers( this.street,  this.city,  this.state,  this.postalCode,  this.country, '');
        drows = DealerLocatorService.fetchAllDealers();
        
        
        //This is redundant - just for testing
        String cleanAddress = GeocodeAsyncHandler.cleanAddress( null,  null,  null,  this.postalCode,  'United States');
        GeocodeAsyncHandler.GeoInfo  info = GeocodeAsyncHandler.GeoCodeWithZipCodeFilter(cleanAddress, this.postalCode);
        
        if (info.lat != null) {
            lat = string.valueOf(info.lat);
            lon = string.valueOf(info.lon);
        }
        else {
            lat = '';
            lon = '';
        }
    }
        
    public void doCreateTestLead() {
        Lead l = new Lead();
        //RecordType ResidentialRecordType = DealerUtility.GetResidentialRecordType();
        Id ResidentialRecordTypeId = DealerUtility.GetResidentialRecordType();
        //l.RecordTypeId = ResidentialRecordType.Id;
        l.RecordTypeId = ResidentialRecordTypeId;
        l.FirstName     = FirstName;
        l.LastName  = LastName;
        l.Company       = Company;
        l.Email             = Email;
        l.street            = leadStreet;
        l.city              = leadCity;
        l.state         = leadState;
        l.postalcode    = leadPostalCode;
        l.country           = leadCountry;
        l.Lat__c            = 39.721956;
        l.Log__c        = -104.974382;
        l.LeadSource    = 'Web';
        //l.Campaign_ID__c = '701800000007iT6'; 
        //l.Dealer_Locator_Selection__c = '0018000000UqMS4AAN';
        if (Test.isRunningTest())
            l.lastName = 'DealerLocator2Controller';
        l.Phone='1234567890';
        insert l;
    }       
    
}