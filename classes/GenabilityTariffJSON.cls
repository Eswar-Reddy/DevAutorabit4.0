public class GenabilityTariffJSON {
    
    public String status {get; set;}
    public Integer count {get; set;}
    public String type {get; set;}
    public List<Tariff> results {get; set;}
    
    public class Tariff{
        public	Long	tariffId {get; set;}	                //Unique Genability ID (primary key) for this tariff
        public	Long	masterTariffId {get; set;}	            //Unique Genability ID that persists across all revisions of this tariff
        public	String	tariffCode {get; set;}	                //Short code that the LSE uses as an alternate name for the tariff
        public	String	tariffName {get; set;}	                //Name of the tariff as used by the LSE
        public	Long	lseId {get; set;}	                    //ID of load serving entity this tariff belongs to
        public	String	lseName {get; set;}	                //Name of the load serving entity
        public	String	serviceType {get; set;}	            //Type of service for the tariff. Current values include ELECTRICITY (grid power) and SOLAR_PV (Solar PPA or Lease)
        public	Long	priorTariffId {get; set;}	            //Unique Genability ID that identifies the prior revision of the tariffId above
        public	Long	distributionLseId {get; set;}	        //In states like Texas where the load serving entity that sells the power is different than the load serving entity that distributes the power, this will contain the ID of the distribution LSE. Otherwise, it will be null.
        public	String	tariffType {get; set;}	                //Possible values are: DEFAULT - tariff that is automatically given to this service class //ALTERNATE - opt in alternate tariff for this service class
                                                    //OPTIONAL_EXTRA - opt in extra, such as green power or a smart thermostat program
                                                    //RIDER - charge that can apply to multiple tariffs. Often a regulatory mandated charge
        public	String	customerClass {get; set;}	            //Possible values are: RESIDENTIAL - homes, apartments etc.
                                                    //GENERAL - commercial, industrial and other business and organization service types (often have additional applicability criteria)
                                                    //SPECIAL_USE - examples are government, agriculture, street lighting, transportation
        public	Integer	customerCount {get; set;}	            //Number of customers that are on this master tariff
        public	Decimal	customerLikelihood {get; set;}	        //The likelihood that a customer is on this tariff of all the tariffs in the search results. Only populated when getting more than one tariff.
        public	String	customerCountSource {get; set;}	    //Where we got the customer count numbers from. Typically FERC (form 1 filings) or Genability (our own estimates).
        public	String	territoryId {get; set;}	            //ID of the territory that this tariff applies to. This is typically the service area for the LSE in this regulatory region (i.e. a state in the USA)
        public	DateTime	effectiveDate {get; set;}	        //Date on which the tariff was or will be effective
        public	DateTime	endDate {get; set;}	            //Date on which this tariff is no longer effective. Can be null which means end date is not known or tariff is open ended
        public	Date	closedDate {get; set;}	                //Date on which a tariff became closed to new customers, but still available for customers who were on it at the time. Can be null which means that the tariff is not closed. All versions of a particular tariff (i.e. those that share a particular masterTariffId) will have the same closedDate value. See example
        public	String	timeZone {get; set;}	                //If populated (usually is), its the timezone that this tariffs dates and times refer to
        public	String	billingPeriod {get; set;}	            //The minimum chargePeriod present on this tariff.
        public	String	currency_x {get; set;}	                //ISO Currency code that the rates for this tariff refer to (e.g. USD for USA Dollar)
        public	String	chargeTypes {get; set;}	            //A comma separated list of all the different ChargeTyperates on this tariff.
        public	String	chargePeriod {get; set;}	            //The most fine grained period for which charges are calculated.
        public	Decimal	minMonthlyConsumption {get; set;}	    //When applicable, the maximum monthly consumption allowed in order to be eligible for this tariff.
        public	Decimal	maxMonthlyConsumption {get; set;}	    //When applicable, the minimum monthly consumption allowed in order to be eligible for this tariff.
        public	Decimal	minMonthlyDemand {get; set;}	        //When applicable, the maximum monthly demand allowed in order to be eligible for this tariff.
        public	Decimal	maxMonthlyDemand {get; set;}	        //When applicable, the minimum monthly demand allowed in order to be eligible for this tariff.
        public	Boolean	hasTimeOfUseRates {get; set;}	        //Indicates whether this tariff contains one or more Time of Use Rate.
        public	Boolean	hasTieredRates {get; set;}	            //Indicates whether this tariff contains one or more Tiered Rate.
        public	Boolean	hasContractedRates {get; set;}	        //Indicates whether this tariff contains one or more Rate that can be contracted (sometimes called by-passable or associated with a price to compare).
        public	Boolean	hasTariffApplicability {get; set;}	    //Indicates that this tariff has additional eligibility criteria, as specified in the TariffProperty collection (below).
        public	Boolean	hasRateApplicability {get; set;}	    //Indicates that one or more rates on this tariff are only applicable to customer with a particular circumstance. When true, this will be specified in the TariffPropertycollection, and also on the TariffRate or rates in question.
        public	Boolean	hasNetMetering {get; set;}	            //Indicates whether this tariff contains one or more net metered rates.
        //public	Boolean	isActive {get; set;}	                //DEPRECATED. Signifies that this tariff id is the currently active tariff (now) within all tariffs sharing this master tariff id. Instead, use the effective and end dates to test whether a tariff is active or not. If you're searching for tariffs, use effectiveOn instead.
        public	List<TariffProperty> properties {get; set;}	//The properties on this tariff. See below for the TariffProperty structure.
        //public	List<TariffRate> rates {get; set;}	            //The rates for this tariff. See below for TariffRatestructure
    }


    public class TariffProperty{
        public	String	keyName {get; set;}	    //Unique name for this property
        public	String	displayName {get; set;}	//The display name of this property
        public	String	keyspace {get; set;}	    //Top level categorization of the property hierarchy
        public	String	family {get; set;}	        //Second level categorization of the property hierarchy, below keyspace
        public	String	description {get; set;}	//A longer description of the tariff property. Good for further explanation as part of a customer "questionaire"
        public	String	dataType {get; set;}	    //The data type of this property. Possible values are string, choice, boolean, date, decimal, integer, formula
        public	String	propertyTypes {get; set;}	//The category of property. Possible values are APPLICABILITY, RATE_CRITERIA, BENEFIT, DATA_REPUTATION
        public	String	operator {get; set;}	    //The mathematical operator associated with this property's value, where applicable.
        public	String	propertyValue {get; set;}	//If applicable the specific value of this property.
        public	String	minValue {get; set;}	    //If applicable the minimum value of this property.
        public	String	maxValue {get; set;}	    //If applicable the maximum value of this property.
        //public	Array of Choices	choices {get; set;}	//The possible choices for this array
        public	String	formulaDetail {get; set;}	//If this property is a FORMULA type, the formula details will be in this field.
        public	Boolean	isDefault {get; set;}	    //Whether the value of this Property is the default value.
    }

    /*
    public class TariffRate{
        public	Long	tariffRateId {get; set;}	        //Unique Genability ID (primary key) for each tariff rate
        public	Long	tariffId {get; set;}	            //Associates the rate with a tariff (foreign key)
        public	Long	riderId {get; set;}	            //Populated when this is a rider attached to this tariff. nullotherwise
        public	Integer	tariffSequenceNumber {get; set;}	//Sequence of this rate in the tariff, for display purposes only (e.g. this is the order on the bill)
        public	String	rateGroupName {get; set;}	        //Name of the group this rate belongs to
        public	String	rateName {get; set;}	            //Name of this rate. Can be null (in which case use the group name)
        public	DateTime	fromDateTime {get; set;}	    //If populated, this indicates the rates effective date is not the same as that of its tariff
        public	DateTime	toDateTime {get; set;}	        //If populated, this indicates the rates end date is not the same as that of its tariff
        //public	Territory	territory {get; set;}	    //Only populated when this rate applies to a different region than the whole tariff (e.g. California Baseline Regions)
        //public	Season	season {get; set;}	            //The season this rate applies to. Only used for seasonal rates (null otherwise)
        //public	TimeOfUse	timeOfUse {get; set;}	    //The time period this rate applies to. Only used for TOU rates (null otherwise)
        public	String	chargeType {get; set;}	            //Possible values: FIXED_PRICE - a fixed charge for the periodCONSUMPTION_BASED - based on quantity used (e.g. kW/h)
                                                //DEMAND_BASED - based on the peak demand (e.g. kW) //QUANTITY - a rate per number of items (e.g. $5 per street light) //FORMULA - a rate that has a specific or custom formula
                                                //MINIMUM - a minimum amount that the LSE will charge you, regardless of the other charges //TAX - a percentage tax rate which is applied to the sum of all of the other charges on a bill
        public	String	chargeClass {get; set;}	        //A comma separated string that indicates what class(es) of charges this rate is for. Values include TRANSMISSION, DISTRIBUTION, SUPPLY, TAX, OTHER, CONTRACTED, USER_ADJUSTED, and AFTER_TAX.
        public	String	chargePeriod {get; set;}	        //Indicates what period this charge is calculated for. This is usually the same as the billing period (and is usually monthly) but can be other intervals. Possible values are:
                                                //MONTHLY - each calendar month //DAILY - calculated for each day //QUARTERLY - every 3 months //ANNUALLY - every year
        public	String	transactionType {get; set;}	    //Indicates whether this rate is BUY (no credit when supplying back), SELL (e.g. a feed in tariff), or NET (you get a credit, e.g. net metering).
        public	String	quantityKey {get; set;}	        //When not null, the property that defines the type of quantity this rate applies to.
        public	String	applicabilityKey {get; set;}	    //When not null, the property that defines the eligibility criteria for this rate.
        public	String	variableLimitKey {get; set;}	    //When populated this defines the variable which determines the upper limit(s) of this rate.
        public	String	variableRateKey {get; set;}	    //When not null, this is the name of the property that defines the variable rate. In this case the rate field is null, or can (rarely) be used as an input to the determination of the variable rate
        public	String	variableFactorKey {get; set;}	    //When not null, this is the name of the property that defines the variable factor to apply to this rate.
        public	List<TariffRateBand> rateBands {get; set;}	//See the data definition below
    }

    public class TariffRateBand{
        public Long	tariffRateBandId {get; set;}	        //Unique Genability ID (primary key) for each Band
        public Long	tariffRateId {get; set;}	            //ID of the rate this band belongs to (foreign key)
        public Integer	rateSequenceNumber {get; set;}	    //This bands position in the bands for its rate
        public Boolean	hasConsumptionLimit {get; set;}	//true indicates that this has banded consumption
        public Decimal	consumptionUpperLimit {get; set;}	//When hasConsumptionLimit is true, this indicates the upper consumption limit of this band. null means no upper limit
        public Boolean	hasDemandLimit {get; set;}	        //true indicates that this has banded demand
        public Decimal	demandUpperLimit {get; set;}	    //When hasDemandLimit is true, this indicates the upper demand limit of this band. null means no upper limit
        public Boolean	hasPropertyLimit {get; set;}	    //true indicates that this has a limit based on a property
        public Decimal	propertyUpperLimit {get; set;}	    //When hasPropertyLimit is true, this indicates the upper limit of this band. null means no upper limit
        public String	applicabilityValue {get; set;}	    //When not null, this indicates the value of applicability property that qualifies for this rate.
        public Decimal	calculationFactor {get; set;}	    //A factor to be applied to the cost of the rate.
        public Decimal	rateAmount {get; set;}	            //Charge amount for this band
        public String	rateUnit {get; set;}	            //Possible values:COST_PER_UNIT - rate amount multiplied by the number of units PERCENTAGE - percentage of a value (e.g. percentage of overall bill)"
        public Boolean	isCredit {get; set;}	            //When true this band is a credit amount (reduces the bill)
    }*/

}