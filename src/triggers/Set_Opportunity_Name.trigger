trigger Set_Opportunity_Name on Opportunity (before insert) {

    Set<Id> accIds = new Set<Id>();
    List<Opportunity> opps = new List<Opportunity>();
    Map<Id, String> accNames = new Map<Id, String>();
    RecordType oppType = [SELECT Id FROM RecordType WHERE Name = 'NA Opportunity Record Type' LIMIT 1];

    for (Opportunity o : Trigger.new) {
        if (o.RecordTypeId != oppType.Id) {
            accIds.add(o.AccountId);
            opps.add(o);
        }
    }

    if (!opps.isEmpty()) {
        for (Account a : [SELECT Id, Name FROM Account WHERE Id IN :accIds]) {  
            accNames.put(a.Id, a.Name);
        }
    
        for (Opportunity o : opps) {
            String oppName = o.Name;
            if (!oppName.contains(accNames.get(o.AccountId))) {
                oppName = accNames.get(o.AccountId) + ' - ' + o.Name;
                o.Name = oppName;
            }
        }
    }
}