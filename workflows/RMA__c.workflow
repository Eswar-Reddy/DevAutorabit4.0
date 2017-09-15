<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Missing_Tracking_Number_Email_Notification</fullName>
        <description>Missing Tracking Number Email Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>noreply@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Support/RMA_Tracking_Reminder</template>
    </alerts>
    <alerts>
        <fullName>RMA_Creation_English</fullName>
        <description>RMA Creation - English</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>gbfs-f2d_rma-na@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Support/RMA_Creation_English</template>
    </alerts>
    <alerts>
        <fullName>RMA_Creation_Europe</fullName>
        <description>RMA Creation - Europe</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>gbfs-f2d_rma-na@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Support/RMA_Europe_Created</template>
    </alerts>
    <alerts>
        <fullName>RMA_Creation_Europe_Default</fullName>
        <ccEmails>sunpoweruk@sunpowercorp.com</ccEmails>
        <ccEmails>orderuk@sunpowercorp.com</ccEmails>
        <ccEmails>techsupport.uk@sunpower.com</ccEmails>
        <description>RMA Creation - Europe - Default</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>orderuk@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Support/RMA_Europe_Created</template>
    </alerts>
    <alerts>
        <fullName>RMA_Creation_Europe_SPBE_Flemish</fullName>
        <ccEmails>sunpowerbelgie@sunpowercorp.com</ccEmails>
        <ccEmails>orderbelgium@sunpowercorp.com</ccEmails>
        <ccEmails>Technischedienst@sunpower.com</ccEmails>
        <description>RMA Creation - Europe - SPBE - Flemish</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>orderbelgium@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Support/RMA_Europe_Created</template>
    </alerts>
    <alerts>
        <fullName>RMA_Creation_Europe_SPBE_French</fullName>
        <ccEmails>sunpowerbelgique@sunpowercorp.com</ccEmails>
        <ccEmails>orderbelgium@sunpowercorp.com</ccEmails>
        <ccEmails>Supportechniquebelgique@sunpower.com</ccEmails>
        <description>RMA Creation - Europe - SPBE - French</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>orderbelgium@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Support/RMA_Europe_Created</template>
    </alerts>
    <alerts>
        <fullName>RMA_Creation_Europe_SPDE</fullName>
        <ccEmails>solarde@sunpowercorp.com</ccEmails>
        <ccEmails>sprd@sunpowercorp.com</ccEmails>
        <ccEmails>technischersupport@sunpower.com</ccEmails>
        <description>RMA Creation - Europe - SPDE</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>transportschaden@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Support/RMA_Europe_Created</template>
    </alerts>
    <alerts>
        <fullName>RMA_Creation_Europe_SPES</fullName>
        <ccEmails>solaresp@sunpowercorp.com</ccEmails>
        <ccEmails>pedidos@sunpowercorp.com</ccEmails>
        <ccEmails>soportetecnico@sunpower.com</ccEmails>
        <description>RMA Creation - Europe - SPES</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>pedidos@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Support/RMA_Europe_Created</template>
    </alerts>
    <alerts>
        <fullName>RMA_Creation_Europe_SPFR</fullName>
        <ccEmails>solarfr@sunpowercorp.com</ccEmails>
        <ccEmails>Sunpowerfr3psr@sunpowercorp.com</ccEmails>
        <ccEmails>Supporttechnique@sunpower.com</ccEmails>
        <description>RMA Creation - Europe - SPFR</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>sunpowerfr3psr@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Support/RMA_Europe_Created</template>
    </alerts>
    <alerts>
        <fullName>RMA_Creation_Europe_SPGB</fullName>
        <ccEmails>sunpoweruk@sunpowercorp.com</ccEmails>
        <ccEmails>orderuk@sunpowercorp.com</ccEmails>
        <ccEmails>techsupport.uk@sunpower.com</ccEmails>
        <description>RMA Creation - Europe - SPGB</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>orderuk@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Support/RMA_Europe_Created</template>
    </alerts>
    <alerts>
        <fullName>RMA_Creation_Europe_SPIT</fullName>
        <ccEmails>solarit@sunpowercorp.com</ccEmails>
        <ccEmails>RMA_Italia@sunpowercorp.com</ccEmails>
        <ccEmails>serviziotecnico@sunpower.com</ccEmails>
        <description>RMA Creation - Europe - SPIT</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>rma_italia@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Support/RMA_Europe_Created</template>
    </alerts>
    <alerts>
        <fullName>RMA_Creation_Europe_SPNL</fullName>
        <ccEmails>SunPowerNederland@sunpowercorp.com</ccEmails>
        <ccEmails>sunpowernetherlandspartnerservice@sunpowercorp.com</ccEmails>
        <ccEmails>Technischedienst@sunpower.com</ccEmails>
        <description>RMA Creation - Europe - SPNL</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>sunpowernetherlandspartnerservice@sunpower.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Support/RMA_Europe_Created</template>
    </alerts>
    <alerts>
        <fullName>RMA_Europe_Shipping_Confirmation</fullName>
        <description>RMA Europe - Shipping Confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>gbfs-f2d_rma-na@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Support/RMA_Europe_Shipping_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>RMA_Material_Availability_Europe_Default</fullName>
        <ccEmails>sunpoweruk@sunpowercorp.com</ccEmails>
        <ccEmails>orderuk@sunpowercorp.com</ccEmails>
        <ccEmails>techsupport.uk@sunpower.com</ccEmails>
        <description>RMA Material Availability - Europe - Default</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>orderuk@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Support/RMA_Europe_Material_Avail_Challenge</template>
    </alerts>
    <alerts>
        <fullName>RMA_Material_Availability_Europe_SPBE_Flemish</fullName>
        <ccEmails>sunpowerbelgie@sunpowercorp.com</ccEmails>
        <ccEmails>orderbelgium@sunpowercorp.com</ccEmails>
        <ccEmails>Technischedienst@sunpower.com</ccEmails>
        <description>RMA Material Availability - Europe - SPBE - Flemish</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>orderbelgium@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Support/RMA_Europe_Material_Avail_Challenge</template>
    </alerts>
    <alerts>
        <fullName>RMA_Material_Availability_Europe_SPBE_French</fullName>
        <ccEmails>sunpowerbelgique@sunpowercorp.com</ccEmails>
        <ccEmails>orderbelgium@sunpowercorp.com</ccEmails>
        <ccEmails>Supportechniquebelgique@sunpower.com</ccEmails>
        <description>RMA Material Availability - Europe - SPBE - French</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>orderbelgium@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Support/RMA_Europe_Material_Avail_Challenge</template>
    </alerts>
    <alerts>
        <fullName>RMA_Material_Availability_Europe_SPDE</fullName>
        <ccEmails>solarde@sunpowercorp.com</ccEmails>
        <ccEmails>sprd@sunpowercorp.com</ccEmails>
        <ccEmails>technischersupport@sunpower.com</ccEmails>
        <description>RMA Material Availability - Europe - SPDE</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>transportschaden@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Support/RMA_Europe_Material_Avail_Challenge</template>
    </alerts>
    <alerts>
        <fullName>RMA_Material_Availability_Europe_SPES</fullName>
        <ccEmails>solaresp@sunpowercorp.com</ccEmails>
        <ccEmails>pedidos@sunpowercorp.com</ccEmails>
        <ccEmails>soportetecnico@sunpower.com</ccEmails>
        <description>RMA Material Availability - Europe - SPES</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>pedidos@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Support/RMA_Europe_Material_Avail_Challenge</template>
    </alerts>
    <alerts>
        <fullName>RMA_Material_Availability_Europe_SPFR</fullName>
        <ccEmails>solarfr@sunpowercorp.com</ccEmails>
        <ccEmails>Sunpowerfr3psr@sunpowercorp.com</ccEmails>
        <ccEmails>Supporttechnique@sunpower.com</ccEmails>
        <description>RMA Material Availability - Europe - SPFR</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>sunpowerfr3psr@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Support/RMA_Europe_Material_Avail_Challenge</template>
    </alerts>
    <alerts>
        <fullName>RMA_Material_Availability_Europe_SPGB</fullName>
        <ccEmails>sunpoweruk@sunpowercorp.com</ccEmails>
        <ccEmails>orderuk@sunpowercorp.com</ccEmails>
        <ccEmails>techsupport.uk@sunpower.com</ccEmails>
        <description>RMA Material Availability - Europe - SPGB</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>orderuk@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Support/RMA_Europe_Material_Avail_Challenge</template>
    </alerts>
    <alerts>
        <fullName>RMA_Material_Availability_Europe_SPIT</fullName>
        <ccEmails>solarit@sunpowercorp.com</ccEmails>
        <ccEmails>RMA_Italia@sunpowercorp.com</ccEmails>
        <ccEmails>serviziotecnico@sunpower.com</ccEmails>
        <description>RMA Material Availability - Europe - SPIT</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>rma_italia@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Support/RMA_Europe_Material_Avail_Challenge</template>
    </alerts>
    <alerts>
        <fullName>RMA_Material_Availability_Europe_SPNL</fullName>
        <ccEmails>SunPowerNederland@sunpowercorp.com</ccEmails>
        <ccEmails>sunpowernetherlandspartnerservice@sunpowercorp.com</ccEmails>
        <ccEmails>Technischedienst@sunpower.com</ccEmails>
        <description>RMA Material Availability - Europe - SPNL</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>sunpowernetherlandspartnerservice@sunpower.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Support/RMA_Europe_Material_Avail_Challenge</template>
    </alerts>
    <alerts>
        <fullName>RMA_Owner_is_assigned</fullName>
        <description>RMA Owner is assigned</description>
        <protected>false</protected>
        <recipients>
            <field>RMA_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Service_Support/RMA_Owner_is_assigned</template>
    </alerts>
    <alerts>
        <fullName>RMA_Replacement_is_added</fullName>
        <description>RMA Replacement # is added</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Service_Support/RMA_Replacement_Added</template>
    </alerts>
    <alerts>
        <fullName>RMA_Shipping_Confirmation_Europe_Default</fullName>
        <ccEmails>sunpoweruk@sunpowercorp.com</ccEmails>
        <ccEmails>orderuk@sunpowercorp.com</ccEmails>
        <ccEmails>techsupport.uk@sunpower.com</ccEmails>
        <description>RMA Shipping Confirmation - Europe - Default</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>orderuk@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Support/RMA_Europe_Shipping_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>RMA_Shipping_Confirmation_Europe_SPBE_Flemish</fullName>
        <ccEmails>sunpowerbelgie@sunpowercorp.com</ccEmails>
        <ccEmails>orderbelgium@sunpowercorp.com</ccEmails>
        <ccEmails>Technischedienst@sunpower.com</ccEmails>
        <description>RMA Shipping Confirmation - Europe - SPBE - Flemish</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>orderbelgium@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Support/RMA_Europe_Shipping_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>RMA_Shipping_Confirmation_Europe_SPBE_French</fullName>
        <ccEmails>sunpowerbelgique@sunpowercorp.com</ccEmails>
        <ccEmails>orderbelgium@sunpowercorp.com</ccEmails>
        <ccEmails>Supportechniquebelgique@sunpower.com</ccEmails>
        <description>RMA Shipping Confirmation - Europe - SPBE - French</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>orderbelgium@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Support/RMA_Europe_Shipping_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>RMA_Shipping_Confirmation_Europe_SPDE</fullName>
        <ccEmails>solarde@sunpowercorp.com</ccEmails>
        <ccEmails>sprd@sunpowercorp.com</ccEmails>
        <ccEmails>technischersupport@sunpower.com</ccEmails>
        <description>RMA Shipping Confirmation - Europe - SPDE</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>transportschaden@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Support/RMA_Europe_Shipping_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>RMA_Shipping_Confirmation_Europe_SPES</fullName>
        <ccEmails>solaresp@sunpowercorp.com</ccEmails>
        <ccEmails>pedidos@sunpowercorp.com</ccEmails>
        <ccEmails>soportetecnico@sunpower.com</ccEmails>
        <description>RMA Shipping Confirmation - Europe - SPES</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>pedidos@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Support/RMA_Europe_Shipping_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>RMA_Shipping_Confirmation_Europe_SPFR</fullName>
        <ccEmails>solarfr@sunpowercorp.com</ccEmails>
        <ccEmails>Sunpowerfr3psr@sunpowercorp.com</ccEmails>
        <ccEmails>Supporttechnique@sunpower.com</ccEmails>
        <description>RMA Shipping Confirmation - Europe - SPFR</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>sunpowerfr3psr@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Support/RMA_Europe_Shipping_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>RMA_Shipping_Confirmation_Europe_SPGB</fullName>
        <ccEmails>sunpoweruk@sunpowercorp.com</ccEmails>
        <ccEmails>orderuk@sunpowercorp.com</ccEmails>
        <ccEmails>techsupport.uk@sunpower.com</ccEmails>
        <description>RMA Shipping Confirmation - Europe - SPGB</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>orderuk@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Support/RMA_Europe_Shipping_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>RMA_Shipping_Confirmation_Europe_SPIT</fullName>
        <ccEmails>solarit@sunpowercorp.com</ccEmails>
        <ccEmails>RMA_Italia@sunpowercorp.com</ccEmails>
        <ccEmails>serviziotecnico@sunpower.com</ccEmails>
        <description>RMA Shipping Confirmation - Europe - SPIT</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>rma_italia@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Support/RMA_Europe_Shipping_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>RMA_Shipping_Confirmation_Europe_SPNL</fullName>
        <ccEmails>SunPowerNederland@sunpowercorp.com</ccEmails>
        <ccEmails>sunpowernetherlandspartnerservice@sunpowercorp.com</ccEmails>
        <ccEmails>Technischedienst@sunpower.com</ccEmails>
        <description>RMA Shipping Confirmation - Europe - SPNL</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>sunpowernetherlandspartnerservice@sunpower.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Support/RMA_Europe_Shipping_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>RMA_Shipping_confirmation_Return_Credit_English</fullName>
        <description>RMA Shipping confirmation - Return Credit - English</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>gbfs-f2d_rma-na@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Support/RMA_Shipping_confirmation_Return_Credit_English</template>
    </alerts>
    <alerts>
        <fullName>RMA_Shipping_confirmation_Unit_Sent_by_Vendor_English</fullName>
        <description>RMA Shipping confirmation - Unit Sent by Vendor - English</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>gbfs-f2d_rma-na@sunpowercorp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Support/RMA_Shipping_confirmation_Unit_Sent_by_Vendor_English</template>
    </alerts>
    <alerts>
        <fullName>RMA_Tracking_is_added</fullName>
        <description>RMA Tracking # is added</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Service_Support/RMA_Tracking_Added</template>
    </alerts>
    <alerts>
        <fullName>RMA_is_created</fullName>
        <description>RMA Creation Communication for all Languages</description>
        <protected>false</protected>
        <recipients>
            <field>Attention_To_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>CC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Service_Support/RMA_is_created</template>
    </alerts>
    <fieldUpdates>
        <fullName>RMA_RecordType_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>RMA_Layout_After_Edit</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>RMA RecordType Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Reminder_Date</fullName>
        <field>Missing_Tracking_Reminder_Date__c</field>
        <formula>CASE(CASE(MOD(TODAY()-DATE(1900,1,7),7), 
0,&quot;Sun&quot;,
1,&quot;Mon&quot;,
2,&quot;Tue&quot;,
3,&quot;Wed&quot;,
4,&quot;Thu&quot;,
5,&quot;Fri&quot;,
6,&quot;Sat&quot;,
&quot;Error&quot;),
&quot;Mon&quot;,TODAY()+3,
&quot;Tue&quot;,TODAY()+ 3,
&quot;Wed&quot;,TODAY()+ 5,
&quot;Thu&quot;,TODAY()+ 5,
&quot;Fri&quot;,TODAY()+ 5,
&quot;Sat&quot;,TODAY()+ 4,
&quot;Sun&quot;,TODAY()+ 3,
TODAY()+30)</formula>
        <name>Set Reminder Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Closed_Date</fullName>
        <field>ClosedDate__c</field>
        <formula>TODAY()</formula>
        <name>Update Closed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>RMA Closed Date Time Stamp</fullName>
        <actions>
            <name>Update_Closed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(   ISCHANGED(RMA_Status_Category__c),   ISPICKVAL(RMA_Status_Category__c, &quot;Closed&quot;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RMA Creation - Europe - Default</fullName>
        <actions>
            <name>RMA_Creation_Europe_Default</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Case# 00738620_Extend RMA Emails to EMEA</description>
        <formula>AND (     ISPICKVAL(Case__r.Account.Theater__c, &apos;Europe&apos;),     AND (     NOT(ISPICKVAL(Case__r.Region__c, &apos;SPTN&apos;)),     NOT(AND(ISPICKVAL(Case__r.Region__c, &apos;SPBE&apos;), ISPICKVAL(Case__r.Contact.Contact_Language__c, &apos;Dutch&apos;))),     NOT(AND(ISPICKVAL(Case__r.Region__c, &apos;SPBE&apos;), ISPICKVAL(Case__r.Contact.Contact_Language__c, &apos;French&apos;))),     NOT(ISPICKVAL(Case__r.Region__c, &apos;SPDE&apos;)),     NOT(ISPICKVAL(Case__r.Region__c, &apos;SPES&apos;)),     NOT(ISPICKVAL(Case__r.Region__c, &apos;SPFR&apos;)),     NOT(ISPICKVAL(Case__r.Region__c, &apos;SPGB&apos;)),     NOT(ISPICKVAL(Case__r.Region__c, &apos;SPIT&apos;)),     NOT(ISPICKVAL(Case__r.Region__c, &apos;SPNL&apos;))     ),     OR (         ISPICKVAL(Disposition__c, &apos;Return-Replacement - SPWR&apos;),              ISPICKVAL(Disposition__c, &apos;Scrapped&apos;)      ),     NOT(ISBLANK(Attention_To_Email__c)) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RMA Creation - Europe - SPBE - Flemish</fullName>
        <actions>
            <name>RMA_Creation_Europe_SPBE_Flemish</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Case# 00738620_Extend RMA Emails to EMEA</description>
        <formula>AND (     ISPICKVAL(Case__r.Account.Theater__c, &apos;Europe&apos;),     ISPICKVAL(Case__r.Region__c, &apos;SPBE&apos;),     ISPICKVAL(Case__r.Contact.Contact_Language__c, &apos;Dutch&apos;),     OR (         ISPICKVAL(Disposition__c, &apos;Return-Replacement - SPWR&apos;),              ISPICKVAL(Disposition__c, &apos;Scrapped&apos;)      ),     NOT(ISBLANK(Attention_To_Email__c)) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RMA Creation - Europe - SPBE - French</fullName>
        <actions>
            <name>RMA_Creation_Europe_SPBE_French</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Case# 00738620_Extend RMA Emails to EMEA</description>
        <formula>AND (     ISPICKVAL(Case__r.Account.Theater__c, &apos;Europe&apos;),     ISPICKVAL(Case__r.Region__c, &apos;SPBE&apos;),     ISPICKVAL(Case__r.Contact.Contact_Language__c, &apos;French&apos;),     OR (         ISPICKVAL(Disposition__c, &apos;Return-Replacement - SPWR&apos;),              ISPICKVAL(Disposition__c, &apos;Scrapped&apos;)      ),     NOT(ISBLANK(Attention_To_Email__c)) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RMA Creation - Europe - SPDE</fullName>
        <actions>
            <name>RMA_Creation_Europe_SPDE</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Case# 00738620_Extend RMA Emails to EMEA</description>
        <formula>AND (     ISPICKVAL(Case__r.Account.Theater__c, &apos;Europe&apos;),     ISPICKVAL(Case__r.Region__c, &apos;SPDE&apos;),     OR (         ISPICKVAL(Disposition__c, &apos;Return-Replacement - SPWR&apos;),              ISPICKVAL(Disposition__c, &apos;Scrapped&apos;)      ),     NOT(ISBLANK(Attention_To_Email__c)) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RMA Creation - Europe - SPES</fullName>
        <actions>
            <name>RMA_Creation_Europe_SPES</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Case# 00738620_Extend RMA Emails to EMEA</description>
        <formula>AND (     ISPICKVAL(Case__r.Account.Theater__c, &apos;Europe&apos;),     ISPICKVAL(Case__r.Region__c, &apos;SPES&apos;),     OR (         ISPICKVAL(Disposition__c, &apos;Return-Replacement - SPWR&apos;),              ISPICKVAL(Disposition__c, &apos;Scrapped&apos;)      ),     NOT(ISBLANK(Attention_To_Email__c)) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RMA Creation - Europe - SPFR</fullName>
        <actions>
            <name>RMA_Creation_Europe_SPFR</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Case# 00738620_Extend RMA Emails to EMEA</description>
        <formula>AND (     ISPICKVAL(Case__r.Account.Theater__c, &apos;Europe&apos;),     ISPICKVAL(Case__r.Region__c, &apos;SPFR&apos;),     OR (         ISPICKVAL(Disposition__c, &apos;Return-Replacement - SPWR&apos;),              ISPICKVAL(Disposition__c, &apos;Scrapped&apos;)      ),     NOT(ISBLANK(Attention_To_Email__c)) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RMA Creation - Europe - SPGB</fullName>
        <actions>
            <name>RMA_Creation_Europe_SPGB</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Case# 00738620_Extend RMA Emails to EMEA</description>
        <formula>AND (     ISPICKVAL(Case__r.Account.Theater__c, &apos;Europe&apos;),     ISPICKVAL(Case__r.Region__c, &apos;SPGB&apos;),     OR (         ISPICKVAL(Disposition__c, &apos;Return-Replacement - SPWR&apos;),              ISPICKVAL(Disposition__c, &apos;Scrapped&apos;)      ),     NOT(ISBLANK(Attention_To_Email__c)) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RMA Creation - Europe - SPIT</fullName>
        <actions>
            <name>RMA_Creation_Europe_SPIT</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Case# 00738620_Extend RMA Emails to EMEA</description>
        <formula>AND (     ISPICKVAL(Case__r.Account.Theater__c, &apos;Europe&apos;),     ISPICKVAL(Case__r.Region__c, &apos;SPIT&apos;),     OR (         ISPICKVAL(Disposition__c, &apos;Return-Replacement - SPWR&apos;),              ISPICKVAL(Disposition__c, &apos;Scrapped&apos;)      ),     NOT(ISBLANK(Attention_To_Email__c)) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RMA Creation - Europe - SPNL</fullName>
        <actions>
            <name>RMA_Creation_Europe_SPNL</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Case# 00738620_Extend RMA Emails to EMEA</description>
        <formula>AND (     ISPICKVAL(Case__r.Account.Theater__c, &apos;Europe&apos;),     ISPICKVAL(Case__r.Region__c, &apos;SPNL&apos;),     OR (         ISPICKVAL(Disposition__c, &apos;Return-Replacement - SPWR&apos;),              ISPICKVAL(Disposition__c, &apos;Scrapped&apos;)      ),     NOT(ISBLANK(Attention_To_Email__c)) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RMA Material Availability - Europe - Default</fullName>
        <active>true</active>
        <description>Case# 00738620_Extend RMA Emails to EMEA</description>
        <formula>AND(   ISPICKVAL(Case__r.Account.Theater__c, &apos;Europe&apos;),      AND (     NOT(ISPICKVAL(Case__r.Region__c, &apos;SPTN&apos;)),     NOT(AND(ISPICKVAL(Case__r.Region__c, &apos;SPBE&apos;), ISPICKVAL(Case__r.Contact.Contact_Language__c, &apos;Dutch&apos;))),     NOT(AND(ISPICKVAL(Case__r.Region__c, &apos;SPBE&apos;), ISPICKVAL(Case__r.Contact.Contact_Language__c, &apos;French&apos;))),     NOT(ISPICKVAL(Case__r.Region__c, &apos;SPDE&apos;)),     NOT(ISPICKVAL(Case__r.Region__c, &apos;SPES&apos;)),     NOT(ISPICKVAL(Case__r.Region__c, &apos;SPFR&apos;)),     NOT(ISPICKVAL(Case__r.Region__c, &apos;SPGB&apos;)),     NOT(ISPICKVAL(Case__r.Region__c, &apos;SPIT&apos;)),     NOT(ISPICKVAL(Case__r.Region__c, &apos;SPNL&apos;))     ),   OR(     ISPICKVAL(Disposition__c, &apos;Return-Replacement - SPWR&apos;),     ISPICKVAL(Disposition__c, &apos;Scrapped&apos;)   ),   ISBLANK(Delivery_Date_of_Replacement_unit_s__c),   ISBLANK(Packing_List__c),   NOT(ISBLANK(Attention_To_Email__c)) )</formula>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>RMA_Material_Availability_Europe_Default</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>RMA__c.CreatedDate</offsetFromField>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>RMA Material Availability - Europe - SPBE - Flemish</fullName>
        <active>true</active>
        <description>Case# 00738620_Extend RMA Emails to EMEA</description>
        <formula>AND(   ISPICKVAL(Case__r.Account.Theater__c, &apos;Europe&apos;),    ISPICKVAL(Case__r.Region__c, &apos;SPBE&apos;),   ISPICKVAL(Case__r.Contact.Contact_Language__c, &apos;Dutch&apos;),   OR(     ISPICKVAL(Disposition__c, &apos;Return-Replacement - SPWR&apos;),     ISPICKVAL(Disposition__c, &apos;Scrapped&apos;)   ),   ISBLANK(Delivery_Date_of_Replacement_unit_s__c),   ISBLANK(Packing_List__c),   NOT(ISBLANK(Attention_To_Email__c)) )</formula>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>RMA_Material_Availability_Europe_SPBE_Flemish</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>RMA__c.CreatedDate</offsetFromField>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>RMA Material Availability - Europe - SPBE - French</fullName>
        <active>true</active>
        <description>Case# 00738620_Extend RMA Emails to EMEA</description>
        <formula>AND(   ISPICKVAL(Case__r.Account.Theater__c, &apos;Europe&apos;),    ISPICKVAL(Case__r.Region__c, &apos;SPBE&apos;),   ISPICKVAL(Case__r.Contact.Contact_Language__c, &apos;French&apos;),   OR(     ISPICKVAL(Disposition__c, &apos;Return-Replacement - SPWR&apos;),     ISPICKVAL(Disposition__c, &apos;Scrapped&apos;)   ),   ISBLANK(Delivery_Date_of_Replacement_unit_s__c),   ISBLANK(Packing_List__c),   NOT(ISBLANK(Attention_To_Email__c)) )</formula>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>RMA_Material_Availability_Europe_SPBE_French</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>RMA__c.CreatedDate</offsetFromField>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>RMA Material Availability - Europe - SPDE</fullName>
        <active>true</active>
        <description>Case# 00738620_Extend RMA Emails to EMEA</description>
        <formula>AND(   ISPICKVAL(Case__r.Account.Theater__c, &apos;Europe&apos;),    ISPICKVAL(Case__r.Region__c, &apos;SPDE&apos;),   OR(     ISPICKVAL(Disposition__c, &apos;Return-Replacement - SPWR&apos;),     ISPICKVAL(Disposition__c, &apos;Scrapped&apos;)   ),   ISBLANK(Delivery_Date_of_Replacement_unit_s__c),   ISBLANK(Packing_List__c),   NOT(ISBLANK(Attention_To_Email__c)) )</formula>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>RMA_Material_Availability_Europe_SPDE</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>RMA__c.CreatedDate</offsetFromField>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>RMA Material Availability - Europe - SPES</fullName>
        <active>true</active>
        <description>Case# 00738620_Extend RMA Emails to EMEA</description>
        <formula>AND(   ISPICKVAL(Case__r.Account.Theater__c, &apos;Europe&apos;),    ISPICKVAL(Case__r.Region__c, &apos;SPES&apos;),   OR(     ISPICKVAL(Disposition__c, &apos;Return-Replacement - SPWR&apos;),     ISPICKVAL(Disposition__c, &apos;Scrapped&apos;)   ),   ISBLANK(Delivery_Date_of_Replacement_unit_s__c),   ISBLANK(Packing_List__c),   NOT(ISBLANK(Attention_To_Email__c)) )</formula>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>RMA_Material_Availability_Europe_SPES</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>RMA__c.CreatedDate</offsetFromField>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>RMA Material Availability - Europe - SPFR</fullName>
        <active>true</active>
        <description>Case# 00738620_Extend RMA Emails to EMEA</description>
        <formula>AND(   ISPICKVAL(Case__r.Account.Theater__c, &apos;Europe&apos;),    ISPICKVAL(Case__r.Region__c, &apos;SPFR&apos;),   OR(     ISPICKVAL(Disposition__c, &apos;Return-Replacement - SPWR&apos;),     ISPICKVAL(Disposition__c, &apos;Scrapped&apos;)   ),   ISBLANK(Delivery_Date_of_Replacement_unit_s__c),   ISBLANK(Packing_List__c),   NOT(ISBLANK(Attention_To_Email__c)) )</formula>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>RMA_Material_Availability_Europe_SPFR</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>RMA__c.CreatedDate</offsetFromField>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>RMA Material Availability - Europe - SPGB</fullName>
        <active>true</active>
        <description>Case# 00738620_Extend RMA Emails to EMEA</description>
        <formula>AND(   ISPICKVAL(Case__r.Account.Theater__c, &apos;Europe&apos;),    ISPICKVAL(Case__r.Region__c, &apos;SPGB&apos;),   OR(     ISPICKVAL(Disposition__c, &apos;Return-Replacement - SPWR&apos;),     ISPICKVAL(Disposition__c, &apos;Scrapped&apos;)   ),   ISBLANK(Delivery_Date_of_Replacement_unit_s__c),   ISBLANK(Packing_List__c),   NOT(ISBLANK(Attention_To_Email__c)) )</formula>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>RMA_Material_Availability_Europe_SPGB</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>RMA__c.CreatedDate</offsetFromField>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>RMA Material Availability - Europe - SPIT</fullName>
        <active>true</active>
        <description>Case# 00738620_Extend RMA Emails to EMEA</description>
        <formula>AND(   ISPICKVAL(Case__r.Account.Theater__c, &apos;Europe&apos;),    ISPICKVAL(Case__r.Region__c, &apos;SPIT&apos;),   OR(     ISPICKVAL(Disposition__c, &apos;Return-Replacement - SPWR&apos;),     ISPICKVAL(Disposition__c, &apos;Scrapped&apos;)   ),   ISBLANK(Delivery_Date_of_Replacement_unit_s__c),   ISBLANK(Packing_List__c),   NOT(ISBLANK(Attention_To_Email__c)) )</formula>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>RMA_Material_Availability_Europe_SPIT</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>RMA__c.CreatedDate</offsetFromField>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>RMA Material Availability - Europe - SPNL</fullName>
        <active>true</active>
        <description>Case# 00738620_Extend RMA Emails to EMEA</description>
        <formula>AND(   ISPICKVAL(Case__r.Account.Theater__c, &apos;Europe&apos;),    ISPICKVAL(Case__r.Region__c, &apos;SPNL&apos;),   OR(     ISPICKVAL(Disposition__c, &apos;Return-Replacement - SPWR&apos;),     ISPICKVAL(Disposition__c, &apos;Scrapped&apos;)   ),   ISBLANK(Delivery_Date_of_Replacement_unit_s__c),   ISBLANK(Packing_List__c),   NOT(ISBLANK(Attention_To_Email__c)) )</formula>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>RMA_Material_Availability_Europe_SPNL</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>RMA__c.CreatedDate</offsetFromField>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>RMA Owner is assigned</fullName>
        <actions>
            <name>RMA_Owner_is_assigned</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Email notification when RMA Owner is assigned</description>
        <formula>AND(   NOT(ISBLANK(RMA_Owner__c)),   OR(     ISNEW(),     ISCHANGED(RMA_Owner__c)   )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RMA RecordType Update</fullName>
        <actions>
            <name>RMA_RecordType_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>RMA__c.RMA_Owner__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RMA Shipping Confirmation - Europe - Default</fullName>
        <actions>
            <name>RMA_Shipping_Confirmation_Europe_Default</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Case# 00738620_Extend RMA Emails to EMEA</description>
        <formula>AND (     ISPICKVAL(Case__r.Account.Theater__c, &apos;Europe&apos;),     AND (     NOT(ISPICKVAL(Case__r.Region__c, &apos;SPTN&apos;)),     NOT(AND(ISPICKVAL(Case__r.Region__c, &apos;SPBE&apos;), ISPICKVAL(Case__r.Contact.Contact_Language__c, &apos;Dutch&apos;))),     NOT(AND(ISPICKVAL(Case__r.Region__c, &apos;SPBE&apos;), ISPICKVAL(Case__r.Contact.Contact_Language__c, &apos;French&apos;))),     NOT(ISPICKVAL(Case__r.Region__c, &apos;SPDE&apos;)),     NOT(ISPICKVAL(Case__r.Region__c, &apos;SPES&apos;)),     NOT(ISPICKVAL(Case__r.Region__c, &apos;SPFR&apos;)),     NOT(ISPICKVAL(Case__r.Region__c, &apos;SPGB&apos;)),     NOT(ISPICKVAL(Case__r.Region__c, &apos;SPIT&apos;)),     NOT(ISPICKVAL(Case__r.Region__c, &apos;SPNL&apos;))     ),     ISPICKVAL(Disposition__c, &apos;Return-Replacement - SPWR&apos;),     NOT(ISBLANK(Delivery_Date_of_Replacement_unit_s__c)),         NOT(ISBLANK(Packing_List__c)),         NOT(ISBLANK(Attention_To_Email__c))     )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RMA Shipping Confirmation - Europe - SPBE - Flemish</fullName>
        <actions>
            <name>RMA_Shipping_Confirmation_Europe_SPBE_Flemish</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Case# 00738620_Extend RMA Emails to EMEA</description>
        <formula>AND (     ISPICKVAL(Case__r.Account.Theater__c, &apos;Europe&apos;),     ISPICKVAL(Case__r.Region__c, &apos;SPBE&apos;),     ISPICKVAL(Case__r.Contact.Contact_Language__c, &apos;Dutch&apos;),     ISPICKVAL(Disposition__c, &apos;Return-Replacement - SPWR&apos;),     NOT(ISBLANK(Delivery_Date_of_Replacement_unit_s__c)),         NOT(ISBLANK(Packing_List__c)),         NOT(ISBLANK(Attention_To_Email__c))     )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RMA Shipping Confirmation - Europe - SPBE - French</fullName>
        <actions>
            <name>RMA_Shipping_Confirmation_Europe_SPBE_French</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Case# 00738620_Extend RMA Emails to EMEA</description>
        <formula>AND (     ISPICKVAL(Case__r.Account.Theater__c, &apos;Europe&apos;),     ISPICKVAL(Case__r.Region__c, &apos;SPBE&apos;),     ISPICKVAL(Case__r.Contact.Contact_Language__c, &apos;French&apos;),     ISPICKVAL(Disposition__c, &apos;Return-Replacement - SPWR&apos;),     NOT(ISBLANK(Delivery_Date_of_Replacement_unit_s__c)),         NOT(ISBLANK(Packing_List__c)),         NOT(ISBLANK(Attention_To_Email__c))     )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RMA Shipping Confirmation - Europe - SPDE</fullName>
        <actions>
            <name>RMA_Shipping_Confirmation_Europe_SPDE</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Case# 00738620_Extend RMA Emails to EMEA</description>
        <formula>AND (     ISPICKVAL(Case__r.Account.Theater__c, &apos;Europe&apos;),     ISPICKVAL(Case__r.Region__c, &apos;SPDE&apos;),     ISPICKVAL(Disposition__c, &apos;Return-Replacement - SPWR&apos;),     NOT(ISBLANK(Delivery_Date_of_Replacement_unit_s__c)),         NOT(ISBLANK(Packing_List__c)),         NOT(ISBLANK(Attention_To_Email__c))     )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RMA Shipping Confirmation - Europe - SPES</fullName>
        <actions>
            <name>RMA_Shipping_Confirmation_Europe_SPES</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Case# 00738620_Extend RMA Emails to EMEA</description>
        <formula>AND (     ISPICKVAL(Case__r.Account.Theater__c, &apos;Europe&apos;),     ISPICKVAL(Case__r.Region__c, &apos;SPES&apos;),     ISPICKVAL(Disposition__c, &apos;Return-Replacement - SPWR&apos;),     NOT(ISBLANK(Delivery_Date_of_Replacement_unit_s__c)),         NOT(ISBLANK(Packing_List__c)),         NOT(ISBLANK(Attention_To_Email__c))     )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RMA Shipping Confirmation - Europe - SPFR</fullName>
        <actions>
            <name>RMA_Shipping_Confirmation_Europe_SPFR</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Case# 00738620_Extend RMA Emails to EMEA</description>
        <formula>AND (     ISPICKVAL(Case__r.Account.Theater__c, &apos;Europe&apos;),     ISPICKVAL(Case__r.Region__c, &apos;SPFR&apos;),     ISPICKVAL(Disposition__c, &apos;Return-Replacement - SPWR&apos;),     NOT(ISBLANK(Delivery_Date_of_Replacement_unit_s__c)),         NOT(ISBLANK(Packing_List__c)),         NOT(ISBLANK(Attention_To_Email__c))     )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RMA Shipping Confirmation - Europe - SPGB</fullName>
        <actions>
            <name>RMA_Shipping_Confirmation_Europe_SPGB</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Case# 00738620_Extend RMA Emails to EMEA</description>
        <formula>AND (     ISPICKVAL(Case__r.Account.Theater__c, &apos;Europe&apos;),     ISPICKVAL(Case__r.Region__c, &apos;SPGB&apos;),     ISPICKVAL(Disposition__c, &apos;Return-Replacement - SPWR&apos;),     NOT(ISBLANK(Delivery_Date_of_Replacement_unit_s__c)),         NOT(ISBLANK(Packing_List__c)),         NOT(ISBLANK(Attention_To_Email__c))     )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RMA Shipping Confirmation - Europe - SPIT</fullName>
        <actions>
            <name>RMA_Shipping_Confirmation_Europe_SPIT</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Case# 00738620_Extend RMA Emails to EMEA</description>
        <formula>AND (     ISPICKVAL(Case__r.Account.Theater__c, &apos;Europe&apos;),     ISPICKVAL(Case__r.Region__c, &apos;SPIT&apos;),     ISPICKVAL(Disposition__c, &apos;Return-Replacement - SPWR&apos;),     NOT(ISBLANK(Delivery_Date_of_Replacement_unit_s__c)),         NOT(ISBLANK(Packing_List__c)),         NOT(ISBLANK(Attention_To_Email__c))     )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RMA Shipping Confirmation - Europe - SPNL</fullName>
        <actions>
            <name>RMA_Shipping_Confirmation_Europe_SPNL</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Case# 00738620_Extend RMA Emails to EMEA</description>
        <formula>AND (     ISPICKVAL(Case__r.Account.Theater__c, &apos;Europe&apos;),     ISPICKVAL(Case__r.Region__c, &apos;SPNL&apos;),     ISPICKVAL(Disposition__c, &apos;Return-Replacement - SPWR&apos;),     NOT(ISBLANK(Delivery_Date_of_Replacement_unit_s__c)),         NOT(ISBLANK(Packing_List__c)),         NOT(ISBLANK(Attention_To_Email__c))     )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RMA Tracking Number Reminder</fullName>
        <actions>
            <name>Set_Reminder_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(ISBLANK(RMA_Replacement__c),ISBLANK(Tracking_No__c), OR(ISPICKVAL(Case__r.Account.Theater__c, &apos;North America&apos;), ISPICKVAL(Case__r.Account.Theater__c, &apos;Central America and the Caribbean&apos;)))</formula>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Missing_Tracking_Number_Email_Notification</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>RMA__c.Missing_Tracking_Reminder_Date__c</offsetFromField>
            <timeLength>8</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
