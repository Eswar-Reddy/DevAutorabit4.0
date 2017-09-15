<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Alliance_Campaign_Probability_Changed_to_100</fullName>
        <ccEmails>AllianceSpecialists@sunpowercorp.com</ccEmails>
        <description>Alliance Campaign Probability Changed to (100%)</description>
        <protected>false</protected>
        <recipients>
            <recipient>andrew.fish@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>desiree.bigoy@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Campaign/Alliance_Campaign_Probability_Changed_to_100</template>
    </alerts>
    <alerts>
        <fullName>Alliance_Campaign_Probability_Changed_to_75</fullName>
        <ccEmails>AllianceSpecialists@sunpowercorp.com</ccEmails>
        <description>Alliance Campaign Probability Changed to (75%)</description>
        <protected>false</protected>
        <recipients>
            <recipient>andrew.fish@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>desiree.bigoy@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Campaign/Alliance_Campaign_Probability_Changed_to_75</template>
    </alerts>
    <alerts>
        <fullName>New_Alliance_Campaign_Created</fullName>
        <ccEmails>AllianceSpecialists@sunpowercorp.com</ccEmails>
        <description>New Alliance Campaign Created</description>
        <protected>false</protected>
        <recipients>
            <recipient>andrew.fish@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>desiree.bigoy@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Campaign/New_Alliance_Campaign_Created</template>
    </alerts>
    <alerts>
        <fullName>New_Campaign_Created</fullName>
        <ccEmails>Marketing.Automation@sunpower.com</ccEmails>
        <description>New Campaign Created</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Campaign/New_Alliance_Campaign_Created</template>
    </alerts>
    <alerts>
        <fullName>SME_On_Campaign_Notification</fullName>
        <description>SME On Campaign Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>SME__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Campaign/SME_On_Campaign_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Launch_Date</fullName>
        <description>Update Launch Date</description>
        <field>Launch_Date__c</field>
        <formula>Today ()</formula>
        <name>Update Launch Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Alliance Campaign Probability Changed to %28100%25%29</fullName>
        <actions>
            <name>Alliance_Campaign_Probability_Changed_to_100</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Alliance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Probability__c</field>
            <operation>equals</operation>
            <value>100</value>
        </criteriaItems>
        <description>Alliance Campaign Probability Changed to (100%)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Alliance Campaign Probability Changed to %2875%25%29</fullName>
        <actions>
            <name>Alliance_Campaign_Probability_Changed_to_75</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Alliance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Probability__c</field>
            <operation>equals</operation>
            <value>75</value>
        </criteriaItems>
        <description>Alliance Campaign Probability Changed to (75%)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Alliance Campaign Created</fullName>
        <actions>
            <name>New_Alliance_Campaign_Created</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Alliance</value>
        </criteriaItems>
        <description>New Alliance Campaign Created</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Campaign Created</fullName>
        <actions>
            <name>New_Campaign_Created</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Standard,Alliance</value>
        </criteriaItems>
        <description>New Campaign Created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SME on Campaign Notification</fullName>
        <actions>
            <name>SME_On_Campaign_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>SME on Campaign Notification</description>
        <formula>ischanged( SME__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Launch Date when Lead First Added to Campaign</fullName>
        <actions>
            <name>Update_Launch_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Alliance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Total_No_Leads__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Launch_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Update Launch Date when Lead First Added to Campaign</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
