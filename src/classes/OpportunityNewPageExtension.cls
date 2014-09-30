public with sharing class OpportunityNewPageExtension {
    private transient Id recordTypeId;
    private transient String recordTypeNameToValidate;
    private transient Map<String, DAX_Record_Types_To_Process__c> recordTypesToProcess;
    private transient List<String> fieldsToValidate;
    public transient List<String> fieldsNotFilledIn { get; set; }
    public boolean showPopup { get; set; }
    public String textMessage1 { get; set; }
    public transient String textMessage2 { get; set; }
    private transient Account accountRecord;

    public OpportunityNewPageExtension(ApexPages.StandardController ctr) {

        if (ApexPages.currentPage().getParameters().get('RecordType') != null && ApexPages.currentPage().getParameters().get('RecordType') != '') {
            this.recordTypeId = ApexPages.currentPage().getParameters().get('RecordType');
        }
        else {
            this.recordTypeId = RecordTypeBusinessRules.getUserDefaultOpportunityRecordType();
        }

        if (ApexPages.currentPage().getParameters().get('accId') != null && ApexPages.currentPage().getParameters().get('accId') != '') {
            Id accountId = ApexPages.currentPage().getParameters().get('accId');
			fieldsToValidate = new List<String>(DAX_Account_Fields_to_Validate__c.getAll().keySet());
			String queryString = ObjectFieldValidator.generateQueryString(fieldsToValidate);
            this.accountRecord = Database.query('SELECT Id, OwnerId, Owner.DAX_Personnel_Number__c, RecordType.Name, ' + queryString.left(queryString.length()-2) + ' FROM Account WHERE Id = :accountId LIMIT 1');
        }
        
       	recordTypesToProcess = DAX_Record_Types_To_Process__c.getAll(); 
        recordTypeNameToValidate = [SELECT Name FROM RecordType WHERE Id = :this.recordTypeId LIMIT 1].Name;
        showPopup = false;
    }
    
    public PageReference redirect() {
        
        // Validate only the Opportunities where the Record Types are listed in the Custom Setting 'Valid AX Record Types':
        if ((recordTypesToProcess.containsKey(recordTypeNameToValidate))) {
            if (this.accountRecord == NULL)  {
                showMessagePopup('You are trying to create an Opportunity without an Account.', 'Go first to the Account record and from there, click on the New Opportunity button.');          
                return null;
            }
            User currentUser = [SELECT Id, DAX_Personnel_Number__c, DAX_Quote_Creator__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
            if (UserInfo.getUserId() != this.accountRecord.OwnerId && currentUser.DAX_Quote_Creator__c == false) {
                showMessagePopup('You must be the Owner of the Account in order to create an Opportunity.', '');
                return null;                
            }
            if (currentUser.DAX_Personnel_Number__c == NULL) {
                showMessagePopup('You cannot create an Opportunity for this Account as you are not setup as a user in Dynamics AX.', '');
                return null;
            }
            if (this.accountRecord.Owner.DAX_Personnel_Number__c == NULL) {
                showMessagePopup('You cannot create an Opportunity for this Account as the Owner of the Account is not setup as a user in Dynamics AX.', '');
                return null;
            }
            // Return the name of any fields that are not populated where the Record Type of the Account is Prospect
            // Does not need to be done if the Account is of the type Customer
            if (!this.accountRecord.RecordType.Name.contains('Customer')) {
                fieldsNotFilledIn = ObjectFieldValidator.getObjectEmptyFieldNames(this.accountRecord, fieldsToValidate);
                if (!fieldsNotFilledIn.isEmpty()) {
                    showMessagePopup('You cannot create an Opportunity for this Account as the following fields are not filled in: ', 'Fill in these fields before trying again to create an Opportunity for this Account.');
                    return null;
                }
            }
        }
        PageReference page = getOpportunityCreatePage();
        return page;
    }
    
    public PageReference okButtonLink() {
        PageReference page;
        if (ApexPages.currentPage().getParameters().get('accId') != null && ApexPages.currentPage().getParameters().get('accId') != '') {
            page = new PageReference('/' + ApexPages.currentPage().getParameters().get('accId'));           
        }
        else {
            page = new PageReference('/001/o');
        }
        return page;        
    }
    
    private PageReference getOpportunityCreatePage() {
        PageReference page = new PageReference('/006/e?retURL=%2F00Q%2Fo&RecordType=' + this.recordTypeId + '&ent=Opportunity');
        if (this.accountRecord != NULL) {
            page.getParameters().put('accid', this.accountRecord.Id);
        }
        page.getParameters().put('nooverride','1');
        return page;    
    }
    
	private void showMessagePopup(String message1, String message2) {
		showPopup = true;
		textMessage1 = message1;
		textMessage2 = message2;
	}
}