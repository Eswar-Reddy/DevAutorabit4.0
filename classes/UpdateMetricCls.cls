public class UpdateMetricCls{
public string dynamicURL {get;set;}
public string dynamicRVARURL {get;set;}
public string dynamicCVARURL {get;set;}
public integer count {get;set;}
public string type1;
public integer batch {get;set;}
public List<Account> lstAccount {get;set;}

//Constructor
public UpdateMetricCls(){
    type1 = '';   
    count=0;     
    type1 = ApexPages.currentPage().getParameters().get('type'); 
    batch = integer.valueOf(ApexPages.currentPage().getParameters().get('batch')); 
    dynamicURL = type1 + ' Metric Update - In Progress';
    
    integer pass = 1;
    for(List<Account> lstAcc :[Select id,name,country_domain__c from Account where recordtype.name='Partner' and status__c='Active' and country_domain__c in :performanceEvalCst.countrydomains order by createddate]){
        if(batch==pass){
            lstAccount = lstAcc;
        }
        pass++;
    }
       
}

public PageReference getNextURL(){
system.debug('=============='+lstAccount.size()+'========='+count+'========'+ApexPages.currentPage().getParameters().get('type'));
if(count<lstAccount.size()){
    if(type1=='incentive'){
        dynamicRVARURL= getIncentiveURL(lstAccount[count],'rvar');
        dynamicCVARURL= getIncentiveURL(lstAccount[count],'cvar');
        count++;
    }
    else if(type1 =='performance'){
        dynamicRVARURL= getEvalURL(lstAccount[count],'rvar');
        dynamicCVARURL= getEvalURL(lstAccount[count],'cvar');    
        count++;    
    }
}
else{
    dynamicURL= type1 + ' Metric Update - Request is Completed';
    dynamicRVARURL = null;
    dynamicCVARURL = null;
}
return null;
}

public string getIncentiveURL(Account acc, string domain){
string url = null;
if(domain=='rvar' && (acc.country_domain__c.contains('rvar') || acc.country_domain__c.contains('combo'))){
    url = '/apex/incentrail?accId='+acc.id;
    
}else if(domain=='cvar' && (acc.country_domain__c.contains('cvar') || (acc.country_domain__c.contains('combo')))){
    url = '/apex/incentrailComm?accId='+acc.id;
}
return url;
}

public string getEvalURL(Account acc, string domain){
string url = null;
if(domain=='rvar' && (acc.country_domain__c.contains('rvar') || acc.country_domain__c.contains('combo'))){
    url = '/apex/PerformanceEvalPage?accId='+acc.id;
    
}else if(domain=='cvar' && (acc.country_domain__c.contains('cvar') || (acc.country_domain__c.contains('combo')))){
    url = '/apex/PerformanceEvalPageComm?accId='+acc.id;
}
return url;
}

}