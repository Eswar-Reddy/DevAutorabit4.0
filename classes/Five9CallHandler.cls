//Handler Class to make webservice call to Five9 and send phone number and Opportunity ID
public with sharing class Five9CallHandler {
    
    
    public static void processOpportunities(String Operation,List<Opportunity> newOppList, Map<Id,Opportunity> newOppMap,Map<Id,Opportunity> oldOppMap){
        
        System.debug('NewOppMap ----- '+newOppMap);
        System.debug('OldOppMap ----- '+oldOppMap);
        Set<String> spdIDSet = new Set<String>();
        spdIDSet.addAll(Label.SPDIds.split(','));
        Set<Id> oppIdSet = new Set<Id>();
        Set<String> oppStageSet = new Set<String>();

        List<Five9WebserviceCalloutSettings__c> fcs = Five9WebserviceCalloutSettings__c.getall().values();
 
        if(!fcs.isEmpty()){
            oppStageSet.addAll(fcs[0].OpportunityStages__c.split(','));
        }
        
        if(Operation=='isInsert'){
            for(Opportunity opp:newOppList){
                if(spdIDSet.contains(opp.PartnerAccountId)){
                    oppIdSet.add(opp.Id);
                }   
            }
        }
        
        if(Operation=='isUpdate'){
            for(Opportunity opp:newOppList){
                System.debug('opp PartnerAccountId -----'+opp.PartnerAccountId);
                System.debug('opp StageName -----'+opp.StageName);
                System.debug('spdIDSet -----'+spdIDSet);
                System.debug('oppStageSet -----'+ oppStageSet);
                System.debug('----- '+spdIDSet.contains(newOppMap.get(opp.Id).PartnerAccountId));
                System.debug('----- '+oppStageSet.contains(opp.StageName));
                System.debug('New PartnerAccountId -----'+newOppMap.get(opp.Id).PartnerAccountId);
                System.debug('Old PartnerAccountId -----'+oldOppMap.get(opp.Id).PartnerAccountId);
                if( (newOppMap.get(opp.Id).PartnerAccountId!=oldOppMap.get(opp.Id).PartnerAccountId) && spdIDSet.contains(newOppMap.get(opp.Id).PartnerAccountId) && oppStageSet.contains(opp.StageName)){
                    oppIdSet.add(opp.Id);
                    System.debug('Five9CallHandler ----- Inside isUpdate Loop');
                }
                    
            }
        }
        
        if(!oppIdSet.isEmpty()){
            calloutfive9(oppIdSet);
        }
            
    }
    
    @future(callout=true)
    public static void calloutfive9(Set<Id> oppIds){
        
        List<Opportunity> oppList = [select Primary_Phone__c,Campaign.Name,Opportunity_Number1__c,Not_Sent_To_Five9__c from Opportunity where Id in :oppIds or Not_Sent_To_Five9__c =true];
        List<Opportunity> toUpdate = new List<Opportunity>();
        
        for(Opportunity opp:oppList){
           boolean calloutSuccess=callfive9addtoList(opp);
           
           if(calloutSuccess==false){
                toUpdate.add(new Opportunity
                                (Id=opp.Id
                                ,Not_Sent_To_Five9__c=true));
           }
           else if(calloutSuccess==true && opp.Not_Sent_To_Five9__c==true){
               toUpdate.add(new Opportunity
                                (Id=opp.Id
                                ,Not_Sent_To_Five9__c=false));
           }
        }
        
        try{
            if(!toUpdate.isEmpty())
                update toUpdate;
        } catch(DMLException e){
            ExLog.log(e);
            throw e;
        }
            
    }
    
    public static boolean callfive9addtoList(Opportunity opp){
        
        boolean calloutSuccess=false;
    
        Five9ComWSDL2Apex.WsAdminPort wap = new Five9ComWSDL2Apex.WsAdminPort();
        wap.inputHttpHeaders_x = new Map<String, String>();
    
        List<Five9WebserviceCalloutSettings__c> fcs = Five9WebserviceCalloutSettings__c.getall().values();
    
        if(!fcs.isEmpty()){
        
            String usrnamepwd = fcs[0].username__c+':'+fcs[0].password__c;
            System.debug('usrnamepwd -----'+usrnamepwd);
            String base64usrnamepwd = EncodingUtil.base64Encode(Blob.valueOf(usrnamepwd));
            wap.inputHttpHeaders_x.put('Authorization', 'Basic'+' '+base64usrnamepwd);
            wap.inputHttpHeaders_x.put('SOAPAction', '');
            
            Five9ComWSDL2Apex.listUpdateSimpleSettings fnlUS = new Five9ComWSDL2Apex.listUpdateSimpleSettings();
            Five9ComWSDL2Apex.recordData fnrD = new Five9ComWSDL2Apex.recordData();
            
            
            fnlUS.fieldsMapping = new List<Five9ComWSDL2Apex.fieldEntry>();        
            
            Five9ComWSDL2Apex.fieldEntry fE0 = new Five9ComWSDL2Apex.fieldEntry();
            fE0.columnNumber=0;
            fE0.fieldName='number1';
            fE0.key=false;
            fnlUS.fieldsMapping.add(fE0);
            
            /*
            Five9ComWSDL2Apex.fieldEntry fE1 = new Five9ComWSDL2Apex.fieldEntry();
            fE1.columnNumber=1;
            fE1.fieldName='number1';
            fE1.key=false;
            fnlUS.fieldsMapping.add(fE1);*/
            
            Five9ComWSDL2Apex.fieldEntry fE2 = new Five9ComWSDL2Apex.fieldEntry();
            fE2.columnNumber=1;
            fE2.fieldName='salesforce_id';
            //fE2.fieldName='Opportunity_Number1__c';
            fE2.key=true;
            fnlUS.fieldsMapping.add(fE2);
            
            Five9ComWSDL2Apex.fieldEntry fE3 = new Five9ComWSDL2Apex.fieldEntry();
            fE3.columnNumber=2;
            fE3.fieldName='sfdc_campaign';
            fE3.key=false;
            fnlUS.fieldsMapping.add(fE3);
            
            
            Five9ComWSDL2Apex.fieldEntry fE4 = new Five9ComWSDL2Apex.fieldEntry();
            fE4.columnNumber=3;
            fE4.fieldName='Opportunity.Opportunity_Number1__c';
            fE4.key=false;
            fnlUS.fieldsMapping.add(fE4);
            
            fnlUS.callAsap=fcs[0].callAsap__c;
            
            String string0='';
            String string1='';
            String string2='';
            String string3='';
            String string4='';
            
            String1=opp.Primary_Phone__c;
            String2=opp.Id;
            String3=opp.Campaign.Name;
            String4=opp.Opportunity_Number1__c;
            
            System.debug('string1 -----'+string1);
            System.debug('string2 -----'+string2);
            System.debug('string3 -----'+string3);
            System.debug('String4 -----'+string4);
            
            //fnrD.fields = new String[]{string1,string2,string3};
            //fnrD.fields = new String[]{string0,string1,string2,string3};
            fnrD.fields = new String[]{string1,string2,string3,string4};
            
            System.debug('fnlUS.fieldsMapping -----'+fnlUS.fieldsMapping);
            System.debug('fnrD -----'+fnrD);
            
            
            
            
            System.debug('String1------'+string1);
            //System.debug('-----'+Limits.getLimitCallouts());
            if(string1!=null && string1!=''){
                try{
                    wap.addRecordToListSimple(fcs[0].ListName__c, fnlUS, fnrD);
                    calloutSuccess=true;
                }catch(Exception e){
                    System.debug('Error ----- '+e);
                }
            }
        }
        return calloutSuccess;
    }
    
}