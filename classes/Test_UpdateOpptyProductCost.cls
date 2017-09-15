@isTest(seealldata=true)
Public class Test_UpdateOpptyProductCost
{
    static testmethod void UpdateOpptyProductCost()
    {
/***>>>> Start Creating Opportunities <<<<***/
        List<Opportunity> lstopp1 = new List<Opportunity>();
        //[SELECT Id, Name, Pricebook2Id,  AccountId FROM Opportunity where Pricebook2Id='01s80000000UtLb' AND recordtypeid = '01280000000PzRS' and CurrencyISOCode = 'USD' limit 5];
        for(integer i = 0; i < 5; i++)
        {
          Opportunity Opp = new Opportunity();
          Opp.name = 'For Test Class ' + i;
          Opp.recordtypeid = '01280000000PzRS';
          Opp.Pricebook2Id = '01s80000000UtLb';
          Opp.Contract_Type__c = 'Design';
          Opp.AccountID = '0018000000gpc4r';
          Opp.Business_Unit__c = 'RLC';
          Opp.RLC_Type__c = 'Residential';
          Opp.StageName = '01 - Assess Opportunity';
          Opp.CloseDate = date.newinstance(2012, 12, 26);
          lstopp1.add(Opp);
        }
        insert lstopp1;
/***>>>> End Creating Opportunities <<<<***/

/***>>>> Start Creating OpportunityLineItem<<<<***/
        List<OpportunityLineItem> lstOLI1 = new List<OpportunityLineItem>();
        Set<Id> lstPBIds = new Set<Id>();
        
        for(Opportunity opp : lstopp1)
        {
            lstPBIds.add(opp.Pricebook2Id);
        }
        
        List<PricebookEntry> LstPricebookEntry1 = new List<PricebookEntry>([SELECT Id, Name, Pricebook2id, Product2Id 
                                                                            FROM PricebookEntry 
                                                                            WHERE Pricebook2Id IN : lstPBIds 
                                                                            AND Pricebook2.name != '%Component%' 
                                                                            AND Product2.name like '%SPR-%' 
                                                                            AND Product2.Product_Type__c = 'PV Module' 
                                                                            AND CurrencyISOCode = 'USD'
                                                                            AND isActive = true
                                                                            limit 5]);
        for(Opportunity opp : lstopp1)
        {
            for(PricebookEntry pbe : LstPricebookEntry1)
            {
                integer i = 0;
                if(opp.Pricebook2Id == pbe.Pricebook2Id)
                {
                    OpportunityLineItem OLI = new OpportunityLineItem();
                    OLI.Opportunityid = opp.id;
                    OLI.PricebookEntryID = pbe.id;
                    OLI.TotalPrice = 60 + i;
                    OLI.Quantity = i + 1;
                    lstOLI1.add(OLI);
                    i++;
                }
            }
        }
        insert lstOLI1;
/***>>>> End Creating OpportunityLineItem<<<<***/

/***>>>> Start Creating Opportunities <<<<***/
        List<Opportunity> lstopp2 = new List<Opportunity>();
        //[SELECT Id, Name,Pricebook2Id, AccountId FROM Opportunity where Pricebook2Id = '01s80000000UyRK' AND recordtypeid = '01280000000PzRR' and CurrencyISOCode = 'USD' limit 5];
        for(integer i = 0; i < 5; i++)
        {
          Opportunity Opp = new Opportunity();
          Opp.name = 'For Test Class 2' + i;
          Opp.recordtypeid = '01280000000PzRR';
          Opp.Pricebook2Id = '01s80000000UyRK';
          Opp.Contract_Type__c = 'Design';
          Opp.AccountID = '0018000000UqM4b';
          Opp.Business_Unit__c = 'RLC';
          Opp.RLC_Type__c = 'Residential';
          Opp.StageName = '01 - Assess Opportunity';
          Opp.CloseDate = date.newinstance(2012, 12, 26);
          lstopp2.add(Opp);
        }
        insert lstopp2;
/***>>>> End Creating Opportunities <<<<***/

/***>>>> Start Creating OpportunityLineItem<<<<***/
        List<OpportunityLineItem> lstOLI2 = new List<OpportunityLineItem>();
        Set<Id> lstPBIds1 = new Set<Id>();
        
        for(Opportunity opp : lstopp2)
        {
            lstPBIds1.add(opp.Pricebook2Id);        
        }
        List<PricebookEntry> LstPricebookEntry2 = new List<PricebookEntry>([SELECT Id, Name, Pricebook2id, Product2Id 
                                                                            FROM PricebookEntry WHERE Pricebook2Id IN:lstPBIds1 
                                                                            AND Pricebook2.name Like '%Comp%' 
                                                                            and Product2.name like '%SPR-%' 
                                                                            and Product2.Product_Type__c = 'PV Module' 
                                                                            and CurrencyISOCode = 'USD' and IsActive = True limit 5]);
        for(Opportunity opp : lstopp2)
        {
            for(PricebookEntry pbe : LstPricebookEntry2)
            {
                integer i=0;
                if(opp.Pricebook2Id == pbe.Pricebook2Id)
                {
                    OpportunityLineItem OLI = new OpportunityLineItem();
                    OLI.Opportunityid = opp.id;
                    OLI.PricebookEntryID = pbe.id;
                    OLI.TotalPrice = 50 + i;
                    OLI.Quantity = i + 2;
                    lstOLI2.add(OLI);
                    i++;
                }
            }
        }
        insert lstOLI2;
/***>>>> End Creating OpportunityLineItem<<<<***/
    }
}