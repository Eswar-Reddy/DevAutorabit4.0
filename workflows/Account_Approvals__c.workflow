<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Account_Approval_Approved</fullName>
        <description>Account Approval Approved</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_Email_Alerts/Account_Approval_Approved</template>
    </alerts>
    <alerts>
        <fullName>Account_Approval_Recalled</fullName>
        <description>Account Approval Recalled</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_Email_Alerts/Account_Approval_Recalled</template>
    </alerts>
    <alerts>
        <fullName>Account_Approval_Rejected</fullName>
        <description>Account Approval Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_Email_Alerts/Account_Approval_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Account_Approval_Submission_Request</fullName>
        <description>Account Approval Submission Request</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Account/Account_Approval_Submission_Request</template>
    </alerts>
    <alerts>
        <fullName>Credit_Check_Approved_On_Account_UPPi</fullName>
        <description>Credit Check Approved On Account - UPPi</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <recipient>alexandre.policarpopinheiro@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>barry.serafino@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>cindy.detorres@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>erik.burkhardt@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>frederic.biollaz@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>frisian.recreo@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>hycinth.homeres@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jessica.aranza@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lavernne.ferraro@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>leah.cagadasmadara@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>maryjane.talha@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>minette.rivera@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rhea.balahadia@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rose.ilagan-maravilla@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Account/Credit_Check_Approved_On_Account</template>
    </alerts>
    <alerts>
        <fullName>DRC_Approval_to_Execute_Documents_Submitted_for_Approval</fullName>
        <description>DRC Approval to Execute Documents Submitted for Approval</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>barry.serafino@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>marina.kourenkova@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Account/Project_Financing_DRC_Request</template>
    </alerts>
    <alerts>
        <fullName>Dealer_Suspended_Approval_Notification</fullName>
        <description>Dealer Suspended Approval Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Account/Lead_Routing_Submission_Approved</template>
    </alerts>
    <alerts>
        <fullName>Dealer_Suspended_Recalled_Lease_Routing_Suspension</fullName>
        <description>Dealer Suspended Recalled (Lease Routing Suspension)</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>gary.ennis@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Account/Lead_Routing_Submission_Recalled</template>
    </alerts>
    <alerts>
        <fullName>Dealer_Suspended_Rejected_Lease_Routing_Suspension</fullName>
        <description>Dealer Suspended Rejected (Lease Routing Suspension)</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>gary.ennis@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Account/Lead_Routing_Submission_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Lease_Routing_Suspension_Submission</fullName>
        <description>Lease Routing Suspension Submission</description>
        <protected>false</protected>
        <recipients>
            <recipient>gary.ennis@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Account/Lead_Routing_Submission_Request</template>
    </alerts>
    <alerts>
        <fullName>Partner_Account_Type_Demotion_Approved</fullName>
        <description>Partner Account Type Demotion Approved</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>avinash.poddar@birlasoft.com.spwr</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Primary_PSR__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_Email_Alerts/Partner_Account_Type_Demotion_Approved</template>
    </alerts>
    <alerts>
        <fullName>Partner_Account_Type_Demotion_Recalled</fullName>
        <description>Partner Account Type Demotion Recalled</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>avinash.poddar@birlasoft.com.spwr</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Primary_PSR__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_Email_Alerts/Partner_Account_Type_Demotion_Recalled</template>
    </alerts>
    <alerts>
        <fullName>Partner_Account_Type_Demotion_Rejected</fullName>
        <description>Partner Account Type Demotion Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>avinash.poddar@birlasoft.com.spwr</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Primary_PSR__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_Email_Alerts/Partner_Account_Type_Demotion_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Project_Financing_Has_Been_Approved</fullName>
        <description>Project Financing Has Been Approved</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Account/Project_Financing_Approved</template>
    </alerts>
    <alerts>
        <fullName>Project_Financing_Has_Been_Recalled</fullName>
        <description>Project Financing Has Been Recalled</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Account/Project_Financing_Recalled</template>
    </alerts>
    <alerts>
        <fullName>Project_Financing_Has_Been_Rejected</fullName>
        <description>Project Financing Has Been Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Account/Project_Financing_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>ASM_Approval_Date</fullName>
        <description>ASM Approval Date</description>
        <field>ASM_Approval_Date__c</field>
        <formula>Today()</formula>
        <name>ASM Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_ASM_Approval</fullName>
        <description>Approval Step - ASM Approval</description>
        <field>Approval_Step__c</field>
        <literalValue>ASM Approval</literalValue>
        <name>Approval Step - ASM Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Approved</fullName>
        <field>Approval_Step__c</field>
        <literalValue>Approved</literalValue>
        <name>Approval Step - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Finance_Manager_Approval</fullName>
        <description>Approval Step - Finance Manager Approval</description>
        <field>Approval_Step__c</field>
        <literalValue>Finance Manager Approval</literalValue>
        <name>Approval Step - Finance Manager Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Initial</fullName>
        <field>Approval_Step__c</field>
        <literalValue>Initial Approval Request</literalValue>
        <name>Approval Step - Initial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Recalled</fullName>
        <field>Approval_Step__c</field>
        <literalValue>Recalled</literalValue>
        <name>Approval Step - Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Rejected</fullName>
        <field>Approval_Step__c</field>
        <literalValue>Rejected</literalValue>
        <name>Approval Step - Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Supply_Enrollment</fullName>
        <description>Approval Step - Supply Enrollment</description>
        <field>Approval_Step__c</field>
        <literalValue>Supply Enrollment</literalValue>
        <name>Approval Step - Supply Enrollment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_System_Set_up</fullName>
        <description>Approval Step - System Set-up</description>
        <field>Approval_Step__c</field>
        <literalValue>System Set-up</literalValue>
        <name>Approval Step - System Set-up</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approved_Date</fullName>
        <field>Approval_Date__c</field>
        <formula>NOW ()</formula>
        <name>Approved Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DRC_Approval_Status_Approved</fullName>
        <description>DRC Approval Status - Approved</description>
        <field>DRC_Approval_to_Execute_Documents_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>DRC Approval Status - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DRC_Approval_Status_Recalled</fullName>
        <description>DRC Approval Status - Recalled</description>
        <field>DRC_Approval_to_Execute_Documents_Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>DRC Approval Status - Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DRC_Approval_Status_Rejected</fullName>
        <description>DRC Approval Status - Rejected</description>
        <field>DRC_Approval_to_Execute_Documents_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>DRC Approval Status - Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DRC_Approval_Status_Submitted</fullName>
        <description>DRC Approval Status - Submitted</description>
        <field>DRC_Approval_to_Execute_Documents_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>DRC Approval Status - Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Approval_of_Doc_Status_Approved</fullName>
        <description>Final Approval of Doc Status - Approved</description>
        <field>Final_Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Final Approval of Doc Status - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Approval_of_Doc_Status_Recalled</fullName>
        <description>Final Approval of Doc Status - Recalled</description>
        <field>Final_Approval_Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>Final Approval of Doc Status - Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Approval_of_Doc_Status_Rejected</fullName>
        <description>Final Approval of Doc Status - Rejected</description>
        <field>Final_Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Final Approval of Doc Status - Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Approval_of_Doc_Status_Submitted</fullName>
        <description>Final Approval of Documents Status - Submitted</description>
        <field>Final_Approval_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Final Approval of Doc Status - Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Finance_Manager_Approval_Date</fullName>
        <field>Finance_Manager_Approval_Date__c</field>
        <formula>today ()</formula>
        <name>Finance Manager - Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Initial_Approval_Date</fullName>
        <field>Initial_Approval_Date__c</field>
        <formula>today ()</formula>
        <name>Initial Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Marketing_Approval_Date</fullName>
        <field>Marketing_Approval_Date__c</field>
        <formula>today ()</formula>
        <name>Marketing Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Proposal_Tool_Access_Date</fullName>
        <field>Proposal_Tool_Access_Date__c</field>
        <formula>today ()</formula>
        <name>Proposal Tool Access Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Status - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Changed_True</fullName>
        <field>Status_Changed__c</field>
        <literalValue>1</literalValue>
        <name>Status Changed - True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Pending_Final_Approval</fullName>
        <description>Status - Pending Final Approval</description>
        <field>Status__c</field>
        <literalValue>Pending Final Approval</literalValue>
        <name>Status - Pending Final Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Recalled</fullName>
        <field>Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>Status - Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Status - Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Submitted</fullName>
        <field>Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Status - Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Supply_Enrollment_Approval_Date</fullName>
        <field>Supply_Enrollment_Approval_Date__c</field>
        <formula>today ()</formula>
        <name>Supply Enrollment - Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>System_Set_up_Approval_Date</fullName>
        <field>System_Set_up_Approval_Date__c</field>
        <formula>today ()</formula>
        <name>System Set-up - Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Term_Sheet_Approval_Status_Recalled</fullName>
        <description>Term Sheet Approval Status - Recalled</description>
        <field>Project_Financing_Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>Term Sheet Approval Status - Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Term_Sheet_Approval_Status_Rejected</fullName>
        <description>Term Sheet Approval Status - Rejected</description>
        <field>Project_Financing_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Term Sheet Approval Status - Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Term_Sheet_Approval_Status_Submitted</fullName>
        <description>Term Sheet Approval Status - Submitted</description>
        <field>Project_Financing_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Term Sheet Approval Status - Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Term_Sheet_Approved</fullName>
        <field>Project_Financing_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Term Sheet Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
