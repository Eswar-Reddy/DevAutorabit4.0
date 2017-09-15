<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ALR_Manual_Review_Email_Alert</fullName>
        <description>LEAD ALR Manual Review Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>Lead_Opps_Manual_Review_Group</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>crmadmin@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Lead/ALR_Manual_Review_Template</template>
    </alerts>
    <alerts>
        <fullName>APAC_Lead_Created</fullName>
        <ccEmails>customers@sunpowercorp.com</ccEmails>
        <description>APAC Lead Created</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Lead/APAC_Lead_Created</template>
    </alerts>
    <alerts>
        <fullName>AU_Lead_Created</fullName>
        <ccEmails>customerservice.australia@sunpowercorp.com</ccEmails>
        <description>AU Lead Created</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Lead/AU_Lead_Created</template>
    </alerts>
    <alerts>
        <fullName>Aging_Lead_Reminder</fullName>
        <description>Aging Lead Reminder</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lead/Aging_Lead_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Assign_Non_Utility_Lead</fullName>
        <description>Assign Non-Utility Lead</description>
        <protected>false</protected>
        <recipients>
            <recipient>lulu.vasquez@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rblomquist@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lead/Assigned_Non_Utility_Lead</template>
    </alerts>
    <alerts>
        <fullName>Lead_Approval_Rejected</fullName>
        <description>Lead Approval Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lead/Lead_Rejection_Email</template>
    </alerts>
    <alerts>
        <fullName>Lead_Conversion_Approved</fullName>
        <description>Lead Conversion Approved</description>
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
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lead/Lead_Approval_Email</template>
    </alerts>
    <alerts>
        <fullName>Lead_Conversion_Approved_NAC1</fullName>
        <description>Lead Conversion Approved - NAC</description>
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
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lead/Lead_Approval_Email</template>
    </alerts>
    <alerts>
        <fullName>Lead_Convert_Australia_New_Zealand</fullName>
        <description>Lead Convert - Australia - New Zealand</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>wilf.johnston@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lead/Convert_Lead_Request</template>
    </alerts>
    <alerts>
        <fullName>Lead_Qualified_UPP_Intl</fullName>
        <description>Lead Qualified - UPP Intl</description>
        <protected>false</protected>
        <recipients>
            <recipient>nemesio.tejero@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lead/Lead_Qualified_Email</template>
    </alerts>
    <alerts>
        <fullName>Partner_Inquiry_Received_Commercial</fullName>
        <description>Partner Inquiry Received Commercial</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>customercare@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Lead/Web2lead_confirmation_CVAR_dealer_form</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Customer</fullName>
        <description>Send Email to Customer</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lead/Lead_to_Opportunity_Customer_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Federal_Sales_Manager_and_Current_Recipients</fullName>
        <description>Send Email to Federal Sales Manager and Current Recipients</description>
        <protected>false</protected>
        <recipients>
            <recipient>morgan.adam@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lead/Federal_Government_Lead_Created</template>
    </alerts>
    <alerts>
        <fullName>Web_Lead_Received_Email_Alert</fullName>
        <description>Web Lead Received Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>alvinchristian.alfonso@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>angelito.tuason@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>armikrizell.santos@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>diakatrina.deuda-dondoy@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jay.julianda@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>yvette.ilagan@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SunPower/Web_Lead_Received</template>
    </alerts>
    <alerts>
        <fullName>partnerinquiryreceived</fullName>
        <description>Partner Inquiry Received</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>customercare@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Partner_Application/Web2lead_confirmation_dealer_form</template>
    </alerts>
    <fieldUpdates>
        <fullName>Clean_Status_Skipped</fullName>
        <description>Updates the Data.com Clean Status field to skipped</description>
        <field>CleanStatus</field>
        <literalValue>Skipped</literalValue>
        <name>Clean Status - Skipped</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_Contacted_Updated</fullName>
        <description>Date Contacted Updated - Lead Status = Contacted</description>
        <field>Date_Contacted__c</field>
        <formula>Today ()</formula>
        <name>Date Contacted Updated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_Qualified_Updated</fullName>
        <description>Date Qualified Updated: Lead Status = Qualified</description>
        <field>Date_Qualifed__c</field>
        <formula>Today ()</formula>
        <name>Date Qualified Updated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EUC_Lead</fullName>
        <field>EUC__c</field>
        <literalValue>1</literalValue>
        <name>EUC Lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>First_Contact_Made</fullName>
        <field>First_Contact_Made__c</field>
        <formula>1</formula>
        <name>First Contact Made</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IBD_Record_Type_Field_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Systems</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>IBD Record Type Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Jigsaw_to_Data_Com_Lead_Source_Update</fullName>
        <description>Jigsaw to Data.Com Lead Source Update</description>
        <field>LeadSource</field>
        <literalValue>Data.Com - Sales</literalValue>
        <name>Jigsaw to Data.Com Lead Source Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Approval_Rejection_Field_Update</fullName>
        <field>Lead_Approval__c</field>
        <literalValue>False</literalValue>
        <name>Lead Approval Rejection Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Created_Checkbox</fullName>
        <description>Lead Created Checkbox</description>
        <field>Lead_Created_Checkbox__c</field>
        <literalValue>1</literalValue>
        <name>Lead Created Checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Mobile_Phone_US_Prefix</fullName>
        <description>Case# 00616615 - Five9 Screen-Pop not working in EMEA (and maybe APAC) - Arokia Nathan</description>
        <field>Mobile_US_Prefix__c</field>
        <formula>IF( 
OR(ISBLANK(MobilePhone), 
/* US Number */ 
AND ( 
LEN(MobilePhone) = 14, 
MID(MobilePhone, 1, 1) = &apos;(&apos;, 
ISNUMBER(MID(MobilePhone, 2, 3)), 
MID(MobilePhone, 5, 1) = &apos;)&apos;, 
MID(MobilePhone, 6, 1) = &apos; &apos;, 
ISNUMBER(MID(MobilePhone, 7, 3)), 
MID(MobilePhone, 10, 1) = &apos;-&apos;, 
ISNUMBER(MID(MobilePhone, 11, 4)) 
), 
/* US Number Extension */ 
AND ( 
LEN(MobilePhone) &gt;= 15, 
MID(MobilePhone, 1, 1) = &apos;(&apos;, 
ISNUMBER(MID(MobilePhone, 2, 3)), 
MID(MobilePhone, 5, 1) = &apos;)&apos;, 
MID(MobilePhone, 6, 1) = &apos; &apos;, 
ISNUMBER(MID(MobilePhone, 7, 3)), 
MID(MobilePhone, 10, 1) = &apos;-&apos;, 
ISNUMBER(MID(MobilePhone, 11, 4)), 
MID(MobilePhone, 15, 1) = &apos; &apos; 
) 
), 
null, 
&apos;011 &apos; &amp; MobilePhone 
)</formula>
        <name>Lead Mobile Phone US Prefix</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Phone_US_Prefix</fullName>
        <description>Case# 00616615 - Five9 Screen-Pop not working in EMEA (and maybe APAC) - Arokia Nathan</description>
        <field>Phone_US_Prefix__c</field>
        <formula>IF( 
OR(ISBLANK(Phone), 
/* US Number */ 
AND ( 
LEN(Phone) = 14, 
MID(Phone, 1, 1) = &apos;(&apos;, 
ISNUMBER(MID(Phone, 2, 3)), 
MID(Phone, 5, 1) = &apos;)&apos;, 
MID(Phone, 6, 1) = &apos; &apos;, 
ISNUMBER(MID(Phone, 7, 3)), 
MID(Phone, 10, 1) = &apos;-&apos;, 
ISNUMBER(MID(Phone, 11, 4)) 
), 
/* US Number Extension */ 
AND ( 
LEN(Phone) &gt;= 15, 
MID(Phone, 1, 1) = &apos;(&apos;, 
ISNUMBER(MID(Phone, 2, 3)), 
MID(Phone, 5, 1) = &apos;)&apos;, 
MID(Phone, 6, 1) = &apos; &apos;, 
ISNUMBER(MID(Phone, 7, 3)), 
MID(Phone, 10, 1) = &apos;-&apos;, 
ISNUMBER(MID(Phone, 11, 4)), 
MID(Phone, 15, 1) = &apos; &apos; 
) 
), 
null, 
&apos;011 &apos; &amp; Phone 
)</formula>
        <name>Lead Phone US Prefix</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Re_Engagement_Germany_Change_Owne</fullName>
        <field>OwnerId</field>
        <lookupValue>NAResidentialLeadQueue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Lead Re-Engagement - Germany-Change Owne</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Re_Engagement_Germany_Change_ReG</fullName>
        <field>Lead_Re_Engagement__c</field>
        <name>Lead Re-Engagement - Germany-Change ReG</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Set_RLC_Type_for_Systems</fullName>
        <description>Set &quot;RLC Type&quot; field to &quot;Light Commercial&quot; for Systems Lead of BU &quot;RLC&quot;</description>
        <field>RLC_Type__c</field>
        <literalValue>Light Commercial</literalValue>
        <name>Lead: Set RLC Type for Systems</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Set_Status_field_to_Qualified</fullName>
        <description>Set Lead Status field to Qualified for Leads that have certain Promo Code
