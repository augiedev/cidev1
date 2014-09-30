public with sharing class ObjectFieldValidator {

	public static List<String> getObjectEmptyFieldNames(Sobject objectRecord, List<String> fieldsToValidate) {
		List<String> emptyFieldNames = new List<String>();
		Map<String, Schema.SObjectField> fieldMap = getObjectFieldMap(objectRecord.getSObjectType().getDescribe().getLabel());

		for (String daxFieldToValidate : fieldsToValidate) {
			if (objectRecord.get(daxFieldToValidate) == NULL) {
				emptyFieldNames.add(fieldMap.get(daxFieldToValidate).getDescribe().getLabel());
			}
		}
		return emptyFieldNames;
	}
	
	public static void validateOpportunityAccountFields(List<Opportunity> recordsToProcess, Map<Id, Account> accountMap, List<String> daxFieldToValidateList) {
		Map<String, Schema.SObjectField> fieldMap = getObjectFieldMap('Account');
		
		for (Sobject currentRecord : recordsToProcess) {
			Account currentAccount = accountMap.get((Id) currentRecord.get('AccountId'));
			if (currentAccount.RecordType.Name.contains('Customer')) {
				continue;
			}
			String emptyFieldsString = '';
			for (String daxFieldToValidate : daxFieldToValidateList) {
				if (currentAccount.get(daxFieldToValidate) == NULL) {
					emptyFieldsString += fieldMap.get(daxFieldToValidate).getDescribe().getLabel() + ', ';
				}
			}
			if (emptyFieldsString.length() > 0) {
				currentRecord.addError('You cannot create an Opportunity for this Account as the following fields are not filled in: ' + emptyFieldsString.left(emptyFieldsString.length()-2));
			}
		}
	}	
	
	public static String getSingleFieldLabel(String objectName, String fieldName) {
		return getObjectFieldMap(objectName).get(fieldName).getDescribe().getLabel();
	}

	public static String generateQueryString(List<String> fieldsToQuery) {
		System.debug('\r\nIN QUERY STRING METHOD');
		String queryString = '';
		for (String daxFieldToValidate : fieldsToQuery) {
			queryString += daxFieldToValidate + ', ';
		}
		return queryString;
	}

	private static Map<String, Schema.SObjectField> getObjectFieldMap(String objectName) {
		return Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
	}
}