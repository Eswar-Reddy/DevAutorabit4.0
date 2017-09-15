@isTest
Public class BeforeUpdateIRTTrigger_Test
{
    static testmethod void ForBeforeUpdateInitialRes()
    {
        List<Case> lstc = new List<Case>();
        Case c = new Case();
        c.Initial_Response_Timestamp__c = Datetime.newInstance(2012, 10, 1, 1, 50, 0);
        c.Date_Assigned_to_Birlasoft__c = Datetime.newInstance(2012, 10, 18, 22, 10, 0);
        c.Initial_Response_Time_for_Birlasoft__c = String.ValueOf(c.Initial_Response_Timestamp__c.GetTime() - c.Date_Assigned_to_Birlasoft__c.GetTime());
        lstc.add(c);
        Insert lstc;    
    }
}