<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Committed_Date_Has_Changed_NAC</fullName>
        <description>Committed Date Has Changed - NAC</description>
        <protected>false</protected>
        <recipients>
            <recipient>eric.potts@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>steven.silveira@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Committed_Date_Change_Notice</template>
    </alerts>
    <alerts>
        <fullName>Date_Has_Changed_NAC</fullName>
        <description>Date Has Changed - NAC/UPPa</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity/Date_Change_Notice</template>
    </alerts>
    <fieldUpdates>
        <fullName>BOS_w</fullName>
        <field>BOS_w__c</field>
        <formula>BOS_s_w__c</formula>
        <name>BOS $/w</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Product_O_M_Update</fullName>
        <description>Opportunity Product O&amp;M Update - updates product as O&amp;M</description>
        <field>O_M__c</field>
        <literalValue>1</literalValue>
        <name>Opportunity Product O&amp;M Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
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
        <fullName>System_Size_PV</fullName>
        <field>System_Size__c</field>
        <formula>System_Size_PV__c</formula>
        <name>System Size (PV)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Total_BOS_Cost</fullName>
        <field>Total_BOS_Cost__c</field>
        <formula>BOS_Total_Cost__c</formula>
        <name>Total BOS Cost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Total_Cost</fullName>
        <description>12_13_2012 - Updated this field update to use Total_Cost1__c custom field instead of Total_Cost__c as the field Total_Cost1__c is populated using trigger &quot;UpdateOpptyProductCost&quot; on Opportunityu Product</description>
        <field>Total_Cost_new__c</field>
        <formula>Total_Cost1__c</formula>
        <name>Total Cost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Total_Development_Cost</fullName>
        <field>Total_Development_Cost__c</field>
        <formula>Dev_Cost__c</formula>
        <name>Total Development Cost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Total_PV_Cost</fullName>
        <field>Total_PV_Cost__c</field>
        <formula>PV_Cost__c</formula>
        <name>Total PV Cost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Blank</fullName>
        <description>Populate 0 to cost__c if left blank</description>
        <field>Cost__c</field>
        <formula>0</formula>
        <name>Update Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
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
        <fullName>Update_Sales_Price</fullName>
        <description>Update Sales Price</description>
        <field>UnitPrice</field>
        <formula>(  Sales_Unit_Price__c *  Product2.Wattage_Out__c  )</formula>
        <name>Update Sales Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Total_Cost1_with_BOS_Total_Cost</fullName>
        <description>Update Total Cost1 with BOS Total Cost</description>
        <field>Total_Cost1__c</field>
        <formula>BOS_Total_Cost__c</formula>
        <name>Update Total Cost1 with BOS Total Cost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Total_CostNew_with_Total_Cost</fullName>
        <description>Update Total CostNew with Total Cost</description>
        <field>Total_Cost_new__c</field>
        <formula>BOS_Total_Cost__c</formula>
        <name>Update Total CostNew with Total Cost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Total_List_Price</fullName>
        <description>Update Total List Price</description>
        <field>Total_List_Price_Calculated__c</field>
        <formula>Total_List_Price__c</formula>
        <name>Update Total List Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Total_Price_List</fullName>
        <description>Update Total Price List</description>
        <field>Total_List_Price_Calculated__c</field>
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
        <formula>((Quantity  *  Product2.Wattage_Out__c) / 1000)</formula>
        <name>Update kWp (Component Opps Only) field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>system_Size_BOs</fullName>
        <field>System_SizeBOS__c</field>
        <formula>System_Size_BOS__c</formula>
        <name>system Size BOs</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>BOS %24%2Fw</fullName>
        <actions>
            <name>BOS_w</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Total_Cost__c</field>
            <operation>notEqual</operation>
            <value>USD 0</value>
        </criteriaItems>
        <description>BOS $/w.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BOS System Size</fullName>
        <actions>
            <name>system_Size_BOs</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.System_Size_BOS__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <description>BOS System Size.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Committed Date Changed On Opportunity Product - NAC</fullName>
        <actions>
            <name>Committed_Date_Has_Changed_NAC</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Committed Date Changed On Opportunity Product - NAC</description>
        <formula>((ISCHANGED( Committed_Date__c))
&amp;&amp;
ISPICKVAL(Opportunity.Business_Unit__c, &quot;NA Commercial&quot; ))
&amp;&amp;
(CONTAINS(  Opportunity.Stage_Name_Duplicate__c  , &apos;03&apos;))

 || 

