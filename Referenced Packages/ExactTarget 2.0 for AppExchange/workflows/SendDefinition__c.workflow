<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ExactTargetForAppExchange_SendFailureNotification</fullName>
        <description>ExactTarget for AppExchange - Send Failure Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ExactTargetForAppExchangeTemplates/ExactTarget_FailedSend</template>
    </alerts>
    <alerts>
        <fullName>ExactTargetForAppExchange_SendSuccessNotification</fullName>
        <description>ExactTarget for AppExchange - Send Success Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ExactTargetForAppExchangeTemplates/ExactTarget_SuccessfulSend</template>
    </alerts>
    <rules>
        <fullName>ExactTarget for AppExchange - Send Failure Notification</fullName>
        <actions>
            <name>ExactTargetForAppExchange_SendFailureNotification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SendDefinition__c.SendStatus__c</field>
            <operation>equals</operation>
            <value>Failed</value>
        </criteriaItems>
        <description>Notifies the creator of a Send definition if the Send fails</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ExactTarget for AppExchange - Send Success Notification</fullName>
        <actions>
            <name>ExactTargetForAppExchange_SendSuccessNotification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SendDefinition__c.SendStatus__c</field>
            <operation>equals</operation>
            <value>Complete</value>
        </criteriaItems>
        <description>Notifies the creator of a Send definition if the Send succeeds</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
