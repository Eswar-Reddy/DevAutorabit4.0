public class TestSunriseMetricManagement{ 

@isTest
public static void checkMetricInsert(){
    Date dt = date.newinstance(2006,1,1);
    Date dt1 = date.newinstance(2006,12,30);
    
    //P1 Dates
    Integer yr = Date.Today().Year();
    Date dt4 = date.newinstance(yr,7,4);
    Date dt5 = date.newinstance(yr-1,12,1);
    Date dt6 = date.newinstance(yr,7,31);
    Date dt7 = date.newinstance(yr,1,4);
    
    //P2 Dates    
    Date dt42 = date.newinstance(yr+1,1,3);
    Date dt52 = date.newinstance(yr,06,1);
    Date dt62 = date.newinstance(yr+1,1,31);
    Date dt72 = date.newinstance(yr,7,5);
    
    Tier__c t1 = new Tier__c(Country__c='USA',Tier_Name__c='Premier');
    insert t1;
    
    Account acc = new Account(name='TestMetric123',type = 'Premier-Partner-Combo',CurrencyIsoCode='USD',Country_Domain__c ='rvar-us',Theater__c='North America',Authorized_Partner_Date__c=dt,Promoted_Premier_Date__c=dt1,BillingCountry ='abc',BillingStreet='abc',BillingCity ='xyz',BillingPostalCode='908',Oracle_Account_Number__c='140x');
    insert acc;
    
    //P1 data
    Performance_Metric__c p = new Performance_Metric__c(channel__c='Residential',Peformance_Metric_Name__c='USA1-Jan2010_to_Jun2010',Country__c='USA',Thea__c='North America',Performance_Period_Start_Date__c= dt7,Performance_period_End_date__c =dt4 ,Metric_Setup_Cut_off_Date__c =dt5,Performance_Evaluation_Cut_off_Date__c =dt6 );
    insert p;
    
    List<Metric_Tier_Relation__c> lstMTR1 = new List<Metric_Tier_Relation__c>();
    Metric_Tier_Relation__c mtr1 = new Metric_Tier_Relation__c(Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='MarketingMetricLabel',Category__c='Marketing',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
    lstMTR1.add(mtr1);
    Metric_Tier_Relation__c mtr11 = new Metric_Tier_Relation__c(Boolean_Metric_Y_N__c=true, Performance_Metric__c =p.Id,Tier__c =t1.Id,Metric_Label__c='MarketingMetricLabel',Category__c='Marketing',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
    lstMTR1.add(mtr11);
    insert lstMTR1;
        
    List<Metric__c> lstM1 = new List<Metric__c>();
    Metric__c mObj1 = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mtr1.Id,Achievement_Value__c=1,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Goal_Met__c= TRUE);
    lstM1.add(mObj1);
    Metric__c mObj11 = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mtr11.Id,Achievement_Value__c=1,Performance_Metric__c=p.id,CurrencyIsoCode = 'USD',Goal_Met__c= TRUE);
    lstM1.add(mObj11);
    insert lstM1;
    
    Attachment att = new Attachment(parentID=mObj1.ID,name='test',body=blob.valueof('testBody'));
    insert att;
    
    //P2 data
    Performance_Metric__c p2 = new Performance_Metric__c(channel__c='Residential',Peformance_Metric_Name__c='USA1-Jul2010_to_Dec2010',Country__c='USA',Thea__c='North America',Performance_Period_Start_Date__c= dt72,Performance_period_End_date__c =dt42 ,Metric_Setup_Cut_off_Date__c =dt52,Performance_Evaluation_Cut_off_Date__c =dt62 );
    insert p2;
    
    List<Metric_Tier_Relation__c> lstMTR2 = new List<Metric_Tier_Relation__c>();
    Metric_Tier_Relation__c mtr2 = new Metric_Tier_Relation__c(Performance_Metric__c =p2.Id,Tier__c =t1.Id,Metric_Label__c='MarketingMetricLabel',Category__c='Marketing',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
    lstMTR2.add(mtr2);
    Metric_Tier_Relation__c mtr22 = new Metric_Tier_Relation__c(Boolean_Metric_Y_N__c=true, Performance_Metric__c =p2.Id,Tier__c =t1.Id,Metric_Label__c='MarketingMetricLabel',Category__c='Marketing',Stay_Tier__c=true,Sequence_Order__c =1,Metric_Input_Type__c='Manual',Benefit_Tier__c=TRUE);
    lstMTR2.add(mtr22);
    insert lstMTR2;
  
    List<Metric__c> lstM2 = new List<Metric__c>();
    Metric__c mObj2 = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mtr2.Id,Achievement_Value__c=0,Performance_Metric__c=p2.id,CurrencyIsoCode = 'USD',Goal_Met__c= False);
    lstM2.add(mObj2);
    Metric__c mObj22 = new Metric__c(Account__c=acc.Id,Metric_Tier_Relation__c=mtr22.Id,Achievement_Value__c=0,Performance_Metric__c=p2.id,CurrencyIsoCode = 'USD',Goal_Met__c= False);
    lstM2.add(mObj22);
    insert lstM2;
    
}

}