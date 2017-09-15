<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Alert_Promised_Date_Entered_Changed</fullName>
        <ccEmails>jessica.rice@sunpowercorp.com</ccEmails>
        <ccEmails>mendel.salvacion@sunpowercorp.com</ccEmails>
        <description>Alert: Promised Date Entered/Changed</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PSR/Alert_Promised_Date_Entered_Changed</template>
    </alerts>
    <alerts>
        <fullName>Americas_Design_Approved_Email</fullName>
        <description>Americas Design Approved Email</description>
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
            <field>Development_Engineer__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Designer__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Sales_Analyst__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PSR/Design_Approved_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>DesignDue_Email_Notification</fullName>
        <description>Design Due Email Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PSR/Design_Due_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Design_Created_Americas</fullName>
        <description>Design Created - Americas</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>deepa.ananthakrishnan@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jason.claiborne@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Development_Engineer__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Engineer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PSR/Design_Created_Notification</template>
    </alerts>
    <alerts>
        <fullName>Design_Created_UPP_Intl</fullName>
        <description>Design Created - UPP Intl</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>alfonso.sierra@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PSR/Design_Created_Notification</template>
    </alerts>
    <alerts>
        <fullName>Design_Due_Email_Notification</fullName>
        <description>Design Due Email Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PSR/Design_Due_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Design_is_verified_send_to_plot</fullName>
        <description>Design is verified - send to plot</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Designer_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Designer_2__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PSR/Design_Correct_and_Plot</template>
    </alerts>
    <alerts>
        <fullName>Email_Notifiation_sent_when_Design_Completed</fullName>
        <description>Email Notifiation sent when Design Completed Date is modified</description>
        <protected>false</protected>
        <recipients>
            <recipient>Sales Analyst</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PSR/Notification_on_change_of_Design_Completed_Date</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification_about_New_Helix_Carport_Request</fullName>
        <description>Email Notification about New Helix Carport Request</description>
        <protected>false</protected>
        <recipients>
            <recipient>CDE_Group</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>systemdesign.na@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Design/New_Helix_Design_Carport_Request_v2</template>
    </alerts>
    <alerts>
        <fullName>Final_Design_Approved_Email</fullName>
        <description>Final Design Approved Email</description>
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
        <recipients>
            <field>Sales_Analyst__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PSR/Design_Approved_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Final_Design_Email_Approval_Actions</fullName>
        <description>Final Design Email  Approval Actions</description>
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
        <template>PSR/Design_Approval_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Final_Rejection_Email</fullName>
        <description>Final Rejection Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PSR/Design_Rejection_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Helix_Design_More_Information_Needed_Alert</fullName>
        <description>Helix Design More Information Needed Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Project_Contact_Person__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>CRSM__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>CommercialPSR__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>systemdesign.na@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Design/Helix_Design_Information_Needed_Partner</template>
    </alerts>
    <alerts>
        <fullName>Helix_Design_Request_Delivered_Alert</fullName>
        <description>Helix Design Request Delivered Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Project_Contact_Person__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>CRSM__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>CommercialPSR__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>systemdesign.na@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Design/Helix_Design_Information_Needed_Partner</template>
    </alerts>
    <alerts>
        <fullName>Helix_Design_Request_in_Progress_Alert</fullName>
        <description>Helix Design Request in Progress Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Project_Contact_Person__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>CRSM__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>CommercialPSR__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>systemdesign.na@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Design/Helix_Design_Information_Needed_Partner</template>
    </alerts>
    <alerts>
        <fullName>Helix_Design_Submitted_by_Dealer_Alert</fullName>
        <description>Helix Design Submitted by Dealer Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Project_Contact_Person__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>CRSM__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>CommercialPSR__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>systemdesign.na@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Design/Helix_Design_Information_Needed_Partner</template>
    </alerts>
    <alerts>
        <fullName>Notification_to_the_Designer_when_assigned_to_a_design_record</fullName>
        <description>Notification to the Designer when assigned to a design record.</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_Email_Alerts/Design_Assignment_Email_Template_vf</template>
    </alerts>
    <alerts>
        <fullName>Notify_PSR_Owner_when_Design_Owner_is_changed</fullName>
        <description>Notify PSR Owner when Design Owner is changed</description>
        <protected>false</protected>
        <recipients>
            <field>PSR_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PSR/Design_Object_Owner_is_changed</template>
    </alerts>
    <alerts>
        <fullName>PDE_On_Design_Email_Alert</fullName>
        <description>PDE On Design Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Project_Engineer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Design/PDE_On_Design_Email_Alert</template>
    </alerts>
    <alerts>
        <fullName>PSR_Design_Updated_Notification</fullName>
        <description>PSR Design Updated Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>alfonso.sierra@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>fernando.calvoherranz@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PSR/PSR_Design_Updated_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>CompletedDesigntoPlot</fullName>
        <field>Status__c</field>
        <literalValue>Correct</literalValue>
        <name>Completed Design to Plot</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DateTime_Paused_for_Duration_Formula_blk</fullName>
        <description>Pivotal: #140441237 When I clone a design, the SLA Time fields, the Revision Of, and the Roof Design fields should be blank</description>
        <field>DateTime_Paused__c</field>
        <name>DateTime Paused for Duration Formula blk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_Paused_for_Duration_Formula_blank</fullName>
        <description>Pivotal: #140441237 When I clone a design, the SLA Time fields, the Revision Of, and the Roof Design fields should be blank</description>
        <field>Date_Paused__c</field>
        <name>Date Paused for Duration Formula blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Dealer_Status_upon_Approval</fullName>
        <description>This sets the Dealer Status field to Design Delivered upon the approval of the design.</description>
        <field>Dealer_Status__c</field>
        <literalValue>Design Delivered</literalValue>
        <name>Dealer Status upon Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Design_Approval_Submission</fullName>
        <field>Status__c</field>
        <literalValue>Awaiting Approval</literalValue>
        <name>Design Approval Submission</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Design_Complete_Date_Update</fullName>
        <description>Design Complete Date Update</description>
        <field>Date_Design_Completed__c</field>
        <formula>TODAY()</formula>
        <name>Design Complete Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Design_Completed_Date_to_blank</fullName>
        <description>Pivotal: #140441237 When I clone a design, the SLA Time fields, the Revision Of, and the Roof Design fields should be blank</description>
        <field>Design_Completed_Date__c</field>
        <name>Design Completed Date to blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Design_Negotiated_Due_Date_to_reflect</fullName>
        <description>Design &apos;Negotiated Due Date’ to reflect PSR &apos;Array layout Due&apos; date</description>
        <field>Date_of_Agreed_Delivery__c</field>
        <formula>Array_layout_Due__c</formula>
        <name>Design &apos;Negotiated Due Date’ to reflect</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Design_Object_Updated_With_Oppty_Name</fullName>
        <description>Design Object Updated With Oppty Name. Used to update hidden text field so search for oppty name will generate design results.</description>
        <field>Opportunity_Name_Hidden__c</field>
        <formula>Opportunity__r.Name</formula>
        <name>Design Object Updated With Oppty Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Design_Started_Date_to_blank</fullName>
        <description>Pivotal: #140441237 When I clone a design, the SLA Time fields, the Revision Of, and the Roof Design fields should be blank</description>
        <field>Design_Started_Date__c</field>
        <name>Design Started Date to blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Design_Status_Field_Change</fullName>
        <field>Status__c</field>
        <literalValue>Completed</literalValue>
        <name>Design Status Field Change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Design_Status_Update</fullName>
        <field>Status__c</field>
        <literalValue>In Progress</literalValue>
        <name>Design Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Design_Submitted_Date_to_blank</fullName>
        <description>Pivotal: #140441237 When I clone a design, the SLA Time fields, the Revision Of, and the Roof Design fields should be blank</description>
        <field>Design_Submitted_Date__c</field>
        <name>Design Submitted Date to blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pause_Counter_to_blank</fullName>
        <description>Pivotal: #140441237 When I clone a design, the SLA Time fields, the Revision Of, and the Roof Design fields should be blank; Setting to default value of 0.00 instead of blank/null as this is needed in Duration calculation (bug #140994891)</description>
        <field>Pause_Counter__c</field>
        <formula>0.00</formula>
        <name>Pause Counter to blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Completed_Date_and_Time</fullName>
        <description>This field update supplies a value to the Design_Completed_Date__c field of the Design object, which is an essential piece of a functionality to determine the total duration an HDR design is &quot;active&quot;. Pivotal #138459593</description>
        <field>Design_Completed_Date__c</field>
        <formula>Now()</formula>
        <name>Set Completed Date and Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Actual_System_Size</fullName>
        <field>Actual_System_Size__c</field>
        <name>Update Actual System Size</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Comments</fullName>
        <field>Comments__c</field>
        <name>Update Comments</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Design_Completed</fullName>
        <field>Date_Design_Completed__c</field>
        <name>Update Design Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Design_Completed_Date</fullName>
        <field>Date_Design_Completed__c</field>
        <formula>TODAY()</formula>
        <name>Update Design Completed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Design_Completed_Status_Cancelled</fullName>
        <description>Design Completed Updated when Status is Cancelled</description>
        <field>Date_Design_Completed__c</field>
        <formula>TODAY ()</formula>
        <name>Update Design Completed Status=Cancelled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Design_Start_Date</fullName>
        <description>Update Design Start Date to default to 75% Briefing Meeting</description>
        <field>Design_Start_Date__c</field>
        <formula>X75_Percent_Briefing_Meeting__c</formula>
        <name>Update Design Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Design_Tracking</fullName>
        <field>Design_Tracking__c</field>
        <name>Update Design Tracking</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Development_Engineer_Murat_Kara</fullName>
        <description>Update Development Engineer - Murat Karakum</description>
        <field>Development_Engineer__c</field>
        <lookupValue>murat.karakum@sunpowercorp.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Update Development Engineer - Murat Kara</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Development_Engineer_Thang_Le</fullName>
        <description>Update Development Engineer - Thang Le</description>
        <field>Development_Engineer__c</field>
        <lookupValue>thang.le@sunpowercorp.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Update Development Engineer - Thang Le</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_PDE_Americas_Andres_Acevedo</fullName>
        <description>Update Project Development Engineer -Americas- (was Andres Acevedo)</description>
        <field>Project_Engineer__c</field>
        <name>Update PDE -Americas- Nidia Barrios</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_PDE_Americas_Ryan_Phillips</fullName>
        <description>Update Project Development Engineer - Americas - Julia Davis, was Ryan Phillips
