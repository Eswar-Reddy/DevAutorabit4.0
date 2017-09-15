public class CaseMetricManagment
{
    //CRM Case recordtype Id
    public static Id CRMCaseRecTypeId
    {
        get
        {
            if(CRMCaseRecTypeId == null)
            {
                CRMCaseRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CRM Case').getRecordTypeId();
            }
            return CRMCaseRecTypeId;
        }
        set;
    }
    //Appirio Owner Ids
    public static Set<Id> BirlasoftOwners
    {
        get
        {
            if(BirlasoftOwners == null)
            {
                BirlasoftOwners = (new Map<Id, User>([Select Id, Name From User where Name Like '%Birlasoft%'])).keyset();
            }
            return BirlasoftOwners;
        }
        set;
    }
    //CRM Business Hours
    public static Id DefaultBusinessHoursId
    {
        get
        {
            if(DefaultBusinessHoursId == null)
            {
                for(BusinessHours bh : [Select Id From BusinessHours Where Name = 'CRM Support' And isActive = true])
                {
                    DefaultBusinessHoursId = bh.Id;
                }
            }
            return DefaultBusinessHoursId ;
        }
        set;
    }
    //Status list for Metric clock up
    public static Set<String> StartStatusSet
    {
        get
        {
            if(StartStatusSet == null)
            {
                StartStatusSet = new Set<String>();
                for(MetricStartStatus__c status : MetricStartStatus__c.getAll().values())
                {
                    StartStatusSet.add(status.Status__c);
                }
            }
            return StartStatusSet;
        }
        set;
    }
    //Function which will called from trigger after insert/update
    public static void afterCaseInsertUpdate(List<Case> newCases, Map<Id,Case> oldMap)
    {
        Boolean isInsert = oldMap == null;
        //prepare a set of CRM case ids 
        Set<Id> crmCaseIds = new Set<Id>();
        for(Case newCase: newCases)
        {
            if(newCase.RecordTypeId == CRMCaseRecTypeId)
            crmCaseIds.add(newCase.Id);
        }
        //check if CRM cases exists
        if(crmCaseIds.size()>0)
        {
            Map<Id,Case> mapCase = new Map<Id,Case>([Select Id, (Select Id,Start_Date__c, End_Date__c, Time_With_Support__c From Case_metrics__r where End_Date__c = null) From Case where Id In : crmCaseIds]);
            //process cases and prepare a list of case metric to be updated
            List<Case_metric__c> listCaseMetric = new List<Case_metric__c>(); 
            for(Case newCase :newCases)
            {
                if(newCase.RecordTypeId != CRMCaseRecTypeId)
                continue;
                if(BirlasoftOwners.contains(newCase.OwnerId) && startStatusSet.contains(newCase.Status)
                && (isInsert || ( !(BirlasoftOwners.contains(oldMap.get(newCase.Id).OwnerId) && startStatusSet.contains(oldMap.get(newCase.Id).Status)) )))
                {
                    //Starting Case Metric
                    Case_metric__c caseMetric = new Case_metric__c();
                    caseMetric.Start_Date__c = datetime.now();
                    caseMetric.Case__c = newCase.Id; 
                    listCaseMetric.add(caseMetric);
                }
                //Closing Metric
                else if(!(BirlasoftOwners.contains(newCase.OwnerId) && startStatusSet.contains(newCase.Status)) && !isInsert)
                {
                    for(Case_metric__c caseMetric: mapCase.get(newCase.Id).Case_metrics__r)
                    {
                        caseMetric.End_Date__c = datetime.now();
                        caseMetric.Time_With_Support__c = getBusinessHoursInBetween(newCase.BusinessHoursId,caseMetric.Start_Date__c, caseMetric.End_Date__c);
                        listCaseMetric.add(caseMetric);
                    }
                }
            }
            if(listCaseMetric.size() > 0)
            upsert listCaseMetric;
        } 
    }
    //Function which will called from trigger before update 
    public static void beforeCaseUpdate(List<Case> newCases,Map<Id,Case> oldMap)
    {
        Set<Id> crmCaseIds = new Set<Id>();
        for(Case newCase : newCases)
        {
            //Calculate Time_With_Customer__c if status not closed for a long time
            if(newCase.recordTypeId == CRMCaseRecTypeId)
            {
                DateTime endTime = newCase.Status == 'Closed' && oldMap.get(newCase.Id).Status == 'Closed' ? newCase.ClosedDate : datetime.now();
                Double caseAgeInHours = getBusinessHoursInBetween(newCase.BusinessHoursId,newCase.CreatedDate,endTime);
                newCase.Time_With_Customer__c = caseAgeInHours - newCase.Time_With_Support__c;
                if (newCase.Initial_Response_Timestamp__c != null && newCase.Appirio_Initial_Response_Time_Hours__c == null && BirlasoftOwners.contains(newCase.OwnerId))
                {
                    crmCaseIds.add(newCase.Id);
                }
                system.debug('Madhuri==='+newCase.Time_With_Customer__c);
            }
        }
        if(crmCaseIds.size()== 0) return;
        Map<Id,Case> mapCase = new Map<Id,Case>([Select Id, (Select Id,Start_Date__c, End_Date__c, Time_With_Support__c From Case_Metrics__r order by Start_Date__c limit 2) From Case where Id In : crmCaseIds]);
        List<Case_metric__c> listCaseMetric; 
        for(Case newCase :newCases)
        {
            if(newCase.RecordTypeId != CRMCaseRecTypeId)
            continue;
            if(mapCase.get(newCase.Id) != null)
            {
                listCaseMetric = mapCase.get(newCase.Id).Case_metrics__r;
                if(listCaseMetric == null) return;
                for(Case_Metric__c caseMetric : listCaseMetric)
                {
                    if(caseMetric.Start_Date__c != null && caseMetric.End_Date__c != null && (caseMetric.Start_Date__c.getTime() / 60000.0) == (caseMetric.End_Date__c.getTime() / 60000.0))
                    { 
                        continue;
                    }
                    newCase.Appirio_Initial_Response_Time_Hours__c = getBusinessHoursInBetween(newCase.BusinessHoursId,caseMetric.Start_Date__c,newCase.Initial_Response_Timestamp__c);
                    if(newCase.Appirio_Initial_Response_Time_Hours__c != null && newCase.Appirio_Initial_Response_Time_Hours__c < 0.00)
                    newCase.Appirio_Initial_Response_Time_Hours__c = 0.00;
                    break;
                }
            }
        }
    }
    //Function to calculate total hours taken on the case from start date to endate
    public static Decimal getBusinessHoursInBetween(Id businessHoursId,DateTime startDate,DateTime endDate)
    {
        businessHoursId = businessHoursId == null? DefaultBusinessHoursId : businessHoursId ;
        return BusinessHours.diff(businessHoursId ,startDate,endDate)/3600000.0; 
    }
}