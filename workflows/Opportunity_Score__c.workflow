<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Score_Updates</fullName>
        <field>Total_Opportunity_Score__c</field>
        <formula>Category_Score_Formulea__c</formula>
        <name>Score Updates</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Score_per_record</fullName>
        <actions>
            <name>Score_Updates</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This WF will update total score on each record of Oppty score during score card filled and save.</description>
        <formula>NOT(ISNULL( Category_Value_Score__r.Id ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
