global without sharing class Batch_ConvertLead implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful
{
    Set<Id> opportunityIds = new Set<Id>();
    global final String query;

    global Batch_ConvertLead() 
    {
        query = 'SELECT Id, Status, FirstName, Lastname, Company, street, city, state, postalCode, country, Email, isConverted, OwnerId, Campaign_ID__c, IsAutoConvert__c , Dealer_Locator_Selection__c, RecordType.Name FROM Lead WHERE isConverted = false AND IsAutoConvert__c = true AND RecordType.Name != \'Partner\' ORDER BY createddate ASC';// limit 1';
    } 
 
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);
    } 
      
    global void execute(Database.BatchableContext BC, List<sObject> scope) 
    {
        
        DealerUtility.IsBatchRunning = true;
        ReferralManagementCallout.inBatchContext = true;
        Map<Lead, GeocodeAsyncHandler.GeoInfo> leadGeoMap = new Map<Lead, GeocodeAsyncHandler.GeoInfo>();
        List <Lead> leadsToUpdate = new List <Lead>();
         
        for (Lead l : (List<Lead>)scope) 
        {            
            try 
            {               
                String cleanAddress = GeocodeAsyncHandler.cleanAddress(l.Street, l.City, l.State, l.PostalCode, l.Country);
                System.debug(LoggingLevel.INFO, 'Batch_ConvertLead.execute: address cleaned.');
                GeocodeAsyncHandler.GeoInfo info = GeocodeAsyncHandler.GeoCode(cleanAddress);
                System.debug(LoggingLevel.INFO, 'Batch_ConvertLead.execute: address geocoded.');
                
                if (info.ZeroResults == true) 
                {
                    System.debug(LoggingLevel.INFO, 'Batch_ConvertLead.execute: ' + l.Id + ' no geocode results.');
                    Lead LeadToUpdate = new Lead(id=l.id);
                    LeadToUpdate.IsAutoConvert__c = false;
                    LeadToUpdate.Lead_Conversion_Status__c = 'Failed Conversion - Address not Found';
                    LeadToUpdate.Status = 'Failed Conversion';
                    leadsToUpdate.add(LeadToUpdate);
                }
                else if (info.Lat != null) 
                {
                    System.debug(LoggingLevel.INFO, 'Batch_ConvertLead.execute: ' + l.Id + ' has geocode results.');
                    DealerUtility.IsBatchRunning = true;
                    //if (!Test.isRunningTest()) DealerUtility.ConvertLead(l, info);
                    
                    leadGeoMap.put(l, info); 
                    DealerUtility.IsBatchRunning = false;  
                }
                
            }
            catch(Exception ex) 
            {
                System.debug(LoggingLevel.INFO, 'Batch_ConvertLead.execute: Exception thrown while geocoding: ' + ex.getMessage());
                Lead LeadToUpdate = new Lead(id=l.id);
                LeadToUpdate.IsAutoConvert__c = false;
                LeadToUpdate.Status = 'Failed Conversion';
                LeadToUpdate.Lead_Conversion_Status__c = 'Failed Conversion - Address cannot be cleaned';
                leadsToUpdate.add(LeadToUpdate);
            }
        
        }

        System.debug(LoggingLevel.INFO, 'Batch_ConvertLead.execute: converting '+ leadGeoMap.size() +' lead(s)');
        Set<Id> opportunityIdsToUpdate = DealerUtility.ConvertLeadBulk(leadGeoMap);
        opportunityIds.addAll(opportunityIdsToUpdate);
        List<Opportunity> opportunities = new List<Opportunity>();
        for(Id opportunityId : opportunityIdsToUpdate) {
            System.Debug('Batch_ConvertLead opportunityId:' + opportunityId);
            opportunities.add(new Opportunity
                ( Id = opportunityId
                , Send_Social_Annex_Update__c = true
                ));
        }
        try {
            update leadsToUpdate;
        }
        catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'Batch_ConvertLead.execute: failed to update leads ' + e.getMessage());
        }
        try {
            update opportunities;
        } catch(DMLException e) {
            ExLog.log(e);
            throw e;
        }
   }
  
  global void finish(Database.BatchableContext BC) 
  {
    
        if (Test.isRunningTest()) return;

        //Is the ALR process active?
        DealerGeneral__c dg = DealerGeneral__c.getInstance();
        if (!dg.Enable_ALR_Process__c) return;
        
        if ([SELECT Id FROM Lead where isConverted = FALSE AND IsAutoConvert__c = TRUE AND RecordType.Name != 'Partner'].size() > 0)
        {
            Batch_ConvertLead startBatch = new Batch_ConvertLead();
            Database.executeBatch(startBatch,1);
        }           
        else 
        {
            DealerUtility.IsBatchRunning = false;
        }
        
        System.Debug(opportunityIds);        
        Database.executeBatch(new Batch_SendSAUpdate(opportunityIds));
        
        Set<String> spdIDSet = new Set<String>();
        spdIDSet.addAll(Label.SPDIds.split(','));
        
        List<Opportunity> oppList = new List<Opportunity>();
        oppList = [Select PartnerAccountId from Opportunity where Id in : opportunityIds];
        
        Set<Id> oppIdsBatch = new Set<Id>();
        
        for(Opportunity opp:oppList){
            if(spdIDSet.contains(opp.PartnerAccountId)){
                oppIdsBatch.add(opp.Id);
            }  
        }
        
        //Call Batch_CallFive9
        if(!oppIdsBatch.isEmpty()){
            List<Five9WebserviceCalloutSettings__c> fcs = Five9WebserviceCalloutSettings__c.getall().values();
            if(!fcs.isEmpty()){
                if(fcs[0].MasterSwitchOn__c==true){
                    Batch_CallFive9 five9batch = new Batch_CallFive9();
                    five9batch.oppIdSet= oppIdsBatch;
                    Database.executeBatch(five9batch,1);
                }
            }
        }
      
      // update Contact Role
      if(!opportunityIds.isEmpty())
      		OpportunityUtilities.updateContactRole(opportunityIds);
      
        
   }
}