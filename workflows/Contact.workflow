<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Check_include_in_Lease_doc_checkbox</fullName>
        <field>Include_in_Lease_Doc__c</field>
        <literalValue>1</literalValue>
        <name>Check include in Lease doc checkbox</name>
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
        <fullName>Contact_Mobile_Phone_US_Prefix</fullName>
        <description>Case# 00616615 - Five9 Screen-Pop not working in EMEA (and maybe APAC) - Arokia Nathan</description>
        <field>Mobile_US_Prefix__c</field>
        <formula>IF(
OR(ISBLANK(MobilePhone), 
/* US Number */
AND (
LEN(MobilePhone) = 14,
MID(MobilePhone, 1, 1) = &apos;(&apos;,
ISNUMBER(MID(MobilePhone, 2, 3)),
MID(MobilePhone, 5, 1) = &apos;)&apos;,
MID(MobilePhone, 6, 1) = &apos; &apos;,
ISNUMBER(MID(MobilePhone, 7, 3)),
MID(MobilePhone, 10, 1) = &apos;-&apos;,
ISNUMBER(MID(MobilePhone, 11, 4))
),
/* US Number Extension */
AND (
LEN(MobilePhone) &gt;= 15,
MID(MobilePhone, 1, 1) = &apos;(&apos;,
ISNUMBER(MID(MobilePhone, 2, 3)),
MID(MobilePhone, 5, 1) = &apos;)&apos;,
MID(MobilePhone, 6, 1) = &apos; &apos;,
ISNUMBER(MID(MobilePhone, 7, 3)),
MID(MobilePhone, 10, 1) = &apos;-&apos;,
ISNUMBER(MID(MobilePhone, 11, 4)),
MID(MobilePhone, 15, 1) = &apos; &apos;
)
), 
null, 
&apos;011 &apos; &amp; MobilePhone
)</formula>
        <name>Contact Mobile Phone US Prefix</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_Phone_US_Prefix</fullName>
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
        <name>Contact Phone US Prefix</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Contact_isUpdatedFromAccount</fullName>
        <description>Case# 00616615 - Five9 Screen-Pop not working in EMEA (and maybe APAC) - Arokia Nathan</description>
        <field>isUpdatedFromAccount__c</field>
        <literalValue>1</literalValue>
        <name>Set Contact isUpdatedFromAccount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_to_Partner</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Partner</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type to Partner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Bypass Data%2Ecom Clean</fullName>
        <actions>
            <name>Clean_Status_Skipped</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Residential Customer,Partner,Other,Bank Guarantee,Without Bank Guarantee,Business Record Type,FR Partner,FR Residential Customer,Person Account,Standard Person Account</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.CleanStatus</field>
            <operation>notEqual</operation>
            <value>Skipped</value>
        </criteriaItems>
        <description>This rules sets the clean status field to skipped for all non commercial records that don&apos;t have a clean status of skipped.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contact Mobile Phone US Prefix Workflow</fullName>
        <actions>
            <name>Contact_Mobile_Phone_US_Prefix</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Case# 00616615 - Five9 Screen-Pop not working in EMEA (and maybe APAC) - Arokia Nathan</description>
        <formula>OR ( AND(ISNEW() ,NOT(ISBLANK(MobilePhone))), AND(NOT(ISNEW()), ISCHANGED(MobilePhone))  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Contact Phone US Prefix Workflow</fullName>
        <actions>
            <name>Contact_Phone_US_Prefix</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Contact_isUpdatedFromAccount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Case# 00616615 - Five9 Screen-Pop not working in EMEA (and maybe APAC) - Arokia Nathan</description>
        <formula>OR ( AND(ISNEW() ,NOT(ISBLANK(Phone))), AND(NOT(ISNEW()), ISCHANGED(Phone))  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Contact%3A New CSAT Contact Notice to AM</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Contact.CSAT_last_reponse_date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Notifies AMs when a new Contact record is generated for their Account via CSAT integration</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Fix Record Type %281-time%29</fullName>
        <actions>
            <name>Update_Record_Type_to_Partner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 or 2 or 3 or 4 or  5</booleanFilter>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>contains</operation>
            <value>Partner-Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>contains</operation>
            <value>Authorized-Partner-Residential</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>contains</operation>
            <value>Premier-Partner-Residential</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>contains</operation>
            <value>Authorized-Partner-Combo</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>contains</operation>
            <value>Premier-Partner-Combo</value>
        </criteriaItems>
        <description>Fix Record Type (1-time).</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set the include in Lease doc for Greenlight</fullName>
        <actions>
            <name>Check_include_in_Lease_doc_checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Contact.CreatedById</field>
            <operation>equals</operation>
            <value>GreenLight Integration</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Primary__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Role and Profile %281-time%29</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Contact.Active_Partner_Portal_User__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Partner_Portal_User__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update Role and Profile (1-time).</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
