<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Notification_to_Finance_for_Lease_Revison</fullName>
        <ccEmails>financing@sunpowercorp.com;umarathe@sunpowercorp.com;</ccEmails>
        <description>Email Notification to Finance for Lease Revison</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Template_for_Finance_when_Revised_Quote_Request_is_created</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification_to_PSR_for_Lease_Revison</fullName>
        <ccEmails>umarathe@sunpowercorp.com</ccEmails>
        <description>Email Notification to PSR for Lease Revison</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_PSR__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Template_for_PSR_when_Revised_Quote_request_is_created</template>
    </alerts>
    <alerts>
        <fullName>Email_for_Amendmend</fullName>
        <ccEmails>SunPowerLeasing@sunpowercorp.com;IreneGrace.Barachina@sunpowercorp.com;Xingni.Chen@sunpowercorp.com;lease_counter_signature@sunpowercorp.com</ccEmails>
        <description>Email for Amendment</description>
        <protected>false</protected>
        <recipients>
            <recipient>amy.hernandez@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>dongiordane.soguilon@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>johannagrace.salinog@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lavernne.ferraro@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>maicamae.juco@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>reiniel.marasigan@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Primary_PSR__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Email_Temp_for_QS_4</template>
    </alerts>
    <alerts>
        <fullName>Send_email_when_Old_Quote_Lease_Doc_is_terminated</fullName>
        <description>Send email when Old Quote Lease Doc is terminated</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_PSR__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Template_for_PSR_when_Old_Quote_is_terminated</template>
    </alerts>
    <alerts>
        <fullName>email_notification_when_2nd_Quote_is_created</fullName>
        <description>email notification when 2nd Quote Summary is created</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_PSR__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/template_when_2nd_Quote_is_created</template>
    </alerts>
    <fieldUpdates>
        <fullName>uncheck_Adhoc_create_LDA</fullName>
        <field>Adhoc_Create_LDA__c</field>
        <literalValue>0</literalValue>
        <name>uncheck Adhoc create LDA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Adhoc Create LDA</fullName>
        <actions>
            <name>uncheck_Adhoc_create_LDA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quote_Summary__c.Adhoc_Create_LDA__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Amendment Email Rule on QS</fullName>
        <actions>
            <name>Email_for_Amendmend</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quote_Summary__c.Revision_Amendment_to_Lease__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send email when 2nd Quote is updated as Revised</fullName>
        <actions>
            <name>Email_Notification_to_Finance_for_Lease_Revison</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Notification_to_PSR_for_Lease_Revison</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send email when 2nd Quote Summary is associated to old Quote Summary through Revision To field.</description>
        <formula>AND(ISCHANGED(Old_Quote__c),  Old_Quote__c &lt;&gt; NULL)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send email when Old Quote Lease Doc is terminated</fullName>
        <actions>
            <name>Send_email_when_Old_Quote_Lease_Doc_is_terminated</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send email when Old Quote is terminated by checking the &quot;Lease Doc Terminated&quot; checkbox</description>
        <formula>IF(AND(Lease_Doc_Terminated__c,  New_Quote_Lease_Number__c &lt;&gt;NULL),true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
