trigger No_Duplicate_Debtor_Number on Account (before insert, before update) {
    
    List<String> debNumbers = new List<String>();
    List<Account> accs = new List<Account>();
    Set<Id> accIds = new Set<Id>();
    Map<Id, RecordType> recordTypesToNotProcess = new Map<Id, RecordType>([SELECT Id FROM RecordType WHERE Name LIKE 'NA%' OR Name LIKE 'BLX%']);
    Map<String, Double> debNumCmpCode = new Map<String, Double>();
    
    for (Account a : Trigger.new) {
        if (a.Exact_Debtor_Number__c != null && !recordTypesToNotProcess.containsKey(a.RecordTypeId)) {
            accIds.add(a.Id);
            accs.add(a);
            debNumbers.add(a.Exact_Debtor_Number__c);
        }
    }
    
    if (!accs.isEmpty()) {
        for(Account a : [SELECT Id, Exact_Debtor_Number__c, Exact_Company_Number__c FROM Account WHERE Exact_Debtor_Number__c IN :debNumbers AND Id NOT IN :accIds]) {
            debNumCmpCode.put(a.Exact_Debtor_Number__c, a.Exact_Company_Number__c);
        }
        
        if (!debNumCmpCode.isEmpty()) {
            for (Account a : accs) {
                if (debNumCmpCode.containsKey(a.Exact_Debtor_Number__c) && debNumCmpCode.get(a.Exact_Debtor_Number__c) == a.Exact_Company_Number__c) {
                    a.addError('An Account already exists with the same Exact Debtor Number. You cannot have another Account with the same Exact Debtor Number');
                }
            }
        }
    }
}