((ISCHANGED( Committed_Date__c))
&amp;&amp;
ISPICKVAL(Opportunity.Business_Unit__c, &quot;NA Commercial&quot; ))
&amp;&amp;
(CONTAINS(  Opportunity.Stage_Name_Duplicate__c  , &apos;04&apos;))

 || 

((ISCHANGED( Committed_Date__c))
&amp;&amp;
ISPICKVAL(Opportunity.Business_Unit__c, &quot;NA Commercial&quot; ))
&amp;&amp;
(CONTAINS(  Opportunity.Stage_Name_Duplicate__c  , &apos;05&apos;))

 || 

((ISCHANGED( Committed_Date__c))
&amp;&amp;
ISPICKVAL(Opportunity.Business_Unit__c, &quot;NA Commercial&quot; ))
&amp;&amp;
(CONTAINS(  Opportunity.Stage_Name_Duplicate__c  , &apos;06&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Date Changed On Opportunity Product - NAC</fullName>
        <actions>
            <name>Date_Has_Changed_NAC</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Date Changed On Opportunity Product - NAC</description>
        <formula>((ISCHANGED( ServiceDate ))
&amp;&amp;
ISPICKVAL(Opportunity.Business_Unit__c, &quot;NA Commercial&quot; ))
&amp;&amp;
(CONTAINS(  Opportunity.Stage_Name_Duplicate__c  , &apos;03&apos;))

 || 

((ISCHANGED( ServiceDate ))
&amp;&amp;
ISPICKVAL(Opportunity.Business_Unit__c, &quot;NA Commercial&quot; ))
&amp;&amp;
(CONTAINS(  Opportunity.Stage_Name_Duplicate__c  , &apos;04&apos;))

 || 

((ISCHANGED( ServiceDate ))
&amp;&amp;
ISPICKVAL(Opportunity.Business_Unit__c, &quot;NA Commercial&quot; ))
&amp;&amp;
(CONTAINS(  Opportunity.Stage_Name_Duplicate__c  , &apos;05&apos;))

 || 

((ISCHANGED( ServiceDate ))
&amp;&amp;
ISPICKVAL(Opportunity.Business_Unit__c, &quot;NA Commercial&quot; ))
&amp;&amp;
(CONTAINS(  Opportunity.Stage_Name_Duplicate__c  , &apos;06&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Date Changed On Opportunity Product - UPPa</fullName>
        <actions>
            <name>Date_Has_Changed_NAC</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Date Changed On Opportunity Product - UPP Americas</description>
        <formula>((ISCHANGED( ServiceDate ))
&amp;&amp;
ISPICKVAL(Opportunity.Business_Unit__c, &quot;UPP Americas&quot; ))
&amp;&amp;
(CONTAINS(  Opportunity.Stage_Name_Duplicate__c  , &apos;03&apos;))

 || 

((ISCHANGED( ServiceDate ))
&amp;&amp;
ISPICKVAL(Opportunity.Business_Unit__c, &quot;UPP Americas&quot; ))
&amp;&amp;
(CONTAINS(  Opportunity.Stage_Name_Duplicate__c  , &apos;04&apos;))

 || 

((ISCHANGED( ServiceDate ))
&amp;&amp;
ISPICKVAL(Opportunity.Business_Unit__c, &quot;UPP Americas&quot; ))
&amp;&amp;
(CONTAINS(  Opportunity.Stage_Name_Duplicate__c  , &apos;05&apos;))

 || 

((ISCHANGED( ServiceDate ))
&amp;&amp;
ISPICKVAL(Opportunity.Business_Unit__c, &quot;UPP Americas&quot; ))
&amp;&amp;
(CONTAINS(  Opportunity.Stage_Name_Duplicate__c  , &apos;06&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Product Line O%26M Update</fullName>
        <actions>
            <name>Opportunity_Product_O_M_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.O_M1__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Opportunity Product Line O&amp;M Update - indicates O&amp;M</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PV Cost Pricing Update</fullName>
        <actions>
            <name>PV_Cost_Pricing_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 AND 2 AND 3)</booleanFilter>
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
            <field>PricebookEntry.Pricebook2Id</field>
            <operation>notContain</operation>
            <value>Component</value>
        </criteriaItems>
        <description>PV Cost Pricing Update
12_13_2012 -- Deactivated as the Trigger on Opportunity has been implemented to populate this Custom field value instead of field update.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>System Size %28PV%29</fullName>
        <actions>
            <name>System_Size_PV</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.System_Size_PV__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Product2.Name</field>
            <operation>notContain</operation>
            <value>total</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Total BOS Cost</fullName>
        <actions>
            <name>Total_BOS_Cost</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.BOS_Total_Cost__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Total Cost</fullName>
        <actions>
            <name>Total_Cost</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>OpportunityLineItem.Total_Cost1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Total_Cost1__c</field>
            <operation>greaterOrEqual</operation>
            <value>USD 0</value>
        </criteriaItems>
        <description>12_13_2012 - Updated the workflow to use Total_Cost1__c custom field instead of Total_Cost__c as the field Total_Cost1__c is populated using trigger &quot;UpdateOpptyProductCost&quot; on Opportunityu Product</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Total Development Cost</fullName>
        <actions>
            <name>Total_Development_Cost</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 or 2</booleanFilter>
        <criteriaItems>
            <field>OpportunityLineItem.Dev_Cost__c</field>
            <operation>notEqual</operation>
            <value>USD 0</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Dev_Cost__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Total PV Cost</fullName>
        <actions>
            <name>Total_PV_Cost</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 or 2 or 3)</booleanFilter>
        <criteriaItems>
            <field>OpportunityLineItem.PV_Cost__c</field>
            <operation>notEqual</operation>
            <value>USD 0</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.PV_Cost__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.PV_Cost__c</field>
            <operation>greaterThan</operation>
            <value>USD 0</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Blank</fullName>
        <actions>
            <name>Update_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Populate Cost to 0 if left blank.</description>
        <formula>ISBLANK( Cost__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Cost</fullName>
        <actions>
            <name>Update_Cost</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND (NOT(2) or 3)</booleanFilter>
        <criteriaItems>
            <field>PricebookEntry.Pricebook2Id</field>
            <operation>contains</operation>
            <value>Comp</value>
        </criteriaItems>
        <criteriaItems>
            <field>Product2.Name</field>
            <operation>startsWith</operation>
            <value>Other</value>
        </criteriaItems>
        <criteriaItems>
            <field>Product2.Product_Family_Text__c</field>
            <operation>notEqual</operation>
            <value>PV Cell</value>
        </criteriaItems>
        <description>Case#00112147-Update Cost
12_13_2012 -- Deactivated as the Trigger on Opportunity has been implemented to populate this Custom field value instead of field update.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Sales Price</fullName>
        <actions>
            <name>Update_Sales_Price</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND (4 OR 5)</booleanFilter>
        <criteriaItems>
            <field>PricebookEntry.Pricebook2Id</field>
            <operation>contains</operation>
            <value>Comp,cost by quarter</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Sales_Unit_Price__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Product2.Wattage_Out__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>PricebookEntry.Pricebook2Id</field>
            <operation>notContain</operation>
            <value>Components/Systems Pricing</value>
        </criteriaItems>
        <criteriaItems>
            <field>PricebookEntry.Pricebook2Id</field>
            <operation>notContain</operation>
            <value>NA Commercial Direct</value>
        </criteriaItems>
        <description>Update Sales Price</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Total Cost1 with BOS Total Cost</fullName>
        <actions>
            <name>Update_Total_Cost1_with_BOS_Total_Cost</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Total_CostNew_with_Total_Cost</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Update Total Cost1 with BOS Total Cost</description>
        <formula>(Not(ISNULL( Total_BOS_Cost__c)
&amp;&amp;
ISNULL( Total_Cost1__c)))
 || 
(  Total_BOS_Cost__c &gt; Total_Cost1__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Total List Price</fullName>
        <actions>
            <name>Update_Total_List_Price</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 Or 2)</booleanFilter>
        <criteriaItems>
            <field>OpportunityLineItem.TotalPrice</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Total_List_Price__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Update Total List Price</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Total Price List</fullName>
        <actions>
            <name>Update_Total_Price_List</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 Or 2</booleanFilter>
        <criteriaItems>
            <field>OpportunityLineItem.Total_List_Price__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Total_List_Price__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update Total Price List</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update kWp %28Component Opps Only%29 field</fullName>
        <actions>
            <name>Update_kWp_Component_Opps_Only_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>PricebookEntry.Pricebook2Id</field>
            <operation>contains</operation>
            <value>Comp</value>
        </criteriaItems>
        <criteriaItems>
            <field>PricebookEntry.Pricebook2Id</field>
            <operation>notContain</operation>
            <value>System</value>
        </criteriaItems>
        <description>Update kWp (Component Opps Only) field</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
