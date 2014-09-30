<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>SetMergeId</fullName>
        <field>MergeId__c</field>
        <formula>MergeId__c</formula>
        <name>Set Merge Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Sync Merge Id</fullName>
        <actions>
            <name>SetMergeId</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>NOT( ISBLANK( SendDefinition__c ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
