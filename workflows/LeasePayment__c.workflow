<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Financial_Payment_Status_Changed_to_Transferred</fullName>
        <ccEmails>booking@sunpower.com</ccEmails>
        <description>Financial Payment Status Changed to Transferred</description>
        <protected>false</protected>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Workflow_Email_Alerts/Lease_Status_Changed_Transferred</template>
    </alerts>
    <alerts>
        <fullName>Install_Invoice_Approved_Email</fullName>
        <ccEmails>leasepaymentinquiry@sunpowercorp.com;salesforcearchives@sunpowercorp.com</ccEmails>
        <description>Install Invoice Approved Email</description>
        <protected>false</protected>
        <recipients>
            <field>Invoice_Document_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Install_Invoice_Approved</template>
    </alerts>
    <alerts>
        <fullName>Interconnect_Invoice_Approved_Email</fullName>
        <ccEmails>leasepaymentinquiry@sunpowercorp.com</ccEmails>
        <description>Interconnect Invoice Approved Email</description>
        <protected>false</protected>
        <recipients>
            <field>Invoice_Document_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Interconnect_Invoice_Approved</template>
    </alerts>
    <alerts>
        <fullName>Lease_Status_Changed</fullName>
        <ccEmails>leasepaymentinquiry@sunpowercorp.com</ccEmails>
        <ccEmails>leasecontrolspsr@sunpowercorp.com</ccEmails>
        <description>Lease Status Changed -Cancelled/Terminated</description>
        <protected>false</protected>
        <recipients>
            <field>PSR_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>dongiordane.soguilon@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lavernne.ferraro@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>reiniel.marasigan@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Lease_Status_Cancelled</template>
    </alerts>
    <alerts>
        <fullName>Lease_Status_Pending_Cancellation</fullName>
        <ccEmails>leasepaymentinquiry@sunpowercorp.com</ccEmails>
        <ccEmails>leasecontrolspsr@sunpowercorp.com</ccEmails>
        <description>Lease Status Changed - Pending Cancellation/Termination</description>
        <protected>false</protected>
        <recipients>
            <field>PSR_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>dongiordane.soguilon@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lavernne.ferraro@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>reiniel.marasigan@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lease/Lease_Status_Pending_Cancellation</template>
    </alerts>
    <alerts>
        <fullName>Notice_To_Proceed</fullName>
        <ccEmails>financing@sunpowercorp.com</ccEmails>
        <ccEmails>ntp@sunpower.com</ccEmails>
        <description>Notice To Proceed</description>
        <protected>false</protected>
        <recipients>
            <field>Dealer_Lease_Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>ntp@sunpower.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Lease/Notice_to_Proceed_Sent</template>
    </alerts>
    <alerts>
        <fullName>Origination_Invoice_Approved_Email</fullName>
        <ccEmails>leasepaymentinquiry@sunpowercorp.com;salesforcearchives@sunpowercorp.com</ccEmails>
        <description>Origination Invoice Approved Email</description>
        <protected>false</protected>
        <recipients>
            <field>Invoice_Document_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Origination_Invoice_Approval_Email</template>
    </alerts>
    <alerts>
        <fullName>Palced_in_Service_Updated</fullName>
        <description>Placed in Service Updated</description>
        <protected>false</protected>
        <recipients>
            <recipient>hermilyn.japitana@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jerome.fortunado@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>odessacarla.oyog@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>shanonabe.deguzman@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lease/Placed_in_Service_Date_has_been_Updated</template>
    </alerts>
    <alerts>
        <fullName>Pending_Interconnection_Email_Lease_SPD</fullName>
        <ccEmails>sse.psr@sunpower.com;;SPD_PC@sunpowercorp.com</ccEmails>
        <description>Pending Interconnection Email Lease - (SPD)</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Primary_Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sunpowerdirect@sunpower.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Quote/Lease_Pending_Connection_Email</template>
    </alerts>
    <alerts>
        <fullName>Send_Cancellation_Email_To_PSR</fullName>
        <description>Send Cancellation Email To PSR</description>
        <protected>false</protected>
        <recipients>
            <field>PSR_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Project_Management_Templates/Send_Cancellation_Email_To_PSR</template>
    </alerts>
    <alerts>
        <fullName>Send_Interconnection_Email</fullName>
        <description>Send Interconnection Email</description>
        <protected>false</protected>
        <recipients>
            <field>Lessee_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Partner_Oracle_Vendor_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>crmadmin@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Quote/Your_System_Is_On_NA</template>
    </alerts>
    <alerts>
        <fullName>Send_Pending_Interconnection_Email</fullName>
        <description>Send Pending Interconnection Email</description>
        <protected>false</protected>
        <recipients>
            <field>Lessee_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Partner_Oracle_Vendor_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>crmadmin@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Quote/SunPower_Installation_Update_Pending</template>
    </alerts>
    <alerts>
        <fullName>Send_Pending_Interconnections_Email</fullName>
        <description>Send Pending Interconnection Email</description>
        <protected>false</protected>
        <recipients>
            <field>Lessee_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Partner_Oracle_Vendor_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>crmadmin@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Quote/Pending_InterConnection_NA</template>
    </alerts>
    <alerts>
        <fullName>System_is_Producing_Energy_Lease_SPD</fullName>
        <ccEmails>sse.psr@sunpower.com;SPD_PC@sunpowercorp.com</ccEmails>
        <description>System is Producing Energy Lease (SPD)</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Primary_Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sunpowerdirect@sunpower.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Quote/Lease_System_On_Email</template>
    </alerts>
    <fieldUpdates>
        <fullName>Declaration_Approved_Field_Update</fullName>
        <field>Declaration_Prealable_Approved__c</field>
        <formula>TODAY()</formula>
        <name>Declaration Approved Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Default_Guarantee_Start_Date</fullName>
        <field>Guarantee_Start_Date__c</field>
        <formula>if( isblank(Energy_Start_Date__c), 
Placed_In_Service__c +1, 
IF(Placed_In_Service__c &gt;=Energy_Start_Date__c , 
Placed_In_Service__c +1 , 
Energy_Start_Date__c +1) 
)</formula>
        <name>Default Guarantee Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FMV_State_Update_AZ_Not_SPWR</fullName>
        <description>FMV State Update - AZ (Not SPWR)</description>
        <field>FMV_by_State__c</field>
        <formula>4.90</formula>
        <name>FMV State Update - AZ (Not SPWR)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FMV_State_Update_CA</fullName>
        <description>FMV State Update - CA 7.94</description>
        <field>FMV_by_State__c</field>
        <formula>7.94</formula>
        <name>FMV State Update - CA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FMV_State_Update_CA_Not_SPWR</fullName>
        <description>FMV State Update - CA (Not SPWR)</description>
        <field>FMV_by_State__c</field>
        <formula>5.57</formula>
        <name>FMV State Update - CA (Not SPWR)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FMV_State_Update_CO_Not_SPWR</fullName>
        <description>FMV State Update - CO (Not SPWR)</description>
        <field>FMV_by_State__c</field>
        <formula>4.94</formula>
        <name>FMV State Update - CO (Not SPWR)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FMV_State_Update_CT</fullName>
        <description>FMV State Update - CT</description>
        <field>FMV_by_State__c</field>
        <formula>6.47</formula>
        <name>FMV State Update - CT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FMV_State_Update_CT_Not_SPWR</fullName>
        <description>FMV State Update - CT (Not SPWR)</description>
        <field>FMV_by_State__c</field>
        <formula>6.47</formula>
        <name>FMV State Update - CT (Not SPWR)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FMV_State_Update_HI</fullName>
        <description>FMV State Update - HI</description>
        <field>FMV_by_State__c</field>
        <formula>7.71</formula>
        <name>FMV State Update - HI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FMV_State_Update_HI_Not_SPWR</fullName>
        <description>FMV State Update - HI (Not SPWR)</description>
        <field>FMV_by_State__c</field>
        <formula>6.46</formula>
        <name>FMV State Update - HI (Not SPWR)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FMV_State_Update_MA_Not_SPWR</fullName>
        <description>FMV State Update - MA (Not SPWR)</description>
        <field>FMV_by_State__c</field>
        <formula>5.45</formula>
        <name>FMV State Update - MA (Not SPWR)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FMV_State_Update_NJ_AZ_CO_NY_MA</fullName>
        <description>FMV State Update - NJ, AZ, CO, NY, MA</description>
        <field>FMV_by_State__c</field>
        <formula>7.53</formula>
        <name>FMV State Update - NJ, AZ, CO, NY, MA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FMV_State_Update_NJ_Not_SPWR</fullName>
        <description>FMV State Update - NJ (Not SPWR)</description>
        <field>FMV_by_State__c</field>
        <formula>4.91</formula>
        <name>FMV State Update - NJ (Not SPWR)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FMV_State_Update_NY_Not_SPWR</fullName>
        <description>FMV State Update - NY (Not SPWR)</description>
        <field>FMV_by_State__c</field>
        <formula>5.05</formula>
        <name>FMV State Update - NY (Not SPWR)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FMV_State_Update_PA</fullName>
        <description>FMV State Update - PA</description>
        <field>FMV_by_State__c</field>
        <formula>7.85</formula>
        <name>FMV State Update - PA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FMV_State_Update_PA_Not_SPWR</fullName>
        <description>FMV State Update - PA (Not SPWR)</description>
        <field>FMV_by_State__c</field>
        <formula>5.08</formula>
        <name>FMV State Update - PA (Not SPWR)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FMV_State_Update_SPWR_Financier</fullName>
        <description>FMV State Update - SPWR Financier</description>
        <field>FMV_by_State__c</field>
        <formula>0</formula>
        <name>FMV State Update - SPWR Financier</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FMV_State_Update_VT</fullName>
        <description>FMV State Update - VT</description>
        <field>FMV_by_State__c</field>
        <formula>6.75</formula>
        <name>FMV State Update - VT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FMV_State_Update_VT_Not_SPWR</fullName>
        <description>FMV State Update - VT (Not SPWR)</description>
        <field>FMV_by_State__c</field>
        <formula>4.46</formula>
        <name>FMV State Update - VT (Not SPWR)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financier_Change_Date</fullName>
        <field>Financier_Change_Date__c</field>
        <formula>Today ()</formula>
        <name>Financier Change Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inactive_Lease_Payment_Layout_Assignment</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Inactive_RecordType</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Inactive Lease Payment Layout Assignment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Install_Invoice_Email_input</fullName>
        <field>Invoice_Document_Email__c</field>
        <formula>Partner_Account__r.Invoice_Document_Email__c</formula>
        <name>Install Invoice Email input</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Notice_to_Proceed_Email_Sent</fullName>
        <field>Notice_to_Proceed_Email_Sent__c</field>
        <literalValue>1</literalValue>
        <name>Notice to Proceed Email Sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PIS_Entry_Date_Update</fullName>
        <description>Case# 00233523</description>
        <field>PIS_Entry_Date__c</field>
        <formula>TODAY()</formula>
        <name>PIS Entry Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PSR_Email_Update</fullName>
        <description>PSR Email Update</description>
        <field>PSR_Email__c</field>
        <formula>PSR_Email_Formula__c</formula>
        <name>PSR Email Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Placed_In_Service_Checked</fullName>
        <description>Placed In Service Checked</description>
        <field>Place_In_Service_Entered__c</field>
        <literalValue>1</literalValue>
        <name>Placed In Service Checked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Install_Inv_Apprvd_TEXT</fullName>
        <field>Install_Inv_Apprvd_TEXT__c</field>
        <formula>TEXT(Install_Inv_Apprvd__c)</formula>
        <name>Populate Install Inv Apprvd TEXT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Notice_to_Proceed_Sent_TEXT</fullName>
        <field>Notice_to_Proceed_Sent_TEXT__c</field>
        <formula>TEXT(Notice_to_Proceed_Sent__c)</formula>
        <name>Populate Notice to Proceed Sent TEXT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SPVT_Result_Pass_Date</fullName>
        <description>Case# 00521116 Updates the SPVT Result Pass date to the date when the SPVT Result is Pass.</description>
        <field>SPVT_Result_Pass_Date__c</field>
        <formula>TODAY()</formula>
        <name>SPVT Result Pass Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sent_Energy_Producing_Email</fullName>
        <description>Sent Energy Producing Email</description>
        <field>Sent_Interconnection_Email__c</field>
        <literalValue>1</literalValue>
        <name>Sent Energy Producing Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sent_Interconnection_Email</fullName>
        <field>Interconnection_Email_Sent__c</field>
        <literalValue>1</literalValue>
        <name>Sent Interconnection Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sent_Pending_Interconnection_Email</fullName>
        <field>Pending_Interconnection_Email_Sent__c</field>
        <literalValue>1</literalValue>
        <name>Sent Pending Interconnection Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Termination_Date</fullName>
        <field>Termination_Date__c</field>
        <formula>TODAY()</formula>
        <name>Termination Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tranching_Status_Closed</fullName>
        <description>Tranching Status - Closed</description>
        <field>Tranching_Status__c</field>
        <literalValue>Closed</literalValue>
        <name>Tranching Status - Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tranching_Status_Presented</fullName>
        <description>Tranching Status - Presented</description>
        <field>Tranching_Status__c</field>
        <literalValue>Presented</literalValue>
        <name>Tranching Status - Presented</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tranching_Status_Received_Payment</fullName>
        <description>Tranching Status - Received Payment</description>
        <field>Tranching_Status__c</field>
        <literalValue>Received Payment</literalValue>
        <name>Tranching Status - Received Payment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tranching_Status_Requested_for_Closing</fullName>
        <description>Tranching Status - Requested for Closing</description>
        <field>Tranching_Status__c</field>
        <literalValue>Requested for Closing</literalValue>
        <name>Tranching Status - Requested for Closing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tranching_Status_Requested_for_Payment</fullName>
        <description>Tranching Status - Requested for Payment</description>
        <field>Tranching_Status__c</field>
        <literalValue>Requested for Payment</literalValue>
        <name>Tranching Status - Requested for Payment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_FMV</fullName>
        <field>Fair_Market_Value_acctg__c</field>
        <formula>Fair_Market_Value__c</formula>
        <name>Update FMV</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_ITC_Cash_Grant_Valuation</fullName>
        <description>to populate the static value of ITC Cash Grant Valuation leases once PIS date is entered moving forward if financier =SPWR-ITC
