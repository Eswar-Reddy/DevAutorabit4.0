<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>TPO_Module_Qty_Unique</fullName>
        <field>Unique_Module_Name_Qty__c</field>
        <formula>Text(Module_Name__c)&amp; Text( Module_Quantity__c )</formula>
        <name>TPO Module Qty Unique</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>TPO Module Qty Unique</fullName>
        <actions>
            <name>TPO_Module_Qty_Unique</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>TPO_MPPT__c.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>TPO_MPPT__c.Module_Quantity__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
