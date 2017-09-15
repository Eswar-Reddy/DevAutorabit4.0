<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CSAT_New_Submission_Notice_To_AM</fullName>
        <description>CSAT: New Submission Notice To AM</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Contact/CSAT_Record_Submission_Notice</template>
    </alerts>
    <rules>
        <fullName>CSAT%3A New Record Submission Notice to AM</fullName>
        <actions>
            <name>CSAT_New_Submission_Notice_To_AM</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>CSAT__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
