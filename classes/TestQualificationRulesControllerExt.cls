@isTest
private class TestQualificationRulesControllerExt
{
    static testMethod void testSelectableFields()
    {
        List<String> availabileFields = new List<String>();
        for( Schema.SObjectField aField : Lead.getSObjectType().getDescribe().Fields.getMap().values() )
        {
            Schema.DescribeFieldResult fieldResult = aField.getDescribe();
            if( fieldResult.isUpdateable() )
            {
                availabileFields.add( fieldResult.getName() );
            }
        }

        Test.startTest();

            List<SelectOption> retrievedOptions = QualificationRulesControllerExt.selectableFields;

        Test.stopTest();

        //System.assertEquals( availabileFields.size(), retrievedOptions.size(), 'There should be as many options as there are fields to update' );
        Set<String> retrievedFields = new Set<String>();
        for( SelectOption anOption : retrievedOptions )
        {
            retrievedFields.add( anOption.getValue() );
        }
        for( String aFieldName : availabileFields )
        {
            System.assert( retrievedFields.contains( aFieldName ), 'Every available field should be found as an option' );
        }
    }

    static testMethod void testConstructor()
    {
        final Integer NUM_RULES = 10;

        Qualification__c testQualification = TestUtils.createQualifications( 1, true )[0];
        List<Qualification_Rule__c> testRules = TestUtils.createQualificationRules( NUM_RULES, testQualification.Id, true );

        ApexPages.StandardController standardController = new ApexPages.StandardController( testQualification );

        Test.startTest();

            QualificationRulesControllerExt customCont = new QualificationRulesControllerExt( standardController );

        Test.stopTest();

        System.assertEquals( NUM_RULES, customCont.rulesForQualification.size(), 'There should be as many wrappers as rules for the Qualification' );
        Set<Id> ruleIds = new Set<Id>();
        for( QualificationRulesControllerExt.RuleModel aWrapper : customCont.rulesForQualification )
        {
            ruleIds.add( aWrapper.record.Id );
        }
        for( Qualification_Rule__c aRule : testRules )
        {
            System.assert( ruleIds.contains( aRule.Id ), 'Every Rule for the Qualification should have been retrieved' );
        }
    }

    static testMethod void testAddRule()
    {
        Qualification__c testQualification = TestUtils.createQualifications( 1, true )[0];

        ApexPages.StandardController standardCont = new ApexPages.StandardController( testQualification );
        QualificationRulesControllerExt customCont = new QualificationRulesControllerExt( standardCont );

        Test.startTest();

            customCont.addRule();

        Test.stopTest();

        System.assertEquals( 1, customCont.rulesForQualification.size(), 'There should have been a new Rule wrapper added' );
    }

    static testMethod void testRuleModel_Constructor()
    {
        final List<String> ACCEPTED_VALUES = new List<String>{ 'asdf', 'sdkjf', '4234', 'asdlsd', 'someting' };

        Qualification_Rule__c testRule = TestUtils.createQualificationRules( 1, null, false )[0];
        testRule.Accepted_Values__c = String.join( ACCEPTED_VALUES, '|' );

        Test.startTest();

            QualificationRulesControllerExt.RuleModel aRuleModel = new QualificationRulesControllerExt.RuleModel( testRule );

        Test.stopTest();

        Set<String> retrievedValues = new Set<String>( aRuleModel.acceptedValues );
        for( String anAcceptdValue : ACCEPTED_VALUES )
        {
            System.assert( retrievedValues.contains( anAcceptdValue ) );
        }
    }

    static testMethod void testRuleModel_AddValue()
    {
        final String DUPE_VALUE = 'something';
        final List<String> VALUES_TO_ADD = new List<String>{ '1', 'asdf', 'someval', DUPE_VALUE };

        Qualification_Rule__c testRule = TestUtils.createQualificationRules( 1, null, false )[0];
        QualificationRulesControllerExt.RuleModel aRuleModel = new QualificationRulesControllerExt.RuleModel( testRule );

        Test.startTest();

            aRuleModel.incomingValues = String.join( VALUES_TO_ADD, QualificationRulesControllerExt.INCOMING_VALUE_DELIMITER );
            aRuleModel.addValues();

            System.assertEquals( VALUES_TO_ADD.size(), aRuleModel.acceptedValues.size(), 'There should be as many accepted values as were inputted' );

            aRuleModel.incomingValues = DUPE_VALUE;
            aRuleModel.addValues();

        Test.stopTest();

        System.assertEquals( VALUES_TO_ADD.size(), aRuleModel.acceptedValues.size(), 'Duplicates should not have been added to the list' );
        Set<String> retrievedValues = new Set<String>( aRuleModel.acceptedValues );
        for( String aValue : VALUES_TO_ADD )
        {
            System.assert( retrievedValues.contains( aValue ), 'Every accepted value should have been added to the list' );
        }
    }

