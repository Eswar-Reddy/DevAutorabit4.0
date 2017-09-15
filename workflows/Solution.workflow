<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>New_Draft_Solution_Created</fullName>
        <ccEmails>SolutionsSteeringCommittee@sunpowercorp.com</ccEmails>
        <description>New Draft Solution Created</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_Email_Alerts/New_Draft_Solution_Created</template>
    </alerts>
    <alerts>
        <fullName>Solution_Updated</fullName>
        <ccEmails>SolutionsSteeringCommittee@sunpowercorp.com</ccEmails>
        <description>Solution Updated</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_Email_Alerts/Solution_Updated</template>
    </alerts>
    <alerts>
        <fullName>Solution_in_Draft_Status_Alert</fullName>
        <ccEmails>SolutionsSteeringCommittee@sunpowercorp.com</ccEmails>
        <description>Solution in Draft Status Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Solutions/Draft_Solution</template>
    </alerts>
    <rules>
        <fullName>New Draft Solution Created</fullName>
        <actions>
            <name>New_Draft_Solution_Created</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Solution.Status</field>
            <operation>equals</operation>
            <value>Draft</value>
        </criteriaItems>
        <description>New Draft Solution Created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Solution Updated</fullName>
        <actions>
            <name>Solution_Updated</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Solution Updated</description>
        <formula>NOT(ISPICKVAL( Status, &quot;Draft&quot;) &amp;&amp; NOT(ISPICKVAL( Status, &quot;&quot;) &amp;&amp;  (Ischanged ( SolutionName  )  ||    Ischanged ( SolutionNote  ) || Ischanged ( Internal_Content__c  ))))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Solution in Draft Status</fullName>
        <actions>
            <name>Solution_in_Draft_Status_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Solution.Status</field>
            <operation>equals</operation>
            <value>Draft</value>
        </criteriaItems>
        <description>Solution in Draft Status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
