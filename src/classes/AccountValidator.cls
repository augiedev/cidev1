public with sharing class AccountValidator {

	public static boolean isCustomerAccountType(Id accountId) {

		String recordTypeName = [SELECT RecordType.Name FROM Account WHERE Id = :accountId LIMIT 1].RecordType.Name;
		if (recordTypeName.contains('Customer')) {
			return true;
		}
		return false;
	}
	
	public static void validateAccountDeletion(List<Account> accountsList) {
		Map<Id, RecordType> recordTypes = new Map<Id, RecordType>([SELECT Id, Name FROM RecordType WHERE SObjectType = 'Account']);
		if (UserInfo.getProfileId() != '00e30000000nfdkAAA') {
			for (Account acc : accountsList) {
				if (recordTypes.get(acc.RecordTypeId).Name.startsWith('NA')) {
					continue;
				}
				if (recordTypes.get(acc.RecordTypeId).Name.endsWith('Customer')) {
					acc.addError('ERROR: You cannot delete a Customer record because it exists in Dynamics AX');
				}
				if (acc.DAX_Prospect_Number__c != NULL && acc.DAX_Prospect_Number__c != '') {
					acc.addError('ERROR: You cannot delete this Account because it exists in Dynamics AX as a Prospect');
				}
			}
		}
	}
}