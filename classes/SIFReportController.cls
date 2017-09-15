// ************************************************************/
// Name : SIFReportController 
// Created On : 16 Dec 2010
// Created By : Jitendra Kothari
// Updated On : 1 Feb 2011(Case # 00054918)
// Updated By : Jitendra Kothari
// Implementation: Controller class for SIF Report Page.
//  This Page has been implemented under case : 
// ***** *******************************************************/
public class SIFReportController {
	public List<SIFReport> listSite{get;set;}
	public Site_Information_Form__c sumSiteLand{get;set;}
	public String selectQuery{get;set;}
	public String query{get;set;}		
	public String tableQuery{get;set;}
	public String whereQuery{get;set;}
	public String orderQuery{get;set;}
	public Integer countSite{get;set;}
	public List<SelectOption> listBusiUnits{get;set;}
	public List<SelectOption> listRegion{get;set;}
	public List<SelectOption> listSubRegion{get;set;}
	public List<SelectOption> listSalesStage{get;set;}
	public List<SelectOption> listSiteStatus{get;set;}
	public List<String> busiUnits{get;set;}
	public List<String> regions{get;set;}
	public List<String> subRegions{get;set;}
	public List<String> salesStages{get;set;}
	public List<String> sitestatus{get;set;}
	public String showbusiUnits{get;set;}
	public String showregions{get;set;}
	public String showsubRegions{get;set;}
	public String showsalesStages{get;set;}
	public String showsitestatus{get;set;}
	public String message{get;set;}
	public String message1{get;set;}
	public String message2{get;set;}
	public Boolean show{get;set;}
	public Boolean isAllowed{get;set;}
	public String currentUserEmail{ get; set;}
  	public String sendEmailToUser {get; set;}
  	public String MAIL_SUBJECT {get;set;}
  	public String strEmailDealerCC{get;set;}
  	public String strEmailDealerBcc{get;set;}
  	public String strEmailBody{get;set;}
  	public Boolean isClosed { get; set;}
	//constructor
  	public SIFReportController() {
  		this.sitestatus =new List<String>{'Comm. Letter signed', 'Optioned', 'On hold'};
  		this.show = false;  				
  		System.debug(loggingLevel.INFO,'In Constructor');
  		getPickListValues();
  		this.showbusiUnits = '';
  		this.showregions = '';  
  		this.showsubRegions = '';  
  		this.showsalesStages = '';  
  		this.showsitestatus = '';
  		this.message2 = '';    	
  		currentUserEmail = Userinfo.getUserName();
  		MAIL_SUBJECT ='SIF Report';
  		strEmailBody = 'Please find the SIF Report attached as a PDF format here with this email.' ;
  		List<GroupMember> memberList = [Select UserOrGroupId, Group.Name From GroupMember where Group.Name = 'SunRay Report Users' and Group.Type='Regular' and UserOrGroupId = :Userinfo.getUserId() limit 1];
  		if(memberList.size()>0){  			
  			if(memberList.get(0).UserOrGroupId == Userinfo.getUserId())
  				this.isAllowed = true;
  		}else{
  			List<User> userList = [Select Profile.Name, Email, UserName From User where Id = :Userinfo.getUserId()];
  			if(userList.size()>0){
  				currentUserEmail = userList.get(0).Email;	  			
  				if(userList.get(0).Profile.Name == 'System Administrator')
  					this.isAllowed = true;
  			}
  			System.debug(loggingLevel.INFO,'User Id->'+Userinfo.getUserId());
  		}		  		 		    		
  	}
  	
