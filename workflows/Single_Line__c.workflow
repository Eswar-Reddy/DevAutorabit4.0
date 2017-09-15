<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>New_Single_Line_Created_NAC_PPA</fullName>
        <description>New Single Line Created - NAC + PPA</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>deepa.ananthakrishnan@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Development_Engineer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PSR/New_Single_Line_Created</template>
    </alerts>
    <alerts>
        <fullName>Notify_PSR_Owner_when_Single_Line_Owner_is_changed</fullName>
        <description>Notify PSR Owner when Single Line Owner is changed</description>
        <protected>false</protected>
        <recipients>
            <field>PSR_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PSR/Single_Line_Object_Owner_is_changed</template>
    </alerts>
    <alerts>
        <fullName>PSR_Created_Single_Line</fullName>
        <description>PSR Created Single Line</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PSR/Single_Line_Assignment_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>PSR_Single_Line_Updated_Notification</fullName>
        <description>PSR Single Line Updated Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>alfonso.sierra@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>fernando.calvoherranz@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PSR/PSR_Single_Line_Updated_Notification</template>
    </alerts>
    <alerts>
        <fullName>Single_Line_Approved</fullName>
        <description>Single Line Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PSR/Single_Line_Approved_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Single_Line_Recalled</fullName>
        <description>Single Line Recalled</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PSR/Single_Line_Recalled_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Single_Line_Rejected</fullName>
        <description>Single Line Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PSR/Single_Line_Rejected_Email_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>Default_Owner_SL_NAC</fullName>
        <field>OwnerId</field>
        <lookupValue>rosalie.delacruz@sunpowercorp.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Default Owner SL - NAC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Default_Owner_SL_UPPa</fullName>
        <field>OwnerId</field>
        <lookupValue>raghuram.balachandran@sunpowercorp.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Default Owner SL - UPPa</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Default_for_Negotiated_Due_Date_SL</fullName>
        <description>Default for Negotiated Due Date - SL</description>
        <field>Negotiated_Due_Date__c</field>
        <formula>PSR__r.Electrical_Support_Due__c</formula>
        <name>Default for Negotiated Due Date - SL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Negotiated_Due_Date_SL_No_Requested</fullName>
        <description>Negotiated Due Date - SL - No Requested Due Date</description>
        <field>Negotiated_Due_Date__c</field>
        <formula>today() + 7</formula>
        <name>Negotiated Due Date - SL - No Requested</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Single_Line_Status_Update_Active</fullName>
        <description>Single Line Status Update - Active</description>
        <field>Status__c</field>
        <literalValue>Active</literalValue>
        <name>Single Line Status Update - Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Single_Line_Status_Update_Approved</fullName>
        <description>Single Line Status Update - Approved</description>
        <field>Status__c</field>
        <literalValue>Completed</literalValue>
        <name>Single Line Status Update - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Single_Line_Status_Update_Rejected</fullName>
        <description>Single Line Status Update - Rejected</description>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Single Line Status Update - Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Single_Status_Update_In_Approval</fullName>
        <description>Single Status Update - In Approval when SL submitted for approval</description>
        <field>Status__c</field>
        <literalValue>In Approval</literalValue>
        <name>Single Status Update - In Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Development_Engineer_Murat_Kara</fullName>
        <description>Update Development Engineer - Murat Karakum</description>
        <field>Development_Engineer__c</field>
        <lookupValue>murat.karakum@sunpowercorp.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Update Development Engineer - Murat Kara</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Development_Engineer_Thang_Le</fullName>
        <description>Update Development Engineer - Thang Le</description>
        <field>Development_Engineer__c</field>
        <lookupValue>thang.le@sunpowercorp.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Update Development Engineer - Thang Le</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SL_Completed_Date_Status_Cancel</fullName>
        <description>Update Single Line Completed Date when SL Cancelled</description>
        <field>Single_Line_Completed__c</field>
        <formula>TODAY ()</formula>
        <name>Update SL Completed Date Status=Cancel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Single_Line_Completed</fullName>
        <field>Single_Line_Completed__c</field>
        <name>Update Single Line Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Single_Line_Completed_Date</fullName>
        <field>Single_Line_Completed__c</field>
        <formula>TODAY()</formula>
        <name>Update Single Line Completed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Single_Line_Tracking</fullName>
        <field>Single_Line_Tracking__c</field>
        <name>Update Single Line Tracking</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Default Negotiated Due Date - SL - BU NAC</fullName>
        <actions>
            <name>Default_for_Negotiated_Due_Date_SL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Single_Line__c.Business_Unit__c</field>
            <operation>equals</operation>
            <value>NA Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Single_Line__c.Single_Line_Completed__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Single_Line__c.Single_Line_Due__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Default Negotiated Due Date - SL - BU NAC</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Default Owner SL - NAC</fullName>
        <actions>
            <name>Default_Owner_SL_NAC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Single_Line__c.Linked_to_PSR__c</field>
            <operation>equals</operation>
            <value>YES</value>
        </criteriaItems>
        <criteriaItems>
            <field>Single_Line__c.Business_Unit__c</field>
            <operation>equals</operation>
            <value>NA Commercial</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Default Owner SL - UPPa</fullName>
        <actions>
            <name>Default_Owner_SL_UPPa</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Single_Line__c.Linked_to_PSR__c</field>
            <operation>equals</operation>
            <value>YES</value>
        </criteriaItems>
        <criteriaItems>
            <field>Single_Line__c.Business_Unit__c</field>
            <operation>equals</operation>
            <value>UPP Americas</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Negotiated Due Date - SL - No Requested</fullName>
        <actions>
            <name>Negotiated_Due_Date_SL_No_Requested</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Single_Line__c.Business_Unit__c</field>
            <operation>equals</operation>
            <value>NA Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Single_Line__c.Linked_to_PSR__c</field>
            <operation>equals</operation>
            <value>YES</value>
        </criteriaItems>
        <criteriaItems>
            <field>Single_Line__c.Single_Line_Due__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Negotiated Due Date - SL - No Requested</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Notify PSR Owner when Single Line Owner is changed</fullName>
        <actions>
            <name>Notify_PSR_Owner_when_Single_Line_Owner_is_changed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(OwnerId)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PSR Created Single Line</fullName>
        <actions>
            <name>PSR_Created_Single_Line</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Single_Line__c.Linked_to_PSR__c</field>
            <operation>equals</operation>
            <value>YES</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PSR Single Line Updated Notification</fullName>
        <actions>
            <name>PSR_Single_Line_Updated_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>PSR__r.Business_Unit__c == &apos;UPP Intl&apos; &amp;&amp; NOT(ISNEW())</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Single Line Completed</fullName>
        <actions>
            <name>Update_Single_Line_Completed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Single_Line__c.Status__c</field>
            <operation>equals</operation>
            <value>Cancelled,Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Single Line Created</fullName>
        <actions>
            <name>Update_Single_Line_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Single_Line_Tracking</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF($User.ByPassValidation__c == false,true ,null)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Single Line Created - NAC %2B UPPa</fullName>
        <actions>
            <name>New_Single_Line_Created_NAC_PPA</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Single_Line__c.Business_Unit__c</field>
            <operation>equals</operation>
            <value>NA Commercial,UPP Americas</value>
        </criteriaItems>
        <criteriaItems>
            <field>Single_Line__c.Linked_to_PSR__c</field>
            <operation>equals</operation>
            <value>YES</value>
        </criteriaItems>
        <description>Single Line Created - NAC + UPPa</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Development Engineer - Murat Kara</fullName>
        <actions>
            <name>Update_Development_Engineer_Murat_Kara</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Single_Line__c.Development_Engineer_Dup__c</field>
            <operation>equals</operation>
            <value>00580000003XuY9</value>
        </criteriaItems>
        <description>Update Development Engineer - Murat Karakum</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Development Engineer - Thang Le</fullName>
        <actions>
            <name>Update_Development_Engineer_Thang_Le</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Single_Line__c.Development_Engineer_Dup__c</field>
            <operation>equals</operation>
            <value>00580000003Ys91</value>
        </criteriaItems>
        <description>Update Development Engineer - Thang Le</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Single Line Completed Date when SL Cancelled</fullName>
        <actions>
            <name>Update_SL_Completed_Date_Status_Cancel</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Single_Line__c.Status__c</field>
            <operation>equals</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <description>Update Single Line Completed Date when SL Cancelled</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