    static testMethod void testRuleModel_DeleteValue()
    {
        final String VALUE_TO_DELETE = 'something';
        final List<String> EXISTING_VALUES = new List<String>{ VALUE_TO_DELETE, '123', 'asdf' };

        Qualification_Rule__c testRule = TestUtils.createQualificationRules( 1, null, false )[0];
        QualificationRulesControllerExt.RuleModel aRuleModel = new QualificationRulesControllerExt.RuleModel( testRule );
        aRuleModel.acceptedValues = EXISTING_VALUES.clone();

        Test.startTest();

            aRuleModel.valueToDelete = VALUE_TO_DELETE;
            aRuleModel.deleteValue();

        Test.stopTest();

        System.assertEquals( EXISTING_VALUES.size() - 1, aRuleModel.acceptedValues.size(), 'There should be one less value after a successful deletion' );
        Set<String> remainingValues = new Set<String>( aRuleModel.acceptedValues );
        for( String aValue : EXISTING_VALUES )
        {
            if( aValue != VALUE_TO_DELETE )
            {
                System.assert( remainingValues.contains( aValue ), 'Every value aside from the deleted value should still be presenet' );
            }
        }
    }

    static testMethod void testRuleModel_Save()
    {
        Qualification__c testQual = TestUtils.createQualifications( 1, true )[0];
        Qualification_Rule__c testRule = TestUtils.createQualificationRules( 1, testQual.Id, false )[0];
        QualificationRulesControllerExt.RuleModel aRuleModel = new QualificationRulesControllerExt.RuleModel( testRule );

        Test.startTest();

            aRuleModel.save();

        Test.stopTest();

        List<Qualification_Rule__c> createdRules = [ SELECT Id, Qualification__c FROM Qualification_Rule__c ];
        System.assertEquals( 1, createdRules.size(), 'There should only be the one created Rule in the system' );
        System.assertEquals( testQual.Id, createdRules[0].Qualification__c, 'The rule should have been created for the test Qualification' );
    }
    
    /*
        Method by  : Niket 
        Methods at : 10-Feb-2015 
    */
    static testMethod void testdeleteRule()
    {
        final Integer NUM_RULES = 10;

        Qualification__c testQualification = TestUtils.createQualifications( 1, true )[0];
        List<Qualification_Rule__c> testRules = TestUtils.createQualificationRules( NUM_RULES, testQualification.Id, true );

        ApexPages.StandardController standardController = new ApexPages.StandardController( testQualification );

        Test.startTest();

            QualificationRulesControllerExt  objQualificationExt = new QualificationRulesControllerExt( standardController );
            QualificationRulesControllerExt.RuleModel aRuleModel = new QualificationRulesControllerExt.RuleModel( testRules[0] );
            objQualificationExt.rulesForQualification.add(aRuleModel);
            objQualificationExt.deleteRule();
        Test.stopTest();
        
    }
    
    static testMethod void testdeleteRuleQualification()
    {
        final Integer NUM_RULES = 10;

        Qualification__c testQualification = TestUtils.createQualifications( 1, true )[0];
        List<Qualification_Rule__c> testRules = TestUtils.createQualificationRules( NUM_RULES, testQualification.Id, true );

        ApexPages.StandardController standardController = new ApexPages.StandardController( testQualification );

        Test.startTest();

            QualificationRulesControllerExt  objQualificationExt = new QualificationRulesControllerExt( standardController );
            QualificationRulesControllerExt.RuleModel aRuleModel = new QualificationRulesControllerExt.RuleModel( testRules[0] );
            Set<id> setId = new Set<Id>();
            setId.add(testRules[0].Id);
            
            objQualificationExt.deleteQualification(setId);
        Test.stopTest();
        
    }
}