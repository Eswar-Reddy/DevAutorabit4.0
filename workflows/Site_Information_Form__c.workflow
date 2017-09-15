<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>External_Project_Id_to_blank</fullName>
        <description>Pivotal: #140441237 When I clone a design, the SLA Time fields, the Revision Of, and the Roof Design fields should be blank</description>
        <field>External_Project_Id__c</field>
        <name>External Project Id to blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Internal_Project_Id_to_blank</fullName>
        <description>Pivotal: #140441237 When I clone a design, the SLA Time fields, the Revision Of, and the Roof Design fields should be blank</description>
        <field>Internal_Project_Id__c</field>
        <name>Internal Project Id to blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Site Created</fullName>
        <actions>
            <name>External_Project_Id_to_blank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Internal_Project_Id_to_blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Pivotal: #140441237 When I clone a site, the Internal &amp; External Aurora Id fields should be blank</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
