<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Tax_Rate_Formula_to_Percent</fullName>
        <field>Final_Tax_Rate__c</field>
        <formula>Tax_Rate__c</formula>
        <name>Update Tax Rate Formula to Percent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Populate Tax Rate</fullName>
        <actions>
            <name>Update_Tax_Rate_Formula_to_Percent</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lease_Schedule__c.Tax_Rate__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
