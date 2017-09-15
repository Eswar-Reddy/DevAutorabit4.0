@isTest
private class SobjectServiceTest {
  /*  static testMethod void selectStarTest() {
        List<Account> accounts = TestUtils.createAccounts(2, true);

        Test.startTest();
            List<Account> queriedAccounts = (List<Account>)SobjectService.selectStar(accounts);
        Test.stopTest();

        System.assertEquals(2, queriedAccounts.size(), 'The number of accounts we get back should match the number of accounts we put in');

        for(Integer i = 0; i < accounts.size(); i++) {
            Account account = accounts[i];
            Account queriedAccount = queriedAccounts[i];

            System.assertEquals(account.Id, queriedAccount.Id, 'The query should retain the correct record positions');
            System.assertEquals(account.Name, queriedAccount.Name, 'The name field should be pulled down, and matching');
        }
    }

    static testMethod void massSetTest() {
        final String ORIGINAL_ACCOUNT_NAME = 'Kenny';
        final String ACCOUNT_NAME = 'Coldplay';

        Account accountRecord = TestUtils.createAccounts(1, false)[0];
        accountRecord.Name = ORIGINAL_ACCOUNT_NAME;

        Test.startTest();
            SobjectService.massSet(new List<Account>{accountRecord}, Account.Name, ACCOUNT_NAME);
        Test.stopTest();

        System.assertEquals(ACCOUNT_NAME, accountRecord.Name, 'The account name should have been set');
    }

    static testMethod void massAppendTest() {
        final String ACCOUNT_NAME = 'Macklemore';
        final String SUFFIX = ' & Ryan Lewis';

        Account accountRecord = TestUtils.createAccounts(1, false)[0];
        accountRecord.Name = ACCOUNT_NAME;

        Test.startTest();
            SobjectService.massAppend(new List<Account>{accountRecord}, Account.Name, SUFFIX);
        Test.stopTest();

        System.assertEquals(ACCOUNT_NAME+SUFFIX, accountRecord.Name, 'The account name should have been appended with the suffix.');
    }

    static testMethod void massCopyFieldTest() {
        final String COPY_FROM_NAME = 'D-12';

        Account copiedFromAccount = TestUtils.createAccounts(1, false)[0];
        copiedFromAccount.Name = COPY_FROM_NAME;
        Account copiedToAccount = TestUtils.createAccounts(1, false)[0];
        copiedToAccount.Sic = 'Kanye West';

        Test.startTest();
            SobjectService.massCopyField(new List<Account>{copiedFromAccount}, Account.Name, new List<Account>{copiedToAccount}, Account.Sic);
        Test.stopTest();

        System.assertEquals(COPY_FROM_NAME, copiedToAccount.Sic, 'The copied from name should have been copied to the account Sic.');
    }

    static testMethod void createSobjects() {
        final Integer N = 10;

        Test.startTest();
            List<Sobject> records = SobjectService.createSobjects(Account.SobjectType, N);
        Test.stopTest();

        System.assertEquals(N, records.size(), 'The number of records created should match');
        for(Sobject record : records) {
            System.assertEquals(Account.SobjectType, record.getSobjectType(), 'The sobject type should be the right one');
        }
    }

    static testMethod void copyFields() {
        Map<String, String> mapping = new Map<String, String>
            { 'Name' => 'Name'
            };
        Account a = new Account(Name = 'Cornel West');
        Account b = new Account();

        Test.startTest();
            SobjectService.copyFields(mapping, new List<Sobject>{b}, new List<Sobject>{a});
        Test.stopTest();

        System.assertEquals(a.Name, b.Name, 'The field should get copied');
    }

    static testMethod void initWithFields_id() {
        Map<String, String> mapping = new Map<String, String>
            { 'Id' => 'Id'
            };
        Account a = new Account(Id = '001000000000000AAA');

        Test.startTest();
            Sobject actual = SobjectService.initWithFields(mapping, a, Account.SobjectType);
        Test.stopTest();

        System.assertEquals(a.Id, actual.Id, 'The field should get copied');
    }

    static testMethod void initWithFields_otherField() {
        Map<String, String> mapping = new Map<String, String>
            { 'Name' => 'Name'
            };
        Account a = new Account(Name = 'Cornel West');

        Test.startTest();
            Sobject actual = SobjectService.initWithFields(mapping, a, Account.SobjectType);
        Test.stopTest();

        System.assertEquals(a.Name, actual.get('Name'), 'The field should get copied');
    }

    static testMethod void getAssignmentMap() {
        Contact c = new Contact
            ( FirstName = 'Thomas'
            , LastName = 'Dziedzic'
            );

        Test.startTest();
            Map<String, String> assignmentMap = SobjectService.getAssignmentMap(new List<Sobject>{c}, Contact.FirstName, Contact.LastName);
        Test.stopTest();

        Map<String, String> expected = new Map<String, String>
            { c.FirstName => c.LastName
            };
        System.assertEquals(expected, assignmentMap, 'The map should match');
    }

    static testMethod void filterSobjects() {
        Account a = new Account(Id = '001000000000000AAA');
        Account b = new Account(Id = '001000000000001AAA');

        Test.startTest();
            List<Sobject> filtered = SobjectService.filterSobjects(new List<Sobject>{a, b}, new Set<Id>{a.Id});
        Test.stopTest();

        System.assertEquals(1, filtered.size(), 'Only one account is expected to pass the filter');
        System.assertEquals(a.Id, filtered[0].Id, 'The correct account should be pulled back');
    }  */
}