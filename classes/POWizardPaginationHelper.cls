public class POWizardPaginationHelper {
	
	//Variable standard set controller for pagination of opportunities
    public ApexPages.StandardSetController setCon{get;set;}
    public List<Opportunity> oppList{get;set;}
   
    
    public Map<String,Integer> getOppList(String accid,Boolean isNAUser,integer PAGINATION_COUNTER_OPPLIST,integer PAGINATION_COUNTERONPAGE_OPPLIST){
    	Map<String,Integer> retArgs = new Map<String,Integer>();
    	String qry1='';
    	if(isNAUser)
	    	qry1 = 'select id,accountID,StageName, Description, Probability, Name, CloseDate, Amount,Owner.Contact.AccountID,Account.BillingCity,Account.BillingState,Account.BillingCountry,Account.BillingStreet,Account.BillingPostalCode,Account.ShippingCity,Account.ShippingState,Account.ShippingCountry,Account.ShippingStreet,Account.ShippingPostalCode  From Opportunity where Partner_Account_Id__c = :accid and Opportunity_Status__c =\'Closed Won\' and type= \'Residential\' and accountID != null and partnerAccountId != null'; //Owner.Contact.AccountID
    	else
    		qry1 = 'select id,accountID,StageName, Description, Probability, Name, CloseDate, Amount,Owner.Contact.AccountID,Account.BillingCity,Account.BillingState,Account.BillingCountry,Account.BillingStreet,Account.BillingPostalCode,Account.ShippingCity,Account.ShippingState,Account.ShippingCountry,Account.ShippingStreet,Account.ShippingPostalCode  From Opportunity where Owner.Contact.AccountID = :accid';
		//String qry = 'Select StageName,Probability,Name,Id,Description,CloseDate,Amount From Opportunity  where AccountId ='+ accid+' limit 1000';	
			
			System.debug('accid ==>'+accid);
			System.debug('query :'+qry1);
			setCon = new ApexPages.StandardSetController(Database.getQueryLocator(qry1));
			if(setCon != null){
                if(setCon.getResultSize() != 0){
                	if(setCon.getResultSize() <= (PAGINATION_COUNTERONPAGE_OPPLIST+PAGINATION_COUNTER_OPPLIST))
            			PAGINATION_COUNTERONPAGE_OPPLIST = setCon.getResultSize() - PAGINATION_COUNTER_OPPLIST;
            		else
            			PAGINATION_COUNTERONPAGE_OPPLIST = PAGINATION_COUNTER_OPPLIST;
                    setCon.setPageSize(PAGINATION_COUNTER_OPPLIST);
                }
          }
		//setCon.setPageSize(10);
			retArgs.put('PAGINATION_COUNTER_OPPLIST',PAGINATION_COUNTER_OPPLIST);
			retArgs.put('PAGINATION_COUNTERONPAGE_OPPLIST',PAGINATION_COUNTERONPAGE_OPPLIST);
			return retArgs;
    }
    
    public Integer getOppCount(String accid){
    	
		/*Integer size = [Select count() From Opportunity  where Owner.Contact.AccountID =: accid];	
		System.debug('size :'+size);
		return size;*/
		return 1;
    }
    
    
    public Map<String,Integer> getOppListSearched(String accid,String searchText,Boolean isNAUser,integer PAGINATION_COUNTER_OPPLIST,integer PAGINATION_COUNTERONPAGE_OPPLIST){
		Map<String,Integer> retArgs = new Map<String,Integer>();  
        String queryName = '\'%' + searchText + '%\'';
		//String qry = 'Select StageName,Probability,Name,Id,Description,CloseDate,Amount From Opportunity  where AccountId ='+ accid +' and Name like '+queryName.trim()+'';
		String qry1='';
		if(isNAUser)
			qry1 = 'select id,accountID,StageName, Description, Probability, Name, CloseDate, Amount,Owner.Contact.AccountID,Account.BillingCity,Account.BillingState,Account.BillingCountry,Account.BillingStreet,Account.BillingPostalCode,Account.ShippingCity,Account.ShippingState,Account.ShippingCountry,Account.ShippingStreet,Account.ShippingPostalCode  From Opportunity where Owner.Contact.AccountID = :accid and Opportunity_Status__c =\'Closed Won\' and type= \'Residential\' and accountID != null and partnerAccountId != null and Name like '+queryName.trim()+'';
		else
			qry1 = 'select id,accountID,StageName, Description, Probability, Name, CloseDate, Amount,Owner.Contact.AccountID,Account.BillingCity,Account.BillingState,Account.BillingCountry,Account.BillingStreet,Account.BillingPostalCode,Account.ShippingCity,Account.ShippingState,Account.ShippingCountry,Account.ShippingStreet,Account.ShippingPostalCode  From Opportunity where Owner.Contact.AccountID = :accid and Name like '+queryName.trim()+'';	
		System.debug('query :'+qry1);
		setCon = new ApexPages.StandardSetController(Database.getQueryLocator(qry1));
		if(setCon != null){
                if(setCon.getResultSize() != 0){
                	if(setCon.getResultSize() <= (PAGINATION_COUNTERONPAGE_OPPLIST+PAGINATION_COUNTER_OPPLIST))
            			PAGINATION_COUNTERONPAGE_OPPLIST = setCon.getResultSize() - PAGINATION_COUNTER_OPPLIST;
            		else
            			PAGINATION_COUNTERONPAGE_OPPLIST = PAGINATION_COUNTER_OPPLIST;
                    setCon.setPageSize(PAGINATION_COUNTER_OPPLIST);
                }
          }
		//setCon.setPageSize(10);
			retArgs.put('PAGINATION_COUNTER_OPPLIST',PAGINATION_COUNTER_OPPLIST);
			retArgs.put('PAGINATION_COUNTERONPAGE_OPPLIST',PAGINATION_COUNTERONPAGE_OPPLIST);
		return retArgs;
    	
    }
		
	/** This function is responsible to navigate to first set of records in pagination.
     *  @return  PageReference
     */
    public void moveFirst(){
        if(setCon != null)
            setCon.first();
       
    }
    
    /** This function is responsible to navigate to next set of records in pagination.
     *  @return  PageReference
     */
    public void moveNext(){
        if(setCon != null)
            setCon.next();
      
    }
    
    /** This function is responsible to navigate to last set of records in pagination.
     *  @return  PageReference
     */
    public void moveLast(){
        if(setCon != null)
            setCon.last();
      
    }
    
    /** This function is responsible to navigate to previous set of records in pagination.
     *  @return  PageReference
     */
    public void movePrevious(){
        if(setCon != null)
            setCon.previous();
       
    }
    
    public List<Opportunity> getOpportunityList(){
		
        if(setCon == null){ 
         
            //initilizeSetCon();  
        }
        if(setCon != null) {
            
            if(setCon.getResultSize() != 0)
                oppList = (List<Opportunity>) setCon.getRecords();
            else
                oppList = new List<Opportunity>();
           
            return oppList;
        }
       
        return null;
	}
    

}