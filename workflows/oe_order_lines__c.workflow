<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>System_Size</fullName>
        <field>System_Size__c</field>
        <formula>System_Size_Formula__c</formula>
        <name>System Size</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>System Size Update</fullName>
        <actions>
            <name>System_Size</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF(ISCHANGED( System_Size_Formula__c )|| (System_Size__c!=System_Size_Formula__c) || ISNEW() ,True,false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
