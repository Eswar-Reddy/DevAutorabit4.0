<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Alert_when_Opportunity_Assigned_To_RSM</fullName>
        <description>Alert when Opportunity Assigned To RSM</description>
        <protected>false</protected>
        <recipients>
            <field>RSM_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/OppAssignToRSM</template>
    </alerts>
    <alerts>
        <fullName>Binding_Offer_Quote_Approval_Email_Template_Sales_Team_Alert</fullName>
        <description>Binding Offer Quote Approval Email Template Sales Team Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>Application Engineer</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Construction Manager</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Developer (Partner User)</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Electrical Engineer</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Energy Efficiency Specialist</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Estimator</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Finance</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Legal</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Management</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Operations</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Operations and Maintenance</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Project Designer</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Project Engineer</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Project Manager</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Proposal Designer</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>SSR</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Analyst</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Manager</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Person</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Senior Project Manager</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Structured Finance</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Supply Chain</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <type>creator</type>
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
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Sales_Analyst__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/Binding_Offer_Final_Approval_vf</template>
    </alerts>
    <alerts>
        <fullName>CPP_AlertRSMofUpdatedProjectedDeliveryDate</fullName>
        <description>CPP-AlertRSMofUpdatedProjectedDeliveryDate</description>
        <protected>false</protected>
        <recipients>
            <field>RSM_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/OppAssignToRSM</template>
    </alerts>
    <alerts>
        <fullName>CVAR_Order_Acknowledgement</fullName>
        <ccEmails>cvar_order_acknowledgement@2860o8ebo4546l1bd535bg04m0fhoqaunptuw7saazat1hfr5m.8-zf1leaw.na29.apex.salesforce.com</ccEmails>
        <description>CVAR Order Acknowledgement</description>
        <protected>false</protected>
        <recipients>
            <recipient>israel.sureta@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>RLC_Commercial/CVAR_Order_Acknowledgement_Email</template>
    </alerts>
    <alerts>
        <fullName>CVAR_Pricing_Exception_Approved_Alert_EU</fullName>
        <description>CVAR Pricing Exception Approved Alert - EU</description>
        <protected>false</protected>
        <recipients>
            <field>PSR_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>RSM_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>RSMName__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/CVAR_Pricing_Exception_Approved</template>
    </alerts>
    <alerts>
        <fullName>CVAR_Pricing_Exception_Approved_Alert_EU_English</fullName>
        <description>CVAR Pricing Exception Approved Alert - EU English</description>
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
            <field>RSMName__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/CVAR_Pricing_Exception_Approved</template>
    </alerts>
    <alerts>
        <fullName>CVAR_Pricing_Exception_Approved_Alert_NA</fullName>
        <description>CVAR Pricing Exception Approved Alert - NA</description>
        <protected>false</protected>
        <recipients>
            <recipient>derek.noble@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>CRSM__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/CVAR_Pricing_Exception_Approved</template>
    </alerts>
    <alerts>
        <fullName>CVAR_Pricing_Exception_Approved_Alert_NA_RSM</fullName>
        <description>CVAR Pricing Exception Approved Alert - NA (RSM)</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>RSMName__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/CVAR_Pricing_Exception_Approved</template>
    </alerts>
    <alerts>
        <fullName>CVAR_Pricing_Exception_Recalled_Alert_EU</fullName>
        <description>CVAR Pricing Exception Recalled Alert - EU</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>RSMName__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/CVAR_Pricing_Exception_Recalled</template>
    </alerts>
    <alerts>
        <fullName>CVAR_Pricing_Exception_Recalled_Alert_NA</fullName>
        <description>CVAR Pricing Exception Recalled Alert - NA</description>
        <protected>false</protected>
        <recipients>
            <field>RSM_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>derek.noble@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>CRSM__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/CVAR_Pricing_Exception_Recalled</template>
    </alerts>
    <alerts>
        <fullName>CVAR_Pricing_Exception_Rejected_Alert_EU</fullName>
        <description>CVAR Pricing Exception Rejected Alert - EU</description>
        <protected>false</protected>
        <recipients>
            <field>RSM_Email__c</field>
            <type>email</type>
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
            <field>RSMName__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/CVAR_Pricing_Exception_Rejected</template>
    </alerts>
    <alerts>
        <fullName>CVAR_Pricing_Exception_Rejected_Alert_NA</fullName>
        <description>CVAR Pricing Exception Rejected Alert - NA</description>
        <protected>false</protected>
        <recipients>
            <recipient>derek.noble@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>CRSM__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/CVAR_Pricing_Exception_Rejected</template>
    </alerts>
    <alerts>
        <fullName>CVAR_Pricing_Exception_Submitted_for_Approval_EU</fullName>
        <description>CVAR Pricing Exception Submitted for Approval</description>
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
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/CVAR_Pricing_Exception_Submitted</template>
    </alerts>
    <alerts>
        <fullName>Close_Lost_Competitor_Information_Reminder_NAC</fullName>
        <description>Close Lost Competitor Information Reminder - NAC</description>
        <protected>false</protected>
        <recipients>
            <recipient>Sales Analyst</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>bill.kelly@sunpowercorp.com</recipient>
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
        <template>Opportunity/Close_Lost_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>Close_Lost_Stage_Notification</fullName>
        <ccEmails>dmitry.klimko@sunpower.com</ccEmails>
        <description>Close Won Stage Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>GlobalSalesOps</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>lindsey.wiedmann@sunpowercorp.com</recipient>
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
        <senderType>CurrentUser</senderType>
        <template>Workflow_Email_Alerts/Opportunity_Close_Lost</template>
    </alerts>
    <alerts>
        <fullName>Closing_Date_In_Current_Quarter</fullName>
        <description>Closing Date In Current Quarter</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
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
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Closing_Date_Within_Current_Quarter</template>
    </alerts>
    <alerts>
        <fullName>Commercial_Delivery_Pre_Alert_14_days_before_Delivery_Date</fullName>
        <ccEmails>salesforcearchives@sunpowercorp.com;cvar.psr@sunpowercorp.com</ccEmails>
        <description>Commercial Delivery Pre-Alert - 14 days before Delivery Date</description>
        <protected>false</protected>
        <recipients>
            <field>PSR_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>israel.sureta@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>CRSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>cvar.psr@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>RLC_Commercial/Com_Order_2weeks_Delivery_Pre_Alert</template>
    </alerts>
    <alerts>
        <fullName>Commercial_Delivery_Pre_Alert_28_days_before_Delivery_Date</fullName>
        <ccEmails>salesforcearchives@sunpowercorp.com;cvar.psr@sunpowercorp.com</ccEmails>
        <description>Commercial Delivery Pre-Alert - 28 days before Delivery Date</description>
        <protected>false</protected>
        <recipients>
            <field>PSR_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>israel.sureta@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>CRSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>cvar.psr@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>RLC_Commercial/Com_Order_4weeks_Delivery_Pre_Alert</template>
    </alerts>
    <alerts>
        <fullName>Commercial_Delivery_Pre_Alert_7_days_before_Delivery_Date</fullName>
        <ccEmails>salesforcearchives@sunpowercorp.com;cvar.psr@sunpowercorp.com</ccEmails>
        <description>Commercial Delivery Pre-Alert - 10 days before Delivery Date</description>
        <protected>false</protected>
        <recipients>
            <field>PSR_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>israel.sureta@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>CRSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>cvar.psr@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>RLC_Commercial/Com_Order_Delivery_7days_Pre_Alert</template>
    </alerts>
    <alerts>
        <fullName>Commercial_Financing_Request</fullName>
        <description>Commercial Financing Request</description>
        <protected>false</protected>
        <recipients>
            <recipient>james.coombes@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>CRSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Commercial_Financing_Request</template>
    </alerts>
    <alerts>
        <fullName>Commercial_Intl_100_Alert_PV_and_PV_BOS</fullName>
        <ccEmails>Vincent.Maurice@sunpower.com;</ccEmails>
        <ccEmails>Carole.Arenou@sunpowercorp.com;</ccEmails>
        <ccEmails>BERTRAND.BEGNEZ@sunpowercorp.com;</ccEmails>
        <description>Commercial Intl 100% Alert - PV and PV+BOS EU</description>
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
            <recipient>Designer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Developer (Partner User)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Development Engineer</recipient>
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
            <recipient>Opportunity Owner</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Procurement</recipient>
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
            <recipient>SSO Analyst</recipient>
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
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>christopherraymond.morandi@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eric.potts@sunpowercorp.com</recipient>
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
            <recipient>jean-baptiste.guillaume@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>pascale.bertrand@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_100_VF</template>
    </alerts>
    <alerts>
        <fullName>Commercial_Intl_100_Alert_PV_and_PV_BOS_APAC</fullName>
        <ccEmails>Vincent.Maurice@sunpower.com;</ccEmails>
        <description>Commercial Intl 100% Alert - PV and PV+BOS APAC</description>
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
            <recipient>Designer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Developer (Partner User)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Development Engineer</recipient>
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
            <recipient>Opportunity Owner</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Procurement</recipient>
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
            <recipient>SSO Analyst</recipient>
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
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>christopherraymond.morandi@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eric.potts@sunpowercorp.com</recipient>
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
            <recipient>jean-baptiste.guillaume@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>shingo.tajiri@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_100_VF</template>
    </alerts>
    <alerts>
        <fullName>Customer_Design_Review_Reminder_SPD</fullName>
        <description>Customer Design Review Reminder (SPD)</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sunpowerdirect@sunpower.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opportunity/Design_Sign_Off_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Customer_Design_Review_SPD</fullName>
        <description>Customer Design Review (SPD)</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sunpowerdirect@sunpower.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opportunity/Design_Sign_Off</template>
    </alerts>
    <alerts>
        <fullName>Customer_Design_Review_SPD_Approved</fullName>
        <ccEmails>sse.psr@sunpower.com;SPD_PC@sunpowercorp.com</ccEmails>
        <description>Customer Design Review (SPD) Approved</description>
        <protected>false</protected>
        <recipients>
            <field>Installer_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sunpowerdirect@sunpower.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opportunity/Customer_Design_Accepted_SPD</template>
    </alerts>
    <alerts>
        <fullName>Customer_Design_Review_SPD_Installer_Notification</fullName>
        <ccEmails>sse.psr@sunpower.com;SPD_PC@sunpowercorp.com</ccEmails>
        <description>Customer Design Review (SPD) - Installer Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Installer_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sunpowerdirect@sunpower.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opportunity/Design_Sign_Off_Notification</template>
    </alerts>
    <alerts>
        <fullName>Customer_Design_Review_SPD_Rejected</fullName>
        <ccEmails>sse.psr@sunpower.com;SPD_PC@sunpowercorp.com</ccEmails>
        <description>Customer Design Review (SPD) Rejected</description>
        <protected>false</protected>
        <recipients>
            <field>Installer_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sunpowerdirect@sunpower.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opportunity/Customer_Design_Rejected_SPD</template>
    </alerts>
    <alerts>
        <fullName>Dealer_Reassigned_Email_To_Customer</fullName>
        <ccEmails>salesforcearchives@sunpowercorp.com</ccEmails>
        <description>Dealer Reassigned Email To Customer</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>customersolutions@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opportunity/New_Dealer_ReAssigned_Email_To_Customer</template>
    </alerts>
    <alerts>
        <fullName>EU_Post_Visit_Survey</fullName>
        <description>EU Post Visit Survey</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>solarit@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opportunity/EU_Post_Visit_Survey_2</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_if_opportunity_stage_is_Installation_Completed</fullName>
        <description>Email Alert if opportunity stage is Installation Completed</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>End_Customer_Survey_Result/Opportunity_Stage_Installation_Completed_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Email_Approved_Notification</fullName>
        <description>Email Approved Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>crmadmin@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opportunity/Email_Approved</template>
    </alerts>
    <alerts>
        <fullName>Email_Declined_Notification</fullName>
        <description>Email Declined Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>crmadmin@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opportunity/Email_Declined</template>
    </alerts>
    <alerts>
        <fullName>Email_Pending_Notification</fullName>
        <description>Email Pending Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>crmadmin@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opportunity/Email_Pending</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_to_French_Contact_if_customer_survey_become_true</fullName>
        <description>Email alert to French Contact if customer survey become true</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>solarfr@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>End_Customer_Survey_Result/CSAT_French_Survey_LH</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_to_German_Contact_if_customer_survey_become_true</fullName>
        <description>Email alert to German Contact if customer survey become true</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>solarde@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>End_Customer_Survey_Result/CSAT_German_Survey_LH</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_to_Italian_Contact_if_customer_survey_become_true</fullName>
        <description>Email alert to Italian Contact if customer survey become true</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>solarit@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>End_Customer_Survey_Result/CSAT_Italy_Survey_LH</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_when_Opportunity_Sales_Stage_is_updated_to_Closed_Lost_NAC</fullName>
        <description>Email notification when Opportunity Sales Stage is updated to Closed Lost - NAC</description>
        <protected>false</protected>
        <recipients>
            <recipient>Management</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Project Manager</recipient>
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
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>arthur.kegels@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eric.potts@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jeremy.kuhre@sunpowercorp.com</recipient>
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
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Closed_Lost_Email_Alert</template>
    </alerts>
    <alerts>
        <fullName>Email_when_an_Opportunity_Close_Date_is_past_due_IBD</fullName>
        <description>Email when an Opportunity Close Date is past due - UPPi Asia</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>frederic.biollaz@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>manuel.brachet@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_Email_Alerts/Close_Date_Past_Due</template>
    </alerts>
    <alerts>
        <fullName>Email_when_an_Opportunity_Close_Date_is_past_due_NAC</fullName>
        <description>Email when an Opportunity Close Date is past due - NAC</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
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
        <senderType>CurrentUser</senderType>
        <template>Workflow_Email_Alerts/Close_Date_Past_Due</template>
    </alerts>
    <alerts>
        <fullName>Email_when_an_Opportunity_Close_Date_is_past_due_UPP_Americas</fullName>
        <description>Email when an Opportunity Close Date is past due - UPP Americas</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
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
        <senderType>CurrentUser</senderType>
        <template>Workflow_Email_Alerts/Close_Date_Past_Due</template>
    </alerts>
    <alerts>
        <fullName>Email_when_an_Opportunity_Close_Date_is_past_due_UPP_Intl</fullName>
        <description>Email when an Opportunity Close Date is past due - UPP Intl</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>frederic.biollaz@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mario.riello@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_Email_Alerts/Close_Date_Past_Due</template>
    </alerts>
    <alerts>
        <fullName>Financed_CVAR_Opportunity_Stage_Update</fullName>
        <description>Financed CVAR Opportunity Stage Update</description>
        <protected>false</protected>
        <recipients>
            <recipient>james.coombes@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jayroy.aragones@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Financed_Commercial_Opps_Stage_Update</template>
    </alerts>
    <alerts>
        <fullName>Financing_Team_Alert_Financing_Application</fullName>
        <ccEmails>financing@sunpowercorp.com</ccEmails>
        <description>Financing Team Alert - Financing Application</description>
        <protected>false</protected>
        <recipients>
            <recipient>james.coombes@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>financing@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opportunity/Financing_Team_Alert_Financing_Application</template>
    </alerts>
    <alerts>
        <fullName>FivePercentageDownPayment</fullName>
        <ccEmails>fivepercentagedownpayment@2rwyliy7wpvoaon5n0v55mlxhm47mh1k3fjcf3iyyxugmlgute.8-zf1leaw.na29.apex.salesforce.com</ccEmails>
        <description>FivePercentageDownPayment</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>RLC_Commercial/FivePercentageDownPayment</template>
    </alerts>
    <alerts>
        <fullName>Follow_up_with_OPPORTUNITY</fullName>
        <description>Follow-up with OPPORTUNITY</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/follow_up_with_OPPORTUNITY_NAME</template>
    </alerts>
    <alerts>
        <fullName>Homeowner_Install_Survey_Notification_Alert_NA_Cash</fullName>
        <description>Homeowner Install Survey Notification Alert - NA Cash</description>
        <protected>false</protected>
        <recipients>
            <field>Project_Coordinator__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>csatstakeholders@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opportunity/Homeowner_Install_Survey_Email_to_Notify_Dealer</template>
    </alerts>
    <alerts>
        <fullName>Homeowner_Install_Survey_Notification_Alert_NA_Lease</fullName>
        <description>Homeowner Install Survey Notification Alert - NA Lease</description>
        <protected>false</protected>
        <recipients>
            <field>Project_Coordinator__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>csatstakeholders@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opportunity/Homeowner_Install_Survey_Email_to_Notify_Dealer</template>
    </alerts>
    <alerts>
        <fullName>Initiate_Credit_Approval_for_Host_Credit</fullName>
        <description>Initiate Credit Approval for Host Credit</description>
        <protected>false</protected>
        <recipients>
            <recipient>Sales Analyst</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Person</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Initiate_Credit_Approval_for_Host_Credit</template>
    </alerts>
    <alerts>
        <fullName>Introductory_email</fullName>
        <ccEmails>phil.fang@cloudsherpas.com</ccEmails>
        <description>Introductory email</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Introductory_email</template>
    </alerts>
    <alerts>
        <fullName>Large_Deal_Email_Alert_NAC</fullName>
        <description>Large Deal Email Alert - NAC</description>
        <protected>false</protected>
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
            <recipient>michael.quincey@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Large_Deal_Email_Alert_NAC</template>
    </alerts>
    <alerts>
        <fullName>Mt_Diablo_Lead_Gen_Campaign_On_Closed_Opportunity</fullName>
        <ccEmails>ian@ecomarkusa.com</ccEmails>
        <description>Mt. Diablo Lead Gen Campaign On Closed Opportunity</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>marketing@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opportunity/Mt_Diablo_Lead_Gen_Campaign_On_Closed_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>NewHomesOpportunity_Appt_Confirmation</fullName>
        <description>NewHomesOpportunity: Appt Confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>EC_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Primary_Res_Opp_Recip_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Res_Opp_Recipient_CC_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>newsolarhome@sunpower.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Solar_Advisor_Email_Templates/New_Homes_Opportunity_appt_confirmation</template>
    </alerts>
    <alerts>
        <fullName>New_Homes_Lead_Appt_Confirmation</fullName>
        <description>NewHomesLead: Appt Confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>EC_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Primary_Res_Opp_Recip_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Res_Opp_Recipient_CC_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>newsolarhome@sunpower.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Partner_Portal/NewHomesLead_Appt_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>New_Opportunity_Created_Notice_NAC</fullName>
        <description>New Opportunity Created Notice - NAC</description>
        <protected>false</protected>
        <recipients>
            <recipient>arnold.macatangay@sunpowercorp.com</recipient>
            <type>user</type>
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
            <recipient>lalaine.andaya@sunpowercorp.com</recipient>
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
        <senderType>CurrentUser</senderType>
        <template>Opportunity/New_Opportunity_Created_Template</template>
    </alerts>
    <alerts>
        <fullName>New_Opportunity_Created_by_Hiroshi_Amano_or_Arun_Kumar</fullName>
        <description>New Opportunity Created by Hiroshi Amano or Arun Kumar</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/New_Opportunity_Created_by</template>
    </alerts>
    <alerts>
        <fullName>New_RLC_Opportunity_Created_NA</fullName>
        <description>New RLC Opportunity Created - NA</description>
        <protected>false</protected>
        <recipients>
            <field>PSR_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>CRSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/New_RLC_Opportunity_Created_Template</template>
    </alerts>
    <alerts>
        <fullName>New_Residential_Opportunity_Created_France_TPO_Cash</fullName>
        <description>New Residential Opportunity Created: France TPO-Cash</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Solar_Advisor_Email_Templates/FR_New_Lead_Cash_Preferred</template>
    </alerts>
    <alerts>
        <fullName>New_Residential_Opportunity_Created_France_TPO_Lease</fullName>
        <description>New Residential Opportunity Created: France TPO-Lease</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Solar_Advisor_Email_Templates/FR_New_Lead_Email_TPO_Preferred</template>
    </alerts>
    <alerts>
        <fullName>New_Residential_Opportunity_Created_NA_Alliance</fullName>
        <ccEmails>CRM-Audit@sunpower.com</ccEmails>
        <description>New Residential Opportunity Created - NA Alliance</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Primary_Res_Opp_Recip_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Res_Opp_Recipient_CC_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>allianceprogram@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Solar_Advisor_Email_Templates/Meet_Your_Partner_NA_Alliance</template>
    </alerts>
    <alerts>
        <fullName>New_Residential_Opportunity_Created_NA_Alliance_with_Lead_Source_Event_Seminar_W</fullName>
        <ccEmails>CRM-Audit@sunpower.com</ccEmails>
        <description>New Residential Opportunity Created - NA Alliance  with Lead Source (Events / Tradeshow)</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Primary_Res_Opp_Recip_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Res_Opp_Recipient_CC_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>allianceprogram@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Solar_Advisor_Email_Templates/Meet_Your_Partner_NA_Alliance_for_Event</template>
    </alerts>
    <alerts>
        <fullName>New_Residential_Opportunity_Created_NA_No_Campaign</fullName>
        <ccEmails>CRM-Audit@sunpower.com</ccEmails>
        <description>New Residential Opportunity - HO notification NA Standard or No Campaign</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Primary_Res_Opp_Recip_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Res_Opp_Recipient_CC_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sunpowersales.support@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Solar_Advisor_Email_Templates/Meet_Your_Partner_NA</template>
    </alerts>
    <alerts>
        <fullName>New_Residential_Opportunity_Created_NA_Standard</fullName>
        <ccEmails>CRM-Audit@sunpower.com</ccEmails>
        <description>New Residential Opportunity Created - NA Standard</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Primary_Res_Opp_Recip_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Res_Opp_Recipient_CC_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>customersupport@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Solar_Advisor_Email_Templates/Meet_Your_Partner_NA_Non_Alliance</template>
    </alerts>
    <alerts>
        <fullName>New_Residential_Opportunity_Created_Partner_Follow_Up_France_TPO</fullName>
        <description>New Residential Opportunity Created: Partner Follow-Up France TPO</description>
        <protected>false</protected>
        <recipients>
            <field>Res_Opp_Recipient_CC_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/France_TPO_New_Residential_Opportunity_Partner_Follow_Up_Template</template>
    </alerts>
    <alerts>
        <fullName>New_Residential_Opportunity_Partner_Follow_Up_Template</fullName>
        <ccEmails>CRM-Audit@sunpower.com</ccEmails>
        <description>New Residential Opportunity - Partner Follow-Up Template</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Res_Opp_Recip_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Res_Opp_Recipient_CC_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>customersupport@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Solar_Advisor_Email_Templates/New_Residential_Opportunity_Partner_Follow_Up_Template</template>
    </alerts>
    <alerts>
        <fullName>New_Residential_Opportunity_Partner_Follow_Up_Template_NA_Alliance</fullName>
        <ccEmails>CRM-Audit@sunpower.com</ccEmails>
        <description>New Residential Opportunity - Partner Follow-Up Template (NA Alliance)</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Res_Opp_Recip_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Res_Opp_Recipient_CC_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>allianceprogram@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Solar_Advisor_Email_Templates/New_Residential_Opportunity_Partner_Follow_Up_Template</template>
    </alerts>
    <alerts>
        <fullName>New_Residential_Opportunity_Partner_Follow_Up_with_Converted_Rating_Template</fullName>
        <description>New Residential Opportunity - Partner Follow-Up with Converted Rating Template</description>
        <protected>false</protected>
        <recipients>
            <field>Res_Opp_Recipient_CC_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/New_Residential_Opportunity_Partner_Follow_Up_with_Converted_Rating_Template</template>
    </alerts>
    <alerts>
        <fullName>New_Residential_Opportunity_Spectrum_Partner_Follow_Up_Template</fullName>
        <ccEmails>CRM-Audit@sunpower.com</ccEmails>
        <description>New Residential Opportunity - Spectrum Partner Follow-Up Template</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Res_Opp_Recip_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Res_Opp_Recipient_CC_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/New_Residential_Opportunity_Spectrum_Partner_Follow_Up_Template</template>
    </alerts>
    <alerts>
        <fullName>New_SPD_Opportunity_Campaign_Specific</fullName>
        <description>New SPD Opportunity - Campaign Specific</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sunpowerdirect@sunpower.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SSE_Direct_Sales/SPD_Campaign_Appointment_Template</template>
    </alerts>
    <alerts>
        <fullName>New_SSE_Opportunity</fullName>
        <ccEmails>solaradvisors@sunpowercorp.com;</ccEmails>
        <ccEmails>andrew.head@sunpowercorp.com</ccEmails>
        <ccEmails>kevin.cool@sunpowercorp.com</ccEmails>
        <description>New SPD Opportunity - for SPD</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>christopher.curtis@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jacqueline.karsnia@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sara.wilson@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>swati.verma@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>whitney.torres@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>william.stockton@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>customersupport@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opportunity/New_Opportunity_Created</template>
    </alerts>
    <alerts>
        <fullName>No_Customer_Design_Off_SPD</fullName>
        <ccEmails>sse.psr@sunpower.com;SPD_PC@sunpowercorp.com</ccEmails>
        <description>No Customer Design-Off (SPD)</description>
        <protected>false</protected>
        <recipients>
            <field>Installer_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sunpowerdirect@sunpower.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opportunity/No_Design_Sign_Off_Notification_SPD</template>
    </alerts>
    <alerts>
        <fullName>No_PPF_Notification_30_Days</fullName>
        <description>No PPF Notification - 30 Days</description>
        <protected>false</protected>
        <recipients>
            <field>PSR_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>CRSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/No_PPF_Notification_30_Days</template>
    </alerts>
    <alerts>
        <fullName>OPPORTUNITY_ALR_Manual_Review_Email_Alert</fullName>
        <description>OPPORTUNITY ALR Manual Review Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>Lead_Opps_Manual_Review_Group</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>crmadmin@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opportunity/Opportunity_ALR_Manual_Review_Template</template>
    </alerts>
    <alerts>
        <fullName>O_M_Only_Deal_Alert</fullName>
        <description>O&amp;M Only Deal Alert - NAC</description>
        <protected>false</protected>
        <recipients>
            <recipient>eric.potts@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>michael.moone@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>michael.yellin@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/O_M_Only_Deal_Alert</template>
    </alerts>
    <alerts>
        <fullName>O_M_Only_Deal_Alert_UPP_Americas</fullName>
        <description>O&amp;M Only Deal Alert - UPP Americas</description>
        <protected>false</protected>
        <recipients>
            <recipient>michael.moone@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/O_M_Only_Deal_Alert</template>
    </alerts>
    <alerts>
        <fullName>O_M_Only_Deal_Alert_UPP_Intl</fullName>
        <ccEmails>JoseMaria.GuineaLlorente@sunpowercorp.com</ccEmails>
        <description>O&amp;M Only Deal Alert - UPP Intl</description>
        <protected>false</protected>
        <recipients>
            <recipient>eduardo.martingurrea@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>fernando.herrerias@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>frederic.biollaz@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>guthrie.dundas@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mario.riello@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>michael.moone@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>steve.hanawalt@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/O_M_Only_Deal_Alert</template>
    </alerts>
    <alerts>
        <fullName>Online_Appointment_notification_email_alert_for_opportunity_SPD_Reminder</fullName>
        <ccEmails>solaradvisors@sunpower.com</ccEmails>
        <description>Online Appointment notification email alert for opportunity (SPD) Reminder</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>EC_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>solaradvisors@sunpower.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SSE_Direct_Sales/Online_Appointment_SPD_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Online_Appointment_notification_email_alert_to_contact_and_Res_Opp_Recipient</fullName>
        <description>Online Appointment notification email alert for opportunity (SPD)</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>EC_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>solaradvisors@sunpower.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SSE_Direct_Sales/Online_Appointment_SunPower_Direct</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Alert_For_Record_Type_Home_Owner_Status_Qualified</fullName>
        <ccEmails>customercare@sunpowercorp.com</ccEmails>
        <description>Opportunity Alert For Record Type Home Owner Status Qualified</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Solar_Advisor_Email_Templates/Customer_Service_Regular_HO_Opp_VF</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Created_By_Arun_Kumar_Yashwant_Jain_Pradeep_Sangwan</fullName>
        <description>Opportunity Created By Arun Kumar, Yashwant Jain, Pradeep Sangwan</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/New_Opportunity_Created_by</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Created_by_Yiqun_Wang</fullName>
        <description>Opportunity Created by Takashi Sugihara and Hiroshi Amano</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/New_Opportunity_Created</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Edited_by_Hiroshi_Amano_or_Arun_Kumar</fullName>
        <description>Opportunity Edited by Hiroshi Amano or Arun Kumar</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Opportunity_has_been_Edited_By</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Has_been_in_90_for_3_Days</fullName>
        <description>Opportunity Has been in 90% for 3 Days</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Opportunity</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Lost_Reassignment_Email_Alert_CS</fullName>
        <ccEmails>customersolutions@sunpowercorp.com</ccEmails>
        <description>Opportunity Lost Reassignment Email Alert CS</description>
        <protected>false</protected>
        <recipients>
            <recipient>alvinchristian.alfonso@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Opportunity_Lost_Email_Alert_to_CSR</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Modified_by_Arun_Kumar_Yashwant_Jain_Pradeep_Sangwan</fullName>
        <description>Opportunity Modified by Arun Kumar, Yashwant Jain, Pradeep Sangwan</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Opportunity_has_been_modified</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Modified_by_Takashi_Sugihara_and_Yiqun_Wang</fullName>
        <description>Opportunity Modified by Takashi Sugihara and Hiroshi Amano</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Opportunity_has_been_modified</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Stage_Agreements_Finalized_Americas_Design_Team</fullName>
        <ccEmails>Priyantha.Sirisooriya@sunpowercorp.com</ccEmails>
        <description>Opportunity Stage Agreements Finalized - Americas Design Team</description>
        <protected>false</protected>
        <recipients>
            <recipient>deepa.ananthakrishnan@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>murat.karakum@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rclark@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>romeo.nido@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ryan.phillips@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sasha.rayatkah@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>stephen.adelson@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>thang.le@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Opportunity_Stage_Agreements_Finalized</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Stage_Negotiated_Contract_Americas_Design_Team</fullName>
        <ccEmails>Priyantha.Sirisooriya@sunpowercorp.com</ccEmails>
        <description>Opportunity Stage Negotiated Contract - Americas Design Team</description>
        <protected>false</protected>
        <recipients>
            <recipient>deepa.ananthakrishnan@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>murat.karakum@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rclark@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>romeo.nido@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ryan.phillips@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sasha.rayatkah@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>stephen.adelson@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>thang.le@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Opportunity_Stage_Negotiate_Contract</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_is_Closed_Lost_UPP_Americas</fullName>
        <description>Email notification when Opportunity Sales Stage is updated to Closed Lost - UPP Americas</description>
        <protected>false</protected>
        <recipients>
            <recipient>Management</recipient>
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
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>brian.ross@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eric.potts@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>frederic.biollaz@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>matt.white@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nam.nguyen@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Closed_Lost_Email_Alert</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_is_Closed_Lost_UPP_Intl</fullName>
        <description>Email notification when Opportunity Sales Stage is updated to Closed Lost - UPP Intl</description>
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
            <recipient>Finance</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Management</recipient>
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
            <recipient>alsantos@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>chris.obrien@sunpowercorp.com</recipient>
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
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sol.antonano@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Closed_Lost_Email_Alert</template>
    </alerts>
    <alerts>
        <fullName>PPF_Acknowledgement</fullName>
        <ccEmails>NA-TSE-SystemDesign@sunpowercorp.com;salesforcearchives@sunpowercorp.com;cvar.psr@sunpowercorp.com</ccEmails>
        <description>PPF Acknowledgement</description>
        <protected>false</protected>
        <recipients>
            <field>PSR_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>israel.sureta@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>CRSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>cvar.psr@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>RLC_Commercial/PPF_Receipt_Acknowledgement</template>
    </alerts>
    <alerts>
        <fullName>Pre_Purchase_Review_Form_Reminder</fullName>
        <ccEmails>salesforcearchives@sunpowercorp.com</ccEmails>
        <description>Pre-Purchase Review Form Reminder</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>israel.sureta@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>dealerservicerepresentative@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>RLC_Commercial/Pre_Purchase_Review_Form_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Price_Concession_Changed_After_Approved</fullName>
        <description>Price Concession Changed After Approved - NA CVAR</description>
        <protected>false</protected>
        <recipients>
            <recipient>jeff.cavros@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_Email_Alerts/Price_Concession_Changed_After_Approved</template>
    </alerts>
    <alerts>
        <fullName>SPJP_Pricing_Exception_Approved_Alert</fullName>
        <description>SPJP Pricing Exception Approved Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/SPJP_Pricing_Exception_Approved</template>
    </alerts>
    <alerts>
        <fullName>SPJP_Pricing_Exception_Rejected_Alert</fullName>
        <description>SPJP Pricing Exception Rejected Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/SPJP_Pricing_Exception_Rejected</template>
    </alerts>
    <alerts>
        <fullName>SPJP_Pricing_Exception_Submitted_for_Approval</fullName>
        <description>SPJP Pricing Exception Submitted for Approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/SPJP_Pricing_Exception_Submitted</template>
    </alerts>
    <alerts>
        <fullName>SSE_Installer_Introduction</fullName>
        <ccEmails>sse.psr@sunpowercorp.com;</ccEmails>
        <description>SSE - Installer Introduction</description>
        <protected>false</protected>
        <recipients>
            <field>Installer_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sunpowerdirect@sunpower.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SSE_Direct_Sales/Installation_Email_Welcome</template>
    </alerts>
    <alerts>
        <fullName>Send_Lease_Welcome_Email_SPD</fullName>
        <ccEmails>sse.psr@sunpower.com;SPD_PC@sunpowercorp.com</ccEmails>
        <description>Send Lease Welcome Email (SPD)</description>
        <protected>false</protected>
        <recipients>
            <field>Installer_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sunpowerdirect@sunpower.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opportunity/Lease_Welcome_Email</template>
    </alerts>
    <alerts>
        <fullName>Send_Partner_Intro_Appointment_Email_for_Pre_Qualified_Campaign_Opps</fullName>
        <description>Send Partner Intro/Appointment Email for Pre-Qualified Campaign Opps</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Primary_Res_Opp_Recip_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Res_Opp_Recipient_CC_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>solaradvisors@sunpower.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Solar_Advisor_Email_Templates/Partner_Pre_Qual_Intro_and_Appointment</template>
    </alerts>
    <alerts>
        <fullName>Site_Appointment_notification_email_alert_to_contact_and_opp_owner</fullName>
        <ccEmails>solaradvisors@sunpower.com</ccEmails>
        <description>Site Appointment notification email alert for opportunity (SPD)</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>EC_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>solaradvisors@sunpower.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SSE_Direct_Sales/Site_Appt_with_photo_bio_SPD</template>
    </alerts>
    <alerts>
        <fullName>Stage_Negotiate_Contract_NAC</fullName>
        <ccEmails>Cody.Kyber@sunpowercorp.com</ccEmails>
        <description>Open project in e-Builder – NAC and UPP</description>
        <protected>false</protected>
        <recipients>
            <recipient>Project Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Analyst</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>julie.williamson@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>william.yeager@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Stage_Negotiate_ContractVF</template>
    </alerts>
    <alerts>
        <fullName>System_is_Producing_Energy_Cash_SPD</fullName>
        <ccEmails>sse.psr@sunpower.com;SPD_PC@sunpowercorp.com</ccEmails>
        <description>System is Producing Energy Cash - (SPD)</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sunpowerdirect@sunpower.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opportunity/Cash_System_is_On</template>
    </alerts>
    <alerts>
        <fullName>TESTPartner</fullName>
        <description>TESTPartner</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/TESTPartner</template>
    </alerts>
    <alerts>
        <fullName>UPPi_100_Alert_PV_and_PV_BOS</fullName>
        <description>UPPi 100% Alert - PV and PV+BOS</description>
        <protected>false</protected>
        <recipients>
            <recipient>christopherraymond.morandi@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>frederic.biollaz@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_100_VF</template>
    </alerts>
    <alerts>
        <fullName>Warm_Transfer_Intro_Email_Alert</fullName>
        <description>Warm Transfer Intro Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Primary_Res_Opp_Recip_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Res_Opp_Recipient_CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>sunpowerdirect@sunpower.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Solar_Advisor_Email_Templates/Meet_Your_SunPower_Partner</template>
    </alerts>
    <alerts>
        <fullName>Warranty_Card_Acknowledgement_Email</fullName>
        <description>Warranty Card Acknowledgement Email</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>csr1@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Solar_Advisor_Email_Templates/Warranty_Home_Owner_Acknowledgement_Email</template>
    </alerts>
    <alerts>
        <fullName>Welcome_Email_for_Cash_SPD</fullName>
        <ccEmails>sse.psr@sunpowercorp.com;</ccEmails>
        <ccEmails>SPD_PC@sunpowercorp.com</ccEmails>
        <description>Welcome Email for Cash (SPD)</description>
        <protected>false</protected>
        <recipients>
            <field>Installer_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sunpowerdirect@sunpower.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opportunity/Cash_Welcome_Email</template>
    </alerts>
    <alerts>
        <fullName>Workflow_process_that_triggers_an_email_notification_being_sent_to_the_Manila_Te</fullName>
        <description>Workflow process that triggers an email notification being sent to the Manila Team Member on the Sales Team to Create an Oracle Number</description>
        <protected>false</protected>
        <recipients>
            <recipient>SSR</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SunPower/Oracle_Order_Creation_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Workflow_process_that_triggers_an_email_notification_to_Opportunity_Owner_when_t</fullName>
        <description>Workflow process that triggers an email notification to Opportunity Owner when the Last Modified Date  has not changed for 6 months</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Dormant_Opportunity_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Workflow_process_that_triggers_an_email_notification_to_the_NAC_Ops_Team_when_Op</fullName>
        <ccEmails>dmitry.klimko@sunpower.com</ccEmails>
        <description>Workflow process that triggers an email notification to the NAC Ops Team when Opportunity Sales Stage is updated to Closed Won.</description>
        <protected>false</protected>
        <recipients>
            <recipient>Sales Analyst</recipient>
            <type>opportunityTeam</type>
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
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Closed_Won_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Workflow_process_that_triggers_an_email_notification_to_the_Opportunity_owner_if</fullName>
        <description>Workflow process that triggers an email notification to the Opportunity owner if the Opportunity Sales Stage is updated to Closed Lost.</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Closed_Lost_Email_Alert</template>
    </alerts>
    <alerts>
        <fullName>X100_Probability_Business_Development_Region_Territory</fullName>
        <description>100% Probability Business Development Region Territory</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>scott.mchugo@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_BDRT_100_VF</template>
    </alerts>
    <alerts>
        <fullName>X100_Probability_Commercial_Intl_U_C</fullName>
        <ccEmails>Vincent.Maurice@sunpower.com;</ccEmails>
        <ccEmails>Carole.Arenou@sunpowercorp.com;</ccEmails>
        <ccEmails>BERTRAND.BEGNEZ@sunpowercorp.com;</ccEmails>
        <description>100% Probability (Commercial Intl) - U&amp;C EU</description>
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
            <recipient>Designer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Developer (Partner User)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Development Engineer</recipient>
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
            <recipient>Opportunity Owner</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Procurement</recipient>
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
            <recipient>SSO Analyst</recipient>
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
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>christopherraymond.morandi@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eric.potts@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>erik.burkhardt@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jdawe@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jean-baptiste.guillaume@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>pascale.bertrand@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>patrice.clement@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_100_VF</template>
    </alerts>
    <alerts>
        <fullName>X100_Probability_Commercial_Intl_U_C_APAC</fullName>
        <ccEmails>Vincent.Maurice@sunpower.com;</ccEmails>
        <ccEmails>Carole.Arenou@sunpowercorp.com;</ccEmails>
        <description>100% Probability (Commercial Intl) - U&amp;C APAC</description>
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
            <recipient>Designer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Developer (Partner User)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Development Engineer</recipient>
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
            <recipient>Opportunity Owner</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Procurement</recipient>
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
            <recipient>SSO Analyst</recipient>
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
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>christopherraymond.morandi@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eric.potts@sunpowercorp.com</recipient>
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
            <recipient>jean-baptiste.guillaume@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>shingo.tajiri@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>zach.struyk@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_100_VF</template>
    </alerts>
    <alerts>
        <fullName>X100_Probability_NAC</fullName>
        <ccEmails>naplanners@sunpowercorp.com</ccEmails>
        <ccEmails>globalproposaldesk@sunpowercorp.com</ccEmails>
        <ccEmails>Robert.Eicher@sunpowercorp.com</ccEmails>
        <ccEmails>Catherine.Roberts@sunpowercorp.com</ccEmails>
        <description>100% Probability (NAC)</description>
        <protected>false</protected>
        <recipients>
            <recipient>GlobalSalesOps</recipient>
            <type>group</type>
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
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>amy.smith3@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>bill.kelly@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>bruce.dickinson@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>christopherraymond.morandi@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>diana.ganibe@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eric.potts@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>erica.schroeder@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>flora.mercurio@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ingrid.ekstrom@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jenny.kwon@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>joshua.lee@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>julie.kirkenslager@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>julie.williamson@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>landon.daft@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lindsey.wiedmann@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>matt.white@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>michael.moone@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>michael.yellin@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nathan.griset@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>penelope.sabater@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rhodora.cayanan@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rredlinger@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sasha.rayatkah@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>scott.davidson@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sol.antonano@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>steven.scott@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_100_VF</template>
    </alerts>
    <alerts>
        <fullName>X100_Probability_NAC_2</fullName>
        <ccEmails>Pat.Pokorny@sunpowercorp.com</ccEmails>
        <ccEmails>Robert.Eicher@sunpowercorp.com</ccEmails>
        <description>100% Probability (NAC) - 2</description>
        <protected>false</protected>
        <recipients>
            <recipient>joanne.chang@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>michael.moone@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>michael.yellin@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>penelope.sabater@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>timothy.wallace@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_100_VF</template>
    </alerts>
    <alerts>
        <fullName>X100_Probability_UPP_Americas</fullName>
        <ccEmails>terrell.thomas@sunpowercorp.com</ccEmails>
        <ccEmails>beatriz.mena@sunpowercorp.com</ccEmails>
        <ccEmails>naplanners@sunpowercorp.com</ccEmails>
        <ccEmails>Andrew.Hall@sunpowercorp.com</ccEmails>
        <ccEmails>Pat.Pokorny@sunpowercorp.com</ccEmails>
        <description>100% Probability (UPP Americas)</description>
        <protected>false</protected>
        <recipients>
            <recipient>GlobalSalesOps</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>Management</recipient>
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
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>christopherraymond.morandi@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>cindy.detorres@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eric.potts@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>frederic.biollaz@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>gladys.razon@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ingrid.ekstrom@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>julie.kirkenslager@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>julie.williamson@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>matt.white@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>maureen.obiri@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nam.nguyen@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rclark@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ryan.phillips@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sol.antonano@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_100_VF</template>
    </alerts>
    <alerts>
        <fullName>X100_Probability_UPP_Americas_1</fullName>
        <ccEmails>Ash.Golani@sunpowercorp.com</ccEmails>
        <ccEmails>Robert.Eicher@sunpowercorp.com</ccEmails>
        <description>100% Probability - (UPP Americas) -1</description>
        <protected>false</protected>
        <recipients>
            <recipient>michael.moone@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>michael.yellin@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_100_VF</template>
    </alerts>
    <alerts>
        <fullName>X100_Probability_UPP_Americas_2</fullName>
        <ccEmails>Stevan.Vale@sunpowercorp.com</ccEmails>
        <ccEmails>Jacqueline.Ahmad@sunpowercorp.com</ccEmails>
        <ccEmails>scott.gray@sunpowercorp.com</ccEmails>
        <ccEmails>dmitry.klimko@sunpower.com</ccEmails>
        <description>100% Probability (UPP Americas) - 2</description>
        <protected>false</protected>
        <recipients>
            <recipient>christopherraymond.morandi@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_100_VF</template>
    </alerts>
    <alerts>
        <fullName>X100_Probability_UPP_Intl_All</fullName>
        <ccEmails>carlo.scapinelli@sunpowercorp.com</ccEmails>
        <description>100% Probability (UPP Intl) All</description>
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
            <recipient>Designer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Developer (Partner User)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Development Engineer</recipient>
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
            <recipient>Procurement</recipient>
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
            <recipient>SSO Analyst</recipient>
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
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>alsantos@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>christopherraymond.morandi@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>emmanuel.barry@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eric.potts@sunpowercorp.com</recipient>
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
            <recipient>julie.kirkenslager@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>julie.williamson@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rclark@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ryan.phillips@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_100_VF</template>
    </alerts>
    <alerts>
        <fullName>X100_Probability_UPP_Intl_All_2</fullName>
        <ccEmails>Pat.Pokorny@sunpowercorp.com</ccEmails>
        <description>100% Probability (UPP Intl) All - 2</description>
        <protected>false</protected>
        <recipients>
            <recipient>christopherraymond.morandi@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_100_VF</template>
    </alerts>
    <alerts>
        <fullName>X100_Probability_UPP_Intl_Off_grid</fullName>
        <description>100% Probability (UPP Intl) - Off grid</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>christopherraymond.morandi@sunpowercorp.com</recipient>
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
            <recipient>paul.lamouille@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>thomas.thillou@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_100_VF</template>
    </alerts>
    <alerts>
        <fullName>X100_Probability_UPP_Intl_U_C</fullName>
        <description>100% Probability (UPP Intl) - U&amp;C</description>
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
            <recipient>Designer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Developer (Partner User)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Development Engineer</recipient>
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
            <recipient>Procurement</recipient>
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
            <recipient>SSO Analyst</recipient>
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
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>christopherraymond.morandi@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mario.riello@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_100_VF</template>
    </alerts>
    <alerts>
        <fullName>X100_Probability_UPPi_RLC_Light</fullName>
        <ccEmails>enrique.roig@sunpowercorp.com</ccEmails>
        <ccEmails>Sergio.Chiericoni@sunpowercorp.com</ccEmails>
        <ccEmails>carlo.scapinelli@sunpowercorp.com</ccEmails>
        <description>100% Probability (UPPi) - RLC Light</description>
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
            <recipient>Designer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Developer (Partner User)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Development Engineer</recipient>
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
            <recipient>Procurement</recipient>
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
            <recipient>SSO Analyst</recipient>
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
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>alsantos@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>christopherraymond.morandi@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eric.potts@sunpowercorp.com</recipient>
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
            <recipient>julie.williamson@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_100_VF</template>
    </alerts>
    <alerts>
        <fullName>X25_APAC_Region</fullName>
        <ccEmails>steve.borman@sunpowercorp.com</ccEmails>
        <description>25% APAC Region</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>frederic.biollaz@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>marilou.macatangay@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nmorris@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/X25_Probability</template>
    </alerts>
    <alerts>
        <fullName>X25_Probability_Commercial_Intl_U_C</fullName>
        <ccEmails>Vincent.Maurice@sunpower.com;</ccEmails>
        <description>25% Probability (Commercial Intl) - U&amp;C EU</description>
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
            <recipient>Designer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Developer (Partner User)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Development Engineer</recipient>
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
            <recipient>Opportunity Owner</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Procurement</recipient>
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
            <recipient>SSO Analyst</recipient>
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
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>erik.burkhardt@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jean-baptiste.guillaume@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>patrice.clement@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/X25_Probability</template>
    </alerts>
    <alerts>
        <fullName>X25_Probability_Commercial_Intl_U_C_APAC</fullName>
        <ccEmails>Vincent.Maurice@sunpower.com;</ccEmails>
        <description>25% Probability (Commercial Intl) - U&amp;C APAC</description>
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
            <recipient>Designer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Developer (Partner User)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Development Engineer</recipient>
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
            <recipient>Opportunity Owner</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Procurement</recipient>
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
            <recipient>SSO Analyst</recipient>
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
            <type>owner</type>
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
            <recipient>jean-baptiste.guillaume@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>shingo.tajiri@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/X25_Probability</template>
    </alerts>
    <alerts>
        <fullName>X25_Probability_NAC</fullName>
        <ccEmails>naplanners@sunpowercorp.com</ccEmails>
        <ccEmails>Julie.Williamson@sunpowercorp.com</ccEmails>
        <ccEmails>Dave.Dosker@sunpowercorp.com</ccEmails>
        <ccEmails>paul.aguilar@sunpowercorp.com</ccEmails>
        <description>Firm Offer (Americas)</description>
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
            <recipient>Designer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Developer (Partner User)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Development Engineer</recipient>
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
            <recipient>SSO Analyst</recipient>
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
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>deepa.ananthakrishnan@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eric.dietl@sunpowercorp.com</recipient>
            <type>user</type>
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
            <recipient>maureen.obiri@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>murat.karakum@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>pdalton@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>peter.todd@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>priyantha.sirisooriya@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>romeo.nido@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>samuel.pratt@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>tasha.mccarter@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>william.yeager@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Sales_Analyst__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/BindingOfferNACvf</template>
    </alerts>
    <alerts>
        <fullName>X25_Probability_UPP_Intl_Off_Grid</fullName>
        <description>25% Probability (UPP Intl ) - Off-Grid</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
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
            <recipient>paul.lamouille@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>thomas.thillou@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/X25_Probability</template>
    </alerts>
    <alerts>
        <fullName>X25_Probability_UPP_Intl_U_C</fullName>
        <description>25% Probability (UPP Intl ) - U&amp;C</description>
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
            <recipient>Designer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Developer (Partner User)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Development Engineer</recipient>
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
            <recipient>Procurement</recipient>
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
            <recipient>SSO Analyst</recipient>
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
            <type>owner</type>
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
            <recipient>mario.riello@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/X25_Probability</template>
    </alerts>
    <alerts>
        <fullName>X25_Probability_UPPi_RLC_Light</fullName>
        <ccEmails>enrique.roig@sunpowercorp.com</ccEmails>
        <ccEmails>Sergio.Chiericoni@sunpowercorp.com</ccEmails>
        <ccEmails>carlo.scapinelli@sunpowercorp.com</ccEmails>
        <ccEmails>Francois.Gerson@sunpowercorp.com</ccEmails>
        <description>25% Probability (UPPi) - RLC Light</description>
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
            <recipient>Designer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Developer (Partner User)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Development Engineer</recipient>
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
            <recipient>Procurement</recipient>
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
            <recipient>SSO Analyst</recipient>
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
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>alsantos@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eric.potts@sunpowercorp.com</recipient>
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
            <recipient>julie.williamson@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/X25_Probability</template>
    </alerts>
    <alerts>
        <fullName>X50_Probability_APAC</fullName>
        <description>50% Probability APAC</description>
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
            <recipient>Designer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Developer (Partner User)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Development Engineer</recipient>
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
            <recipient>Procurement</recipient>
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
            <recipient>SSO Analyst</recipient>
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
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/X50_Probability_VF</template>
    </alerts>
    <alerts>
        <fullName>X50_Probability_Commercial_Intl_U_C</fullName>
        <ccEmails>Vincent.Maurice@sunpower.com;</ccEmails>
        <ccEmails>BERTRAND.BEGNEZ@sunpowercorp.com;</ccEmails>
        <description>50% Probability (Commercial Intl) - U&amp;C EU</description>
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
            <recipient>Designer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Developer (Partner User)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Development Engineer</recipient>
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
            <recipient>Procurement</recipient>
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
            <recipient>SSO Analyst</recipient>
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
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>carole.arenou@sunpowercorp.com</recipient>
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
            <recipient>jdawe@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jean-baptiste.guillaume@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>pascale.bertrand@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/X50_Probability_NAC_VF</template>
    </alerts>
    <alerts>
        <fullName>X50_Probability_Commercial_Intl_U_C_APAC</fullName>
        <ccEmails>Vincent.Maurice@sunpower.com;</ccEmails>
        <description>50% Probability (Commercial Intl) - U&amp;C APAC</description>
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
            <recipient>Designer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Developer (Partner User)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Development Engineer</recipient>
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
            <recipient>Procurement</recipient>
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
            <recipient>SSO Analyst</recipient>
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
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>carole.arenou@sunpowercorp.com</recipient>
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
            <recipient>ria.cirineo@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>shingo.tajiri@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>zach.struyk@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/X50_Probability_NAC_VF</template>
    </alerts>
    <alerts>
        <fullName>X50_Probability_NAC</fullName>
        <ccEmails>naplanners@sunpowercorp.com</ccEmails>
        <ccEmails>Julie.Williamson@sunpowercorp.com</ccEmails>
        <ccEmails>Dave.Dosker@sunpowercorp.com</ccEmails>
        <description>50% Probability (NAC)</description>
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
            <recipient>Designer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Developer (Partner User)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Development Engineer</recipient>
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
            <recipient>SSO Analyst</recipient>
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
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>deepa.ananthakrishnan@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eric.potts@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>iris.korovesi@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jason.spokes@sunpowercorp.com</recipient>
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
            <recipient>maureen.obiri@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>murat.karakum@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>peter.todd@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>priyantha.sirisooriya@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>romeo.nido@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>samuel.pratt@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sasha.rayatkah@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>stephen.adelson@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>thang.le@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/X50_Probability_NAC_VF</template>
    </alerts>
    <alerts>
        <fullName>X50_Probability_UPP_Americas</fullName>
        <ccEmails>terrell.thomas@sunpowercorp.com</ccEmails>
        <ccEmails>beatriz.mena@sunpowercorp.com</ccEmails>
        <ccEmails>naplanners@sunpowercorp.com</ccEmails>
        <description>50% Probability (UPP Americas)</description>
        <protected>false</protected>
        <recipients>
            <recipient>GlobalSalesOps</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>Project Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Analyst</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Senior Project Manager</recipient>
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
            <recipient>frederic.biollaz@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>matt.white@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>maureen.obiri@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rclark@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ryan.phillips@sunpowercorp.com</recipient>
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
        <template>Opportunity/X50_Probability_UPPa_VF</template>
    </alerts>
    <alerts>
        <fullName>X50_Probability_UPP_Intl</fullName>
        <ccEmails>alain.roy@sunpower.com</ccEmails>
        <description>50% Probability (UPP Intl ) - All Markets</description>
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
            <recipient>Designer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Developer (Partner User)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Development Engineer</recipient>
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
            <recipient>Procurement</recipient>
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
            <recipient>SSO Analyst</recipient>
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
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>alsantos@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>carole.arenou@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>deepa.ananthakrishnan@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>emmanuel.barry@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eric.potts@sunpowercorp.com</recipient>
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
            <recipient>ryan.phillips@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/X50_Probability_NAC_VF</template>
    </alerts>
    <alerts>
        <fullName>X50_Probability_UPP_Intl_2</fullName>
        <ccEmails>Robert.Louie@sunpowercorp.com</ccEmails>
        <ccEmails>Arjun.Karavadi@sunpowercorp.com</ccEmails>
        <description>50% Probability (UPP Intl ) -2</description>
        <protected>false</protected>
        <recipients>
            <recipient>mark.whalen@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/X50_Probability_NAC_VF</template>
    </alerts>
    <alerts>
        <fullName>X50_Probability_UPP_Intl_Off_Grid</fullName>
        <ccEmails>Christophe.Dargnies@sunpowercorp.com</ccEmails>
        <ccEmails>roberto.crescitelli@sunpower.com</ccEmails>
        <description>50% Probability (UPP Intl ) - Off-Grid</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>paul.lamouille@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/X50_Probability_NAC_VF</template>
    </alerts>
    <alerts>
        <fullName>X50_Probability_UPP_Intl_U_C</fullName>
        <description>50% Probability (UPP Intl ) - U&amp;C</description>
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
            <recipient>Designer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Developer (Partner User)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Development Engineer</recipient>
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
            <recipient>Procurement</recipient>
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
            <recipient>SSO Analyst</recipient>
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
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>mario.riello@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/X50_Probability_NAC_VF</template>
    </alerts>
    <alerts>
        <fullName>X50_Probability_UPPi_RLC_Light</fullName>
        <ccEmails>enrique.roig@sunpowercorp.com</ccEmails>
        <ccEmails>Sergio.Chiericoni@sunpowercorp.com</ccEmails>
        <ccEmails>carlo.scapinelli@sunpowercorp.com</ccEmails>
        <description>50% Probability (UPPi) - RLC Light</description>
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
            <recipient>Designer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Developer (Partner User)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Development Engineer</recipient>
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
            <recipient>Procurement</recipient>
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
            <recipient>SSO Analyst</recipient>
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
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>alsantos@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eric.potts@sunpowercorp.com</recipient>
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
            <recipient>julie.williamson@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/X50_Probability_VF</template>
    </alerts>
    <alerts>
        <fullName>X75_Probability_Commercial_Intl_U_C</fullName>
        <ccEmails>Vincent.Maurice@sunpower.com;</ccEmails>
        <ccEmails>Carole.Arenou@sunpowercorp.com;</ccEmails>
        <ccEmails>BERTRAND.BEGNEZ@sunpowercorp.com;</ccEmails>
        <description>75% Probability (Commercial Intl) - U&amp;C EU</description>
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
            <recipient>Designer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Developer (Partner User)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Development Engineer</recipient>
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
            <recipient>Procurement</recipient>
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
            <recipient>SSO Analyst</recipient>
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
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>carole.arenou@sunpowercorp.com</recipient>
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
            <recipient>jdawe@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jean-baptiste.guillaume@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>pascale.bertrand@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_75_VF</template>
    </alerts>
    <alerts>
        <fullName>X75_Probability_Commercial_Intl_U_C_APAC</fullName>
        <ccEmails>Vincent.Maurice@sunpower.com;</ccEmails>
        <ccEmails>Carole.Arenou@sunpowercorp.com;</ccEmails>
        <ccEmails>BERTRAND.BEGNEZ@sunpowercorp.com;</ccEmails>
        <description>75% Probability (Commercial Intl) - U&amp;C APAC</description>
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
            <recipient>Designer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Developer (Partner User)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Development Engineer</recipient>
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
            <recipient>Procurement</recipient>
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
            <recipient>SSO Analyst</recipient>
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
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>carole.arenou@sunpowercorp.com</recipient>
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
            <recipient>pascale.bertrand@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>shingo.tajiri@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_75_VF</template>
    </alerts>
    <alerts>
        <fullName>X75_Probability_NAC</fullName>
        <ccEmails>scott.gray@sunpowercorp.com</ccEmails>
        <ccEmails>naplanners@sunpowercorp.com</ccEmails>
        <ccEmails>Sudhakar.Pandurangan@sunpowercorp.com</ccEmails>
        <ccEmails>ingrid.ekstrom@sunpower.com</ccEmails>
        <description>75% Probability (NAC)</description>
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
            <recipient>Designer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Developer (Partner User)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Development Engineer</recipient>
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
            <recipient>SSO Analyst</recipient>
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
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>deepa.ananthakrishnan@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eric.potts@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jason.spokes@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>julie.williamson@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>matt.white@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>murat.karakum@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>peter.todd@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>priyantha.sirisooriya@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>romeo.nido@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>samuel.pratt@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sasha.rayatkah@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>stephen.adelson@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>thang.le@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>william.yeager@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_75_VF</template>
    </alerts>
    <alerts>
        <fullName>X75_Probability_NAC_2</fullName>
        <ccEmails>Robert.Louie@sunpowercorp.com</ccEmails>
        <ccEmails>Arjun.Karavadi@sunpowercorp.com</ccEmails>
        <ccEmails>Mark.Whalen@sunpowercorp.com</ccEmails>
        <ccEmails>Diana.Ganibe@sunpowercorp.com</ccEmails>
        <description>75% Probability (NAC) -2</description>
        <protected>false</protected>
        <recipients>
            <recipient>emad.brayo@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>steve.feng@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_75_VF</template>
    </alerts>
    <alerts>
        <fullName>X75_Probability_UPP_Americas</fullName>
        <ccEmails>beatriz.mena@sunpowercorp.com</ccEmails>
        <ccEmails>naplanners@sunpowercorp.com</ccEmails>
        <ccEmails>scott.gray@sunpowercorp.com</ccEmails>
        <description>75% Probability (UPP Americas)</description>
        <protected>false</protected>
        <recipients>
            <recipient>GlobalSalesOps</recipient>
            <type>group</type>
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
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>eric.potts@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>frederic.biollaz@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>matt.white@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>maureen.obiri@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rclark@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ryan.phillips@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>william.yeager@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_75_VF</template>
    </alerts>
    <alerts>
        <fullName>X75_Probability_UPP_Intl_All</fullName>
        <ccEmails>alain.roy@sunpowercorp.com</ccEmails>
        <description>75% Probability (UPP Intl ) - All</description>
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
            <recipient>Designer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Developer (Partner User)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Development Engineer</recipient>
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
            <recipient>Procurement</recipient>
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
            <recipient>SSO Analyst</recipient>
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
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>alsantos@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>deepa.ananthakrishnan@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>emmanuel.barry@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eric.potts@sunpowercorp.com</recipient>
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
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_75_VF_UPPi</template>
    </alerts>
    <alerts>
        <fullName>X75_Probability_UPP_Intl_All_2</fullName>
        <ccEmails>Robert.Louie@sunpowercorp.com</ccEmails>
        <ccEmails>Arjun.Karavadi@sunpowercorp.com</ccEmails>
        <description>75% Probability (UPP Intl ) - All 2</description>
        <protected>false</protected>
        <recipients>
            <recipient>mark.whalen@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_75_VF_UPPi</template>
    </alerts>
    <alerts>
        <fullName>X75_Probability_UPP_Intl_Off_Grid</fullName>
        <ccEmails>Christophe.Dargnies@sunpowercorp.com</ccEmails>
        <ccEmails>roberto.crescitelli@sunpower.com</ccEmails>
        <description>75% Probability (UPP Intl ) - Off-Grid</description>
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
            <recipient>Designer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Developer (Partner User)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Development Engineer</recipient>
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
            <recipient>Procurement</recipient>
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
            <recipient>SSO Analyst</recipient>
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
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>david.monceau@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>paul.lamouille@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_75_VF_UPPi</template>
    </alerts>
    <alerts>
        <fullName>X75_Probability_UPP_Intl_U_C</fullName>
        <description>75% Probability (UPP Intl ) - U&amp;C</description>
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
            <recipient>Designer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Developer (Partner User)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Development Engineer</recipient>
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
            <recipient>Procurement</recipient>
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
            <recipient>SSO Analyst</recipient>
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
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>mario.riello@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_75_VF</template>
    </alerts>
    <alerts>
        <fullName>X75_Probability_UPPi_RLC_Light</fullName>
        <ccEmails>enrique.roig@sunpowercorp.com</ccEmails>
        <ccEmails>Sergio.Chiericoni@sunpowercorp.com</ccEmails>
        <ccEmails>carlo.scapinelli@sunpowercorp.com</ccEmails>
        <description>75% Probability (UPPi) - RLC Light</description>
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
            <recipient>Designer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Developer (Partner User)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Development Engineer</recipient>
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
            <recipient>Procurement</recipient>
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
            <recipient>SSO Analyst</recipient>
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
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>alsantos@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eric.potts@sunpowercorp.com</recipient>
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
            <recipient>julie.williamson@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_75_VF_UPPi</template>
    </alerts>
    <alerts>
        <fullName>X90_Probability_Commercial_Intl_U_C</fullName>
        <ccEmails>Vincent.Maurice@sunpower.com;</ccEmails>
        <ccEmails>BERTRAND.BEGNEZ@sunpowercorp.com;</ccEmails>
        <description>90% Probability (Commercial Intl) - U&amp;C EU</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>carole.arenou@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>christopherraymond.morandi@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eric.potts@sunpowercorp.com</recipient>
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
            <recipient>jdawe@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jean-baptiste.guillaume@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>pascale.bertrand@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>patrice.clement@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_90_VF</template>
    </alerts>
    <alerts>
        <fullName>X90_Probability_Commercial_Intl_U_C_APAC</fullName>
        <ccEmails>Vincent.Maurice@sunpower.com;</ccEmails>
        <description>90% Probability (Commercial Intl) - U&amp;C APAC</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>christopherraymond.morandi@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eric.potts@sunpowercorp.com</recipient>
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
            <recipient>nmorris@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>shingo.tajiri@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_90_VF</template>
    </alerts>
    <alerts>
        <fullName>X90_Probability_NAC</fullName>
        <ccEmails>Julie.Williamson@sunpowercorp.com</ccEmails>
        <ccEmails>naplanners@sunpowercorp.com</ccEmails>
        <ccEmails>Sudhakar.Pandurangan@sunpowercorp.com</ccEmails>
        <ccEmails>Emad.Brayo@sunpowercorp.com</ccEmails>
        <ccEmails>catherine.roberts@sunpowercorp.com</ccEmails>
        <description>90% Probability (NAC)</description>
        <protected>false</protected>
        <recipients>
            <recipient>GlobalSalesOps</recipient>
            <type>group</type>
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
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>christopherraymond.morandi@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>deepa.ananthakrishnan@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eric.potts@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>flora.mercurio@sunpowercorp.com</recipient>
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
            <recipient>maureen.obiri@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rhodora.cayanan@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sasha.rayatkah@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>william.yeager@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_90_VF</template>
    </alerts>
    <alerts>
        <fullName>X90_Probability_UPP_Americas</fullName>
        <ccEmails>beatriz.mena@sunpowercorp.com</ccEmails>
        <ccEmails>naplanners@sunpowercorp.com</ccEmails>
        <description>90% Probability (UPP Americas)</description>
        <protected>false</protected>
        <recipients>
            <recipient>GlobalSalesOps</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>Sales Person</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>christopherraymond.morandi@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eric.potts@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>frederic.biollaz@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>matt.white@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>maureen.obiri@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rclark@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ryan.phillips@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>william.yeager@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_90_VF</template>
    </alerts>
    <alerts>
        <fullName>X90_Probability_UPP_Intl</fullName>
        <description>90% Probability (UPP Intl) - All</description>
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
            <recipient>Designer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Developer (Partner User)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Development Engineer</recipient>
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
            <recipient>Procurement</recipient>
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
            <recipient>SSO Analyst</recipient>
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
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>alsantos@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>christopherraymond.morandi@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>emmanuel.barry@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>frederic.biollaz@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>maryjane.talha@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rclark@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ryan.phillips@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_90_VF</template>
    </alerts>
    <alerts>
        <fullName>X90_Probability_UPP_Intl_All_2</fullName>
        <ccEmails>Sergio.Chiericoni@sunpowercorp.com</ccEmails>
        <description>90% Probability (UPP Intl) - All 2</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_90_VF</template>
    </alerts>
    <alerts>
        <fullName>X90_Probability_UPP_Intl_Off_Grid</fullName>
        <ccEmails>Christophe.Dargnies@sunpowercorp.com</ccEmails>
        <ccEmails>roberto.crescitelli@sunpower.com</ccEmails>
        <description>90% Probability (UPP Intl) - Off-Grid</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>christopherraymond.morandi@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_90_VF</template>
    </alerts>
    <alerts>
        <fullName>X90_Probability_UPP_Intl_U_C</fullName>
        <ccEmails>Teresa.Giaculli@sunpowercorp.com</ccEmails>
        <description>90% Probability (UPP Intl) - U&amp;C</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>christopherraymond.morandi@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mario.riello@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_90_VF</template>
    </alerts>
    <alerts>
        <fullName>X90_Probability_UPPi_RLC_Light</fullName>
        <ccEmails>enrique.roig@sunpowercorp.com</ccEmails>
        <ccEmails>Sergio.Chiericoni@sunpowercorp.com</ccEmails>
        <ccEmails>carlo.scapinelli@sunpowercorp.com</ccEmails>
        <description>90% Probability (UPPi) - RLC Light</description>
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
            <recipient>Designer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Developer (Partner User)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Development Engineer</recipient>
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
            <recipient>Procurement</recipient>
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
            <recipient>SSO Analyst</recipient>
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
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>alsantos@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>christopherraymond.morandi@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>eric.potts@sunpowercorp.com</recipient>
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
            <recipient>julie.williamson@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Probability_90_VF</template>
    </alerts>
    <alerts>
        <fullName>alertwhenopportunityabandonedbypartner</fullName>
        <description>Alert When Opportunity abandoned by Partner</description>
        <protected>false</protected>
        <recipients>
            <field>RSM_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Opportunity_Abandoned_56_days_VF</template>
    </alerts>
    <alerts>
        <fullName>emailalerttopartnerandrsmnoactivityafter7days</fullName>
        <description>Email Alert to Partner and RSM (No Activity after 7 days)</description>
        <protected>false</protected>
        <recipients>
            <field>RSM_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Opportunity_Abandoned_7_days_VF</template>
    </alerts>
    <alerts>
        <fullName>opportunityabondonedbypartnernoactivityforlast56days</fullName>
        <description>Opportunity Abondoned by Partner - No Activity for last 56 days</description>
        <protected>false</protected>
        <recipients>
            <field>RSM_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Opportunity_Abandoned_56_days_VF</template>
    </alerts>
    <alerts>
        <fullName>opportunityabondonedbypartnernoactivityforlast90days</fullName>
        <description>Opportunity Abondoned by Partner - No Activity for last 90 days</description>
        <protected>false</protected>
        <recipients>
            <field>RSM_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Opportunity_Abandoned_90_days_VF</template>
    </alerts>
    <alerts>
        <fullName>testmustbedeleted</fullName>
        <ccEmails>meprakashg@gmail.com</ccEmails>
        <description>TestMustbeDeleted</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Opportunity_Abandoned_7_days_VF</template>
    </alerts>
    <fieldUpdates>
        <fullName>Account_Lease_Update</fullName>
        <field>Lease__c</field>
        <literalValue>1</literalValue>
        <name>Account Lease Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Blank_Flash_Test_Data_Request_Date</fullName>
        <description>Update field &apos;Flash Test Data Request Date&apos; to blank</description>
        <field>Flash_Test_Data_Request_Date__c</field>
        <name>Blank - Flash Test Data Request Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPP_CalculateAmount</fullName>
        <field>Amount</field>
        <formula>System_Size_KwP__c  * 3720</formula>
        <name>CPP-CalculateAmount$$</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPP_MoveStageTo0</fullName>
        <field>StageName</field>
        <literalValue>0% - Dead, Lost</literalValue>
        <name>CPP-MoveTo0%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPP_MoveTo100</fullName>
        <field>StageName</field>
        <literalValue>100% - Delivered</literalValue>
        <name>CPP-MoveTo100%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPP_MoveTo12</fullName>
        <field>StageName</field>
        <literalValue>12% - Qualified Opportunity</literalValue>
        <name>CPP-MoveTo12%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPP_MoveTo20</fullName>
        <field>StageName</field>
        <literalValue>25% - Design Initiated</literalValue>
        <name>CPP-MoveTo25%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPP_MoveTo35</fullName>
        <field>StageName</field>
        <literalValue>50% - Quote / Proposal Submitted</literalValue>
        <name>CPP-MoveTo35%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPP_MoveTo50</fullName>
        <field>StageName</field>
        <literalValue>50% - Quote / Proposal Submitted</literalValue>
        <name>CPP-MoveTo50%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPP_MoveTo75</fullName>
        <field>StageName</field>
        <literalValue>75% - Imminent PO / Agreements Finalized</literalValue>
        <name>CPP-MoveTo75%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPP_MoveTo85</fullName>
        <field>StageName</field>
        <literalValue>90% - PO Received with Deposit</literalValue>
        <name>CPP-MoveTo90%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPP_MoveTo95</fullName>
        <field>StageName</field>
        <literalValue>95% - Down Payment Received by SPWR</literalValue>
        <name>CPP-MoveTo95%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPP_MoveToFutureFollowUp</fullName>
        <field>StageName</field>
        <literalValue>Future Follow-up</literalValue>
        <name>CPP-MoveToFutureFollowUp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPP_MoveToInstallationComplete</fullName>
        <field>StageName</field>
        <literalValue>Installation Completed</literalValue>
        <name>CPP-MoveToInstallationComplete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPP_ProjStagetoNewProspect</fullName>
        <field>Project_Stage__c</field>
        <literalValue>New Prospect</literalValue>
        <name>CPP-ProjStagetoNewProspect</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPP_SetCloseDate_Today</fullName>
        <field>CloseDate</field>
        <formula>Today()</formula>
        <name>CPP-SetCloseDate=Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPP_SetDelDateToProjDel</fullName>
        <field>Delivery_Date__c</field>
        <formula>Projected_Delivery_Date__c</formula>
        <name>CPP-SetDelDateToProjDel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPP_SetFinanceInPlaceDte</fullName>
        <field>Financing_in_Place_date__c</field>
        <formula>Today()</formula>
        <name>CPP-SetFinanceInPlaceDte</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPP_SetFinancingInPlaceBlank</fullName>
        <field>Financing_in_Place_date__c</field>
        <name>CPP-SetFinancingInPlaceBlank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPP_SetProjDelToDeliveryDate</fullName>
        <field>Projected_Delivery_Date__c</field>
        <formula>Delivery_Date__c</formula>
        <name>CPP-SetProjDelToDeliveryDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPP_SetProjDel_45</fullName>
        <field>Projected_Delivery_Date__c</field>
        <formula>Today() + 45</formula>
        <name>CPP-SetProjDel+45</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPP_SetReasonWon_LostToSARCancelled</fullName>
        <field>Reason_Won_Lost__c</field>
        <literalValue>SAR Cancelled</literalValue>
        <name>CPP-SetReasonWon/LostToSARCancelled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPP_SetReasonWon_LostToSARRejected</fullName>
        <field>Reason_Won_Lost__c</field>
        <literalValue>SAR Rejected</literalValue>
        <name>CPP-SetReasonWon/LostToSARRejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPP_SetSiteAuditReceivedDate</fullName>
        <field>Site_Audit_Form_Received__c</field>
        <formula>Today()</formula>
        <name>CPP-SetSiteAuditReceivedDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPP_StageTo20</fullName>
        <field>StageName</field>
        <literalValue>25% - Pre-Purchase Review Received</literalValue>
        <name>CPP-StageTo25%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Stage_Order_Placed</fullName>
        <field>StageName</field>
        <literalValue>01 – Prospecting</literalValue>
        <name>Change Stage - Development</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Close_Opportunity_Order_Placed</fullName>
        <field>Opportunity_Status__c</field>
        <literalValue>Closed Won</literalValue>
        <name>Close Opportunity - Order Placed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Close_Won_Date</fullName>
        <field>Closed_Won_Date__c</field>
        <formula>TODAY()</formula>
        <name>Close Won Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Convert_Opportunity_to_System_Type</fullName>
        <description>Convert Opportunity to System Record Type</description>
        <field>RecordTypeId</field>
        <lookupValue>Systems</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Convert Opportunity to System Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Customer_Survey_Opt_In_Default</fullName>
        <description>Customer Survey Opt In Default</description>
        <field>Customer_Satisfaction_survey_opt_in__c</field>
        <literalValue>1</literalValue>
        <name>Customer Survey Opt In Default</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_Flash_Test_Data_Request_Date_Upda</fullName>
        <description>Date - Flash Test Data Request Date Update</description>
        <field>Flash_Test_Data_Request_Date__c</field>
        <formula>TODAY()</formula>
        <name>Date - Flash Test Data Request Date Upda</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_Opportunity_Changed_to_Closed_Lost</fullName>
        <description>Date Opportunity Was Changed to Closed Lost</description>
        <field>Deal_Lost_Date__c</field>
        <formula>TODAY()</formula>
        <name>Date Opportunity Changed to Closed Lost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Default_Delivery_to_Projected_RLC_NA</fullName>
        <description>Delivery Date default to Projected Delivery Date - RLC</description>
        <field>Delivery_Date__c</field>
        <formula>Projected_Delivery_Date__c</formula>
        <name>Default Delivery to Projected - RLC NA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Default_Stage_for_EU_Commercial</fullName>
        <description>Default Stage for EU Commercial</description>
        <field>StageName</field>
        <literalValue>01 - Build Single Sales Objective</literalValue>
        <name>Default Stage for EU Commercial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Design_Status_Design_Sent_to_Customer</fullName>
        <field>Design_Status__c</field>
        <literalValue>Design Sent to Customer</literalValue>
        <name>Design Status - Design Sent to Customer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Design_Status_No_Customer_Response</fullName>
        <field>Design_Status__c</field>
        <literalValue>No Customer Response</literalValue>
        <name>Design Status - No Customer Response</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Dummy_Field_Uncheck</fullName>
        <field>Dummy_Update_on_Opportunity__c</field>
        <literalValue>0</literalValue>
        <name>Dummy Field Uncheck</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EC_Owner_Email_Update_Delete</fullName>
        <description>Remove the EC Owner Email field after the notification email has been sent</description>
        <field>EC_Owner_Email__c</field>
        <name>EC Owner Email Update Delete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ford_Spiff_Update</fullName>
        <description>Ford - Nissan Spiff Update - 250</description>
        <field>Spiff__c</field>
        <formula>250</formula>
        <name>Ford - Nissan Spiff Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>G2Debug</fullName>
        <field>Description</field>
        <formula>Description  &amp; &quot; &quot; &amp;  Text( Projected_Delivery_Date__c ) &amp; &quot; Priorvalue = &quot; &amp; Text(PRIORVALUE( Projected_Delivery_Date__c )) &amp; &quot;-.&quot;</formula>
        <name>G2Debug</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Move_to_100</fullName>
        <field>Probability</field>
        <formula>1</formula>
        <name>Move to 100%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Move_to_50</fullName>
        <field>Probability</field>
        <formula>0.50</formula>
        <name>Move to 50%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Move_to_75</fullName>
        <field>Probability</field>
        <formula>0.75</formula>
        <name>Move to 75%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Move_to_90</fullName>
        <field>Probability</field>
        <formula>0.90</formula>
        <name>Move to 90%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>New_Residential_Opps_Notification</fullName>
        <description>Checked by field update when email notification goes out to the Partner &amp; HomeOwner</description>
        <field>New_Residential_Opps_Notification__c</field>
        <literalValue>1</literalValue>
        <name>New Residential Opps Notification</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OpportunityOwnerEmail</fullName>
        <description>Updates Owner email field from owner user record</description>
        <field>Owner_Email__c</field>
        <formula>Owner.Email</formula>
        <name>OpportunityOwnerEmail</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Contacted_Date_Time</fullName>
        <description>update opportunity contacted date &amp; time field when stage change to contacted</description>
        <field>Opportunity_Contacted_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Opportunity Contacted Date-Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Lease_Update</fullName>
        <field>Lease__c</field>
        <literalValue>1</literalValue>
        <name>Opportunity Lease Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Stage_Changed_from_10_to_12</fullName>
        <description>Opportunity Stage Changed from 10% to 12%</description>
        <field>StageName</field>
        <literalValue>12% - Qualified Opportunity</literalValue>
        <name>Opportunity Stage Changed from 10% to 12</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Status_Closed_Lost</fullName>
        <description>Opportunity Status Closed Lost</description>
        <field>Opportunity_Status__c</field>
        <literalValue>Closed Lost</literalValue>
        <name>Opportunity Status Closed Lost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Status_Qualified_when_12</fullName>
        <description>Opportunity Status Qualified when 12%</description>
        <field>Opportunity_Status__c</field>
        <literalValue>Qualified</literalValue>
        <name>Opportunity Status Qualified when 12%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Status_Update_when_20_or_35</fullName>
        <description>Opportunity Status Update when 20% or 35%</description>
        <field>Opportunity_Status__c</field>
        <literalValue>Active</literalValue>
        <name>Opportunity Status Update when 20% or 35</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opps_Set_Record_Type_to_Commercial</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Commercial</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Opps: Set Record Type to Commercial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opps_Set_Record_Type_to_Components</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Components</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Opps: Set Record Type to Components</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opps_Set_Record_Type_to_Home_Owner</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Home_Owner</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Opps: Set Record Type to Home Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opps_Set_Record_Type_to_Systems</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Systems</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Opps: Set Record Type to Systems</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opps_Set_Record_Type_to_Systems_UPPAmer</fullName>
        <description>Opps: Set Record Type to Systems UPP Americas</description>
        <field>RecordTypeId</field>
        <lookupValue>Development</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Opps: Set Record Type to Systems UPPAmer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Overriding_the_default_close_date</fullName>
        <field>CloseDate</field>
        <formula>TODAY() + 180</formula>
        <name>Overriding the default close date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PROJECT_STAGE_Dead_Lost</fullName>
        <description>PROJECT STAGE - Dead Lost</description>
        <field>Project_Stage__c</field>
        <literalValue>Dead, Lost</literalValue>
        <name>PROJECT STAGE - Dead Lost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PSR_Email_Update</fullName>
        <description>PSR Email Update</description>
        <field>PSR_Email__c</field>
        <formula>PSR_Email_text__c</formula>
        <name>PSR Email Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PSR_Update_Opportunity</fullName>
        <description>PSR Update - Opportunity</description>
        <field>PSR_Email__c</field>
        <formula>PSR_Email_text__c</formula>
        <name>PSR Update - Opportunity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PV_Cost_Pricing_Updated</fullName>
        <description>PV Cost Pricing - Updated</description>
        <field>PV_Cost_Pricing__c</field>
        <formula>PV_Cost_Forecast__c</formula>
        <name>PV Cost Pricing - Updated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Partner_Intro_Email_Check</fullName>
        <description>Partner Intro Email (Check)</description>
        <field>Partner_Intro_Email_Check__c</field>
        <literalValue>1</literalValue>
        <name>Partner Intro Email (Check)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PrependNumberToName</fullName>
        <field>Name</field>
        <formula>IF(BEGINS(Name, Opportunity_Number_New__c+&quot;_&quot;), Name , Opportunity_Number_New__c +&quot;_&quot;+ Name)</formula>
        <name>PrependNumberToName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Price_Concession_Update</fullName>
        <description>Price Concession Update - mapped to field difference (Total List - Amount)</description>
        <field>Price_Concession__c</field>
        <formula>Diff_Sales_and_List_Price_Total__c</formula>
        <name>Price Concession Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Primary_Res_Opp_Recip_Email</fullName>
        <field>Primary_Res_Opp_Recip_Email__c</field>
        <formula>Owner.Email</formula>
        <name>Primary Res Opp Recip Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Probability_25</fullName>
        <description>Probability 25%</description>
        <field>Probability</field>
        <formula>0.25</formula>
        <name>Probability 25%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RLC_NA_Creates_Opportunity_Default_BU</fullName>
        <description>RLC NA Creates Opportunity - Default BU</description>
        <field>Business_Unit__c</field>
        <literalValue>RLC</literalValue>
        <name>RLC NA Creates Opportunity - Default BU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RLC_NA_Creates_Opportunity_Default_RLC</fullName>
        <description>RLC NA Creates Opportunity - Default RLC</description>
        <field>RLC_Type__c</field>
        <literalValue>Light Commercial</literalValue>
        <name>RLC NA Creates Opportunity - Default RLC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Regional_Commitment_Update_Closed</fullName>
        <description>Regional Commitment Update - Closed</description>
        <field>Regional_Commitment__c</field>
        <literalValue>Closed</literalValue>
        <name>Regional Commitment Update - Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Salesperson_Commitment_Closed</fullName>
        <description>Update Salesperson Commitment - Closed</description>
        <field>Salesperson_Commitment__c</field>
        <literalValue>Closed</literalValue>
        <name>Salesperson Commitment - Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Send_Mail_update</fullName>
        <field>Send_Mail__c</field>
        <literalValue>1</literalValue>
        <name>Send Mail update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sent_Energy_Producing_Email</fullName>
        <field>Sent_Energy_Producing_Email__c</field>
        <literalValue>1</literalValue>
        <name>Sent Energy Producing Email</name>
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
        <fullName>Set_alert_false</fullName>
        <field>Send_Financing_Alert__c</field>
        <literalValue>0</literalValue>
        <name>Set Alert False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Solaire_Record_Type</fullName>
        <description>Set record type for Solaire based on Vertical value</description>
        <field>RecordTypeId</field>
        <lookupValue>Solaire</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Solaire Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Systems_Stage_Update_On_Creation</fullName>
        <description>Systems Stage Update On Creation</description>
        <field>StageName</field>
        <literalValue>01 - Build Single Sales Objective</literalValue>
        <name>Systems Stage Update On Creation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UD_Opp_Status_to_Appointment_Confirm</fullName>
        <description>Updated Opportunity Stage to Appointment Confirmed when created from SPD Lead Conversion</description>
        <field>StageName</field>
        <literalValue>Appointment Confirmed</literalValue>
        <name>UD Opp Status to Appointment Confirm</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UPPi_Mature_Market_Update</fullName>
        <description>UPPi Mature Market Opportunity Update</description>
        <field>UPP_Market_Type__c</field>
        <literalValue>Mature Market</literalValue>
        <name>UPPi Mature Market Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Correct_Design_Submitted</fullName>
        <field>Is_correct_Design_Included__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Correct Design Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_12</fullName>
        <field>Probability</field>
        <formula>0.12</formula>
        <name>Update 12%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Closed_Date</fullName>
        <description>Update Closed Date to today</description>
        <field>CloseDate</field>
        <formula>Today()</formula>
        <name>Update Closed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Closed_Field_For_Opportunity</fullName>
        <description>Update Closed (Text) Field For Opportunity</description>
        <field>Closed_Text__c</field>
        <formula>1</formula>
        <name>Update Closed Field For Opportunity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Description</fullName>
        <field>Description</field>
        <formula>Account.Lead_Qualification_Notes__c</formula>
        <name>Update Description</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Field_Res_Opp_Recipient_CC_Email</fullName>
        <field>Res_Opp_Recipient_CC_Email__c</field>
        <formula>Res_Opp_Recipient_CC__c</formula>
        <name>Update Field Res Opp Recipient CC Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Financing_Comments</fullName>
        <field>Financing__c</field>
        <formula>text(Financing2__c )</formula>
        <name>Update Financing Comments</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Installation_complete_date</fullName>
        <field>Installation_Completed_Date__c</field>
        <formula>Today()</formula>
        <name>Update Installation complete date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Number_of_Days_to_close_Date</fullName>
        <field>Number_of_days_to_the_Close_date__c</field>
        <formula>No_of_days_to_the_Close_date__c</formula>
        <name>Update Number of Days to close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opportunity_Stage_Close_Won</fullName>
        <field>Opportunity_Status__c</field>
        <literalValue>Closed Won</literalValue>
        <name>Update Opportunity Stage - Close Won</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opportunity_Status_to_Active</fullName>
        <description>Update Opportunity Status to Active</description>
        <field>Opportunity_Status__c</field>
        <literalValue>Active</literalValue>
        <name>Update Opportunity Status to Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opportunity_Status_to_Closed_Won</fullName>
        <description>Update Opportunity Status to Closed Won</description>
        <field>Opportunity_Status__c</field>
        <literalValue>Closed Won</literalValue>
        <name>Update Opportunity Status to Closed Won</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opportunity_Status_to_In_Review</fullName>
        <description>Update Opportunity Status</description>
        <field>Opportunity_Status__c</field>
        <literalValue>In Review</literalValue>
        <name>Update Opportunity Status to In Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opportunity_Status_to_On_Hold</fullName>
        <description>Update Opportunity Status to On Hold</description>
        <field>Opportunity_Status__c</field>
        <literalValue>On Hold</literalValue>
        <name>Update Opportunity Status to On Hold</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opportunity_to_0_Dead_Lost</fullName>
        <description>Update Opportunity to Future Follow-Up</description>
        <field>StageName</field>
        <literalValue>Future Follow-up</literalValue>
        <name>Update Opportunity to - Future Follow</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Pricing_Exception_Status_Approv</fullName>
        <description>Update Pricing Exception Status - Approved</description>
        <field>Pricing_Exception_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Pricing Exception Status - Approv</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Pricing_Exception_Status_In_Rev</fullName>
        <description>Update Pricing Exception Status - In Review</description>
        <field>Pricing_Exception_Status__c</field>
        <literalValue>In Review</literalValue>
        <name>Update Pricing Exception Status - In Rev</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Pricing_Exception_Status_Recall</fullName>
        <description>Update Pricing Exception Status - Recalled</description>
        <field>Pricing_Exception_Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>Update Pricing Exception Status - Recall</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Pricing_Exception_Status_Reject</fullName>
        <description>Update Pricing Exception Status - Rejected</description>
        <field>Pricing_Exception_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Pricing Exception Status - Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Probability_to_10</fullName>
        <field>Probability</field>
        <formula>0.10</formula>
        <name>Update Probability to 10%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Project_Stage_Dead_Lost</fullName>
        <description>Update Project Stage - Future Follow-Up</description>
        <field>Project_Stage__c</field>
        <literalValue>Future Follow-up</literalValue>
        <name>Update Project Stage - Future Follow-Up</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Reason_Won_Lost_Comments_No_PPF</fullName>
        <description>Update Reason Won/Lost Comments - No PPF sent</description>
        <field>Reason_Won_Lost_comments__c</field>
        <formula>&quot;No PPF Sent&quot;</formula>
        <name>Update Reason Won/Lost Comments - No PPF</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Reason_Won_Lost_Other</fullName>
        <description>Reason Won/Lost  - Other</description>
        <field>Reason_Won_Lost__c</field>
        <literalValue>Other</literalValue>
        <name>Update Reason Won/Lost  - Other</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_to_Future_Follow_Up_RLC_NA</fullName>
        <description>Update Stage to Future Follow-Up RLC NA</description>
        <field>StageName</field>
        <literalValue>Future Follow-up</literalValue>
        <name>Update Stage to Future Follow-Up RLC NA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_to_New_Opportunity</fullName>
        <description>Update Stage to New Opportunity</description>
        <field>StageName</field>
        <literalValue>New Opportunity</literalValue>
        <name>Update Stage to New Opportunity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Survey_Opt_in</fullName>
        <field>Customer_Satisfaction_survey_opt_in__c</field>
        <literalValue>0</literalValue>
        <name>Update Survey Opt in</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_to_12</fullName>
        <description>Update to 12%</description>
        <field>StageName</field>
        <literalValue>12% - Qualified Opportunity</literalValue>
        <name>Update to 12%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Warm_Transfer_Opp_Stage_to_Contacted</fullName>
        <field>StageName</field>
        <literalValue>Contacted</literalValue>
        <name>Warm Transfer Opp Stage to Contacted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>updateabandondedbypartner</fullName>
        <description>modify the field Is Abandonded by Partner to true</description>
        <field>Is_Abandonded__c</field>
        <literalValue>1</literalValue>
        <name>UpdateAbandondedByPartner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <flowActions>
        <fullName>OppAppointmnetEmailFlow</fullName>
        <description>Appointment workflow once an opportunity moves to Appointment Confirmed date.</description>
        <flow>OppAppointmentEmailFlow1</flow>
        <flowInputs>
            <name>varOppId</name>
            <value>{!Id}</value>
        </flowInputs>
        <label>OppAppointmnetEmailFlow</label>
        <language>en_US</language>
        <protected>false</protected>
    </flowActions>
    <outboundMessages>
        <fullName>Informatica_Spectrum_Integration</fullName>
        <apiVersion>35.0</apiVersion>
        <description>Outbound message call for NRT spectrum Integration</description>
        <endpointUrl>https://ps1w2-obm.rt.informaticacloud.com/active-bpel/services/REST/SalesforceNotificationRESTPort?processName=SalesforceSpectrumLeadSync</endpointUrl>
        <fields>Id</fields>
        <fields>Name</fields>
        <fields>SyncWithSpectrum__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>spectrum.integration@sunpower.com</integrationUser>
        <name>Informatica Spectrum Integration</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>100%25 Probability %28Commercial Intl%29 - PV and PV%2BBOS %28APAC%29</fullName>
        <actions>
            <name>Commercial_Intl_100_Alert_PV_and_PV_BOS_APAC</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>Commercial Intl</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Contract_Type__c</field>
            <operation>equals</operation>
            <value>PV Only,BOS+PV</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Probability_Text__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Region1__c</field>
            <operation>equals</operation>
            <value>APAC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Territory_Text__c</field>
            <operation>notEqual</operation>
            <value>UPPa - Business Development Region</value>
        </criteriaItems>
        <description>100% Probability (Commercial Intl) - PV and PV+BOS (APAC)</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>100%25 Probability %28Commercial Intl%29 - PV and PV%2BBOS EU</fullName>
        <actions>
            <name>Commercial_Intl_100_Alert_PV_and_PV_BOS</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>Commercial Intl</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Contract_Type__c</field>
            <operation>equals</operation>
            <value>PV Only,BOS+PV</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Probability_Text__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Region1__c</field>
            <operation>equals</operation>
            <value>Europe,MEA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Territory_Text__c</field>
            <operation>notEqual</operation>
            <value>UPPa - Business Development Region</value>
        </criteriaItems>
        <description>100% Probability (Commercial Intl) - PV and PV+BOS EU</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>100%25 Probability %28Commercial Intl%29 - U%26C APAC</fullName>
        <actions>
            <name>X100_Probability_Commercial_Intl_U_C_APAC</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>100% Probability (Commercial Intl) - U&amp;C APAC</description>
        <formula>AND(NOT($User.ByPassValidation__c), ISCHANGED(Probability ), AND((ISPICKVAL(Business_Unit__c ,&apos;Commercial Intl&apos;)), Probability =1,(Territory_Text__c &lt;&gt; &apos;UPPa - Business Development Region&apos;), ISPICKVAL( Region1__c , &quot;APAC&quot;) ) ) &amp;&amp; ( Off_Grid__c = false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>100%25 Probability %28Commercial Intl%29 - U%26C EU</fullName>
        <actions>
            <name>X100_Probability_Commercial_Intl_U_C</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>100% Probability (Commercial Intl) - U&amp;C EU</description>
        <formula>AND( NOT($User.ByPassValidation__c), ISCHANGED(Probability ), AND( (ISPICKVAL(Business_Unit__c ,&apos;Commercial Intl&apos;)),(Territory_Text__c &lt;&gt; &apos;UPPa - Business Development Region&apos;), Probability =1, ISPICKVAL( Region1__c , &quot;Europe&quot;)) ) &amp;&amp; ( Off_Grid__c = false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>100%25 Probability %28NAC%29</fullName>
        <actions>
            <name>X100_Probability_NAC</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>100% Probability (NAC)</description>
        <formula>AND( NOT($User.ByPassValidation__c), ISCHANGED(Probability ), AND( (ISPICKVAL(Business_Unit__c ,&apos;NA Commercial&apos;)),(Territory_Text__c &lt;&gt; &apos;UPPa - Business Development Region&apos;), Probability =1) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>100%25 Probability %28UPPa%29</fullName>
        <actions>
            <name>X100_Probability_UPP_Americas</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>X100_Probability_UPP_Americas_2</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>100% Probability (UPPa)</description>
        <formula>AND( NOT($User.ByPassValidation__c), ISCHANGED(Probability ), AND( (ISPICKVAL(Business_Unit__c ,&apos;UPP Americas&apos;)), Probability =1,(Territory_Text__c &lt;&gt; &apos;UPPa - Business Development Region&apos;)), Owner.Id &lt;&gt; &quot;00580000005FjM2&quot; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>100%25 Probability %28UPPi%29 - Off Grid</fullName>
        <actions>
            <name>X100_Probability_UPP_Intl_Off_grid</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>100% Probability (UPPi) - Off Grid</description>
        <formula>AND( NOT($User.ByPassValidation__c), ISCHANGED(Probability ), AND( (ISPICKVAL(Business_Unit__c ,&apos;UPP Intl&apos;)),(Territory_Text__c &lt;&gt; &apos;UPPa - Business Development Region&apos;), Probability =1) ) &amp;&amp; ( Off_Grid__c = true)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>100%25 Probability %28UPPi%29 - PV and PV%2BBOS</fullName>
        <actions>
            <name>UPPi_100_Alert_PV_and_PV_BOS</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>UPP Intl</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Contract_Type__c</field>
            <operation>equals</operation>
            <value>PV Only,BOS+PV</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Probability_Text__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Territory_Text__c</field>
            <operation>notEqual</operation>
            <value>UPPa - Business Development Region</value>
        </criteriaItems>
        <description>100% Probability (UPPi) - PV and PV+BOS</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>100%25 Probability %28UPPi%29 - RLC Light</fullName>
        <actions>
            <name>X100_Probability_UPPi_RLC_Light</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>100% Probability (UPPi) - RLC Light</description>
        <formula>AND( NOT($User.ByPassValidation__c), ISCHANGED(Probability ), AND( (ISPICKVAL(Business_Unit__c ,&apos;RLC&apos;)),(Territory_Text__c &lt;&gt; &apos;UPPa - Business Development Region&apos;), Probability =1) ) &amp;&amp; RecordTypeId = &apos;01280000000PzRR&apos; &amp;&amp; ISPICKVAL( Region1__c , &apos;Europe&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>100%25 Probability %28UPPi%29 - U%26C</fullName>
        <actions>
            <name>X100_Probability_UPP_Intl_U_C</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>UPPi_Mature_Market_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>100% Probability (UPPi) - U&amp;C</description>
        <formula>AND( NOT($User.ByPassValidation__c), ISCHANGED(Probability ), AND( (ISPICKVAL(Business_Unit__c ,&apos;UPP Intl&apos;)), Probability =1,(Territory_Text__c &lt;&gt; &apos;UPPa - Business Development Region&apos;)) ) &amp;&amp; ( Off_Grid__c = false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>100%25 Probability %28UPPi%29 All</fullName>
        <actions>
            <name>X100_Probability_UPP_Intl_All</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>X100_Probability_UPP_Intl_All_2</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>100% Probability (UPPi) All</description>
        <formula>AND( NOT($User.ByPassValidation__c), ISCHANGED(Probability ), AND( (CONTAINS(BU_text__c ,&quot;Intl&quot;)), Probability =1,(Territory_Text__c &lt;&gt; &apos;UPPa - Business Development Region&apos;)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>100%25 Probability Business Development Region Territory</fullName>
        <actions>
            <name>X100_Probability_Business_Development_Region_Territory</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Probability_Text__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Territory_Text__c</field>
            <operation>equals</operation>
            <value>UPPa - Business Development Region</value>
        </criteriaItems>
        <description>email notification for opportunities with Territory = &quot;Business Development Region&quot; when Probability is moved to 100%.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>25%25 Probability %28Commercial Intl%29 - U%26C APAC</fullName>
        <actions>
            <name>X25_Probability_Commercial_Intl_U_C_APAC</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>25% Probability (Commercial Intl) - U&amp;C APAC</description>
        <formula>AND( NOT($User.ByPassValidation__c), ISCHANGED(Probability ), AND(  (ISPICKVAL(Business_Unit__c ,&apos;Commercial Intl&apos;)),  Probability =0.25, ISPICKVAL( Region1__c , &quot;APAC&quot;) )  ) &amp;&amp;  (  Off_Grid__c = false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>25%25 Probability %28Commercial Intl%29 - U%26C EU</fullName>
        <actions>
            <name>X25_Probability_Commercial_Intl_U_C</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>25% Probability (Commercial Intl) - U&amp;C EU</description>
        <formula>AND( NOT($User.ByPassValidation__c), ISCHANGED(Probability ), AND(  (ISPICKVAL(Business_Unit__c ,&apos;Commercial Intl&apos;)),  Probability =0.25, ISPICKVAL( Region1__c , &quot;Europe&quot;))  ) &amp;&amp;  (  Off_Grid__c = false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>25%25 Probability %28UPPi%29 - Off-Grid</fullName>
        <actions>
            <name>X25_Probability_UPP_Intl_Off_Grid</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>25% Probability (UPPi) - Off-Grid</description>
        <formula>AND( NOT($User.ByPassValidation__c), ISCHANGED(Probability ), AND(  (ISPICKVAL(Business_Unit__c ,&apos;UPP Intl&apos;)),  Probability =0.25)  ) &amp;&amp;  ( Off_Grid__c = true)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>25%25 Probability %28UPPi%29 - RLC Light</fullName>
        <actions>
            <name>X25_Probability_UPPi_RLC_Light</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>25% Probability (UPPi) - RLC Light</description>
        <formula>AND(  NOT($User.ByPassValidation__c),  ISCHANGED(Probability ),  AND(  (ISPICKVAL(Business_Unit__c ,&apos;RLC&apos;)),  Probability =0.25)  )  &amp;&amp;  RecordTypeId  = &apos;01280000000PzRR&amp;&apos; &amp;&amp;  ISPICKVAL( Region1__c , &apos;Europe&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>25%25 Probability %28UPPi%29 - U%26C</fullName>
        <actions>
            <name>X25_Probability_UPP_Intl_U_C</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>25% Probability (UPPi) - U&amp;C</description>
        <formula>AND( NOT($User.ByPassValidation__c), ISCHANGED(Probability ), AND(  (ISPICKVAL(Business_Unit__c ,&apos;UPP Intl&apos;)),  Probability =0.25)  ) &amp;&amp;  (  Off_Grid__c = false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>25%25 Probability APAC</fullName>
        <actions>
            <name>X25_APAC_Region</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>25% Probability APAC</description>
        <formula>AND(  NOT($User.ByPassValidation__c), ISCHANGED(Probability ),  AND(  (ISPICKVAL( Region1__c ,&apos;APAC&apos;)),  Probability = 0.25)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>50%25 Probability %28Commercial Intl%29 - U%26C APAC</fullName>
        <actions>
            <name>X50_Probability_Commercial_Intl_U_C_APAC</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>50% Probability (Commercial Intl) - U&amp;C APAC</description>
        <formula>AND( NOT($User.ByPassValidation__c), ISCHANGED(Probability ), AND(  (ISPICKVAL(Business_Unit__c ,&apos;Commercial Intl&apos;)),  Probability =0.50, ISPICKVAL( Region1__c , &quot;APAC&quot;) )  ) &amp;&amp;  (  Off_Grid__c = false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>50%25 Probability %28Commercial Intl%29 - U%26C EU</fullName>
        <actions>
            <name>X50_Probability_Commercial_Intl_U_C</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>50% Probability (Commercial Intl) - U&amp;C EU</description>
        <formula>AND( NOT($User.ByPassValidation__c), ISCHANGED(Probability ), AND(  (ISPICKVAL(Business_Unit__c ,&apos;Commercial Intl&apos;)),  Probability =0.50, ISPICKVAL( Region1__c , &quot;Europe&quot;))  ) &amp;&amp;  (  Off_Grid__c = false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>50%25 Probability %28UPPa%29</fullName>
        <actions>
            <name>X50_Probability_UPP_Americas</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>50% Probability (UPPa)</description>
        <formula>AND( NOT($User.ByPassValidation__c), ISCHANGED(Probability ), AND(  (ISPICKVAL(Business_Unit__c ,&apos;UPP Americas&apos;)),  Probability =0.50 , Owner.Id &lt;&gt; &quot;00580000005FjM2&quot;   ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>50%25 Probability %28UPPi%29 - All</fullName>
        <actions>
            <name>X50_Probability_UPP_Intl</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>X50_Probability_UPP_Intl_2</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>50% Probability (UPPi) - All</description>
        <formula>AND(  NOT($User.ByPassValidation__c),  ISCHANGED(Probability ),  AND(  (CONTAINS( BU_text__c ,&quot;Intl&quot;)),  Probability =0.50)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>50%25 Probability %28UPPi%29 - Off-Grid</fullName>
        <actions>
            <name>X50_Probability_UPP_Intl_Off_Grid</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>50% Probability (UPPi) - Off-Grid</description>
        <formula>AND( NOT($User.ByPassValidation__c), ISCHANGED(Probability ), AND(  (ISPICKVAL(Business_Unit__c ,&apos;UPP Intl&apos;)),  Probability =0.50)  ) &amp;&amp;  ( Off_Grid__c = true)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>50%25 Probability %28UPPi%29 - RLC Light</fullName>
        <actions>
            <name>X50_Probability_UPPi_RLC_Light</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>50% Probability (UPPi) - RLC Light</description>
        <formula>AND(  NOT($User.ByPassValidation__c),  ISCHANGED(Probability ),  AND(  (ISPICKVAL(Business_Unit__c ,&apos;RLC&apos;)),  Probability =0.50)  )  &amp;&amp;  RecordTypeId  = &apos;01280000000PzRR&amp;&apos; &amp;&amp;  ISPICKVAL( Region1__c , &apos;Europe&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>50%25 Probability %28UPPi%29 - U%26C</fullName>
        <actions>
            <name>X50_Probability_UPP_Intl_U_C</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>50% Probability (UPPi) - U&amp;C</description>
        <formula>AND( NOT($User.ByPassValidation__c), ISCHANGED(Probability ), AND(  (ISPICKVAL(Business_Unit__c ,&apos;UPP Intl&apos;)),  Probability =0.50)  ) &amp;&amp;  (  Off_Grid__c = false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>50%25 Probability APAC</fullName>
        <actions>
            <name>X50_Probability_APAC</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>50% Probability APAC</description>
        <formula>AND(  NOT($User.ByPassValidation__c), ISCHANGED(Probability ),  AND(  (ISPICKVAL( Region1__c ,&apos;APAC&apos;)),  Probability = 0.50)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>75%25 Probability %28Commercial Intl%29 - U%26C APAC</fullName>
        <actions>
            <name>X75_Probability_Commercial_Intl_U_C_APAC</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>75% Probability (Commercial Intl)  - U&amp;C APAC</description>
        <formula>AND(  NOT($User.ByPassValidation__c), ISCHANGED(Probability ),  AND(  (ISPICKVAL(Business_Unit__c ,&apos;Commercial Intl&apos;)),  Probability =0.75, ISPICKVAL( Region1__c , &quot;APAC&quot;) )  ) &amp;&amp;  (  Off_Grid__c = false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>75%25 Probability %28Commercial Intl%29 - U%26C EU</fullName>
        <actions>
            <name>X75_Probability_Commercial_Intl_U_C</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>75% Probability (Commercial Intl)  - U&amp;C EU</description>
        <formula>AND(  NOT($User.ByPassValidation__c), ISCHANGED(Probability ),  AND(  (ISPICKVAL(Business_Unit__c ,&apos;Commercial Intl&apos;)),  Probability =0.75, ISPICKVAL( Region1__c , &quot;Europe&quot;))  ) &amp;&amp;  (  Off_Grid__c = false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>75%25 Probability %28NAC%29</fullName>
        <actions>
            <name>X75_Probability_NAC</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>X75_Probability_NAC_2</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>75% Probability (NAC)</description>
        <formula>AND(  NOT($User.ByPassValidation__c), ISCHANGED(Probability ),  AND(  (ISPICKVAL(Business_Unit__c ,&apos;NA Commercial&apos;)),  Probability =0.75)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>75%25 Probability %28UPPa%29</fullName>
        <actions>
            <name>Opportunity_Stage_Agreements_Finalized_Americas_Design_Team</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>X75_Probability_UPP_Americas</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>75% Probability (UPPa)</description>
        <formula>AND(  NOT($User.ByPassValidation__c), ISCHANGED(Probability ),  AND(  (ISPICKVAL(Business_Unit__c ,&apos;UPP Americas&apos;)),  Probability =0.75, Owner.Id &lt;&gt; &quot;00580000005FjM2&quot; )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>75%25 Probability %28UPPi%29 - All</fullName>
        <actions>
            <name>X75_Probability_UPP_Intl_All</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>X75_Probability_UPP_Intl_All_2</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>75% Probability (UPPi) - All</description>
        <formula>AND(  NOT($User.ByPassValidation__c),  ISCHANGED(Probability ),  AND(  (CONTAINS(BU_text__c,&quot;Intl&quot;)),  Probability =0.75)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>75%25 Probability %28UPPi%29 - Off-Grid</fullName>
        <actions>
            <name>X75_Probability_UPP_Intl_Off_Grid</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>75% Probability (UPPi) - Off-Grid</description>
        <formula>AND(  NOT($User.ByPassValidation__c), ISCHANGED(Probability ),  AND(  (ISPICKVAL(Business_Unit__c ,&apos;UPP Intl&apos;)),  Probability =0.75)  ) &amp;&amp;  (  Off_Grid__c = true)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>75%25 Probability %28UPPi%29 - RLC Light</fullName>
        <actions>
            <name>X75_Probability_UPPi_RLC_Light</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>75% Probability (UPPi) - RLC Light</description>
        <formula>AND(  NOT($User.ByPassValidation__c),  ISCHANGED(Probability ),  AND(  (ISPICKVAL(Business_Unit__c ,&apos;RLC&apos;)),  Probability =0.75)  )  &amp;&amp;  RecordTypeId  = &apos;01280000000PzRR&amp;&apos; &amp;&amp;  ISPICKVAL( Region1__c , &apos;Europe&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>75%25 Probability %28UPPi%29 - U%26C</fullName>
        <actions>
            <name>X75_Probability_UPP_Intl_U_C</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>75% Probability (UPPi)  - U&amp;C</description>
        <formula>AND(  NOT($User.ByPassValidation__c), ISCHANGED(Probability ),  AND(  (ISPICKVAL(Business_Unit__c ,&apos;UPP Intl&apos;)),  Probability =0.75)  ) &amp;&amp;  (  Off_Grid__c = false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>90%25 Probability %28Commercial Intl%29 - U%26C APAC</fullName>
        <actions>
            <name>X90_Probability_Commercial_Intl_U_C_APAC</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>90% Probability (Commercial Intl) - U&amp;C APAC</description>
        <formula>AND(  NOT($User.ByPassValidation__c), ISCHANGED(Probability ),  AND(  (ISPICKVAL(Business_Unit__c ,&apos;Commercial Intl&apos;)),  Probability =0.90, ISPICKVAL( Region1__c , &quot;APAC&quot;) )  ) &amp;&amp;  (  Off_Grid__c = false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>90%25 Probability %28Commercial Intl%29 - U%26C EU</fullName>
        <actions>
            <name>X90_Probability_Commercial_Intl_U_C</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>90% Probability (Commercial Intl) - U&amp;C EU</description>
        <formula>AND(  NOT($User.ByPassValidation__c), ISCHANGED(Probability ),  AND(  (ISPICKVAL(Business_Unit__c ,&apos;Commercial Intl&apos;)),  Probability =0.90, ISPICKVAL( Region1__c , &quot;Europe&quot;))  ) &amp;&amp;  (  Off_Grid__c = false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>90%25 Probability %28NAC%29</fullName>
        <actions>
            <name>X90_Probability_NAC</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>90% Probability (NAC)</description>
        <formula>AND(  NOT($User.ByPassValidation__c), ISCHANGED(Probability ),  AND(  (ISPICKVAL(Business_Unit__c ,&apos;NA Commercial&apos;)),  Probability =0.90)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>90%25 Probability %28UPPa%29</fullName>
        <actions>
            <name>X90_Probability_UPP_Americas</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>90% Probability (UPPa)</description>
        <formula>AND(  NOT($User.ByPassValidation__c), ISCHANGED(Probability ),  AND(  (ISPICKVAL(Business_Unit__c ,&apos;UPP Americas&apos;)),  Probability =0.90, Owner.Id &lt;&gt; &quot;00580000005FjM2&quot; )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>90%25 Probability %28UPPi%29 - All</fullName>
        <actions>
            <name>X90_Probability_UPP_Intl</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>X90_Probability_UPP_Intl_All_2</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>90% Probability (UPPi) - All</description>
        <formula>AND(  NOT($User.ByPassValidation__c),  ISCHANGED(Probability ),  AND(  (CONTAINS(BU_text__c,&quot;Intl&quot;)),  Probability =0.90)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>90%25 Probability %28UPPi%29 - Off Grid</fullName>
        <actions>
            <name>X90_Probability_UPP_Intl_Off_Grid</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>90% Probability (UPPi) - Off Grid</description>
        <formula>AND(  NOT($User.ByPassValidation__c), ISCHANGED(Probability ),  AND(  (ISPICKVAL(Business_Unit__c ,&apos;UPP Intl&apos;)),  Probability =0.90)  )  &amp;&amp;  (  Off_Grid__c = true)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>90%25 Probability %28UPPi%29 - RLC Light</fullName>
        <actions>
            <name>X90_Probability_UPPi_RLC_Light</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>90% Probability (UPPi) - RLC Light</description>
        <formula>AND(  NOT($User.ByPassValidation__c),  ISCHANGED(Probability ),  AND(  (ISPICKVAL(Business_Unit__c ,&apos;RLC&apos;)),  Probability =0.90)  )  &amp;&amp;  RecordTypeId  = &apos;01280000000PzRR&amp;&apos; &amp;&amp;  ISPICKVAL( Region1__c , &apos;Europe&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>90%25 Probability %28UPPi%29 - U%26C</fullName>
        <actions>
            <name>X90_Probability_UPP_Intl_U_C</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>90% Probability (UPPi) - U&amp;C</description>
        <formula>AND(  NOT($User.ByPassValidation__c), ISCHANGED(Probability ),  AND(  (ISPICKVAL(Business_Unit__c ,&apos;UPP Intl&apos;)),  Probability =0.90)  ) &amp;&amp;  (  Off_Grid__c = false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Add Installation date on stage Installation Complete</fullName>
        <actions>
            <name>Update_Installation_complete_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Installation Completed</value>
        </criteriaItems>
        <description>&apos;Add Installation date when stage&apos; Name change to Installation Complete</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Alert Send when Opportuntiy Abandon by Partner</fullName>
        <active>false</active>
        <booleanFilter>(((1 OR 2) AND 3) AND 4)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Type</field>
            <operation>equals</operation>
            <value>Residential</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Type</field>
            <operation>equals</operation>
            <value>Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>notEqual</operation>
            <value>Closed Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>notEqual</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <description>Alert Send when Opportuntiy Abandon by Partner</description>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>alertwhenopportunityabandonedbypartner</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.LastModifiedDate</offsetFromField>
            <timeLength>48</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Alert When Opp Assgned To RSM</fullName>
        <actions>
            <name>Alert_when_Opportunity_Assigned_To_RSM</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Send Alert when Opportunity Assigned to RSM</description>
        <formula>AND(AND(OR(ISPICKVAL(Type , &apos;Residential&apos;),ISPICKVAL(Type,&apos;Commercial&apos;)), ISCHANGED(OwnerId)), isAssignedToRSM__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Application Approved Notification E-mail</fullName>
        <actions>
            <name>Email_Approved_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sent when Application Status changes to Approved</description>
        <formula>AND( Credit_Application_Status__c != &apos;&apos; ,   OR( Credit_Application_Status__c  = &apos;approved&apos; ,  Credit_Application_Status__c = &apos;Approved&apos; ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Application Declined Notification E-mail</fullName>
        <actions>
            <name>Email_Declined_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sent when Application Status changes to Declined</description>
        <formula>AND( Credit_Application_Status__c != &apos;&apos; ,  OR( Credit_Application_Status__c = &apos;declined&apos; , Credit_Application_Status__c = &apos;Declined&apos; ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Application Engineer Task Assignment</fullName>
        <actions>
            <name>Site_Audit_Required</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Contract_Type__c</field>
            <operation>equals</operation>
            <value>BOS+PV,BOS Only</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Components</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.CreatedById</field>
            <operation>notEqual</operation>
            <value>DMAdmin</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>notEqual</operation>
            <value>UPP Americas,NA Commercial,RLC</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Task created for Application Engineer when contract type contains BOS for components</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Auto Update on Close Date</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Contract Signed</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Binding Offer %28Americas%29</fullName>
        <actions>
            <name>X25_Probability_NAC</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>UPP Americas,NA Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>03 - Firm Offer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Owner_ID__c</field>
            <operation>notEqual</operation>
            <value>00580000005FjM2</value>
        </criteriaItems>
        <description>Binding Offer (Americas)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Blank - Flash Test Data Request Date</fullName>
        <actions>
            <name>Blank_Flash_Test_Data_Request_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Flash_Test_Data_Request__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>Blank - Flash Test Data Request Date</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Book Sale Task Creation</fullName>
        <actions>
            <name>Book_Opportunity</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>06 – Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CreatedById</field>
            <operation>notEqual</operation>
            <value>DMAdmin</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Task Created when Opportunity status is updated to Submit Booked Sale</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CPP-BalanceInvoiceNumEvent</fullName>
        <actions>
            <name>CPP_MoveTo100</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>CPP-Balance Invoice Num Event.</description>
        <formula>AND(  $RecordType.Name = &quot;Commercial&quot;,  NOT(ISBLANK(   Balance_Invoice_Number__c   )) , NOT(ISPICKVAL( StageName , &quot;0% - Dead, Lost&quot; )), NOT(ISPICKVAL( StageName , &quot;Future Follow-up&quot;) ), NOT(ISPICKVAL( StageName , &quot;Installation Completed&quot; )  ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CPP-CVARDeadTo12%25</fullName>
        <actions>
            <name>CPP_MoveTo12</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>CPP-CVAR Dead To 12%.</description>
        <formula>AND( $RecordType.Name = &quot;Commercial&quot;,  OR( ISPICKVAL(PRIORVALUE( Project_Stage__c ), &quot;Dead, Lost&quot; ), ISPICKVAL(PRIORVALUE( Project_Stage__c ), &quot;Dead, Withdrawn&quot; ) ), ISPICKVAL(StageName, &quot;0% - Dead, Lost&quot;) ,   ISBLANK(   Site_Audit_Form_Received__c    ),   ISBLANK(   EPA_Generated__c   ),   ISBLANK(  Financing_in_Place_date__c  ), ISBLANK( PO_Receipt_Date__c ) , ISBLANK( Deposit_received__c ),  !ISPICKVAL(Project_Stage__c , &quot;Dead, Lost&quot; ), !ISPICKVAL( Project_Stage__c , &quot;Dead, Withdrawn&quot; )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPP-CVARDeadTo25%25</fullName>
        <actions>
            <name>CPP_StageTo20</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>CPP-CVAR Dead To 25%</description>
        <formula>AND( $RecordType.Name = &quot;Commercial&quot;,  OR( ISPICKVAL(PRIORVALUE( Project_Stage__c ), &quot;Dead, Lost&quot; ), ISPICKVAL(PRIORVALUE( Project_Stage__c ), &quot;Dead, Withdrawn&quot; ) ), ISPICKVAL(StageName, &quot;0% - Dead, Lost&quot;) ,    !ISBLANK( Site_Audit_Form_Received__c ) , ISBLANK(   EPA_Generated__c   ),   ISBLANK(  Financing_in_Place_date__c  ), ISBLANK( PO_Receipt_Date__c ) , ISBLANK( Deposit_received__c ),  !ISPICKVAL(Project_Stage__c , &quot;Dead, Lost&quot; ), !ISPICKVAL( Project_Stage__c , &quot;Dead, Withdrawn&quot; )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPP-CVARDeadTo50%25</fullName>
        <actions>
            <name>CPP_MoveTo50</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>CPP-CVAR Dead To 50%.</description>
        <formula>AND( $RecordType.Name = &quot;Commercial&quot;,  OR( ISPICKVAL(PRIORVALUE( Project_Stage__c ), &quot;Dead, Lost&quot; ), ISPICKVAL(PRIORVALUE( Project_Stage__c ), &quot;Dead, Withdrawn&quot; ) ), ISPICKVAL(StageName, &quot;0% - Dead, Lost&quot;) , !ISBLANK(   Financing_in_Place_date__c   ), ISBLANK( PO_Receipt_Date__c ) , ISBLANK( Deposit_received__c ),  !ISPICKVAL(Project_Stage__c , &quot;Dead, Lost&quot; ), !ISPICKVAL( Project_Stage__c , &quot;Dead, Withdrawn&quot; )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPP-CVARDeadTo_50%25</fullName>
        <actions>
            <name>CPP_MoveTo35</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>CPP-CVAR Dead To 50%.</description>
        <formula>AND( $RecordType.Name = &quot;Commercial&quot;,  OR( ISPICKVAL(PRIORVALUE( Project_Stage__c ), &quot;Dead, Lost&quot; ), ISPICKVAL(PRIORVALUE( Project_Stage__c ), &quot;Dead, Withdrawn&quot; ) ), ISPICKVAL(StageName, &quot;0% - Dead, Lost&quot;) , !ISBLANK(    EPA_Generated__c   ), ISBLANK(  Financing_in_Place_date__c  ), ISBLANK( PO_Receipt_Date__c ) , ISBLANK( Deposit_received__c ),  !ISPICKVAL(Project_Stage__c , &quot;Dead, Lost&quot; ), !ISPICKVAL( Project_Stage__c , &quot;Dead, Withdrawn&quot; )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPP-CommOppDefaults</fullName>
        <actions>
            <name>CPP_SetProjDelToDeliveryDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>CPP-Comm Opp Defaults.</description>
        <formula>AND(    $RecordType.Name = &quot;Commercial&quot; ,     !OR( ISPICKVAL( $User.UserType, &quot;PowerPartner&quot;), ISPICKVAL( $User.UserType, &quot;Partner&quot;) ) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CPP-DefaultCommOppStage</fullName>
        <actions>
            <name>CPP_MoveTo12</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>CPP-Default Comm Opp Stage.</description>
        <formula>AND(     $RecordType.Name  = &quot;Commercial&quot;,  OR(  ISPICKVAL( $User.UserType, &quot;PowerPartner&quot;),  ISPICKVAL( $User.UserType, &quot;Partner&quot;)  ) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CPP-DownPaymentEvent</fullName>
        <actions>
            <name>CPP_MoveTo95</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>CPP-Down Payment Event.</description>
        <formula>AND( $RecordType.Name = &quot;Commercial&quot;, !ISBLANK( Deposit_received__c ), !ISPICKVAL( StageName , &quot;100% - Delivered&quot; ), !ISPICKVAL( StageName , &quot;0% - Dead, Lost&quot; ), !ISPICKVAL( StageName , &quot;Future Follow-up&quot; ), !ISPICKVAL( StageName , &quot;Installation Completed&quot; ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CPP-EPAIssuedEvent</fullName>
        <actions>
            <name>CPP_MoveTo35</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>CPP-EPA Issued Event.</description>
        <formula>AND( $RecordType.Name = &quot;Commercial&quot;, !ISBLANK( EPA_Generated__c ), ISBLANK( Financing_in_Place_date__c ) , ISBLANK( PO_Receipt_Date__c ) , ISBLANK( Deposit_received__c ) , !ISPICKVAL( StageName , &quot;100% - Delivered&quot; ), !ISPICKVAL( StageName , &quot;0% - Dead, Lost&quot; ), !ISPICKVAL( StageName , &quot;Future Follow-up&quot; ), !ISPICKVAL( StageName , &quot;Installation Completed&quot; ),!ISPICKVAL( StageName , &quot;50% - Financing &amp; Rebate in Place&quot; ),!ISPICKVAL( StageName , &quot;75% - Imminent PO / Agreements Finalized&quot; ),!ISPICKVAL( StageName , &quot;85% - PO Received by SPWR&quot; ),!ISPICKVAL( StageName , &quot;95% - Down Payment Received by SPWR&quot; ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CPP-FundingInPlaceDate</fullName>
        <actions>
            <name>CPP_SetFinanceInPlaceDte</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>CPP-Funding In Place Date.</description>
        <formula>AND( $RecordType.Name = &quot;Commercial&quot;,  OR(  ISPICKVAL( PRIORVALUE( Financing_Status__c ) , &quot;In Process&quot;),  ISPICKVAL( PRIORVALUE( Financing_Status__c ) , &quot;&quot;) ), OR(  ISPICKVAL( Financing_Status__c , &quot;Cash&quot;),  ISPICKVAL( Financing_Status__c , &quot;SPWR Financing in Place&quot;),  ISPICKVAL( Financing_Status__c , &quot;Other Financing in Place&quot;) )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPP-FundingInPlaceEvent</fullName>
        <actions>
            <name>CPP_MoveTo50</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>CPP-Funding In Place Event.</description>
        <formula>AND( $RecordType.Name = &quot;Commercial&quot;, OR( ISPICKVAL( Financing_Status__c , &quot;Cash&quot;), ISPICKVAL( Financing_Status__c , &quot;SPWR Financing in Place&quot;), ISPICKVAL( Financing_Status__c , &quot;Other Financing in Place&quot;) ), ISBLANK( PO_Receipt_Date__c ) , ISBLANK( Deposit_received__c ) , !ISPICKVAL( StageName , &quot;100% - Won&quot; ), NOT(ISBLANK( EPA_Generated__c  )), !ISPICKVAL( StageName , &quot;0% - Dead, Lost&quot; ), !ISPICKVAL( StageName , &quot;Future Follow-up&quot; ), !ISPICKVAL( StageName , &quot;Installation Completed&quot; ) , !ISPICKVAL( StageName , &quot;75% - Imminent PO / Agreements Finalized&quot; ),!ISPICKVAL( StageName , &quot;85% - PO Received by SPWR&quot; ),!ISPICKVAL( StageName , &quot;95% - Down Payment Received by SPWR&quot; ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CPP-FundingNoLongerInPlace</fullName>
        <actions>
            <name>CPP_SetFinancingInPlaceBlank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Funding No Longer In Place.</description>
        <formula>AND( $RecordType.Name = &quot;Commercial&quot;,  OR(  ISPICKVAL( PRIORVALUE( Financing_Status__c ) , &quot;SPWR Financing in Place&quot;),  ISPICKVAL( PRIORVALUE( Financing_Status__c ) , &quot;Other Financing in Place&quot;),  ISPICKVAL( PRIORVALUE( Financing_Status__c ) , &quot;Cash&quot;) ), OR(  ISPICKVAL( Financing_Status__c , &quot;In Process&quot;),  ISPICKVAL( Financing_Status__c , &quot;&quot;)  )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPP-POReceivedFormula</fullName>
        <actions>
            <name>CPP_MoveTo85</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>CPP-PO Received Formula.</description>
        <formula>AND( $RecordType.Name = &quot;Commercial&quot;, !ISBLANK( PO_Receipt_Date__c ), ISBLANK( Deposit_received__c ) , !ISPICKVAL( StageName , &quot;100% - Won&quot; ), !ISPICKVAL( StageName , &quot;0% - Dead, Lost&quot; ), !ISPICKVAL( StageName , &quot;Future Follow-up&quot; ), !ISPICKVAL( StageName , &quot;Installation Completed&quot; ),!ISPICKVAL( StageName , &quot;90% - PO Received / Contracts Signed&quot; ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CPP-ProjStageToFutureFollowUp</fullName>
        <actions>
            <name>CPP_MoveToFutureFollowUp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(   $RecordType.Name = &quot;Commercial&quot;,    ISPICKVAL(  Project_Stage__c  , &quot;Future Follow-up&quot;),    ISBLANK( PO_Receipt_Date__c ) ,   ISBLANK( Deposit_received__c ) ,    !ISPICKVAL( StageName , &quot;100% - Delivered&quot; ),   !ISPICKVAL( StageName , &quot;0% - Dead, Lost&quot; ),   !ISPICKVAL( StageName , &quot;Installation Completed&quot; )    )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CPP-Project Stage Dead Stage Update</fullName>
        <actions>
            <name>CPP_MoveStageTo0</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 3) or (1 and 2 and 4)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Project_Stage__c</field>
            <operation>equals</operation>
            <value>&quot;Dead, Lost&quot;,&quot;Dead, Withdrawn&quot;</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>RLC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_Status__c</field>
            <operation>equals</operation>
            <value>Dead,Closed Lost</value>
        </criteriaItems>
        <description>CPP-Project Stage for DeadOut Dead, Withdrawn and Dead Lost</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPP-Project Stage DeadOut</fullName>
        <actions>
            <name>CPP_MoveStageTo0</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>CPP-Project Stage DeadOut.</description>
        <formula>AND(  $RecordType.Name = &quot;Commercial&quot;,  OR(  ISPICKVAL( $User.UserType, &quot;PowerPartner&quot;),  ISPICKVAL( $User.UserType, &quot;Partner&quot;)  ),  ISCHANGED(Project_Stage__c),  ISPICKVAL(PRIORVALUE( Project_Stage__c ), &quot;Dead, Lost&quot;), Isblank( PO_Receipt_Date__c ) ) &amp;&amp; NOT( $User.ByPassValidation__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPP-SetDeliveryDateToProjDelivery-Created</fullName>
        <actions>
            <name>CPP_SetDelDateToProjDel</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Deactivated the rule because it has been merged into another rule &apos;CPP-SetDeliveryDateToProjDelivery-Existing&apos;</description>
        <formula>AND(  OR(  ISPICKVAL( $User.UserType, &quot;PowerPartner&quot;),  ISPICKVAL( $User.UserType, &quot;Partner&quot;)  ),   $RecordType.Name = &quot;Commercial&quot;,   ISPICKVAL( StageName , &quot;12% - Qualified Opportunity&quot;)     )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CPP-SetDeliveryDateToProjDelivery-Existing</fullName>
        <actions>
            <name>CPP_SetDelDateToProjDel</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( OR(  ISPICKVAL( $User.UserType, &quot;PowerPartner&quot;),  ISPICKVAL( $User.UserType, &quot;Partner&quot;)  ),   $RecordType.Name = &quot;Commercial&quot;,   ISPICKVAL( StageName , &quot;12% - Qualified Opportunity&quot;) ,   OR(  ISNEW() , Projected_Delivery_Date__c &lt;&gt;  PRIORVALUE( Projected_Delivery_Date__c ) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPP-SetSiteAuditReceivedDate</fullName>
        <actions>
            <name>CPP_SetSiteAuditReceivedDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>CPP - This rule notices that the Site Audit Review Status drop down status has changed from none to something else and sets the Site Audit Form Received date to today.</description>
        <formula>AND(  OR(   ISPICKVAL( PRIORVALUE( Site_Audit_Review_Status__c ), &quot;&quot;)  ),  OR(  ISPICKVAL( Site_Audit_Review_Status__c , &quot;In-Process&quot;),  ISPICKVAL( Site_Audit_Review_Status__c , &quot;On Hold&quot;),  ISPICKVAL( Site_Audit_Review_Status__c , &quot;Completed-Preliminary&quot;),  ISPICKVAL( Site_Audit_Review_Status__c , &quot;Completed-Final&quot;),  ISPICKVAL( Site_Audit_Review_Status__c , &quot;Cancelled&quot;),  ISPICKVAL( Site_Audit_Review_Status__c , &quot;Rejected&quot;) )   )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPP-SetStageTo0%25DeadLostIfSiteReviewStatusChangesToCancelled</fullName>
        <actions>
            <name>CPP_MoveStageTo0</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPP_SetReasonWon_LostToSARCancelled</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>CPP - set the opportunity Stage to 0% - Dead, Lost, and Reason Won/Lost to “SAR Cancelled” if the “Site Audit Review Status” field is changed to Cancelled.</description>
        <formula>AND( ISPICKVAL( Site_Audit_Review_Status__c , &quot;Cancelled&quot;), $RecordType.Name = &quot;Commercial&quot;,  !ISPICKVAL( StageName , &quot;100% - Won&quot; ), !ISPICKVAL( StageName , &quot;Future Follow-up&quot; ), !ISPICKVAL( StageName , &quot;Installation Completed&quot; ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CPP-SetStageTo0%25DeadLostIfSiteReviewStatusChangesToRejected</fullName>
        <actions>
            <name>CPP_MoveStageTo0</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPP_SetReasonWon_LostToSARRejected</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>CPP - set the opportunity Stage to 0% - Dead, Lost, and Reason Won/Lost to “SAR Rejected” if the “Site Audit Review Status” field is changed to Rejected.</description>
        <formula>AND( ISPICKVAL( Site_Audit_Review_Status__c , &quot;Rejected&quot;), $RecordType.Name = &quot;Commercial&quot;,  !ISPICKVAL( StageName , &quot;100% - Won&quot; ), !ISPICKVAL( StageName , &quot;Future Follow-up&quot; ), !ISPICKVAL( StageName , &quot;Installation Completed&quot; ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CPP-SetStageTo25IfSiteReviewStatusChanges</fullName>
        <actions>
            <name>CPP_MoveTo20</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>CPP - This rule is redundant but makes sure that the Stage moves to 25% if other rules fire in unfortunate order.</description>
        <formula>AND( OR( ISPICKVAL( Site_Audit_Review_Status__c , &quot;In-Process&quot;), ISPICKVAL( Site_Audit_Review_Status__c , &quot;On Hold&quot;), ISPICKVAL( Site_Audit_Review_Status__c , &quot;Completed-Preliminary&quot;), ISPICKVAL( Site_Audit_Review_Status__c , &quot;Completed-Final&quot;) ), $RecordType.Name = &quot;Commercial&quot;, ISBLANK( Financing_in_Place_date__c ) , ISBLANK( PO_Receipt_Date__c ) , ISBLANK( Deposit_received__c ) , !ISPICKVAL( StageName , &quot;100% - Delivered&quot; ), !ISPICKVAL( StageName , &quot;0% - Dead, Lost&quot; ), !ISPICKVAL( StageName , &quot;Future Follow-up&quot; ), !ISPICKVAL( StageName , &quot;Installation Completed&quot; ) , !ISPICKVAL( StageName , &quot;35% - EPA/Quote Issued&quot; ),!ISPICKVAL( StageName , &quot;50% - Financing &amp; Rebate in Place&quot; ),!ISPICKVAL( StageName , &quot;75% - Verbal commitment of imminent PO&quot; ),!ISPICKVAL( StageName , &quot;90% - PO Received with Deposit&quot; ),!ISPICKVAL( StageName , &quot;95% - Down Payment Received by SPWR&quot; ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CPP-SiteAuditReceivedEvent</fullName>
        <actions>
            <name>CPP_MoveTo20</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $RecordType.Name = &quot;Commercial&quot;, !ISBLANK( Site_Audit_Form_Received__c ) , ISBLANK( Financing_in_Place_date__c ) , ISBLANK( PO_Receipt_Date__c ) , ISBLANK( Deposit_received__c ) , !ISPICKVAL( StageName , &quot;100% - Won&quot; ), !ISPICKVAL( StageName , &quot;0% - Dead, Lost&quot; ), !ISPICKVAL( StageName , &quot;Future Follow-up&quot; ), !ISPICKVAL( StageName , &quot;Installation Completed&quot; ) , !ISPICKVAL( StageName , &quot;35% - EPA/Quote Issued&quot; ),!ISPICKVAL( StageName , &quot;50% - Financing &amp; Rebate in Place&quot; ),!ISPICKVAL( StageName , &quot;75% - Imminent PO / Agreements Finalized&quot; ),!ISPICKVAL( StageName , &quot;85% - PO Received by SPWR&quot; ),!ISPICKVAL( StageName , &quot;95% - Down Payment Received by SPWR&quot; ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CPP-TimeOfInstallLT1</fullName>
        <actions>
            <name>CPP_SetProjDel_45</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Commercial</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CPP-UndoPartnerStageChangeFrom0%25DeadLost</fullName>
        <actions>
            <name>CPP_MoveStageTo0</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(    $RecordType.Name  = &quot;Commercial&quot;, OR(  ISPICKVAL( $User.UserType, &quot;PowerPartner&quot;), ISPICKVAL( $User.UserType, &quot;Partner&quot;) ),  ISCHANGED(StageName),  ISPICKVAL(PRIORVALUE(StageName), &quot;0% - Dead, Lost&quot;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPP-UndoPartnerStageChangeFrom100%25</fullName>
        <actions>
            <name>CPP_MoveTo100</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(    $RecordType.Name  = &quot;Commercial&quot;, OR( ISPICKVAL( $User.UserType, &quot;PowerPartner&quot;), ISPICKVAL( $User.UserType, &quot;Partner&quot;) ),   ISCHANGED(StageName),  ISPICKVAL(PRIORVALUE(StageName), &quot;100% - Won&quot;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPP-UndoPartnerStageChangeFrom12%25</fullName>
        <actions>
            <name>CPP_MoveTo12</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(    $RecordType.Name  = &quot;Commercial&quot;, NOT( ISPICKVAL( StageName,&quot;0% - Dead, Lost&quot;)), NOT( ISPICKVAL(StageName, &quot;0% - Lost&quot;)),  OR( ISPICKVAL( $User.UserType, &quot;PowerPartner&quot;), ISPICKVAL( $User.UserType, &quot;Partner&quot;) ),   ISCHANGED(StageName),  ISPICKVAL(PRIORVALUE(StageName), &quot;12% - Qualified Opportunity&quot;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPP-UndoPartnerStageChangeFrom25%25</fullName>
        <actions>
            <name>CPP_MoveTo20</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>CPP-UndoPartnerStageChangeFrom25%</description>
        <formula>AND(    $RecordType.Name  = &quot;Commercial&quot;, OR( ISPICKVAL( $User.UserType, &quot;PowerPartner&quot;), ISPICKVAL( $User.UserType, &quot;Partner&quot;) ),   ISCHANGED(StageName),  ISPICKVAL(PRIORVALUE(StageName), &quot;25% - Design Initiated&quot;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPP-UndoPartnerStageChangeFrom35%25</fullName>
        <actions>
            <name>CPP_MoveTo35</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(    $RecordType.Name  = &quot;Commercial&quot;, OR( ISPICKVAL( $User.UserType, &quot;PowerPartner&quot;), ISPICKVAL( $User.UserType, &quot;Partner&quot;) ),   ISCHANGED(StageName),  ISPICKVAL(PRIORVALUE(StageName), &quot;35% - EPA/Quote Issued&quot;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPP-UndoPartnerStageChangeFrom50%25</fullName>
        <actions>
            <name>CPP_MoveTo50</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(     $RecordType.Name  = &quot;Commercial&quot;,  OR(  ISPICKVAL( $User.UserType, &quot;PowerPartner&quot;),  ISPICKVAL( $User.UserType, &quot;Partner&quot;)  ),    ISCHANGED(StageName),   ISPICKVAL(PRIORVALUE(StageName), &quot;50% - Financing &amp; Rebate in Place&quot;)   )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPP-UndoPartnerStageChangeFrom75%25</fullName>
        <actions>
            <name>CPP_MoveTo75</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(    $RecordType.Name  = &quot;Commercial&quot;, OR( ISPICKVAL( $User.UserType, &quot;PowerPartner&quot;), ISPICKVAL( $User.UserType, &quot;Partner&quot;) ),   ISCHANGED(StageName),  ISPICKVAL(PRIORVALUE(StageName), &quot;75% - Imminent PO / Agreements Finalized&quot;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPP-UndoPartnerStageChangeFrom90%25</fullName>
        <actions>
            <name>CPP_MoveTo85</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Was 85%</description>
        <formula>AND(    $RecordType.Name  = &quot;Commercial&quot;, OR( ISPICKVAL( $User.UserType, &quot;PowerPartner&quot;), ISPICKVAL( $User.UserType, &quot;Partner&quot;) ),   ISCHANGED(StageName),  ISPICKVAL(PRIORVALUE(StageName), &quot;90% - PO Received / Contracts Signed&quot;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPP-UndoPartnerStageChangeFrom95%25</fullName>
        <actions>
            <name>CPP_MoveTo95</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(    $RecordType.Name  = &quot;Commercial&quot;, OR( ISPICKVAL( $User.UserType, &quot;PowerPartner&quot;), ISPICKVAL( $User.UserType, &quot;Partner&quot;) ),   ISCHANGED(StageName),  ISPICKVAL(PRIORVALUE(StageName), &quot;95% - Down Payment Received by SPWR&quot;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPP-UndoPartnerStageChangeFromFutureFollowUp</fullName>
        <actions>
            <name>CPP_MoveToFutureFollowUp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(    $RecordType.Name  = &quot;Commercial&quot;, OR( ISPICKVAL( $User.UserType, &quot;PowerPartner&quot;), ISPICKVAL( $User.UserType, &quot;Partner&quot;) ),   ISCHANGED(StageName),  ISPICKVAL(PRIORVALUE(StageName), &quot;Future Follow-up&quot;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPP-UndoPartnerStageChangeFromInstallationComplete</fullName>
        <actions>
            <name>CPP_MoveToInstallationComplete</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(    $RecordType.Name  = &quot;Commercial&quot;, OR( ISPICKVAL( $User.UserType, &quot;PowerPartner&quot;), ISPICKVAL( $User.UserType, &quot;Partner&quot;) ),   ISCHANGED(StageName),  ISPICKVAL(PRIORVALUE(StageName), &quot;Installation Completed&quot;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPP-VerbalCommitment</fullName>
        <actions>
            <name>CPP_MoveTo75</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPP_SetCloseDate_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $RecordType.Name = &quot;Commercial&quot;, ISPICKVAL( Project_Stage__c , &quot;Proposal Won&quot;), ISBLANK( PO_Receipt_Date__c ) , ISBLANK( Deposit_received__c ) , !ISPICKVAL( StageName , &quot;100% - Won&quot; ), !ISPICKVAL( StageName , &quot;0% - Dead, Lost&quot; ), !ISPICKVAL( StageName , &quot;Future Follow-up&quot; ), !ISPICKVAL( StageName , &quot;Installation Completed&quot; ) ,!ISPICKVAL( StageName , &quot;85% - PO Received by SPWR&quot; ),!ISPICKVAL( StageName , &quot;95% - Down Payment Received by SPWR&quot; ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CSAT French Survey</fullName>
        <actions>
            <name>Email_alert_to_French_Contact_if_customer_survey_become_true</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Survey sent to French customer</description>
        <formula>NOT($User.ByPassValidation__c) &amp;&amp; $RecordType.Name = &apos;Home Owner&apos; &amp;&amp; ISPICKVAL(Theater__c, &apos;Europe&apos;) &amp;&amp; Customer_Satisfaction_survey_opt_in__c = true &amp;&amp; Account.BillingCountry = &apos;France&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CSAT German Survey</fullName>
        <actions>
            <name>Email_alert_to_German_Contact_if_customer_survey_become_true</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Survey sent to German customer</description>
        <formula>NOT($User.ByPassValidation__c) &amp;&amp; $RecordType.Name = &apos;Home Owner&apos; &amp;&amp; ISPICKVAL(Theater__c, &apos;Europe&apos;) &amp;&amp; Customer_Satisfaction_survey_opt_in__c = true &amp;&amp; Account.BillingCountry = &apos;Germany&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CSAT Italy Survey</fullName>
        <actions>
            <name>Email_alert_to_Italian_Contact_if_customer_survey_become_true</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Survey sent to Italian</description>
        <formula>NOT($User.ByPassValidation__c) &amp;&amp; $RecordType.Name = &apos;Home Owner&apos; &amp;&amp; ISPICKVAL(Theater__c, &apos;Europe&apos;) &amp;&amp; Customer_Satisfaction_survey_opt_in__c = true &amp;&amp; Account.BillingCountry = &apos;Italy&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CVAR Order Acknowledgement</fullName>
        <actions>
            <name>CVAR_Order_Acknowledgement</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>( (NOT(ISNULL(PO_Receipt_Date__c)) &amp;&amp; ISNULL(PRIORVALUE(PO_Receipt_Date__c))   ) || PO_Receipt_Date__c!= PRIORVALUE(PO_Receipt_Date__c) )&amp;&amp;  RecordTypeId =&apos;0128000000037dl&apos;&amp;&amp; NOT(ISNULL(PO_Receipt_Date__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Change Project Status New Prospect</fullName>
        <actions>
            <name>CPP_ProjStagetoNewProspect</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.RLC_Type__c</field>
            <operation>equals</operation>
            <value>Light Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>12% - Qualified Opportunity</value>
        </criteriaItems>
        <description>Change Project Status New Prospect</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Change Stage - Development</fullName>
        <actions>
            <name>Change_Stage_Order_Placed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Development</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>notEqual</operation>
            <value>01 – Prospecting,02 - Early Development,03 - Mid Development,04 - Advance Development,05 - Finalize Assets,06 – Closed Won,07 – Closed Lost</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Check Partner Update</fullName>
        <actions>
            <name>TESTPartner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Check_Partner__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Closed Lost Email Notification - NAC</fullName>
        <actions>
            <name>Close_Lost_Competitor_Information_Reminder_NAC</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_notification_when_Opportunity_Sales_Stage_is_updated_to_Closed_Lost_NAC</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Probability</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CreatedById</field>
            <operation>notEqual</operation>
            <value>DMAdmin</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>NA Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Workflow process that triggers an email notification to the Sales Team if the Opportunity Sales Stage is updated to Closed Lost - NAC</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Closed Lost Email Notification - UPPa</fullName>
        <actions>
            <name>Opportunity_is_Closed_Lost_UPP_Americas</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Probability</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CreatedById</field>
            <operation>notEqual</operation>
            <value>DMAdmin</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>UPP Americas</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Owner_ID__c</field>
            <operation>notEqual</operation>
            <value>00580000005FjM2</value>
        </criteriaItems>
        <description>Workflow process that triggers an email notification to the Sales Team if the Opportunity Sales Stage is updated to Closed Lost - UPPa</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Closed Lost Email Notification - UPPi</fullName>
        <actions>
            <name>Opportunity_is_Closed_Lost_UPP_Intl</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Probability</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CreatedById</field>
            <operation>notEqual</operation>
            <value>DMAdmin</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>UPP Intl,Commercial Intl</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Workflow process that triggers an email notification to the Sales Team if the Opportunity Sales Stage is updated to Closed Lost - UPPi</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Closed Won Email Notification - NAC</fullName>
        <actions>
            <name>Workflow_process_that_triggers_an_email_notification_to_the_NAC_Ops_Team_when_Op</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won,06 – Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CreatedById</field>
            <operation>notEqual</operation>
            <value>DMAdmin</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>NA Commercial</value>
        </criteriaItems>
        <description>Workflow process that triggers an email notification to the NAC Ops team if the Opportunity Sales Stage is updated to Closed Won</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Closing Date In Current Quarter</fullName>
        <actions>
            <name>Closing_Date_In_Current_Quarter</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>((1 AND 2 and 3) or (1 and 2 and 4) or (1 and 2 and 5)) AND 6</booleanFilter>
        <criteriaItems>
            <field>Opportunity.CloseDate</field>
            <operation>lessOrEqual</operation>
            <value>THIS QUARTER</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>NA Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>01 - Build Single Sales Objective</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>02 - Finalize SSO</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>03 - Firm Offer</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Alert when NAC Deal has a deal closing in current quarter with stage of 01 – Assess Opportunity, 02 – Budgetary Pricing, or 03 – Binding Offer</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Comm Delivery Pre-Alert-10days</fullName>
        <active>true</active>
        <description>notification 10 days before delivery date upon meeting set criteria (previously 7 day)</description>
        <formula>AND( Probability =0.90, (Delivery_Date__c  -  TODAY()  &gt;=  10), NOT( Account.ShippingState = &apos;HI&apos; ), RecordType.Name =&quot;Commercial&quot;, ISPICKVAL( Business_Unit__c, &quot;RLC&quot;), ISPICKVAL( Partner_Account_Id__r.Status__c, &quot;Active&quot;), OR( ISPICKVAL( Theater__c, &quot;North America&quot;), ISPICKVAL( Theater__c, &quot;Central America and the Caribbean&quot;) ), OR( ISPICKVAL( Partner_Account_Id__r.Type, &quot;Authorized-Partner-Combo&quot;), ISPICKVAL( Partner_Account_Id__r.Type, &quot;Partner-Commercial&quot;), ISPICKVAL( Partner_Account_Id__r.Type, &quot;Premier-Partner-Combo&quot;), ISPICKVAL( Partner_Account_Id__r.Type, &quot;Elite-Partner-Combo&quot;) ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Commercial_Delivery_Pre_Alert_7_days_before_Delivery_Date</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Delivery_Date__c</offsetFromField>
            <timeLength>-10</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Comm Delivery Pre-Alert-14days</fullName>
        <active>false</active>
        <description>notification 14 days before delivery date upon meeting set criteria</description>
        <formula>AND( Probability =0.90, (Delivery_Date__c  -  TODAY()  &gt;=  14), RecordType.Name =&quot;Commercial&quot;, ISPICKVAL( Business_Unit__c, &quot;RLC&quot;), ISPICKVAL( Partner_Account_Id__r.Status__c, &quot;Active&quot;), OR( ISPICKVAL( Theater__c, &quot;North America&quot;), ISPICKVAL( Theater__c, &quot;Central America and the Caribbean&quot;) ), OR( ISPICKVAL( Partner_Account_Id__r.Type, &quot;Authorized-Partner-Combo&quot;), ISPICKVAL( Partner_Account_Id__r.Type, &quot;Partner-Commercial&quot;), ISPICKVAL( Partner_Account_Id__r.Type, &quot;Premier-Partner-Combo&quot;), ISPICKVAL( Partner_Account_Id__r.Type, &quot;Elite-Partner-Combo&quot;) ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Commercial_Delivery_Pre_Alert_14_days_before_Delivery_Date</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Delivery_Date__c</offsetFromField>
            <timeLength>-14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Comm Delivery Pre-Alert-28days</fullName>
        <active>true</active>
        <description>notification 28 days before delivery date upon meeting set criteria</description>
        <formula>AND( Probability =0.90, (Delivery_Date__c  -  TODAY()  &gt;=  28), RecordType.Name =&quot;Commercial&quot;, ISPICKVAL( Business_Unit__c, &quot;RLC&quot;), ISPICKVAL( Partner_Account_Id__r.Status__c, &quot;Active&quot;), OR( ISPICKVAL( Theater__c, &quot;North America&quot;), ISPICKVAL( Theater__c, &quot;Central America and the Caribbean&quot;) ), OR( ISPICKVAL( Partner_Account_Id__r.Type, &quot;Authorized-Partner-Combo&quot;), ISPICKVAL( Partner_Account_Id__r.Type, &quot;Partner-Commercial&quot;), ISPICKVAL( Partner_Account_Id__r.Type, &quot;Premier-Partner-Combo&quot;), ISPICKVAL( Partner_Account_Id__r.Type, &quot;Elite-Partner-Combo&quot;) ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Commercial_Delivery_Pre_Alert_28_days_before_Delivery_Date</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Delivery_Date__c</offsetFromField>
            <timeLength>-28</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Comm Delivery Pre-Alert-7days</fullName>
        <active>false</active>
        <description>notification 7 days before delivery date upon meeting set criteria</description>
        <formula>AND( Probability =0.90, (Delivery_Date__c  -  TODAY()  &gt;=  7), NOT( Account.ShippingState = &apos;HI&apos; ), RecordType.Name =&quot;Commercial&quot;, ISPICKVAL( Business_Unit__c, &quot;RLC&quot;), ISPICKVAL( Partner_Account_Id__r.Status__c, &quot;Active&quot;), OR( ISPICKVAL( Theater__c, &quot;North America&quot;), ISPICKVAL( Theater__c, &quot;Central America and the Caribbean&quot;) ), OR( ISPICKVAL( Partner_Account_Id__r.Type, &quot;Authorized-Partner-Combo&quot;), ISPICKVAL( Partner_Account_Id__r.Type, &quot;Partner-Commercial&quot;), ISPICKVAL( Partner_Account_Id__r.Type, &quot;Premier-Partner-Combo&quot;), ISPICKVAL( Partner_Account_Id__r.Type, &quot;Elite-Partner-Combo&quot;) ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Commercial_Delivery_Pre_Alert_7_days_before_Delivery_Date</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Delivery_Date__c</offsetFromField>
            <timeLength>-7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Convert System AUS Lead to Opportunity System Type</fullName>
        <actions>
            <name>Convert_Opportunity_to_System_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Theater__c</field>
            <operation>equals</operation>
            <value>Australia</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Converted_Lead_Record_Type__c</field>
            <operation>equals</operation>
            <value>Systems</value>
        </criteriaItems>
        <description>Convert System Type Australian Lead to Opportunity System Record Type</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Create Task on Opportunity for VIP Campaign Converted SPD Leads</fullName>
        <active>true</active>
        <description>Workflow to fire flow trigger sending either an onsite appointment notification to an opportunity&apos;s primary contact and energy consultant for SPD</description>
        <formula>AND(    NOT( ISBLANK( Appointment_Date__c ) ),     NOT( ISBLANK( TEXT(Appointment_Time__c) ) ),   OR( ISPICKVAL( Consultation_Type__c , &apos;In-Person&apos;),        ISPICKVAL( Consultation_Type__c, &apos;Online&apos;) ),   Partner_Account_text__c  = &apos;SunPower Direct (SPD)&apos;,   Campaign.Name = &apos;SunPower VIP Executive Pass&apos; )</formula>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Customer_Consultation</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Opportunity.HD_CreatedDatePlus2Min__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Customer Design Review %28SPD%29</fullName>
        <actions>
            <name>Customer_Design_Review_SPD</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Customer_Design_Review_SPD_Installer_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Design_Status_Design_Sent_to_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Uncheck_Correct_Design_Submitted</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Customer Design Review (SPD)</description>
        <formula>(CONTAINS( Partner_Account_text__c , &apos;SPD&apos;) &amp;&amp; (ISPICKVAL(  Design_Status__c  , &quot;Design Submitted&quot;)  ||  ISPICKVAL(  Design_Status__c  , &quot;Design Sent to Customer&quot;)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Customer_Design_Review_Reminder_SPD</name>
                <type>Alert</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>No_Customer_Design_Off_SPD</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Design_Status_No_Customer_Response</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Customer Design Review %28SPD%29 Approved</fullName>
        <actions>
            <name>Customer_Design_Review_SPD_Approved</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Design_Status__c</field>
            <operation>equals</operation>
            <value>Final Design Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Partner_Account_text__c</field>
            <operation>contains</operation>
            <value>SPD</value>
        </criteriaItems>
        <description>Customer Design Review (SPD) Approved</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Customer Design Review %28SPD%29 Rejected</fullName>
        <actions>
            <name>Customer_Design_Review_SPD_Rejected</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Design_Status__c</field>
            <operation>equals</operation>
            <value>Customer Declined Design</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Partner_Account_text__c</field>
            <operation>contains</operation>
            <value>SPD</value>
        </criteriaItems>
        <description>Customer Design Review (SPD) Rejected</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Customer Survey Opt In Default - NA - AUS</fullName>
        <actions>
            <name>Customer_Survey_Opt_In_Default</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Theater__c</field>
            <operation>equals</operation>
            <value>Central America and the Caribbean,North America,Australia</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Home Owner</value>
        </criteriaItems>
        <description>Customer Survey Opt In Default - NA - AUS</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Date - Flash Test Data Request Date Update</fullName>
        <actions>
            <name>Date_Flash_Test_Data_Request_Date_Upda</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Flash_Test_Data_Request__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Date - Flash Test Data Request Date Update</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Date Opportunity Was Changed to Closed Lost</fullName>
        <actions>
            <name>Date_Opportunity_Changed_to_Closed_Lost</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>&quot;0% - Dead, Lost&quot;,07 – Closed Lost,Opportunity Lost,Closed Lost,0% - Lost</value>
        </criteriaItems>
        <description>Date Opportunity Was Changed to Closed Lost</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Default Stage for EU Commercial</fullName>
        <actions>
            <name>Default_Stage_for_EU_Commercial</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RLC_Type__c</field>
            <operation>equals</operation>
            <value>EU Commercial</value>
        </criteriaItems>
        <description>Default Stage for EU Commercial</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Delivery Date default to Projected Delivery Date - RLC NA</fullName>
        <actions>
            <name>Default_Delivery_to_Projected_RLC_NA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Delivery_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Projected_Delivery_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>RLC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Theater__c</field>
            <operation>equals</operation>
            <value>North America</value>
        </criteriaItems>
        <description>Delivery Date default to Projected Delivery Date - RLC NA</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Dormant Opportunity Email Notification</fullName>
        <actions>
            <name>Workflow_process_that_triggers_an_email_notification_to_Opportunity_Owner_when_t</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Opportunity_LastModifiedDate__c</field>
            <operation>greaterOrEqual</operation>
            <value>NEXT 180 DAYS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CreatedById</field>
            <operation>notEqual</operation>
            <value>DMAdmin</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Workflow process that triggers an email notification to Opportunity Owner when the Last Modified Date has not changed for 6 months</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Dummy Update on Opportunity</fullName>
        <actions>
            <name>Dummy_Field_Uncheck</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Dummy_Update_on_Opportunity__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EU Post Dealer Visit Follow up Survey</fullName>
        <active>false</active>
        <description>EU Post Dealer Visit Survey</description>
        <formula>NOT($User.ByPassValidation__c) &amp;&amp; ISPICKVAL(Lead_Manufacturer__c, &apos;SunPower&apos;) &amp;&amp; NOT(ISPICKVAL(StageName,&apos;Installation Completed&apos;)) &amp;&amp; $RecordType.Name = &apos;Home Owner&apos; &amp;&amp; Account.BillingCountry = &apos;Italy&apos; &amp;&amp; ISPICKVAL(RLC_Type__c,&apos;Residential&apos;)  &amp;&amp;  NOT(ISBLANK(Partner_Account_Id__c)) &amp;&amp; CreatedDate &lt; DATETIMEVALUE(&quot;2012-01-16 11:00:00&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>EU_Post_Visit_Survey</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Send_Mail_update</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Opportunity.CreatedDate</offsetFromField>
            <timeLength>31</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Financed Commercial Opps Stage Update</fullName>
        <actions>
            <name>Financed_CVAR_Opportunity_Stage_Update</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>EMAIL alert to Finance SME when CVAR oppss gets updated and Financing comment is not blank</description>
        <formula>AND(ISCHANGED(StageName), AND(OR(ISPICKVAL(StageName , &quot;25% - Design Initiated&quot;),ISPICKVAL(StageName , &quot;50% - Quote / Proposal Submitted&quot;),ISPICKVAL(StageName , &quot;90% - PO Received / Contracts Signed&quot;)), AND(RecordType.DeveloperName=&quot;Commercial&quot;, AND(ISPICKVAL(Business_Unit__c,&quot;RLC&quot;), AND(ISPICKVAL(Partner_Account_Id__r.Status__c ,&quot;Active&quot;), AND (OR(ISPICKVAL(Theater__c,&quot;North America&quot;),ISPICKVAL(Theater__c,&quot;Central America and the Caribbean&quot;)), AND(NOT(ISBLANK( Financing__c)))))))))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FivePercentageDown</fullName>
        <actions>
            <name>FivePercentageDownPayment</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>(  (NOT(ISNULL(Down_Payment_Invoice_Number__c )) &amp;&amp; ISNULL(PRIORVALUE(Down_Payment_Invoice_Number__c )) )  ||  Down_Payment_Invoice_Number__c!= PRIORVALUE(Down_Payment_Invoice_Number__c) )&amp;&amp;  RecordTypeId =&apos;0128000000037dl&apos;&amp;&amp;  NOT(ISNULL(Down_Payment_Invoice_Number__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Ford - Nissan Spiff Update</fullName>
        <actions>
            <name>Ford_Spiff_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Primary_Campaign_Source_text__c</field>
            <operation>contains</operation>
            <value>Ford,Nissan</value>
        </criteriaItems>
        <description>Ford - Nissan Spiff Update</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Hand Off Task Creation</fullName>
        <actions>
            <name>Please_compile_Booking_and_Hand_Off_Documents_for_this_Opportunity_s_contract_ty</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>06 – Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CreatedById</field>
            <operation>notEqual</operation>
            <value>DMAdmin</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Probability</field>
            <operation>equals</operation>
            <value>100</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>notEqual</operation>
            <value>RLC,Components,UPP Intl</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Components</value>
        </criteriaItems>
        <description>Task Created when Opportunity status is updated to Agreements Finalized</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Homeowner Install Survey Notification - NA Cash</fullName>
        <actions>
            <name>Homeowner_Install_Survey_Notification_Alert_NA_Cash</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Installation Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Theater__c</field>
            <operation>equals</operation>
            <value>Central America and the Caribbean,North America</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Customer_Satisfaction_survey_opt_in__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Partner_Account_text__c</field>
            <operation>contains</operation>
            <value>SunPower Direct</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Lease__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Lease_Placed_in_Service__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Date_PTO_Letter_Received_Promised__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Homeowner Install Survey Notification - NA Cash</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Homeowner Install Survey Notification - NA Lease</fullName>
        <actions>
            <name>Homeowner_Install_Survey_Notification_Alert_NA_Lease</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Installation Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Theater__c</field>
            <operation>equals</operation>
            <value>Central America and the Caribbean,North America</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Customer_Satisfaction_survey_opt_in__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Partner_Account_text__c</field>
            <operation>contains</operation>
            <value>SunPower Direct</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Lease__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Lease_Placed_in_Service__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Homeowner Install Survey Notification - NA Lease</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Initiate Credit Approval for Host Credit - NAC</fullName>
        <actions>
            <name>Initiate_Credit_Approval_for_Host_Credit</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>NA Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Probability</field>
            <operation>greaterOrEqual</operation>
            <value>25</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Contract_Type__c</field>
            <operation>equals</operation>
            <value>PPA (including EPC)</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Initiate Credit Approval for Host Credit - NAC</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Introductory email</fullName>
        <actions>
            <name>Introductory_email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISPICKVAL(Theater__c, &apos;Europe&apos;), CONTAINS(Customer_Country__c, &apos;France&apos;), (OwnerId = Primary_Contact__r.Id ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Large Deal Email Alert - NAC</fullName>
        <actions>
            <name>Large_Deal_Email_Alert_NAC</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Large Deal Email Alert - NAC
Pivotal #143057849 - case# 00941990 - NAC Large Deal Email Alert</description>
        <formula>AND (  RecordType.DeveloperName = &apos;Systems&apos;,  ISPICKVAL(Business_Unit__c, &apos;NA Commercial&apos;),  Amount &gt;= 20000000,   ISPICKVAL(StageName, &apos;04 - Negotiate Binding Contract&apos;),  $User.ByPassValidation__c = false )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Last Modified by Takashi Sugihara or Hiroshi Amano</fullName>
        <actions>
            <name>Opportunity_Modified_by_Takashi_Sugihara_and_Yiqun_Wang</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Opportunity.LastModifiedById</field>
            <operation>equals</operation>
            <value>Takashi Sugihara</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.LastModifiedById</field>
            <operation>equals</operation>
            <value>Hiroshi Amano</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Last Modified by Takashi Sugihara or Hiroshi Amano</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lease Order Placed -Close Oppty</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Lease_Order_Placed__c</field>
            <operation>equals</operation>
            <value>Y</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lease Survey Opt out</fullName>
        <actions>
            <name>Update_Survey_Opt_in</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.OptOut__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>When optOut field on opportunity is checked then customer survey satisfaction opt in should be unchecked</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Manual Credit Review Notification</fullName>
        <actions>
            <name>Email_Pending_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sent when Application Status changes to Pending – Credit Review</description>
        <formula>AND( Credit_Application_Status__c != &apos;&apos; ,  OR( Credit_Application_Status__c = &quot;Pending - Credit Review&quot;, Credit_Application_Status__c = &quot;pending - credit review&quot; )  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Move to 100%25</fullName>
        <actions>
            <name>Move_to_100</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>100% - Delivered,100% - Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Commercial</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Move to 12%25</fullName>
        <actions>
            <name>Update_12</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>contains</operation>
            <value>12%</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Move to 25%25</fullName>
        <actions>
            <name>Probability_25</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>contains</operation>
            <value>25</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Move to 50%25</fullName>
        <actions>
            <name>Move_to_50</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 or 3) AND 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>contains</operation>
            <value>50</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>50% - Quote / Proposal Submitted</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Move to 75%25</fullName>
        <actions>
            <name>Move_to_75</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>contains</operation>
            <value>75%</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Move to 90%25</fullName>
        <actions>
            <name>Move_to_90</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 or 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>contains</operation>
            <value>90</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>90% - PO Received / Contracts Signed</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Negotiate Contract %28NAC%29</fullName>
        <actions>
            <name>X50_Probability_NAC</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Negotiate Contract (NAC)</description>
        <formula>AND(  NOT($User.ByPassValidation__c), ISCHANGED(Probability ),  AND(  (ISPICKVAL(Business_Unit__c ,&apos;NA Commercial&apos;)),   ISPICKVAL( StageName ,&apos;04 - Negotiate Binding Contract&apos;)  ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>New Follow-Up Workflow Rule with Converted Rating</fullName>
        <actions>
            <name>New_Residential_Opportunity_Partner_Follow_Up_with_Converted_Rating_Template</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Partner_Account_text__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Primary_Campaign_Source_text__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Theater__c</field>
            <operation>equals</operation>
            <value>North America</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Lead_Manufacturer__c</field>
            <operation>equals</operation>
            <value>SunPower</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Partner_Account_text__c</field>
            <operation>equals</operation>
            <value>SunPower Direct,Quality Home Services,Sun Solar Energy Solutions dba Lifestyles Construction and Solar,Revolusun,SPWR by QHS,Sun Solar Energy Solutions dba Lifestyles Construction and Solar,Revolusun,Sunpower Sales Experience (SSE)</value>
        </criteriaItems>
        <description>New Residential Opportunity Partner Follow-Up Email with converted rating</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Opportunity Created - NAC</fullName>
        <actions>
            <name>New_Opportunity_Created_Notice_NAC</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>NA Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>An email notification sent when a new NA Commercial opportunity is created.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New Opportunity Created by Arun Kumar%2C Yashwant Jain%2C Pradeep Sangwan</fullName>
        <actions>
            <name>Opportunity_Created_By_Arun_Kumar_Yashwant_Jain_Pradeep_Sangwan</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>Opportunity.CreatedById</field>
            <operation>equals</operation>
            <value>Arun Kumar</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CreatedById</field>
            <operation>equals</operation>
            <value>Yashwant Jain</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CreatedById</field>
            <operation>equals</operation>
            <value>Pradeep Sangwan</value>
        </criteriaItems>
        <description>New Opportunity Created by Arun Kumar, Yashwant Jain, Pradeep Sangwan</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New Opportunity Created by Hiroshi Amano or Arun Kumar</fullName>
        <actions>
            <name>New_Opportunity_Created_by_Hiroshi_Amano_or_Arun_Kumar</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 Or 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.CreatedById</field>
            <operation>equals</operation>
            <value>Hiroshi Amano</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CreatedById</field>
            <operation>equals</operation>
            <value>Arun Kumar</value>
        </criteriaItems>
        <description>New Opportunity Created by Hiroshi Amano or Arun Kumar</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New Opportunity Created by Takashi Sugihara and Hiroshi Amano</fullName>
        <actions>
            <name>Opportunity_Created_by_Yiqun_Wang</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.CreatedById</field>
            <operation>equals</operation>
            <value>Takashi Sugihara</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CreatedById</field>
            <operation>equals</operation>
            <value>Hiroshi Amano</value>
        </criteriaItems>
        <description>New Opportunity Created by Takashi Sugihara and Hiroshi Amano</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New RLC Commericial Opportunity Created - NA</fullName>
        <actions>
            <name>New_RLC_Opportunity_Created_NA</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Theater__c</field>
            <operation>equals</operation>
            <value>North America</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CRSM__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>New RLC Opportunity Commercial Created - NA</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Residential Opportunity - HO notification NA Standard or No Campaign</fullName>
        <actions>
            <name>New_Residential_Opportunity_Created_NA_No_Campaign</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>New_Residential_Opps_Notification</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>New Residential Opportunity - HO notification NA Standard or No Campaign</description>
        <formula>(  	Partner_Account_Id__r.RecordType.DeveloperName = &quot;Partner&quot;  	&amp;&amp; !ISBLANK(Partner_Account_text__c)  	&amp;&amp; ( 		ISBLANK(Primary_Campaign_Source_text__c)  		|| ( Campaign.RecordTypeId = &apos;01280000000Q2re&apos;  			&amp;&amp; ( Campaign.Requires_Lead_Pre_Qualification__c = FALSE 			     || ( Campaign.Requires_Lead_Pre_Qualification__c = TRUE &amp;&amp; ISPICKVAL(Consultation_Type__c, &apos;Warm Transfer Fail&apos; ) ) )			   )   		)  	&amp;&amp; ISPICKVAL( Theater__c , &quot;North America&quot;)  	&amp;&amp; NOT(Contains(Partner_Account_Id__r.Name, &quot;SunPower&quot;))  	&amp;&amp; ISPICKVAL( Lead_Manufacturer__c, &quot;SunPower&quot;)  	&amp;&amp; CONTAINS(Primary_Contact_Email__c , &quot;@&quot;)  	&amp;&amp; RecordTypeId = &apos;0128000000037dm&apos;  	&amp;&amp; IsClosed = False  	&amp;&amp; CreatedDate &gt; HD_CreatedDatePlus2Min__c  	&amp;&amp; New_Residential_Opps_Notification__c = FALSE  	&amp;&amp; NOT(ISPICKVAL( Consultation_Type__c , &apos;Warm Transfer&apos;) ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Residential Opportunity - Partner notification NA Standard or No Campaign</fullName>
        <actions>
            <name>New_Residential_Opportunity_Partner_Follow_Up_Template</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>New Residential Opportunity - Partner notification NA Standard campaign record type or No Campaign</description>
        <formula>( Partner_Account_Id__r.RecordType.DeveloperName = &quot;Partner&quot; &amp;&amp; Partner_Account_Id__r.isSpectrumPartner__c = False &amp;&amp; !ISBLANK(Partner_Account_text__c) &amp;&amp; (ISBLANK(Primary_Campaign_Source_text__c) || Campaign.RecordTypeId = &apos;01280000000Q2re&apos;) &amp;&amp; ISPICKVAL( Theater__c , &quot;North America&quot;) &amp;&amp; NOT(Contains(Partner_Account_Id__r.Name, &quot;SunPower&quot;)) &amp;&amp; ISPICKVAL( Lead_Manufacturer__c, &quot;SunPower&quot;)&amp;&amp; RecordTypeId = &apos;0128000000037dm&apos; &amp;&amp; IsClosed = False &amp;&amp; CreatedDate &gt; HD_CreatedDatePlus2Min__c)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Residential Opportunity Created - SPD Campaign Specific</fullName>
        <actions>
            <name>New_SPD_Opportunity_Campaign_Specific</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>New Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Partner_Account_text__c</field>
            <operation>contains</operation>
            <value>SPD</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Primary_Contact_Email__c</field>
            <operation>contains</operation>
            <value>@</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Primary_Campaign_Source_text__c</field>
            <operation>contains</operation>
            <value>DPF - B Green Market Systems - Appt Setting</value>
        </criteriaItems>
        <description>New Residential Opportunity Created - SPD Campaign Specific</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Residential Opportunity Created%3A France TPO-Cash</fullName>
        <actions>
            <name>New_Residential_Opportunity_Created_France_TPO_Cash</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>New_Opportunity_Email_Notification_Sent_France_TPO_Cash</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 and 7 and 8</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Partner_Account_text__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Customer_Country__c</field>
            <operation>equals</operation>
            <value>France</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Theater__c</field>
            <operation>equals</operation>
            <value>Europe</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Primary_Contact_Email__c</field>
            <operation>contains</operation>
            <value>@</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Lead_Manufacturer__c</field>
            <operation>equals</operation>
            <value>SunPower</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Financing2__c</field>
            <operation>notEqual</operation>
            <value>Lease</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Partner_Account_text__c</field>
            <operation>notContain</operation>
            <value>SunPower</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Home Owner</value>
        </criteriaItems>
        <description>New Residential Opportunity Created: France TPO-Cash</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Residential Opportunity Created%3A France TPO-Lease</fullName>
        <actions>
            <name>New_Residential_Opportunity_Created_France_TPO_Lease</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>New_Opportunity_Email_Notification_Sent_France_TPO_Lease</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 and 7 and 8</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Partner_Account_text__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Customer_Country__c</field>
            <operation>equals</operation>
            <value>France</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Theater__c</field>
            <operation>equals</operation>
            <value>Europe</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Primary_Contact_Email__c</field>
            <operation>contains</operation>
            <value>@</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Lead_Manufacturer__c</field>
            <operation>equals</operation>
            <value>SunPower</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Financing2__c</field>
            <operation>equals</operation>
            <value>Lease</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Partner_Account_text__c</field>
            <operation>notContain</operation>
            <value>SunPower</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Home Owner</value>
        </criteriaItems>
        <description>New Residential Opportunity Created: France TPO-Lease</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Residential Opportunity Created%3A Partner Follow- up France TPO</fullName>
        <actions>
            <name>New_Residential_Opportunity_Created_Partner_Follow_Up_France_TPO</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>New_Opportunity_Created_Partner_Follow_Up_France_TPO</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Partner_Account_text__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Customer_Country__c</field>
            <operation>equals</operation>
            <value>France</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Theater__c</field>
            <operation>equals</operation>
            <value>Europe</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Lead_Manufacturer__c</field>
            <operation>equals</operation>
            <value>SunPower</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Home Owner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Partner_Account_text__c</field>
            <operation>notContain</operation>
            <value>SunPower</value>
        </criteriaItems>
        <description>New Residential Opportunity Created: Partner Follow- up France TPO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Residential Opportunity HO notification - NA Alliance Campaign record type</fullName>
        <actions>
            <name>New_Residential_Opportunity_Created_NA_Alliance</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>New_Residential_Opps_Notification</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>New Residential Opportunity HO notification- NA Alliance Campaign record type</description>
        <formula>(   Partner_Account_Id__r.RecordType.DeveloperName = &quot;Partner&quot;   &amp;&amp; Partner_Account_Id__r.isSpectrumPartner__c = False   &amp;&amp; !ISBLANK(Partner_Account_text__c)   &amp;&amp; Campaign.RecordTypeId = &apos;01280000000Q2rj&apos;  &amp;&amp; ISPICKVAL( Theater__c , &quot;North America&quot;)   &amp;&amp; NOT(Contains(Partner_Account_Id__r.Name, &quot;SunPower&quot;))   &amp;&amp; ISPICKVAL( Lead_Manufacturer__c, &quot;SunPower&quot;)   &amp;&amp; CONTAINS(Primary_Contact_Email__c , &quot;@&quot;)   &amp;&amp; RecordTypeId = &apos;0128000000037dm&apos;   &amp;&amp; IsClosed = False &amp;&amp; CreatedDate &gt; HD_CreatedDatePlus2Min__c   &amp;&amp; New_Residential_Opps_Notification__c = FALSE  &amp;&amp; NOT(ISPICKVAL( Consultation_Type__c , &apos;Warm Transfer&apos;) )  &amp;&amp; (  ( Campaign.Requires_Lead_Pre_Qualification__c = FALSE )   ||   ( Campaign.Requires_Lead_Pre_Qualification__c = TRUE      &amp;&amp; ISPICKVAL( Consultation_Type__c, &apos;Warm Transfer Fail&apos; ) )      ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Residential Opportunity Partner Follow-Up Email - NA Alliance</fullName>
        <actions>
            <name>New_Residential_Opportunity_Partner_Follow_Up_Template_NA_Alliance</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>New Residential Opportunity Partner Follow-Up Email - NA Alliance - Updated 2/10/2015 JT - Missed on Enhancement deployment 2/7/2015</description>
        <formula>(RecordTypeId = &apos;0128000000037dm&apos; &amp;&amp; ISPICKVAL( Theater__c , &quot;North America&quot;)  &amp;&amp;  ISPICKVAL( Lead_Manufacturer__c, &quot;SunPower&quot;) &amp;&amp;  Partner_Account_Id__r.RecordType.DeveloperName = &quot;Partner&quot; &amp;&amp;  NOT(Contains(Partner_Account_Id__r.Name, &quot;SunPower&quot; ))   &amp;&amp; Contains( Stage_Name_Duplicate__c , &quot;new&quot;) &amp;&amp; Partner_Account_Id__c !=PRIORVALUE(Partner_Account_Id__c) &amp;&amp; (Campaign.RecordTypeId = &apos;01280000000Q2rj&apos;))  &amp;&amp;   NOT(ISPICKVAL(Opportunity_Status__c, &quot;Closed Lost&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>New Residential Opportunity Partner Follow-Up Email - No Campaign</fullName>
        <actions>
            <name>New_Residential_Opportunity_Partner_Follow_Up_Template</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>New Residential Opportunity Partner Follow-Up Email - No Campaign</description>
        <formula>!ISNULL(Partner_Account_text__c)&amp;&amp;   OR(ISNULL(Primary_Campaign_Source_text__c), ISBLANK(Primary_Campaign_Source_text__c)) &amp;&amp; ISPICKVAL( Theater__c , &quot;North America&quot;)&amp;&amp; NOT(Contains(Partner_Account_Id__r.Name, &quot;SunPower&quot;))&amp;&amp; ISPICKVAL( Lead_Manufacturer__c, &quot;SunPower&quot;)&amp;&amp; RecordTypeId = &apos;0128000000037dm&apos;&amp;&amp; !ISPICKVAL(StageName,&quot;Closed Lost&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Residential Opportunity Partner notification - NA Alliance Campaign record type</fullName>
        <actions>
            <name>New_Residential_Opportunity_Partner_Follow_Up_Template_NA_Alliance</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>New Residential Opportunity Partner notification- NA Alliance Campaign record type</description>
        <formula>( Partner_Account_Id__r.RecordType.DeveloperName = &quot;Partner&quot; &amp;&amp; !ISBLANK(Partner_Account_text__c) &amp;&amp; (Campaign.RecordTypeId = &apos;01280000000Q2rj&apos;) &amp;&amp; ISPICKVAL( Theater__c , &quot;North America&quot;) &amp;&amp; NOT(Contains(Partner_Account_Id__r.Name, &quot;SunPower&quot;)) &amp;&amp; ISPICKVAL( Lead_Manufacturer__c, &quot;SunPower&quot;) &amp;&amp; RecordTypeId = &apos;0128000000037dm&apos; &amp;&amp; IsClosed = False &amp;&amp; CreatedDate &gt; HD_CreatedDatePlus2Min__c)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Residential Spectrum Opportunity Created - NA</fullName>
        <actions>
            <name>New_Residential_Opportunity_Created_NA_Standard</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>New_Residential_Opportunity_Spectrum_Partner_Follow_Up_Template</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>New_Residential_Opps_Notification</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>New Residential Spectrum Opportunity Created - NA</description>
        <formula>( Partner_Account_Id__r.RecordType.DeveloperName = &quot;Partner&quot; &amp;&amp; Partner_Account_Id__r.isSpectrumPartner__c = True &amp;&amp; !ISBLANK(Partner_Account_text__c) &amp;&amp; ISPICKVAL( Theater__c , &quot;North America&quot;) &amp;&amp; NOT(Contains(Partner_Account_Id__r.Name, &quot;SunPower&quot;)) &amp;&amp; ISPICKVAL( Lead_Manufacturer__c, &quot;SunPower&quot;) &amp;&amp; CONTAINS(Primary_Contact_Email__c , &quot;@&quot;) &amp;&amp; RecordTypeId = &apos;0128000000037dm&apos; &amp;&amp; IsClosed = False  &amp;&amp; CreatedDate &gt; HD_CreatedDatePlus2Min__c  &amp;&amp; New_Residential_Opps_Notification__c = FALSE )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New SPD Opportunity</fullName>
        <actions>
            <name>New_SSE_Opportunity</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Partner_Account_text__c</field>
            <operation>contains</operation>
            <value>SunPower</value>
        </criteriaItems>
        <description>New SPD Opportunity</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>No PPF%28Pre-Purchase Form Received%29</fullName>
        <active>false</active>
        <formula>( ISPICKVAL( Theater__c , &apos;Central America and the Caribbean&apos;)  ||  ISPICKVAL( Theater__c , &apos;North America&apos;) ) &amp;&amp; ISBLANK(  Site_Audit_Form_Received__c )  &amp;&amp;  $RecordType.Name == &apos;Commercial&apos; &amp;&amp; NOT(ISNULL(Partner_Account_Id__c ))  &amp;&amp;  (NOT(CONTAINS( Stage_Name_Duplicate__c , &apos;Lost&apos;)    &amp;&amp;   NOT(CONTAINS( Stage_Name_Duplicate__c , &apos;Future&apos;) &amp;&amp; NOT(CONTAINS( Stage_Name_Duplicate__c , &apos;Won&apos;)))))</formula>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>No_PPF_Notification_30_Days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.CreatedDate</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <offsetFromField>Opportunity.CreatedDate</offsetFromField>
            <timeLength>37</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Notification to partner 3 months after opportunity is labelled %22Not ready to buy - follow-up in 3 months</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Reason_Won_Lost__c</field>
            <operation>equals</operation>
            <value>Not ready to buy follow up in 3 months</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Notification to partner 3 months after opportunity is labelled &quot;Not ready to buy - follow-up in 3 months</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Follow_up_with_OPPORTUNITY</name>
                <type>Alert</type>
            </actions>
            <timeLength>90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Number of days to the Close date</fullName>
        <actions>
            <name>Update_Number_of_Days_to_close_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CreatedById</field>
            <operation>equals</operation>
            <value>DMAdmin</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>O%26M Only Deal Alert - NAC</fullName>
        <actions>
            <name>O_M_Only_Deal_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>NA Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Contract_Type__c</field>
            <operation>equals</operation>
            <value>O&amp;M</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>O&amp;M Only Deal Alert - NAC</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>O%26M Only Deal Alert - UPPa</fullName>
        <actions>
            <name>O_M_Only_Deal_Alert_UPP_Americas</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>UPP Americas</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Contract_Type__c</field>
            <operation>equals</operation>
            <value>O&amp;M</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>O&amp;M Only Deal Alert - UPPa</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>O%26M Only Deal Alert - UPPi</fullName>
        <actions>
            <name>O_M_Only_Deal_Alert_UPP_Intl</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>UPP Intl</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Contract_Type__c</field>
            <operation>equals</operation>
            <value>O&amp;M</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>O&amp;M Only Deal Alert - UPPi</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Open project in e-Builder %E2%80%93 NAC and UPP</fullName>
        <actions>
            <name>Stage_Negotiate_Contract_NAC</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 AND 2 AND 3 AND 4 AND 5)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>NA Commercial,UPP Americas</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Approved_to_Send_PSR__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Components</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Contract_Type__c</field>
            <operation>notEqual</operation>
            <value>O&amp;M,PV Only</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Open project in e-Builder – NAC and UPP</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity ALR Manual Review Workflow</fullName>
        <actions>
            <name>OPPORTUNITY_ALR_Manual_Review_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>AND   (  ISCHANGED(Dealer_Assignment_Status__c),   OR(   ISPICKVAL(Dealer_Assignment_Status__c,&apos;Failed Assignment - Invalid Geolocation&apos;), ISPICKVAL(Dealer_Assignment_Status__c,&apos;Failed Assignment&apos;), ISPICKVAL(Dealer_Assignment_Status__c,&apos;Failed Assignment - No Dealers Found&apos;), ISPICKVAL(Dealer_Assignment_Status__c,&apos;&apos;)  ),  OR  (  ISPICKVAL(Theater__c,&apos;Central America and the Caribbean&apos;), ISPICKVAL(Theater__c,&apos;North America&apos;)  ),  ISPICKVAL(Lead_Manufacturer__c,&apos;SunPower&apos;), Converted_Lead_Record_Type__c = &apos;Residential&apos;, NOT(CONTAINS(&apos;test:Tester:Testing:Test:TEST:tester:testing&apos;, Name ) )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Alert For Record Type Home Owner Status Qualified</fullName>
        <actions>
            <name>Opportunity_Alert_For_Record_Type_Home_Owner_Status_Qualified</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Theater__c</field>
            <operation>equals</operation>
            <value>North America</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Home Owner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_Status__c</field>
            <operation>equals</operation>
            <value>Qualified,Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Address_URL__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Opportunity Alert For Record Type Home Owner Status Qualified</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Close Date</fullName>
        <actions>
            <name>Overriding_the_default_close_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Converted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.LeadSource</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Systems</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CreatedById</field>
            <operation>notEqual</operation>
            <value>DMAdmin</value>
        </criteriaItems>
        <description>Override the default close date from the close of the quarter to six months from when an opportunity record is created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Close Date Past Due - NAC</fullName>
        <actions>
            <name>Email_when_an_Opportunity_Close_Date_is_past_due_NAC</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 3 AND 4)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>NA Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CloseDate</field>
            <operation>lessThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>notEqual</operation>
            <value>06 – Closed Won,07 – Closed Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Opportunity Close Date is Past Due for NAC.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Close Date Past Due - UPPa</fullName>
        <actions>
            <name>Email_when_an_Opportunity_Close_Date_is_past_due_UPP_Americas</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 3 AND 4 and 5)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>UPP Americas</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CloseDate</field>
            <operation>lessThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>notEqual</operation>
            <value>06 – Closed Won,07 – Closed Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Owner_ID__c</field>
            <operation>notEqual</operation>
            <value>00580000005FjM2</value>
        </criteriaItems>
        <description>Opportunity Close Date is Past Due for UPPa.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Close Date Past Due - UPPi</fullName>
        <actions>
            <name>Email_when_an_Opportunity_Close_Date_is_past_due_UPP_Intl</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 3 AND 4)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>UPP Intl,Commercial Intl</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CloseDate</field>
            <operation>lessThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>notEqual</operation>
            <value>06 – Closed Won,07 – Closed Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Opportunity Close Date is Past Due for UPPi.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Close Date is Past Due for UPPi Asia</fullName>
        <actions>
            <name>Email_when_an_Opportunity_Close_Date_is_past_due_IBD</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 3 AND 4)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>UPP Intl</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CloseDate</field>
            <operation>lessThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>notEqual</operation>
            <value>06 – Closed Won,07 – Closed Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Opportunity Close Date is Past Due for UPPi Asia</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Closed %2FWon Notification</fullName>
        <actions>
            <name>Close_Lost_Stage_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>06 – Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Owner_ID__c</field>
            <operation>notEqual</operation>
            <value>00580000005FjM2</value>
        </criteriaItems>
        <description>Opportunity Closed /Won Notification</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Edited by Hiroshi Amano or Arun Kumar</fullName>
        <actions>
            <name>Opportunity_Edited_by_Hiroshi_Amano_or_Arun_Kumar</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Opportunity.LastModifiedById</field>
            <operation>equals</operation>
            <value>Hiroshi Amano</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.LastModifiedById</field>
            <operation>equals</operation>
            <value>Arun Kumar</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Opportunity Edited by Hiroshi Amano or Arun Kumar</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Has been in 90%25 for 3 Days</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>06 – Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Probability</field>
            <operation>equals</operation>
            <value>90</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Opportunity Has been in 90% for 3 Days</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Opportunity_Has_been_in_90_for_3_Days</name>
                <type>Alert</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity Manually Reassigned To New Dealer Alert To Customer%2FPartner</fullName>
        <actions>
            <name>Dealer_Reassigned_Email_To_Customer</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>New_Residential_Opportunity_Partner_Follow_Up_Template</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow sends email alert to customer when an Opportunity previously rejected by Dealer is manually assigned to New Dealer</description>
        <formula>Manually_Reassigned__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Modified by Arun Kumar%2C Yashwant Jain%2C Pradeep Sangwan</fullName>
        <actions>
            <name>Opportunity_Modified_by_Arun_Kumar_Yashwant_Jain_Pradeep_Sangwan</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>Opportunity.LastModifiedById</field>
            <operation>equals</operation>
            <value>Arun Kumar</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.LastModifiedById</field>
            <operation>equals</operation>
            <value>Yashwant Jain</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.LastModifiedById</field>
            <operation>equals</operation>
            <value>Pradeep Sangwan</value>
        </criteriaItems>
        <description>Opportunity Modified by Arun Kumar, Yashwant Jain, Pradeep Sangwan</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Reassignment Alert CS</fullName>
        <actions>
            <name>Opportunity_Lost_Reassignment_Email_Alert_CS</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2) AND (3 OR 4 OR 5) AND 6</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Opportunity Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Home Owner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Reason_Won_Lost__c</field>
            <operation>equals</operation>
            <value>Unsuitable structure/roof</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Reason_Won_Lost__c</field>
            <operation>equals</operation>
            <value>Outside of coverage area</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Reason_Won_Lost__c</field>
            <operation>equals</operation>
            <value>Outside of business scope</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Lead_Manufacturer__c</field>
            <operation>equals</operation>
            <value>SunPower</value>
        </criteriaItems>
        <description>Case#484462</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Status Qualified when 12%25</fullName>
        <actions>
            <name>Opportunity_Status_Qualified_when_12</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 Or 2 or 4 or 5) and 3</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>12% - Qualified Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Probability</field>
            <operation>equals</operation>
            <value>0.12</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Probability_Text__c</field>
            <operation>equals</operation>
            <value>12</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Stage_Name_Duplicate__c</field>
            <operation>contains</operation>
            <value>12</value>
        </criteriaItems>
        <description>Opportunity Status Qualified when 12%</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Status Update when 25%25 or 50%25 or 75%25</fullName>
        <actions>
            <name>Opportunity_Status_Update_when_20_or_35</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 and 2) or (1 and 3) or (1 and 4)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>RLC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Probability</field>
            <operation>equals</operation>
            <value>0.25</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Probability</field>
            <operation>equals</operation>
            <value>0.50</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Probability</field>
            <operation>equals</operation>
            <value>0.75</value>
        </criteriaItems>
        <description>Opportunity Status Update when 25% or 50% or 75%</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Status Update when 90%25</fullName>
        <actions>
            <name>Update_Opportunity_Stage_Close_Won</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 and (2 or 3 or 4 or 5)) or (2 and 6)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>RLC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Probability</field>
            <operation>equals</operation>
            <value>0.90</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Probability</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.ForecastCategoryName</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>contains</operation>
            <value>90,100</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Commercial</value>
        </criteriaItems>
        <description>Opportunity Status Update when 90%</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity stage - Installation Completed_WF</fullName>
        <actions>
            <name>Email_Alert_if_opportunity_stage_is_Installation_Completed</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>$RecordType.Name = &apos;Home Owner&apos; &amp;&amp; (ISPICKVAL(Theater__c, &apos;Central America and the Caribbean&apos;) || ISPICKVAL(Theater__c, &apos;North America&apos;)) &amp;&amp; ISPICKVAL(StageName, &apos;Installation Completed&apos;)  &amp;&amp; NOT($User.ByPassValidation__c)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opps%3A Record Type for Commercial</fullName>
        <actions>
            <name>Opps_Set_Record_Type_to_Commercial</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Converted_Lead_Record_Type__c</field>
            <operation>equals</operation>
            <value>Systems</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RLC_Type__c</field>
            <operation>equals</operation>
            <value>Light Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Theater__c</field>
            <operation>notEqual</operation>
            <value>Australia</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Opps%3A Record Type for Components</fullName>
        <actions>
            <name>Opps_Set_Record_Type_to_Components</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Converted_Lead_Record_Type__c</field>
            <operation>equals</operation>
            <value>New Homes,Residential,Systems</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>UPP Intl,Commercial Intl</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Opps%3A Record Type for Home Owner</fullName>
        <actions>
            <name>Opps_Set_Record_Type_to_Home_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Converted_Lead_Record_Type__c</field>
            <operation>equals</operation>
            <value>Residential</value>
        </criteriaItems>
        <description>Opps: Record Type for Home Owner</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Opps%3A Record Type for Systems</fullName>
        <actions>
            <name>Opps_Set_Record_Type_to_Systems</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2) or (3) or (4 and 5)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Converted_Lead_Record_Type__c</field>
            <operation>equals</operation>
            <value>New Homes,Partner,Residential</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>NA Commercial,UPP Americas</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RLC_Type__c</field>
            <operation>equals</operation>
            <value>EU Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Converted_Lead_Record_Type__c</field>
            <operation>equals</operation>
            <value>Systems</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>NA Commercial</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Opps%3A Record Type for Systems UPPa</fullName>
        <actions>
            <name>Opps_Set_Record_Type_to_Systems_UPPAmer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 and 5) or (3 AND 4 and 5) or (5 and 6)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Converted_Lead_Record_Type__c</field>
            <operation>equals</operation>
            <value>Systems</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>UPP Americas</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Converted_Lead_Record_Type__c</field>
            <operation>equals</operation>
            <value>New Homes,Residential,Systems</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>UPP Intl,Commercial Intl</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Contract_Type__c</field>
            <operation>equals</operation>
            <value>Development</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>UPP Americas,NA Commercial,UPP Intl,Commercial Intl</value>
        </criteriaItems>
        <description>Opps: Record Type for Systems UPPa</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Oracle Order Creation Task Assignment</fullName>
        <actions>
            <name>Workflow_process_that_triggers_an_email_notification_being_sent_to_the_Manila_Te</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>06 – Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Components</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CreatedById</field>
            <operation>notEqual</operation>
            <value>DMAdmin</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Oracle_Order_Number__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Workflow process that triggers an email notification being sent to the Manila Team Member on the Sales Team to Create an Oracle Number</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PPF Receipt Acknowledgement</fullName>
        <actions>
            <name>PPF_Acknowledgement</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>worflow to trigger email notification when PPF date is populated For
Theater = North America &amp; Central America and the Caribbean
Opportunity Record Type = Commercial
Business Unit = RLC
Partner Account Status = Active
Partner Account Type = Partner</description>
        <formula>AND(NOT(ISBLANK( Quote_Submit_SLA__c)), ISBLANK(PRIORVALUE(Site_Audit_Form_Received__c)),  AND(NOT(ISBLANK(Site_Audit_Form_Received__c)), AND( Probability  = 0.25, AND(RecordType.DeveloperName=&quot;Commercial&quot;,AND( ISPICKVAL(Business_Unit__c,&quot;RLC&quot;), AND(ISPICKVAL(Partner_Account_Id__r.Status__c ,&quot;Active&quot;), AND (OR(ISPICKVAL(Theater__c,&quot;North America&quot;),ISPICKVAL(Theater__c,&quot;Central America and the Caribbean&quot;)), AND (OR(ISPICKVAL(Partner_Account_Id__r.Type,&quot;Partner-Commercial&quot;),ISPICKVAL(Partner_Account_Id__r.Type,&quot;Authorized-Partner-Combo&quot;),ISPICKVAL(Partner_Account_Id__r.Type,&quot;Premier-Partner-Combo&quot;),ISPICKVAL(Partner_Account_Id__r.Type,&quot;Elite-Partner-Combo&quot;))))))))))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PROJECT STAGE - Dead Lost</fullName>
        <actions>
            <name>Opportunity_Status_Closed_Lost</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PROJECT_STAGE_Dead_Lost</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 3) or (1 AND 3) or(4 AND 5)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>&quot;0% - Dead, Lost&quot;</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RLC_Type__c</field>
            <operation>equals</operation>
            <value>Light Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Home Owner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Opportunity Lost</value>
        </criteriaItems>
        <description>PROJECT STAGE - Dead Lost</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PV Cost Pricing - Updated</fullName>
        <actions>
            <name>PV_Cost_Pricing_Updated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.PV_Cost_Forecast__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>PV Cost Pricing - Updated</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Partner Intro Email %28Check%29</fullName>
        <actions>
            <name>Partner_Intro_Email_Check</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Partner_Intro_Email_Sent__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Pre-Purchase Form Received Date</fullName>
        <actions>
            <name>CPP_MoveTo20</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Probability_25</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Opportunity_Status_to_Active</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 3 AND 4) or 5 or 6</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Site_Audit_Form_Received__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Theater__c</field>
            <operation>equals</operation>
            <value>Central America and the Caribbean,North America</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RLC_Type__c</field>
            <operation>equals</operation>
            <value>Light Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>notEqual</operation>
            <value>&quot;0% - Dead, Lost&quot;,75% - Imminent PO / Agreements Finalized,50% - Quote / Proposal Submitted,90% - PO Received / Contracts Signed,100% - Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Stage_Name_Duplicate__c</field>
            <operation>contains</operation>
            <value>25</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>25% - Design Initiated</value>
        </criteriaItems>
        <description>Pre-Purchase Form Received Date</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Pre-Purchase Review Form Reminder</fullName>
        <actions>
            <name>Pre_Purchase_Review_Form_Reminder</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Opportunity.RLC_Type__c</field>
            <operation>equals</operation>
            <value>Light Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Theater__c</field>
            <operation>equals</operation>
            <value>North America</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Site_Audit_Form_Received__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Owner_Email__c</field>
            <operation>notContain</operation>
            <value>sunpowercorp.com</value>
        </criteriaItems>
        <description>Pre-Purchase Review Form Reminder</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PrependOppNumberToName</fullName>
        <actions>
            <name>PrependNumberToName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND ((2 AND 3) OR 4 or 5)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Home Owner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>notEqual</operation>
            <value>RLC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Theater__c</field>
            <operation>notEqual</operation>
            <value>Central America and the Caribbean,North America</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Theater__c</field>
            <operation>equals</operation>
            <value>Australia</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>UPP Intl,NA Commercial,UPP Americas</value>
        </criteriaItems>
        <description>This will concatenate Opportunity Number and Opportunity Name into Opportunity Name field.
Updated for Case #00171812</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Price Concession Changed After Approved - RLC NA</fullName>
        <actions>
            <name>Price_Concession_Changed_After_Approved</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Price Concession Changed After Approved - RLC NA</description>
        <formula>ISPICKVAL(Pricing_Exception_Status__c, &apos;Approved&apos;) &amp;&amp; ( ISCHANGED(   Price_Concession__c ) &amp;&amp; ISPICKVAL(Theater__c, &apos;North America&apos;)) &amp;&amp; NOT( $User.ByPassValidation__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Price Concession Update</fullName>
        <actions>
            <name>Price_Concession_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Diff_Sales_and_List_Price_Total__c</field>
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
        <fullName>RLC NA Partner Creates Opportunity</fullName>
        <actions>
            <name>RLC_NA_Creates_Opportunity_Default_BU</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>RLC_NA_Creates_Opportunity_Default_RLC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Theater__c</field>
            <operation>equals</operation>
            <value>North America</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>startsWith</operation>
            <value>Partner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Commercial</value>
        </criteriaItems>
        <description>RLC NA Partner Creates Opportunity(Deactivated because this has been moved to trigger)</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RSM Notified When Pricing Exception Approved - RLC</fullName>
        <actions>
            <name>CVAR_Pricing_Exception_Approved_Alert_NA_RSM</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Pricing_Exception_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Theater__c</field>
            <operation>equals</operation>
            <value>North America</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RLC_Type__c</field>
            <operation>equals</operation>
            <value>Residential</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>RSM Notified When Pricing Exception Approved - RLC</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Regional Commitment Update - Closed</fullName>
        <actions>
            <name>Regional_Commitment_Update_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>NA Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Probability_Text__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <description>Regional Commitment Update - Closed</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SSE - Installer Introduction</fullName>
        <actions>
            <name>SSE_Installer_Introduction</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>SSE_Installer_Notification_Sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <description>SSE - Installer Introduction</description>
        <formula>(RecordTypeId = &apos;0128000000037dm&apos; &amp;&amp; ISPICKVAL( Theater__c , &quot;North America&quot;) &amp;&amp; Partner_Account_Id__r.Name = &quot;SunPower Direct (SPD)&quot; &amp;&amp; NOT(ISBLANK( Installer__c )  &amp;&amp; NOT(ISNULL( Installer_Contact__c ))))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Salesperson Commitment - Closed - NAC</fullName>
        <actions>
            <name>Salesperson_Commitment_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Probability</field>
            <operation>equals</operation>
            <value>100</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>NA Commercial</value>
        </criteriaItems>
        <description>Salesperson Commitment - Closed - NAC</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Appointment Notification Emails on Update</fullName>
        <actions>
            <name>OppAppointmnetEmailFlow</name>
            <type>FlowAction</type>
        </actions>
        <active>true</active>
        <description>SPD: Send Appointment Notification Emails on Update-Workflow to fire flow trigger sending either an onsite or online appointment notification to an opportunity&apos;s primary contact after update only</description>
        <formula>AND( NOT( ISNEW() ), ISPICKVAL( Lead_Manufacturer__c , &apos;SunPower&apos;), NOT ( Campaign.Name = &apos;SunPower VIP Executive Pass&apos; ),  NOT( ISBLANK( Appointment_Date__c ) ), NOT( ISBLANK( TEXT( Appointment_Time__c ) ) ), OR ( ISCHANGED( Appointment_Date__c ), ISCHANGED( Appointment_Time__c ), ISCHANGED( Consultation_Type__c ) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Appt%2FIntro Email For New Home Campaign</fullName>
        <actions>
            <name>New_Homes_Lead_Appt_Confirmation</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>New_Residential_Opps_Notification</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Customer_Consultation</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>New Homes Lease Project: Workflow to fire flow trigger sending onsite appointment notification to an opportunity&apos;s primary contact and partner account foNew Home  campaign opportunities</description>
        <formula>AND(       NOT( ISBLANK( Appointment_Date__c ) ),   NOT( ISBLANK( TEXT(Appointment_Time__c) ) ),    NOT(ISPICKVAL( Consultation_Type__c , &apos;&apos;) ),   Partner_Account_text__c  = &apos;SunPower New Homes&apos;,   NOT( ISBLANK( Partner_Account_text__c) ),   NOT( Campaign.Name = &apos;SunPower VIP Executive Pass&apos; ),   Campaign.Requires_Lead_Pre_Qualification__c = TRUE,   NOT(ISBLANK( Campaign.NH_Community__c )),    CONTAINS(Primary_Contact_Email__c , &quot;@&quot;),   New_Residential_Opps_Notification__c != TRUE )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Appt%2FIntro Email For Pre-Qual Campaign</fullName>
        <actions>
            <name>Send_Partner_Intro_Appointment_Email_for_Pre_Qualified_Campaign_Opps</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>New_Residential_Opps_Notification</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Customer_Consultation</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>Workflow to fire flow trigger sending onsite appointment notification to an opportunity&apos;s primary contact and partner account for pre-qualified campaign opportunities</description>
        <formula>AND(       NOT( ISBLANK( Appointment_Date__c ) ),   NOT( ISBLANK( TEXT(Appointment_Time__c) ) ),    NOT(ISPICKVAL( Consultation_Type__c , &apos;&apos;) ),   Partner_Account_text__c  != &apos;SunPower Direct (SPD)&apos;,   NOT( ISBLANK( Partner_Account_text__c) ),   NOT( Campaign.Name = &apos;SunPower VIP Executive Pass&apos; ),   Campaign.Requires_Lead_Pre_Qualification__c = TRUE,   ISBLANK( Campaign.NH_Community__c ),    CONTAINS(Primary_Contact_Email__c , &quot;@&quot;),   New_Residential_Opps_Notification__c != TRUE, NOT(ISPICKVAL( Consultation_Type__c , &apos;Warm Transfer&apos;) ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Email Alert - Mt%2E Diablo Campaign On Closed Opportunity</fullName>
        <actions>
            <name>Mt_Diablo_Lead_Gen_Campaign_On_Closed_Opportunity</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Primary_Campaign_Source_text__c</field>
            <operation>equals</operation>
            <value>Mt. Diablo Lead Gen Campaign</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Probability</field>
            <operation>equals</operation>
            <value>100</value>
        </criteriaItems>
        <description>Send Email Alert - Mt. Diablo Campaign On Closed Opportunity</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Financing Alert</fullName>
        <actions>
            <name>Financing_Team_Alert_Financing_Application</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_alert_false</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Send_Financing_Alert__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Case#00105838</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Online Appointment Notification Emails on Creation</fullName>
        <actions>
            <name>Online_Appointment_notification_email_alert_to_contact_and_Res_Opp_Recipient</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>New_Residential_Opps_Notification</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Customer_Consultation</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>Workflow to fire flow trigger sending an online appointment notification to an opportunity&apos;s primary contact</description>
        <formula>AND( New_Residential_Opps_Notification__c != True,    DATEVALUE(CreatedDate) = TODAY(),  CONTAINS( Primary_Contact__r.Email, &apos;@&apos;),      ISPICKVAL(Lead_Manufacturer__c , &apos;SunPower&apos;),                        NOT( ISBLANK( Appointment_Date__c ) ),     NOT( ISBLANK( TEXT(Appointment_Time__c) ) ),       Partner_Account_text__c  = &apos;SunPower Direct (SPD)&apos;,        NOT ( Campaign.Name = &apos;SunPower VIP Executive Pass&apos;),  AND(ISPICKVAL( Consultation_Type__c , &apos;Online&apos;),        NOT( ISBLANK(  Meeting_Link__c ))))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>EC_Owner_Email_Update_Delete</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Opportunity.HD_CreatedDatePlus2Min__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Send Online Appointment Reminder Notification Email</fullName>
        <active>false</active>
        <description>Workflow to fire flow trigger sending either an online appointment reminderto an opportunity&apos;s primary contact and energy consultant for SunPower New Homes 24 hours prior appointment schedule case# 00774747</description>
        <formula>AND(  CONTAINS( Primary_Contact__r.Email, &apos;@&apos;),  ISPICKVAL(Lead_Manufacturer__c , &apos;SunPower&apos;),  NOT( ISBLANK( Appointment_Date__c ) ),  NOT( ISBLANK( TEXT(Appointment_Time__c) ) ),  Partner_Account_text__c = &apos;SunPower New Homes&apos;,  NOT ( Campaign.Name = &apos;SunPower VIP Executive Pass&apos;),  AND(ISPICKVAL( Consultation_Type__c , &apos;Online&apos;), NOT( ISBLANK( Meeting_Link__c ))),  (Appointment_Date__c &gt;= TODAY() + 2)  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>EC_Owner_Email_Update_Delete</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Opportunity.HD_CreatedDatePlus2Min__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Online_Appointment_notification_email_alert_for_opportunity_SPD_Reminder</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Appointment_Date__c</offsetFromField>
            <timeLength>-24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Send Online Appointment Reminder Notification Emails</fullName>
        <active>true</active>
        <description>Workflow to fire flow trigger sending either an online appointment reminderto an opportunity&apos;s primary contact and energy consultant for SunPower New Homes 8 hours prior appointment schedule. #142554873</description>
        <formula>AND(  CONTAINS( Primary_Contact__r.Email, &apos;@&apos;),  ISPICKVAL(Lead_Manufacturer__c , &apos;SunPower&apos;),  NOT( ISBLANK( Appointment_Date__c ) ),  NOT( ISBLANK( TEXT(Appointment_Time__c) ) ),  Partner_Account_text__c = &apos;SunPower New Homes&apos;,  NOT ( Campaign.Name = &apos;SunPower VIP Executive Pass&apos;),  AND(ISPICKVAL( Consultation_Type__c , &apos;Online&apos;), NOT( ISBLANK( Meeting_Link__c ))),  (Appointment_Date__c &gt;= TODAY() + 2)  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Online_Appointment_notification_email_alert_for_opportunity_SPD_Reminder</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Appointment_Date_Time__c</offsetFromField>
            <timeLength>-8</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>EC_Owner_Email_Update_Delete</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Opportunity.HD_CreatedDatePlus2Min__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Send Onsite Appointment Notification Emails on Creation</fullName>
        <actions>
            <name>Site_Appointment_notification_email_alert_to_contact_and_opp_owner</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>New_Residential_Opps_Notification</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Customer_Consultation</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>Workflow to fire flow trigger sending either an onsite appointment notification to an opportunity&apos;s primary contact and energy consultant for SPD</description>
        <formula>AND(     New_Residential_Opps_Notification__c != True,   DATEVALUE(CreatedDate) = TODAY(),  CONTAINS( Primary_Contact__r.Email, &apos;@&apos;),   ISPICKVAL(Lead_Manufacturer__c , &apos;SunPower&apos;), NOT( ISBLANK( Appointment_Date__c ) ),   NOT( ISBLANK( TEXT(Appointment_Time__c) ) ),   ISPICKVAL( Consultation_Type__c , &apos;In-Person&apos;),  Partner_Account_text__c = &apos;SunPower Direct (SPD)&apos;,  NOT ( Campaign.Name = &apos;SunPower VIP Executive Pass&apos; ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>EC_Owner_Email_Update_Delete</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Opportunity.HD_CreatedDatePlus2Min__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Solaire Record Type</fullName>
        <actions>
            <name>Solaire_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Converted_Lead_Record_Type__c</field>
            <operation>equals</operation>
            <value>Systems</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Vertical__c</field>
            <operation>equals</operation>
            <value>Solaire</value>
        </criteriaItems>
        <description>Set record type of Solaire Opportunity based on Vertical value from leads</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Spectrum Integration NRT</fullName>
        <actions>
            <name>Informatica_Spectrum_Integration</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.SyncWithSpectrum__c</field>
            <operation>equals</operation>
            <value>New,Update,Reassign,Failed</value>
        </criteriaItems>
        <description>This workflow will call Spectrum API to push Opportunity updates to Spectrum.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Stage Update for Appointment Confirmed</fullName>
        <actions>
            <name>UD_Opp_Status_to_Appointment_Confirm</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Stage to Appointment Confirmed when created from SPD Lead Conversion process</description>
        <formula>AND(     NOT( ISBLANK( Appointment_Date__c ) ) ,    NOT( ISPICKVAL( Appointment_Time__c, &apos;&apos;) ),    NOT( ISPICKVAL( Consultation_Type__c, &apos;&apos;) ),    NOT( ISBLANK( Dealer_Selection__c ) ),    OR (       Campaign.Requires_Lead_Pre_Qualification__c  = TRUE,       Partner_Account_text__c = &apos;SunPower Direct (SPD)&apos;    ) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Stage Updated to Verbal Commitment</fullName>
        <actions>
            <name>Update_Closed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Verbal Commitment</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Partner_Account_text__c</field>
            <operation>equals</operation>
            <value>SunPower New Homes</value>
        </criteriaItems>
        <description>Workflow rule to check if Opportunity Stage  equals Verbal Commitment and Account Name equals SunPower New Homes</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>System is Producing Energy Cash - %28SPD%29</fullName>
        <actions>
            <name>System_is_Producing_Energy_Cash_SPD</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Sent_Energy_Producing_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Partner_Account_text__c</field>
            <operation>contains</operation>
            <value>SPD</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Installation Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Sent_Energy_Producing_Email__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Contract_Type__c</field>
            <operation>equals</operation>
            <value>SPD – Cash (w/loan),SPD – Cash Only</value>
        </criteriaItems>
        <description>System is Producing Energy (Cash) - (SPD)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Systems Stage Update On Creation</fullName>
        <actions>
            <name>Systems_Stage_Update_On_Creation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Components,Systems</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>notEqual</operation>
            <value>01 - Build Single Sales Objective,02 - Finalize SSO,03 - Firm Offer,04 - Negotiate Binding Contract,06 – Closed Won,07 – Closed Lost,05 – Agreements Finalized</value>
        </criteriaItems>
        <description>Systems Stage Update On Creation</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TPO Update Account Lease</fullName>
        <actions>
            <name>Account_Lease_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Lease_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Financing2__c</field>
            <operation>equals</operation>
            <value>Lease</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.BillingCountry</field>
            <operation>equals</operation>
            <value>France</value>
        </criteriaItems>
        <description>Update Account Lease field when Lead Conversion Financing type is Lease</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Close Won Date</fullName>
        <actions>
            <name>Close_Won_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.IsWon</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set closed won date if status is become closed won</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Closed %28Text%29 Field For Opportunity</fullName>
        <actions>
            <name>Update_Closed_Field_For_Opportunity</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Update Closed (Text) Field For Opportunity</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Field Res Opp Recipient CC Email</fullName>
        <actions>
            <name>Primary_Res_Opp_Recip_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Field_Res_Opp_Recipient_CC_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Field Res Opp Recipient CC Email from the Partner Account</description>
        <formula>Partner_Account_Id__c != PRIORVALUE(Partner_Account_Id__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Financing Comments</fullName>
        <actions>
            <name>Update_Financing_Comments</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Financing2__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Financing__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Opportunity Contacted Date-Time</fullName>
        <actions>
            <name>Opportunity_Contacted_Date_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Contacted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_Contacted_Date_Time__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Contacted - Not Reached</value>
        </criteriaItems>
        <description>update the opportunity contacted date &amp; time field when stage change to contacted</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Opportunity Description</fullName>
        <actions>
            <name>Update_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Lead_Qualification_Notes__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Updates the Opportunity &quot;Description&quot; with the value of Account&apos;s &quot;Lead Qualification Notes&quot;</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Opportunity Status on Installation Completed Stage</fullName>
        <actions>
            <name>Update_Opportunity_Status_to_Closed_Won</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Installation Completed</value>
        </criteriaItems>
        <description>Update Opportunity Status when Stage is set to &quot;Installation Completed&quot;.
(Deactivating the worflow as this has been moved to before trigger so that workflow field update does not fire the trigger again)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Opportunity Status to Closed Won - Home Owner Record Type</fullName>
        <actions>
            <name>Update_Opportunity_Status_to_Closed_Won</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Contract Signed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Home Owner</value>
        </criteriaItems>
        <description>Update Opportunity Status to Closed Won - Home Owner Record Type</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update PSR - Opportunity</fullName>
        <actions>
            <name>PSR_Update_Opportunity</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.PSR_Email_text__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update PSR - Opportunity</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Project Stage - Future Follow-Up</fullName>
        <actions>
            <name>Update_Project_Stage_Dead_Lost</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 AND 2) or (1)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Future Follow-up</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Commercial</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update RLC Opportunity Stage Reflects 10%25 Instead of 12%25</fullName>
        <actions>
            <name>Opportunity_Stage_Changed_from_10_to_12</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>RLC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>New Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Commercial</value>
        </criteriaItems>
        <description>Update RLC Opportunity Stage Reflects 10% Instead of 12%</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Send Financing Alert</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Financing_Application_Submitted_date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update Send Financing Alert</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Stage to Future Follow-Up RLC NA</fullName>
        <actions>
            <name>Update_Opportunity_Status_to_On_Hold</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Probability_to_10</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Stage_to_Future_Follow_Up_RLC_NA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 10 and (3 or 7 or 9) AND (4 Or 5 Or 6 or 8 or 11)) or (2 and 7)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Theater__c</field>
            <operation>equals</operation>
            <value>Central America and the Caribbean,North America</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Project_Stage__c</field>
            <operation>equals</operation>
            <value>Future Follow-up</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Stage_Name_Duplicate__c</field>
            <operation>notContain</operation>
            <value>dead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Stage_Name_Duplicate__c</field>
            <operation>notContain</operation>
            <value>Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Stage_Name_Duplicate__c</field>
            <operation>notContain</operation>
            <value>Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Future Follow-up</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Stage_Name_Duplicate__c</field>
            <operation>notContain</operation>
            <value>Delivered</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.ForecastCategoryName</field>
            <operation>equals</operation>
            <value>Omitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Probability</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Probability</field>
            <operation>equals</operation>
            <value>.10</value>
        </criteriaItems>
        <description>Update Stage to Future Follow-Up RLC NA</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Stage to New Opportunity</fullName>
        <actions>
            <name>Update_Stage_to_New_Opportunity</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Home Owner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>01 - Build Single Sales Objective,02 - Finalize SSO,03 - Firm Offer,04 - Negotiate Binding Contract</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update to 12%25</fullName>
        <actions>
            <name>Update_to_12</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 AND 2 AND 3) or 1</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>contains</operation>
            <value>12</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Project_Stage__c</field>
            <operation>notEqual</operation>
            <value>Future Follow-up</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Project_Stage__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update to 12%</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Warm Transfer Intro And Status Update</fullName>
        <actions>
            <name>Warm_Transfer_Intro_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>New_Residential_Opps_Notification</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Warm_Transfer_Opp_Stage_to_Contacted</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>WF to send intro email for Warm Transfer leads to partners, also updates opportunity stage to contacted</description>
        <formula>AND(     New_Residential_Opps_Notification__c != True,     DATEVALUE( CreatedDate ) = TODAY(),     ISPICKVAL( Lead_Manufacturer__c , &apos;SunPower&apos; ),     Primary_Contact__r.LastName != null,      Partner_Account_text__c != &apos;SunPower Direct (SPD)&apos;,     NOT( Campaign.Name = &apos;SunPower VIP Executive Pass&apos; ),     ISPICKVAL( Consultation_Type__c , &apos;Warm Transfer&apos;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Warranty Card Acknowledgement Email</fullName>
        <actions>
            <name>Warranty_Card_Acknowledgement_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Home Owner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Theater__c</field>
            <operation>equals</operation>
            <value>Central America and the Caribbean,North America,South America</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Primary_Contact_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Warranty_Card_Received__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Warranty Card Acknowledgement Email</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Welcome Email for Cash %28SPD%29</fullName>
        <actions>
            <name>Welcome_Email_for_Cash_SPD</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Sent_Welcome_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Welcome_Email_for_Cash_SPD</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <description>Welcome Email for Cash (SPD)</description>
        <formula>AND(ISPICKVAL( Theater__c , &quot;North America&quot;),  CONTAINS( Partner_Account_text__c , &apos;SPD&apos;) , Sent_Welcome_Email__c = False, NOT(ISBLANK( Installer__c ))  ,  NOT(ISBLANK( Installer_Contact__c )), Contains( SPWR_Deal_Type_text__c ,&quot;Cash Only&quot;)  , ISPICKVAL( StageName , &quot;Contract Signed&quot;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Welcome Email for Lease %28SPD%29</fullName>
        <actions>
            <name>Sent_Welcome_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Welcome_Email_Sent_SPD</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <description>Welcome Email for Lease (SPD)</description>
        <formula>AND(ISPICKVAL( StageName , &quot;Contract Signed&quot;), ISPICKVAL( Theater__c , &quot;North America&quot;) , CONTAINS( Partner_Account_text__c , &apos;SPD&apos;) , Sent_Welcome_Email__c = False , NOT(ISBLANK( Installer__c )  ), NOT(ISBLANK( Installer_Contact__c )), (Contains( SPWR_Deal_Type_text__c , &quot;Lease&quot;)  || Contains( SPWR_Deal_Type_text__c ,&quot;Cash (w/loan)&quot;)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Book_Opportunity</fullName>
        <assignedTo>diane.galiza@cloudsherpas.com.spwr</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Please review the Opportunity Roles and materials attached to the Opportunity to confirm completion, then update the Probability to 100% and Close Date to the accurate day.</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.CloseDate</offsetFromField>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Book Opportunity</subject>
    </tasks>
    <tasks>
        <fullName>Customer_Consultation</fullName>
        <assignedToType>owner</assignedToType>
        <description>An appointment has been confirmed for this opportunity and you will be receiving an email copy shortly.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.Appointment_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Customer Consultation</subject>
    </tasks>
    <tasks>
        <fullName>Customer_ConsultationOL</fullName>
        <assignedToType>owner</assignedToType>
        <description>An appointment has been confirmed for this opportunity and you will be receiving an email copy shortly.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.Appointment_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Customer Consultation</subject>
    </tasks>
    <tasks>
        <fullName>New_Opportunity_Created_Partner_Follow_Up_France_TPO</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>New Opportunity Created: Partner Follow-Up France TPO</subject>
    </tasks>
    <tasks>
        <fullName>New_Opportunity_Email_Notification_Sent_France_TPO_Cash</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>New Opportunity Email Notification Sent: France TPO-Cash</subject>
    </tasks>
    <tasks>
        <fullName>New_Opportunity_Email_Notification_Sent_France_TPO_Lease</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>New Opportunity Email Notification Sent: France TPO-Lease</subject>
    </tasks>
    <tasks>
        <fullName>Please_compile_Booking_and_Hand_Off_Documents_for_this_Opportunity_s_contract_ty</fullName>
        <assignedTo>Sales Analyst</assignedTo>
        <assignedToType>opportunityTeam</assignedToType>
        <description>SLA/PPA: PPA | SLA | Budget | PPA Model | Other
EPC: Budget | EPC | Other
EPC w/ PPA: PPA | SLA | Budget | EPC
O&amp;M: Budget | EPC | O&amp;M Agree.
Design/PCW: Budget | Pre-Contract Work (PCW)
Component/PV Only: PO / Purch. Agree.</description>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Please compile Booking and Hand Off Documents  for this Opportunity’s contract type</subject>
    </tasks>
    <tasks>
        <fullName>SSE_Installer_Notification_Sent</fullName>
        <assignedTo>christopher.fox@sunpowercorp.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>SSE - Installer Notification Sent</subject>
    </tasks>
    <tasks>
        <fullName>Site_Audit_Required</fullName>
        <assignedTo>Application Engineer</assignedTo>
        <assignedToType>opportunityTeam</assignedToType>
        <description>Please Conduct a Site Audit on the location related to this Opportunity</description>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Site Audit Required</subject>
    </tasks>
    <tasks>
        <fullName>Welcome_Email_Sent_SPD</fullName>
        <assignedTo>devon.westerholm@sunpowercorp.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>The Welcome Email has been sent to the Lessee Contact and Partner Account: Vendor Email (SPD)</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Welcome Email Sent (SPD)</subject>
    </tasks>
    <tasks>
        <fullName>Welcome_Email_for_Cash_SPD</fullName>
        <assignedTo>devon.westerholm@sunpowercorp.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Welcome Email for Cash (SPD)</subject>
    </tasks>
</Workflow>
