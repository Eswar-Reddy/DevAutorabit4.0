/*********************************************************************
    Name  : TestUploadProofController
    Date  : Sep 01,2011
    Description:This is a Test Class For Class "UploadProofController".
*********************************************************************/

@isTest
private class TestUploadProofController {

    static testMethod void uploadProofControllerTest() {
        Date dt = date.newinstance(2006,1,1);
        Date dt1 = date.newinstance(2010,7,4);
        Date dt2 = date.newinstance(2009,12,1);
        Date dt3 = date.newinstance(2010,7,31);
        Date dt4 = date.newinstance(2010,1,4);
        
        Performance_Metric__c p = new Performance_Metric__c(channel__c='Residential',Peformance_Metric_Name__c='Italy1-Jan2010_to_Jun2010',Country__c='Italy',Thea__c='Europe',Performance_Period_Start_Date__c= dt4,Performance_period_End_date__c =dt1 ,Metric_Setup_Cut_off_Date__c =dt2,Performance_Evaluation_Cut_off_Date__c =dt3 );
        insert p;
        
        Account acc = new Account(name='testResh1',type = 'Authorized-Partner-Combo',CurrencyIsoCode='EUR',Country_Domain__c ='rvar-it',Theater__c='Europe',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1,BillingCountry ='abc',BillingStreet='abc',BillingCity ='xyz',BillingPostalCode='908',Oracle_Account_Number__c='140x');
        insert acc;
        
        Tier__c t1 = new Tier__c(Country__c='Italy',Tier_Name__c='Authorized');
        insert t1;  

        Metric_Tier_Relation__c mtr = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Bonus for Extra Training - percent of Sales People with Adv Training ',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE);
        insert mtr;

        Metric__c mObj1 = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mtr.Id,Achievement_Value__c=0,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Goal_Met__c= TRUE);
        insert mObj1;        
                
        /* Create an Attachment */
        Attachment a = new Attachment(ParentId = mObj1.id, Name = 'Attachment', Body = Blob.valueOf('Attachment Body'));
        Database.insert(a);
        
        Test.setCurrentPage(Page.UploadProof);
        ApexPages.currentPage().getParameters().put('Id',mObj1.ID);
        UploadProofController UPC = new UploadProofController();
        UPC.proof = a;
        UPC.saveFile();
        UPC.Cancel();
        
        UploadProofController UPC1 = new UploadProofController();
        UPC1.proof = new Attachment(Name = 'Attachment', Body = Blob.valueOf('Attachment Body'));
        UPC1.saveFile();
        
        mObj1.File_Submission_Count__c = 1;
        update mObj1;
        
        UploadProofController UPC3 = new UploadProofController();
        UPC3.proof = new Attachment(Name = 'Attachment', Body = Blob.valueOf('Attachment Body'));
        UPC3.saveFile();
        
        ApexPages.currentPage().getParameters().put('Id',null);
        UploadProofController UPC2 = new UploadProofController();
        UPC2.saveFile();
    }
}