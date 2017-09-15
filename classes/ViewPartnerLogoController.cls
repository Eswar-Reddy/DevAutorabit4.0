/************************************
**PR-01802
**By- Kapil Goutam
**On- May 25 2009
**Description- Controller class for ViewPartnerLogo Page
**
*************************************/
public class ViewPartnerLogoController {
	public Account acc{get;set;}
	public String logoURL;
	
	public ViewPartnerLogoController(ApexPages.StandardController stdController) {
        acc = (Account)stdController.getRecord();
       	
    }
    
    public String getLogoURL(){
    	List<Account> listAccount = new List<Account>([Select Partner_Logo__c from Account where Id=:acc.Id limit 1]);
    	if(listAccount.Size()>0 && listAccount.get(0).Partner_Logo__c != null){
    		return listAccount.get(0).Partner_Logo__c;
    	}
    
    	return '';
    }

}