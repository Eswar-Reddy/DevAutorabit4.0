<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Adhoc_Create_LDA</fullName>
        <ccEmails>sfdcinquiries@sunpowercorp.com</ccEmails>
        <description>Adhoc Create LDA</description>
        <protected>false</protected>
        <recipients>
            <field>Oracle_Vendor_email_field_value__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>jerome.fortunado@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>financing@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Quote/LDA</template>
    </alerts>
    <alerts>
        <fullName>Adhoc_Create_LDA_Loan</fullName>
        <ccEmails>sfdcinquiries@sunpowercorp.com;</ccEmails>
        <ccEmails>sam.ga@sunpower.com</ccEmails>
        <description>Adhoc Create LDA Loan</description>
        <protected>false</protected>
        <recipients>
            <field>Oracle_Vendor_email_field_value__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>jerome.fortunado@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/LDA_LOAN</template>
    </alerts>
    <alerts>
        <fullName>Aknowledgement_email</fullName>
        <ccEmails>sfdcinquiries@sunpowercorp.com;</ccEmails>
        <ccEmails>sam.ga@sunpower.com</ccEmails>
        <description>Aknowledgement email to Oracle Vendor emil id field in Partner Account</description>
        <protected>false</protected>
        <recipients>
            <field>Oracle_Vendor_email_field_value__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>jerome.fortunado@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>financing@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Quote/LDA</template>
    </alerts>
    <alerts>
        <fullName>Binding_Offer_Final_Approval_Email_Alert</fullName>
        <description>Binding Offer Final Approval Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Initial_Submitter__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>Application Engineer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Construction Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Developer (Partner User)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Energy Efficiency Specialist</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Estimator</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Finance</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Management</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Operations</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Operations and Maintenance</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Project Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Proposal Designer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales</recipient>
            <type>opportunityTeam</type>
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
            <recipient>Sales Person</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Structured Finance</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Supply Chain</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/Binding_Offer_Final_Approval_vf</template>
    </alerts>
    <alerts>
        <fullName>Binding_Offer_Final_Approval_Email_Alert_NAC</fullName>
        <description>Binding Offer Final Approval Email Alert - NAC</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Initial_Submitter__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>Application Engineer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Construction Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Developer (Partner User)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Energy Efficiency Specialist</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Estimator</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Finance</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Management</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Operations</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Operations and Maintenance</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Project Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Proposal Designer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales</recipient>
            <type>opportunityTeam</type>
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
            <recipient>Sales Person</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Structured Finance</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Supply Chain</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>eric.potts@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>joshua.lee@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>matt.white@sunpowercorp.com</recipient>
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
        <recipients>
            <field>Sales_Analyst__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/Binding_Offer_Final_Approval_vf</template>
    </alerts>
    <alerts>
        <fullName>Binding_Offer_Final_Rejection_Email_Notification</fullName>
        <description>Binding Offer Final Rejection Email Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>SSR</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Analyst</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/Binding_Offer_Quote_Rejected_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Binding_Offer_Quote_Submission_UPPi_Binding_Offer_Mature_Markets</fullName>
        <description>Binding Offer Quote Submission - UPPi - Binding Offer Mature Markets</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sol.antonano@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/Binding_Offer_Quote_Submission_VF</template>
    </alerts>
    <alerts>
        <fullName>Budgetary_Pricing_Approval</fullName>
        <description>Budgetary Pricing Approval</description>
        <protected>false</protected>
        <recipients>
            <field>Initial_Submitter__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>Application Engineer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Construction Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Developer (Partner User)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Energy Efficiency Specialist</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Estimator</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Finance</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Management</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Operations</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Operations and Maintenance</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Project Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Proposal Designer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales</recipient>
            <type>opportunityTeam</type>
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
            <recipient>Sales Person</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Structured Finance</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Supply Chain</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/Budgetary_Pricing_Final_Quote_Approval_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Budgetary_Pricing_Final_Approval_Email_Alert</fullName>
        <description>Budgetary Pricing Final Approval Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>Application Engineer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Construction Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Developer (Partner User)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Energy Efficiency Specialist</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Estimator</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Finance</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Management</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Operations</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Operations and Maintenance</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Project Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Proposal Designer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales</recipient>
            <type>opportunityTeam</type>
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
            <recipient>Sales Person</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Structured Finance</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Supply Chain</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/Budgetary_Pricing_Final_Approval_vf</template>
    </alerts>
    <alerts>
        <fullName>Budgetary_Pricing_Rejection_Notification</fullName>
        <description>Budgetary Pricing Rejection Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>Sales Analyst</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/Budgetary_Pricing_Final_Quote_Rejection_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Loan_aknowledgement_email</fullName>
        <ccEmails>sfdcinquiries@sunpowercorp.com;</ccEmails>
        <ccEmails>sam.ga@sunpower.com</ccEmails>
        <description>Loan aknowledgement email to Oracle Vendor emil id field in Partner Account</description>
        <protected>false</protected>
        <recipients>
            <field>Oracle_Vendor_email_field_value__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>jerome.fortunado@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/LDA_LOAN</template>
    </alerts>
    <alerts>
        <fullName>New_Quote_Created</fullName>
        <description>New_Quote Created</description>
        <protected>false</protected>
        <recipients>
            <recipient>Sales Analyst</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_Email_Alerts/New_Quote_Created_Notification</template>
    </alerts>
    <alerts>
        <fullName>New_Quote_Created_Notification</fullName>
        <description>New Quote Created Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Opportunity_Owner_s_Manager__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/New_Quote_Created</template>
    </alerts>
    <alerts>
        <fullName>PV_Availability_Management_Final_Approval_Email</fullName>
        <description>PV Availability / Management Final Approval Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>Sales Analyst</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/Components_Quote_Sales_Ops_Approved_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>PV_Availability_Management_Final_Rejection_Email</fullName>
        <description>PV Availability / Management Final Rejection Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>Sales Analyst</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/Components_Quote_Sales_Ops_Rejected_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>PV_Availability_Management_Step1_Approval_Email</fullName>
        <description>PV Availability / Management Step1 Approval Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/Components_Quote_Management_Approved_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>PV_Availability_Management_Step1_Rejection_Email</fullName>
        <description>PV Availability / Management Step1 Rejection Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/Components_Quote_Management_Rejected_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Price_Concession_Approval_Alert</fullName>
        <description>Price Concession Approval Alert</description>
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
        <senderType>CurrentUser</senderType>
        <template>Quote/Price_Concession_Approved</template>
    </alerts>
    <alerts>
        <fullName>Price_Concession_Recalled_Alert</fullName>
        <description>Price Concession Recalled Alert</description>
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
        <senderType>CurrentUser</senderType>
        <template>Quote/Price_Concession_Recalled</template>
    </alerts>
    <alerts>
        <fullName>Price_Concession_Rejected_Alert</fullName>
        <description>Price Concession Rejected Alert</description>
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
        <senderType>CurrentUser</senderType>
        <template>Quote/Price_Concession_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Quote_Approval_Alert</fullName>
        <description>Quote Approval Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>Sales Analyst</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Analyst</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Sales_Analyst__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/U_C_Deal_Sheet</template>
    </alerts>
    <alerts>
        <fullName>Quote_Approval_Alert_NAC</fullName>
        <description>Quote Approval Alert - NAC</description>
        <protected>false</protected>
        <recipients>
            <recipient>Application Engineer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Construction Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Developer (Partner User)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Electrical Engineer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Energy Efficiency Specialist</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Estimator</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Finance</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Legal</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Management</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Operations</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Operations and Maintenance</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Project Designer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Project Engineer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Project Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Proposal Designer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>SSR</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales</recipient>
            <type>opportunityTeam</type>
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
            <recipient>Sales Person</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Senior Project Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Structured Finance</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Supply Chain</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>eric.potts@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>matt.white@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Sales_Analyst__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/U_C_Deal_Sheet</template>
    </alerts>
    <alerts>
        <fullName>Resource_Approval_Email</fullName>
        <description>Resource Approval Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/Resource_Request_Approved_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Resource_Approval_Rejection_Notification</fullName>
        <description>Resource Approval Rejection Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>Sales Analyst</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/Resource_Request_Rejected_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_LDA_Mail</fullName>
        <description>Send LDA Mail</description>
        <protected>false</protected>
        <recipients>
            <field>Oracle_Vendor_email_field_value__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>financing@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Quote/LDA</template>
    </alerts>
    <alerts>
        <fullName>Send_Welcome_Email</fullName>
        <description>Send Welcome Email</description>
        <protected>false</protected>
        <recipients>
            <field>Lessee__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Oracle_Vendor_email_field_value__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>crmadmin@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Quote/Welcome_To_SunPower_NA</template>
    </alerts>
    <fieldUpdates>
        <fullName>Adhoc_Create_LDA_Field_Update</fullName>
        <field>Adhoc_Create_LDA__c</field>
        <literalValue>0</literalValue>
        <name>Adhoc Create LDA Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_to_Quote_Record_Type_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Proposal_Quote</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Approval to Quote Record Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Binding_Offer_Final_Approval_Field_Udpat</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>Binding Offer Final Approval Field Udpat</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Binding_Offer_Final_Approval_Field_Updat</fullName>
        <field>Status</field>
        <literalValue>Approved</literalValue>
        <name>Binding Offer Final Approval Field Updat</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Binding_Offer_Recall_Field_Update</fullName>
        <field>Status</field>
        <literalValue>Draft</literalValue>
        <name>Binding Offer Recall Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Binding_Offer_Submission_Field_Update</fullName>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>Binding Offer Submission Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Budgetary_Approved</fullName>
        <description>Budgetary Approved Status Update</description>
        <field>Status</field>
        <literalValue>Approved</literalValue>
        <name>Budgetary Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Budgetary_Pricing_Approval_FIeld_Update1</fullName>
        <field>Status</field>
        <literalValue>Draft</literalValue>
        <name>Budgetary Pricing Approval FIeld Update1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Budgetary_Pricing_Approval_FIeld_Update2</fullName>
        <field>Quote_Steps__c</field>
        <literalValue>Binding Offer</literalValue>
        <name>Budgetary Pricing Approval FIeld Update2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Budgetary_Pricing_Rejection_Field_Update</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>Budgetary Pricing Rejection Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Budgetary_Pricing_Submission_Field_Updat</fullName>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>Budgetary Pricing Submission Field Updat</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Check_PV_Availability_Submission_Field_U</fullName>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>Check PV Availability Submission Field U</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_SM_After_Lock</fullName>
        <field>Copy_SM_After_Lock__c</field>
        <formula>TEXT( System_Model__c)</formula>
        <name>Copy SM After Lock</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_SM_Before_Lock</fullName>
        <field>Copy_SM_Before_Lock__c</field>
        <formula>TEXT(System_Model__c)</formula>
        <name>Copy SM Before Lock</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Created_Date</fullName>
        <field>Created_Date__c</field>
        <formula>today()</formula>
        <name>Created Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Delete_PPA_Price</fullName>
        <field>Year_1_PPA_Price__c</field>
        <name>Delete PPA Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Delete_PPA_Savings</fullName>
        <field>Year_1_Savings__c</field>
        <name>Delete PPA Savings</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Is_Locked_True</fullName>
        <description>This will set Is Locked on the quote record coming from CPR</description>
        <field>Is_Locked__c</field>
        <literalValue>1</literalValue>
        <name>Is Locked = True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PV_Avail_BU_Leader_Rejection_Field_Upda</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>PV Avail. BU Leader Rejection Field Upda</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PV_Availability_Approval_Field_Update</fullName>
        <field>Status</field>
        <literalValue>Approved</literalValue>
        <name>PV Availability Approval Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PV_Availability_Recall_Field_Update</fullName>
        <field>Status</field>
        <literalValue>Draft</literalValue>
        <name>PV Availability Recall Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PV_Availability_Rejection_Field_Update</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>PV Availability Rejection Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PV_Cost_Roll_Up_Total</fullName>
        <description>PV Cost (Roll-Up Total)</description>
        <field>Total_PV_Cost__c</field>
        <formula>PV_Cost_Roll_Up__c</formula>
        <name>PV Cost (Roll-Up Total)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Price_Concession_Update</fullName>
        <description>Price Concession Update</description>
        <field>Price__c</field>
        <formula>Diff_Sales_and_List_Price_Total__c</formula>
        <name>Price Concession Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quote_Field_Update</fullName>
        <field>Name</field>
        <formula>(QuoteNumber + &quot;-&quot; + Opportunity.Name)</formula>
        <name>Quote Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quote_Lock_Update</fullName>
        <field>Is_Locked__c</field>
        <literalValue>0</literalValue>
        <name>Quote Lock Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quote_Steps_Field_Update</fullName>
        <field>Quote_Steps__c</field>
        <literalValue>Awaiting PV Availability</literalValue>
        <name>Quote Steps Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quote_Steps_Rejection_Action</fullName>
        <field>Quote_Steps__c</field>
        <literalValue>Contract In Progress</literalValue>
        <name>Quote Steps Rejection Action</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Date_of_Lease_doc_Created_Date</fullName>
        <field>Lease_doc_Created_Date__c</field>
        <name>Remove Date of Lease doc Created Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Date_of_Lease_doc_sent_out_for_si</fullName>
        <field>Lease_doc_Sent_out_for_Signature__c</field>
        <name>Remove Date of Lease doc sent out for si</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Workflow_Trigger</fullName>
        <field>Doc_out_for_signature__c</field>
        <literalValue>0</literalValue>
        <name>Reset Workflow Trigger</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Workflow_Trigger1</fullName>
        <field>Doc_out_for_signature__c</field>
        <literalValue>0</literalValue>
        <name>Reset Workflow Trigger1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Resource_Approval_Field_Update</fullName>
        <field>Status</field>
        <literalValue>Draft</literalValue>
        <name>Resource Approval Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Resource_Approval_Recall_Field_Update</fullName>
        <field>Status</field>
        <literalValue>Draft</literalValue>
        <name>Resource Approval Recall Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Resource_Approval_Rejection_Field_Update</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>Resource Approval Rejection Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Resource_Submission_Field_Update</fullName>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>Resource Submission Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Send_Email_to_Sales_Analyst</fullName>
        <field>IsSendApprovaltoSalesAnalyst__c</field>
        <literalValue>1</literalValue>
        <name>Send Email to Sales Analyst</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sent_Welcome_Email</fullName>
        <field>Sent_Welcome_Email__c</field>
        <literalValue>1</literalValue>
        <name>Sent Welcome Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Initial_Submitter</fullName>
        <description>This sets the Quote field Initial Submitter to the value $User.Email when the record has been submitted for approval. Case# 00477298.</description>
        <field>Initial_Submitter__c</field>
        <formula>$User.Email</formula>
        <name>Set Initial Submitter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Adhoc_Create_LDA_Loan</fullName>
        <field>Adhoc_Create_LDA__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Adhoc Create LDA Loan</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Trigger_field</fullName>
        <field>Trigger_Checkbox__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Trigger field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_field</fullName>
        <field>Lease_Doc_Signed__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Consolidated_Lease_Number_Dup</fullName>
        <description>Update Consolidated Lease Number (Dup) Index field</description>
        <field>Consolidated_Lease_Number_Dup__c</field>
        <formula>Consolidated_Lease_Number__c</formula>
        <name>Update Consolidated Lease Number (Dup)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Construction_Fees</fullName>
        <field>Construction__c</field>
        <formula>( Dealer_Fees__c *60)/100</formula>
        <name>Update Construction Fees</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Date_of_Lease_doc_sent_out_for_si</fullName>
        <field>Lease_doc_Sent_out_for_Signature__c</field>
        <formula>TODAY()</formula>
        <name>Update Date of Lease doc sent out for si</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Date_of_Lease_doc_signed</fullName>
        <field>Lease_doc_Signed_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Date of Lease doc signed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Interconnect_Fees</fullName>
        <field>Interconnect__c</field>
        <formula>( Dealer_Fees__c *20)/100</formula>
        <name>Update Interconnect Fees</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lease_doc_Created_Date</fullName>
        <field>Lease_doc_Created_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Lease doc Created Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lien_Waiver_Already_Sent</fullName>
        <field>Lien_Waiver_Already_Sent__c</field>
        <literalValue>1</literalValue>
        <name>Update Lien Waiver Already Sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opportunity_Owner_s_Manager</fullName>
        <description>Update Opportunity Owner&apos;s Manager</description>
        <field>Opportunity_Owner_s_Manager__c</field>
        <formula>Opportunity_Owner_s_Manager_text__c</formula>
        <name>Update Opportunity Owner&apos;s Manager</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Origination_Fees</fullName>
        <field>Origination__c</field>
        <formula>( Dealer_Fees__c *20)/100</formula>
        <name>Update Origination Fees</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Quote_Type_Binding_Offer</fullName>
        <field>Quote_Steps__c</field>
        <literalValue>Binding Offer</literalValue>
        <name>Update Quote Type - Binding Offer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_System_Size_PV</fullName>
        <description>Update System Size (PV)</description>
        <field>System_Size_PV__c</field>
        <formula>System_Size__c</formula>
        <name>Update System Size (PV)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Utility_Bill_Escalator</fullName>
        <field>Utility_Bill_Annual_Escalation__c</field>
        <formula>0</formula>
        <name>Utility Bill Escalator</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>uncheck_Adhoc_create_LDA</fullName>
        <field>Adhoc_Create_LDA__c</field>
        <literalValue>0</literalValue>
        <name>uncheck Adhoc create LDA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Conga_Send_for_Sig_Outbound_Msg</fullName>
        <apiVersion>26.0</apiVersion>
        <endpointUrl>https://workflow.appextremes.com/apps/Conga/PMWorkflow.aspx</endpointUrl>
        <fields>Conga_Solution_URL1__c</fields>
        <fields>Id</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>ssuser@sunpower.com</integrationUser>
        <name>Conga Send for Sig Outbound Msg</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Initiate_Conga_Workflow</fullName>
        <apiVersion>25.0</apiVersion>
        <endpointUrl>https://workflow.appextremes.com/apps/Conga/PMWorkflow.aspx</endpointUrl>
        <fields>CW_URL__c</fields>
        <fields>Id</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>datamigration@sunpowercorp.com</integrationUser>
        <name>Initiate Conga Workflow</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Adhoc Create LDA</fullName>
        <actions>
            <name>Adhoc_Create_LDA</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>uncheck_Adhoc_create_LDA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quote.Adhoc_Create_LDA__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Quote_type__c</field>
            <operation>notEqual</operation>
            <value>Residential New Homes Lease Quotation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.QuoteType__c</field>
            <operation>notEqual</operation>
            <value>Loan</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Adhoc Create LDA Loan</fullName>
        <actions>
            <name>Adhoc_Create_LDA_Loan</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Uncheck_Adhoc_Create_LDA_Loan</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quote.Adhoc_Create_LDA__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Quote_type__c</field>
            <operation>notEqual</operation>
            <value>Residential New Homes Lease Quotation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.QuoteType__c</field>
            <operation>equals</operation>
            <value>Loan</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Clear Fields on Quote Expiry</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Quote.ExpirationDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Year_1_PPA_Price__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Year_1_Savings__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.RecordTypeId</field>
            <operation>equals</operation>
            <value>Commercial Quote</value>
        </criteriaItems>
        <description>Clears the PPA Price and the Savings when the Quote Expiration Date has passed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Delete_PPA_Price</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Delete_PPA_Savings</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Quote.ExpirationDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Conga Send for Signature Workflow Exec</fullName>
        <actions>
            <name>Update_Lien_Waiver_Already_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Conga_Send_for_Sig_Outbound_Msg</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <formula>AND(Send_Lien_Waiver_Agreement__c, Trigger_Checkbox__c, NOT(Lien_Waiver_Already_Sent__c),
IF( ISNUMBER(IF(ISBLANK(Original_Lease_Number__c), Final_Lease_Number__c, Original_Lease_Number__c )), VALUE(IF(ISBLANK(Original_Lease_Number__c), Final_Lease_Number__c, Original_Lease_Number__c)) &gt; 27000, FALSE), 
Account__r.Partner_Account__r.Id &lt;&gt; &quot;0018000000v6FpP&quot; )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Conga Workflow Exec Mail</fullName>
        <actions>
            <name>Reset_Workflow_Trigger1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Initiate_Conga_Workflow</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Quote.Doc_out_for_signature__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy SM After Lock</fullName>
        <actions>
            <name>Copy_SM_After_Lock</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Quote.System_Model__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Is_Locked__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This is created by Amit Saha from IT Team to analyse one of the issues , it will deleted later</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy SM Before Lock</fullName>
        <actions>
            <name>Copy_SM_Before_Lock</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Quote.System_Model__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This is created by Amit Saha from IT Team to analyse one of the issues , it will deleted later</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy to SM from CopySMBeforeLock</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Quote.System_Model__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Copy_SM_Before_Lock__c</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <description>This is created by Amit Saha from IT Team . This WF will copy the value from Copy_SM_Before_Lock if Copy_SM_Before_Lock has a value and System_model__c is blank .To ensure if the value in System_Model__c is null then we  copied the val from backup field,</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Created Date</fullName>
        <actions>
            <name>Created_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quote.QuoteNumber</field>
            <operation>notEqual</operation>
            <value>NULL</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Is Selected Sets Locked</fullName>
        <actions>
            <name>Is_Locked_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quote.Is_Selected_Scenario__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Is_Quote_Locked__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>When a quote is locked in CPR the integration sets &quot;Is Selected&quot; field. For lease doc purpose the &quot;Is Locked&quot; field needs to be set. Instead of changing integration there is a workflow to set &quot;Is Locked&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Quote Created Notification</fullName>
        <actions>
            <name>New_Quote_Created</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Quote.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>New Quote Created Notification</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PV Cost %28Roll-Up Total%29</fullName>
        <actions>
            <name>PV_Cost_Roll_Up_Total</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quote.PV_Cost_Roll_Up__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>PV Cost (Roll-Up Total)</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Price Concession Update</fullName>
        <actions>
            <name>Price_Concession_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quote.Diff_Sales_and_List_Price_Total__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Components</value>
        </criteriaItems>
        <criteriaItems>
            <field>Pricebook2.Name</field>
            <operation>contains</operation>
            <value>Components</value>
        </criteriaItems>
        <description>Price Concession Update</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Quote Name Field Update</fullName>
        <actions>
            <name>Quote_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quote.Name</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Remove Date of Lease doc Created Date</fullName>
        <actions>
            <name>Remove_Date_of_Lease_doc_Created_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quote.Lease_Doc_Created__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Remove Date of Lease doc sent out for signature</fullName>
        <actions>
            <name>Remove_Date_of_Lease_doc_sent_out_for_si</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quote.Doc_out_for_signature__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Acknowledgement Email</fullName>
        <actions>
            <name>Aknowledgement_email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quote.Doc_out_for_signature__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Quote_type__c</field>
            <operation>notEqual</operation>
            <value>Residential New Homes Lease Quotation,TPS Quote</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.QuoteType__c</field>
            <operation>notEqual</operation>
            <value>Loan</value>
        </criteriaItems>
        <description>An Acknowledgment Email would be sent to the Oracle Vendor Email when an agreement is created.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send LDA</fullName>
        <actions>
            <name>Send_LDA_Mail</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Quote.Doc_out_for_signature__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>An Acknowledgment Email would be sent to the Oracle Vendor Email when an agreement is created.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Loan Acknowledgement Email</fullName>
        <actions>
            <name>Loan_aknowledgement_email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quote.Doc_out_for_signature__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Quote_type__c</field>
            <operation>notEqual</operation>
            <value>Residential New Homes Lease Quotation,TPS Quote</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.QuoteType__c</field>
            <operation>equals</operation>
            <value>Loan</value>
        </criteriaItems>
        <description>An Acknowledgment Email would be sent to the Oracle Vendor Email when an agreement is created.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Utility Bill Escalator to Zero</fullName>
        <actions>
            <name>Utility_Bill_Escalator</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>RecordType.Name = &apos;Proposal Quote&apos;  &amp;&amp;  Is_Locked__c = false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Unlock Quote Created</fullName>
        <actions>
            <name>Quote_Lock_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quote.Is_Locked__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Spectrum_Partner_Quote__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Unlock Quote Created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Consolidated Lease Number %28Dup%29 Index field</fullName>
        <actions>
            <name>Update_Consolidated_Lease_Number_Dup</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quote.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update Consolidated Lease Number (Dup) Index field</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Date of Lease doc sent out for signature</fullName>
        <actions>
            <name>Update_Date_of_Lease_doc_sent_out_for_si</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2) OR (3 AND 4 AND 5)</booleanFilter>
        <criteriaItems>
            <field>Quote.Doc_out_for_signature__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Spectrum_Partner_Quote__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Lease_doc_Sent_out_for_Signature__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Doc_out_for_signature__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Spectrum_Partner_Quote__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Date of Lease doc signed</fullName>
        <actions>
            <name>Update_Date_of_Lease_doc_signed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 AND 2 AND 6 AND 7) OR (3 AND 4 AND 5 AND 7)</booleanFilter>
        <criteriaItems>
            <field>Quote.Lease_Doc_Signed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Spectrum_Partner_Quote__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Lease_doc_Signed_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Spectrum_Partner_Quote__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Lease_Doc_Signed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Amendment_Doc_Signed__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Bypass_Workflow__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Lease doc Created Date</fullName>
        <actions>
            <name>Update_Lease_doc_Created_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2) OR (3 AND 4 AND 5)</booleanFilter>
        <criteriaItems>
            <field>Quote.Lease_Doc_Created__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Spectrum_Partner_Quote__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Lease_doc_Created_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Lease_Doc_Created__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Spectrum_Partner_Quote__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Opportunity Owner%27s Manager</fullName>
        <actions>
            <name>Update_Opportunity_Owner_s_Manager</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 Or 2</booleanFilter>
        <criteriaItems>
            <field>Quote.Opportunity_Owner_s_Manager__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Opportunity_Owner_s_Manager__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Update Opportunity Owner&apos;s Manager</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Origination and Interconnect</fullName>
        <actions>
            <name>Update_Construction_Fees</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Interconnect_Fees</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Origination_Fees</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow will update the Origination and Interconnect fees using new % split
