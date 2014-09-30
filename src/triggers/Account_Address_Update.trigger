trigger Account_Address_Update on Account (before insert, before update) {
    
    Map<Id, RecordType> naAccountRecordTypes = new Map<Id, RecordType>([SELECT Id FROM RecordType WHERE Name LIKE 'NA%']);
    
    for (Account acc : Trigger.new) {

    	// Copy the Billing Address to the Shipping Address ONLY if the Account is being created due to a Lead Conversion
    	if (Trigger.isInsert && acc.Originated_as_a_Lead__c == true) {
    		acc.ShippingStreet = acc.BillingStreet;
    		acc.ShippingCity = acc.BillingCity;
    		acc.ShippingState = acc.BillingState;
    		acc.Shipping_County__c = acc.Billing_County__c;
    		acc.ShippingPostalCode = acc.BillingPostalCode;
    		acc.ShippingCountry = acc.BillingCountry;
    	}
        	
        // If the Account is a NA Account
        if (naAccountRecordTypes.containsKey(acc.RecordTypeId)) {        	
            acc.Street__c = acc.ShippingStreet;
            acc.City__c = acc.ShippingCity;
            acc.State_County__c = acc.ShippingState;
            if (acc.Shipping_County__c != null) {
                acc.State_County__c = acc.ShippingState + ', ' + acc.Shipping_County__c;
            }
            acc.Zip_Postal_Code__c = acc.ShippingPostalCode;
        }
        // If the Account is an EMEA Account
        else {
            acc.Street__c = acc.BillingStreet;
            acc.City__c = acc.BillingCity;
            acc.State_County__c = acc.BillingState;
            acc.Zip_Postal_Code__c = acc.BillingPostalCode;    
            acc.Shipping_Region__c = acc.Billing_Region__c;     
        }
    }
}