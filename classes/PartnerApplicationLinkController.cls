/*****************************
**Created By- Aashish Mathur 
**Created On- Nov 25, 2010 
**Desciption- Controller class for PartnerApplicationLink page
*******************************/

public class PartnerApplicationLinkController {
	public Lead lead{get;set;} 
	public String URL{get;set;}
	public Boolean show{get;set;}
	public PartnerApplicationLinkController(ApexPages.StandardController controller){
    	this.lead = (Lead)controller.getRecord();
    	//this.show = true;
    	this.lead = [select Id, Partner_Application__c from Lead where Id = :this.lead.Id limit 1];    	
    	if(this.lead.Partner_Application__c!=null){
    		this.show = false;
    	}else{
    		this.show = true;
    	}
  	}
  	public PageReference createSpanishPA(){
  		String prUrl;
        prUrl = '/apex/CreatePartnerApplication?LId=' + lead.Id;
        prUrl = prUrl + '&Type="Residential"&Lang="Spanish"';
    	PageReference pr = new PageReference(prUrl);
    	pr.setRedirect(true);
    	return pr;  
  	}
  	public PageReference createFrenchPA(){
  		String prUrl;
        prUrl = '/apex/CreatePartnerApplication?LId=' + lead.Id;
        prUrl = prUrl + '&Type="Residential"&Lang="French"';
    	PageReference pr = new PageReference(prUrl);
    	pr.setRedirect(true);
    	return pr;  
  	}
  	public PageReference createGermanPA(){
  		String prUrl;
        prUrl = '/apex/CreatePartnerApplication?LId=' + lead.Id;
        prUrl = prUrl + '&Type="Residential"&Lang="German"';
    	PageReference pr = new PageReference(prUrl);
    	pr.setRedirect(true);
    	return pr;  
  	}
  	public PageReference createItalianPA(){
  		String prUrl;
        prUrl = '/apex/CreatePartnerApplication?LId=' + lead.Id;
        prUrl = prUrl + '&Type="Residential"&Lang="Spanish"';
    	PageReference pr = new PageReference(prUrl);
    	pr.setRedirect(true);
    	return pr;  
  	}
  	public PageReference createAusPA(){
  		String prUrl;
        prUrl = '/apex/CreatePartnerApplication?LId=' + lead.Id;
        prUrl = prUrl + '&Type="Residential"&Lang="English"';
    	PageReference pr = new PageReference(prUrl);
    	System.debug(LoggingLevel.INFO, 'PR->'+prUrl);
    	//pr.setRedirect(true);
    	return pr;  
  	}
  	public PageReference createResPA(){
  		String prUrl;
        prUrl = '/apex/CreatePartnerApplication?LId=' + lead.Id;
        prUrl = prUrl + '&Type="Residential"';
    	PageReference pr = new PageReference(prUrl);
    	pr.setRedirect(true);
    	return pr;  
  	}
  	public PageReference createCommPA(){
  		String prUrl;
        prUrl = '/apex/CreatePartnerApplication?LId=' + lead.Id;
        prUrl = prUrl + '&Type="Commercial"';
    	PageReference pr = new PageReference(prUrl);
    	pr.setRedirect(true);
    	return pr;  
  	}    
}