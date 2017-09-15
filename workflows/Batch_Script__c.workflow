<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>batchscriptcheckbox</fullName>
        <field>Batch_Script_Run__c</field>
        <literalValue>1</literalValue>
        <name>Batch Script Checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>BatchScriptWorkflow</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Batch_Script__c.Batch_Script_Run__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>To update fields after every 7 days</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
