<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Add_Partner_as_MQC_Partner_in_Oracle</fullName>
        <description>Add Partner as MQC Partner in Oracle</description>
        <protected>false</protected>
        <recipients>
            <recipient>flora.mercurio@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Account/Add_Partner_as_MQC_Partner_in_Oracle</template>
    </alerts>
    <alerts>
        <fullName>Add_this_this_Monitor_Promotion_Participant_in_Oracle</fullName>
        <description>Add this this Monitor Promotion Participant in Oracle</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>testingaccount@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Account/Add_this_this_Monitor_Promotion_Participant_in_Oracle</template>
    </alerts>
    <alerts>
        <fullName>Alert_on_MQC1_MQC2_Participant_Update</fullName>
        <ccEmails>pricing.request@sunpowercorp.com</ccEmails>
        <description>Alert on MQC1/MQC2 Participant Update</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Account/Alert_on_MQC1_MQC2_Participant_Update</template>
    </alerts>
    <alerts>
        <fullName>Approval_Type_Rejected</fullName>
        <description>Approval Type Rejected</description>
        <protected>false</protected>
        <recipients>
            <recipient>jeff.cavros@sunpower.com</recipient>
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
        <template>Account/Account_Type_Rejected</template>
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
            <recipient>rochelle.cervera@sunpowercorp.com</recipient>
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
        <fullName>Credit_Check_Recalled_On_Account_UPPi</fullName>
        <description>Credit Check Recalled On Account - UPPi</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <recipient>barry.serafino@sunpowercorp.com</recipient>
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
        <template>Account/Credit_Check_Recalled_On_Account_UPPi</template>
    </alerts>
    <alerts>
        <fullName>Credit_Check_Rejected_On_Account_UPPi</fullName>
        <description>Credit Check Rejected On Account - UPPi</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <recipient>barry.serafino@sunpowercorp.com</recipient>
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
        <template>Account/Credit_Check_Rejected_On_Account</template>
    </alerts>
    <alerts>
        <fullName>Lease_Tool_Access_Creation_Notification</fullName>
        <ccEmails>financing@sunpowercorp.com</ccEmails>
        <description>Lease Tool Access Creation Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Account/Lease_Tool_Access_Creation_Notification</template>
    </alerts>
    <alerts>
        <fullName>Notification_to_Pricing_Team_when_Partner_Type_gets_updated</fullName>
        <ccEmails>pricing.request@sunpowercorp.com</ccEmails>
        <description>Notification to Pricing Team when Partner Type gets updated</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Partner_Management/Partner_Type_Status_Update</template>
    </alerts>
    <alerts>
        <fullName>Online_Ordering_is_enabled</fullName>
        <description>Online Ordering is enabled</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Primary_PSR__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Account/Online_Ordering_is_enabled</template>
    </alerts>
    <alerts>
        <fullName>Partner_Terminated_Notification</fullName>
        <ccEmails>CSR-NATeamLeads@sunpowercorp.com</ccEmails>
        <ccEmails>DesignSupport@sunpower.com</ccEmails>
        <description>Partner Terminated Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Account/Partner_Has_Been_Terminated</template>
    </alerts>
    <alerts>
        <fullName>Provide_SmartStore_Access_Send_Partner_Welcome_Pack</fullName>
        <ccEmails>marketing@sunpowercorp.com</ccEmails>
        <description>Provide SmartStore Access &amp; Send Partner Welcome Pack</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
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
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Account/Provide_SmartStore_Access_Send_Partner_Welcome_Pack</template>
    </alerts>
    <alerts>
        <fullName>Send_Echosign_Request_to_add_Partner_email_domain_to_safellist</fullName>
        <ccEmails>support@echosign.zendesk.com</ccEmails>
        <description>Send Echosign Request to add Partner email domain to safellist</description>
        <protected>false</protected>
        <recipients>
            <recipient>jasmin.rosal@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rose.punzalan@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforcearchives@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Account/Add_domain_to_Echosign_safelist</template>
    </alerts>
    <alerts>
        <fullName>Send_email_alert_to_RSM_when_account_credit_is_put_on_hold</fullName>
        <description>Send email alert to RSM when account credit is put on hold</description>
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
        <template>Account/Account_Credit_On_Hold</template>
    </alerts>
    <alerts>
        <fullName>partnerassignedtoaterritory</fullName>
        <description>Partner Assigned to a Territory</description>
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
        <template>Partner_Management/Partner_Assigned_to_a_Territory</template>
    </alerts>
    <alerts>
        <fullName>partnerrequiresaccesstosunpowersystems</fullName>
        <description>Partner Requires Access to SunPower Systems</description>
        <protected>false</protected>
        <recipients>
            <recipient>ITHelpDeskManager</recipient>
            <type>role</type>
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
        <template>Partner_Management/Partner_Requires_Access_to_SunPower_Systems</template>
    </alerts>
    <alerts>
        <fullName>partnerrequiressmartstoreaccess</fullName>
        <description>Partner Requires SmartStore Access</description>
        <protected>false</protected>
        <recipients>
            <recipient>ITHelpDeskManager</recipient>
            <type>role</type>
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
        <template>Partner_Management/Partner_Requires_SmartStore_Access</template>
    </alerts>
    <fieldUpdates>
        <fullName>Account_Phone_US_Prefix</fullName>
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
        <name>Account Phone US Prefix</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Type_Authorized_Partner_Combo</fullName>
        <description>Account Type - Authorized-Partner Combo</description>
        <field>Type</field>
        <literalValue>Authorized-Partner-Combo</literalValue>
        <name>Account Type - Authorized-Partner Combo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Type_Premier_Partner_Res</fullName>
        <description>Account Type-Premier-Partner-Res</description>
        <field>Type</field>
        <literalValue>Premier-Partner-Residential</literalValue>
        <name>Account Type-Premier-Partner-Res</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Type_Update_Autho_Partner_Res</fullName>
        <description>Account Type Update-Autho-Partner-Res</description>
        <field>Type</field>
        <literalValue>Authorized-Partner-Residential</literalValue>
        <name>Account Type Update-Autho-Partner-Res</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Type_Update_Elite_Partner_Comb</fullName>
        <description>Account Type Update - Elite-Partner-Comb</description>
        <field>Type</field>
        <literalValue>Elite-Partner-Combo</literalValue>
        <name>Account Type Update - Elite-Partner-Comb</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Type_Update_Elite_Partner_Res</fullName>
        <description>Account Type Update-Elite-Partner-Res</description>
        <field>Type</field>
        <literalValue>Elite-Partner-Residential</literalValue>
        <name>Account Type Update-Elite-Partner-Res</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Type_Update_Partner_Commercial</fullName>
        <description>Account Type Update-Partner-Commercial</description>
        <field>Type</field>
        <literalValue>Partner-Commercial</literalValue>
        <name>Account Type Update-Partner-Commercial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Type_Update_Premier_Partner_Co</fullName>
        <description>Account Type Update - Premier-Partner-Co</description>
        <field>Type</field>
        <literalValue>Premier-Partner-Combo</literalValue>
        <name>Account Type Update - Premier-Partner-Co</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPP_Set_Account_Status_Active</fullName>
        <field>Status__c</field>
        <literalValue>Active</literalValue>
        <name>CPP-Set Account Status Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Check_Opted_Out_of_Ok_To_Ship_Once</fullName>
        <description>Change value of Opted Out of Ok to Ship Once to true</description>
        <field>Opted_out_of_Ok_To_Ship_Once__c</field>
        <literalValue>1</literalValue>
        <name>Check Opted Out of Ok To Ship Once</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
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
        <fullName>Clear_Theater</fullName>
        <field>Theater__c</field>
        <name>Clear Theater</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Website</fullName>
        <field>Website</field>
        <name>Clear Website</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>New_Type_Request_Status_Approved</fullName>
        <description>New Type Request Status - Approved</description>
        <field>New_Type_Request_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>New Type Request Status - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>New_Type_Request_Status_In_Approval</fullName>
        <description>New Type Request Status - In Approval</description>
        <field>New_Type_Request_Status__c</field>
        <literalValue>In Approval</literalValue>
        <name>New Type Request Status - In Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>New_Type_Request_Status_Recalled</fullName>
        <description>New Type Request Status - Recalled</description>
        <field>New_Type_Request_Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>New Type Request Status - Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>New_Type_Request_Status_Rejected</fullName>
        <description>New Type Request Status - Rejected</description>
        <field>New_Type_Request_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>New Type Request Status - Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Partner_Account_Terminated_Date_Update</fullName>
        <description>Partner Account Terminated Date Update - Status = Terminated, Terminated Date is updated.</description>
        <field>Terminated_Date__c</field>
        <formula>TODAY()</formula>
        <name>Partner Account Terminated Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Account_ShippingCity</fullName>
        <description>Populate Account ShippingCity from Primary Shipping Site</description>
        <field>ShippingCity</field>
        <formula>Shipping_Site__r.City__c</formula>
        <name>Populate Account ShippingCity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Account_ShippingCountry</fullName>
        <description>Populate Account Shipping Country from Primary Shipping Site</description>
        <field>ShippingCountry</field>
        <formula>TEXT(Shipping_Site__r.Country__c)</formula>
        <name>Populate Account ShippingCountry</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Account_ShippingPostalCode</fullName>
        <description>Populate Account  Shipping Zip from Primary Shipping Site</description>
        <field>ShippingPostalCode</field>
        <formula>Shipping_Site__r.Zip__c</formula>
        <name>Populate Account ShippingPostalCode</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Account_ShippingState</fullName>
        <description>Populate Account Shipping state from from Primary Shipping Site</description>
        <field>ShippingState</field>
        <formula>Shipping_Site__r.State__c</formula>
        <name>Populate Account ShippingState</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Account_ShippingStreet</fullName>
        <description>Populate Account Shipping Street from Primary Shipping Site</description>
        <field>ShippingStreet</field>
        <formula>Shipping_Site__r.Address1__c &amp; IF(NOT(ISNULL(Shipping_Site__r.Address2__c)), &quot; &quot; &amp; Shipping_Site__r.Address2__c, &quot;&quot;)&amp;  IF(NOT(ISNULL(Shipping_Site__r.Address3__c)), &quot; &quot; &amp; Shipping_Site__r.Address3__c, &quot;&quot;)</formula>
        <name>Populate Account ShippingStreet</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Run_Origination_Docs_Uncheck_Update</fullName>
        <field>Run_Origination_Docs_Trigger__c</field>
        <literalValue>0</literalValue>
        <name>Run Origination Docs Uncheck Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Subscription_Date_Update</fullName>
        <field>Subscription_Date__c</field>
        <formula>NOW()</formula>
        <name>Subscription Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateDealerOptout_fld</fullName>
        <field>Dealer_Locator_Opt_Out__c</field>
        <literalValue>1</literalValue>
        <name>UpdateDealerOptout_fld</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Allow_all_to_view_opportunities</fullName>
        <field>Allow_all_to_view_Opportunities__c</field>
        <literalValue>1</literalValue>
        <name>Update Allow all to view opportunities</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Default_Oracle_Account_Type</fullName>
        <field>Oracle_Account_Type__c</field>
        <literalValue>R</literalValue>
        <name>Update Default Oracle Account Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Default_Oracle_Classification</fullName>
        <field>Oracle_Customer_Classification__c</field>
        <literalValue>LEASE_CUSTOMER</literalValue>
        <name>Update Default Oracle Classification</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Default_Oracle_Operating_Unit</fullName>
        <field>Oracle_Operating_Unit__c</field>
        <literalValue>SPEB OU</literalValue>
        <name>Update Default Oracle Operating Unit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Default_Oracle_Order_Type</fullName>
        <field>Oracle_Order_Type__c</field>
        <literalValue>SPEB RVAR Lease 2</literalValue>
        <name>Update Default Oracle Order Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Default_Oracle_Payment_Terms</fullName>
        <field>Oracle_Payment_Terms__c</field>
        <literalValue>45 NET</literalValue>
        <name>Update Default Oracle Payment Terms</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Default_Oracle_Sales_Channel</fullName>
        <field>Oracle_Sales_Channel__c</field>
        <literalValue>RVAR LEASE</literalValue>
        <name>Update Default Oracle Sales Channel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Executives_view_all_Opportunities</fullName>
        <field>Executives_view_all_Opportunities__c</field>
        <literalValue>1</literalValue>
        <name>Update Executives view all Opportunities</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Theater_North_America</fullName>
        <field>Theater__c</field>
        <literalValue>North America</literalValue>
        <name>Update Theater North America</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>updatepartneractivateddatetime</fullName>
        <field>Partner_Activated_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Update Partner Activated Date Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Access to SunPower Systems - 24 Hours</fullName>
        <actions>
            <name>partnerrequiresaccesstosunpowersystems</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.SunPower_System_Access_24_Hour_Alert__c</field>
            <operation>equals</operation>
            <value>YES</value>
        </criteriaItems>
        <description>Access to SunPower Systems - 24 Hours.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Access to SunPower Systems - 48 Hours</fullName>
        <actions>
            <name>partnerrequiresaccesstosunpowersystems</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.SunPower_System_Access_48_Hour_Alert__c</field>
            <operation>equals</operation>
            <value>YES</value>
        </criteriaItems>
        <description>Access to SunPower Systems - 48 Hours.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Access to SunPower Systems - 72 Hours</fullName>
        <actions>
            <name>partnerrequiresaccesstosunpowersystems</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.SunPower_System_Access_72_Hour_Alert__c</field>
            <operation>equals</operation>
            <value>YES</value>
        </criteriaItems>
        <description>Access to SunPower Systems - 72 Hours.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Account Phone US Prefix Workflow</fullName>
        <actions>
            <name>Account_Phone_US_Prefix</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Case# 00616615 - Five9 Screen-Pop not working in EMEA (and maybe APAC) - Arokia Nathan</description>
        <formula>OR (  AND(ISNEW() ,NOT(ISBLANK(Phone))),  AND(NOT(ISNEW()), ISCHANGED(Phone))  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account Status to Active</fullName>
        <actions>
            <name>Provide_SmartStore_Access_Send_Partner_Welcome_Pack</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Send_Echosign_Request_to_add_Partner_email_domain_to_safellist</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>MRC_Access_Welcome_Pack</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Country_Domain__c</field>
            <operation>equals</operation>
            <value>rvar-us,cvar-us,combo-us</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>notEqual</operation>
            <value>Residential – SSE</value>
        </criteriaItems>
        <description>Made for On-boarding improvements</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Add Partner as MQC Partner in Oracle</fullName>
        <actions>
            <name>Add_Partner_as_MQC_Partner_in_Oracle</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.MultiQuarter_Contract_Participant__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Add Partner as MQC Partner in Oracle</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Add Partner as Monitor Promotion Participant</fullName>
        <actions>
            <name>Add_this_this_Monitor_Promotion_Participant_in_Oracle</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Monitor_Promotion_Participant__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Add Partner as Monitor Promotion Participant in Oracle</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Alert on MQC1%2FMQC2 Participant Update</fullName>
        <actions>
            <name>Alert_on_MQC1_MQC2_Participant_Update</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Alert on MQC1/MQC2 Participant Update.</description>
        <formula>(( ISCHANGED( MQC1_Multi_Quarter_Contract_Participant__c )  &amp;&amp;  MQC1_Multi_Quarter_Contract_Participant__c ) || ( ISCHANGED( MQC2_Multi_Quarter_Contract_Participant__c )  &amp;&amp;  MQC2_Multi_Quarter_Contract_Participant__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Bypass Data%2Ecom Clean</fullName>
        <actions>
            <name>Clean_Status_Skipped</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Residential Customer,Partner,Other,Bank Guarantee,Without Bank Guarantee,Infrastructure Account,FR Partner,FR Residential Customer,Person Account,Standard Person Account</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.CleanStatus</field>
            <operation>notEqual</operation>
            <value>Skipped</value>
        </criteriaItems>
        <description>This rules sets the clean status field to skipped for all non commercial records that don&apos;t have a clean status of skipped.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Check if Partner Opted Out of Ok To Ship</fullName>
        <actions>
            <name>Check_Opted_Out_of_Ok_To_Ship_Once</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Check if Partner Opted Out of Ok To Ship</description>
        <formula>AND(Opted_out_of_Ok_To_Ship_Once__c = FALSE, ISCHANGED(Partner_Opt_Out_Ok_To_Ship__c),ISPICKVAL($User.UserType,&apos;PowerPartner&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Clear Theater</fullName>
        <actions>
            <name>Clear_Theater</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.BillingCountry</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Clear Theater.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Credit On Hold</fullName>
        <actions>
            <name>Send_email_alert_to_RSM_when_account_credit_is_put_on_hold</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Credit_Hold__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>When credit is put on hold for the Account</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lease Tool Access Creation Notification</fullName>
        <actions>
            <name>Lease_Tool_Access_Creation_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Lease2_0_Program_Partner__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Lease Tool Access Creation Notification</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lease2-Update to Lease Account</fullName>
        <actions>
            <name>Update_Default_Oracle_Account_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Default_Oracle_Classification</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Default_Oracle_Operating_Unit</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Default_Oracle_Order_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Default_Oracle_Payment_Terms</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Default_Oracle_Sales_Channel</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Residential Customer</value>
        </criteriaItems>
        <description>This Workflow will update the OU and other Oracle related fields when the Lease flag is checked.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notification on Account Type%26Status update</fullName>
        <actions>
            <name>Notification_to_Pricing_Team_when_Partner_Type_gets_updated</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Notification to Prcing Admin when account type was changed for Partner record</description>
        <formula>AND(OR(ISCHANGED( Type ), ISCHANGED( Status__c )), ( ISPICKVAL(Theater__c, &quot;Europe&quot;)), (RecordType.DeveloperName  = &quot;Partner&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Online Ordering is Enabled</fullName>
        <actions>
            <name>Online_Ordering_is_enabled</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Online_Order_Access__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner</value>
        </criteriaItems>
        <description>Online Ordering is Enabled</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Partner Account Terminated Date Update</fullName>
        <actions>
            <name>Partner_Terminated_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Partner_Account_Terminated_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>equals</operation>
            <value>Terminated</value>
        </criteriaItems>
        <description>Partner Account Terminated Date Update - Status = Terminated, Terminated Date is updated.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Partner Activated</fullName>
        <actions>
            <name>updatepartneractivateddatetime</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>accesstosunpowersystems</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>welcomekitfornewpartner</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Authorized_Partner_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Partner Assigned to a Territory</fullName>
        <actions>
            <name>partnerassignedtoaterritory</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Territory_Assigned__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Partner Created</fullName>
        <actions>
            <name>Update_Executives_view_all_Opportunities</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PartnerPortal%26OnlineOrder-AU</fullName>
        <actions>
            <name>Provide_Partner_Portal_access_enable_Online_Ordering_AU</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Oracle_Account_Number__c</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Country_Domain__c</field>
            <operation>equals</operation>
            <value>combo-au,rvar-au,cvar-au</value>
        </criteriaItems>
        <description>Enable Partner Portal access &amp; Online Ordering for Country Domains (combo-au, rvar-au, cvar-au)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PartnerPortal%26OnlineOrder-BeEsUkRl</fullName>
        <actions>
            <name>Provide_Partner_Portal_access_enable_Online_Ordering_BeEsUkRl</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Oracle_Account_Number__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Country_Domain__c</field>
            <operation>equals</operation>
            <value>rvar-uk,combo-be,combo-es,rvar-es,rvar-rl,cvar-es,cvar-be,cvar-uk,combo-rl,cvar-rl,combo-uk,rvar-be</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <description>Enable Partner Portal access &amp; Online Ordering for Country Domains (&apos;rvar-be&apos;,&apos;cvar-be&apos;,&apos;combo-be&apos;,&apos;rvar-es&apos;,&apos;cvar-es&apos;,&apos;combo-es&apos; ,&apos;rvar-uk&apos;,&apos;cvar-uk&apos;,&apos;combo-uk&apos;,&apos;combo-rl&apos;, &apos;cvar-rl&apos;,&apos;rvar-rl&apos;)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PartnerPortal-OnlineOrder-SmartStore-ItDeFr</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Oracle_Account_Number__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Country_Domain__c</field>
            <operation>equals</operation>
            <value>combo-fr,cvar-it,rvar-fr,cvar-de,rvar-it,rvar-de,combo-it,cvar-fr,combo-de</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <description>Enable Partner Portal access &amp; Online Ordering for Country Domains (&apos;rvar-it&apos;,&apos;cvar-it&apos;,&apos;combo-it&apos;,&apos;rvar-de&apos;,&apos;cvar-de&apos;,&apos;combo-de&apos;,&apos;rvar-fr&apos;,&apos;cvar-fr&apos;,&apos;combo-fr&apos;)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Populate Account ShippingAddress</fullName>
        <actions>
            <name>Populate_Account_ShippingCity</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Populate_Account_ShippingCountry</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Populate_Account_ShippingPostalCode</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Populate_Account_ShippingState</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Populate_Account_ShippingStreet</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populate Account ShippingAddress from the Primary Shipping Site that&apos;s selected</description>
        <formula>AND (
 RecordType.Name = &apos;Partner&apos;,
 OR ( (AND (ISNEW(), Not(ISNULL(Shipping_Site__c)))),
   AND( ISCHANGED (Shipping_Site__c), NOT(ISNULL(Shipping_Site__c)))
   ),
   NOT(ISBLANK(Shipping_Site__c)) 
   )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Provide Partner Portal access %26 enable Online Ordering</fullName>
        <actions>
            <name>Provide_Partner_Portal_access_enable_Online_Ordering</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Oracle_Account_Number__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Country_Domain__c</field>
            <operation>equals</operation>
            <value>rvar-us,cvar-us,combo-us</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Provide Partner Portal access &amp; enable Online Ordering</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Run Origination Docs Uncheck</fullName>
        <actions>
            <name>Run_Origination_Docs_Uncheck_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Run_Origination_Docs_Trigger__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Status Equals Active for AUS country domain</fullName>
        <actions>
            <name>Send_Partner_Starter_Kit</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Send_Partner_Welcome_Kit</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Country_Domain__c</field>
            <operation>contains</operation>
            <value>combo-au,rvar-au,cvar-au</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Status Equals Active for AUS country domain</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Status Equals Active for BE country domain</fullName>
        <actions>
            <name>Send_Partner_Starter_Kit</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Send_Partner_Welcome_Kit</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Country_Domain__c</field>
            <operation>contains</operation>
            <value>cvar-be,combo-be,rvar-be</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Status Equals Active for BE country domain</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Status Equals Active for IT and De Country Domain</fullName>
        <actions>
            <name>Send_Partner_Starter_Kit</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Send_Partner_Welcome_Kit</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Country_Domain__c</field>
            <operation>contains</operation>
            <value>combo-fr,rvar-de,rvar-fr,cvar-de,combo-de,cvar-fr</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Status Equals Active for IT and De Country Domain</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Status Equals Active for Spain%2C Aus%2C Italy%2C %2B UK</fullName>
        <actions>
            <name>Send_Partner_Starter_Kit</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Send_Partner_Welcome_Kit</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Country_Domain__c</field>
            <operation>contains</operation>
            <value>combo-au,cvar-it,rvar-uk,rvar-es,combo-es,rvar-it,rvar-au,combo-it,cvar-au,cvar-es,cvar-uk,combo-uk</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Status Equals Active for Spain, Aus, Italy, + UK</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Status Equals Active for Spain%2C Aus%2C Italy%2C %2B UK%2C %2BRL</fullName>
        <actions>
            <name>Send_Partner_Starter_Kit</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Send_Partner_Welcome_Kit</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Country_Domain__c</field>
            <operation>contains</operation>
            <value>rvar-es,rvar-it,rvar-rl,cvar-au,combo-uk,combo-au,rvar-uk,cvar-it,combo-es,combo-it,cvar-es,cvar-uk,combo-rl,cvar-rl</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Status Equals Active for Spain, Aus, Italy, + UK ,+RL</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Subscription Date</fullName>
        <actions>
            <name>Subscription_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Send_PDF_Notification__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Subscription_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Theater North America</fullName>
        <actions>
            <name>Update_Theater_North_America</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Theater__c</field>
            <operation>equals</operation>
            <value>NA</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UpdateDealerOptout</fullName>
        <actions>
            <name>UpdateDealerOptout_fld</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Lead_Flow_opt_out__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Update Dealer Locator opt Our field to true if Lead flow opt out is true.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>MRC_Access_Welcome_Pack</fullName>
        <assignedTo>beverly.villanueva@sunpowercorp.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>MRC Access | Welcome Pack</subject>
    </tasks>
    <tasks>
        <fullName>Provide_Partner_Portal_access_enable_Online_Ordering</fullName>
        <assignedTo>ma.cristina.deborja@sunpowercorp.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Please enable online ordering . Thanks</description>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Provide Partner Portal Access &amp; Enable Online Ordering</subject>
    </tasks>
    <tasks>
        <fullName>Provide_Partner_Portal_access_enable_Online_Ordering_AU</fullName>
        <assignedTo>liezl.panaligan@sunpowercorp.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Please Provide Partner Portal access &amp; enable Online Ordering. Thank You Partner Experience.</description>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Provide Partner Portal access &amp; enable Online Ordering</subject>
    </tasks>
    <tasks>
        <fullName>Provide_Partner_Portal_access_enable_Online_Ordering_BeEsUkRl</fullName>
        <assignedTo>annclaire.grandclaude@sunpowercorp.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Please Provide Partner Portal access &amp; enable Online Ordering. Thank You Partner Experience.</description>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Provide Partner Portal access &amp; enable Online Ordering</subject>
    </tasks>
    <tasks>
        <fullName>Send_Partner_Starter_Kit</fullName>
        <assignedTo>richelle.saule@sunpowercorp.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>&apos;Please Send Partner Welcome Kit ’.Thank You Partner Experience.</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Send Welcome Kit</subject>
    </tasks>
    <tasks>
        <fullName>Send_Partner_Welcome_Kit</fullName>
        <assignedTo>jeremy.sibug@sunpowercorp.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>&apos;Please Send Partner Welcome Kit ’.Thank You Partner Experience</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Send Welcome Kit</subject>
    </tasks>
    <tasks>
        <fullName>Send_Partner_Welcome_Kit_AU</fullName>
        <assignedTo>richelle.saule@sunpowercorp.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>&apos;Please Send Partner Welcome Kit ’.Thank You.</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Send Partner Welcome Kit</subject>
    </tasks>
    <tasks>
        <fullName>Send_Partner_Welcome_Kit_UK_IT_SP_AU</fullName>
        <assignedTo>jeremy.sibug@sunpowercorp.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>&apos;Please Send Partner Welcome Kit ’.Thank You Partner Experience</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Send Partner Welcome Kit - UK, IT, SP, AU</subject>
    </tasks>
    <tasks>
        <fullName>accesstosunpowersystems</fullName>
        <assignedTo>ITHelpDeskManager</assignedTo>
        <assignedToType>role</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Access to SunPower Systems</subject>
    </tasks>
    <tasks>
        <fullName>welcomekitfornewpartner</fullName>
        <assignedTo>MarketingManager</assignedTo>
        <assignedToType>role</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Welcome Kit for New Partner</subject>
    </tasks>
</Workflow>
