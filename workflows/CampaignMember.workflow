<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Email_Alert_Canvassing_East_Bay_Ecomark</fullName>
        <ccEmails>ian@ecomarkusa.com</ccEmails>
        <description>Send Email Alert - Canvassing - East Bay - Ecomark</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Campaign/Send_Email_Alert_Canvassing_East_Bay_Ecomark</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_Alert_Canvassing_Fresno_Ecomark</fullName>
        <ccEmails>ian@ecomarkusa.com</ccEmails>
        <description>Send Email Alert - Canvassing - Fresno - Ecomark</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Campaign/Send_Email_Alert_Canvassing_Fresno_Ecomark</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_Alert_Ecomark</fullName>
        <ccEmails>ian@ecomarkusa.com</ccEmails>
        <description>Send Email Alert - Ecomark</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Campaign/Send_Email_Alert_Ecomark_USA</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_Alert_Mt_Diablo_Campaign</fullName>
        <ccEmails>ian@ecomarkusa.com</ccEmails>
        <description>Send Email Alert - Mt. Diablo Campaign</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Campaign/Send_Email_Alert_Mt_Diablo_Campaign</template>
    </alerts>
    <rules>
        <fullName>Send Email Alert - Canvassing - East Bay - Ecomark</fullName>
        <actions>
            <name>Send_Email_Alert_Canvassing_East_Bay_Ecomark</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Campaign.Campaign_ID__c</field>
            <operation>equals</operation>
            <value>2013_NA_RLC_Canvassing_East Bay</value>
        </criteriaItems>
        <description>Send Email Alert - Canvassing - East Bay - Ecomark</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send Email Alert - Canvassing - Fresno - Ecomark</fullName>
        <actions>
            <name>Send_Email_Alert_Canvassing_Fresno_Ecomark</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Campaign.Campaign_ID__c</field>
            <operation>equals</operation>
            <value>2013_NA_RLC_Canvassing_Fresno</value>
        </criteriaItems>
        <description>Send Email Alert - Canvassing - Fresno - Ecomark</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send Email Alert - Ecomark</fullName>
        <actions>
            <name>Send_Email_Alert_Ecomark</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 or 2 or 3 or 4</booleanFilter>
        <criteriaItems>
            <field>Campaign.Campaign_ID__c</field>
            <operation>equals</operation>
            <value>2013_NA_RLC_OSH_Blackstone,2013_NA_RLC_OSH_Dublin,2013_NA_RLC_OSH_Livermore,2013_NA_RLC_OSH</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Campaign_ID__c</field>
            <operation>equals</operation>
            <value>2013_NA_RLC_Canvassing_East Bay,2013_NA_RLC_Canvassing_Fresno,2013_NA_RLC_Canvassing_Denver,2012_NA_RLC_Mt. Diablo</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Campaign_ID__c</field>
            <operation>equals</operation>
            <value>2013_NA_RLC_OSH_Concord,2013_NA_RLC_OSH_Clayton,2013_NA_RLC_OSH_Clovis,2013_NA_RLC_OSH_Fresno (North East)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Campaign_ID__c</field>
            <operation>equals</operation>
            <value>13_NA_RLC_OSH_Figarden,2013_NA_RLC_OSH_Visalia,2013_NA_RLC_OSH_San Ramon,2013_NA_RLC_OSH_San Leandro,2013_NA_RLC_OSH_Kings Canyon</value>
        </criteriaItems>
        <description>Send Email Alert - Ecomark</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send Email Alert - Mt%2E Diablo Campaign</fullName>
        <actions>
            <name>Send_Email_Alert_Mt_Diablo_Campaign</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Campaign.Campaign_ID__c</field>
            <operation>equals</operation>
            <value>2012_NA_RLC_Mt. Diablo</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
