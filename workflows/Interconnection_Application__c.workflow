<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Interconnection_Application_Approved</fullName>
        <description>Interconnection Application Approved</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>theresa.floyd@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Interconnection_Application_Approved</template>
    </alerts>
    <alerts>
        <fullName>Interconnection_Application_Recalled</fullName>
        <description>Interconnection Application Recalled</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>theresa.floyd@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Interconnection_Application_Recalled</template>
    </alerts>
    <alerts>
        <fullName>Interconnection_Application_Rejected</fullName>
        <description>Interconnection Application Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>theresa.floyd@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Interconnection_Application_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>Final_Approval_Recalled</fullName>
        <field>Final_Approval_Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>Final Approval - Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Approval_Rejected</fullName>
        <field>Final_Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Final Approval - Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Approval_Status_Approved</fullName>
        <field>Final_Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Final Approval Status - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Interconnection_Phase_Build</fullName>
        <description>Interconnection Phase - Interconnection  Build</description>
        <field>IA_Status__c</field>
        <literalValue>Interconnection Build</literalValue>
        <name>Interconnection Phase - Build</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Interconnection_Phase_Cancelled</fullName>
        <description>Interconnection Phase - Interconnection Cancelled</description>
        <field>IA_Status__c</field>
        <literalValue>Interconnection Cancelled</literalValue>
        <name>Interconnection Phase - Cancelled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Interconnection_Phase_Commissioning</fullName>
        <description>Interconnection Phase - Commissioning &amp; incentive Claim</description>
        <field>IA_Status__c</field>
        <literalValue>Commissioning &amp; Incentive Claim</literalValue>
        <name>Interconnection Phase - Commissioning</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Interconnection_Phase_Completed</fullName>
        <description>Interconnection Phase - Interconnection Completed</description>
        <field>IA_Status__c</field>
        <literalValue>Interconnection Completed</literalValue>
        <name>Interconnection Phase - Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Interconnection_Phase_Construction</fullName>
        <description>Interconnection Phase - Construction</description>
        <field>IA_Status__c</field>
        <literalValue>Construction</literalValue>
        <name>Interconnection Phase - Construction</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Interconnection_Phase_Design</fullName>
        <description>Interconnection Phase - Design</description>
        <field>IA_Status__c</field>
        <literalValue>Design</literalValue>
        <name>Interconnection Phase - Design</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Interconnection_Phase_Future</fullName>
        <description>Interconnection Phase - Future</description>
        <field>IA_Status__c</field>
        <literalValue>Future</literalValue>
        <name>Interconnection Phase - Future</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Interconnection_Phase_Inspection_PTO</fullName>
        <description>Interconnection Phase - Inspection &amp; PTO</description>
        <field>IA_Status__c</field>
        <literalValue>Inspection &amp; PTO</literalValue>
        <name>Interconnection Phase - Inspection &amp; PTO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Interconnection_Phase_Redesign</fullName>
        <description>Interconnection Phase - Redesign</description>
        <field>IA_Status__c</field>
        <literalValue>Redesign</literalValue>
        <name>Interconnection Phase - Redesign</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Interconnection_Phase_Utility_Review</fullName>
        <description>Interconnection Phase - Utility Review (or Design):</description>
        <field>IA_Status__c</field>
        <literalValue>Utility Review</literalValue>
        <name>Interconnection Phase - Utility Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UncheckTriggerWorkflow</fullName>
        <field>Trigger_Workflow__c</field>
        <literalValue>0</literalValue>
        <name>UncheckTriggerWorkflow</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Interconnection Phase - Cancelled</fullName>
        <actions>
            <name>Interconnection_Phase_Cancelled</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UncheckTriggerWorkflow</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Interconnection_Application__c.Date_Interconnection_Completed__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Date_Interconnection_Cancelled__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Interconnection Phase - Cancelled (10)</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Interconnection Phase - Commissioning</fullName>
        <actions>
            <name>Interconnection_Phase_Commissioning</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UncheckTriggerWorkflow</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Interconnection_Application__c.Date_Interconnection_Completed__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Date_Interconnection_Cancelled__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.PTO_Received__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Interconnection Phase - Commissioning (8)</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Interconnection Phase - Completed</fullName>
        <actions>
            <name>Interconnection_Phase_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UncheckTriggerWorkflow</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Interconnection_Application__c.Date_Interconnection_Completed__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Date_Interconnection_Cancelled__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Interconnection Phase - Completed (9)</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Interconnection Phase - Construction</fullName>
        <actions>
            <name>Interconnection_Phase_Construction</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UncheckTriggerWorkflow</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 4 AND 5 and 6 and (3 or 7)</booleanFilter>
        <criteriaItems>
            <field>Interconnection_Application__c.Date_Interconnection_Completed__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Application_Passed_Utility_Eng_Review__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Begin_Inspection_PTO_Activities_on__c</field>
            <operation>greaterThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.PTO_Received__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Date_Interconnection_Cancelled__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Application_Passed_Utility_Eng_Review__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Begin_Inspection_PTO_Activities_on__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Interconnection Phase - Construction (7)</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Interconnection Phase - Design</fullName>
        <actions>
            <name>Interconnection_Phase_Design</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UncheckTriggerWorkflow</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 and 6 and 7 and 8 and 9</booleanFilter>
        <criteriaItems>
            <field>Interconnection_Application__c.Interconnection_now_in_Design_Phase__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Design_Phase_Complete__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.IA_Submitted_to_Utility__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Application_Passed_Utility_Eng_Review__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.PTO_Received__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Redesign_Submitted_to_Utility__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Redesign_Required_Due_by__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Date_Interconnection_Completed__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Date_Interconnection_Cancelled__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Interconnection Phase - Design (2)</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Interconnection Phase - Future</fullName>
        <actions>
            <name>Interconnection_Phase_Future</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UncheckTriggerWorkflow</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 and 6 and 7 and 8 and 9 and 10</booleanFilter>
        <criteriaItems>
            <field>Interconnection_Application__c.Interconnection_now_in_Design_Phase__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Design_Phase_Complete__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.IA_Submitted_to_Utility__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Application_Passed_Utility_Eng_Review__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Begin_Inspection_PTO_Activities_on__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.PTO_Received__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Redesign_Submitted_to_Utility__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Redesign_Required_Due_by__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Date_Interconnection_Completed__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Date_Interconnection_Cancelled__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Interconnection Phase - Future (1)</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Interconnection Phase - Inspection %26 PTO</fullName>
        <actions>
            <name>Interconnection_Phase_Inspection_PTO</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UncheckTriggerWorkflow</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 4 and 5 and 3 and 6</booleanFilter>
        <criteriaItems>
            <field>Interconnection_Application__c.Date_Interconnection_Completed__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Date_Interconnection_Cancelled__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Begin_Inspection_PTO_Activities_on__c</field>
            <operation>lessOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.PTO_Received__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Application_Passed_Utility_Eng_Review__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Begin_Inspection_PTO_Activities_on__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Interconnection Phase - Inspection &amp; PTO (6)</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Interconnection Phase - Interconnection Build</fullName>
        <actions>
            <name>Interconnection_Phase_Build</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UncheckTriggerWorkflow</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 3 AND 4 AND 5 and 6 and 7 and 8)</booleanFilter>
        <criteriaItems>
            <field>Interconnection_Application__c.Design_Phase_Complete__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.IA_Submitted_to_Utility__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Application_Passed_Utility_Eng_Review__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.PTO_Received__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Redesign_Submitted_to_Utility__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Redesign_Required_Due_by__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Date_Interconnection_Completed__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Date_Interconnection_Cancelled__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Interconnection Phase - Interconnection Build (3)</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Interconnection Phase - Redesign</fullName>
        <actions>
            <name>Interconnection_Phase_Redesign</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UncheckTriggerWorkflow</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(2 and 3 AND 4 AND 5 and 6 and 7) and (1 or 8)</booleanFilter>
        <criteriaItems>
            <field>Interconnection_Application__c.IA_Submitted_to_Utility__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Application_Passed_Utility_Eng_Review__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.PTO_Received__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Redesign_Submitted_to_Utility__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Redesign_Required_Due_by__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Date_Interconnection_Completed__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Date_Interconnection_Cancelled__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.IA_Submitted_to_Utility__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Interconnection Phase - Redesign (5)</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Interconnection Phase - Utility Review</fullName>
        <actions>
            <name>Interconnection_Phase_Utility_Review</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UncheckTriggerWorkflow</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 and 2 and 3 and 4 and 5 and 6) or (1 and 2 and 3 and 5 and 6 and 7 and 8) or (9 and 2 and 3 and 4 and 5 and 6)</booleanFilter>
        <criteriaItems>
            <field>Interconnection_Application__c.IA_Submitted_to_Utility__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Application_Passed_Utility_Eng_Review__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.PTO_Received__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Redesign_Submitted_to_Utility__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Date_Interconnection_Completed__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Date_Interconnection_Cancelled__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Redesign_Submitted_to_Utility__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.Redesign_Required_Due_by__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Interconnection_Application__c.IA_Submitted_to_Utility__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Interconnection Phase - Utility Review (4)</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
