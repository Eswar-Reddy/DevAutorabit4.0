<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Engineering_Task_Cancelled_Update</fullName>
        <description>Engineering Task Cancelled - Update to Completed</description>
        <field>Status</field>
        <literalValue>Completed</literalValue>
        <name>Engineering Task Cancelled - Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Engineering_Task_Overdue_Status</fullName>
        <description>Marks task as Overdue status if task&apos;s tracking date is before today&apos;s date.</description>
        <field>Status</field>
        <literalValue>Overdue</literalValue>
        <name>Engineering Task Overdue Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Performance_Support_Task_Update</fullName>
        <description>Performance Support Task Update</description>
        <field>RecordTypeId</field>
        <lookupValue>Performance_Support</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Performance Support Task Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Site_Adit_Task_Update_to_Status_Complete</fullName>
        <description>Site Adit Task Update to Status Completed</description>
        <field>Status</field>
        <literalValue>Completed</literalValue>
        <name>Site Adit Task Update to Status Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Structural_Support_Task_Record_Type_Upda</fullName>
        <description>Structural Support Task Record Type Update</description>
        <field>RecordTypeId</field>
        <lookupValue>Structural_Support</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Structural Support Task Record Type Upda</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Task_Type_D_E</fullName>
        <description>Task Type - D&amp;E</description>
        <field>Task_Type__c</field>
        <literalValue>D&amp;E</literalValue>
        <name>Task Type - D&amp;E</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Task_Type_FE</fullName>
        <description>Task Type - FE</description>
        <field>Task_Type__c</field>
        <literalValue>FE</literalValue>
        <name>Task Type - FE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Task_Type_G_A</fullName>
        <description>Task Type - G&amp;A</description>
        <field>Task_Type__c</field>
        <literalValue>G&amp;A</literalValue>
        <name>Task Type - G&amp;A</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Task_Type_Holiday</fullName>
        <description>Task Type - Holiday</description>
        <field>Task_Type__c</field>
        <literalValue>Holiday</literalValue>
        <name>Task Type - Holiday</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Task_Type_PTO</fullName>
        <description>Task Type - PTO</description>
        <field>Task_Type__c</field>
        <literalValue>PTO</literalValue>
        <name>Task Type - PTO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Task_Type_RFI</fullName>
        <description>Task Type - RFI</description>
        <field>Task_Type__c</field>
        <literalValue>RFI</literalValue>
        <name>Task Type - RFI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Completed</fullName>
        <description>Update Status to completed when completed date is entered for SSO Task</description>
        <field>Status</field>
        <literalValue>Completed</literalValue>
        <name>Update Status to Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Task_Completed_Date_to_Today</fullName>
        <description>Update Task Completed Date to Today on task completion/cancellation</description>
        <field>Completed_Date__c</field>
        <formula>Now()</formula>
        <name>Update Task Completed Date to Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>task_making_public_to_true</fullName>
        <field>IsVisibleInSelfService</field>
        <literalValue>1</literalValue>
        <name>task making public to true</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>test1</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Public_Task</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>test1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_task_recordtype_and_making_public</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Public_Task</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>update task recordtype and making public</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Engineering Task Cancelled - Update to Completed</fullName>
        <actions>
            <name>Engineering_Task_Cancelled_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>equals</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>Engineering Task</value>
        </criteriaItems>
        <description>Engineering Task Cancelled - Update to Completed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Engineering Task Overdue</fullName>
        <actions>
            <name>Engineering_Task_Overdue_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>Engineering Task</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.ActivityDate</field>
            <operation>lessThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Engineering Task Overdue.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Performance Support Task Record Type Update</fullName>
        <actions>
            <name>Performance_Support_Task_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>contains</operation>
            <value>Performance Support Task</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Performance Support</value>
        </criteriaItems>
        <description>Performance Support Task Record Type Update</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Structural Support Task Task Record Type Update</fullName>
        <actions>
            <name>Structural_Support_Task_Record_Type_Upda</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>contains</operation>
            <value>Structural Support Task</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Structural Support</value>
        </criteriaItems>
        <description>Structural Support Task Task Record Type Update</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Task Completed Date - Update to Today</fullName>
        <actions>
            <name>Update_Task_Completed_Date_to_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>equals</operation>
            <value>Cancelled,Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Completed_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Task Completed Date - Update to Today on task completion/cancelled</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Task Type - D%26E</fullName>
        <actions>
            <name>Task_Type_D_E</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Task.Request_Sub_Category__c</field>
            <operation>notEqual</operation>
            <value>Field Engineering,RFI</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Requested_By__c</field>
            <operation>notEqual</operation>
            <value>PTO,Holiday,G&amp;A</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>Engineering Task</value>
        </criteriaItems>
        <description>Task Type - D&amp;E</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Task Type - FE</fullName>
        <actions>
            <name>Task_Type_FE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.Request_Sub_Category__c</field>
            <operation>equals</operation>
            <value>Field Engineering</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>Engineering Task</value>
        </criteriaItems>
        <description>Task Type - FE</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Task Type - G%26A</fullName>
        <actions>
            <name>Task_Type_G_A</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.Requested_By__c</field>
            <operation>equals</operation>
            <value>G&amp;A</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>Engineering Task</value>
        </criteriaItems>
        <description>Task Type - G&amp;A</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Task Type - Holiday</fullName>
        <actions>
            <name>Task_Type_Holiday</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.Requested_By__c</field>
            <operation>equals</operation>
            <value>Holiday</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>Engineering Task</value>
        </criteriaItems>
        <description>Task Type - Holiday</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Task Type - PTO</fullName>
        <actions>
            <name>Task_Type_PTO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.Requested_By__c</field>
            <operation>equals</operation>
            <value>PTO</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>Engineering Task</value>
        </criteriaItems>
        <description>Task Type - PTO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Task Type - RFI</fullName>
        <actions>
            <name>Task_Type_RFI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.Request_Sub_Category__c</field>
            <operation>equals</operation>
            <value>RFI</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>Engineering Task</value>
        </criteriaItems>
        <description>Task Type - RFI</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Task Update to Completed - Site Audit</fullName>
        <actions>
            <name>Site_Adit_Task_Update_to_Status_Complete</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Task.Completed_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>startsWith</operation>
            <value>Site Survey Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>notEqual</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <description>Task Update to Completed - Site Audit</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Private Task Fields</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>Private Task</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Status to Completed</fullName>
        <actions>
            <name>Update_Status_to_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Completed_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Task Status update to Completed when Completed date is entered</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update task for Five9 Call Recording</fullName>
        <actions>
            <name>task_making_public_to_true</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>update_task_recordtype_and_making_public</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Solar Advisor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Five9__Five9SessionId__c</field>
            <operation>notEqual</operation>
            <value>NULL</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
