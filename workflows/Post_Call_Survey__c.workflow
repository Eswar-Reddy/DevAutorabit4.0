<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>No_Response_Received_Issue_Resolution</fullName>
        <field>Survey_Status__c</field>
        <literalValue>No Response Received</literalValue>
        <name>No Response Received Issue Resolution</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>No Response Received</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Post_Call_Survey__c.Survey_Status__c</field>
            <operation>equals</operation>
            <value>Invitation Sent</value>
        </criteriaItems>
        <description>Survey Status in Post Call Survey Object will be changed to No Response Received after 5 days of no response.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>No_Response_Received_Issue_Resolution</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
