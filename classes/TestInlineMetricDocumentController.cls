/*********************************************************************
    Name  : TestInlineMetricDocumentController
    Date  : July 20,2011
    Description:This is a Test Class For Class "InlineMetricDocumentController".
*********************************************************************/

@isTest
private class TestInlineMetricDocumentController {

    static testMethod void inlineMetricDocumentTest() {
        
        Date dt1 = date.newinstance(2010,7,4);
        Date dt2 = date.newinstance(2009,12,1);
        Date dt3 = date.newinstance(2010,7,31);
        Date dt4 = date.newinstance(2010,1,4);
        Date dt5 = date.newinstance(2006,12,30);
        Date dt6 = date.newinstance(2006,1,1);

        Performance_Metric__c p = new Performance_Metric__c(channel__c='Residential',Peformance_Metric_Name__c='USA1-Jan2010_to_Jun2010',Country__c='USA',Thea__c='North America',Performance_Period_Start_Date__c= dt4,Performance_period_End_date__c =dt1 ,Metric_Setup_Cut_off_Date__c =dt2,Performance_Evaluation_Cut_off_Date__c =dt3 );
        insert p;
        
        Account acc = new Account(name='testResh2',type = 'Premier-Partner-Combo',CurrencyIsoCode='USD',Country_Domain__c ='rvar-us',Theater__c='North America',Authorized_Partner_Date__c=dt6,Promoted_Premier_Date__c=dt5,BillingCountry ='abc',BillingStreet='abc',BillingCity ='xyz',BillingPostalCode='908',Oracle_Account_Number__c='140x');
        insert acc;
        
        Tier__c t1 = new Tier__c(Country__c='USA',Tier_Name__c='Premier');
        insert t1;  

        Metric_Tier_Relation__c mtr = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Homeowner customer satisfaction score',Category__c='Customer Satisfaction',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
        insert mtr;
        
        Metric__c mObj1 = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mtr.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Audit_Date__c=Date.newInstance(2011,1,1));
        insert mObj1;
        
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=mObj1.id;
        insert attach;
        
        mObj1.File_Submission_Count__c = 1;
        update mObj1;
         
        ApexPages.StandardController contrl = new ApexPages.StandardController(mObj1);
        InlineMetricDocumentController IMDControl = new InlineMetricDocumentController(contrl);
        
        PageReference pg = IMDControl.acceptAttach();
        pg = IMDControl.rejectAttach();
        List<Task> taskList = [select id from task where whatId = :mObj1.Id];
        System.assertEquals(1,taskList.size());
        
    }
}