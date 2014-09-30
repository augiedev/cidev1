public with sharing class RecordTypeBusinessRules {
	
	public static Id getUserDefaultOpportunityRecordType() {
		Id defaultRecordTypeId = getUserDefaultRecordType(Schema.SObjectType.Opportunity.getRecordTypeInfos());
	    return defaultRecordTypeId;
    }
    
	public static Id getUserDefaultLeadRecordType() {
		Id defaultRecordTypeId = getUserDefaultRecordType(Schema.SObjectType.Lead.getRecordTypeInfos());
	    return defaultRecordTypeId;
    }    
    
    private static Id getUserDefaultRecordType(List<Schema.RecordTypeInfo> recordTypeList) {
		Id defaultRecordTypeId;
		for (Schema.RecordTypeInfo rtInfo : recordTypeList) {
			if (rtInfo.isDefaultRecordTypeMapping()) {               
				defaultRecordTypeId = rtInfo.getRecordTypeId();
				break;
			}
		}
	    return defaultRecordTypeId;    	
    }

}