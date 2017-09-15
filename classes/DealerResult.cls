global class DealerResult implements Comparable {

    public enum SortField {Distance, Score, Type}
    public enum SortDirection {ASCENDING, DESCENDING}
    
    public static SortDirection SORT_DIR = SortDirection.DESCENDING;
    public static SortField SORT_FIELD = SortField.Score;
     
    public String AccountId {get; set;}
    public String AccountName {get; set;}
    public String AccountDisplayName {get; set;}//Added by Chakri
    public String PartnerLogo {get; set;}//Added by Chakri
    public String Type {get; set;}
    public Decimal Lat {get; set;}
    public Decimal Lon {get; set;}
    public Decimal Distance {get; set;}
    public Decimal Score {get; set;}
    public String DealerLocatorPhone {get; set;}
    public String Phone {get; set;}
    public String Street {get; set;}
    public String City {get; set;}
    public String State {get; set;}
    public String Country {get; set;}
    public String PostalCode {get; set;}
    public String Website {get; set;}
    public String OracleAccountNumber {get; set;}
    public String Description {get; set;}
    public String PartnerFacts {get; set;}
    public Boolean AllianceProgramPartner {get; set;}    
    public String OpportunityRecipient {get; set;}
    public Boolean DealerLocatorOptOut {get; set;}     
    public Boolean LeadFlowOptOut {get; set;}
    public String rsmID {get;set;} //Added by Chakri 00664359
    public String rsmName {get;set;} //Added by Chakri 00664359

    public Boolean isCampaignPartner {
        get {
            if(isCampaignPartner == null)
                isCampaignPartner = false;
            return isCampaignPartner;
        }
        set;
    }
    public Boolean isAllianceCampaignPartner {
        get {
            if(isAllianceCampaignPartner == null)
                isAllianceCampaignPartner = false;
            return isAllianceCampaignPartner;
        }
        set;
    }
    public Boolean isWarmTransferPartner {
        get {
            if(isWarmTransferPartner == null)
                isWarmTransferPartner = false;
            return isWarmTransferPartner;
        }
        set;
    }
    
    public boolean bIsExclusiveCampaign 
    {
        get
        {   
            if(bIsExclusiveCampaign == null)
                bIsExclusiveCampaign = false;
            return bIsExclusiveCampaign;    
        }set;
    }

    public DealerResult(String accountId, String accountName,String type, Decimal lat, Decimal lon, Decimal distance, Decimal score, 
                                String DealerLocatorPhone, String Phone, String Street, String City, String State, String Country, 
                                String PostalCode, String Website, String OracleAccountNumber, String Description, String PartnerFacts, 
                                Boolean AllianceProgramPartner, String OpportunityRecipient, Boolean DealerLocatorOptOut, Boolean LeadFlowOptOut)
    {
        this.AccountId = accountId;
        this.AccountName = accountName;
        this.type = type;
        this.Lat = lat;
        this.Lon = lon;
        this.Distance = distance;
        this.Score = score;        
        this.DealerLocatorPhone  = DealerLocatorPhone;
        this.Phone = Phone;
        this.Street = Street;
        this.City = City;
        this.State = State;
        this.Country = Country;
        this.PostalCode = PostalCode;
        this.Website = Website;
        this.OracleAccountNumber = OracleAccountNumber;
        this.Description = Description;
        this.PartnerFacts = PartnerFacts;
        this.AllianceProgramPartner  = AllianceProgramPartner;
        this.OpportunityRecipient = OpportunityRecipient;
        this.DealerLocatorOptOut = DealerLocatorOptOut;
        this.LeadFlowOptOut  = LeadFlowOptOut;
    }
                
    global Integer compareTo(object other)
    {
        if (SORT_FIELD == SortField.Distance)
        {return compareToDistance(other);}
        else if (SORT_FIELD == SortField.Score)
        {return compareToScore(other);}
        else if (SORT_FIELD == SortField.Type)
        {return compareToType(other);}
        else return 0;
        
    }
    
    Integer compareToDistance(Object other)
    {
        Decimal otherDistance = other != null ? ((DealerResult)other).Distance : 0;   
        if (SORT_DIR == SortDirection.ASCENDING)    
            return Integer.valueOf( 1000000*(this.Distance - otherDistance));
        else
            return Integer.valueOf( 1000000*(otherDistance - this.Distance));   
    }
    
    Integer compareToScore(Object other)
    {
        Decimal otherScore = other != null ? ((DealerResult)other).Score : 0;  
        otherScore  = otherScore  != null ? otherScore  : 0; 
        this.Score = this.Score != null ? this.Score : 0;
        
        //System.debug('@@@@@DealerResult.compareToScore: otherScore : '+otherScore );
        //System.debug('@@@@@DealerResult.compareToScore: Score : '+Score );
        
        if (SORT_DIR == SortDirection.ASCENDING)    
            return Integer.valueOf( 1*(this.Score - otherScore));
        else
            return Integer.valueOf( 1*(otherScore - this.Score));   
    }
    
    Integer compareToType(Object other)
    {
        String otherType = other != null ? ((DealerResult)other).Type : '';   
        if (SORT_DIR == SortDirection.ASCENDING)     
            return this.Type.compareTo(otherType);   
        else
            return otherType.compareTo(this.Type);
    }   
}