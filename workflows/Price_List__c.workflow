<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Price_List_Approval_Submitted_Notification</fullName>
        <description>Price List Approval Submitted-Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Price_List/Price_List_Approval_Submitted_Notification</template>
    </alerts>
    <alerts>
        <fullName>Price_List_Approved_Approved</fullName>
        <description>Price List Approved Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>flora.mercurio@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Price_List/Price_List_Approved</template>
    </alerts>
    <alerts>
        <fullName>Price_List_Approved_Recalled</fullName>
        <description>Price List Approved Recalled</description>
        <protected>false</protected>
        <recipients>
            <recipient>flora.mercurio@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Price_List/Price_List_Approval_Request_Recalled</template>
    </alerts>
    <alerts>
        <fullName>Price_List_Approved_Rejected</fullName>
        <description>Price List Approved Rejected</description>
        <protected>false</protected>
        <recipients>
            <recipient>flora.mercurio@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Price_List/Price_List_Approval_Request_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>Price_List_Status_Approved</fullName>
        <description>Price List Status - Approved</description>
        <field>Price_List_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Price List Status - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Price_List_Status_In_Review</fullName>
        <description>Price List Status - In Review</description>
        <field>Price_List_Status__c</field>
        <literalValue>In Review</literalValue>
        <name>Price List Status - In Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Price_List_Status_Recalled</fullName>
        <description>Price List Status - Recalled</description>
        <field>Price_List_Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>Price List Status - Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Price_List_Status_Rejected</fullName>
        <description>Price List Status - Rejected</description>
        <field>Price_List_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Price List Status - Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
