<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>EU_Italy_Partner_Application_Approved</fullName>
        <ccEmails>solarit@sunpowercorp.com</ccEmails>
        <description>EU - Italy Partner Application Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>EUDealerAmbassadors</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Partner_Application/Partner_Applicant_Approved</template>
    </alerts>
    <alerts>
        <fullName>EU_Partner_Application_Approved</fullName>
        <ccEmails>sunpower.innendienst@sunpowercorp.com</ccEmails>
        <ccEmails>SunpowerPartnerServiceUK@sunpowercorp.com</ccEmails>
        <description>EU Partner Application Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>EUDealerAmbassadors</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Partner_Application/Partner_Applicant_Approved</template>
    </alerts>
    <alerts>
        <fullName>JP_Partner_Application_Approved</fullName>
        <description>JP Partner Application Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>JP_Dealer_Ambassadors</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Partner_Application/Partner_Applicant_Approved</template>
    </alerts>
    <alerts>
        <fullName>NA_Partner_Application_Approved_by_ASM</fullName>
        <description>NA Partner Application Approved by ASM</description>
        <protected>false</protected>
        <recipients>
            <recipient>NADealerAmbassadors</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Partner_Application/Partner_Applicant_Approved</template>
    </alerts>
    <alerts>
        <fullName>PartnerApplicationApproved</fullName>
        <description>Partner Application Approved</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Partner_Application/Partner_Applicant_Approved</template>
    </alerts>
    <alerts>
        <fullName>Partner_Application_AUS_Approved_for_Credit</fullName>
        <description>Partner Application (AUS) Approved for Credit</description>
        <protected>false</protected>
        <recipients>
            <recipient>christian.manriza@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ma.cristina.pancho@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Partner_Application/Partner_Application_AUS_Approved_for_Credit</template>
    </alerts>
    <alerts>
        <fullName>Partner_Application_Alert_14_Days_Since_Submitted</fullName>
        <description>Partner Application Alert - 14 Days Since Submitted</description>
        <protected>false</protected>
        <recipients>
            <recipient>alvin.deguzman@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Area_Sales_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>CRSM__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Lead_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Partner_Application/NA_Partner_Application_Submitted_14_Days_Ago</template>
    </alerts>
    <alerts>
        <fullName>Partner_Application_In_Submitted_Status_EU</fullName>
        <description>Partner Application In Submitted Status - EU</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Partner_Application/Partner_Application_In_Submitted_Status_EU</template>
    </alerts>
    <alerts>
        <fullName>Partner_Application_Sent_for_Credit_Approval_AUS</fullName>
        <ccEmails>SPAU.accountsreceivable@sunpowercorp.com</ccEmails>
        <description>Partner Application Sent for Credit Approval - AUS</description>
        <protected>false</protected>
        <recipients>
            <recipient>ma.cristina.pancho@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Partner_Application/Partner_Application_Sent_for_Credit_Approval_AUS</template>
    </alerts>
    <alerts>
        <fullName>Send_email_for_AUS_PA_Received</fullName>
        <ccEmails>customerservice.australia@sunpowercorp.com</ccEmails>
        <description>Send email for AUS PA Received</description>
        <protected>false</protected>
        <recipients>
            <field>Lead_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>customercare@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Partner_Application/NAPartnerApplicationSubmit</template>
    </alerts>
    <alerts>
        <fullName>Send_email_for_Belgium_Dutch_PA_Received</fullName>
        <ccEmails>sunpowerbelgie@sunpowercorp.com</ccEmails>
        <description>Send email for Belgium (Dutch) PA Received</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Lead_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sunpowerbelgie@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Partner_Application/NAPartnerApplicationSubmit</template>
    </alerts>
    <alerts>
        <fullName>Send_email_for_Belgium_French_PA_Received</fullName>
        <ccEmails>sunpowerbelgique@sunpowercorp.com</ccEmails>
        <description>Send email for Belgium (French) PA Received</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Lead_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sunpowerbelgique@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Partner_Application/NAPartnerApplicationSubmit</template>
    </alerts>
    <alerts>
        <fullName>Send_email_for_EU_PA_Received</fullName>
        <description>Send email for EU PA Received</description>
        <protected>false</protected>
        <recipients>
            <field>Lead_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>customercare@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Partner_Application/NAPartnerApplicationSubmit</template>
    </alerts>
    <alerts>
        <fullName>Send_email_for_France_PA_Received</fullName>
        <ccEmails>solarfr@sunpowercorp.com</ccEmails>
        <description>Send email for France PA Received</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Lead_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>solarfr@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Partner_Application/NAPartnerApplicationSubmit</template>
    </alerts>
    <alerts>
        <fullName>Send_email_for_Germany_PA_Received</fullName>
        <ccEmails>solarde@sunpowercorp.com</ccEmails>
        <description>Send email for Germany PA Received</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Lead_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>solarde@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Partner_Application/NAPartnerApplicationSubmit</template>
    </alerts>
    <alerts>
        <fullName>Send_email_for_Italy_PA_Received</fullName>
        <ccEmails>solarit@sunpowercorp.com</ccEmails>
        <description>Send email for Italy PA Received</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Lead_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>solarit@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Partner_Application/NAPartnerApplicationSubmit</template>
    </alerts>
    <alerts>
        <fullName>Send_email_for_JP_PA_Received</fullName>
        <description>Send email for JP PA Received</description>
        <protected>false</protected>
        <recipients>
            <field>Lead_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>customercare@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Partner_Application/NAPartnerApplicationSubmit</template>
    </alerts>
    <alerts>
        <fullName>Send_email_for_NA_PA_Received</fullName>
        <description>Send email for NA PA Received</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sermarfin.capili@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Lead_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>customercare@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Partner_Application/NAPartnerApplicationSubmit</template>
    </alerts>
    <alerts>
        <fullName>Send_email_for_Spain_PA_Received</fullName>
        <ccEmails>solaresp@sunpowercorp.com</ccEmails>
        <description>Send email for Spain PA Received</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Lead_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>solaresp@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Partner_Application/NAPartnerApplicationSubmit</template>
    </alerts>
    <alerts>
        <fullName>Send_email_for_UK_PA_Received</fullName>
        <ccEmails>SunPowerUK@sunpowercorp.com</ccEmails>
        <description>Send email for UK PA Received</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Lead_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sunpoweruk@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Partner_Application/NAPartnerApplicationSubmit</template>
    </alerts>
    <alerts>
        <fullName>To_let_the_ASM_know_when_EU_application_is_finally_Approved</fullName>
        <description>To let the ASM know when EU application is finally Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Area_Sales_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Partner_Application/PA_Approved_by_DS</template>
    </alerts>
    <alerts>
        <fullName>To_let_the_RSM_know_when_AUS_application_is_finally_Approved</fullName>
        <ccEmails>dealerservice.australia@sunpowercorp.com</ccEmails>
        <description>To let the RSM know when AUS application is finally Approved</description>
        <protected>false</protected>
        <recipients>
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Partner_Application/PA_Approved_by_DS</template>
    </alerts>
    <alerts>
        <fullName>To_let_the_RSM_know_when_EU_application_is_finally_approved_by_Director_of_Sales</fullName>
        <description>To let the RSM know when EU application is finally approved by Director of Sales</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Partner_Application/PA_Approved_by_DS</template>
    </alerts>
    <alerts>
        <fullName>To_let_the_RSM_know_when_JP_application_is_finally_Approved</fullName>
        <description>To let the RSM know when JP application is finally Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>aimee.deguzman@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>emi.koyama@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mami.tamura@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>toru.oyama@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Partner_Application/PA_Approved_by_DS</template>
    </alerts>
    <alerts>
        <fullName>To_let_the_RSM_know_when_NA_application_is_finally_Approved</fullName>
        <description>To let the RSM/CRSM  know when NA application is finally Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>CRSM__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Partner_Application/PA_Approved_by_ASM</template>
    </alerts>
    <alerts>
        <fullName>To_let_the_RSM_knows_when_NA_application_is_finally_Approved</fullName>
        <description>To let the RSM know when NA application is finally Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Partner_Application/PA_Approved_by_ASM</template>
    </alerts>
    <alerts>
        <fullName>partnerapplicationreceived</fullName>
        <description>Partner Application Received</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>crmadmin@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Partner_Application/Partner_Application_Received_HTML</template>
    </alerts>
    <fieldUpdates>
        <fullName>Fulfill_PA_Approval_Date</fullName>
        <field>PA_Approval_Date__c</field>
        <formula>TODAY()</formula>
        <name>Fulfill PA Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Partner_Application_In_Approval_Status</fullName>
        <description>Partner Application - In Approval Status Update</description>
        <field>Status__c</field>
        <literalValue>In Approval</literalValue>
        <name>Partner Application - In Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_NA_Area_Sales_Manger</fullName>
        <description>Update NA Area Sales Manager</description>
        <field>Area_Sales_Manager__c</field>
        <lookupValue>derek.noble@sunpowercorp.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Update NA Area Sales Manger</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Owner_to_EU_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>EUPartnerApplicationQueue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Owner to EU Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Owner_to_NA_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>NAPartnerApplicationQueue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Owner to NA Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_PA_status_to_Pending_RSM_Contact</fullName>
        <description>As initial email goes out, the status will be updated to Pending RSM Contact.</description>
        <field>Status__c</field>
        <literalValue>Pending RSM Contact</literalValue>
        <name>Update PA status to Pending RSM Contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_toSubmitted</fullName>
        <field>Status__c</field>
        <literalValue>In Progress</literalValue>
        <name>Update Status to In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Reject</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Submitted</fullName>
        <field>Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Update Status to Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>statusSetFromApprovalProcess</fullName>
        <field>statusSetFromApprovalProcess__c</field>
        <literalValue>1</literalValue>
        <name>statusSetFromApprovalProcess</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>updaterecordtypetoaus</fullName>
        <field>RecordTypeId</field>
        <lookupValue>AUS_Partner_Application</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type to AUS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>updaterecordtypetoeu</fullName>
        <field>RecordTypeId</field>
        <lookupValue>EU_Partner_Application</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type to EU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>updaterecordtypetona</fullName>
        <field>RecordTypeId</field>
        <lookupValue>NA_Partner_Application</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type to NA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>updaterecordtypetonacommercial</fullName>
        <field>RecordTypeId</field>
        <lookupValue>NA_Commercial_Partner_Application</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type to NA Commercial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AUS Partner Application Created</fullName>
        <actions>
            <name>updaterecordtypetoaus</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Partner_Application__c.Theater__c</field>
            <operation>contains</operation>
            <value>Australia</value>
        </criteriaItems>
        <description>AUS Partner Application Created.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>AUS Partner Application Submitted with Owner</fullName>
        <actions>
            <name>Send_email_for_AUS_PA_Received</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Partner_Application__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>AUS Partner Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Partner_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <description>AUS Partner Application Submitted</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EU Partner Application Created</fullName>
        <actions>
            <name>updaterecordtypetoeu</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Partner_Application__c.Theater__c</field>
            <operation>contains</operation>
            <value>Europe</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>EU Partner Application Submitted</fullName>
        <actions>
            <name>Update_Owner_to_EU_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Partner_Application__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EU Partner Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Partner_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EU Partner Application Submitted with Owner</fullName>
        <actions>
            <name>Send_email_for_EU_PA_Received</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Partner_Application__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EU Partner Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Partner_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <description>EU Partner Application Submitted</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>English Partner Application Approved</fullName>
        <actions>
            <name>PartnerApplicationApproved</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Partner_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Partner_Application__c.Language__c</field>
            <operation>equals</operation>
            <value>English</value>
        </criteriaItems>
        <description>When Partner Application is approved, let the submitter know that Partner Application has been approved.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>English Partner Application Received</fullName>
        <actions>
            <name>partnerapplicationreceived</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Partner_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Partner_Application__c.Language__c</field>
            <operation>equals</operation>
            <value>English</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>JP Partner Application Submitted with Owner</fullName>
        <actions>
            <name>Send_email_for_JP_PA_Received</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Partner_Application__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>JP Partner Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Partner_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <description>JP Partner Application Submitted</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NA Commercial Partner Application Created</fullName>
        <actions>
            <name>updaterecordtypetonacommercial</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Partner_Application__c.Theater__c</field>
            <operation>contains</operation>
            <value>Central America and the Caribbean,North America</value>
        </criteriaItems>
        <criteriaItems>
            <field>Partner_Application__c.Partner_Application_Type__c</field>
            <operation>equals</operation>
            <value>Commercial</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>NA Partner Application - Area Sales Manager update</fullName>
        <actions>
            <name>Update_NA_Area_Sales_Manger</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Partner_Application__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>NA Commercial Partner Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Partner_Application__c.Area_Sales_Manager__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>NA Partner Application - Area Sales Manager update created for case 00358830 
