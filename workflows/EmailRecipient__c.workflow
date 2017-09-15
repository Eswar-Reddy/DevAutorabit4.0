<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Alert_for_e_invoice_notification</fullName>
        <ccEmails>salesforcearchives@sunpowercorp.com</ccEmails>
        <description>Email Alert for e-invoice notification</description>
        <protected>false</protected>
        <recipients>
            <field>Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>invoicing@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SOA2/PDF_Notification_new</template>
    </alerts>
    <fieldUpdates>
        <fullName>SOA_ChildCommunicationSentUpdate</fullName>
        <field>Communication_Sent__c</field>
        <literalValue>1</literalValue>
        <name>SOA ChildCommunicationSentUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SOA2TransactionEmailRecipientSendEmail</fullName>
        <actions>
            <name>Email_Alert_for_e_invoice_notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>SOA_ChildCommunicationSentUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow to send the eInvoice Email to Customers on Insert or Update of the record</description>
        <formula>OR ( 	AND 	(		                          NOT(SOA2TransactionDetail__r.Communication_Sent__c),   		NOT(Communication_Sent__c),  		NOT(ISBLANK(Contact_Email__c)) 	),  	AND 	( 		SOA2TransactionDetail__r.Communication_Sent__c,   		NOT(Communication_Sent__c),  		NOT(ISBLANK(Contact_Email__c)) 	) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
