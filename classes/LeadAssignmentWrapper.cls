public with sharing class LeadAssignmentWrapper{
	
	public GeocodeAsyncHandler.GeoInfo GeoInfo {get;set;}
	public Lead lead {get;set;}
	public Integer CompetingColour {get;set;}
	public Boolean isValid {get;set;}
	public Boolean isSPD {get;set;}
	public Campaign campaign{get;set;}
	public Boolean bIscampaign {get;set;}
    public boolean bIsLeadQualificationCampaign 
    {
    	get
    	{	
    		if(bIsLeadQualificationCampaign == null)
    			bIsLeadQualificationCampaign = false;
    		return bIsLeadQualificationCampaign;	
    	}set;
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
    public boolean blnNewHomeCampaign 
    {
    	get
    	{	
    		if(blnNewHomeCampaign == null)
    			blnNewHomeCampaign = false;
    		return blnNewHomeCampaign;	
    	}set;
    }
    public Boolean isWarmTransfer {
        get {
            if(isWarmTransfer == null)
                isWarmTransfer = false;
            return isWarmTransfer;
        } set;
    }
    public String ldState {get;set;}
	public String ldStreet {get;set;}
	public String ldPhone {get;set;}
	public String ldMobile {get;set;}
	public String ldEmail {get;set;}
    public Set<Id> campaignPartnerIds {get;set;}
    public String five9ListName {get;set;}
   // public Set<Id> campaignpartners {get;set;}
	public Lead_Dealer_Assignment_Audit__c objAuditAssign{
		get{
			 if(objAuditAssign == null)
			 	objAuditAssign = new Lead_Dealer_Assignment_Audit__c();
			 return objAuditAssign;	
		}set;
	}
	
	public list<Lead_Eligible_Dealers__c> lstEligible_Dealers{
		get{
			if(lstEligible_Dealers == null)
				lstEligible_Dealers = new list<Lead_Eligible_Dealers__c>();
			return lstEligible_Dealers;	
		}set;
	}
	
	public list<DealerResult> listDealers{
		get{
			if(listDealers == null)
				listDealers = new list<DealerResult>();
			return listDealers;	
		}set;
	}
	
	public list<Dealer_Notification__c> lstDealerNotification{
		get{
			if(lstDealerNotification == null)
				lstDealerNotification = new list<Dealer_Notification__c>();
			return lstDealerNotification;	
		}set;
	}
}