@isTest(SeeAllData=true)
private class Test_Test_Indentation
{
    public static Global_Dealer_Program__c newGdp = new Global_Dealer_Program__c();
    public static List<Metric_Template__c> newMT = new List<Metric_Template__c>();
    public static List<Metrics__c> newMetrics = new List<Metrics__c>();
    public static List<Account> newAcc = new List<Account>();
    public static List<SelectOption> lst_AccOption = new List<SelectOption>();
    static testMethod void OverrideDataforNewPeriod()
    {
        Create_Global_Dealer_Programs('P1',2012);
        if(!newAcc.isEmpty())
        {
            for(Account ac: newAcc)
            {
             lst_AccOption.add(new Selectoption(ac.Id,ac.Name));
            }
        
        }
        Test.StartTest();
        PageReference pageRef = Page.Test_Indentation;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(newGdp);        
        Test_Indentation cd = new Test_Indentation(sc);
        List<SelectOption> propaccList = cd.getprop_accList();
        propaccList = lst_AccOption;
        cd.setprop_accList(propaccList);
        String propaccsel = cd.getprop_acctSelected();
        propaccsel = lst_AccOption.get(0).getvalue();
        cd.setprop_acctSelected(propaccsel);
        List<SelectOption>  propallist = cd.getprop_alphaList();
        String propalphasel = cd.getprop_alphaSelected();
        propalphasel = 'A';
        cd.setprop_alphaSelected(propalphasel);     
        cd.showMetrics();
        cd.saveMetrics();   
        cd.setDisable();
        Test.StopTest();
    }   
    static void Create_Global_Dealer_Programs(String str_loPeriod,Integer int_currYear)
    {// Loop To iterate over each Global Dealer Program that belongs to Period 1 to copy the data into the new Global Dealer Program
      Id AccRecId = [select id from RecordType where sObjectType='Account' and IsActive=true and Name='Partner'].id;

        newGdp = new Global_Dealer_Program__c(Account_Type__c = 'Authorized-Partner-Combo, Authorized-Partner-Residential',
                    Country_Domain__c='rvar-us, combo-us',  
                    Performance_Year__c = int_currYear,
                    Performance_Period__c = str_loPeriod,
                    Countries_Supported__c = 'United States',
                    Data_Load_Identifier__c = 'TestGDP'+Math.random());    
         insert newGdp;
         for(Integer i=0;i<10;i++)
         {
            newMT.add(new Metric_Template__c(Global_Dealer_Program__c=  newGdp.id,
                                            Metric_Category__c = 'Performance to Business Plan',
                                            Metric_Code__c = 'BP_AEU_006',
                                            Metric_External_ID__c =  'TestMT'+Math.random(),
                                            Metric_Name__c =  'Period Minimum Sales',
                                            Metric_Parent_Code__c= 'BP_AEU_012',
                                            Where_to_Display__c='METRIC',
                                            Metric_Order__c = i));
         }
         if(!newMT.isEmpty())
         {
            insert newMT;
            for(Integer j=0;j<10;j++)
            {
                newAcc.add(new Account(RecordTypeid = AccRecId,Name = 'ATestAccount'+j,Type = 'Authorized-Partner-Combo',Country_Domain__c = 'combo-us',
                                        BillingCountry='United States', BillingCity= 'San Francisco',BillingPostalCode = '94139',
                                        BillingStreet = 'Po Box', BillingState = 'CA',ShippingCountry='Italy', ShippingCity= 'Rome', ShippingPostalCode = '94139',
                                       ShippingStreet = 'Po Box', ShippingState = 'Rome'));
            }
            if(!newAcc.isEmpty())
            {
                insert newAcc;
                for(Account a : newAcc)
                {
                    for(Metric_Template__c mt : newMT)
                    {
                         newMetrics.add(new Metrics__c(Account__c = a.id,
                                        External_Id__c = 'TestEX'+Math.random(), //Generating External Id
                                        Metric_Template__c= mt.id));
                    }
                }
                if(!newMetrics.isEmpty())
                {
                    insert newMetrics;  
                }
            }
         }
    }//END FUNC Create_Global_Dealer_Programs
}