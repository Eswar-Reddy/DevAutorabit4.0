<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Expedited_Roof_Design_Email_Alert</fullName>
        <ccEmails>maxfitdesign@sunpowercorp.com</ccEmails>
        <description>Expedited Roof Design Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>Expedited_Roof_Design_Request_Email</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>crmadmin@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Roof_Design/Expedited_Roof_Design_Request</template>
    </alerts>
    <alerts>
        <fullName>Send_Roof_Desgin_Status_Complete_Email_to_Account_Owner</fullName>
        <description>Send Roof Desgin Status Complete Email to Account Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>crmadmin@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Roof_Design/Email_on_Roof_Design_Status_Complete</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_SLA</fullName>
        <field>SLA_In_Hours__c</field>
        <formula>(FLOOR((NOW() -  CreatedDate)*24))
+
(((((NOW() -  CreatedDate)*24)-floor((NOW() -  CreatedDate)*24))*60)/100)</formula>
        <name>Update SLA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>MaxFit Roof Design Status Completed</fullName>
        <actions>
            <name>Update_SLA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Roof_Design__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Residential MaxFit Designs</value>
        </criteriaItems>
        <criteriaItems>
            <field>Roof_Design__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <description>Workflow to trigger when Residential MaxFit type of Roof Design Status is Completed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
