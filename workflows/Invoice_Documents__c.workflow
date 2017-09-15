<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Install_Invoice_Approved_TPS</fullName>
        <ccEmails>ThirdpartyInvoices@sunpowercorp.com;salesforcearchives@sunpowercorp.com</ccEmails>
        <description>Install Invoice Approved - TPS</description>
        <protected>false</protected>
        <recipients>
            <field>Invoice_Document_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Invoice_Document/Install_Invoice_Approved_TPS</template>
    </alerts>
    <alerts>
        <fullName>Interconnect_Invoice_Approved_TPS</fullName>
        <ccEmails>ThirdpartyInvoices@sunpowercorp.com;salesforcearchives@sunpowercorp.com</ccEmails>
        <description>Interconnect Invoice Approved - TPS</description>
        <protected>false</protected>
        <recipients>
            <field>Invoice_Document_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Invoice_Document/Interconnect_Invoice_Approved_TPS</template>
    </alerts>
    <alerts>
        <fullName>Invoice_Document_Proceed</fullName>
        <description>Invoice Document Proceed</description>
        <protected>false</protected>
        <recipients>
            <field>Oracle_Vendor_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Invoice_Document/Invoice_Document_Proceed</template>
    </alerts>
    <alerts>
        <fullName>Invoice_Document_Rejection_email_sent_to_Partner</fullName>
        <ccEmails>leasepaymentinquiry@sunpowercorp.com</ccEmails>
        <description>Invoice Document Rejection email sent to Partner</description>
        <protected>false</protected>
        <recipients>
            <field>Invoice_Document_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Invoice_Document_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Invoice_Document_Rejection_email_sent_to_Partner_TPS</fullName>
        <ccEmails>ThirdpartyInvoices@sunpowercorp.com</ccEmails>
        <description>Invoice Document Rejection email sent to Partner - TPS</description>
        <protected>false</protected>
        <recipients>
            <field>Invoice_Document_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Invoice_Document_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Invoice_Documents_Countersigned_Rebate_Application_MA</fullName>
        <ccEmails>salesforcearchives@sunpowercorp.com</ccEmails>
        <description>Invoice Documents Countersigned Rebate Application - MA</description>
        <protected>false</protected>
        <recipients>
            <field>Invoice_Document_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lease/Invoice_Documents_Countersigned_Rebate_Application_MA</template>
    </alerts>
    <alerts>
        <fullName>Invoice_Documents_Countersigned_Rebate_Application_VT</fullName>
        <ccEmails>salesforcearchives@sunpowercorp.com</ccEmails>
        <description>Invoice Documents Countersigned Rebate Application - VT</description>
        <protected>false</protected>
        <recipients>
            <field>Invoice_Document_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Invoice_Document/Invoice_Documents_Countersigned_Rebate_Application_VT</template>
    </alerts>
    <alerts>
        <fullName>Invoice_Documents_Countersigned_Rebate_Reservation_CA</fullName>
        <ccEmails>salesforcearchives@sunpowercorp.com</ccEmails>
        <description>Invoice Documents Countersigned Rebate Reservation - CA</description>
        <protected>false</protected>
        <recipients>
            <field>Invoice_Document_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lease/Invoice_Documents_Countersigned_Rebate_Application_CA</template>
    </alerts>
    <alerts>
        <fullName>Invoice_Documents_Countersigned_SREC_Reservation_Form_NJ</fullName>
        <ccEmails>salesforcearchives@sunpowercorp.com</ccEmails>
        <description>Invoice Documents Countersigned SREC Reservation Form - NJ</description>
        <protected>false</protected>
        <recipients>
            <field>Invoice_Document_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lease/Invoice_Documents_Countersigned_SREC_Registration_NJ</template>
    </alerts>
    <alerts>
        <fullName>Invoice_Documents_Countersigned_Schedule_A_NJ</fullName>
        <ccEmails>salesforcearchives@sunpowercorp.com</ccEmails>
        <description>Invoice Documents Countersigned Schedule A - NJ</description>
        <protected>false</protected>
        <recipients>
            <field>Invoice_Document_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lease/Invoice_Documents_Countersigned_Schedule_A_NJ</template>
    </alerts>
    <alerts>
        <fullName>Invoice_Documents_SREC_Certification_Number_NJ</fullName>
        <ccEmails>salesforcearchives@sunpowercorp.com</ccEmails>
        <description>Invoice Documents SREC Certification Number - NJ</description>
        <protected>false</protected>
        <recipients>
            <field>Invoice_Document_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lease/Invoice_Documents_SREC_Certification_Number_NJ</template>
    </alerts>
    <alerts>
        <fullName>Origination_Invoice_Approved_TPS</fullName>
        <ccEmails>ThirdpartyInvoices@sunpowercorp.com;salesforcearchives@sunpowercorp.com</ccEmails>
        <description>Origination Invoice Approved - TPS</description>
        <protected>false</protected>
        <recipients>
            <field>Invoice_Document_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Invoice_Document/Origination_Invoice_Approved_TPS</template>
    </alerts>
    <alerts>
        <fullName>Permit_Received_Invoice_Approved_TPS</fullName>
        <ccEmails>ThirdpartyInvoices@sunpowercorp.com;salesforcearchives@sunpowercorp.com</ccEmails>
        <description>Permit Received Invoice Approved - TPS</description>
        <protected>false</protected>
        <recipients>
            <field>Invoice_Document_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Invoice_Document/Permit_Received_Invoice_Approved_TPS</template>
    </alerts>
    <fieldUpdates>
        <fullName>Last_Install_Doc_Submitted_Update</fullName>
        <field>Last_Install_Doc_Submission__c</field>
        <formula>TODAY()</formula>
        <name>Last Install Doc Submitted Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Lease_Payment__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Last_Interconnect_Doc_Submitted_Update</fullName>
        <field>Last_Interconnect_Doc_Submission__c</field>
        <formula>TODAY()</formula>
        <name>Last Interconnect Doc Submitted Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Lease_Payment__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Response_Date_Stamp</fullName>
        <field>Response_Date__c</field>
        <formula>TODAY()</formula>
        <name>Response Date Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Email_Field</fullName>
        <field>Invoice_Document_Email__c</field>
        <formula>Lease_Payment__r.Partner_Account__r.Invoice_Document_Email__c</formula>
        <name>Update Email Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Invoice_Document_Email</fullName>
        <field>Invoice_Document_Email__c</field>
        <formula>IF(ISPICKVAL( Program__c,&apos;TPS&apos;), Responsible_Partner__r.Invoice_Document_Email__c,Lease_Payment__r.Partner_Account__r.Invoice_Document_Email__c)</formula>
        <name>Update Invoice Document Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Oracle_Vendor_Email</fullName>
        <description>Update Oracle Vendor Email</description>
        <field>Oracle_Vendor_Email__c</field>
        <formula>IF(ISPICKVAL( Program__c,&apos;TPS&apos;),  Responsible_Partner__r.Oracle_Vendor_Email__c , Oracle_Vendor_Email_Formula__c)</formula>
        <name>Update Oracle Vendor Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>DocumentUploadToInformatica</fullName>
        <apiVersion>37.0</apiVersion>
        <endpointUrl>https://ps1w2-obm.rt.informaticacloud.com/active-bpel/services/REST/SalesforceNotificationRESTPort?processName=UploadPermitsToMosaic</endpointUrl>
        <fields>Id</fields>
        <fields>Lease_Payment__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>sysuser@sunpower.com</integrationUser>
        <name>DocumentUploadToInformatica</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Install Invoice Approval Email - TPS</fullName>
        <actions>
            <name>Install_Invoice_Approved_TPS</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND (   Lease_Payment__r.RecordType.DeveloperName = &apos;TPS&apos;,   TEXT(Program__c) = &apos;TPS&apos;,   TEXT(Invoice_Type__c) = &apos;Install&apos;,    Approved_Notification__c = true )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Interconnect Invoice Approved - TPS</fullName>
        <actions>
            <name>Interconnect_Invoice_Approved_TPS</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND (   Lease_Payment__r.RecordType.DeveloperName = &apos;TPS&apos;,   TEXT(Program__c) = &apos;TPS&apos;,   TEXT(Invoice_Type__c) = &apos;Interconnect&apos;,    Approved_Notification__c = true,   OR (     TEXT(Document_Owner__c) != &apos;IP&apos;,     AND (       TEXT(Document_Owner__c) = &apos;IP&apos;,       TEXT(Lease_Payment__r.SPVT_Result__c) = &apos;Pass&apos;     )    ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Invoice Document Proceed</fullName>
        <actions>
            <name>Invoice_Document_Proceed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Invoice_Documents__c.Documents_in_File__c</field>
            <operation>equals</operation>
            <value>Confirmed ICF</value>
        </criteriaItems>
        <criteriaItems>
            <field>Invoice_Documents__c.Status__c</field>
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
        <fullName>Invoice Document Rejection Email</fullName>
        <actions>
            <name>Invoice_Document_Rejection_email_sent_to_Partner</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Email_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Invoice_Documents__c.Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
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
        <fullName>Invoice Document Rejection Email - TPS</fullName>
        <actions>
            <name>Invoice_Document_Rejection_email_sent_to_Partner_TPS</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Invoice_Document_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Invoice_Documents__c.Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>TPS</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Invoice Documents Countersigned Rebate Application - MA</fullName>
        <actions>
            <name>Invoice_Documents_Countersigned_Rebate_Application_MA</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Invoice Documents Countersigned Rebate Application - MA</description>
        <formula>ISPICKVAL(Documents_in_File__c,&apos;Countersigned Rebate Application&apos;) &amp;&amp; State__c=&apos;MA&apos; &amp;&amp; ISPICKVAL(PRIORVALUE(Status__c),&apos;Not Submitted&apos;) &amp;&amp; ISPICKVAL(Status__c,&apos;Pending&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Invoice Documents Countersigned Rebate Reservation - CA</fullName>
        <actions>
            <name>Invoice_Documents_Countersigned_Rebate_Reservation_CA</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Documents_in_File__c,&apos;Countersigned Rebate Reservation&apos;)  &amp;&amp; State__c=&apos;CA&apos;  &amp;&amp; ISPICKVAL(PRIORVALUE(Status__c),&apos;Not Submitted&apos;)  &amp;&amp; ISPICKVAL(Status__c,&apos;Pending&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Invoice Documents Countersigned Rebate Reservation - VT</fullName>
        <actions>
            <name>Invoice_Documents_Countersigned_Rebate_Application_VT</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Documents_in_File__c,&apos;Countersigned Rebate Reservation&apos;) &amp;&amp; State__c=&apos;VT&apos; &amp;&amp; ISPICKVAL(PRIORVALUE(Status__c),&apos;Not Submitted&apos;) &amp;&amp; ISPICKVAL(Status__c,&apos;Pending&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Invoice Documents Countersigned SREC Reservation Form - NJ</fullName>
        <actions>
            <name>Invoice_Documents_Countersigned_SREC_Reservation_Form_NJ</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Invoice Documents Countersigned SREC Reservation Form - NJ</description>
        <formula>ISPICKVAL(Documents_in_File__c,&apos;Countersigned SREC Reservation Form&apos;) &amp;&amp; State__c=&apos;NJ&apos; &amp;&amp; ISPICKVAL(PRIORVALUE(Status__c),&apos;Not Submitted&apos;) &amp;&amp; ISPICKVAL(Status__c,&apos;Pending&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Invoice Documents Countersigned Schedule A - NJ</fullName>
        <actions>
            <name>Invoice_Documents_Countersigned_Schedule_A_NJ</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Sangita deactivated based on Melisssa&apos;s input for SREC requirement</description>
        <formula>ISPICKVAL(Documents_in_File__c,&apos;Countersigned Schedule A&apos;) &amp;&amp; State__c=&apos;NJ&apos; &amp;&amp; ISPICKVAL(PRIORVALUE(Status__c),&apos;Not Submitted&apos;) &amp;&amp; ISPICKVAL(Status__c,&apos;Pending&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Invoice Documents Interconnect Agreement - CO</fullName>
        <active>true</active>
        <formula>ISPICKVAL(Documents_in_File__c,&apos;Interconnect Agreement&apos;)  &amp;&amp; State__c=&apos;CO&apos;  &amp;&amp; ISPICKVAL(PRIORVALUE(Status__c),&apos;Not Submitted&apos;)  &amp;&amp; ISPICKVAL(Status__c,&apos;Pending&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Invoice Documents SREC Certification Number - NJ</fullName>
        <actions>
            <name>Invoice_Documents_SREC_Certification_Number_NJ</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Sangita deactivated on Aug 1 as per Malissa&apos;s input for sREC requirements</description>
        <formula>ISPICKVAL(Documents_in_File__c,&apos;SREC Certification Number&apos;) &amp;&amp; State__c=&apos;NJ&apos; &amp;&amp; ISPICKVAL(PRIORVALUE(Status__c),&apos;Not Submitted&apos;) &amp;&amp; ISPICKVAL(Status__c,&apos;Pending&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Last Install Doc Submitted</fullName>
        <actions>
            <name>Last_Install_Doc_Submitted_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Invoice_Documents__c.Invoice_Type__c</field>
            <operation>equals</operation>
            <value>Install</value>
        </criteriaItems>
        <criteriaItems>
            <field>Invoice_Documents__c.Status__c</field>
            <operation>equals</operation>
            <value>Pending</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Last Interconnect Doc Submitted</fullName>
        <actions>
            <name>Last_Interconnect_Doc_Submitted_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Invoice_Documents__c.Invoice_Type__c</field>
            <operation>equals</operation>
            <value>Interconnect</value>
        </criteriaItems>
        <criteriaItems>
            <field>Invoice_Documents__c.Status__c</field>
            <operation>equals</operation>
            <value>Pending</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NotificationToInformaticaOnDocumentApproval</fullName>
        <actions>
            <name>DocumentUploadToInformatica</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2 OR 3) AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Invoice_Documents__c.Documents_in_File__c</field>
            <operation>equals</operation>
            <value>Photos</value>
        </criteriaItems>
        <criteriaItems>
            <field>Invoice_Documents__c.Documents_in_File__c</field>
            <operation>equals</operation>
            <value>PTO Letter</value>
        </criteriaItems>
        <criteriaItems>
            <field>Invoice_Documents__c.Documents_in_File__c</field>
            <operation>equals</operation>
            <value>Final Permit</value>
        </criteriaItems>
        <criteriaItems>
            <field>Invoice_Documents__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>LeasePayment__c.FinancingType__c</field>
            <operation>equals</operation>
            <value>Loan</value>
        </criteriaItems>
        <description>System will notify the Informatica on approval of certain document. Informatica will pick those document and upload to Mosaic to overcome apex heap limit of 12 mb.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Origination Invoice Approved - TPS</fullName>
        <actions>
            <name>Origination_Invoice_Approved_TPS</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND (   Lease_Payment__r.RecordType.DeveloperName = &apos;TPS&apos;,   TEXT(Program__c) = &apos;TPS&apos;,   TEXT(Invoice_Type__c) = &apos;Origination&apos;,    Approved_Notification__c = true )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Permit Received Invoice Approved - TPS</fullName>
        <actions>
            <name>Permit_Received_Invoice_Approved_TPS</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND (   Lease_Payment__r.RecordType.DeveloperName = &apos;TPS&apos;,   TEXT(Program__c) = &apos;TPS&apos;,   TEXT(Invoice_Type__c) = &apos;Permit Received&apos;,    Approved_Notification__c = true )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Response Date Creation</fullName>
        <actions>
            <name>Response_Date_Stamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Invoice_Documents__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved,Rejected</value>
        </criteriaItems>
        <description>When Lease Payments team approves or rejects an Invoice Document, today&apos;s date will be stamped in the Response Date field</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Oracle Vendor Email</fullName>
        <actions>
            <name>Update_Invoice_Document_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Oracle_Vendor_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Invoice_Documents__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
