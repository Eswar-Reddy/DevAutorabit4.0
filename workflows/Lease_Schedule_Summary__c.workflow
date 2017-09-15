<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Cost_Factor_Capital</fullName>
        <description>Multiplier factor for Capital Lease to compute Capitalized Cost. Reflects latest value. Latest:PIS Entry Date&gt;4/3/16 , use 0.18</description>
        <field>Cost_Factor_Capital__c</field>
        <formula>0.18</formula>
        <name>Cost Factor-Capital</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Cost_Factor_Operating</fullName>
        <description>Updates Cost Factor Multiplier to compute for Capitalized Cost on Operating Leases.Reflects latest value. Latest:PIS Entry Date&gt;4/3/16 , use 0.17</description>
        <field>Cost_Factor_Operating__c</field>
        <formula>0.17</formula>
        <name>Cost Factor_Operating</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lease_Program</fullName>
        <field>Lease_Program__c</field>
        <formula>Value($Label.Value_of_Lease_Program)</formula>
        <name>Update Lease Program</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Cost_Factor_4_Capitalized_Cost</fullName>
        <actions>
            <name>Cost_Factor_Capital</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Cost_Factor_Operating</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates Cost Factor Multiplier to compute for Capitalized Cost on Capital Leases</description>
        <formula>AND(
Lease_Payment__r.PIS_Entry_Date__c &gt; Date(2016, 4, 3),
 ISBLANK(Cost_Factor_Capital__c)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Lease Program</fullName>
        <actions>
            <name>Update_Lease_Program</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(Quote__r.Lease_Doc_Created__c,  Quote__r.Lease_doc_Created_Date__c &gt;=  DATEVALUE($Label.Lease_Doc_Create_Date), Country_Domain__c= &apos;au&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
