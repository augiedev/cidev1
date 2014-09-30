trigger OpportunityTriggers on Opportunity (before insert) {

	// Before Execution Triggers
	if (Trigger.isBefore) {
		if (Trigger.isInsert) {
			OpportunityValidator.validateAccountOnOpportunity(Trigger.new);
		}
     }       
}