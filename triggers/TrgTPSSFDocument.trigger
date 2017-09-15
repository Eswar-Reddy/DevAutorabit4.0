trigger TrgTPSSFDocument on TPSSF__Document__c (before insert) {
map<String,String> mapDocumentCategory = new map<String,String>();
map<String,String> mapDocumentType = new map<String,String>();
set<String> mapCategoryID = new set<String>();
set<String> mapDocumentTypeID = new set<String>();
set<ID> oppID = new set<ID> ();
Map<ID,String> mapOpportunityAgreement= new Map<ID,String>();
    
    for(TPSSF__Document__c objDocument : trigger.new){
        if(objDocument.TPSSF__Object_Name__c == 'Opportunity'){
            objDocument.Opportunity__c  =objDocument.TPSSF__Object_Id__c;
            oppID.add(objDocument.Opportunity__c);
        }
         else if(objDocument.TPSSF__Object_Name__c == 'Account')
            objDocument.Account__c = objDocument.TPSSF__Object_Id__c;
        if(objDocument.TPSSF__Document_Category__c != null)
        	mapCategoryID.add(objDocument.TPSSF__Document_Category__c);
        if(objDocument.TPSSF__Document_Type__c != null)
        	mapDocumentTypeID.add(objDocument.TPSSF__Document_Type__c);
    }
    if(!mapCategoryID.isEmpty())
    {
        for(TPSSF__Document_Category__c objCa: [SELECT ID,TPSSF__Key__c,Name from TPSSF__Document_Category__c where TPSSF__Key__c IN: mapCategoryID]){
            mapDocumentCategory.put(objCa.TPSSF__Key__c, objCa.Name);
        }
    }
    if(!mapDocumentTypeID.isEmpty())
    {
        for(TPSSF__Document_Type__c objType: [SELECT ID,TPSSF__Key__c,Name from TPSSF__Document_Type__c where TPSSF__Key__c IN: mapDocumentTypeID]){
            mapDocumentType.put(objType.TPSSF__Key__c, objType.Name);
        }
    }
    for(echosign_dev1__SIGN_Agreement__c objAgreement: [Select id,Opportunity__c,echosign_dev1__Status__c from echosign_dev1__SIGN_Agreement__c where Opportunity__c IN : oppID AND Recordtype.Name='Lease Contract']){
        mapOpportunityAgreement.put(objAgreement.Opportunity__c, objAgreement.echosign_dev1__Status__c);
    }
    System.debug('----------------------------mapOpportunityAgreement'+mapOpportunityAgreement);
    for(TPSSF__Document__c objDocument : trigger.new){
         if(objDocument.TPSSF__Document_Category__c != null && mapDocumentCategory.containsKey(objDocument.TPSSF__Document_Category__c))
             objDocument.Document_Category__c = mapDocumentCategory.get(objDocument.TPSSF__Document_Category__c);
         if(objDocument.TPSSF__Document_Type__c != null && mapDocumentType.containsKey(objDocument.TPSSF__Document_Type__c))
             objDocument.Document_Type__c = mapDocumentType.get(objDocument.TPSSF__Document_Type__c);
        if(mapOpportunityAgreement!= null && objDocument.Opportunity__c != null && mapOpportunityAgreement.containsKey(objDocument.Opportunity__c))
             objDocument.Agreement_Status__c = mapOpportunityAgreement.get(objDocument.Opportunity__c);
    }
}