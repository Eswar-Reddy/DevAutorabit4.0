<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>PM_Install_Scheduled_Notification</fullName>
        <description>Email alert sent to assigned to residential project user when Homeowner Scheduled Installation Date changes</description>
        <protected>false</protected>
        <recipients>
            <field>Opportunity_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Project_Management_Templates/PM_Install_Scheduled_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Project_Close_Date</fullName>
        <description>Updates Project Close Date when Status is Completed</description>
        <field>Project_Close_Date__c</field>
        <formula>Now()</formula>
        <name>Update Project Close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Project Close Date</fullName>
        <actions>
            <name>Update_Project_Close_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Residential_Project__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed,Cancelled</value>
        </criteriaItems>
        <description>Populates Project Close Date when Project is Completed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
