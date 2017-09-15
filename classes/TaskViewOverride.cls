public class TaskViewOverride{
public String newURL {get;set;}
public String retU {get;set;}
public boolean isAuthorizedUser{get;set;}

public TaskViewOverride(ApexPages.standardController std){
    
    isAuthorizedUser = true;
    String tID = ApexPages.currentPage().getParameters().get('id');
    retU = ApexPages.currentPage().getParameters().get('retURL');
    
    newURL = '/'+ tID +'?nooverride=1';     
    if(retU!=null){
        newURL = newURL + '&retURL=' + retU;
    }
    
    if(tID!=null){
    	
        List<Task> t = new List<Task>([Select id,recordtype.name from Task where id=:tID all rows]);
        if(t.size() > 0){
        	if(userInfo.getUserType()=='PowerPartner' && t.get(0).recordtype.name=='Task visible to SunPower only'){
            	isAuthorizedUser = false;
        	}	
        }
    }
    
}

}