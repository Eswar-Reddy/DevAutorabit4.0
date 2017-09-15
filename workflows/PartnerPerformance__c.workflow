<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Record_Type_to_Submitted</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Submitted_Partner_Performance</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type to Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Partner Performance Submitted</fullName>
        <actions>
            <name>Update_Record_Type_to_Submitted</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Partner_Performance_Review_Completed</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PartnerPerformance__c.Submit_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Partner_Performance_Review_Completed</fullName>
        <assignedToType>owner</assignedToType>
        <description>Notify the Partner account owner that the partner performance review has been completed.  Review the partner performance score to consider the partner for promotion or demotion.</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Partner Performance Review Completed</subject>
    </tasks>
</Workflow>