Modified criteria for case 00412150</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NA Partner Application Created</fullName>
        <actions>
            <name>updaterecordtypetona</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Partner_Application__c.Theater__c</field>
            <operation>contains</operation>
            <value>Central America and the Caribbean,North America</value>
        </criteriaItems>
        <criteriaItems>
            <field>Partner_Application__c.Partner_Application_Type__c</field>
            <operation>equals</operation>
            <value>Residential</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>NA Partner Application Submitted</fullName>
        <actions>
            <name>Update_Owner_to_NA_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Partner_Application__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>NA Partner Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Partner_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NA Partner Application Submitted with Owner</fullName>
        <actions>
            <name>Send_email_for_NA_PA_Received</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_PA_status_to_Pending_RSM_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Partner_Application__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>NA Commercial Partner Application,NA Partner Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Partner_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <description>NA Partner Application Submitted</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>PA Submitted Belgium %28Dutch%29</fullName>
        <actions>
            <name>Send_email_for_Belgium_Dutch_PA_Received</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>PA Submitted Belgium (Dutch)</description>
        <formula>ISPICKVAL(Lead__r.Contact_Language__c, &apos;Dutch&apos;)
 &amp;&amp; 
 (Country__c = &quot;Belgium&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PA Submitted Belgium %28French%29</fullName>
        <actions>
            <name>Send_email_for_Belgium_French_PA_Received</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>PA Submitted Belgium (French)</description>
        <formula>(ISPICKVAL(Lead__r.Contact_Language__c, &apos;French&apos;)
 &amp;&amp; 
 ((Country__c = &quot;Belgium&quot;)  ||  ISNULL(Country__c)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Credit_Application_Assign_credit_Limit</fullName>
        <assignedTo>wailing.chang@sunpowercorp.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>This Partner Application is now ready for the Credit Application process. 

Please close the task once you receive the necessary documents. Kindly log after the review indicating the Credit Limit has been approved or rejected.</description>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Credit Application  – Assign credit Limit</subject>
    </tasks>
</Workflow>
