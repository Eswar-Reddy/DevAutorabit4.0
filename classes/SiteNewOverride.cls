public class SiteNewOverride
{
    public String newURL {get;set;}
    public String retU {get;set;}
    public Opportunity opp{get;set;}
    public RecordType rec {get;set;}


    public SiteNewOverride(ApexPages.standardController std)
    {
        Site_Information_Form__c site = (Site_Information_Form__c)std.getRecord();     
        String Url = ApexPages.currentPage().getURL();
       
        String preFix = Site_Information_Form__c.SObjectType.getDescribe().getKeyPrefix();                
               
        for(RecordType recT : [SELECT id, Name FROM RecordType where id =: site.RecordTypeId limit 1]){
            rec = recT;
        }
        integer index = Url.indexOf('?');
        
        //Prepare new URL 
        String newU = Url.subString(index);
        newU = '/' + preFix+ '/e' + newU;
        newU = newU.replace('sfdc.override','nooverride');
        newURL = newU.replace('&save_new=1','');
        
        if(Url.contains('CF00N80000004Y3nO') && rec!=null && rec.Name == 'Standard Site')
        {          
          opp = [SELECT Id,AccountId,Account.Name,Name FROM Opportunity where id=:site.Opportunity_del__c];  
          newURL = newURL + '&CF00N80000004Y3lu='+ Opp.Account.Name + '&CF00N80000004Y3lu_lkid='+Opp.AccountID;  
          //Start 00103434
          newURL = newURL.replace('\'','\\\'');        
          //End 00103434            
        }
         
    }
    
}