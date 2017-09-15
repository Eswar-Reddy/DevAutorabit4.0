public class PuchaseOrderDealerShipAddController{
	//Variable for Ship_To_Site__C object 
	Public Ship_To_Site__C shipToSite {get; set;}
	//Boolean variable to set whether Ship_To_Site in inserted or not
	public boolean isSucceeded{get;set;}
	//Variable for recordType parameter
	public String recParam{get;set;}
	//Variable for address_unique_id in Ship_To_Site__C object
	public String uniqueAddressKey{get;set;}
	//variable for dealer account type
	public String dealerAccType{get;set;}
	
	/** Constructor PuchaseOrderDealerShipAddController.
	 *  @param ApexPages.standardController
	 */
	public PuchaseOrderDealerShipAddController(ApexPages.standardController std){
	    uniqueAddressKey = '';
	    isSucceeded =false;
	    shipToSite = new Ship_To_Site__C();
	    Map<String,ID> recTypes = new Map<String,ID>();
	    //Set record type
	    for (RecordType rec : [Select id,name,developerName from RecordType where sObjectType='Ship_To_Site__C']){
	        recTypes.put(rec.developerName,rec.ID);
	    }
	    //Set the fields of shipToSite according to dealer account
	    if(ApexPages.currentPage().getParameters().get('dealerAccountID')!=null){
	        if(ApexPages.currentPage().getParameters().get('recType')!=null){
	            recParam =ApexPages.currentPage().getParameters().get('recType');
	            if(recParam != null && recParam == 'WARE'){
	                shipToSite.RecordTypeID = recTypes.get('Dealer_Warehouse');
	                shipToSite.Type__c ='Dealer Warehouse';
	            }
	            else if(recParam != null && recParam == 'RESI'){
	                shipToSite.RecordTypeID = recTypes.get('Installation_Site');
	                shipToSite.Type__c ='Residential Customer';
	            }
	            else if(recParam != null && recParam == 'OPPT'){
	                shipToSite.RecordTypeID = recTypes.get('Opportunity');
	                shipToSite.Type__c ='Residential Customer';
	            }
	        }
	               
	        shipToSite.Dealer_Account__c = ApexPages.currentPage().getParameters().get('dealerAccountID');
	        Account acc = [Select id,ShippingStreet,ShippingState,ShippingCountry,ShippingPostalCode,ShippingCity,Type from Account where id=:shipToSite.Dealer_Account__c limit 1];
	        // setting type of dealer account whether it is Residential Installer or any other type
	        // if it is of Residential Installer then dont display the field Residential_Customer_Account__c
	        dealerAccType = acc.Type;
	        shipToSite.Address1__c = acc.ShippingStreet;
	        shipToSite.State__c = acc.ShippingState;
	        shipToSite.Country__c = acc.ShippingCountry;
	        shipToSite.Zip__c = acc.ShippingPostalCode;
	        shipToSite.city__c = acc.ShippingCity;
	    }
	    if(ApexPages.currentPage().getParameters().get('oppId')!=null){
	        String oppID= ApexPages.currentPage().getParameters().get('oppId');
	        for(Opportunity opp:[select accountId from Opportunity where id =:oppId and AccountID != null Limit 1])
	        	shipToSite.Residential_Customer_Account__c =opp.AccountID; 
	    }
	}
	
   /** Action Function to save ship to site object.
    *  
    */
    public PageReference saveShipToSite(){
        //if(shipToSite.SiteID__c == null)
        //  shipToSite.SiteID__c = String.valueOf(DateTime.now()).subString(3);
        uniqueAddressKey = shipToSite.Address1__c == null ?  '' :shipToSite.Address1__c;
        uniqueAddressKey = uniqueAddressKey + (shipToSite.Address2__c == null ? '' :shipToSite.Address2__c);
        uniqueAddressKey = uniqueAddressKey + (shipToSite.Address3__c == null ? '': shipToSite.Address3__c);
        uniqueAddressKey = uniqueAddressKey + (shipToSite.City__c == null ? '' : shipToSite.City__c);
        uniqueAddressKey = uniqueAddressKey + (shipToSite.State__c == null ? '' : shipToSite.State__c);
        uniqueAddressKey = uniqueAddressKey + (shipToSite.Zip__c == null ? '' : shipToSite.Zip__c);
        uniqueAddressKey = uniqueAddressKey + (shipToSite.Country__c == null ? '' : shipToSite.Country__c);                         
        List<Ship_to_Site__c> lst = [Select Id from Ship_to_Site__c where Address_Unique_ID__c like :uniqueAddressKey LIMIT 1]; 
        if(lst!= null && lst.size() > 0){
             ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.POWizardErrorMsgDuplicateShipSite);
             ApexPages.addMessage(errorMsg);
        }else{
        	try{
            	insert shipToSite;
        	}catch(Exception e){
        		//ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error');
             	//ApexPages.addMessage(errorMsg);
             	return null;
        	}
            isSucceeded =true;
        }        
        return null;
    }
	     
   /** Fetching contacts for the field Attention__c from Dealer Account.
    *  @return List<SelectOption>
    */
    public List<SelectOption> getAttentionContacts(){
        List<SelectOption> options = new List<SelectOption>();      
        //SelectOption opt1 = new SelectOption('','--None--');
        //options.add(opt1);
        for(Contact con : [Select Id, Name from Contact where AccountId =:shipToSite.Dealer_Account__c LIMIT 1000]){
            SelectOption opt = new SelectOption(con.Id, con.Name);
            options.add(opt);
        }
        return options;
   } 
}