  	public void prepareQueryResult(String orderByClause){
  		//updated for case # 00054918 & 00056915
  		selectQuery ='Select Id, Name, Notary_Option_Signed_On__c, Site_Name__c, Customer_Contact__c, Price_per_Acre__c'+  		
  				', Customer_Contact__r.Name, RecordTypeId, Land_size_ha__c, Notary_Option_Expiry_Date__c, Site_City__c'+
  				', Site_Status__c, Available_Space__c, Commercial_Letter_Signed__c, Commercial_Letter_Expiry_Date__c'+
  				', Own_Lease_Site__c, Opportunity_del__r.Sub_Region__c,  Opportunity_del__r.StageName'+
  				', Opportunity_del__r.Price_per_HA__c, Opportunity_del__r.Name, Opportunity_del__c';
  		//updated for case # 00054918 & 00056915
  		tableQuery = ' From Site_Information_Form__c';
  		whereQuery = ' Where RecordType.Name =\'Standard Site\' and Opportunity_del__r.RecordType.Name = \'Development\'';
  		
  		if(busiUnits!=null && busiUnits.size()>0){
  			this.showbusiUnits = getInString(busiUnits);  			  
  			whereQuery = whereQuery + ' and Opportunity_del__r.Business_Unit__c in ('+this.showbusiUnits+')';  			
  		}
  		if(regions!=null && regions.size()>0){
  			this.showregions = getInString(regions);
  			//Case#00063588 replaced Region1__c with Country__c
  			whereQuery = whereQuery + ' and Opportunity_del__r.Country__c in ('+this.showregions+')';
  		}
  		if(subRegions!=null && subRegions.size()>0){
  			this.showsubRegions = getInString(subRegions);
  			whereQuery = whereQuery + ' and Opportunity_del__r.Sub_Region__c in ('+this.showsubRegions+')';
  		}
  		if(salesStages!=null && salesStages.size()>0){
  			this.showsalesStages = getInString(salesStages);
  			whereQuery = whereQuery + ' and Opportunity_del__r.StageName in ('+this.showsalesStages+')';
  		}
  		if(sitestatus!=null && sitestatus.size()>0){
  			this.showsitestatus = getInString(sitestatus);
  			whereQuery = whereQuery + ' and Site_Status__c in ('+this.showsitestatus+')';
  		}
  		if(orderByClause==null)//Case#00063588 replaced Region1__c with Country__c
  			orderByClause = ' Opportunity_del__r.Sub_Region__c, Opportunity_del__r.Country__c, Opportunity_del__r.StageName,Site_Status__c, Name Asc'; 		
  		
  		orderQuery = ' Order by ' + orderByClause + ' Limit '+ Limits.getLimitQueryRows();
  		query = selectQuery + tableQuery + whereQuery + orderQuery;
  		System.debug(loggingLevel.INFO,query);
  		this.listSite = new List<SIFReport>();
  		List<Site_Information_Form__c> listSite1;  			
  		try{
  			listSite1 = Database.query(query);  		
	  		Integer i = 1;
	  		Decimal reg_space = 0.0;
	  		String region = '';
	  		this.sumSiteLand = new Site_Information_Form__c(Land_size_ha__c = 0);
	  		for(Site_Information_Form__c site : listSite1){
	  			//this is done for reporting purpose only - will have the value of Id
	  			if(site.Land_size_ha__c!=null)
                    this.sumSiteLand.Land_size_ha__c = this.sumSiteLand.Land_size_ha__c + site.Land_size_ha__c;
                
	  			//site.Confirmed_design_wind_speed__c = i;//for case # 00057573
	  			//i++;//for case # 00057573
	  			Integer dayBwTodayAndNOSODate = 0;
	  			Integer dayBwTodayAndCLSDate = 0;	  			
	  			if(site.Notary_Option_Signed_On__c!=null){
	  				dayBwTodayAndNOSODate = System.today().daysBetween(site.Notary_Option_Signed_On__c);
	  			}
	  			if(site.Commercial_Letter_Signed__c!=null){
	  				dayBwTodayAndCLSDate = System.today().daysBetween(site.Commercial_Letter_Signed__c);
	  			}
	  			//for case # 00054918
	  			Integer dayBwTodayAndNOEODate = 0;
	  			Integer dayBwTodayAndCLEDate = 0;
	  			if(site.Notary_Option_Expiry_Date__c!=null){
	  				dayBwTodayAndNOEODate = System.today().daysBetween(site.Notary_Option_Expiry_Date__c);
	  			}
	  			if(site.Commercial_Letter_Expiry_Date__c!=null){
	  				dayBwTodayAndCLEDate = System.today().daysBetween(site.Commercial_Letter_Expiry_Date__c);
	  			}
	  			//for case # 00054918
	  			if(site.Site_Status__c == 'Comm. Letter signed'){
	  				//this is done for reporting purpose only - will have the value of Signed
	  				site.Lease_Expiration_Date__c =  dayBwTodayAndCLSDate < dayBwTodayAndNOSODate ? site.Commercial_Letter_Signed__c : site.Notary_Option_Signed_On__c;
	  				//this is done for reporting purpose only - will have the value of Expires
	  				//for case # 00054918
	  				//site.Neighbors_Preemption_Right__c =  dayBwTodayAndCLSDate > dayBwTodayAndNOSODate ? site.Commercial_Letter_Signed__c : site.Notary_Option_Signed_On__c;
	  				site.Neighbors_Preemption_Right__c =  site.Commercial_Letter_Expiry_Date__c;
	  				/*site.Neighbors_Preemption_Right__c =  dayBwTodayAndCLSDate > dayBwTodayAndNOEODate ? site.Commercial_Letter_Signed__c : site.Notary_Option_Expiry_Date__c;
	  				if(site.Neighbors_Preemption_Right__c==null)
	  					site.Neighbors_Preemption_Right__c = site.Commercial_Letter_Signed__c;*/
	  				//for case # 00054918
	  				//this is done for reporting purpose only - will have the value of Expires color
	  				site.Cause_of_Shading__c = 'blue';  				
	  			}else if(site.Site_Status__c == 'Optioned'){
	  				//this is done for reporting purpose only - will have the value of Signed
	  				site.Lease_Expiration_Date__c =   site.Notary_Option_Signed_On__c;
	  				//this is done for reporting purpose only - will have the value of Expires
	  				//for case # 00054918
	  				//site.Neighbors_Preemption_Right__c =  site.Notary_Option_Signed_On__c;
	  				site.Neighbors_Preemption_Right__c =  site.Notary_Option_Expiry_Date__c;
	  				//for case # 00054918
	  				//this is done for reporting purpose only - will have the value of Expires color
	  				site.Cause_of_Shading__c = 'red';
	  			}
	  			if((site.Site_Status__c == 'Comm. Letter signed' || site.Site_Status__c == 'Optioned') 
	  				&& site.Neighbors_Preemption_Right__c!=null)
	  				site.Cause_of_Shading__c = colorSetter(site.Neighbors_Preemption_Right__c, System.today(), 'blue', 'red'); 			
	  			//this is done for reporting purpose only - will have the value of Land Notorized
	  			if(site.Notary_Option_Signed_On__c!=null && site.Site_Status__c != 'Comm. Letter signed'){  				
	  				site.Notary_Option_Signed_On__c = null;
	  				//this is done for reporting purpose only - will have the value of Land Notorized color
	  				site.Comment_Box__c = 'red';
	  			}else{
	  				//this is done for reporting purpose only - will have the value of Land Notorized color
	  				site.Comment_Box__c = 'blue';
	  			}
	  			SIFReport sf = new SIFReport(site);
	  			if(site.Opportunity_del__r.Sub_Region__c!=null)
	  				sf.sortOrder = site.Opportunity_del__r.Sub_Region__c;//for case # 00057573
	  			else
	  				sf.sortOrder = '';
	  			if(site.Neighbors_Preemption_Right__c!=null)
	  				sf.sortOrder = sf.sortOrder + site.Neighbors_Preemption_Right__c;//for case # 00057573
	  			else 
	  				sf.sortOrder = sf.sortOrder + '';//for case # 00057573
	  			System.debug(loggingLevel.INFO,'Sorting order ' + sf.sortOrder);//for case # 00057573
	  			if(region == ''){
	  				region = site.Opportunity_del__r.Sub_Region__c;	  				
	  			}else if(region != site.Opportunity_del__r.Sub_Region__c){
	  				SIFReport sf1 = new SIFReport(new Site_Information_Form__c());
		  			sf1.show = false;
			  		sf1.innerSite.Land_size_ha__c = reg_space;
			  		sf1.innerSite.Site_City__c = region;
			  		if(region!=null)
			  			sf1.sortOrder = region + '99';//for case # 00057573
			  		else
			  			sf1.sortOrder = '99';//for case # 00057573
	  				System.debug(loggingLevel.INFO,'Sorting order ' + sf1.sortOrder);//for case # 00057573
	  				this.listSite.add(sf1);
	  				//System.debug(loggingLevel.INFO,'Total by '+region+' ->'+reg_space);
	  				reg_space = 0.0;
	  				region = site.Opportunity_del__r.Sub_Region__c;
	  			}
	  			if(site.Land_size_ha__c!=null){
	  				reg_space = reg_space + site.Land_size_ha__c;
	  			}
	  			this.listSite.add(sf);
	  		}
	  		
	  		this.countSite = listSite1.size();
	  		
	  		if(this.countSite!=0){
	  			this.message = '';	  			
	  			SIFReport sf = new SIFReport(new Site_Information_Form__c());
	  			sf.show = false;
		  		sf.innerSite.Land_size_ha__c = reg_space;
		  		sf.innerSite.Site_City__c = region;
		  		if(region!=null)
			  		sf.sortOrder = region + '99';//for case # 00057573
			  	else
			  		sf.sortOrder = '99';//for case # 00057573
	  			System.debug(loggingLevel.INFO,'Sorting order ' + sf.sortOrder);//for case # 00057573	  			
		  		this.listSite.add(sf);
		  		getSortedSIF();//for case # 00057573
		  		//System.debug(loggingLevel.INFO,'Total by '+region+' ->'+reg_space);
	  		}
	  		else 
	  			this.message = 'No Record found......';
  		}catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,e.getMessage()));
        }  
  	}
  	//start for case # 00057573
  	public void getSortedSIF(){
  		for(Integer index =0 ;index<listSite.size();index++){
        	for(Integer nextIndex = index+1; nextIndex < listSite.size();nextIndex++){
            	if(listSite[index].sortOrder > listSite[nextIndex].sortOrder){ 
                    	SIFReport tmp = listSite[index];   
                        listSite.set(index,listSite[nextIndex]);
                        listSite.set(nextIndex,tmp);
                }                
            }         
        }//for ends
  	}
  	//end for case # 00057573
  	public void getPickListValues(){
  		SelectOption selopt;
  		
  		listBusiUnits = new List<SelectOption>();
  		listRegion = new List<SelectOption>();
  		listSubRegion = new List<SelectOption>();
  		listSalesStage = new List<SelectOption>();
  		listSiteStatus = new List<SelectOption>();
  		
  		//fetch picklist values for business unit
  		Schema.DescribeFieldResult F = Opportunity.Business_Unit__c.getDescribe();
    	List<Schema.PicklistEntry> P = F.getPicklistValues();
    	for(Schema.PicklistEntry entry : P){      
      		if(entry.isActive()){
      			selopt =  new SelectOption(entry.getValue(), entry.getLabel());      		 
      			listBusiUnits.add(selopt);
      		} 
    	}
    	
    	//Case#00063588 replaced Region1__c with Country__c
    	//fetch picklist values for region
    	F = Opportunity.Country__c.getDescribe();
    	P = F.getPicklistValues();
    	for(Schema.PicklistEntry entry : P){      
      		if(entry.isActive()){
	      		selopt =  new SelectOption(entry.getValue(), entry.getLabel());      		 
	      		listRegion.add(selopt);
      		} 
    	}
    	
    	//fetch picklist values for sub region
    	F = Opportunity.Sub_Region__c.getDescribe();
    	P = F.getPicklistValues();
    	for(Schema.PicklistEntry entry : P){
    		if(entry.isActive()){      
      			selopt =  new SelectOption(entry.getValue(), entry.getLabel());      		 
      			listSubRegion.add(selopt);
    		}  
    	}
    	
    	//fetch picklist values for sales stage
    	F = Opportunity.StageName.getDescribe();
    	P = F.getPicklistValues();
    	for(Schema.PicklistEntry entry : P){
    		if(entry.isActive() && accept(entry)){      
      			selopt =  new SelectOption(entry.getValue(), entry.getLabel());      		 
      			listSalesStage.add(selopt);
    		} 
    	}
    	
    	//fetch picklist values for Site Status
    	F = Site_Information_Form__c.Site_Status__c.getDescribe();    	
    	P = F.getPicklistValues();
    	for(Schema.PicklistEntry entry : P){  
    		if(entry.isActive()){  		
      			selopt =  new SelectOption(entry.getValue(), entry.getLabel());      		 
      			listSiteStatus.add(selopt);
    		} 
    	} 
  	}
  	
  	private Boolean accept(PicklistEntry e) {
        // Only show the entries are in the show set
        Set<String> show = new Set<String>{
            '01 – Assess Opportunity'
			,'02 – Budgetary Pricing'
			,'03 – Binding Offer'
			,'04 – Negotiate Contract'
			,'05 – Agreements Finalized'
			,'06 – Closed Won'
			//,'07 – Closed Lost'
			};
        return show.contains(e.getValue());
	}
	
  	public String getInString(List<String> input){
  		String result = '';
  		for(String s : input){
  			s = s.trim();
  			s = s.replace('\'', '\\\'');
  			if(result=='')
  				result = result + '\'' + s + '\'';
  			else
  				result = result + ',\'' + s + '\''; 
  		} 
  		return result;
  	}
  	
  	//set the base on input dates
    public String colorSetter(Date d1, Date d2, String color1, String color2){        
        if(d1!=null && d2.daysBetween(d1) > 0)
            return color1;
        else        
            return color2;        
    }
    
  	public PageReference getData(){
  		this.show = true;
  		this.showbusiUnits = '';
  		this.showregions = '';  
  		this.showsubRegions = '';  
  		this.showsalesStages = '';  
  		this.showsitestatus = '';
  		this.message2 = '';
  		prepareQueryResult(null);  		 		
  		return null;
  	}
  	
  	public PageReference exportToPDF() {
  		this.message2 = '';
    	return new PageReference('/apex/SIFReportPdf');  		
	}
	
	public PageReference exportToExcel() {
		this.message2 = '';
  		return new PageReference('/apex/SIFReportExcel');
	}
	
	public PageReference exportToPDFAndEmail() {
		this.message2 = '';
		try{
        	transient blob content = (new PageReference('/apex/SIFReportPdf')).getContent();
        	System.debug(loggingLevel.INFO,'blob->'+content.toString());
            String fileName = 'SIFReport-'+ Datetime.now().format('yyMMddHHmmss') + '.pdf';          
            sendEmail(content,fileName);
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,e.getMessage()));
            return null;
        }
        this.message2 = 'Email Sent Succesfully.';
        return null;          		
	}
	
	private void sendEmail(blob content,String fileName){        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();             
        if(content.size() > 0 && fileName != '' ) {
        	List<Messaging.EmailFileAttachment> lstAttachments = new List<Messaging.EmailFileAttachment>();            
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();            
            attach.setContentType('application/pdf');            
            attach.setFileName(fileName);
            attach.setInline(false);
            attach.setBody(content);
            lstAttachments.add(attach);
            mail.setFileAttachments(lstAttachments);
        }        
        if (sendEmailToUser != null && sendEmailToUser != '') {
            mail.setToAddresses(sendEmailToUser.split(';')); //To Email Address
            mail.setSubject(MAIL_SUBJECT);
        	mail.setPlainTextBody(strEmailBody); 
        }
        
        if (strEmailDealerCC != null && strEmailDealerCC != '')
            mail.setCcAddresses(strEmailDealerCC.split(';'));//Cc Email Address
        
        if (strEmailDealerBcc != null && strEmailDealerBcc != '')
            mail.setBccAddresses(strEmailDealerBcc.split(';'));//Bcc Email Address
            
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
	
	public List<String> getBusiUnits(){
		return busiUnits;
	}
	
	public void setBusiUnits(List<String> busiUnits){
		this.busiUnits = busiUnits;	
	}
	
	public List<String> getRegions(){
		return regions;
	}
	
	public void setRegions(List<String> regions){
		this.regions = regions;	
	}
	public List<String> getSubRegions(){
		return subRegions;
	}
	
	public void setSubRegions(List<String> subRegions){
		this.subRegions = subRegions;	
	}
	public List<String> getSalesStages(){
		return salesStages;
	}
	
	public void setSalesStages(List<String> salesStages){
		this.salesStages = salesStages;	
	}
	public List<String> getSitestatus(){
		return sitestatus;
	}
	
	public void setsitestatus(List<String> sitestatus){
		this.sitestatus = sitestatus;	
	}
	
	public List<SelectOption> getListBusiUnits() {		
		return listBusiUnits;
	}
	
	public List<SelectOption> getListRegion() {		
		return listRegion;
	}
	
	public List<SelectOption> getListSubRegion() {		
		return listSubRegion;
	}
	
	public List<SelectOption> getListSalesStage() {		
		return listSalesStage;
	}
	
	public List<SelectOption> getListSiteStatus() {		
		return listSiteStatus;
	}
	//class that hold an SIF Report Row
	public class SIFReport{		
		public Site_Information_Form__c innerSite{get;set;}
		public boolean show{get;set;}
		public Site_Information_Form__c regionTotal{get;set;}
		public String sortOrder{get;set;}//for case # 00057573
		SIFReport(Site_Information_Form__c site){
			this.innerSite = site;
			this.show = true;						
		}
	}
}