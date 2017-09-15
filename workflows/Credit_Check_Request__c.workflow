<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Alert_for_Lease_Credit_Check_Failure</fullName>
        <ccEmails>Steven.Dunn@sunpowercorp.com, tahmed@thirdpillar.com, hhandono@thirdpillar.com</ccEmails>
        <description>Email Alert for Lease Credit Check Failure</description>
        <protected>false</protected>
        <recipients>
            <recipient>cdevarapalli@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jason.ritchie@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>naga.vinnakota@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rose.punzalan@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>crmadmin@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Lease_Credit_Check_Failed_Email_Alert</template>
    </alerts>
    <fieldUpdates>
        <fullName>UnCheck_Send_Lease_Credit_Check_field</fullName>
        <description>Uncheck to Confirm email alert has been sent</description>
        <field>Send_Lease_Credit_Check_Failure_Email__c</field>
        <literalValue>0</literalValue>
        <name>UnCheck Send Lease Credit Check field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Email_Counter_Credit_Check</fullName>
        <field>Email_Counter__c</field>
        <formula>Email_Counter__c +1</formula>
        <name>Update Email Counter Credit Check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Automate Credit Check Emails</fullName>
        <active>true</active>
        <description>This Workflow rule is to send reminders to customers  for every 48 hours</description>
        <formula>AND(OR(Status__c =&apos;Pending-Application Sent&apos;,Status__c =&apos;Sent&apos;),Email_Counter__c &lt;5,CONTAINS(Account__r.Partner_Account__r.Name, &apos;New Homes&apos;), ISPICKVAL(Credit_Beureu__c,&apos;LoanPath&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Email_Counter_Credit_Check</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Credit_Check_Request__c.LastModifiedDate</offsetFromField>
            <timeLength>48</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Lease Credit Check Submitted</fullName>
        <actions>
            <name>Email_Alert_for_Lease_Credit_Check_Failure</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>UnCheck_Send_Lease_Credit_Check_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Credit_Check_Request__c.Application_Id__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Check_Request__c.Application_Type__c</field>
            <operation>equals</operation>
            <value>Lease</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Check_Request__c.Send_Lease_Credit_Check_Failure_Email__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Workflow to Evaluate if there is a Lease Credit Check Failure and Send an Email alert</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
