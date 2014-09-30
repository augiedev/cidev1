trigger AccountTriggers on Account (before insert, before update, before delete) {
	
     // Before Execution Triggers
     if (Trigger.isBefore) {
        if (Trigger.isInsert) {
        	CountryValidator.validateCountry('Account', Trigger.new, null, new String[]{'BillingCountry', 'ShippingCountry'});
        }
        else if (Trigger.isUpdate) {
        	CountryValidator.validateCountry('Account', Trigger.new, Trigger.oldMap, new String[]{'BillingCountry', 'ShippingCountry'});
        }
        else if (Trigger.isDelete) {
        	AccountValidator.validateAccountDeletion(Trigger.old);
        }
     }
}