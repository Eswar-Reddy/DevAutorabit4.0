<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_e_singnature</fullName>
        <field>e_Signature_Message__c</field>
        <formula>&apos;Please sign the SunPower Lease Dealer Participation Agreement. A countersigned copy will be sent to you via EchoSign for good standing order of your records.&apos;</formula>
        <name>Update e-singnature</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_sunpower_executive</fullName>
        <field>SunPower_Executive__c</field>
        <lookupValue>martin.debono@sunpowercorp.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Update sunpower executive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>When contract type is NA Lease Program Participation Agreement</fullName>
        <actions>
            <name>Update_e_singnature</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_sunpower_executive</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contract_Reference__c.Name</field>
            <operation>equals</operation>
            <value>NA Lease Program Participation Agreement</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