Case#00077409- Status should be set &apos;Open&apos;</description>
        <field>Status</field>
        <literalValue>Open</literalValue>
        <name>Lead: Set Status field to Open</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Team_NA_Commercial_ISR_Queue</fullName>
        <description>Lead Team Update - NA Commercial ISR Queue</description>
        <field>Lead_Team__c</field>
        <literalValue>ISR</literalValue>
        <name>Lead Team - NA Commercial ISR Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Team_NA_Commercial_Marketing_Queu</fullName>
        <description>Lead Team - NA Commercial Marketing Queue</description>
        <field>Lead_Team__c</field>
        <literalValue>Marketing</literalValue>
        <name>Lead Team - NA Commercial Marketing Queu</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Leads_Set_Converted_Record_Type</fullName>
        <field>Record_Type_For_Conversion__c</field>
        <formula>$RecordType.Name</formula>
        <name>Leads: Set Converted Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Marketing_Opt_In</fullName>
        <description>Marketing Opt-In should be true when BU is NA Commercial or UPP Americas in Systems record type</description>
        <field>Marketing_Opt_In__c</field>
        <literalValue>1</literalValue>
        <name>Marketing Opt-In</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SSO_First_Contact_Date_Time_Update</fullName>
        <field>SSO_First_Contact_Date_Time__c</field>
        <formula>Now()</formula>
        <name>SSO First Contact Date/Time Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Lead_Inferred_Quality_When_Source</fullName>
        <field>Lead_Inferred_Quality__c</field>
        <literalValue>Accept</literalValue>
        <name>Set Lead Inferred Quality : When Source</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>StatusSetDisqualified</fullName>
        <description>This should update the status from to Disqualified</description>
        <field>Status</field>
        <literalValue>Disqualified</literalValue>
        <name>StatusSetDisqualified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_CRBS_to_null</fullName>
        <field>Commercial_Residential_Business_Split__c</field>
        <name>Update CRBS to null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_EC_Email_Field</fullName>
        <field>EC_Owner_Email__c</field>
        <formula>Owner:User.Email</formula>
        <name>Field Update EC Email Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Eloqua_Checkbox</fullName>
        <field>Updated_by_Eloqua__c</field>
        <literalValue>1</literalValue>
        <name>Update Eloqua Checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_How_Module_to_null</fullName>
        <field>How_do_you_buy_your_Modules__c</field>
        <name>Update How Module to null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Last_Submission_Date</fullName>
        <field>Last_Submission_Date__c</field>
        <formula>CreatedDate</formula>
        <name>Update Last Submission Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Approval_To_Approved</fullName>
        <field>Lead_Approval__c</field>
        <literalValue>True</literalValue>
        <name>Update Lead Approval To Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Approval_to_Pending</fullName>
        <field>Lead_Approval__c</field>
        <literalValue>False</literalValue>
        <name>Update Lead Approval to Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Reason_Application_Sent</fullName>
        <field>Reason__c</field>
        <literalValue>Application Sent</literalValue>
        <name>Update Lead Reason Application Sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Team_Previous_Owner</fullName>
        <field>Lead_Team_Previous_Owner__c</field>
        <formula>TEXT(PRIORVALUE(Lead_Team__c))</formula>
        <name>Update Lead Team - Previous Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Team_SSO</fullName>
        <description>Update Lead Team - SSO</description>
        <field>Lead_Team__c</field>
        <literalValue>SSO</literalValue>
        <name>Update Lead Team - SSO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_PartnerType_Commercial</fullName>
        <description>Set Partner Type Field to Commercial</description>
        <field>Partner_Type__c</field>
        <literalValue>Commercial</literalValue>
        <name>Update PartnerType Commercial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_PartnerType_Residential</fullName>
        <description>Set Partner Type field to Residential</description>
        <field>Partner_Type__c</field>
        <literalValue>Residential</literalValue>
        <name>Update PartnerType Residential</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Primary_Contact</fullName>
        <field>Primary_Contact__c</field>
        <literalValue>1</literalValue>
        <name>Update Primary Contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Rec_Type_to_General</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Systems</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Rec Type to General</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Rec_Type_to_New_Homes</fullName>
        <field>RecordTypeId</field>
        <lookupValue>New_Homes</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Rec Type to New Homes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Rec_Type_to_Partner</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Partner</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Rec Type to Partner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Rec_Type_to_Systems</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Systems</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Rec Type to Systems</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_to_Residential</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Residential</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type to Residential</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SSO_First_Contact_Date_Time</fullName>
        <field>SSO_First_Contact_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Update SSO First Contact Date/Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <flowActions>
        <fullName>Lead_Referring_Contact_Flow_Trigger</fullName>
        <description>Case# 00562712 - Ambassador (referrer) direct entry method - Arokia Nathan</description>
        <flow>Lead_Referring_Contact_Flow</flow>
        <flowInputs>
            <name>LeadId</name>
            <value>{!Id}</value>
        </flowInputs>
        <flowInputs>
            <name>ReferringContactId</name>
            <value>{!Friend_Id__c}</value>
        </flowInputs>
        <label>Lead Referring Contact Flow Trigger</label>
        <language>en_US</language>
        <protected>false</protected>
    </flowActions>
    <rules>
        <fullName>APAC Lead Created</fullName>
        <actions>
            <name>APAC_Lead_Created</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Theater__c</field>
            <operation>equals</operation>
            <value>Asia Pacific</value>
        </criteriaItems>
        <description>APAC Lead Created</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AU Lead Created</fullName>
        <actions>
            <name>AU_Lead_Created</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Theater__c</field>
            <operation>equals</operation>
            <value>Australia,New Zealand</value>
        </criteriaItems>
        <description>AU Lead Created</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Aging Lead Reminder</fullName>
        <actions>
            <name>Aging_Lead_Reminder</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Aging Lead Reminder.</description>
        <formula>IF($User.ByPassValidation__c == false,(CreatedDate &gt;= ( NOW() - 7)),null)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Assigned Non-Utility Lead</fullName>
        <actions>
            <name>Assign_Non_Utility_Lead</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 AND 2 AND 3) and 4</booleanFilter>
        <criteriaItems>
            <field>Lead.Business_Unit__c</field>
            <operation>notEqual</operation>
            <value>UPP Intl</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Business_Unit__c</field>
            <operation>notEqual</operation>
            <value>UPP Americas</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.SPWR_Industry_Type__c</field>
            <operation>equals</operation>
            <value>Electric Utility</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Assigned Non-Utility Lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Australia-New Zealand Convert Lead</fullName>
        <actions>
            <name>Lead_Convert_Australia_New_Zealand</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 or 4) AND 2 AND 3 and 5</booleanFilter>
        <criteriaItems>
            <field>Lead.RLC_Type__c</field>
            <operation>equals</operation>
            <value>Light Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Qualified</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Theater__c</field>
            <operation>equals</operation>
            <value>Australia,New Zealand</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Business_Unit__c</field>
            <operation>equals</operation>
            <value>UPP Intl</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Systems</value>
        </criteriaItems>
        <description>Australia-New Zealand Convert Lead</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Bypass Data%2Ecom Clean</fullName>
        <actions>
            <name>Clean_Status_Skipped</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>New Homes,Partner,Residential,XantrexRecall</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.CleanStatus</field>
            <operation>notEqual</operation>
            <value>Skipped</value>
        </criteriaItems>
        <description>This rules sets the clean status field to skipped for all non commercial records that don&apos;t have a clean status of skipped.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Date Contacted</fullName>
        <actions>
            <name>Date_Contacted_Updated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>contains</operation>
            <value>Contacted</value>
        </criteriaItems>
        <description>Date Contacted: Lead Status = Contacted</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Date Qualified</fullName>
        <actions>
            <name>Date_Qualified_Updated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Qualified</value>
        </criteriaItems>
        <description>Date Qualified: Lead Status = Qualified</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EUC Lead</fullName>
        <actions>
            <name>EUC_Lead</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RLC_Type__c</field>
            <operation>equals</operation>
            <value>EU Commercial</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Federal Government Lead Created</fullName>
        <actions>
            <name>Send_Email_to_Federal_Sales_Manager_and_Current_Recipients</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.SPWR_Industry_Type__c</field>
            <operation>equals</operation>
            <value>Federal Government - Non-Military,Federal Government - Military</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>notEqual</operation>
            <value>DMAdmin</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Federal Government Lead Created</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>First Contact Made</fullName>
        <actions>
            <name>First_Contact_Made</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.SSO_First_Contact_Date_Time__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Jigsaw to Data%2ECom Lead Source Update</fullName>
        <actions>
            <name>Jigsaw_to_Data_Com_Lead_Source_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>contains</operation>
            <value>Jigsaw</value>
        </criteriaItems>
        <description>Jigsaw to Data.Com Lead Source Update</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead ALR Manual Review Workflow</fullName>
        <actions>
            <name>ALR_Manual_Review_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Workflow used to send email to CSR when certain lead status is met</description>
        <formula>AND  
