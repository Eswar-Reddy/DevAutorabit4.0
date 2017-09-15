<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Record_Type_to_Job_Checkout_Form</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Job_Checkout_Form</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type to Job Checkout Form</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_to_Job_HazardAnalysis</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Job_Hazard_Analysis</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type to Job HazardAnalysis</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_to_Site_Survey_Form</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Site_Survey_Form</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type to Site Survey Form</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Form Record Type - Job Checkout Form</fullName>
        <actions>
            <name>Update_Record_Type_to_Job_Checkout_Form</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Form__c.Form_Record_Type__c</field>
            <operation>equals</operation>
            <value>Job Checkout Form</value>
        </criteriaItems>
        <description>Update RecordType with Record_Type__c value</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Form Record Type - Job Hazard Analysis</fullName>
        <actions>
            <name>Update_Record_Type_to_Job_HazardAnalysis</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Form__c.Form_Record_Type__c</field>
            <operation>equals</operation>
            <value>Job Hazard Analysis</value>
        </criteriaItems>
        <description>Update RecordType with Record_Type__c value</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Form Record Type - Site Survey Form</fullName>
        <actions>
            <name>Update_Record_Type_to_Site_Survey_Form</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Form__c.Form_Record_Type__c</field>
            <operation>equals</operation>
            <value>Site Survey Form</value>
        </criteriaItems>
        <description>Update RecordType with Record_Type__c value</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
