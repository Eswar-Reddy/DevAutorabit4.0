/**
* Created by: Accenture 
* Date : 29 April 2010
* Purpose: Contains functions that have to be update Account & Lead records with active/Inactive site count.
* as per the review comments  on 26 April 2010.
**/

public class CountOfSites{

    public static void afterInsertUpdate(List<Site_Information_Form__c> siteInfoList){
        List<Account> accList = new List<Account>();
        List<Account> accLst = new List<Account>();
        List<Site_Information_Form__c> siteList = new List<Site_Information_Form__c>();
        Set<Id> AccId = new Set<Id>();
        Set<Id> leadId = new Set<Id>();
        Set<Id> siteId = new Set<Id>();
        List<Lead> leadList = new List<Lead>();
        List<Lead> leadLst = new List<Lead>();
        for(Site_Information_Form__c s: siteInfoList){
            if(s.id != null){
                siteId.add(s.Id);
                AccId.add(s.Account__c);
                if(s.Lead__c!=null){
                    leadId.add(s.Lead__c);
                }
            }
        }
        
        /*siteList=[select  Account__c,Lead__c from Site_Information_Form__c where Id IN:siteId];
        for(Site_Information_Form__c s:siteList ){
            AccId.add(s.Account__c);
            leadId.add(s.Lead__c);
        }*/
        accLst = [select Id,(select Id,Site_Status__c from Site_Information_Forms__r) from Account where Id IN: accId];
        // loop through the accounts and sites and find the active n inactive site count for each account
        for(Account a: accLst){
            List<Site_Information_Form__c> sActLst = new List<Site_Information_Form__c>();
            List<Site_Information_Form__c> sActLst2 = new List<Site_Information_Form__c>();
            List<Site_Information_Form__c> sTotList= a.Site_Information_Forms__r;
            for(Site_Information_Form__c s: sTotList){
              if(s.Site_Status__c == 'Active'){
                  sActLst.add(s);
              }    
              if(s.Site_Status__c == 'Inactive'){
                  sActLst2.add(s);
              }
            }
            Integer sActSize = sActLst.size();
            Integer sTotSize = sTotList.size();
            Integer sProsSize = sActLst2.size();
            a.Number_of_Active_Sites__c = sActSize;
            a.Number_of_Inactive_Sites__c = sProsSize;
            accList.add(a);
        }
              
               
        If(accLst.size()!= 0){
            Update accList;
        }
        
        LeadList = [select Id,Isconverted,count_of_Sites__c,(select Id from Site__r) from Lead where Id IN:leadId]; // and Isconverted =:false ];
        // loop through the lead and count the number of sites.
        for(Lead l: leadList){
            List<Site_Information_Form__c> sTotList = l.Site__r;
            Integer sTotLead = sTotList.size();
            l.count_of_Sites__c = sTotLead;
            if(!l.Isconverted){
                leadLst.add(l);
            }
        }
        Update leadLst;

    }
    
    public static void beforeInsertUpdate(List<Opportunity_Role__c> opRoleList){
        for(Opportunity_Role__c opprole : opRoleList){
            RecordType record = [Select Id,Name from RecordType  where RecordType.id =: opprole.HiddenRecordType__c];
            opprole.Role_on_Opportunity__c = record.Name;
        }
    }

}