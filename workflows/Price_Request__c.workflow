<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Price_Request_Approved</fullName>
        <ccEmails>pricing.request@sunpower.com</ccEmails>
        <description>Price Request Approved</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>flora.mercurio@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>melissa.mataba@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_Email_Alerts/Price_Request_Approved</template>
    </alerts>
    <alerts>
        <fullName>Price_Request_Recalled</fullName>
        <ccEmails>pricing.request@sunpower.com</ccEmails>
        <description>Price Request Recalled</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>flora.mercurio@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>melissa.mataba@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_Email_Alerts/Price_Request_Recalled</template>
    </alerts>
    <alerts>
        <fullName>Price_Request_Rejected</fullName>
        <ccEmails>pricing.request@sunpower.com</ccEmails>
        <description>Price Request Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>flora.mercurio@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>melissa.mataba@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_Email_Alerts/Price_Request_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>Price_Request_Status_Approved</fullName>
        <field>Price_Request_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Price Request Status - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Price_Request_Status_In_Progress</fullName>
        <field>Price_Request_Status__c</field>
        <literalValue>In Progress</literalValue>
        <name>Price Request Status - In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Price_Request_Status_Recalled</fullName>
        <field>Price_Request_Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>Price Request Status - Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Price_Request_Status_Rejected</fullName>
        <field>Price_Request_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Price Request Status - Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Price_Request_Status_Resolved</fullName>
        <field>Price_Request_Status__c</field>
        <literalValue>Resolved</literalValue>
        <name>Price Request Status - Resolved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Price Request Status - Resolved</fullName>
        <actions>
            <name>Price_Request_Status_Resolved</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Price_Request__c.Disposition__c</field>
            <operation>equals</operation>
            <value>Cancelled Price Request,Duplicate Price Request,Invalid Price Request</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
