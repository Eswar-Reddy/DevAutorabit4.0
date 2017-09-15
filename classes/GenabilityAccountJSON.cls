public class GenabilityAccountJSON {

    public String status {get;set;}
    public Integer count {get;set;}
    public String type {get;set;}
    public List<Account> results {get;set;}

    public class Account{
        public String accountId;                            //This is the unique Genability ID of this Account object.
        public String providerAccountId;	                //If you use a unique identifier for this account in your own systems, you can specify that here. This allows you to quickly tie your own data with what you create with the Genability APIs. This must be unique within your accounts.
        public String accountName;	                        //This is the name of the account. We suggest using this field to identify the entity this account represents. For a small business, this could the name of the business. For a larger business with multiple locations, this could be the name of the location, e.g. Starbucks, Briarwood Mall.
        public String customerOrgId;	                    //This allows grouping of accounts together. The customerOrgId should be an ID you use in your own systems to identify this account. Specifying a customerOrgId simplifies tying the account to your own data.
        public String customerOrgName;	                    //This is the name of the account's organization. We suggest using this field to identify the name of the account's business. For example, Starbucks.
        public Address address;	                            //Holds any address and geo-location data this account has.
        public String timeZone;	                            //The timezone that this account is located in. They are in the tz database format.
        public String owner;	                            //Use this to set the person who currently "owns" this account (otherwise its null)
        public String status;	                            //This indicates the status of this account. Possible values are: ACTIVE (defaults to this), INACTIVE and DELETED.
        public String type;	                                //This indicates the account type, whether of eg a customer or a prospect. Possible values are: CUSTOMER, POTENTIAL, TARGET and ARCHETYPE. By default, this is null.
        public Map<String,GenabilityPropertyJSON.Property> properties;                //This is a list of properties that exist on this account.
        public List<GenabilityTariffJSON.Tariff> tariffs;   //This is a list of tariffs that are on the account.

        public Account(String sproviderAccountId,
                        String saccountName,
                        Address aaddress,
                        Map<String,GenabilityPropertyJSON.Property> propertyMap
                        ){
            providerAccountId = sproviderAccountId;
            accountName = saccountName;
            address = aaddress;
            properties = propertyMap;
        }
    }

    public class Address{
        public String addressString;    //Full free text string representing address. This is the property that is usually passed in. Zip will suffice but the full address is better.
        public String addressName;      //A name associated with the address (e.g. Headquarters). Not usually set.
        public String address1;         //First part of the address. Usually populated by our address validation from the addressString passed in.
        public String address2;         //Second part of the address. Usually populated by our address validation from the addressString passed in.
        public String city;             //City of the address. Usually populated by our address validation from the addressString passed in.
        public String state;            //State of the address. Usually populated by our address validation from the addressString passed in.
        public String zip;              //Postcode or ZIP code of the address. Usually populated by our address validation from the addressString passed in.
        public String country;          //Usually the ISO Country Code of the address. Usually populated by our address validation from the addressString passed in.
        public String formattedAddress; //This read-only field populated by our geo-coding and address parsing service (we use Google).
        public Double lon;              //Longitude of the address. We'll populate this by geo-tagging the address.
        public Double lat;              //Latitude of the address. We'll populate this by geo-tagging the address.
        
        public Address(String saddressString,
                       String saddressName,
                       String saddress1,
                       String saddress2,
                       String scity,
                       String sstate,
                       String szip,
                       String scountry,
                       Double dlon,
                       Double dlat){
            addressString = saddressString;
            addressName = saddressName;
            address1 = saddress1;
            address2 = saddress2;
            city = scity;
            state = sstate;
            zip = szip;
            country = scountry;
            lon = dlon;
            lat = dlat;
        }
    }

    public class GetDollarAmount {
        public String providerAccountId;
        public String fromDateTime;
        public String toDateTime;
        public String billingPeriod;
        public String detailLevel;
        public List<TariffInput> tariffInputs;

        public GetDollarAmount( String sproviderAccountId,
                                String sfromDateTime,
                                String stoDateTime,
                                String sbillingPeriod,
                                String sdetailLevel,
                                List<TariffInput> listoftariffInputs
                                 ){
            providerAccountId = sproviderAccountId;
            fromDateTime = sfromDateTime;
            toDateTime = stoDateTime;
            billingPeriod = sbillingPeriod;
            detailLevel = sdetailLevel;
            tariffInputs = listoftariffInputs;
        }
    }

    public class TariffInput {
        public String fromDateTime;
        public String toDateTime;
        public String keyName;
        public String dataValue;
        public String unit;

        public TariffInput( String sfromDateTime,
                            String stoDateTime,
                            String skeyName,
                            String sdataValue,
                            String sunit
                            ){
            fromDateTime = sfromDateTime;
            toDateTime = stoDateTime;
            keyName = skeyName;
            dataValue = sdataValue;
            unit = sunit;
        }
    }
}