<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Purchase_Order_Submission</fullName>
        <description>Purchase Order Submission</description>
        <protected>false</protected>
        <recipients>
            <field>DSR_PO_Group_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Assigned_DSR__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Assigned_RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>customercare@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Purchase_Orders/PurchaseOrderSubmittedTemplateNew</template>
    </alerts>
    <alerts>
        <fullName>Purchase_Order_Submission_Error</fullName>
        <description>Purchase Order Submission Error</description>
        <protected>false</protected>
        <recipients>
            <field>DSR_PO_Group_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Assigned_DSR__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>customercare@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Purchase_Orders/PurchaseOrderErrorTemplateNew</template>
    </alerts>
    <alerts>
        <fullName>Purchase_Order_Submission_Mid_Bavaria_Germany_Region</fullName>
        <ccEmails>Sunpower5psr@sunpowercorp.com</ccEmails>
        <ccEmails>Malouella.ricardo@sunpowercorp.com</ccEmails>
        <description>Purchase Order Submission Mid Bavaria Germany Region</description>
        <protected>false</protected>
        <recipients>
            <field>DSR_PO_Group_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Assigned_DSR__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Assigned_RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>customercare@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Purchase_Orders/PurchaseOrderSubmittedTemplateNew</template>
    </alerts>
    <alerts>
        <fullName>Purchase_Order_Submission_Mid_Bavaria_Germany_Region_Error</fullName>
        <ccEmails>Sunpower5psr@sunpowercorp.com</ccEmails>
        <ccEmails>Malouella.ricardo@sunpowercorp.com</ccEmails>
        <description>Purchase Order Submission Mid Bavaria Germany Region Error</description>
        <protected>false</protected>
        <recipients>
            <field>DSR_PO_Group_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Assigned_DSR__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>customercare@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Purchase_Orders/PurchaseOrderErrorTemplateNew</template>
    </alerts>
    <alerts>
        <fullName>Purchase_Order_Submission_North_Germany_Region</fullName>
        <ccEmails>Sunpower1psr@sunpowercorp.com</ccEmails>
        <ccEmails>Malouella.ricardo@sunpowercorp.com</ccEmails>
        <description>Purchase Order Submission North Germany Region</description>
        <protected>false</protected>
        <recipients>
            <field>DSR_PO_Group_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Assigned_DSR__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Assigned_RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>customercare@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Purchase_Orders/PurchaseOrderSubmittedTemplateNew</template>
    </alerts>
    <alerts>
        <fullName>Purchase_Order_Submission_North_Germany_Region_Error</fullName>
        <ccEmails>Sunpower1psr@sunpowercorp.com</ccEmails>
        <ccEmails>Malouella.ricardo@sunpowercorp.com</ccEmails>
        <description>Purchase Order Submission North Germany Region Error</description>
        <protected>false</protected>
        <recipients>
            <field>DSR_PO_Group_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Assigned_DSR__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>customercare@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Purchase_Orders/PurchaseOrderErrorTemplateNew</template>
    </alerts>
    <alerts>
        <fullName>Send_an_email_when_FR_PO_is_created</fullName>
        <ccEmails>Sunpowerprime.psr@sunpowercorp.com</ccEmails>
        <description>Send an email when FR PO is created</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/template_for_action_when_PO_is_created</template>
    </alerts>
    <alerts>
        <fullName>Send_an_email_when_PO_is_created</fullName>
        <description>Send an email when PO is created</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_DSR__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/template_for_action_when_PO_is_created</template>
    </alerts>
    <fieldUpdates>
        <fullName>Default_PO_OK_To_Ship_To_HOLD</fullName>
        <description>Default Purchase Order&apos;s OK To Ship value to &apos;HOLD&apos;</description>
        <field>OK_To_Ship__c</field>
        <literalValue>HOLD</literalValue>
        <name>Default PO OK To Ship To HOLD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Default_PO_OK_To_Ship_To_SKIP</fullName>
        <description>Default Purchase Oder&apos;s Ok To Ship to SKIP</description>
        <field>OK_To_Ship__c</field>
        <literalValue>SKIP</literalValue>
        <name>Default PO OK To Ship To SKIP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PurchaseOrder_Booked_Date</fullName>
        <field>Order_Booked_Date__c</field>
        <formula>Now()</formula>
        <name>PurchaseOrder Booked Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PurchaseOrder_Submitted_Date</fullName>
        <field>Order_Submit_Date__c</field>
        <formula>NOW()</formula>
        <name>PurchaseOrder Submitted Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateInterfaceMessage</fullName>
        <field>InterfaceMessage__c</field>
        <formula>LEFT(Order_Status_Interface_Message__c, 255)</formula>
        <name>UpdateInterfaceMessage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Financier_Changed</fullName>
        <field>Financier_Changed__c</field>
        <literalValue>1</literalValue>
        <name>Update Financier Changed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lease_Number_Dup_field</fullName>
        <description>Update Lease Number (Dup ) field</description>
        <field>Lease_Number_Dup__c</field>
        <formula>Lease_Number__c</formula>
        <name>Update Lease Number (Dup ) field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_the_PO_Number</fullName>
        <field>Name</field>
        <formula>Lease_Number__c</formula>
        <name>Update the PO Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Lease2 - PO Submit Rule</fullName>
        <actions>
            <name>Update_the_PO_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Purchase_Order__c.Order_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Purchase_Order__c.Dealer_Fees__c</field>
            <operation>greaterThan</operation>
            <value>USD 0</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.FirstName</field>
            <operation>notContain</operation>
            <value>DataMigration</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PO Booked Status</fullName>
        <actions>
            <name>PurchaseOrder_Booked_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Purchase_Order__c.Oracle_Order_Status__c</field>
            <operation>equals</operation>
            <value>Booked</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.FirstName</field>
            <operation>notContain</operation>
            <value>Datamigration</value>
        </criteriaItems>
        <description>Update the PO Booked Date 
 when Oracle Order Status = Booked</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PO Entered Status</fullName>
        <actions>
            <name>PurchaseOrder_Submitted_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Purchase_Order__c.Oracle_Order_Status__c</field>
            <operation>equals</operation>
            <value>Entered</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.FirstName</field>
            <operation>notContain</operation>
            <value>Datamigration</value>
        </criteriaItems>
        <description>Update the PO Submitted Date fields 
  when Oracle Order Status = Entered</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PO Partner Ok To Ship Opt In</fullName>
        <actions>
            <name>Default_PO_OK_To_Ship_To_HOLD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Check if Partner Opted in for Ok To Ship</description>
        <formula>Dealer_Account__r.Partner_Opt_Out_Ok_To_Ship__c  = FALSE &amp;&amp; OR(ISPICKVAL(Dealer_Account__r.Country_Domain__c,&apos;rvar-us&apos;),ISPICKVAL(Dealer_Account__r.Country_Domain__c,&apos;combo-us&apos;))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PO Partner Ok To Ship Opt Out</fullName>
        <actions>
            <name>Default_PO_OK_To_Ship_To_SKIP</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Check if Partner Opted out of Ok To Ship</description>
        <formula>Dealer_Account__r.Partner_Opt_Out_Ok_To_Ship__c = TRUE &amp;&amp; OR(ISPICKVAL(Dealer_Account__r.Country_Domain__c,&apos;rvar-us&apos;),ISPICKVAL(Dealer_Account__r.Country_Domain__c,&apos;combo-us&apos;))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PurchaseOrderErrorMidBavariaRegionGermanyRule</fullName>
        <actions>
            <name>Purchase_Order_Submission_Mid_Bavaria_Germany_Region_Error</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Purchase_Order__c.Order_Status__c</field>
            <operation>equals</operation>
            <value>Error</value>
        </criteriaItems>
        <criteriaItems>
            <field>Purchase_Order__c.Account_Territory__c</field>
            <operation>equals</operation>
            <value>Bavaria Mid-Germany region</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.FirstName</field>
            <operation>notContain</operation>
            <value>Datamigration</value>
        </criteriaItems>
        <description>When a PO submission to Sunpower results in an error, will need to send alerts to parties: 
