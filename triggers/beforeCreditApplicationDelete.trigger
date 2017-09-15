// Created for Sunpower Case # 00029855
trigger beforeCreditApplicationDelete on Credit_Application__c (before delete) {
    // No one can delete a CA
    for (Credit_Application__c creApp : Trigger.old) {
        creApp.addError('CA record cannot be deleted.');
    }
}