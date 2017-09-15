<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>OraclePVSImId_update</fullName>
        <description>Update Oracle PVSImID</description>
        <field>OraclePVSimId__c</field>
        <formula>Item_ID__c</formula>
        <name>OraclePVSImId update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update OraclePVSIMID</fullName>
        <actions>
            <name>OraclePVSImId_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>populates Oraclepvsimid with a oracleitem id. This field will be manually populated with oracle and pvsim combo for 208V</description>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