11/03/2015 was Julia Collignon</description>
        <field>Project_Engineer__c</field>
        <lookupValue>rclark@sunpower.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Update PDE -Americas- Julia Davis</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_PDE_Americas_Thang_Le</fullName>
        <description>Update Project Development Engineer -Americas- Thang Le</description>
        <field>Project_Engineer__c</field>
        <lookupValue>thang.le@sunpowercorp.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Update PDE -Americas- Thang Le</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Promised</fullName>
        <field>Date_of_Agreed_Delivery__c</field>
        <name>Update Promised</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Revision</fullName>
        <field>Revision_Letter__c</field>
        <literalValue>A</literalValue>
        <name>Update Revision</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Revision_Type</fullName>
        <field>Revision_Type__c</field>
        <literalValue>New</literalValue>
        <name>Update Revision Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Alert%3A Promised Date Entered%2FChanged</fullName>
        <actions>
            <name>Alert_Promised_Date_Entered_Changed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>send alert if change in promised date</description>
        <formula>IF($User.ByPassValidation__c == false,
AND ( $RecordType.DeveloperName = &quot;New_Homes&quot;, ISCHANGED(Date_of_Agreed_Delivery__c) ),null)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Completed Design Reviewed</fullName>
        <actions>
            <name>Design_is_verified_send_to_plot</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CompletedDesigntoPlot</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Completed Design Reviewed.</description>
        <formula>IF($User.ByPassValidation__c == false, 
AND ( $RecordType.DeveloperName = &quot;New_Homes&quot;, NOT(ISNULL( Date_Completed_Design_Reviewed__c ) ) ),null)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Design Complete Date Update</fullName>
        <actions>
            <name>Design_Complete_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Design__c.Status__c</field>
            <operation>equals</operation>
            <value>Cancelled,Completed</value>
        </criteriaItems>
        <description>Design Complete Date Update</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Design Completed Updated when Status is Cancelled</fullName>
        <actions>
            <name>Update_Design_Completed_Status_Cancelled</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Design__c.Status__c</field>
            <operation>equals</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <description>Design Completed Updated when Status is Cancelled</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Design Due Email Notification</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Design__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Proposal Design</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Workflow process that triggers an email notification to the Design Owner 1 days before the Tracking Date as a reminder that the Design is due.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>DesignDue_Email_Notification</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Design__c.Design_Tracking__c</offsetFromField>
            <timeLength>-1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Design Is Created - Americas</fullName>
        <actions>
            <name>Design_Created_Americas</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Design__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Project Design</value>
        </criteriaItems>
        <criteriaItems>
            <field>Design__c.Linked_to_PSR__c</field>
            <operation>equals</operation>
            <value>YES</value>
        </criteriaItems>
        <criteriaItems>
            <field>Design__c.Business_Unit__c</field>
            <operation>equals</operation>
            <value>NA Commercial,UPP Americas</value>
        </criteriaItems>
        <description>Design Is Created for UPPa &amp; NAC</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Design Is Created - UPPi</fullName>
        <actions>
            <name>Design_Created_UPP_Intl</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Design__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Project Design,Proposal Design</value>
        </criteriaItems>
        <criteriaItems>
            <field>Design__c.Business_Unit__c</field>
            <operation>contains</operation>
            <value>Intl</value>
        </criteriaItems>
        <criteriaItems>
            <field>Design__c.Linked_to_PSR__c</field>
            <operation>equals</operation>
            <value>YES</value>
        </criteriaItems>
        <description>Design Is Created UPPi</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Design Start Date Update - NAC</fullName>
        <actions>
            <name>Update_Design_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Design__c.Business_Unit__c</field>
            <operation>equals</operation>
            <value>NA Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Design__c.X75_Percent_Briefing_Meeting__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Design__c.Design_Start_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Design Start Date Update - NAC</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Design Updated with Oppty Name %28Text%29</fullName>
        <actions>
            <name>Design_Object_Updated_With_Oppty_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Design__c.Status__c</field>
            <operation>equals</operation>
            <value>Active,Correct,Not Started,Completed,Awaiting Approval,On Hold,Invalid,De-Activated</value>
        </criteriaItems>
        <description>Design Object Updated With Oppty Name (Text). Used to update hidden text field so search for oppty name will generate design in results.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Designer Assignment Email Notification</fullName>
        <actions>
            <name>Notification_to_the_Designer_when_assigned_to_a_design_record</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Work flow process that triggers an email notification  to the Designer when assigned to a design record</description>
        <formula>AND(     ISBLANK(DealerName__c),    NOT(  CONTAINS( TEXT(Owner:User.UserType), &apos;Partner&apos;) ),     OR(        ISNEW() ,        ISCHANGED( OwnerId )    ),     $User.Bypass_Workflow__c = false  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Email Notification on Design completion date update</fullName>
        <actions>
            <name>Email_Notifiation_sent_when_Design_Completed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>IF($User.ByPassValidation__c == false, ISCHANGED( Date_Design_Completed__c ),null)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Helix Design More Information Needed</fullName>
        <actions>
            <name>Helix_Design_More_Information_Needed_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Design__c.Dealer_Status__c</field>
            <operation>equals</operation>
            <value>More Information Needed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Design__c.HelixDesignType__c</field>
            <operation>equals</operation>
            <value>Helix Roof,Helix Tracker,Helix Carport</value>
        </criteriaItems>
        <criteriaItems>
            <field>Design__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Proposal Design</value>
        </criteriaItems>
        <criteriaItems>
            <field>Design__c.Submitted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Bypass_Workflow__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Helix Design More Information Needed
Pivotal # ##130330391</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Helix Design Request Delivered</fullName>
        <actions>
            <name>Helix_Design_Request_Delivered_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Design__c.Dealer_Status__c</field>
            <operation>equals</operation>
            <value>Design Delivered</value>
        </criteriaItems>
        <criteriaItems>
            <field>Design__c.HelixDesignType__c</field>
            <operation>equals</operation>
            <value>Helix Roof,Helix Tracker,Helix Carport</value>
        </criteriaItems>
        <criteriaItems>
            <field>Design__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Proposal Design</value>
        </criteriaItems>
        <criteriaItems>
            <field>Design__c.Submitted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Bypass_Workflow__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Helix Design Request Delivered
Pivotal # ##128905463</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Helix Design Request in Progress</fullName>
        <actions>
            <name>Helix_Design_Request_in_Progress_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Design__c.Dealer_Status__c</field>
            <operation>equals</operation>
            <value>Design In Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>Design__c.HelixDesignType__c</field>
            <operation>equals</operation>
            <value>Helix Roof,Helix Tracker,Helix Carport</value>
        </criteriaItems>
        <criteriaItems>
            <field>Design__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Proposal Design</value>
        </criteriaItems>
        <criteriaItems>
            <field>Design__c.Submitted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Bypass_Workflow__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Helix Design Request in Progress
Pivotal # ##128905427</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Helix Design Submitted</fullName>
        <actions>
            <name>Helix_Design_Submitted_by_Dealer_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Design__c.Dealer_Status__c</field>
            <operation>equals</operation>
            <value>Request Under Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Design__c.HelixDesignType__c</field>
            <operation>equals</operation>
            <value>Helix Roof,Helix Tracker,Helix Carport</value>
        </criteriaItems>
        <criteriaItems>
            <field>Design__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Proposal Design</value>
        </criteriaItems>
        <criteriaItems>
            <field>Design__c.Submitted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Pivotal # #131830345 :Dealer: Submitted Design</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify PSR Owner when Design Owner is changed</fullName>
        <actions>
            <name>Notify_PSR_Owner_when_Design_Owner_is_changed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND (   NOT($User.ByPassValidation__c),   ISCHANGED(OwnerId) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PSR Design Updated Notification</fullName>
        <actions>
            <name>PSR_Design_Updated_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND (   NOT($User.ByPassValidation__c),   PSR__r.Business_Unit__c == &apos;UPP Intl&apos;,   NOT(ISNEW()) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Proposal Design Cloned</fullName>
        <actions>
            <name>DateTime_Paused_for_Duration_Formula_blk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Date_Paused_for_Duration_Formula_blank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Design_Completed_Date_to_blank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Design_Started_Date_to_blank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Design_Submitted_Date_to_blank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Pause_Counter_to_blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Design__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Proposal Design</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Pivotal: #140441237 When I clone a design, the SLA Time fields, the Revision Of, and the Roof Design fields should be blank
Extension of workflow Proposal Design Created: There is a max of 10 field updates per wf</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Proposal Design Created</fullName>
        <actions>
            <name>Update_Comments</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Design_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Design_Tracking</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Revision</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Revision_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Design__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Proposal Design</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send Email to CDE on New HDR Carport</fullName>
        <actions>
            <name>Email_Notification_about_New_Helix_Carport_Request</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends an email notification to the CDE group when a new HDR Carport request comes in.</description>
        <formula>AND (   NOT($User.ByPassValidation__c),     ISPICKVAL(HelixDesignType__c, &apos;Helix Carport&apos;),      ISPICKVAL(Design_Originated_by__c, &apos;Request&apos;),      NOT(ISBLANK(Design_Submitted_Date__c)),      ISPICKVAL(Dealer_Status__c, &apos;Request Under Review&apos;),        ISCHANGED(Dealer_Status__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Development Engineer - Murat Karakum</fullName>
        <actions>
            <name>Update_Development_Engineer_Murat_Kara</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Design__c.Development_Engineer_PSR__c</field>
            <operation>contains</operation>
            <value>Karakum</value>
        </criteriaItems>
        <description>Update Development Engineer - Murat Karakum</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Development Engineer - Thang Le</fullName>
        <actions>
            <name>Update_Development_Engineer_Thang_Le</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Design__c.Development_Engineer_PSR__c</field>
            <operation>equals</operation>
            <value>Le</value>
        </criteriaItems>
        <description>Update Development Engineer - Thang Le</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Project Development Engineer - Carport - Americas</fullName>
        <actions>
            <name>PDE_On_Design_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_PDE_Americas_Thang_Le</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 AND 2) or (1 AND 3)</booleanFilter>
        <criteriaItems>
            <field>Design__c.Product_Family_Mounting_System__c</field>
            <operation>contains</operation>
            <value>Carport</value>
        </criteriaItems>
        <criteriaItems>
            <field>Design__c.Business_Unit__c</field>
            <operation>equals</operation>
            <value>NA Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Design__c.Business_Unit__c</field>
            <operation>equals</operation>
            <value>UPP Americas</value>
        </criteriaItems>
        <description>Update Project Development Engineer - Carport - Americas</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Project Development Engineer - Ground - Americas</fullName>
        <actions>
            <name>PDE_On_Design_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_PDE_Americas_Andres_Acevedo</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 AND 2) or (1 AND 3)</booleanFilter>
        <criteriaItems>
            <field>Design__c.Product_Family_Mounting_System__c</field>
            <operation>contains</operation>
            <value>Ground</value>
        </criteriaItems>
        <criteriaItems>
            <field>Design__c.Business_Unit__c</field>
            <operation>equals</operation>
            <value>NA Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Design__c.Business_Unit__c</field>
            <operation>equals</operation>
            <value>UPP Americas</value>
        </criteriaItems>
        <description>Update Project Development Engineer - Ground - Americas</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Project Development Engineer - Roof - Americas</fullName>
        <actions>
            <name>PDE_On_Design_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_PDE_Americas_Ryan_Phillips</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 AND 2) or (1 AND 3)</booleanFilter>
        <criteriaItems>
            <field>Design__c.Product_Family_Mounting_System__c</field>
            <operation>contains</operation>
            <value>Roof</value>
        </criteriaItems>
        <criteriaItems>
            <field>Design__c.Business_Unit__c</field>
            <operation>equals</operation>
            <value>NA Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Design__c.Business_Unit__c</field>
            <operation>equals</operation>
            <value>UPP Americas</value>
        </criteriaItems>
        <description>Update Project Development Engineer - Roof - Americas</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
