<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CAReceived</fullName>
        <description>CAReceived</description>
        <protected>false</protected>
        <recipients>
            <field>Partner_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>customercare@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Account/OB_Credit_Application_Acknowledgement</template>
    </alerts>
    <alerts>
        <fullName>Credit_Application_Approved_Email_Alert</fullName>
        <description>Credit Application Approved Email Alert</description>
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
        <senderAddress>customercare@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Credit_Application/Credit_Application_Has_Been_Approved_NA</template>
    </alerts>
    <alerts>
        <fullName>Credit_Application_Approved_Email_Alert_EU_Belgium_Dutch</fullName>
        <description>Credit Application Approved Email Alert - EU (Belgium-Dutch)</description>
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
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sunpowerbelgique@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Credit_Application/EU_Credit_Application_Approved_Belgium_Dutch</template>
    </alerts>
    <alerts>
        <fullName>Credit_Application_Approved_Email_Alert_EU_Belgium_French</fullName>
        <description>Credit Application Approved Email Alert - EU (Belgium-French)</description>
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
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sunpowerbelgique@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Credit_Application/EU_Credit_Application_Approved_Belgium_French</template>
    </alerts>
    <alerts>
        <fullName>Credit_Application_Approved_Email_Alert_EU_English</fullName>
        <description>Credit Application Approved Email Alert - EU (English)</description>
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
        <senderAddress>sunpoweruk@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Credit_Application/Credit_Application_Has_Been_Approved_NA</template>
    </alerts>
    <alerts>
        <fullName>Credit_Application_Approved_Email_Alert_EU_French</fullName>
        <description>Credit Application Approved Email Alert - EU (French)</description>
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
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>solarfr@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Credit_Application/EU_Credit_Application_Approved_French</template>
    </alerts>
    <alerts>
        <fullName>Credit_Application_Approved_Email_Alert_EU_German</fullName>
        <description>Credit Application Approved Email Alert - EU (German)</description>
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
            <recipient>simona.orofino@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>solarde@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Credit_Application/EU_Credit_Application_Approved_German</template>
    </alerts>
    <alerts>
        <fullName>Credit_Application_Approved_Email_Alert_EU_Italian</fullName>
        <description>Credit Application Approved Email Alert - EU (Italian)</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>katia.bertelli@sunpowercorp.com</recipient>
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
        <senderAddress>solarit@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Credit_Application/EU_Credit_Application_Approved_Italian</template>
    </alerts>
    <alerts>
        <fullName>Credit_Application_Approved_Email_Alert_EU_Spanish</fullName>
        <description>Credit Application Approved Email Alert - EU (Spanish)</description>
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
        <senderAddress>solaresp@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Credit_Application/EU_Credit_Application_Approved_Spanish</template>
    </alerts>
    <alerts>
        <fullName>Credit_Application_Approved_Email_Alert_NA</fullName>
        <ccEmails>lilibeth.magpantay@sunpowercorp.com;</ccEmails>
        <ccEmails>rose.ilagan-maravilla@sunpowercorp.com;</ccEmails>
        <ccEmails>aisa.roxas@sunpowercorp.com</ccEmails>
        <description>Credit Application Approved Email Alert - NA</description>
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
        <senderAddress>customercare@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Credit_Application/Credit_Application_Has_Been_Approved_NA</template>
    </alerts>
    <alerts>
        <fullName>Credit_Application_Has_Been_Recalled_NA</fullName>
        <description>Credit Application Has Been Recalled - NA</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>customercare@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Credit_Application/Credit_Application_Has_Been_Recalled_NA</template>
    </alerts>
    <alerts>
        <fullName>Credit_Application_Has_Been_Rejected_EU_Belgium_Dutch</fullName>
        <description>Credit Application Has Been Rejected - EU(Belgium-Dutch)</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sunpowerbelgique@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Credit_Application/EU_Credit_Application_Declined_Belgium_Dutch</template>
    </alerts>
    <alerts>
        <fullName>Credit_Application_Has_Been_Rejected_EU_Belgium_French</fullName>
        <description>Credit Application Has Been Rejected - EU(Belgium-French)</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sunpowerbelgique@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Credit_Application/EU_Credit_Application_Declined_Belgium_French</template>
    </alerts>
    <alerts>
        <fullName>Credit_Application_Has_Been_Rejected_EU_English</fullName>
        <description>Credit Application Has Been Rejected - EU(English)</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sunpoweruk@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Credit_Application/Credit_Application_Has_Been_Rejected_NA</template>
    </alerts>
    <alerts>
        <fullName>Credit_Application_Has_Been_Rejected_EU_French</fullName>
        <description>Credit Application Has Been Rejected - EU(French)</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>solarfr@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Credit_Application/EU_Credit_Application_Declined_French</template>
    </alerts>
    <alerts>
        <fullName>Credit_Application_Has_Been_Rejected_EU_German</fullName>
        <description>Credit Application Has Been Rejected - EU(German)</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>solarde@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Credit_Application/EU_Credit_Application_Declined_German</template>
    </alerts>
    <alerts>
        <fullName>Credit_Application_Has_Been_Rejected_EU_Italian</fullName>
        <description>Credit Application Has Been Rejected - EU(Italian)</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>solarit@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Credit_Application/EU_Credit_Application_Declined_Italian</template>
    </alerts>
    <alerts>
        <fullName>Credit_Application_Has_Been_Rejected_EU_Spanish</fullName>
        <description>Credit Application Has Been Rejected - EU(Spanish)</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>solaresp@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Credit_Application/EU_Credit_Application_Declined_Spanish</template>
    </alerts>
    <alerts>
        <fullName>Credit_Application_Has_Been_Rejected_NA</fullName>
        <description>Credit Application Has Been Rejected - NA</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Credit_Application/Credit_Application_Has_Been_Rejected_NA</template>
    </alerts>
    <alerts>
        <fullName>Credit_Application_In_Progress_Belgium_Dutch</fullName>
        <description>Credit Application In Progress - Belgium -Dutch</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
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
        <template>Credit_Application/EU_Credit_Application_Received_Belgium_Dutch</template>
    </alerts>
    <alerts>
        <fullName>Credit_Application_In_Progress_Belgium_French</fullName>
        <description>Credit Application In Progress - Belgium -French</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
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
        <template>Credit_Application/EU_Credit_Application_Received_Belgium_French</template>
    </alerts>
    <alerts>
        <fullName>Credit_Application_In_Progress_English</fullName>
        <description>Credit Application In Progress - English</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sunpoweruk@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Credit_Application/Credit_Application_Received_D_English</template>
    </alerts>
    <alerts>
        <fullName>Credit_Application_In_Progress_French</fullName>
        <description>Credit Application In Progress - French</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>solarfr@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Credit_Application/EU_Credit_Application_Received_D_French</template>
    </alerts>
    <alerts>
        <fullName>Credit_Application_In_Progress_German</fullName>
        <description>Credit Application In Progress - German</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>anke.frers@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>simona.orofino@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>solarde@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Credit_Application/EU_Credit_Application_Received_D_German</template>
    </alerts>
    <alerts>
        <fullName>Credit_Application_In_Progress_Italian</fullName>
        <description>Credit Application In Progress - Italian</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>solarit@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Credit_Application/EU_Credit_Application_Received_D_Italian</template>
    </alerts>
    <alerts>
        <fullName>Credit_Application_In_Progress_Spanish</fullName>
        <description>Credit Application In Progress - Spanish</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>solaresp@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Credit_Application/EU_Credit_Application_Received_D_Spanish</template>
    </alerts>
    <alerts>
        <fullName>Credit_Application_Missing_Documentation_English</fullName>
        <description>Credit Application Missing Documentation - English</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sunpoweruk@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Credit_Application/Credit_Application_Miss_Info_English</template>
    </alerts>
    <alerts>
        <fullName>EU_Credit_Application_Missing_Documentation_Belgium_Dutch</fullName>
        <description>EU Credit Application Missing Documentation - Belgium-Dutch</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sunpowerbelgique@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Credit_Application/EU_Credit_Application_Miss_Info_Belgium_Dutch</template>
    </alerts>
    <alerts>
        <fullName>EU_Credit_Application_Missing_Documentation_Belgium_French</fullName>
        <description>EU Credit Application Missing Documentation - Belgium-French</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sunpowerbelgique@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Credit_Application/EU_Credit_Application_Miss_Info_Belgium_French</template>
    </alerts>
    <alerts>
        <fullName>EU_Credit_Application_Missing_Documentation_French</fullName>
        <description>EU Credit Application Missing Documentation - French</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>solarfr@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Credit_Application/EU_Credit_Application_Miss_Info_French</template>
    </alerts>
    <alerts>
        <fullName>EU_Credit_Application_Missing_Documentation_German</fullName>
        <description>EU Credit Application Missing Documentation - German</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>solarde@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Credit_Application/EU_Credit_Application_Miss_Info_German</template>
    </alerts>
    <alerts>
        <fullName>EU_Credit_Application_Missing_Documentation_Italian</fullName>
        <description>EU Credit Application Missing Documentation - Italian</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>solarit@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Credit_Application/EU_Credit_Application_Miss_Info_Italian</template>
    </alerts>
    <alerts>
        <fullName>EU_Credit_Application_Missing_Documentation_Spanish</fullName>
        <description>EU Credit Application Missing Documentation - Spanish</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>solaresp@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Credit_Application/EU_Credit_Application_Miss_Info_Spanish</template>
    </alerts>
    <alerts>
        <fullName>Notify_RSM_when_credit_application_is_created_EU</fullName>
        <ccEmails>credit@sunpowercorp.com</ccEmails>
        <description>Notify RSM when credit application is created - EU</description>
        <protected>false</protected>
        <recipients>
            <recipient>alexandre.policarpopinheiro@sunpowercorp.com</recipient>
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
        <template>Credit_Application/Credit_Application_Submitted</template>
    </alerts>
    <alerts>
        <fullName>Notify_RSM_when_credit_application_is_created_NA</fullName>
        <ccEmails>credit@sunpowercorp.com</ccEmails>
        <ccEmails>Nino.Llorente@sunpowercorp.com</ccEmails>
        <description>Notify RSM when credit application is created - NA</description>
        <protected>false</protected>
        <recipients>
            <recipient>lilibeth.magpantay@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mariaana.alora@sunpower.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mariatheresa.agno@sunpowercorp.com</recipient>
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
            <recipient>vickie.dudley@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>RSM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>customercare@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Credit_Application/Credit_Application_Submitted</template>
    </alerts>
    <alerts>
        <fullName>Send_mail_to_RSM</fullName>
        <description>Send mail to RSM</description>
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
        <template>Credit_Application/Credit_Application_Status_Changed</template>
    </alerts>
    <alerts>
        <fullName>Send_mail_to_RSM_2</fullName>
        <description>Send mail to RSM</description>
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
        <template>Credit_Application/Credit_Application_Status_Changed</template>
    </alerts>
    <alerts>
        <fullName>Send_mail_to_RSM_3</fullName>
        <description>Send mail to RSM</description>
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
        <template>Credit_Application/Credit_Application_Status_Changed</template>
    </alerts>
    <alerts>
        <fullName>Send_mail_to_RSM_4</fullName>
        <description>Send mail to RSM</description>
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
        <template>Credit_Application/Credit_Application_Status_Changed</template>
    </alerts>
    <alerts>
        <fullName>Update_Credit_Limit_in_Oracle</fullName>
        <ccEmails>lilibeth.magpantay@sunpowercorp.com;</ccEmails>
        <ccEmails>rose.ilagan-maravilla@sunpowercorp.com;</ccEmails>
        <ccEmails>aisa.roxas@sunpowercorp.com</ccEmails>
        <description>Update Credit Limit in Oracle</description>
        <protected>false</protected>
        <recipients>
            <recipient>minette.rivera@sunpowercorp.com</recipient>
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
        <senderType>CurrentUser</senderType>
        <template>Credit_Application/Credit_Application_Approved_Update_Credit_Limit_in_Oracle</template>
    </alerts>
    <fieldUpdates>
        <fullName>Credit_Application_Status_Approved</fullName>
        <description>Credit Application Status - Approved</description>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Credit Application Status - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Credit_Application_Status_Declined</fullName>
        <description>Credit Application Status - Declined</description>
        <field>Status__c</field>
        <literalValue>Declined</literalValue>
        <name>Credit Application Status - Declined</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Credit_Application_Status_In_Progress</fullName>
        <description>Credit Application Status - In Progress</description>
        <field>Status__c</field>
        <literalValue>In Progress</literalValue>
        <name>Credit Application Status - In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Credit_Application_Status_Recalled</fullName>
        <description>Credit Application Status - Recalled</description>
        <field>Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>Credit Application Status - Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Credit_Application_Status_Submitted</fullName>
        <description>Credit Application Status - Submitted for Approval</description>
        <field>Status__c</field>
        <literalValue>Submitted for Approval</literalValue>
        <name>Credit Application Status - Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_Payable_Contact</fullName>
        <description>Update Account Payable Contact</description>
        <field>Accounts_Payable__c</field>
        <formula>AP_Contact__c</formula>
        <name>Update Account Payable Contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_Payable_Email</fullName>
        <description>Update Account Payable Email</description>
        <field>Accounts_Payable_Email__c</field>
        <formula>AP_Email__c</formula>
        <name>Update Account Payable Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_Payable_Fax</fullName>
        <description>Update Account Payable Fax</description>
        <field>Accounts_Payable_Fax__c</field>
        <formula>AP_Fax__c</formula>
        <name>Update Account Payable Fax</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_Payable_Phone</fullName>
        <description>Update Account Payable Phone</description>
        <field>Accounts_Payable_Phone__c</field>
        <formula>AP_Phone__c</formula>
        <name>Update Account Payable Phone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>updatecloseddate</fullName>
        <field>Closed_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Closed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>updateownertoqueue</fullName>
        <field>OwnerId</field>
        <lookupValue>CreditApplicationQueue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Owner to Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Credit Application Assignment</fullName>
        <actions>
            <name>updateownertoqueue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Credit_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Ready for Review</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Credit Application In Progress - Belgium-Dutch</fullName>
        <actions>
            <name>Credit_Application_In_Progress_Belgium_Dutch</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 and 2 and 3 and 4</booleanFilter>
        <criteriaItems>
            <field>Credit_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EU Credit Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.Account_Bill_To_Country__c</field>
            <operation>equals</operation>
            <value>Belgium</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.Contact_Language__c</field>
            <operation>equals</operation>
            <value>Dutch</value>
        </criteriaItems>
        <description>Credit Application In Progress - Belgium Dutch</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Credit Application In Progress - Belgium-French</fullName>
        <actions>
            <name>Credit_Application_In_Progress_Belgium_French</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 and 2 and 3 and 4</booleanFilter>
        <criteriaItems>
            <field>Credit_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EU Credit Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.Account_Bill_To_Country__c</field>
            <operation>equals</operation>
            <value>Belgium</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.Contact_Language__c</field>
            <operation>equals</operation>
            <value>French</value>
        </criteriaItems>
        <description>Credit Application In Progress - Belgium French</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Credit Application In Progress - English</fullName>
        <actions>
            <name>Credit_Application_In_Progress_English</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2) Or (3 AND 4)</booleanFilter>
        <criteriaItems>
            <field>Credit_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>NA Credit Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EU Credit Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.Account_Bill_To_Country__c</field>
            <operation>notEqual</operation>
            <value>Italy,Germany,Spain,France</value>
        </criteriaItems>
        <description>Credit Application In Progress - English</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Credit Application In Progress - France</fullName>
        <actions>
            <name>Credit_Application_In_Progress_French</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 and 2 and 3</booleanFilter>
        <criteriaItems>
            <field>Credit_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EU Credit Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.Account_Bill_To_Country__c</field>
            <operation>equals</operation>
            <value>France</value>
        </criteriaItems>
        <description>Credit Application In Progress - France</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Credit Application In Progress - Germany</fullName>
        <actions>
            <name>Credit_Application_In_Progress_German</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 and 2 and 3</booleanFilter>
        <criteriaItems>
            <field>Credit_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EU Credit Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.Account_Bill_To_Country__c</field>
            <operation>equals</operation>
            <value>Germany</value>
        </criteriaItems>
        <description>Credit Application In Progress - Germany</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Credit Application In Progress - Italy</fullName>
        <actions>
            <name>Credit_Application_In_Progress_Italian</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 and 2 and 3</booleanFilter>
        <criteriaItems>
            <field>Credit_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EU Credit Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.Account_Bill_To_Country__c</field>
            <operation>equals</operation>
            <value>Italy</value>
        </criteriaItems>
        <description>Credit Application In Progress - Italy</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Credit Application In Progress - Spanish</fullName>
        <actions>
            <name>Credit_Application_In_Progress_Spanish</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 and 2 and 3</booleanFilter>
        <criteriaItems>
            <field>Credit_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EU Credit Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.Account_Bill_To_Country__c</field>
            <operation>equals</operation>
            <value>Spain</value>
        </criteriaItems>
        <description>Credit Application In Progress - Spanish</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Credit Application Missing Documentation - Belgium-Dutch</fullName>
        <actions>
            <name>EU_Credit_Application_Missing_Documentation_Belgium_Dutch</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Credit_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Evaluation On Hold - Missing Documentation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EU Credit Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.Account_Bill_To_Country__c</field>
            <operation>equals</operation>
            <value>Belgium</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.Contact_Language__c</field>
            <operation>equals</operation>
            <value>Dutch</value>
        </criteriaItems>
        <description>Credit Application Missing Documentation - Belgium-Dutch</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Credit Application Missing Documentation - Belgium-French</fullName>
        <actions>
            <name>EU_Credit_Application_Missing_Documentation_Belgium_French</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Credit_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Evaluation On Hold - Missing Documentation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EU Credit Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.Account_Bill_To_Country__c</field>
            <operation>equals</operation>
            <value>Belgium</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.Contact_Language__c</field>
            <operation>equals</operation>
            <value>French</value>
        </criteriaItems>
        <description>Credit Application Missing Documentation - Belgium-French</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Credit Application Missing Documentation - English</fullName>
        <actions>
            <name>Credit_Application_Missing_Documentation_English</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2) or (1 AND 3)</booleanFilter>
        <criteriaItems>
            <field>Credit_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Evaluation On Hold - Missing Documentation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>NA Credit Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.Bill_To_Country__c</field>
            <operation>equals</operation>
            <value>United Kingdom</value>
        </criteriaItems>
        <description>Credit Application Missing Documentation - English</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Credit Application Missing Documentation - French</fullName>
        <actions>
            <name>EU_Credit_Application_Missing_Documentation_French</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 and 2 and 3</booleanFilter>
        <criteriaItems>
            <field>Credit_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Evaluation On Hold - Missing Documentation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EU Credit Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.Bill_To_Country__c</field>
            <operation>equals</operation>
            <value>France</value>
        </criteriaItems>
        <description>Credit Application Missing Documentation - French</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Credit Application Missing Documentation - German</fullName>
        <actions>
            <name>EU_Credit_Application_Missing_Documentation_German</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 and 2 and 3</booleanFilter>
        <criteriaItems>
            <field>Credit_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Evaluation On Hold - Missing Documentation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EU Credit Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.Bill_To_Country__c</field>
            <operation>equals</operation>
            <value>Germany</value>
        </criteriaItems>
        <description>Credit Application Missing Documentation - German</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Credit Application Missing Documentation - Italian</fullName>
        <actions>
            <name>EU_Credit_Application_Missing_Documentation_Italian</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 and 2 and 3</booleanFilter>
        <criteriaItems>
            <field>Credit_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Evaluation On Hold - Missing Documentation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EU Credit Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.Bill_To_Country__c</field>
            <operation>equals</operation>
            <value>Italy</value>
        </criteriaItems>
        <description>Credit Application Missing Documentation - Italian</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Credit Application Missing Documentation - Spanish</fullName>
        <actions>
            <name>EU_Credit_Application_Missing_Documentation_Spanish</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 and 2 and 3</booleanFilter>
        <criteriaItems>
            <field>Credit_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Evaluation On Hold - Missing Documentation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EU Credit Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.Bill_To_Country__c</field>
            <operation>equals</operation>
            <value>Spain</value>
        </criteriaItems>
        <description>Credit Application Missing Documentation - Spanish</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Credit Review Completed</fullName>
        <actions>
            <name>updatecloseddate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND ( 2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Credit_Application__c.Type__c</field>
            <operation>equals</operation>
            <value>Credit Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Declined</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify Dealer CA Submitted</fullName>
        <actions>
            <name>CAReceived</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Credit_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Notify when Credit Application is submitted - EU</fullName>
        <actions>
            <name>Notify_RSM_when_credit_application_is_created_EU</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Credit_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Ready for Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EU Credit Application</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify when Credit Application is submitted - NA</fullName>
        <actions>
            <name>Notify_RSM_when_credit_application_is_created_NA</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Credit_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Ready for Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Credit_Application__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>NA Credit Application</value>
        </criteriaItems>
        <description>Notify when Credit Application is submitted - NA</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RSM Receipt</fullName>
        <actions>
            <name>Send_mail_to_RSM</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Credit_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Ready for Review</value>
        </criteriaItems>
        <description>Send mail to RSM</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RSM Receipt_2</fullName>
        <actions>
            <name>Send_mail_to_RSM_2</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Credit_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Evaluation On Hold - Missing Documentation</value>
        </criteriaItems>
        <description>Send mail to RSM</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RSM Receipt_3</fullName>
        <actions>
            <name>Send_mail_to_RSM_3</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Credit_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <description>Send mail to RSM</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RSM Receipt_4</fullName>
        <actions>
            <name>Send_mail_to_RSM_4</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Credit_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Declined</value>
        </criteriaItems>
        <description>Send mail to RSM</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Account Payable Contact</fullName>
        <actions>
            <name>Update_Account_Payable_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Credit_Application__c.AP_Contact__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update Account Payable Contact</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Account Payable Email</fullName>
        <actions>
            <name>Update_Account_Payable_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Credit_Application__c.AP_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update Account Payable Email</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Account Payable Fax</fullName>
        <actions>
            <name>Update_Account_Payable_Fax</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Credit_Application__c.AP_Fax__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update Account Payable Fax</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Account Payable Phone</fullName>
        <actions>
            <name>Update_Account_Payable_Phone</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Credit_Application__c.AP_Phone__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update Account Payable Phone</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Update_Credit_Limit_in_Oracle</fullName>
        <assignedTo>minette.rivera@sunpowercorp.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>The related To Credit Application has been approved. 
Go to the Related To: CA-xxxxxx link to retreive more information.
Close this Task when is done.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>Credit_Application__c.Credit_Application_Accepted_Date__c</offsetFromField>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Update Credit Limit in Oracle</subject>
    </tasks>
</Workflow>
