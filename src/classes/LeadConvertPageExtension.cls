public with sharing class LeadConvertPageExtension {

	private Lead leadRecord;
	private transient Map<String, DAX_Record_Types_To_Process__c> recordTypesToProcess;
	public transient List<String> fieldsNotFilledIn { get; set; }
	private transient List<String> fieldsToValidate;
	public boolean showPopup { get; set; }
	public boolean showConfirmation { get; set; }
	public String title { get; set; }
	public transient String doNotCreateOpportunity { get; set; }
	public transient String textMessage1 { get; set; }
	public transient String textMessage2 { get; set; }

	public LeadConvertPageExtension(ApexPages.StandardController ctr) {

		if (ApexPages.currentPage().getParameters().get('id') != null && ApexPages.currentPage().getParameters().get('id') != '') {
			Id leadId = ApexPages.currentPage().getParameters().get('id');
			fieldsToValidate = new List<String>(DAX_Lead_Fields_to_Validate__c.getAll().keySet());
			String queryString = ObjectFieldValidator.generateQueryString(fieldsToValidate);
			this.leadRecord = Database.query('SELECT Id, OwnerId, RecordTypeId, RecordType.Name, Segment__c, Industry__c, Dimension__c, Organization__c, ' + queryString.left(queryString.length()-2) + ' FROM LEAD WHERE Id = :leadId LIMIT 1');
		}

		showPopup = false;
		showConfirmation = false;
		title = 'ERROR - Cannot Convert Lead';
		doNotCreateOpportunity = '0';
	}
	
	public PageReference redirect() {

		// If Record Type is NA (North America), go to Convert Lead page. No Processing
		if (!this.leadRecord.RecordType.Name.startsWith('NA')) {

			// If the Segmentation is not filled in, Lead cannot be Converted. ERROR
			if (this.leadRecord.Segment__c == NULL || this.leadRecord.Industry__c == NULL || this.leadRecord.Dimension__c == NULL || this.leadRecord.Organization__c == NULL) {
				showMessagePopup('You cannot convert a Lead where the Segmentation is not filled in.', 'The fields for the Segmentation are: Segment, Industry, Dimension, Organization');
				return null;				
			}

			recordTypesToProcess = DAX_Record_Types_To_Process__c.getAll();

			if (recordTypesToProcess.containsKey(this.leadRecord.RecordType.Name)) {
				if (UserInfo.getUserId() != this.leadRecord.OwnerId) {
					showMessagePopup('You must be the Owner of the Lead in order to convert the Lead into an Account.', '');
					return null;				
				}
				Double leadOwnerPersonnelNumber = [SELECT DAX_Personnel_Number__c FROM User WHERE Id = :this.leadRecord.OwnerId LIMIT 1].DAX_Personnel_Number__c;
				if (leadOwnerPersonnelNumber == 0 || leadOwnerPersonnelNumber == NULL) {
					showMessagePopup('You must be setup as a user in Dynamics AX in order to convert the Lead into an Account.', '');
					return null;				
				}
				// Return the name of any fields that are not populated
				fieldsNotFilledIn = ObjectFieldValidator.getObjectEmptyFieldNames(this.leadRecord, fieldsToValidate);
				if (!fieldsNotFilledIn.isEmpty()) {
					showMessagePopup('You cannot convert this Lead as the following fields are not filled in: ', 'Fill in these fields before trying again to convert this Lead into an Account.');
					return null;
				}
			}
			// Call method to show confirm window
			showConfirmation = true;
			title = 'LEAD CONVERSION - Create Opportunity?';
			showMessagePopup('You are about to convert a Lead to an Account', 'Do you also want to create an Opportunity for this new Account?');
			return null;
		}

		PageReference page = getLeadConvertPage('/apex/AccountSearch?isLeadBeingConverted=true&nooverride=1', 'leadId');
		return page;
	}
	
	public PageReference goToLeadConvertPage() {
		PageReference page = getLeadConvertPage('/lead/leadconvert.jsp?nooverride=1', 'id');
		return page;
	}
	
	public PageReference getLeadRecordPage() {
		return new ApexPages.StandardController(this.leadRecord).view();
	}
	
	private PageReference getLeadConvertPage(String urlRedirect, String idParamName) {
		PageReference page = new PageReference(urlRedirect + this.leadRecord.Id);
		page.getParameters().put(idParamName, this.leadRecord.Id);
		page.getParameters().put('retURL', '/' + this.leadRecord.Id);
		page.getParameters().put('nooppti', doNotCreateOpportunity);
		page.setRedirect(true);
		return page;	
	}
	
	private void showMessagePopup(String message1, String message2) {
		showPopup = true;
		textMessage1 = message1;
		textMessage2 = message2;
	}
}