-To a SunPower DSR group email alias 
-To the Primary DSR assigned to the partner account 
-To the RSM for the assigned partner account</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PurchaseOrderErrorNorthGermanyRegionRule</fullName>
        <actions>
            <name>Purchase_Order_Submission_North_Germany_Region_Error</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Purchase_Order__c.Order_Status__c</field>
            <operation>equals</operation>
            <value>Error</value>
        </criteriaItems>
        <criteriaItems>
            <field>Purchase_Order__c.Account_Territory__c</field>
            <operation>equals</operation>
            <value>North Germany region</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.FirstName</field>
            <operation>notContain</operation>
            <value>Datamigration</value>
        </criteriaItems>
        <description>When a PO submission to Sunpower results in an error, will need to send alerts to parties: 
-To a SunPower DSR group email alias 
-To the Primary DSR assigned to the partner account 
-To the RSM for the assigned partner account</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PurchaseOrderErrorRule</fullName>
        <actions>
            <name>Purchase_Order_Submission_Error</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3) AND 4</booleanFilter>
        <criteriaItems>
            <field>Purchase_Order__c.Order_Status__c</field>
            <operation>equals</operation>
            <value>Error</value>
        </criteriaItems>
        <criteriaItems>
            <field>Purchase_Order__c.Account_Territory__c</field>
            <operation>equals</operation>
            <value>Other region</value>
        </criteriaItems>
        <criteriaItems>
            <field>Purchase_Order__c.Account_Territory__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User.FirstName</field>
            <operation>notContain</operation>
            <value>DataMigration</value>
        </criteriaItems>
        <description>When a PO submission to Sunpower results in an error, will need to send alerts to parties: 
