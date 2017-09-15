<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Response_Date_Creation</fullName>
        <description>This email update will update the response date field with today&apos;s date , whenever the status changes to approved or rejected.</description>
        <field>Response_Date__c</field>
        <formula>today()</formula>
        <name>Response Date Creation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Response Date Origination Docs</fullName>
        <actions>
            <name>Response_Date_Creation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Origination_Document__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved,Rejected</value>
        </criteriaItems>
        <description>When a Sunpower approver changes the status of an origination doc to &quot;approved&quot; or &quot;rejected&quot;, this workflow rule will fire an email update (and today&apos;s date will be stamped on the response date field).</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
