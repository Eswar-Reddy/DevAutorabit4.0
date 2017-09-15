<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Email_to_Customer_on_warranty_completion</fullName>
        <description>Send Email to Customer on warranty completion</description>
        <protected>false</protected>
        <recipients>
            <field>Customer_Account_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Warranty_Registration/Warranty_Registered_Email</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Email</fullName>
        <field>Customer_Account_Email__c</field>
        <formula>Customer_SFDC_ID__r.Email__c</formula>
        <name>Update Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_field</fullName>
        <field>Customer_Account_Email__c</field>
        <formula>Customer_SFDC_ID__r.Email__c</formula>
        <name>Update field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>WR_Email_Notification</fullName>
        <actions>
            <name>Send_Email_to_Customer_on_warranty_completion</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Warranty_Registration__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