Lease cost * 1.05= cash grant valuation * 30%</description>
        <field>ITC_Cash_Grant_Valuation_acctg__c</field>
        <formula>(Lease_Cost__c * 1.05) * 0.30</formula>
        <name>Update ITC/Cash Grant Valuation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lease_Dup</fullName>
        <description>Update Lease # Dup</description>
        <field>Lease_Dup__c</field>
        <formula>Lease__c</formula>
        <name>Update Lease # Dup</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Uncond_Fin_LW_Approved</fullName>
        <field>Uncond_Fin_LW_Approved__c</field>
        <formula>Uncond_Fin_LW_Rcvd__c</formula>
        <name>Update Uncond Fin LW Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Wattage_Extract_From_Module_250</fullName>
        <field>Wattage__c</field>
        <formula>250</formula>
        <name>Wattage Extract From Module - 250</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Wattage_Extract_From_Module_335</fullName>
        <field>Wattage__c</field>
        <formula>335</formula>
        <name>Wattage Extract From Module - 335</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Wattage_Extract_From_Module_345</fullName>
        <field>Wattage__c</field>
        <formula>345</formula>
        <name>Wattage Extract From Module - 345</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Wattage_Update_225</fullName>
        <description>Wattage Update - 225</description>
        <field>Wattage__c</field>
        <formula>225</formula>
        <name>Wattage Update - 225</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Wattage_Update_228</fullName>
        <description>Wattage Update - 228</description>
        <field>Wattage__c</field>
        <formula>228</formula>
        <name>Wattage Update - 228</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Wattage_Update_230</fullName>
        <description>Wattage Update - 230</description>
        <field>Wattage__c</field>
        <formula>230</formula>
        <name>Wattage Update - 230</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Wattage_Update_235</fullName>
        <description>Wattage Update - 235</description>
        <field>Wattage__c</field>
        <formula>235</formula>
        <name>Wattage Update - 235</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Wattage_Update_238</fullName>
        <description>Wattage Update - 238</description>
        <field>Wattage__c</field>
        <formula>238</formula>
        <name>Wattage Update - 238</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Wattage_Update_240</fullName>
        <description>Wattage Update - 240</description>
        <field>Wattage__c</field>
        <formula>240</formula>
        <name>Wattage Update - 240</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Wattage_Update_245</fullName>
        <description>Wattage Update - 245</description>
        <field>Wattage__c</field>
        <formula>245</formula>
        <name>Wattage Update - 245</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Wattage_Update_308</fullName>
        <description>Wattage Update - 308</description>
        <field>Wattage__c</field>
        <formula>308</formula>
        <name>Wattage Update - 308</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Wattage_Update_318</fullName>
        <description>Wattage Update - 318</description>
        <field>Wattage__c</field>
        <formula>318</formula>
        <name>Wattage Update - 318</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Wattage_Update_320</fullName>
        <description>Wattage Update - 320</description>
        <field>Wattage__c</field>
        <formula>320</formula>
        <name>Wattage Update - 320</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Wattage_Update_327</fullName>
        <description>Wattage Update - 327</description>
        <field>Wattage__c</field>
        <formula>327</formula>
        <name>Wattage Update - 327</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Watts_Update</fullName>
        <field>Wattage__c</field>
        <formula>Watts__c</formula>
        <name>Watts Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Send_Submit_for_Final_Review_Signal_to_I</fullName>
        <apiVersion>39.0</apiVersion>
        <description>Send Submit for Final Review Outbound Message to Informatica</description>
        <endpointUrl>https://ps1w2-obm.rt.informaticacloud.com/active-bpel/services/REST/SalesforceNotificationRESTPort?processName=InvokeSubmitForFinalReview</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>sysuser@sunpower.com</integrationUser>
        <name>Send Submit for Final Review Signal to I</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Auto Update SPVT Result Pass Date</fullName>
        <actions>
            <name>SPVT_Result_Pass_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Case# 00521116. This field update is to update the SPVT Result pass date when SPVT Result is pass.
