/**
 * Created by cdevarapalli on 4/20/17.
 * JSON for Genability Usage Profile
 */

public class GenabilityUsageProfileJSON {

    public String status {get; set;}
    public Integer count {get; set;}
    public String type {get; set;}
    public List<UsageProfile> results {get; set;}

    public class UsageProfile{
        public  String  providerAccountId {get; set;}
        public  String  providerProfileId {get; set;}
        public  String	profileId {get; set;}	//Unique Genability ID (UUID) for this usage profile.
        public  String	profileName {get; set;}	//(Optional) Your specified name for this usage profile.
        public  String	accountId {get; set;}	//Required accountId for this usage profile. This is useful for linking usage profiles to your own customer Ids.
        public  String	description {get; set;}	//Optional description for this Usage Profile.
        public  String	serviceTypes {get; set;}	//Comma separated strings of the types of service this profile denotes. Current types include "ELECTRICITY"and "SOLAR_PV".
        public  Boolean	isDefault {get; set;}	//Denotes whether this is the default profile for the service type. Default profiles are used for calcs when no profile is specified.
        public  Integer	dataStatus {get; set;}	//Read-only value that Genability maintains to show how up-to-date the profile number crunching is. 1=processing, 2= done, 3=error (we auto-fix 3)
        public  String  sourceId {get; set;}
        //Source	source;	//Optional. Source contains a sourceId and name (both strings). Uniquely identify the source of this profile. e.g. "PVWatts"
        //Array of PropertyData	properties;	//Our standard collection of PropertyData denoting properties specific to this Profile.
        //Array of ReadingDataSummary	readingDataSummaries;	//See below for details of ReadingDataSummary.
        //Array of IntervalInfo Data	intervals;	//See below for details of IntervalInfo.
        public  List<ReadingData>   readingData;	//See below for details of ReadingData.
        //Array of BaselineMeasure	baselineMeasures;	//(Optional) For estimated solar production, your profile doesn't necessarily have to correspond to a particular year. You can use this field to input an array of generic datapoints corresponding to the hours of a year rather than specific dates.
    }

    public class ReadingData{
        String keyName {get; set;}
        String fromDateTime {get; set;}
        String toDateTime {get; set;}
        String quantityUnit {get; set;}
        Decimal quantityValue {get; set;}

        public ReadingData( String skeyName,
                            String dtfromDateTime,
                            String dttoDateTime,
                            String squantityUnit,
                            Decimal dquantityValue){
            keyName = skeyName;
            fromDateTime = dtfromDateTime;
            toDateTime = dttoDateTime;
            quantityUnit = squantityUnit;
            quantityValue = dquantityValue;
        }
    }
}