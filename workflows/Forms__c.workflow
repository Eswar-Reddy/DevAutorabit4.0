<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>PPF_Submission</fullName>
        <ccEmails>cvar.psr@sunpowercorp.com</ccEmails>
        <description>PPF Submission</description>
        <protected>false</protected>
        <recipients>
            <field>CRSM_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_Email_Alerts/PPF_Form_Submitting</template>
    </alerts>
    <fieldUpdates>
        <fullName>Uncheck_Submit_Form_Checkbox</fullName>
        <description>Uncheck Submit Form Checkbox</description>
        <field>Submit_Form__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Submit Form Checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_CRSM_Email</fullName>
        <field>CRSM_Email__c</field>
        <formula>CRSM_Email_Address__c</formula>
        <name>Update CRSM Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>PPF Form Submission</fullName>
        <actions>
            <name>PPF_Submission</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Forms__c.Submit_Form__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>PPF Form Submission</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Uncheck Submit Form Checkbox</fullName>
        <actions>
            <name>Uncheck_Submit_Form_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Forms__c.Submit_Form__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Uncheck Submit Form Checkbox</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update CRSM Email</fullName>
        <actions>
            <name>Update_CRSM_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 or 2</booleanFilter>
        <criteriaItems>
            <field>Forms__c.CRSM_Email_Address__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Forms__c.CRSM_Email_Address__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
