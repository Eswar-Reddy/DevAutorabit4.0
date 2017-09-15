<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Inspection_is_Finished_by_Inspector</fullName>
        <description>Inspection is Finished by Inspector</description>
        <protected>false</protected>
        <recipients>
            <field>Partner_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Inspection_Report/Inspection_Report_Assigned_to_Dealer</template>
    </alerts>
    <alerts>
        <fullName>Mail_to_Inspector</fullName>
        <description>Mail to Inspector</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Inspection_Report/Inspection_Report_Assigned_to_External_Inspection</template>
    </alerts>
    <alerts>
        <fullName>Mail_to_TI</fullName>
        <description>Mail to TI</description>
        <protected>false</protected>
        <recipients>
            <field>Reviewer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Inspection_Report/Inspection_Report_Finished_by_inspector</template>
    </alerts>
    <rules>
        <fullName>Inspection is finalized</fullName>
        <actions>
            <name>Inspection_is_Finished_by_Inspector</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>and( Case__r.RecordTypeId == &apos;01280000000Q1s0&apos;, Reviewer__c &lt;&gt; null, Contact__c &lt;&gt; null, OR( ISPICKVAL(Case_Status__c, &apos;Approved&apos;), ISPICKVAL(Case_Status__c, &apos;Waiting for Partner Response&apos;)) 
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Mail to Inspector</fullName>
        <actions>
            <name>Mail_to_Inspector</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>and( Case__r.RecordTypeId == &apos;01280000000Q1s0&apos;, 
Contact__c&lt;&gt;null, ISPICKVAL(Case_Status__c, &apos;Sent to Inspector&apos;), 
OR( ISCHANGED(Case_Status__c) , ISCHANGED(Contact__c) ) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Mail to Reviewer</fullName>
        <actions>
            <name>Mail_to_TI</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>and( Case__r.RecordTypeId == &apos;01280000000Q1s0&apos;, Reviewer__c &lt;&gt; null, ISPICKVAL(Case_Status__c, &apos;Completed&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
