<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Opportunity_Name</fullName>
        <field>Name</field>
        <formula>LEFT(TRIM(Account.Name), 255 - (LEN(TRIM(Name)) + 3)) + &apos; - &apos; + TRIM(Name)</formula>
        <name>Set Opportunity Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set Opportunity Name</fullName>
        <actions>
            <name>Set_Opportunity_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>UK Opportunity Record Type,IT Opportunity Record Type,BLX Opportunity Record Type,ES Opportunity Record Type,DE Opportunity Record Type,JP Opportunity Record Type,HK Opportunity Record Type</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
