<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Final_Metric_Rejection</fullName>
        <ccEmails>hemant.garg@metacube.com</ccEmails>
        <description>Final Metric Rejection</description>
        <protected>false</protected>
        <recipients>
            <field>File_Submitted_By_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_Email_Alerts/Final_Metric_Rejection</template>
    </alerts>
    <alerts>
        <fullName>Metric_Document_Resubmission_Notification</fullName>
        <description>Metric Document Resubmission Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>MarketingUsers</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_Email_Alerts/Metric_Document_Resubmission</template>
    </alerts>
    <alerts>
        <fullName>Metric_Rejection_Notification_French</fullName>
        <description>Metric Rejection Notification French</description>
        <protected>false</protected>
        <recipients>
            <field>File_Submitted_By_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sunrise_Marketing_Review/Upload_new_proof_French</template>
    </alerts>
    <alerts>
        <fullName>Metric_Rejection_Notification_German</fullName>
        <description>Metric Rejection Notification German</description>
        <protected>false</protected>
        <recipients>
            <field>File_Submitted_By_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sunrise_Marketing_Review/Upload_new_proof_German</template>
    </alerts>
    <alerts>
        <fullName>Metric_Rejection_Notification_Italian</fullName>
        <description>Metric Rejection Notification Italian</description>
        <protected>false</protected>
        <recipients>
            <field>File_Submitted_By_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sunrise_Marketing_Review/Uploan_new_proof_Italian</template>
    </alerts>
    <alerts>
        <fullName>Metric_Rejection_Notification_USA</fullName>
        <description>Metric Rejection Notification USA</description>
        <protected>false</protected>
        <recipients>
            <field>File_Submitted_By_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sunrise_Marketing_Review/Upload_new_proof_USA</template>
    </alerts>
    <fieldUpdates>
        <fullName>Disable_Attachment</fullName>
        <field>Attachment_Disabled__c</field>
        <literalValue>1</literalValue>
        <name>Disable_Attachment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Metric File Resubmission</fullName>
        <actions>
            <name>Metric_Document_Resubmission_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Metric__c.File_Submission_Count__c</field>
            <operation>equals</operation>
            <value>2</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Added byPassValidation check on 12/5/2011 for case#00088905</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Metric Rejected Finally</fullName>
        <actions>
            <name>Final_Metric_Rejection</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>System Administrator,SunPower Super User,SunPower User</value>
        </criteriaItems>
        <criteriaItems>
            <field>Metric__c.Boolean_Achievement__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Metric__c.File_Submission_Count__c</field>
            <operation>equals</operation>
            <value>2</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ByPassValidation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>If a metric is rejected finally after resubmission then sent email notification to the partner.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Metric Rejected French</fullName>
        <actions>
            <name>Metric_Rejection_Notification_French</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>If a metric is rejected then send email notification to the partner</description>
        <formula>(CreatedDate &lt;&gt; LastModifiedDate) &amp;&amp; (Boolean_Achievement__c == false) &amp;&amp; (File_Submission_Count__c == 1) &amp;&amp; ($Profile.Name == &apos;System Administrator&apos; || $Profile.Name == &apos;SunPower Super User&apos; || $Profile.Name == &apos;SunPower User&apos;) &amp;&amp; OR(ISPICKVAL( Account__r.Country_Domain__c , &apos;rvar-fr&apos;) , ISPICKVAL( Account__r.Country_Domain__c , &apos;cvar-fr&apos;) , ISPICKVAL( Account__r.Country_Domain__c , &apos;combo-fr&apos;)) &amp;&amp;  NOT($User.ByPassValidation__c)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Disable_Attachment</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>48</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Metric Rejected Germany</fullName>
        <actions>
            <name>Metric_Rejection_Notification_German</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>If a metric is rejected then send email notification to the partner</description>
        <formula>(CreatedDate &lt;&gt; LastModifiedDate) &amp;&amp; (Boolean_Achievement__c == false) &amp;&amp; (File_Submission_Count__c == 1) &amp;&amp; ($Profile.Name == &apos;System Administrator&apos; || $Profile.Name == &apos;SunPower Super User&apos; || $Profile.Name == &apos;SunPower User&apos;) &amp;&amp; OR(ISPICKVAL( Account__r.Country_Domain__c , &apos;rvar-de&apos;) , ISPICKVAL( Account__r.Country_Domain__c , &apos;cvar-de&apos;) , ISPICKVAL( Account__r.Country_Domain__c , &apos;combo-de&apos;)) &amp;&amp;  NOT($User.ByPassValidation__c)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Disable_Attachment</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>48</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Metric Rejected Italy</fullName>
        <actions>
            <name>Metric_Rejection_Notification_Italian</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>If a metric is rejected then send email notification to the partner</description>
        <formula>(CreatedDate &lt;&gt; LastModifiedDate) &amp;&amp; (Boolean_Achievement__c == false) &amp;&amp; (File_Submission_Count__c == 1) &amp;&amp; ($Profile.Name == &apos;System Administrator&apos; || $Profile.Name == &apos;SunPower Super User&apos; || $Profile.Name == &apos;SunPower User&apos;) &amp;&amp; OR(ISPICKVAL( Account__r.Country_Domain__c , &apos;rvar-it&apos;) , ISPICKVAL( Account__r.Country_Domain__c , &apos;cvar-it&apos;) , ISPICKVAL( Account__r.Country_Domain__c , &apos;combo-it&apos;)) &amp;&amp;  NOT($User.ByPassValidation__c)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Disable_Attachment</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>48</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Metric Rejected USA</fullName>
        <actions>
            <name>Metric_Rejection_Notification_USA</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>If a metric is rejected then send email notification to the partner</description>
        <formula>(CreatedDate &lt;&gt; LastModifiedDate) &amp;&amp; (Boolean_Achievement__c == false) &amp;&amp; (File_Submission_Count__c == 1) &amp;&amp; ($Profile.Name == &apos;System Administrator&apos; || $Profile.Name == &apos;SunPower Super User&apos; || $Profile.Name == &apos;SunPower User&apos;) &amp;&amp; OR(ISPICKVAL( Account__r.Country_Domain__c , &apos;rvar-us&apos;) , ISPICKVAL( Account__r.Country_Domain__c , &apos;cvar-us&apos;) , ISPICKVAL( Account__r.Country_Domain__c , &apos;combo-us&apos;)) &amp;&amp;  NOT($User.ByPassValidation__c)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Disable_Attachment</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>48</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
