<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Utility_Code_External_Id</fullName>
        <description>Case# 00543268 - Enforce unique utility code - Arokia Nathan</description>
        <field>External_Id__c</field>
        <formula>Name</formula>
        <name>Set Utility Code External Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set Utility Code External Id</fullName>
        <actions>
            <name>Set_Utility_Code_External_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Utility_Code__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Case# 00543268 - Enforce unique utility code - Arokia Nathan</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