(  
IsConverted =  FALSE, 
ISPICKVAL(Lead_Manufacturer__c, &apos;SunPower&apos;),
RecordType.DeveloperName = &apos;Residential&apos;, 
NOT(CONTAINS (&apos;test:Tester:Testing:Test:TEST&apos;,FirstName)), NOT(CONTAINS (&apos;test:tester:testing&apos;, LastName )), 
OR( 
ISPICKVAL(Status, &apos;Awaiting Qualification Review&apos;), ISPICKVAL(Status, &apos;Awaiting Duplicate Review&apos;), ISPICKVAL(Status, &apos;SPAM&apos;), 
ISPICKVAL(Status, &apos;Failed Conversion&apos;) ), 
OR( CreatedBy.Alias = &apos;Gutie&apos;, CreatedBy.Alias = &apos;Eloqua&apos;, CreatedBy.Alias = &apos;SunPo&apos;, CreatedBy.Alias = &apos;enihe&apos;, CreatedBy.Alias = &apos;sunpower&apos;, CreatedBy.Alias = &apos;adiez&apos; ), OR  
(  
ISPICKVAL(Theater__c,&apos;Central America and the Caribbean&apos;),  ISPICKVAL(Theater__c,&apos;North America&apos;)  
) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Approved - NAC</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Business_Unit__c</field>
            <operation>equals</operation>
            <value>NA Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Approval__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Lead Approved for NAC, converted to oppty.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Converted To Opportunity</fullName>
        <actions>
            <name>Send_Email_to_Customer</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Ipp</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>notEqual</operation>
            <value>DMAdmin</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Created Checkbox</fullName>
        <actions>
            <name>Lead_Created_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Lead Mobile Phone US Prefix Workflow</fullName>
        <actions>
            <name>Lead_Mobile_Phone_US_Prefix</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Case# 00616615 - Five9 Screen-Pop not working in EMEA (and maybe APAC) - Arokia Nathan</description>
        <formula>OR (  AND(ISNEW() ,NOT(ISBLANK(MobilePhone))),  AND(NOT(ISNEW()), ISCHANGED(MobilePhone))  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Phone US Prefix Workflow</fullName>
        <actions>
            <name>Lead_Phone_US_Prefix</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Case# 00616615 - Five9 Screen-Pop not working in EMEA (and maybe APAC) - Arokia Nathan</description>
        <formula>OR (  AND(ISNEW() ,NOT(ISBLANK(Phone))),  AND(NOT(ISNEW()), ISCHANGED(Phone))  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Qualified - UPP Intl</fullName>
        <actions>
            <name>Lead_Qualified_UPP_Intl</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Qualified</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Business_Unit__c</field>
            <operation>equals</operation>
            <value>UPP Intl</value>
        </criteriaItems>
        <description>Lead Qualified - UPP Intl</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Referring Contact Workflow</fullName>
        <actions>
            <name>Lead_Referring_Contact_Flow_Trigger</name>
            <type>FlowAction</type>
        </actions>
        <active>true</active>
        <description>Case# 00562712 - Ambassador (referrer) direct entry method - Arokia Nathan</description>
        <formula>AND( ISBLANK(Ambassador__Referred_By_Contact__c), NOT(ISBLANK(Friend_Id__c)) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Lead Team - Previous Owner</fullName>
        <actions>
            <name>Update_Lead_Team_Previous_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Lead Team - Previous Owner</description>
        <formula>ISCHANGED(Lead_Team__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Team Update - NA Commercial CSR Queue</fullName>
        <actions>
            <name>Update_Lead_Team_SSO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>startsWith</operation>
            <value>NA Commercial CSR Queue</value>
        </criteriaItems>
        <description>Lead Team Update - NA Commercial CSR Queue</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Team Update - NA Commercial ISR Queue</fullName>
        <actions>
            <name>Lead_Team_NA_Commercial_ISR_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>startsWith</operation>
            <value>NA Commercial ISR Queue</value>
        </criteriaItems>
        <description>Lead Team Update - NA Commercial ISR Queue</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Team Update - NA Commercial Marketing Queue</fullName>
        <actions>
            <name>Lead_Team_NA_Commercial_Marketing_Queu</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>startsWith</operation>
            <value>NA Commercial Marketing Queue</value>
        </criteriaItems>
        <description>Lead Team Update - NA Commercial Marketing Queue</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead%3A Set Last Submission Date</fullName>
        <actions>
            <name>Update_Last_Submission_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>True</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Lead%3A Set RLC Type for Systems</fullName>
        <actions>
            <name>Lead_Set_RLC_Type_for_Systems</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Systems</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.BU__c</field>
            <operation>equals</operation>
            <value>RLC</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notContain</operation>
            <value>EU</value>
        </criteriaItems>
        <description>Set &quot;RLC Type&quot; field to &quot;Light Commercial&quot; for Systems Lead that has BU of RLC</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Lead%3A Set Status to Open</fullName>
        <actions>
            <name>Lead_Set_Status_field_to_Qualified</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Promo_Code__c</field>
            <operation>equals</operation>
            <value>Dealer - Keyword Connects_SDtv,Dealer - Keyword Connects_NJRadio,2011_NA_RLC_KeywordC,Dealer - Keyword Connects_GMB_TV</value>
        </criteriaItems>
        <description>Set Status of Lead to Qualified for the Leads that have specific Campaign Promo Code
Case#00077409- Status should be set &apos;Open&apos;</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Leads%3A Set Converted Record Type</fullName>
        <actions>
            <name>Leads_Set_Converted_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Copies record type so value can be mapped to Opportunities for corresponding Opportunity Record Type value setting on Lead conversions via Workflow</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Making Blank two fields on Partner Leads</fullName>
        <actions>
            <name>Update_CRBS_to_null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_How_Module_to_null</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Commercial_Residential_Business_Split__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.How_do_you_buy_your_Modules__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Making Blank two fields on Partner Leads</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Marketing Opt-In Update</fullName>
        <actions>
            <name>Marketing_Opt_In</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Systems</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Business_Unit__c</field>
            <operation>equals</operation>
            <value>NA Commercial,UPP Americas</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Marketing Opt-In Update</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NALeadResidentialUpdateforALR</fullName>
        <actions>
            <name>StatusSetDisqualified</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Once the Lead Record is created, update if-
Record type - Residential
FirstName  = &apos;SPWR Test&apos;</description>
        <formula>AND(( RecordType.Name  =  &apos;Residential&apos;), FirstName  = &apos;SPWR Test&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Partner Inquiry Received from Website</fullName>
        <actions>
            <name>partnerinquiryreceived</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Lead_Reason_Application_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_PartnerType_Residential</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_SSO_First_Contact_Date_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Web</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Theater__c</field>
            <operation>equals</operation>
            <value>North America</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Partner_Type__c</field>
            <operation>equals</operation>
            <value>Residential,Combo</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Partner Inquiry Received from Website</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Partner Inquiry Received from Website Commercial</fullName>
        <actions>
            <name>Partner_Inquiry_Received_Commercial</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Lead_Reason_Application_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_PartnerType_Commercial</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_SSO_First_Contact_Date_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Web</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Theater__c</field>
            <operation>equals</operation>
            <value>North America</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Partner_Type__c</field>
            <operation>equals</operation>
            <value>Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Partner Inquiry Received from Website Commercial</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SSO First Contact Date%2FTime</fullName>
        <actions>
            <name>SSO_First_Contact_Date_Time_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.SSO_First_Contacted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>SSO First Contact Date/Time</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sets Lead Inferred Quality to Accept for Eloqua Leads</fullName>
        <actions>
            <name>Set_Lead_Inferred_Quality_When_Source</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Source_System__c</field>
            <operation>equals</operation>
            <value>Eloqua</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>To update the field to track Eloqua Leads</fullName>
        <actions>
            <name>Update_Eloqua_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>equals</operation>
            <value>Eloqua Marketing</value>
        </criteriaItems>
        <description>To track the 1200 Leads which got error out previously and update a checkbox on Lead to send this report to CSR&apos;s</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update EC Email Field</fullName>
        <actions>
            <name>Update_EC_Email_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Fills EC Email field for email routing</description>
        <formula>Dealer_Locator_Selection__r.Name = &apos;SunPower Direct (SPD)&apos; &amp;&amp; ISPICKVAL(Lead_Manufacturer__c , &apos;SunPower&apos;)  &amp;&amp; Owner:User.Profile_Text__c = &apos;Partner SSE Installer&apos; &amp;&amp; LOWER(Owner:User.Alias) != &apos;sadvi&apos;    &amp;&amp; OwnerId  !=  PRIORVALUE( OwnerId )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Lead Record Type for UPPi Asia Countries</fullName>
        <actions>
            <name>IBD_Record_Type_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 OR 2 OR 3 OR 4) AND 5</booleanFilter>
        <criteriaItems>
            <field>Lead.Country</field>
            <operation>equals</operation>
            <value>Greece</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Country</field>
            <operation>equals</operation>
            <value>Japan</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Country</field>
            <operation>equals</operation>
            <value>China</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Country</field>
            <operation>equals</operation>
            <value>India</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Was IBD</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Primary Contact</fullName>
        <actions>
            <name>Update_Primary_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Residential</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Rec Type to Commercial</fullName>
        <active>false</active>
        <booleanFilter>1 or 2 or 3</booleanFilter>
        <criteriaItems>
            <field>Lead.Lead_Type__c</field>
            <operation>equals</operation>
            <value>Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Type__c</field>
            <operation>equals</operation>
            <value>RFI Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Type__c</field>
            <operation>equals</operation>
            <value>Light Commercial Lead</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Rec Type to General</fullName>
        <actions>
            <name>Update_Rec_Type_to_General</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 OR 2 OR 3 OR 4) AND 5</booleanFilter>
        <criteriaItems>
            <field>Lead.Lead_Type__c</field>
            <operation>equals</operation>
            <value>Components</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Type__c</field>
            <operation>equals</operation>
            <value>RFI</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Type__c</field>
            <operation>equals</operation>
            <value>General</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Type__c</field>
            <operation>equals</operation>
            <value>Installer</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Rec Type to New Homes</fullName>
        <actions>
            <name>Update_Rec_Type_to_New_Homes</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 OR 2 OR 3 OR 4) AND 5</booleanFilter>
        <criteriaItems>
            <field>Lead.Lead_Type__c</field>
            <operation>equals</operation>
            <value>New Homes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Type__c</field>
            <operation>equals</operation>
            <value>SPNH</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Type__c</field>
            <operation>equals</operation>
            <value>RFI SPNH</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Type__c</field>
            <operation>equals</operation>
            <value>New Home</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Rec Type to Partner</fullName>
        <actions>
            <name>Update_Rec_Type_to_Partner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Lead_Type__c</field>
            <operation>equals</operation>
            <value>Partner</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Rec Type to Residential</fullName>
        <actions>
            <name>Update_Record_Type_to_Residential</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 or 2 or 3 or 4 or 5) and 6</booleanFilter>
        <criteriaItems>
            <field>Lead.Lead_Type__c</field>
            <operation>equals</operation>
            <value>Residential</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Type__c</field>
            <operation>equals</operation>
            <value>Residential Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Type__c</field>
            <operation>equals</operation>
            <value>Home Owner (Dealer Lead)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Type__c</field>
            <operation>equals</operation>
            <value>RFI Home Owner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Type__c</field>
            <operation>equals</operation>
            <value>Home Owner</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Rec Type to Systems</fullName>
        <actions>
            <name>Update_Rec_Type_to_Systems</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 or 2</booleanFilter>
        <criteriaItems>
            <field>Lead.Lead_Type__c</field>
            <operation>equals</operation>
            <value>Systems</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Type__c</field>
            <operation>equals</operation>
            <value>Systems Lead</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Web Lead Received</fullName>
        <actions>
            <name>Web_Lead_Received_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND (2 OR 3 OR 4 OR 5 Or 6) AND 7</booleanFilter>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Web</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>NA Residential Lead Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>NA Commercial Lead Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>NA Partner Lead Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>NA General Lead Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>Unassigned Lead Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
