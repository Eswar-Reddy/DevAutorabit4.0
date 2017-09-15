<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>IP_PC_for_Complete_Design_Package</fullName>
        <description>IP, PC for Complete Design Package</description>
        <protected>false</protected>
        <recipients>
            <recipient>IP</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Project Coordinator</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SSE_Direct_Sales/TPS_Document_Upload</template>
    </alerts>
    <alerts>
        <fullName>TPS_Email_to_ICT_for_Commissioning_Report</fullName>
        <ccEmails>invoice_compliance@sunpower.com</ccEmails>
        <description>TPS-Email to ICT for Commissioning Report</description>
        <protected>false</protected>
        <recipients>
            <recipient>apanganiban2@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SSE_Direct_Sales/TPS_Document_Upload</template>
    </alerts>
    <alerts>
        <fullName>TPS_Email_to_IP</fullName>
        <description>TPS- Email to IP</description>
        <protected>false</protected>
        <recipients>
            <recipient>IP</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SSE_Direct_Sales/TPS_Document_Upload</template>
    </alerts>
    <alerts>
        <fullName>TPS_Email_to_PC_IP_TPS_for_PTO</fullName>
        <description>TPS-Email to PC, IP, TPS for PTO</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <recipient>IP</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Project Coordinator</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SSE_Direct_Sales/TPS_Document_Upload</template>
    </alerts>
    <alerts>
        <fullName>TPS_Email_to_PM_IP_for_Final_Permit</fullName>
        <description>TPS-Email to PM, IP for Final Permit</description>
        <protected>false</protected>
        <recipients>
            <recipient>IP</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Project Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SSE_Direct_Sales/TPS_Document_Upload</template>
    </alerts>
    <alerts>
        <fullName>TPS_Email_to_PSR_ICT_for_Signed_Inspection_Card</fullName>
        <ccEmails>lease_compliance@sunpower.com</ccEmails>
        <description>TPS-Email to PSR, ICT for Signed Inspection Card</description>
        <protected>false</protected>
        <recipients>
            <recipient>apanganiban2@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SSE_Direct_Sales/TPS_Document_Upload</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_AccIdWithDocumentType</fullName>
        <description>It&apos;s field updated to put Lease Number + documentType on a unique field. By doing this, We can make documentType unique for a particular Quote/Lease. It&apos;s created to avoid the custom trigger coding and test classes to cover that.</description>
        <field>Opportunity_Document__c</field>
        <formula>Quote__r.Consolidated_Lease_Number__c + &apos;-&apos; + Text(Document_Type__c)</formula>
        <name>Update AccIdWithDocumentType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>TPS-Email to ICT for Commissioning</fullName>
        <actions>
            <name>TPS_Email_to_ICT_for_Commissioning_Report</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Document__c.Document_Type__c</field>
            <operation>equals</operation>
            <value>Commissioning Report</value>
        </criteriaItems>
        <description>TPS:email to PSR, ICT after Commissioning document is uploaded.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>TPS-Email to IP for Shading</fullName>
        <actions>
            <name>TPS_Email_to_IP</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Document__c.Document_Type__c</field>
            <operation>equals</operation>
            <value>Shading Report/Solar Census</value>
        </criteriaItems>
        <description>TPS:email to IP after shading document is uploaded</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>TPS-Email to IP-PC forComplete Design Package</fullName>
        <actions>
            <name>IP_PC_for_Complete_Design_Package</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Document__c.Document_Type__c</field>
            <operation>equals</operation>
            <value>Complete Design Package</value>
        </criteriaItems>
        <description>TPS:email to PC, IP after Complete Design Package document is uploaded</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>TPS-Email to IP-PC-TPS for PTO</fullName>
        <actions>
            <name>TPS_Email_to_PC_IP_TPS_for_PTO</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Document__c.Document_Type__c</field>
            <operation>equals</operation>
            <value>PTO</value>
        </criteriaItems>
        <description>TPS:email to PM, IP after PTO document is uploaded</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>TPS-Email to IP-PM for Final Permit</fullName>
        <actions>
            <name>TPS_Email_to_PM_IP_for_Final_Permit</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Document__c.Document_Type__c</field>
            <operation>equals</operation>
            <value>Final Permit</value>
        </criteriaItems>
        <description>TPS:email to PM, IP after Final Permit document is uploaded</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>TPS-Email to PSR-ICT for Signed Inspection</fullName>
        <actions>
            <name>TPS_Email_to_PSR_ICT_for_Signed_Inspection_Card</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Document__c.Document_Type__c</field>
            <operation>equals</operation>
            <value>Signed Inspection Card</value>
        </criteriaItems>
        <description>TPS:email to PSR, ICT after Signed Inspection Card document is uploaded</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update AccId%2BDocumentType on Unique field</fullName>
        <actions>
            <name>Update_AccIdWithDocumentType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>It&apos;s workflow a update the Lease Number + documentType on a unique field.  By doing this, We can make documentType unique for a particular Opportunity.</description>
        <formula>AND(INCLUDES(Opportunity__r.Partner_Account_Id__r.NH_SSE_Type__c,&apos;TPS&apos;),OR(ISNEW(),ISCHANGED(Document_Type__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
