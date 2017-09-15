<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_that_SunPower_CPV_product_added_to_Estimate</fullName>
        <description>Notify that SunPower CPV product added to Estimate</description>
        <protected>false</protected>
        <recipients>
            <recipient>celia.cheng@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>cindi.choi@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jay.peir@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/Estimate_Product_SunPower_CPV</template>
    </alerts>
    <fieldUpdates>
        <fullName>PV_Cost_Pricing_Update</fullName>
        <description>PV Cost Pricing Update</description>
        <field>Cost__c</field>
        <formula>PV_Cost_Pricing__c</formula>
        <name>PV Cost Pricing Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quote_Product_Line_O_M_Update</fullName>
        <description>Quote Product Line O&amp;M Updated - indicates O&amp;M product</description>
        <field>O_M__c</field>
        <literalValue>1</literalValue>
        <name>Quote Product Line O&amp;M Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Serengeti_Cost_Pricing_Update</fullName>
        <description>Serengeti Cost Pricing Update</description>
        <field>Cost__c</field>
        <formula>Serengeti_Cost_Pricing__c</formula>
        <name>Serengeti Cost Pricing Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Total_Cost</fullName>
        <field>Total_Cost_new__c</field>
        <formula>Total_Cost__c</formula>
        <name>Total Cost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Cost</fullName>
        <field>Cost__c</field>
        <formula>PricebookEntry.Product2.Cost__c</formula>
        <name>Update Cost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Kwp</fullName>
        <description>Update Kwp</description>
        <field>kWp__c</field>
        <formula>System_Size_PV__c</formula>
        <name>Update Kwp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_PV_Cost</fullName>
        <description>Update PV Cost</description>
        <field>PV_Cost_Roll_Up__c</field>
        <formula>PV_Cost__c</formula>
        <name>Update PV Cost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sales_Price</fullName>
        <description>Update Sales Price</description>
        <field>UnitPrice</field>
        <formula>( Sales_Unit_Price__c * Product2.Wattage_Out__c )</formula>
        <name>Update Sales Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Total_Price_List</fullName>
        <description>Update Total Price List</description>
        <field>Total_Price_List_Calculated__c</field>
        <formula>Total_List_Price__c</formula>
        <name>Update Total Price List</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_kWp_Component_Opps_Only_field</fullName>
        <description>Update kWp (Component Opps Only) field</description>
        <field>kWp_Components__c</field>
        <formula>((Quantity  *    Wattage_Out__c  ) / 1000)</formula>
        <name>Update kWp (Component Opps Only) field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_kWp_Field</fullName>
        <field>kWp__c</field>
        <formula>kWp_Components__c</formula>
        <name>Update kWp Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>PV Cost Pricing Update</fullName>
        <actions>
            <name>PV_Cost_Pricing_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Product2.Product_Type__c</field>
            <operation>equals</operation>
            <value>PV Module</value>
        </criteriaItems>
        <criteriaItems>
            <field>Product2.Name</field>
            <operation>startsWith</operation>
            <value>SPR-</value>
        </criteriaItems>
        <criteriaItems>
            <field>QuoteLineItem.PV_Cost_Pricing__c</field>
            <operation>notEqual</operation>
            <value>USD 0</value>
        </criteriaItems>
        <criteriaItems>
            <field>PricebookEntry.Pricebook2Id</field>
            <operation>notContain</operation>
            <value>Component</value>
        </criteriaItems>
        <description>PV Cost Pricing Update</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Product SunPower CPV added</fullName>
        <actions>
            <name>Notify_that_SunPower_CPV_product_added_to_Estimate</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>QuoteLineItem.Product_Name__c</field>
            <operation>contains</operation>
            <value>SunPower CPV</value>
        </criteriaItems>
        <criteriaItems>
            <field>QuoteLineItem.Estimate_Formula__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Quote Line Item O%26M Update</fullName>
        <actions>
            <name>Quote_Product_Line_O_M_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>QuoteLineItem.O_M1__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Quote Line Item O&amp;M Update - indicates as O&amp;M</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Quote Line Item on Estimate Has Product SunPower CPV 1%2E0</fullName>
        <active>false</active>
        <criteriaItems>
            <field>QuoteLineItem.Product_Name__c</field>
            <operation>contains</operation>
            <value>CPV</value>
        </criteriaItems>
        <description>Quote Line Item on Estimate Has Product SunPower CPV 1.0</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Serengeti Cost Pricing Update</fullName>
        <actions>
            <name>Serengeti_Cost_Pricing_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Product2.Product_Type__c</field>
            <operation>equals</operation>
            <value>PV Module</value>
        </criteriaItems>
        <criteriaItems>
            <field>Product2.Name</field>
            <operation>startsWith</operation>
            <value>SER-</value>
        </criteriaItems>
        <criteriaItems>
            <field>QuoteLineItem.Serengeti_Cost_Pricing__c</field>
            <operation>notEqual</operation>
            <value>USD 0</value>
        </criteriaItems>
        <criteriaItems>
            <field>PricebookEntry.Pricebook2Id</field>
            <operation>notContain</operation>
            <value>Component</value>
        </criteriaItems>
        <description>Serengeti Cost Pricing Update</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Total Cost</fullName>
        <actions>
            <name>Total_Cost</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF(Total_Cost__c = Total_Cost_new__c , false, true)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Cost</fullName>
        <actions>
            <name>Update_Cost</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 or 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Quote.PriceBook_Name__c</field>
            <operation>contains</operation>
            <value>Component</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.PriceBook_Name__c</field>
            <operation>contains</operation>
            <value>Cost By Quarter</value>
        </criteriaItems>
        <criteriaItems>
            <field>QuoteLineItem.Product_Type__c</field>
            <operation>notEqual</operation>
            <value>Freight</value>
        </criteriaItems>
        <description>Case#00112147-Update Cost</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Kwp</fullName>
        <actions>
            <name>Update_Kwp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 or 2 or 3) and 4</booleanFilter>
        <criteriaItems>
            <field>QuoteLineItem.kWp_Components__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>QuoteLineItem.kWp_Components__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>QuoteLineItem.kWp_Components__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Product2.Product_Type__c</field>
            <operation>notContain</operation>
            <value>PV Cell</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update PV Cost</fullName>
        <actions>
            <name>Update_PV_Cost</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>QuoteLineItem.PV_Cost__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update PV Cost</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Sales Price</fullName>
        <actions>
            <name>Update_Sales_Price</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PricebookEntry.Pricebook2Id</field>
            <operation>contains</operation>
            <value>Component,cost by quarter</value>
        </criteriaItems>
        <criteriaItems>
            <field>Product2.Family</field>
            <operation>notEqual</operation>
            <value>Freight</value>
        </criteriaItems>
        <criteriaItems>
            <field>PricebookEntry.Pricebook2Id</field>
            <operation>notContain</operation>
            <value>System</value>
        </criteriaItems>
        <description>Update Sales Price</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Total List Price</fullName>
        <actions>
            <name>Update_Total_Price_List</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 or 2</booleanFilter>
        <criteriaItems>
            <field>QuoteLineItem.Total_List_Price__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>QuoteLineItem.Total_List_Price__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update Total List Price</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update kWp %28Component Opps Only%29 field</fullName>
        <actions>
            <name>Update_kWp_Component_Opps_Only_field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_kWp_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quote.PriceBook_Name__c</field>
            <operation>contains</operation>
            <value>Comp</value>
        </criteriaItems>
        <criteriaItems>
            <field>Product2.Family</field>
            <operation>notEqual</operation>
            <value>Freight</value>
        </criteriaItems>
        <criteriaItems>
            <field>PricebookEntry.Pricebook2Id</field>
            <operation>notContain</operation>
            <value>Components/Systems Pricing</value>
        </criteriaItems>
        <description>Update kWp (Component Opps Only) field</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
