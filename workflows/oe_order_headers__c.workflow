<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>PSRnotification</fullName>
        <description>PSRnotification</description>
        <protected>false</protected>
        <recipients>
            <field>PSRemailId__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>customersupport@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/PSRNoteforCRDwithinSSDTimeFrame</template>
    </alerts>
    <fieldUpdates>
        <fullName>Ok_To_Ship_UNSCHEDULE</fullName>
        <field>OK_TO_SHIP__c</field>
        <literalValue>UNSCHEDULE</literalValue>
        <name>Ok To Ship UNSCHEDULE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PSRemailidUpdateAction</fullName>
        <description>Update Email Field PSRemailId through cross object formula to get PSR email id</description>
        <field>PSRemailId__c</field>
        <formula>Parent_Account__r.Primary_PSR__r.Email</formula>
        <name>PSRemailidUpdateAction</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Shipping_Address_History</fullName>
        <field>Shipping_Address_Previous_Value__c</field>
        <formula>PRIORVALUE(Shipping_Address_Current_Value__c)</formula>
        <name>Shipping Address History</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CRDwithin3days</fullName>
        <actions>
            <name>PSRnotification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>oe_order_headers__c.Business_Day_for_Workflow__c</field>
            <operation>greaterOrEqual</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>oe_order_headers__c.Business_Day_for_Workflow__c</field>
            <operation>lessOrEqual</operation>
            <value>3</value>
        </criteriaItems>
        <description>CRD within 3 buisness Days</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>OkToShipActionDueDateWithin4days</fullName>
        <active>false</active>
        <description>Workflow to Check if SSD is within 4 days and Ok To Ship is not confirmed yet</description>
        <formula>AND(
    OR(ISPICKVAL(Parent_Account__r.Country_Domain__c,&apos;rvar-us&apos;),AND(ISPICKVAL(Parent_Account__r.Country_Domain__c,&apos;combo-us&apos;),
CONTAINS(ORDER_TYPE__c,&apos;RVAR&apos;))),INCLUDES( Hold_Status__c , &apos;PENDING OK TO SHIP&apos; ),
 Parent_Account__r.Partner_Opt_Out_Ok_To_Ship__c  = FALSE,
NOT( ISNULL( OK_To_Ship_Action_Due_Date__c )), NOT( ISPICKVAL( OK_TO_SHIP__c  , &apos;RELEASE&apos; )) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Ok_To_Ship_UNSCHEDULE</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>oe_order_headers__c.OK_To_Ship_Action_Due_Date__c</offsetFromField>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>PSREmailIDUpdate</fullName>
        <actions>
            <name>PSRemailidUpdateAction</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>To update PSRemailid Field through Field Update</description>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SSDWithin4days</fullName>
        <active>false</active>
        <description>Workflow to Check if SSD is within 4 days and Ok To Ship is not confirmed yet</description>
        <formula>AND(
    OR(ISPICKVAL(Parent_Account__r.Country_Domain__c,&apos;rvar-us&apos;),AND(ISPICKVAL(Parent_Account__r.Country_Domain__c,&apos;combo-us&apos;),
CONTAINS(ORDER_TYPE__c,&apos;RVAR&apos;))),INCLUDES( Hold_Status__c , &apos;PENDING OK TO SHIP&apos; ),
 Parent_Account__r.Partner_Opt_Out_Ok_To_Ship__c  = FALSE,
NOT( ISNULL( X4_days_before_SSD__c )), NOT( ISPICKVAL( OK_TO_SHIP__c  , &apos;RELEASE&apos; )) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Ok_To_Ship_UNSCHEDULE</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>oe_order_headers__c.X4_days_before_SSD__c</offsetFromField>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Shipping Address History</fullName>
        <actions>
            <name>Shipping_Address_History</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( !(ISNEW()),!( PRIORVALUE(  Shipping_Address_Current_Value__c)= Shipping_Address_Current_Value__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
