trigger DMLeadConvert on Lead_Conversion__c (after insert) {

//List<Database.LeadConvert> lstLeadConvert = new List<Database.LeadConvert>();
LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
//List<Id> leadIDs = new List<Id>();
System.debug('Updating oppty Ids on converted Leads.');

for(Integer i=0;i<Trigger.new.size();i++)
{

        System.debug('Forcing LeadConversion');
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(Trigger.new[i].Lead__c);
        lc.setAccountId(Trigger.new[i].Account__c);
        lc.setContactId (Trigger.new[i].Contact__c);
        lc.setConvertedStatus(convertStatus.MasterLabel); 
        lc.setDoNotCreateOpportunity(true);
        //lstLeadConvert.add(lc);
        Database.convertLead(lc);

   }





}