trigger LeadTriggers on Lead (before insert, before update) {
	
     // Before Execution Triggers
     if (Trigger.isBefore) {
        if (Trigger.isInsert) {
        	CountryValidator.validateCountry('Lead', Trigger.new, null, new String[] {'Country'});
        }
        else if (Trigger.isUpdate) {
        	CountryValidator.validateCountry('Lead', Trigger.new, Trigger.oldMap, new String[] {'Country'});
        }
     }
}