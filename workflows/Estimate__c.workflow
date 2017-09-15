<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Design_Completed_Alert_PM_and_Estimator_on_Estimate_Object</fullName>
        <description>Design Completed - Alert PM and Estimator on Estimate Object</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Estimator__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PSR/Design_Completed_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Estimate_Completed_Aler_NACt</fullName>
        <description>Estimate Completed Alert - NAC</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>Sales Analyst</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>jennylene.lapitan@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PSR/Estimate_Moved_to_Complete_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Estimate_Final_Approval_Email</fullName>
        <description>Estimate Final Approval Email</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Estimate_Reviewer__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Estimator__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>PSR_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PSR/Estimate_Approval_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Estimate_Final_Rejection_Email</fullName>
        <description>Estimate Final Rejection Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PSR/Estimate_Rejection_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Estimate_Owner_Changed</fullName>
        <description>Estimate Owner Changed</description>
        <protected>false</protected>
        <recipients>
            <recipient>ragutierrez@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PSR/Estimate_Owner_Changed_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Estimate_Reassignment_Alert</fullName>
        <description>Estimate Reassignment Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Reassigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PSR/Estimate_Reassignment_Alert</template>
    </alerts>
    <alerts>
        <fullName>Estimate_Reassignment_Completed</fullName>
        <description>Estimate Reassignment Completed</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Estimator__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PSR/Estimate_Reassignment_Completed</template>
    </alerts>
    <alerts>
        <fullName>Estimate_Step_s_Rejection_Email</fullName>
        <description>Estimate Step&apos;s Rejection Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Estimator__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PSR/Estimate_Rejection_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Notification_to_the_Project_Manager_when_assigned_to_an_estimate_record</fullName>
        <description>Notification to the Project Manager when assigned to an estimate record.</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PSR/Estimate_Assignment_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Notify_PSR_Owner_when_Estimate_Owner_is_changed</fullName>
        <description>Notify PSR Owner when Estimate Owner is changed</description>
        <protected>false</protected>
        <recipients>
            <field>PSR_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PSR/Estimate_Object_Owner_is_changed</template>
    </alerts>
    <alerts>
        <fullName>PSR_Created_Estimate</fullName>
        <description>PSR Created Estimate</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Estimator__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PSR/Estimate_Assignment_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>PSR_Created_Estimate_NAC</fullName>
        <description>PSR Created Estimate - NAC/UPPa</description>
        <protected>false</protected>
        <recipients>
            <recipient>katie.fearon@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PSR/Estimate_Assignment_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>PSR_Created_Estimate_UPPi</fullName>
        <description>PSR Created Estimate - UPPi</description>
        <protected>false</protected>
        <recipients>
            <recipient>jorge.martinez@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PSR/Estimate_Assignment_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>PSR_Estimate_Updated_Notification</fullName>
        <description>PSR Estimate Updated Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>frederick.yu@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>martial.genolet@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PSR/PSR_Estimate_Updated_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_Notification_to_Estimator_on_Change</fullName>
        <description>Send Notification to Estimator on Change</description>
        <protected>false</protected>
        <recipients>
            <field>Estimator__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Old_Estimator__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Service_Support/Estimator_Change_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Estimate_Complete_Update_When_Cancelled</fullName>
        <description>Update Estimate Complete Date when Estimate Status is Cancelled</description>
        <field>Estimate_Complete_Date__c</field>
        <formula>TODAY ()</formula>
        <name>Estimate Complete Update When Cancelled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Estimate_Final_Rejection_Field_Update</fullName>
        <field>Status__c</field>
        <literalValue>Invalid</literalValue>
        <name>Estimate Final Rejection Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Estimate_Status_Field_Update</fullName>
        <field>Status__c</field>
        <literalValue>Completed</literalValue>
        <name>Estimate Status Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Estimate_Status_Field_Update_in_Rejectio</fullName>
        <field>Status__c</field>
        <literalValue>In Progress</literalValue>
        <name>Estimate Status Field Update in Rejectio</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Estimate_Submission_Field_Update</fullName>
        <field>Status__c</field>
        <literalValue>Awaiting Approval</literalValue>
        <name>Estimate Submission Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateCompletedDate</fullName>
        <field>Estimate_Complete_Date__c</field>
        <formula>TODAY()</formula>
        <name>UpdateCompletedDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Estimate_Complete_Date</fullName>
        <field>Estimate_Complete_Date__c</field>
        <name>Update Estimate Complete Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Estimate_Original_Due_Date</fullName>
        <description>Update Estimate &apos;Original Due Date&apos; to match PSR &apos;Cost Estimate Due&apos;</description>
        <field>Original_Due_Date__c</field>
        <formula>Cost_Estimate_Due__c</formula>
        <name>Update Estimate Original Due Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Estimate_Owner_NAC</fullName>
        <description>Update Estimate Owner - NAC (was Jeff Harold) 1/11/13</description>
        <field>PSR_Owner__c</field>
        <lookupValue>roman.sanchez@sunpowercorp.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Update Estimate Owner - NAC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Estimate_Tracking_Date</fullName>
        <field>Estimate_Tracking_Date__c</field>
        <name>Update Estimate Tracking Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Reassignment_Date</fullName>
        <field>Reassignment_Dates__c</field>
        <formula>today ()</formula>
        <name>Update Reassignment Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Design Completed - Alert PM and Estimator on Estimate Object</fullName>
        <actions>
            <name>Design_Completed_Alert_PM_and_Estimator_on_Estimate_Object</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Estimate__c.Design_Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <description>Design Completed - Alert PM and Estimator on Estimate Object</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Estimate Completed - NAC</fullName>
        <actions>
            <name>Estimate_Completed_Aler_NACt</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Estimate__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Estimate__c.Business_Unit__c</field>
            <operation>equals</operation>
            <value>NA Commercial</value>
        </criteriaItems>
        <description>Estimate Completed - NAC</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Estimate Created</fullName>
        <actions>
            <name>Update_Estimate_Complete_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Estimate_Tracking_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Estimate Created.</description>
        <formula>IF($User.ByPassValidation__c == false,true,null)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Estimate Reassignment Alert</fullName>
        <actions>
            <name>Estimate_Reassignment_Alert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Estimate__c.Reassignment_Dates__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Estimate Reassignment Alert Is Changed</fullName>
        <actions>
            <name>Estimate_Reassignment_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Reassignment_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Reassigned_To__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Estimate Reassignment Completed</fullName>
        <actions>
            <name>Estimate_Reassignment_Completed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>( Reassignment_Status__c = &apos;Completed&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Estimate_Completed</fullName>
        <actions>
            <name>UpdateCompletedDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Estimate__c.Status__c</field>
            <operation>equals</operation>
            <value>Cancelled,Completed</value>
        </criteriaItems>
        <description>Estimate Completed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Estimator Change Notification</fullName>
        <actions>
            <name>Send_Notification_to_Estimator_on_Change</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send email notification on Estimator change.</description>
        <formula>ISCHANGED( Estimator__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify PSR Owner when Estimate Owner is changed</fullName>
        <actions>
            <name>Notify_PSR_Owner_when_Estimate_Owner_is_changed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify PSR Owner when Estimate Owner is changed.</description>
        <formula>ISCHANGED(OwnerId)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PSR Created Estimate</fullName>
        <actions>
            <name>PSR_Created_Estimate</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Estimate__c.Linked_to_PSR__c</field>
            <operation>equals</operation>
            <value>YES</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>PSR Created Estimate.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PSR Created Estimate - NAC%2FUPPa</fullName>
        <actions>
            <name>PSR_Created_Estimate_NAC</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND (3 or 4)</booleanFilter>
        <criteriaItems>
            <field>Estimate__c.Linked_to_PSR__c</field>
            <operation>equals</operation>
            <value>YES</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Estimate__c.Business_Unit__c</field>
            <operation>equals</operation>
            <value>NA Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Estimate__c.Business_Unit__c</field>
            <operation>equals</operation>
            <value>UPP Americas</value>
        </criteriaItems>
        <description>PSR Created Estimate - NAC/UPPa</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PSR Created Estimate - UPP Intl</fullName>
        <actions>
            <name>PSR_Created_Estimate_UPPi</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Estimate__c.Linked_to_PSR__c</field>
            <operation>equals</operation>
            <value>YES</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Estimate__c.Business_Unit__c</field>
            <operation>equals</operation>
            <value>UPP Intl</value>
        </criteriaItems>
        <description>PSR Created Estimate - UPP Intl.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PSR Estimate Updated Notification</fullName>
        <actions>
            <name>PSR_Estimate_Updated_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>PSR__r.Business_Unit__c == &apos;UPP Intl&apos; &amp;&amp; NOT(ISNEW())</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Project Manager Assignment Email Notification</fullName>
        <actions>
            <name>Notification_to_the_Project_Manager_when_assigned_to_an_estimate_record</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Work flow process that triggers an email notification to the Project Manager when assigned to an estimate record.</description>
        <formula>AND(NOT( ISNEW() ), ISCHANGED( OwnerId ) , NOT( $User.ByPassValidation__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Estimate Complete Date When Estimate is Status cancelled%2E</fullName>
        <actions>
            <name>Estimate_Complete_Update_When_Cancelled</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Estimate__c.Status__c</field>
            <operation>equals</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <description>Update Estimate Complete Date When Estimate is Status cancelled.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Estimate Original Due Date</fullName>
        <actions>
            <name>Update_Estimate_Original_Due_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Estimate__c.Linked_to_PSR__c</field>
            <operation>equals</operation>
            <value>YES</value>
        </criteriaItems>
        <description>Update Estimate &apos;Original Due Date&apos; to match PSR &apos;Cost Estimate Due&apos;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Estimate Owner - NAC</fullName>
        <actions>
            <name>Update_Estimate_Owner_NAC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Estimate__c.Business_Unit__c</field>
            <operation>equals</operation>
            <value>NA Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Estimate__c.PSR_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update Estimate Owner - NAC</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
