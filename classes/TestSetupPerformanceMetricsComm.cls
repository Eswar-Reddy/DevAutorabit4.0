@isTest
private class TestSetupPerformanceMetricsComm{

  private static testMethod void myTest1(){
    Date dt = date.newinstance(2006,1,1);
    Date dt1 = date.newinstance(2006,12,30);
    Date dt4 = date.newinstance(2010,7,4);
    Date dt5 = date.newinstance(2009,12,1);
    Date dt6 = date.newinstance(2010,7,31);
    Date dt7 = date.newinstance(2010,1,4);
    Performance_Metric__c p = new Performance_Metric__c(channel__c='Commercial',Peformance_Metric_Name__c='USA1-Jan2010_to_Jun2010',Country__c='USA',Thea__c='North America',Performance_Period_Start_Date__c= dt7,Performance_period_End_date__c =dt4 ,Metric_Setup_Cut_off_Date__c =dt5,Performance_Evaluation_Cut_off_Date__c =dt6 );
    insert p;
    
    Tier__c t1 = new Tier__c(Country__c='USA',Tier_Name__c='Premier');
    insert t1; 
    
    Metric_Tier_Relation__c mtr1 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Homeowner customer satisfaction score',Category__c='Customer Satisfaction',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE, isRSMView__c=true);
    insert mtr1;
    
    Metric_Tier_Relation__c mtr2 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Bonus for Extra Training - No. certified for Adv. Design ',Category__c='Training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE, isRSMView__c=true);
    insert mtr2;
    
    Metric_Tier_Relation__c mtr3 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Bonus for Meeting 6 Month Revenue Target ',Category__c='Performance to Business Plan',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE, isRSMView__c=true);
    insert mtr3;
    
    Metric_Tier_Relation__c mtr4 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Bonus for SmartPack Usage ',Category__c='All SPWR solutions',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE, isRSMView__c=true);
    insert mtr4;
    
    Metric_Tier_Relation__c mtr5 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='SunPower Dealer Webpage and Logo Usage ',Category__c='Marketing',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE, isRSMView__c=true);
    insert mtr5;
    
    Metric_Tier_Relation__c mtr6 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Customer Complaints ',Category__c='Customer Satisfaction',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE, isRSMView__c=false);
    insert mtr6;
    
    Metric_Tier_Relation__c mtr7 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='SunPower installations Registered ',Category__c='Customer Satisfaction',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE, isRSMView__c=false);
    insert mtr7;
    
    Metric_Tier_Relation__c mtr8 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Residential Installation Inspections ',Category__c='training',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE, isRSMView__c=false);
    insert mtr8;
    
    Metric_Tier_Relation__c mtr9 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='Opportunity Close rate for SunPower Opportunities ',Category__c='performance to business plan',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE, isRSMView__c=false);
    insert mtr9;
    
    Metric_Tier_Relation__c mtr10 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='greater than 70 of  Residential sales are systems ',Category__c='All SPWR solutions',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Automated',Benefit_Tier__c=TRUE, isRSMView__c=false);
    insert mtr10;
        
    ApexPages.StandardController stdController = new ApexPages.StandardController(p);
    
    SetupPerformanceMetricsComm controller = new SetupPerformanceMetricsComm(stdController);
    
    Apexpages.CurrentPage().getParameters().put('id', p.Id);
    controller = new SetupPerformanceMetricsComm(stdController);
    
    Boolean isChkFld = controller.getIsAllowedChkFields();
    Boolean isPermittedforRSM = controller.getPermittedForRSMTab();
    Boolean isPermittedforOthers = controller.getPermittedForOthers();
    
    controller.goToperformanceEvalPage();
    controller.saveObj();
    
    controller.getShowAccountView();
    controller.updateRSMRows();
    controller.saveMarketingObj();
    controller.getFreezeRSMMetric();
    controller.getMarketAddRow();
    controller.getFreezeMetric();
    controller.addMarketingRow();
  }
}