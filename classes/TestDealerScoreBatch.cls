@isTest
public class TestDealerScoreBatch {
    
    static TestMethod void testScheduler() {
        
        List<Dealer_Scoring__c> settings = new List<Dealer_Scoring__c>();
        		Dealer_Scoring__c score1 = new Dealer_Scoring__c(name='SS-00001',Field_Label__c='Contact SLA',Filter_Field__c='Theater__c',
                  Filter_Value__c='Central America and the Caribbean',Score_Value__c=20,Field_Name__c='Contact_SLA__c',Sort_Order__c='C',Calculation_Type__c='Percent');
        settings.add(score1);
                Dealer_Scoring__c score2 = new Dealer_Scoring__c(name='SS-00002',Field_Label__c='SFDC Timely Updates',Filter_Field__c='Theater__c',
                  Filter_Value__c='Central America and the Caribbean',Score_Value__c=30,Field_Name__c='SFDC_Timely_Updates__c',Sort_Order__c='D',Calculation_Type__c='Percent');
        settings.add(score2);
                Dealer_Scoring__c score3 = new Dealer_Scoring__c(name='SS-00003',Field_Label__c='Dealer Tier',Field_Value__c='Authorized',
                  Score_Value__c=5,Field_Name__c='Dealer_Tier__c',Sort_Order__c='A',Calculation_Type__c='Text');
        settings.add(score3);
                Dealer_Scoring__c score4 = new Dealer_Scoring__c(name='SS-00004',Field_Label__c='Dealer Tier',Field_Value__c='Master',
                  Score_Value__c=20,Field_Name__c='Dealer_Tier__c',Sort_Order__c='A',Calculation_Type__c='Text');
        settings.add(score4);
                Dealer_Scoring__c score5 = new Dealer_Scoring__c(name='SS-00005',Field_Label__c='SFDC Timely Updates',Filter_Field__c='Theater__c',
                  Filter_Value__c='North America',Score_Value__c=30,Field_Name__c='SFDC_Timely_Updates__c',Sort_Order__c='D',Calculation_Type__c='Percent');
        settings.add(score5);
        		Dealer_Scoring__c score6 = new Dealer_Scoring__c(name='SS-00006',Field_Label__c='Dealer Tier',Field_Value__c='Elite',
                  Score_Value__c=15,Field_Name__c='Dealer_Tier__c',Sort_Order__c='A',Calculation_Type__c='Text');
        settings.add(score6);
        		Dealer_Scoring__c score7 = new Dealer_Scoring__c(name='SS-00007',Field_Label__c='Contact SLA',Filter_Field__c='Theater__c',
                  Filter_Value__c='North America',Score_Value__c=20,Field_Name__c='Contact_SLA__c',Sort_Order__c='C',Calculation_Type__c='Percent');
        settings.add(score7);
        		Dealer_Scoring__c score8 = new Dealer_Scoring__c(name='SS-00008',Field_Label__c='Opp Closed Won Rate',
                  Score_Value__c=20,Field_Name__c='Opp_Convert_Rate__c',Sort_Order__c='B',Calculation_Type__c='Percent');
        settings.add(score8);
        		Dealer_Scoring__c score9 = new Dealer_Scoring__c(name='SS-00009',Field_Label__c='Dealer Tier',Field_Value__c='Premier',
                  Score_Value__c=10,Field_Name__c='Dealer_Tier__c',Sort_Order__c='A',Calculation_Type__c='Text');
        settings.add(score9);
          
        insert settings;

        TestALRCommon.CreateCustomSetting();
        
        Account partner = TestClassFactory.CreateDealer('TestdealerName', 'North America');
            
        String CRON_EXP = '0 0 0 15 3 ? 2022';
        Test.startTest();
        String jobId = System.schedule('SomeTestJobName', CRON_EXP, new scheduleUpdateScores());
        Test.stopTest();        
    }

}