<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Communication_Sent_Date</fullName>
        <description>Communication Sent Date</description>
        <field>Communication_Sent_Date__c</field>
        <formula>TODAY()</formula>
        <name>Communication Sent Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mark_to_delete_attachment</fullName>
        <field>Delete_Attachment__c</field>
        <literalValue>1</literalValue>
        <name>Mark to delete attachment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Communication Sent Date</fullName>
        <actions>
            <name>Communication_Sent_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SOA2TransactionDetails__c.Communication_Sent__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Communication Sent Date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SOA2_Delete PDF Transaction Files</fullName>
        <active>true</active>
        <criteriaItems>
            <field>SOA2TransactionDetails__c.Transaction_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Workflow will update the flag to delete the attachment and related SOA2transactiondetail records after 2 year of transaction date</description>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Mark_to_delete_attachment</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>SOA2TransactionDetails__c.Transaction_Date__c</offsetFromField>
            <timeLength>730</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
