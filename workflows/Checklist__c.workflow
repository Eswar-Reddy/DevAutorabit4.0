<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Alert_Once_the_Status_is_Completed_send_notification_to_the_Designer</fullName>
        <description>Email Alert: Once the Status is &quot;Completed&quot;, send notification to the Designer</description>
        <protected>false</protected>
        <recipients>
            <field>Designer_Name__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/send_notification_to_the_Designer_Once_the_Status_is_Completed_Template</template>
    </alerts>
    <rules>
        <fullName>Once the Status is %22Completed%22%2C send notification to the Designer</fullName>
        <actions>
            <name>Email_Alert_Once_the_Status_is_Completed_send_notification_to_the_Designer</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Checklist__c.Status_Field__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Checklist__c.Designer_Name__c</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <criteriaItems>
            <field>Checklist__c.Send_Notification__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Once the Status is &quot;Completed&quot;, send notification to the Designer.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
