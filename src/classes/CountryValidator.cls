public with sharing class CountryValidator {
	
	public static void validateCountry(String objectName, List<SObject> records, Map<Id, SObject> oldRecords, String[] countryFields) {

		Map<String, DAX_Record_Types_To_Process__c> recordTypesToProcess = DAX_Record_Types_To_Process__c.getAll();
		Map<String, DAX_Country_Codes_Mapping__c> countryMap = DAX_Country_Codes_Mapping__c.getAll();
		Map<Id, RecordType> recordTypesToValidate = new Map<Id, RecordType>([SELECT Id, Name FROM RecordType WHERE (SObjectType = 'Account' OR SObjectType = 'Lead') AND (NOT Name LIKE '%Customer%')]);

		for (SObject currentRecord : records) {

			Id currentRecordId = (Id) currentRecord.get('Id');
			Id recordTypeId = (Id) currentRecord.get('RecordTypeId');

			// Not a Record Type that needs to be processsed. Applies to Record Types that are not interfaced with DAX and Account Customer Record Types
			if (!recordTypesToValidate.containsKey(recordTypeId)) {
				continue;
			}
			if (!recordTypesToProcess.containsKey(recordTypesToValidate.get(recordTypeId).Name)) {
				continue;
			}
			for (Integer i = 0; i < countryFields.size(); i++) {
				// Country has no value. No processing needed
				if (currentRecord.get(countryFields[i]) == NULL) {
					continue;
				}

				String countryValue = String.valueOf(currentRecord.get(countryFields[i])).toLowerCase();
				if (oldRecords != NULL) {
					try {
						String oldCountryValue = String.valueOf(oldRecords.get(currentRecordId).get(countryFields[i])).toLowerCase();
						// Country value has not changed. No processing needed
						if (countryValue == oldCountryValue) {
							continue;
						}
					} catch (NullPointerException n) {}
				}
				
				// Need to change the Country value. Change is done
				if (countryMap.containsKey(countryValue)) {
					currentRecord.put(countryFields[i], countryMap.get(countryValue).DAX_Country_Code__c);
				}
				// ERROR. The Country value is not listed and needs to be changed.
				else {
					currentRecord.addError('The Country you have entered is invalid. Please enter a valid Country value for the field ' + ObjectFieldValidator.getSingleFieldLabel(objectName, countryFields[i]));
				}
			}
		}
	}
}