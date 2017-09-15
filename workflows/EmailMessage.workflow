<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Change_Status_to_open_to_work</fullName>
        <field>Status</field>
        <literalValue>Open to Work</literalValue>
        <name>Change Status to open to work</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Upd_CRM_Case_Status_After_Inbound_Email</fullName>
        <description>When an inbound email arrives via email2case, update the CRM Case Status to &quot;Pending Support Response&quot;</description>
        <field>Status</field>
        <literalValue>Pending Support Response</literalValue>
        <name>Upd CRM Case Status After Inbound Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Upd_CRM_Case_Status_After_Sending_Email</fullName>
        <description>After sending an email, update the Case status to &quot;Pending User Response&quot;</description>
        <field>Status</field>
        <literalValue>Pending User Response</literalValue>
        <name>Upd CRM Case Status After Sending Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Change Status to open to work</fullName>
        <actions>
            <name>Change_Status_to_open_to_work</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Technical Support Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update CRM Case Status When Receiving New Case Email</fullName>
        <actions>
            <name>Upd_CRM_Case_Status_After_Inbound_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND (NOT(3)) AND 4</booleanFilter>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>CRM Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Subject</field>
            <operation>startsWith</operation>
            <value>ON HOLD:</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>When a new email arrives via email2case for an existing case, update the Case.Status to &quot;Pending Support Response&quot;</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update CRM Case Status When Sending New Case Email</fullName>
        <actions>
            <name>Upd_CRM_Case_Status_After_Sending_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>CRM Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Age_in_days__c</field>
            <operation>greaterThan</operation>
            <value>0.0001</value>
        </criteriaItems>
        <description>When sending an email for an existing case, update the Case.Status to &quot;Pending User Response&quot;</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
