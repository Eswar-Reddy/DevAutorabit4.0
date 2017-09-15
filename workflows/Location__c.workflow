<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Copy_Name_in_Zip_Code</fullName>
        <field>ZipCode__c</field>
        <formula>Name</formula>
        <name>Copy Name in Zip Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Zip_Code_in_Name</fullName>
        <field>Name</field>
        <formula>ZipCode__c</formula>
        <name>Copy Zip Code in Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Copy Name in Zip Code</fullName>
        <actions>
            <name>Copy_Name_in_Zip_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copy Name in ZipCode when a location record is created from sfdc layout.</description>
        <formula>ISBLANK( ZipCode__c ) || Name != PRIORVALUE(Name)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy Zip Code in Name</fullName>
        <actions>
            <name>Copy_Zip_Code_in_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copy Zip Code values in Name for the records inserted using script.</description>
        <formula>Name = Id &amp;&amp; NOT(ISBLANK( ZipCode__c) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
