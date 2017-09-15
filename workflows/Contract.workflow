<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Affiliate_Contract_Expriration_60_Days</fullName>
        <description>Affiliate Contract Expriration (60 Days)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>bryan.gates@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eric.potts@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>hannah.herguth@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>julie.kirkenslager@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nemesio.tejero@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>steven.silveira@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Account/Affiliate_Agreement_Expiration</template>
    </alerts>
    <alerts>
        <fullName>Homeowner_Approved_Solar_Design</fullName>
        <ccEmails>SPD_PC@sunpowercorp.com</ccEmails>
        <ccEmails>sse.psr@sunpowercorp.com</ccEmails>
        <description>Homeowner Approved Solar Design</description>
        <protected>false</protected>
        <recipients>
            <field>Installer_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Design/Homeowner_Approved_Design</template>
    </alerts>
    <alerts>
        <fullName>Homeowner_Declines_Solar_Design</fullName>
        <ccEmails>SPD_PC@sunpowercorp.com</ccEmails>
        <ccEmails>sse.psr@sunpowercorp.com</ccEmails>
        <description>Homeowner Declines Solar Design</description>
        <protected>false</protected>
        <recipients>
            <field>Installer_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Design/Homeowner_Declines_Design</template>
    </alerts>
    <alerts>
        <fullName>Partner_Unsigned_Contract</fullName>
        <description>Partner - Contract has not been signed</description>
        <protected>false</protected>
        <recipients>
            <field>CustomerSignedId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Partner_Management/Partner_Unsigned_Contract</template>
    </alerts>
    <fieldUpdates>
        <fullName>update15daysbeforecontractdeadline</fullName>
        <field>X15_Days_Before_Contract_Deadline__c</field>
        <literalValue>1</literalValue>
        <name>Update 15 Days before Contract Deadline</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update30daysbeforecontractdeadline</fullName>
        <field>X30_Days_Before_Contract_Deadline__c</field>
        <literalValue>1</literalValue>
        <name>Update 30 Days before Contract Deadline</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update45daysbeforecontractdeadline</fullName>
        <field>X45_Days_Before_Contract_Deadline__c</field>
        <literalValue>1</literalValue>
        <name>Update 45 Days before Contract Deadline</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update7daysbeforecontractdeadline</fullName>
        <field>X7_Days_Before_Contract_Deadline__c</field>
        <literalValue>1</literalValue>
        <name>Update 7 Days before Contract Deadline</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>1 day before contract end</fullName>
        <actions>
            <name>Partner_Unsigned_Contract</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contract.Days_before_Contract_End__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contract.Status</field>
            <operation>equals</operation>
            <value>Out for Signature</value>
        </criteriaItems>
        <description>1 day before contract end.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>15 days before contract deadline</fullName>
        <actions>
            <name>Partner_Unsigned_Contract</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>update15daysbeforecontractdeadline</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contract.Days_before_Contract_Deadline__c</field>
            <operation>equals</operation>
            <value>15</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contract.Status</field>
            <operation>equals</operation>
            <value>Out for Signature</value>
        </criteriaItems>
        <description>15 days before contract deadline.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>15 days before contract end</fullName>
        <actions>
            <name>Partner_Unsigned_Contract</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contract.Days_before_Contract_End__c</field>
            <operation>equals</operation>
            <value>15</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contract.Status</field>
            <operation>equals</operation>
            <value>Out for Signature</value>
        </criteriaItems>
        <description>15 days before contract end.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>2 days before contract end</fullName>
        <actions>
            <name>Partner_Unsigned_Contract</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contract.Days_before_Contract_End__c</field>
            <operation>equals</operation>
            <value>2</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contract.Status</field>
            <operation>equals</operation>
            <value>Out for Signature</value>
        </criteriaItems>
        <description>2 days before contract end.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>3 days before contract end</fullName>
        <actions>
            <name>Partner_Unsigned_Contract</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contract.Days_before_Contract_End__c</field>
            <operation>equals</operation>
            <value>3</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contract.Status</field>
            <operation>equals</operation>
            <value>Out for Signature</value>
        </criteriaItems>
        <description>3 days before contract end.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>30 days before contract deadline</fullName>
        <actions>
            <name>Partner_Unsigned_Contract</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>update30daysbeforecontractdeadline</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contract.Days_before_Contract_Deadline__c</field>
            <operation>equals</operation>
            <value>30</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contract.Status</field>
            <operation>equals</operation>
            <value>Out for Signature</value>
        </criteriaItems>
        <description>30 days before contract deadline.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>30 days before contract end</fullName>
        <actions>
            <name>Partner_Unsigned_Contract</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contract.Days_before_Contract_End__c</field>
            <operation>equals</operation>
            <value>30</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contract.Status</field>
            <operation>equals</operation>
            <value>Out for Signature</value>
        </criteriaItems>
        <description>30 days before contract end.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>45 days before contract deadline</fullName>
        <actions>
            <name>Partner_Unsigned_Contract</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>update45daysbeforecontractdeadline</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contract.Days_before_Contract_Deadline__c</field>
            <operation>equals</operation>
            <value>45</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contract.Status</field>
            <operation>equals</operation>
            <value>Out for Signature</value>
        </criteriaItems>
        <description>45 days before contract deadline.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>7 days before contract deadline</fullName>
        <actions>
            <name>Partner_Unsigned_Contract</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>update7daysbeforecontractdeadline</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contract.Days_before_Contract_Deadline__c</field>
            <operation>equals</operation>
            <value>7</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contract.Status</field>
            <operation>equals</operation>
            <value>Out for Signature</value>
        </criteriaItems>
        <description>7 days before contract deadline.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>7 days before contract end</fullName>
        <actions>
            <name>Partner_Unsigned_Contract</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contract.Days_before_Contract_End__c</field>
            <operation>equals</operation>
            <value>7</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contract.Status</field>
            <operation>equals</operation>
            <value>Out for Signature</value>
        </criteriaItems>
        <description>7 days before contract end.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Affiliate Contract Expiring</fullName>
        <actions>
            <name>Affiliate_Contract_Expriration_60_Days</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contract.Days_before_Contract_End__c</field>
            <operation>equals</operation>
            <value>60</value>
        </criteriaItems>
        <description>Affiliate Contract Expiring.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
