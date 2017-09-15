@isTest
public class DealerUtilityPricingFileTest {

    private static testMethod void test_DealerUtilityCode() {
        DealerUtilityPricingFileTestData td = new DealerUtilityPricingFileTestData();    
        td.createTestData();

        Utility_Code__c utilityCode_1 = DealerUtilityPricingFileTestData.getNewUtilityCode('CA_ALAMEDA', 'CA', 'Alameda Municpal Power');  
        insert new List <Utility_Code__c>{utilityCode_1};

        // GRP_DEALER_UTILITY_CODE
        Dealer_Utility_Pricing_File__c dupf_1 = DealerUtilityPricingFileTestData.getNewDUPF(td.partnerAccount_1.Id, utilityCode_1.Id, null, null, 'pricing_file_1');
        insert new List <Dealer_Utility_Pricing_File__c>{dupf_1};

        system.assertEquals('pricing_file_1', DealerUtilityPricingFile.getPricingFile(td.account_1, 'CA_ALAMEDA_D1', null, null));            
    }

    private static testMethod void test_DealerUtilityState() {
        DealerUtilityPricingFileTestData td = new DealerUtilityPricingFileTestData();    
        td.createTestData();

        Utility_Code__c utilityCode_1 = DealerUtilityPricingFileTestData.getNewUtilityCode('CA_ALAMEDA', 'CA', 'Alameda Municpal Power');  
        insert new List <Utility_Code__c>{utilityCode_1};

        // GRP_DEALER_UTILITY_DESC_STATE
        Dealer_Utility_Pricing_File__c dupf_1 = DealerUtilityPricingFileTestData.getNewDUPF(td.partnerAccount_1.Id, null, 'CA', 'utility_1', 'pricing_file_1');
        insert new List <Dealer_Utility_Pricing_File__c>{dupf_1};

        system.assertEquals('pricing_file_1', DealerUtilityPricingFile.getPricingFile(td.account_1, 'CA_ALAMEDA_D1', 'CA', 'utility_1'));            
    }

    private static testMethod void test_UtilityCode() {
        DealerUtilityPricingFileTestData td = new DealerUtilityPricingFileTestData();    
        td.createTestData();

        Utility_Code__c utilityCode_1 = DealerUtilityPricingFileTestData.getNewUtilityCode('CA_ALAMEDA', 'CA', 'Alameda Municpal Power');  
        insert new List <Utility_Code__c>{utilityCode_1};

        // GRP_UTILITY_CODE
        Dealer_Utility_Pricing_File__c dupf_1 = DealerUtilityPricingFileTestData.getNewDUPF(null, utilityCode_1.Id, null, null, 'pricing_file_1');
        insert new List <Dealer_Utility_Pricing_File__c>{dupf_1};

        system.assertEquals('pricing_file_1', DealerUtilityPricingFile.getPricingFile(td.account_1, 'CA_ALAMEDA_D1', 'CA', 'utility_1'));            
    }

    private static testMethod void test_UtilityState() {
        DealerUtilityPricingFileTestData td = new DealerUtilityPricingFileTestData();    
        td.createTestData();

        Utility_Code__c utilityCode_1 = DealerUtilityPricingFileTestData.getNewUtilityCode('CA_ALAMEDA', 'CA', 'Alameda Municpal Power');  
        insert new List <Utility_Code__c>{utilityCode_1};

        // GRP_UTILITY_DESC_STATE
        Dealer_Utility_Pricing_File__c dupf_1 = DealerUtilityPricingFileTestData.getNewDUPF(null, null, 'CA', 'utility_1', 'pricing_file_1');
        insert new List <Dealer_Utility_Pricing_File__c>{dupf_1};

        system.assertEquals('pricing_file_1', DealerUtilityPricingFile.getPricingFile(td.account_1, 'CA_ALAMEDA_D1', 'CA', 'utility_1'));            
    }

    private static testMethod void test_DealerState() {
        DealerUtilityPricingFileTestData td = new DealerUtilityPricingFileTestData();    
        td.createTestData();

        Utility_Code__c utilityCode_1 = DealerUtilityPricingFileTestData.getNewUtilityCode('CA_ALAMEDA', 'CA', 'Alameda Municpal Power');  
        insert new List <Utility_Code__c>{utilityCode_1};

        // GRP_DEALER_STATE
        Dealer_Utility_Pricing_File__c dupf_1 = DealerUtilityPricingFileTestData.getNewDUPF(td.partnerAccount_1.Id, null, 'CA', null, 'pricing_file_1');
        insert new List <Dealer_Utility_Pricing_File__c>{dupf_1};

        system.assertEquals('pricing_file_1', DealerUtilityPricingFile.getPricingFile(td.account_1, 'CA_ALAMEDA_D1', 'CA', 'utility_1'));            
    }

    private static testMethod void test_State() {
        DealerUtilityPricingFileTestData td = new DealerUtilityPricingFileTestData();    
        td.createTestData();

        Utility_Code__c utilityCode_1 = DealerUtilityPricingFileTestData.getNewUtilityCode('CA_ALAMEDA', 'CA', 'Alameda Municpal Power');  
        insert new List <Utility_Code__c>{utilityCode_1};

        // GRP_STATE
        Dealer_Utility_Pricing_File__c dupf_1 = DealerUtilityPricingFileTestData.getNewDUPF(null, null, 'CA', null, 'pricing_file_1');
        insert new List <Dealer_Utility_Pricing_File__c>{dupf_1};

        system.assertEquals('pricing_file_1', DealerUtilityPricingFile.getPricingFile(td.account_1, 'CA_ALAMEDA_D1', 'CA', 'utility_1'));            
    }

    private static testMethod void test_NoMatch_NoUtilityCodes() {
        DealerUtilityPricingFileTestData td = new DealerUtilityPricingFileTestData();    
        td.createTestData();

        system.assertEquals(Label.CPRToABCFileName, DealerUtilityPricingFile.getPricingFile(td.account_1, 'CA_ANAHEIM', 'CA', 'utility_1'));            
    }

    private static testMethod void test_NoMatch() {
        DealerUtilityPricingFileTestData td = new DealerUtilityPricingFileTestData();    
        td.createTestData();

        Utility_Code__c utilityCode_1 = DealerUtilityPricingFileTestData.getNewUtilityCode('CA_IID', 'CA', 'Imperial Irrigation District (IID)');  
        insert new List <Utility_Code__c>{utilityCode_1};

        // GRP_STATE
        Dealer_Utility_Pricing_File__c dupf_1 = DealerUtilityPricingFileTestData.getNewDUPF(td.partnerAccount_1.Id, utilityCode_1.Id, 'CA', 'utility_1', 'pricing_file_1');
        insert new List <Dealer_Utility_Pricing_File__c>{dupf_1};

        system.assertEquals(Label.CPRToABCFileName, DealerUtilityPricingFile.getPricingFile(td.account_1, 'CA_ANAHEIM', 'CA', 'utility_2'));            
    }

}