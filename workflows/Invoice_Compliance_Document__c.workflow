<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ICD_Install_Invoice_Approved_TPS</fullName>
        <ccEmails>ThirdpartyInvoices@sunpowercorp.com;salesforcearchives@sunpowercorp.com</ccEmails>
        <description>ICD Install Invoice Approved - TPS</description>
        <protected>false</protected>
        <recipients>
            <field>Invoice_Document_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ICD_Email_Template_Folder/ICD_Install_Invoice_Approved_TPS</template>
    </alerts>
    <alerts>
        <fullName>ICD_Interconnect_Invoice_Approved_TPS</fullName>
        <ccEmails>ThirdpartyInvoices@sunpowercorp.com;salesforcearchives@sunpowercorp.com</ccEmails>
        <description>ICD Interconnect Invoice Approved - TPS</description>
        <protected>false</protected>
        <recipients>
            <field>Invoice_Document_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ICD_Email_Template_Folder/ICD_Interconnect_Invoice_Approved_TPS</template>
    </alerts>
    <alerts>
        <fullName>ICD_Invoice_Document_Proceed</fullName>
        <description>ICD Invoice Document Proceed</description>
        <protected>false</protected>
        <recipients>
            <field>Oracle_Vendor_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ICD_Email_Template_Folder/ICD_Invoice_Document_Proceed</template>
    </alerts>
    <alerts>
        <fullName>ICD_Invoice_Document_Rejection_email_sent_to_Partner</fullName>
        <ccEmails>leasepaymentinquiry@sunpowercorp.com</ccEmails>
        <description>ICD Invoice Document Rejection email sent to Partner</description>
        <protected>false</protected>
        <recipients>
            <field>Invoice_Document_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ICD_Email_Template_Folder/ICD_Invoice_Document_Rejected</template>
    </alerts>
    <alerts>
        <fullName>ICD_Invoice_Document_Rejection_email_sent_to_Partner_TPS</fullName>
        <ccEmails>ThirdpartyInvoices@sunpowercorp.com</ccEmails>
        <description>ICD Invoice Document Rejection email sent to Partner - TPS</description>
        <protected>false</protected>
        <recipients>
            <field>Invoice_Document_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ICD_Email_Template_Folder/ICD_Invoice_Document_Rejected</template>
    </alerts>
    <alerts>
        <fullName>ICD_Invoice_Documents_Documents_in_File_Notification</fullName>
        <ccEmails>salesforcearchives@sunpowercorp.com</ccEmails>
        <description>ICD Invoice Documents Documents in File Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Invoice_Document_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ICD_Email_Template_Folder/ICD_Invoice_Document_Document_in_File_Notification_template</template>
    </alerts>
    <alerts>
        <fullName>ICD_Origination_Invoice_Approved_TPS</fullName>
        <ccEmails>ThirdpartyInvoices@sunpowercorp.com;salesforcearchives@sunpowercorp.com</ccEmails>
        <description>ICD Origination Invoice Approved - TPS</description>
        <protected>false</protected>
        <recipients>
            <field>Invoice_Document_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ICD_Email_Template_Folder/ICD_Origination_Invoice_Approved_TPS</template>
    </alerts>
    <alerts>
        <fullName>ICD_Permit_Received_Invoice_Approved_TPS</fullName>
        <ccEmails>ThirdpartyInvoices@sunpowercorp.com;salesforcearchives@sunpowercorp.com</ccEmails>
        <description>ICD Permit Received Invoice Approved - TPS</description>
        <protected>false</protected>
        <recipients>
            <field>Invoice_Document_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ICD_Email_Template_Folder/ICD_Permit_Received_Invoice_Approved_TPS</template>
    </alerts>
    <outboundMessages>
        <fullName>DocumentUploadToInformatica</fullName>
        <apiVersion>40.0</apiVersion>
        <endpointUrl>https://ps1w2-obm.rt.informaticacloud.com/active-bpel/services/REST/SalesforceNotificationRESTPort?processName=UploadPermitsToMosaic</endpointUrl>
        <fields>Financial_Payment__c</fields>
        <fields>Id</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>sysuser@sunpower.com</integrationUser>
        <name>DocumentUploadToInformatica</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>ICD Install Invoice Approval Email - TPS</fullName>
        <actions>
            <name>ICD_Install_Invoice_Approved_TPS</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND ( Financial_Payment__r.RecordType.DeveloperName = &apos;TPS&apos;, TEXT(Program__c) = &apos;TPS&apos;, TEXT(Invoice_Type__c) = &apos;Install&apos;, Approved_Notification__c = true )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ICD Interconnect Invoice Approved - TPS</fullName>
        <actions>
            <name>ICD_Interconnect_Invoice_Approved_TPS</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND ( Financial_Payment__r.RecordType.DeveloperName = &apos;TPS&apos;,        TEXT(Program__c) = &apos;TPS&apos;,        TEXT(Invoice_Type__c) = &apos;Interconnect&apos;,        Approved_Notification__c = true,  OR ( TEXT(Document_Owner__c) != &apos;IP&apos;,       AND ( TEXT(Document_Owner__c) = &apos;IP&apos;,       TEXT(Financial_Payment__r.SPVT_Result__c) = &apos;Pass&apos; )     )  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ICD Invoice Document - Documents in File Notification</fullName>
        <actions>
            <name>ICD_Invoice_Documents_Documents_in_File_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(     OR(         AND(ISPICKVAL(Documents_in_File__c,&apos;Countersigned Rebate Reservation&apos;),            OR(State__c = &apos;CA&apos;,State__c = &apos;VT&apos;)           ),        AND(ISPICKVAL(Documents_in_File__c,&apos;Countersigned SREC Reservation Form&apos;),State__c = &apos;NJ&apos;),        AND(ISPICKVAL(Documents_in_File__c,&apos;Interconnect Agreement&apos;),State__c = &apos;CO&apos;)      ),     ISPICKVAL(PRIORVALUE(Status__c),&apos;Not Submitted&apos;),     ISPICKVAL(Status__c,&apos;Pending&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ICD Invoice Document Proceed</fullName>
        <actions>
            <name>ICD_Invoice_Document_Proceed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Invoice_Compliance_Document__c.Documents_in_File__c</field>
            <operation>equals</operation>
            <value>Confirmed ICF</value>
        </criteriaItems>
        <criteriaItems>
            <field>Invoice_Compliance_Document__c.Status__c</field>
            <operation>equals</operation>
            <value>Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ICD Invoice Document Rejection Email</fullName>
        <actions>
            <name>ICD_Invoice_Document_Rejection_email_sent_to_Partner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(    ISPICKVAL(Status__c, &apos;Rejected&apos;),    $User.ByPassValidation__c = False,    Financial_Payment__r.RecordType.DeveloperName  &lt;&gt; &apos;TPS&apos;   )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ICD Invoice Document Rejection Email - TPS</fullName>
        <actions>
            <name>ICD_Invoice_Document_Rejection_email_sent_to_Partner_TPS</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(        ISPICKVAL(Status__c, &apos;Rejected&apos;),        $User.ByPassValidation__c = False,        Financial_Payment__r.RecordType.DeveloperName = &apos;TPS&apos;     )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ICD NotificationToInformaticaOnDocumentApproval</fullName>
        <actions>
            <name>DocumentUploadToInformatica</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>System will notify the Informatica on approval of certain document. Informatica will pick those document and upload to Mosaic to overcome apex heap limit of 12 mb.</description>
        <formula>AND(    OR(        ISPICKVAL(Documents_in_File__c,&apos;Photos&apos;),        ISPICKVAL(Documents_in_File__c,&apos;PTO Letter&apos;),        ISPICKVAL(Documents_in_File__c,&apos;Final Permit&apos;)      ),    ISPICKVAL(Status__c,&apos;Approved&apos;),    Financial_Payment__r.FinancingType__c = &apos;Loan&apos;  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ICD Origination Invoice Approved - TPS</fullName>
        <actions>
            <name>ICD_Origination_Invoice_Approved_TPS</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND (       Financial_Payment__r.RecordType.DeveloperName = &apos;TPS&apos;,       TEXT(Program__c) = &apos;TPS&apos;,       TEXT(Invoice_Type__c) = &apos;Origination&apos;,       Approved_Notification__c = true      )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ICD Permit Received Invoice Approved - TPS</fullName>
        <actions>
            <name>ICD_Permit_Received_Invoice_Approved_TPS</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND (       Financial_Payment__r.RecordType.DeveloperName = &apos;TPS&apos;,       TEXT(Program__c) = &apos;TPS&apos;,       TEXT(Invoice_Type__c) = &apos;Permit Received&apos;,       Approved_Notification__c = true      )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