New Home Leases doesn&apos;t follow the 20-60-20 split, hence, don&apos;t update the fields for NH Lease quotations</description>
        <formula>IF(AND(Account_Billing_Country__c &lt;&gt;&apos;France&apos;, NOT(ISPICKVAL(Quote_type__c , &quot;Residential New Homes Lease Quotation&quot;)) ), NOT( ISNULL( Dealer_Fees__c )), false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update System Size %28PV%29</fullName>
        <actions>
            <name>Update_System_Size_PV</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quote.PriceBook_Name__c</field>
            <operation>contains</operation>
            <value>Comp</value>
        </criteriaItems>
        <description>Update System Size (PV)</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Welcome Email for Lease</fullName>
        <actions>
            <name>Send_Welcome_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Sent_Welcome_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Welcome_Email_Sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND (3 or 4) and 5 and 6 AND 7 AND 8</booleanFilter>
        <criteriaItems>
            <field>Quote.Lease_Doc_Signed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Sent_Welcome_Email__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Lease_Status_Email_Opt_Out__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Lease_Status_Email_Opt_Out__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Partner_Account_text__c</field>
            <operation>notContain</operation>
            <value>SunPower</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.QuoteType__c</field>
            <operation>equals</operation>
            <value>Lease</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Amendment_Doc_Signed__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Bypass_Workflow__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Welcome_Email_Sent</fullName>
        <assignedTo>devon.westerholm@sunpowercorp.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>The Welcome Email has been sent to the Lessee Contact and Partner Account: Vendor Email</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Welcome Email Sent</subject>
    </tasks>
</Workflow>