Case# 00581887 the SPVT Result Pass Date will change the value to Today&apos;s date if the SPVT Result field changed the value and = Pass</description>
        <formula>AND( 
ISCHANGED( SPVT_Result__c), 
ISPICKVAL( SPVT_Result__c,&quot;Pass&quot;) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Declaration Approved Workflow</fullName>
        <actions>
            <name>Declaration_Approved_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LeasePayment__c.Declaration_Prealable_Status__c</field>
            <operation>equals</operation>
            <value>Complete</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Default Guarantee Start Date</fullName>
        <actions>
            <name>Default_Guarantee_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Default Guarantee Start Date to PIS if Guarantee Start Date is null</description>
        <formula>ISCHANGED(Placed_In_Service__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FMV Default to %240 - SPWR Financier</fullName>
        <actions>
            <name>FMV_State_Update_SPWR_Financier</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LeasePayment__c.Funding_Tranche__c</field>
            <operation>equals</operation>
            <value>SPWR – Non US Treasury,SPWR</value>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Payment_Received__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>FMV Default to $0 - SPWR Financier</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FMV State Update - AZ</fullName>
        <actions>
            <name>FMV_State_Update_AZ_Not_SPWR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LeasePayment__c.Site_State_Prov__c</field>
            <operation>equals</operation>
            <value>AZ,Arizona</value>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Funding_Tranche__c</field>
            <operation>notEqual</operation>
            <value>SPWR – Non US Treasury,SPWR</value>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Payment_Received__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>FMV State Update - AZ</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FMV State Update - CA</fullName>
        <actions>
            <name>FMV_State_Update_CA_Not_SPWR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LeasePayment__c.Site_State_Prov__c</field>
            <operation>equals</operation>
            <value>CA,Califonia</value>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Funding_Tranche__c</field>
            <operation>notEqual</operation>
            <value>SPWR – Non US Treasury,SPWR</value>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Payment_Received__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>FMV State Update - CA</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FMV State Update - CO</fullName>
        <actions>
            <name>FMV_State_Update_CO_Not_SPWR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LeasePayment__c.Site_State_Prov__c</field>
            <operation>equals</operation>
            <value>CO,Colorado</value>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Funding_Tranche__c</field>
            <operation>notEqual</operation>
            <value>SPWR – Non US Treasury,SPWR</value>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Payment_Received__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>FMV State Update - CO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FMV State Update - CT</fullName>
        <actions>
            <name>FMV_State_Update_CT_Not_SPWR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LeasePayment__c.Site_State_Prov__c</field>
            <operation>equals</operation>
            <value>CT,Connecticut</value>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Funding_Tranche__c</field>
            <operation>notEqual</operation>
            <value>SPWR – Non US Treasury,SPWR</value>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Payment_Received__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>FMV State Update - CT</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FMV State Update - HI</fullName>
        <actions>
            <name>FMV_State_Update_HI_Not_SPWR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LeasePayment__c.Site_State_Prov__c</field>
            <operation>equals</operation>
            <value>HI,Hawaii</value>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Funding_Tranche__c</field>
            <operation>notEqual</operation>
            <value>SPWR – Non US Treasury,SPWR</value>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Payment_Received__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>FMV State Update - HI</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FMV State Update - MA</fullName>
        <actions>
            <name>FMV_State_Update_MA_Not_SPWR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LeasePayment__c.Site_State_Prov__c</field>
            <operation>equals</operation>
            <value>MA,Massachusetts</value>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Funding_Tranche__c</field>
            <operation>notEqual</operation>
            <value>SPWR – Non US Treasury,SPWR</value>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Payment_Received__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>FMV State Update - MA</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FMV State Update - NJ</fullName>
        <actions>
            <name>FMV_State_Update_NJ_Not_SPWR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LeasePayment__c.Site_State_Prov__c</field>
            <operation>equals</operation>
            <value>NJ,New Jersey</value>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Funding_Tranche__c</field>
            <operation>notEqual</operation>
            <value>SPWR – Non US Treasury,SPWR</value>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Payment_Received__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>FMV State Update - NJ</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FMV State Update - NY</fullName>
        <actions>
            <name>FMV_State_Update_NY_Not_SPWR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LeasePayment__c.Site_State_Prov__c</field>
            <operation>equals</operation>
            <value>NY,New York</value>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Funding_Tranche__c</field>
            <operation>notEqual</operation>
            <value>SPWR – Non US Treasury,SPWR</value>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Payment_Received__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>FMV State Update - NY</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FMV State Update - PA</fullName>
        <actions>
            <name>FMV_State_Update_PA_Not_SPWR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LeasePayment__c.Site_State_Prov__c</field>
            <operation>equals</operation>
            <value>PA,Pennsylvania</value>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Funding_Tranche__c</field>
            <operation>notEqual</operation>
            <value>SPWR – Non US Treasury,SPWR</value>
        </criteriaItems>
        <description>FMV State Update - PA</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FMV State Update - VT</fullName>
        <actions>
            <name>FMV_State_Update_VT_Not_SPWR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LeasePayment__c.Site_State_Prov__c</field>
            <operation>equals</operation>
            <value>VT,Vermont</value>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Funding_Tranche__c</field>
            <operation>notEqual</operation>
            <value>SPWR – Non US Treasury,SPWR</value>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Payment_Received__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>FMV State Update - VT</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FMV Update</fullName>
        <actions>
            <name>Update_FMV</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LeasePayment__c.Fair_Market_Value_acctg__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Placed_In_Service__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This workflow rule updates the field &quot;Fair Market Value (acctg)&quot; with the value form the formula field Fair Market value - only when the former field is blank. The reson for seemingly duplicate fields is to preserve legacy data.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Financier Is Changed</fullName>
        <actions>
            <name>Financier_Change_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Financier Is Changed</description>
        <formula>ISCHANGED( Funding_Tranche__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Install Invoice Approval Email</fullName>
        <actions>
            <name>Install_Invoice_Approved_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Install_Invoice_Email_input</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LeasePayment__c.Install_Pymnt_Apprvd__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>TPS</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Interconnect Invoice Approval Email</fullName>
        <actions>
            <name>Interconnect_Invoice_Approved_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Install_Invoice_Email_input</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LeasePayment__c.Intrcnct_Pymnt_Apprvd__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.SPVT_Result__c</field>
            <operation>equals</operation>
            <value>Pass</value>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>TPS</value>
        </criteriaItems>
        <description>SPVT Result pass is added as per case# 00475421.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Interconnection Email</fullName>
        <actions>
            <name>Send_Interconnection_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Sent_Interconnection_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Interconnection_Email_Sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>Case#00206232</description>
        <formula>AND ( NOT( Interconnection_Email_Sent__c), NOT(( ISPICKVAL(Partner_Account__r.Lease_Status_Email_Opt_Out__c, &apos;Yes&apos;))) , NOT(ISNULL(Placed_In_Service__c )), NOT(Contains(Quote__r.Opportunity.Partner_Account_text__c, &quot;SunPower&quot;) ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Invalidate Lease Payment</fullName>
        <actions>
            <name>Inactive_Lease_Payment_Layout_Assignment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LeasePayment__c.Status__c</field>
            <operation>equals</operation>
            <value>Duplicate,Expired,Terminated</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lease Status Changed - Cancelled%2FTerminated</fullName>
        <actions>
            <name>Lease_Status_Changed</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Termination_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>LeasePayment__c.Status__c</field>
            <operation>equals</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Status__c</field>
            <operation>equals</operation>
            <value>Terminated</value>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Status__c</field>
            <operation>equals</operation>
            <value>Cancellation with RMA</value>
        </criteriaItems>
        <description>Lease Status Changed - Cancelled</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lease Status Changed - Pending Cancellation%2FTermination</fullName>
        <actions>
            <name>Lease_Status_Pending_Cancellation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LeasePayment__c.Status__c</field>
            <operation>equals</operation>
            <value>Pending Termination,Pending Cancellation</value>
        </criteriaItems>
        <description>Lease Status Changed - Pending Cancellation/Termination</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lease Status Changed - Transferred</fullName>
        <actions>
            <name>Financial_Payment_Status_Changed_to_Transferred</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LeasePayment__c.Status__c</field>
            <operation>equals</operation>
            <value>Transferred</value>
        </criteriaItems>
        <description>Lease Status Changed - Transferred</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notice to Proceed Sent</fullName>
        <actions>
            <name>Notice_To_Proceed</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Notice_to_Proceed_Email_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LeasePayment__c.Notice_to_Proceed_Sent__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Dealer_Lease_Contact_Email__c</field>
            <operation>contains</operation>
            <value>@</value>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Notice_to_Proceed_Email_Sent__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Notice to Proceed Sent</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Origination Invoice Approval Email</fullName>
        <actions>
            <name>Origination_Invoice_Approved_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Install_Invoice_Email_input</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LeasePayment__c.Origination_Payment_Approved__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Partner_Proposal_Design_Review_Passed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>TPS</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PIS Entry Date</fullName>
        <actions>
            <name>PIS_Entry_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT(ISBLANK(Placed_In_Service__c)),  ISCHANGED( Placed_In_Service__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PSR Email Update</fullName>
        <actions>
            <name>PSR_Email_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>LeasePayment__c.PSR_Email_Formula__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.PSR_Email_Formula__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>PSR Email Update</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Pending Interconnection Email</fullName>
        <actions>
            <name>Send_Pending_Interconnections_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Sent_Pending_Interconnection_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Pending_Interconnections_Email_Sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>Case# 00204926</description>
        <formula>AND( NOT(Pending_Interconnection_Email_Sent__c), NOT( Interconnection_Email_Sent__c), NOT(ISBLANK(Notice_to_Proceed_Sent__c)), AND(NOT(ISNULL( Partner_Account__c)), NOT(Contains(Quote__r.Opportunity.Partner_Account_text__c, &quot;SunPower&quot;) ), NOT(ISBLANK( Payment_Date_Installation__c )), 
NOT (ISPICKVAL(Partner_Account__r.Lease_Status_Email_Opt_Out__c, &apos;Yes&apos;))) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Pending Interconnection Email Lease - %28SPD%29</fullName>
        <actions>
            <name>Pending_Interconnection_Email_Lease_SPD</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Pending_Interconnection_Email_Lease_SPD</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LeasePayment__c.Notice_to_Proceed_Sent__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Dealer_Name__c</field>
            <operation>contains</operation>
            <value>SPD</value>
        </criteriaItems>
        <description>Pending Interconnection Email Lease - (SPD)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Pending Interconnection Email for LeaseV2</fullName>
        <actions>
            <name>Send_Pending_Interconnection_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Pending_Interconnection_Email_Sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <formula>AND(NOT( ISNULL(Notice_to_Proceed_Sent__c)),NOT(ISNULL(Install_Inv_Apprvd__c)),
 NOT( ISPICKVAL(Partner_Account__r.Lease_Status_Email_Opt_Out__c, &apos;Yes&apos;)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Placed In Service Checked</fullName>
        <actions>
            <name>Placed_In_Service_Checked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LeasePayment__c.Placed_In_Service__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Placed In Service Checked</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Placed in Service Updated</fullName>
        <actions>
            <name>Palced_in_Service_Updated</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Placed in Service Updated</description>
        <formula>(ISCHANGED( Placed_In_Service__c) &amp;&amp; NOT(ISBLANK(PRIORVALUE(Placed_In_Service__c))))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Date Fields TEXT Value</fullName>
        <actions>
            <name>Populate_Install_Inv_Apprvd_TEXT</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Populate_Notice_to_Proceed_Sent_TEXT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LeasePayment__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>As Date Fields are nor supported in PRIORVALUE in Formulas, that Created the Workflow to retain the PRIORVALUE for Date Field
&quot;Populate Notice to Proceed Sent&quot;
&quot;Populate Install Inv Apprvd&quot;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Cancellation Email To PSR</fullName>
        <actions>
            <name>Send_Cancellation_Email_To_PSR</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LeasePayment__c.Oracle_Cancellation_Status__c</field>
            <operation>equals</operation>
            <value>Error</value>
        </criteriaItems>
        <description>Email is being sent to PSR whenever there is Error is oracle callout for Cancellation.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Submit for Final Review Signal to Informatica</fullName>
        <actions>
            <name>Send_Submit_for_Final_Review_Signal_to_I</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LeasePayment__c.Mosaic_Status__c</field>
            <operation>equals</operation>
            <value>Submit for Final Review</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>System is Producing Energy Lease - %28SPD%29</fullName>
        <actions>
            <name>System_is_Producing_Energy_Lease_SPD</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Sent_Energy_Producing_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LeasePayment__c.Energy_Start_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Sent_Energy_Producing_Email__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Dealer_Name__c</field>
            <operation>contains</operation>
            <value>SPD</value>
        </criteriaItems>
        <description>System is Producing Energy Lease - (SPD)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tranching Status Update - Closed</fullName>
        <actions>
            <name>Tranching_Status_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND (3 or 4)</booleanFilter>
        <criteriaItems>
            <field>LeasePayment__c.Payment_Received__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Payment_Request_Submitted__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Closing_Request_Resp__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Tranche_2_Response_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Tranching Status Update - Closed</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Tranching Status Update - Presented</fullName>
        <actions>
            <name>Tranching_Status_Presented</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND (5 or 6 )</booleanFilter>
        <criteriaItems>
            <field>LeasePayment__c.Payment_Received__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Payment_Request_Submitted__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Closing_Request_Resp__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Closing_Request_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Preflight_Batch_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Tranche_1_Response_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Tranching Status Update - Presented</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Tranching Status Update - Received Payment</fullName>
        <actions>
            <name>Tranching_Status_Received_Payment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1)</booleanFilter>
        <criteriaItems>
            <field>LeasePayment__c.Payment_Received__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Tranching Status Update - Received Payment</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Tranching Status Update - Requested for Closing</fullName>
        <actions>
            <name>Tranching_Status_Requested_for_Closing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND (4 or 5)</booleanFilter>
        <criteriaItems>
            <field>LeasePayment__c.Payment_Received__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Payment_Request_Submitted__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Closing_Request_Resp__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Closing_Request_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Tranche_2_Response_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Tranching Status Update - Requested for Closing</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Tranching Status Update - Requested for Payment</fullName>
        <actions>
            <name>Tranching_Status_Requested_for_Payment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2)</booleanFilter>
        <criteriaItems>
            <field>LeasePayment__c.Payment_Received__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Payment_Request_Submitted__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Tranching Status Update - Requested for Payment</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update ITC Cash Grant Valuation</fullName>
        <actions>
            <name>Update_ITC_Cash_Grant_Valuation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>to populate the static value of ITC Cash Grant Valuation leases once PIS date is entered moving forward if financier =SPWR-ITC</description>
        <formula>AND(ISPICKVAL (Funding_Tranche__c ,&quot;SPWR-ITC&quot;),
 (OR(ISBLANK(Placed_In_Service__c ),(ISBLANK(Lease_Cost__c )))))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Lease %23 Dup</fullName>
        <actions>
            <name>Update_Lease_Dup</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LeasePayment__c.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update Lease # Dup to make record searchable</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Lease Phase - Countersigned</fullName>
        <active>false</active>
        <booleanFilter>(1 AND 2 AND 3 AND 4 AND 5 and 6)</booleanFilter>
        <criteriaItems>
            <field>LeasePayment__c.Date_Countersigned__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.SPEB_SO__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Date_Delivered__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Install_Inv_Rcvd__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Intrcnct_Inv_Rcvd__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Cmsng_Rpt_Rcvd__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Update Lease Phase - Countersigned</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Lease Phase - Delivered</fullName>
        <active>false</active>
        <booleanFilter>(1 AND 2 AND 3 AND 4)</booleanFilter>
        <criteriaItems>
            <field>LeasePayment__c.Date_Delivered__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Install_Inv_Rcvd__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Intrcnct_Inv_Rcvd__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Cmsng_Rpt_Rcvd__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Update Lease Phase - Delivered</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Lease Phase - Generated</fullName>
        <active>false</active>
        <booleanFilter>(1 AND 2 AND 3 AND 4 AND 5 and 6 AND 7)</booleanFilter>
        <criteriaItems>
            <field>LeasePayment__c.Docs_Gen_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Date_Countersigned__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.SPEB_SO__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Date_Delivered__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Install_Inv_Rcvd__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Intrcnct_Inv_Rcvd__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Cmsng_Rpt_Rcvd__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Update Lease Phase - Generated</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Lease Phase - Installed</fullName>
        <active>false</active>
        <booleanFilter>(1 AND 2 AND 3)</booleanFilter>
        <criteriaItems>
            <field>LeasePayment__c.Install_Inv_Rcvd__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Intrcnct_Inv_Rcvd__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Cmsng_Rpt_Rcvd__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Update Lease Phase - Installed</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Lease Phase - Interconnected</fullName>
        <active>false</active>
        <criteriaItems>
            <field>LeasePayment__c.Placed_In_Service__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update Lease Phase - Interconnected</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Lease Phase - Order Booked</fullName>
        <active>false</active>
        <booleanFilter>(1 AND 2 AND 3 AND 4 AND 5)</booleanFilter>
        <criteriaItems>
            <field>LeasePayment__c.SPEB_SO__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Date_Delivered__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Install_Inv_Rcvd_YN__c</field>
            <operation>lessOrEqual</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Intrcnct_Inv_Rcvd__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.Cmsng_Rpt_Rcvd_YN__c</field>
            <operation>notEqual</operation>
            <value>1</value>
        </criteriaItems>
        <description>Update Lease Phase - Order Booked</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Uncond Fin LW Approved</fullName>
        <actions>
            <name>Update_Uncond_Fin_LW_Approved</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Update the field &quot;Uncond Fin LW Approved&quot; when the &quot;Unconditional Final Lien Waiver Received&quot; is updated</description>
        <formula>NOT( ISNULL(Uncond_Fin_LW_Rcvd__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Wattage Extract From Module - 225</fullName>
        <actions>
            <name>Wattage_Update_225</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LeasePayment__c.Module__c</field>
            <operation>contains</operation>
            <value>225</value>
        </criteriaItems>
        <description>Wattage Extract From Module - 225</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Wattage Extract From Module - 228</fullName>
        <actions>
            <name>Wattage_Update_228</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LeasePayment__c.Module__c</field>
            <operation>contains</operation>
            <value>228</value>
        </criteriaItems>
        <description>Wattage Extract From Module - 228</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Wattage Extract From Module - 230</fullName>
        <actions>
            <name>Wattage_Update_230</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LeasePayment__c.Module__c</field>
            <operation>contains</operation>
            <value>230</value>
        </criteriaItems>
        <description>Wattage Extract From Module - 230</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Wattage Extract From Module - 235</fullName>
        <actions>
            <name>Wattage_Update_235</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LeasePayment__c.Module__c</field>
            <operation>contains</operation>
            <value>235</value>
        </criteriaItems>
        <description>Wattage Extract From Module - 235</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Wattage Extract From Module - 238</fullName>
        <actions>
            <name>Wattage_Update_238</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LeasePayment__c.Module__c</field>
            <operation>contains</operation>
            <value>238</value>
        </criteriaItems>
        <description>Wattage Extract From Module - 238</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Wattage Extract From Module - 240</fullName>
        <actions>
            <name>Wattage_Update_240</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LeasePayment__c.Module__c</field>
            <operation>contains</operation>
            <value>240</value>
        </criteriaItems>
        <description>Wattage Extract From Module - 240</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Wattage Extract From Module - 245</fullName>
        <actions>
            <name>Wattage_Update_245</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LeasePayment__c.Module__c</field>
            <operation>contains</operation>
            <value>245</value>
        </criteriaItems>
        <description>Wattage Extract From Module - 245</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Wattage Extract From Module - 250</fullName>
        <actions>
            <name>Wattage_Extract_From_Module_250</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LeasePayment__c.Module__c</field>
            <operation>contains</operation>
            <value>250</value>
        </criteriaItems>
        <description>Wattage Extract From Module - 250</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Wattage Extract From Module - 308</fullName>
        <actions>
            <name>Wattage_Update_308</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LeasePayment__c.Module__c</field>
            <operation>contains</operation>
            <value>308</value>
        </criteriaItems>
        <description>Wattage Extract From Module - 308</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Wattage Extract From Module - 318</fullName>
        <actions>
            <name>Wattage_Update_318</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LeasePayment__c.Module__c</field>
            <operation>contains</operation>
            <value>318</value>
        </criteriaItems>
        <description>Wattage Extract From Module - 318</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Wattage Extract From Module - 320</fullName>
        <actions>
            <name>Wattage_Update_320</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LeasePayment__c.Module__c</field>
            <operation>contains</operation>
            <value>320</value>
        </criteriaItems>
        <description>Wattage Extract From Module - 320</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Wattage Extract From Module - 327</fullName>
        <actions>
            <name>Wattage_Update_327</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LeasePayment__c.Module__c</field>
            <operation>contains</operation>
            <value>327</value>
        </criteriaItems>
        <description>Wattage Extract From Module - 327</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Wattage Extract From Module - 335</fullName>
        <actions>
            <name>Wattage_Extract_From_Module_335</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LeasePayment__c.Module__c</field>
            <operation>contains</operation>
            <value>335</value>
        </criteriaItems>
        <description>Wattage Extract From Module - 335</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Wattage Extract From Module - 345</fullName>
        <actions>
            <name>Wattage_Extract_From_Module_345</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LeasePayment__c.Module__c</field>
            <operation>contains</operation>
            <value>345</value>
        </criteriaItems>
        <description>Wattage Extract From Module - 345</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Watts Update</fullName>
        <actions>
            <name>Watts_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LeasePayment__c.Watts__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Interconnection_Email_Sent</fullName>
        <assignedTo>devon.westerholm@sunpowercorp.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Interconnection Email Sent</subject>
    </tasks>
    <tasks>
        <fullName>Pending_Interconnection_Email_Lease_SPD</fullName>
        <assignedTo>devon.westerholm@sunpowercorp.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Pending Interconnection Email Lease - (SPD)</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Pending Interconnection Email Lease - (SPD)</subject>
    </tasks>
    <tasks>
        <fullName>Pending_Interconnection_Email_Sent</fullName>
        <assignedTo>diane.galiza@cloudsherpas.com.spwr</assignedTo>
        <assignedToType>user</assignedToType>
        <description>The Welcome Email Opt Out has been sent to the Partner Account: Vendor Email</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Pending Interconnection Email Sent</subject>
    </tasks>
    <tasks>
        <fullName>Pending_Interconnections_Email_Sent</fullName>
        <assignedTo>devon.westerholm@sunpowercorp.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Pending Interconnection Email Sent</subject>
    </tasks>
</Workflow>
