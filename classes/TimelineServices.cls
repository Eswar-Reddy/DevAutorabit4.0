public with sharing class TimelineServices {
    public static String AGREEMENT_RECORD_TYPE_NAME = 'Lease_Contract';
    public static final String AGREEMENT_STATUS = 'Signed';
    public static final String ACTIVE_STATUS = 'Active';
    public static final String DELIMITER = '-';

    public static RecordType leaseContactRecordType {
        get {
            if(leaseContactRecordType == null) {
                leaseContactRecordType = [
                    SELECT Id
                    FROM RecordType
                    WHERE SobjectType = 'echosign_dev1__SIGN_Agreement__c'
                        AND DeveloperName = :AGREEMENT_RECORD_TYPE_NAME
                        AND IsActive = true
                ];
            }
            return leaseContactRecordType;
        }
        private set;
    }

    public static Account partnerAccount {
        get {
            if( partnerAccount == null) {
                partnerAccount = [SELECT BillingCountry FROM Account WHERE Id = :partnerAccountId][0];
            }
            return partnerAccount;
        }
        private set;
    }

    public static Id partnerAccountId {
        get {
            if(partnerAccountId == null) {
                partnerAccountId = [SELECT Contact.AccountId FROM User WHERE Id = :UserInfo.getUserId()][0].Contact.AccountId;
            }
            return partnerAccountId;
        }
        private set;
    }

    public static Map<String, echosign_dev1__SIGN_Agreement__c> getAccountIdToAgreement(Set<Id> accountIds, Set<String> recordTypes) {
        List<echosign_dev1__SIGN_Agreement__c> agreements = [
            SELECT Id, echosign_dev1__Document__c, Account__c, echosign_dev1__Status__c, echosign_dev1__LastEventId__c, RecordType.DeveloperName,
                (
                SELECT Id, Name
                FROM Attachments
                ORDER BY CreatedDate DESC
                )
            FROM echosign_dev1__SIGN_Agreement__c
            WHERE RecordType.DeveloperName IN :recordTypes
                AND echosign_dev1__Status__c = :AGREEMENT_STATUS
                AND Account__c IN :accountIds
            ORDER BY CreatedDate DESC
        ];

        Map<String, echosign_dev1__SIGN_Agreement__c> accountIdToAgreement = new Map<String, echosign_dev1__SIGN_Agreement__c>();
        for(echosign_dev1__SIGN_Agreement__c agreement : agreements) {
            String key = buildAccountAgreementKey(agreement.Account__c, agreement.RecordType.DeveloperName);

            if(!accountIdToAgreement.containsKey(key)) {
                accountIdToAgreement.put(key, agreement);
            }
        }
        return accountIdToAgreement;
    }

    public static String buildAccountAgreementKey(Id accountId, String agreementRecordType)
    {
        return (accountId + DELIMITER + agreementRecordType);
    }
}