-To a SunPower DSR group email alias 
-To the Primary DSR assigned to the partner account 
-To the RSM for the assigned partner account</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PurchaseOrderSubmissionMidBavariaRegionGermanyRule</fullName>
        <actions>
            <name>Purchase_Order_Submission_Mid_Bavaria_Germany_Region</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Purchase_Order__c.Order_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Purchase_Order__c.Account_Territory__c</field>
            <operation>equals</operation>
            <value>Bavaria Mid-Germany region</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.FirstName</field>
            <operation>notContain</operation>
            <value>Datamigration</value>
        </criteriaItems>
        <description>When a PO is submitted to SPwr will need to sending alerts to parties: 
-The partner user who placed the order 
-To a SunPower DSR group email alias 
-To the Primary DSR assigned to the partner account 
-To the RSM for the assigned partner account</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PurchaseOrderSubmissionNorthGermanyRegionRule</fullName>
        <actions>
            <name>Purchase_Order_Submission_North_Germany_Region</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Purchase_Order__c.Order_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Purchase_Order__c.Account_Territory__c</field>
            <operation>equals</operation>
            <value>North Germany region</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.FirstName</field>
            <operation>notContain</operation>
            <value>Datamigration</value>
        </criteriaItems>
        <description>When a PO is submitted to SPwr will need to sending alerts to parties: 
-The partner user who placed the order 
-To a SunPower DSR group email alias 
-To the Primary DSR assigned to the partner account 
-To the RSM for the assigned partner account</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PurchaseOrderSubmissionRule</fullName>
        <actions>
            <name>Purchase_Order_Submission</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 3 AND 4 AND (2 OR 5)</booleanFilter>
        <criteriaItems>
            <field>Purchase_Order__c.Order_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Purchase_Order__c.Account_Territory__c</field>
            <operation>equals</operation>
            <value>Other region</value>
        </criteriaItems>
        <criteriaItems>
            <field>Purchase_Order__c.Lease__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.FirstName</field>
            <operation>notContain</operation>
            <value>DataMigration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Purchase_Order__c.Account_Territory__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>When a PO is submitted to SPwr will need to sending alerts to parties: 
-The partner user who placed the order 
-To a SunPower DSR group email alias 
-To the Primary DSR assigned to the partner account 
-To the RSM for the assigned partner account</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send an email when FR PO is created</fullName>
        <actions>
            <name>Send_an_email_when_FR_PO_is_created</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send an email when PO is created</description>
        <formula>AND (   NOT(ISNULL(Quote__c)) ,    Quote__r.Is_Locked__c,     Quote__r.Lease_Doc_Signed__c,  NOT( CONTAINS( $User.FirstName, &quot;Datamigration&quot;)), IF(Quote__r.Account_Billing_Country__c == &apos;France&apos;,true,false))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send email when PO is created</fullName>
        <actions>
            <name>Send_an_email_when_PO_is_created</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This rule will Send an email when a new PO is created.</description>
        <formula>AND ( NOT(ISNULL(Quote__c)) , Quote__r.Is_Locked__c, Quote__r.Lease_Doc_Signed__c, NOT( CONTAINS( $User.FirstName, &quot;Datamigration&quot;)), IF(Quote__r.Account_Billing_Country__c &lt;&gt; &apos;France&apos;,true,false) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Financier Changed Checkbox</fullName>
        <actions>
            <name>Update_Financier_Changed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Financier__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Lease Number %28Dup%29 field</fullName>
        <actions>
            <name>Update_Lease_Number_Dup_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Purchase_Order__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update Lease Number (Dup) field</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UpdateInterfaceMessage</fullName>
        <actions>
            <name>UpdateInterfaceMessage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This rule is used to update the Interface Message field that in turn is tracked by history so we can capture the data which is helpful in troubleshooting SOA/Oracle issues.</description>
        <formula>ISCHANGED(Order_Status_Interface_Message__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
