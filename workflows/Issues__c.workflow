<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Pinched_Busbar_PBB_Program_Issue_Notification</fullName>
        <description>Pinched Busbar (PBB) Program Issue Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>tory.finn@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Issue/Case_Notification_for_Incident_or_General_Notification_Alert</template>
    </alerts>
    <alerts>
        <fullName>SFDC_Corrosion_Case</fullName>
        <ccEmails>Chelsea.Teall@sunpowercorp.com</ccEmails>
        <description>SFDC Corrosion Case</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>zach.campeau@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Issue/SFDC_Corrosion_Case</template>
    </alerts>
    <alerts>
        <fullName>SFDC_Module_Case</fullName>
        <ccEmails>Sander.Caldwell@sunpowercorp.com</ccEmails>
        <ccEmails>Lauren.Leonard@sunpowercorp.com</ccEmails>
        <ccEmails>Jeremy.Nguyen@sunpowercorp.com</ccEmails>
        <ccEmails>Dominic.Yumul@sunpowercorp.com</ccEmails>
        <ccEmails>Laetitia.RodriguesBarbosa@sunpowercorp.com</ccEmails>
        <description>SFDC Module Case</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>dominic.yumul@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>zach.campeau@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Issue/SFDC_Module_Case</template>
    </alerts>
    <alerts>
        <fullName>SFDC_Module_Case_2</fullName>
        <ccEmails>Trexie.Lozada@sunpowercorp.com</ccEmails>
        <ccEmails>Dennis.Mendiola@sunpowercorp.com</ccEmails>
        <ccEmails>Venerando.Miralles@sunpowercorp.com</ccEmails>
        <ccEmails>Ryan.Lacerda@sunpowercorp.com</ccEmails>
        <description>SFDC Module Case 2</description>
        <protected>false</protected>
        <recipients>
            <recipient>glorymay.lumauig@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ma.niza.arinaza@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Issue/SFDC_Module_Case</template>
    </alerts>
    <alerts>
        <fullName>SFDC_PE_Case</fullName>
        <ccEmails>Hamid.Pourzand@sunpowercorp.com</ccEmails>
        <ccEmails>Ma.Niza.Arinaza@sunpowercorp.com</ccEmails>
        <description>SFDC PE Case</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>dominic.yumul@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jeremy.nguyen@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>salesforcearchives@sunpowercorp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Issue/SFDC_PE_Case</template>
    </alerts>
    <rules>
        <fullName>Pinched Busbar %28PBB%29 Program Issue Notification</fullName>
        <actions>
            <name>Pinched_Busbar_PBB_Program_Issue_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>((1 AND 2) AND (3 or  4)) or ((5 and 6) or (7))</booleanFilter>
        <criteriaItems>
            <field>Issues__c.Product_Category__c</field>
            <operation>equals</operation>
            <value>modules</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issues__c.Part__c</field>
            <operation>startsWith</operation>
            <value>SPR</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issues__c.Problem__c</field>
            <operation>equals</operation>
            <value>low power,hot cells</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issues__c.Problem__c</field>
            <operation>startsWith</operation>
            <value>PBB</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issues__c.Name</field>
            <operation>contains</operation>
            <value>Burn</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issues__c.Name</field>
            <operation>contains</operation>
            <value>Mark</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issues__c.Name</field>
            <operation>contains</operation>
            <value>Burnt Cells,Burn Marks,Hot Spots,Hot Cells,PBB,underperforming,Power Degradation</value>
        </criteriaItems>
        <description>Pinched Busbar (PBB) Program Issue Notification</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SFDC Corrosion Case</fullName>
        <actions>
            <name>SFDC_Corrosion_Case</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR  2</booleanFilter>
        <criteriaItems>
            <field>Issues__c.Problem__c</field>
            <operation>equals</operation>
            <value>Corrosion,Corrosion on contacts</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issues__c.Cause__c</field>
            <operation>equals</operation>
            <value>Evironmental - Salt exposure,Cold Galvanization bad,Plant growth,Environmental - degradation,Bad Anodization,Environmental - corrosion</value>
        </criteriaItems>
        <description>SFDC Corrosion Case</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SFDC Module Case</fullName>
        <actions>
            <name>SFDC_Module_Case</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>SFDC_Module_Case_2</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>((1 OR 2) Or (1 AND 2)) AND 3</booleanFilter>
        <criteriaItems>
            <field>Issues__c.Location__c</field>
            <operation>equals</operation>
            <value>Module</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issues__c.Product_Category__c</field>
            <operation>equals</operation>
            <value>modules</value>
        </criteriaItems>
        <criteriaItems>
            <field>Issues__c.Cause__c</field>
            <operation>notEqual</operation>
            <value>shipping issue,maintenance issue,vandalism,Soiling,Connector loose,impact - unknown,Polarization,Shading,installation issue</value>
        </criteriaItems>
        <description>SFDC Module Case</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SFDC PE Case</fullName>
        <actions>
            <name>SFDC_PE_Case</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Issues__c.PE_Action__c</field>
            <operation>equals</operation>
            <value>Requires Engineering</value>
        </criteriaItems>
        <description>SFDC PE Case</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
