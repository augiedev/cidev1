public with sharing class OpportunityValidator {

	public static void validateAccountOnOpportunity(List<Opportunity> opportunityList) {

		Map<Id, Account> accountMap;
		Map<String, DAX_Record_Types_To_Process__c> recordTypesToProcess = DAX_Record_Types_To_Process__c.getAll();
		Map<Id, RecordType> opportunityRecordTypes = new Map<Id, RecordType>([SELECT Id, Name FROM RecordType WHERE SObjectType = 'Opportunity']);
		Set<Id> accountIdSet = new Set<Id>();
		List<Opportunity> opportunitiesToProcessList = new List<Opportunity>();
		List<String> fieldsToValidate;
		
		// Only get the Opportunities where the Record Type of the Opportunity is in the list of Record Types to be validated
		// Otherwise, the Opportunity can be created by the user
		// If the Opportunity does not contain an Account, throw an error back to the user
		for (Opportunity currentOpportunity : opportunityList) {
			Id recordTypeId = currentOpportunity.RecordTypeId;
			if (currentOpportunity.RecordTypeId == null) {
				recordTypeId = RecordTypeBusinessRules.getUserDefaultOpportunityRecordType();
			}
			if (recordTypesToProcess.containsKey(opportunityRecordTypes.get(recordTypeId).Name)) {
				if (currentOpportunity.AccountId == NULL) {
					currentOpportunity.addError('ERROR: You are not allowed to create an Opportunity without an Account.');
					continue;
				}	
				accountIdSet.add(currentOpportunity.AccountId);
				opportunitiesToProcessList.add(currentOpportunity);
			}
		}
		
		// Determine whether the Account of the Opportunity is of type Prospect or Customer.
		// If Customer, remove the Opportunity from the list of Opportunities that need to be processed.
		if (!opportunitiesToProcessList.isEmpty()) {
			fieldsToValidate = new List<String>(DAX_Account_Fields_to_Validate__c.getAll().keySet());
			String queryString = ObjectFieldValidator.generateQueryString(fieldsToValidate);
			accountMap = new Map<id,account>((List<account>)Database.query('SELECT Id, RecordTypeId, RecordType.Name, ' + queryString.left(queryString.length()-2) + ' FROM Account WHERE Id IN  :accountIdSet'));
			Integer j = 0;
			while (j < opportunitiesToProcessList.size()) {
				if (accountMap.get(opportunitiesToProcessList.get(j).AccountId).RecordType.Name.contains('Customer')) {
					opportunitiesToProcessList.remove(j);
				}
				else {
					j++;
				}
			}
		}
		
		// Process the Opportunities that need to be interfaced to Dynamics AX
		if (!opportunitiesToProcessList.isEmpty()) {		
			ObjectFieldValidator.validateOpportunityAccountFields(opportunitiesToProcessList, accountMap, fieldsToValidate);
		}
	}
}