/***************************************
***Case Number-00049024
***Created By- Aashish Mathur
***Created Date - Nov 23, 2010 
***Description- Trigger Methods
****************************************/
public class SiteManagement {
    public static void afterInsertUpdateDelete (List<Site_Information_Form__c> siteList){  
        Set<Id> setId = new Set<Id>();
        
        for(Site_Information_Form__c site : siteList)
            setId.add(site.Opportunity_del__c);
        
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        
        for(Opportunity opp : [Select Id, Total_Land_Size__c,Average_Usable_Land_Percentage__c,
         	(select Id,Of_Useable_Land__c,Land_size_ha__c, Site_Status__c from R00N30000000t6dPEAQ__r) From Opportunity where Id in:setId //for case #00054915 
         	and RecordType.Name='Development']){
            List<Site_Information_Form__c> listSite = opp.R00N30000000t6dPEAQ__r;
            Double Total_Land_Size = 0;
            Double Average_Usable_Land_Percentage = 0;
            Integer i=0;
        
            for(Site_Information_Form__c site : listSite){
               if(site.Land_size_ha__c != null 
               	&& site.Site_Status__c != 'Inactive'//for case #00054915
               	&& site.Site_Status__c != 'Abandoned'//for case #00054915               	
               		){
                   Total_Land_Size =  Total_Land_Size + site.Land_size_ha__c;
               }
               if(site.Of_Useable_Land__c != null){
                   Average_Usable_Land_Percentage = Average_Usable_Land_Percentage + site.Of_Useable_Land__c; 
             	  	i++;
               }
            }
        
            if(Average_Usable_Land_Percentage>0 && i>1)
                Average_Usable_Land_Percentage = Average_Usable_Land_Percentage/i;
        
            System.debug(loggingLevel.INFO, 'average->'+ Average_Usable_Land_Percentage);
            System.debug(loggingLevel.INFO, 'sum->'+ Total_Land_Size);
            if(opp.Total_Land_Size__c != Total_Land_Size
                 ||opp.Average_Usable_Land_Percentage__c!=Average_Usable_Land_Percentage){
                    opp.Total_Land_Size__c =   Total_Land_Size;
                    opp.Average_Usable_Land_Percentage__c=Average_Usable_Land_Percentage;
                    oppToUpdate.add(opp);
                }
            }       
           if(oppToUpdate.size()>0)  
            update oppToUpdate;
    }
}