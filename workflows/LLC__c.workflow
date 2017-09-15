<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>LLC_Approval_Submission</fullName>
        <ccEmails>Andrew.Dete@sunpowercorp.com</ccEmails>
        <description>LLC Approval Submission</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_Email_Alerts/LLC_Approval_Submission_Email_Alert</template>
    </alerts>
    <alerts>
        <fullName>LLC_Approved_Email_Alert</fullName>
        <ccEmails>Andrew.Dete@sunpowercorp.com</ccEmails>
        <description>LLC Approved Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_Email_Alerts/LLC_Approved_Email_Alert</template>
    </alerts>
    <alerts>
        <fullName>LLC_Recalled_Email_Alert</fullName>
        <description>LLC Recalled Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_Email_Alerts/LLC_Recalled_Email_Alert</template>
    </alerts>
    <alerts>
        <fullName>LLC_Rejected_Email_Alert</fullName>
        <description>LLC Rejected Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_Email_Alerts/LLC_Rejected_Email_Alert</template>
    </alerts>
    <fieldUpdates>
        <fullName>LCC_Rejected_Status_Updated</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>LCC Rejected Status Updated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_Approval_Rejected_Update</fullName>
        <description>LLC Approval Rejected Update</description>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>LLC Approval Rejected Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_Approval_Status_Update</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>LLC Approval Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_Approval_Submission</fullName>
        <field>Status__c</field>
        <literalValue>In Review</literalValue>
        <name>LLC Approval Submission</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_Approved_Date</fullName>
        <field>Approved_Date__c</field>
        <formula>TODAY()</formula>
        <name>LLC Approved Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_Recalled_Status_Update</fullName>
        <description>LLC Recalled Status Update</description>
        <field>Status__c</field>
        <literalValue>Draft</literalValue>
        <name>LLC Recalled Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
