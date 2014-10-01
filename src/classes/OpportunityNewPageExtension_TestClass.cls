@isTest(SeeAllData=true)
private class OpportunityNewPageExtension_TestClass {

    private static UnitTestHelper helper = new UnitTestHelper();
    private static Account fakeProspectAccount;
    private static Account fakeCustomerAccount;
    private static List<Opportunity> fakeOpportunityList;
    private static User busAdminUser;
    private static User dAXSalesUser;
    private static User nonDAXSalesUser;
    private static User dAXQuoteCreatorUser;
    private static Map<String, Id> recordTypesMap = new Map<String, Id>();
    private static Map<String, Id> profilesMap = new Map<String, Id>();
    private static ApexPages.StandardController sc;
    private static OpportunityNewPageExtension onpe;
    private static PageReference pageRef = Page.OpportunityNewPage;
    
    static {
        setRecordTypesMap();
		busAdminUser = [SELECT Id, FirstName, LastName,  Profile.Name FROM User WHERE Profile.Name = 'BLX Business Administrator' AND IsActive = TRUE LIMIT 1];
		Id salesProfileId = [SELECT Id FROM Profile WHERE Name = 'BLX Sales User' LIMIT 1].Id;
		Id salesRoleId = [SELECT Id FROM UserRole WHERE Name = 'NL Core Sales Executive' LIMIT 1].Id;
		Id busAdminProfileId = [SELECT Id FROM Profile WHERE Name = 'BLX Business Administrator' LIMIT 1].Id;
		Id busAdminRoleId = [SELECT Id FROM UserRole WHERE Name = 'BLX Business Administrator' LIMIT 1].Id;
		dAXSalesUser = helper.createUser('UserFN', 'UserLN', 'userDAX', 'userDAX@userDAX.com', 'userDAX@userDAX.com', '90024', '505', false, salesProfileId, salesRoleId);
		nonDAXSalesUser = helper.createUser('UserFN', 'UserLN', 'user', 'userNonDAX@userNonDAX.com', 'userNonDAX@userNonDAX.com', NULL, '505', false, salesProfileId, salesRoleId);
		dAXQuoteCreatorUser = helper.createUser('UserQC', 'UserQC', 'userAXQC', 'userDAXQC@userDAX.com', 'userDAXQC@userDAXQC.com', '90025', '505', true, busAdminProfileId, busAdminRoleId);
		insert(daxSalesUser);
		insert(nonDAXSalesUser);
		insert(dAXQuoteCreatorUser);
		fakeProspectAccount = helper.createAccounts(1, dAXSalesUser.Id, recordTypesMap.get('BLX Account Record Type - Prospect')).get(0);
		fakeCustomerAccount = helper.createAccounts(1, dAXSalesUser.Id, recordTypesMap.get('BLX Account Record Type - Customer')).get(0);

		insert(fakeCustomerAccount);
    }

    private static void setRecordTypesMap() {
    	for (RecordType r : [SELECT Id, Name FROM RecordType WHERE SObjectType = 'Account' OR SObjectType = 'Opportunity']) {
    		recordTypesMap.put(r.Name, r.Id);
    	}    	
    }
    
    private static void init(boolean accIdNeeded) {
		insert(fakeProspectAccount);    	
    	if (accIdNeeded) {
			ApexPages.CurrentPage().getParameters().put('accId', fakeProspectAccount.Id);
    	}
	    sc = new ApexPages.standardController(new Opportunity());
	    onpe = new OpportunityNewPageExtension(sc);
    }
    
    static testMethod void Does_CreateError_When_AccountIsProspectWithInvalidData() {
    	System.runAs(dAXSalesUser) {
	    	// ARRANGE
	    	fakeProspectAccount.Language__c = NULL;
	    	init(true);
	    	String expectedResultTextMessage = 'You cannot create an Opportunity for this Account as the following fields are not filled in: ';
	    	String expectedResultFieldsNotFilledIn = 'Language';
	    	String expectedResultOKButton = 'System.PageReference[/' + fakeProspectAccount.Id + ']';
	    	
	    	// ACT
	    	PageReference actualResultURL = onpe.redirect();
	    	String actualResultTextMessage = onpe.textMessage1;
	    	List<String> actualResultFieldsNotFilledIn = onpe.fieldsNotFilledIn;
	    	PageReference actualResultOKButton = onpe.okButtonLink();
	    	
	    	// ASSERT
	    	System.assertEquals(expectedResultTextMessage, actualResultTextMessage);
	    	System.assertEquals(expectedResultFieldsNotFilledIn, actualResultFieldsNotFilledIn.get(0));
	    	System.assertEquals(expectedResultOKButton, String.valueOf(actualResultOKButton));
 	  	}
    } 
    
    static testMethod void Does_CreateOpportunity_When_AccountIsProspectWithValidData() {
    	System.runAs(daxSalesUser) {
	    	// ARRANGE
	    	init(true);
	    	String expectedResultURL = 'System.PageReference[/006/e?accid=' + fakeProspectAccount.Id + '&ent=Opportunity&nooverride=1&RecordType=012300000001j0CAAQ&retURL=%2F00Q%2Fo]';
	    	String expectedResultTextMessage = NULL;
	    	String expectedResultOKButton = 'System.PageReference[/' + fakeProspectAccount.Id + ']';
	    	
	    	// ACT
	    	PageReference actualResultURL = onpe.redirect();
	    	String actualResultTextMessage = onpe.textMessage1;
	    	PageReference actualResultOKButton = onpe.okButtonLink();
	    	
	    	// ASSERT
	    	System.assertEquals(expectedResultURL, String.valueOf(actualResultURL));
	    	System.assertEquals(expectedResultTextMessage, String.valueOf(actualResultTextMessage));
	    	System.assertEquals(expectedResultOKButton, String.valueOf(actualResultOKButton));
 	  	}
    }
    
    static testMethod void Does_CreateOpportunity_When_AccountIsCustomer() {
    	// ARRANGE
    	System.runAs(daxSalesUser) {
	    	
	    	init(true);
	    	String expectedResultURL = 'System.PageReference[/006/e?accid=' + fakeProspectAccount.Id + '&ent=Opportunity&nooverride=1&RecordType=012300000001j0CAAQ&retURL=%2F00Q%2Fo]';
	    	String expectedResultTextMessage = NULL;
	    	String expectedResultOKButton = 'System.PageReference[/' + fakeProspectAccount.Id + ']';
	    	
	    	// ACT
	    	PageReference actualResultURL = onpe.redirect();
	    	String actualResultTextMessage = onpe.textMessage1;
	    	PageReference actualResultOKButton = onpe.okButtonLink();
	    	
	    	// ASSERT
	    	System.assertEquals(expectedResultURL, String.valueOf(actualResultURL));
	    	System.assertEquals(expectedResultTextMessage, String.valueOf(actualResultTextMessage));
	    	System.assertEquals(expectedResultOKButton, String.valueOf(actualResultOKButton));
 	  	}
    }    
    
    static testMethod void Does_CreateError_When_AccountIdIsNULL() {
    	System.runAs(dAXSalesUser) {
	    	// ARRANGE
	    	init(false);
	    	PageReference expectedResultPageReference = null;
	    	String expectedResultTextMessage1 = 'You are trying to create an Opportunity without an Account.';
	    	String expectedResultOKButton = 'System.PageReference[/001/o]';
	    	
	    	// ACT
	    	PageReference actualResultPageReference = onpe.redirect();
	    	String actualResultTextMessage1 = onpe.textMessage1;
	    	PageReference actualResultOKButton = onpe.okButtonLink();
	    	
	    	// ASSERT
	    	System.assertEquals(expectedResultPageReference, actualResultPageReference);
	    	System.assertEquals(expectedResultTextMessage1, actualResultTextMessage1);
	    	System.assertEquals(expectedResultOKButton, String.valueOf(actualResultOKButton));
 	  	}
    }
    
    static testMethod void Does_CreateError_When_AccountOwnerIsNotCurrentUser() {
    	System.runAs(busAdminUser) {    	
	    	// ARRANGE
	    	init(true);
	    	PageReference expectedResultPageReference = null;
	    	String expectedResultTextMessage1 = 'You must be the Owner of the Account in order to create an Opportunity.';
	    	String expectedResultOKButton = 'System.PageReference[/' + fakeProspectAccount.Id + ']';
	    	
	    	// ACT
	    	PageReference actualResultPageReference = onpe.redirect();
	    	String actualResultTextMessage1 = onpe.textMessage1;
	    	PageReference actualResultOKButton = onpe.okButtonLink();
	    	
	    	// ASSERT
	    	System.assertEquals(expectedResultPageReference, actualResultPageReference);
	    	System.assertEquals(expectedResultTextMessage1, actualResultTextMessage1);
	    	System.assertEquals(expectedResultOKButton, String.valueOf(actualResultOKButton));
    	}
    }
    
    static testMethod void Does_CreateError_When_DAXPersonnelNumberIsNULL() {
    	// ARRANGE
    	fakeProspectAccount.OwnerId = nonDAXSalesUser.Id;
    	System.runAs(nonDAXSalesUser) {    	
	    	init(true);
	    	PageReference expectedResultPageReference = null;
	    	String expectedResultTextMessage1 = 'You cannot create an Opportunity for this Account as you are not setup as a user in Dynamics AX.';
	    	String expectedResultOKButton = 'System.PageReference[/' + fakeProspectAccount.Id + ']';
	    	
	    	// ACT
	    	PageReference actualResultPageReference = onpe.redirect();
	    	String actualResultTextMessage1 = onpe.textMessage1;
	    	PageReference actualResultOKButton = onpe.okButtonLink();
	    	
	    	// ASSERT
	    	System.assertEquals(expectedResultPageReference, actualResultPageReference);
	    	System.assertEquals(expectedResultTextMessage1, actualResultTextMessage1);
	    	System.assertEquals(expectedResultOKButton, String.valueOf(actualResultOKButton));
    	}
    }
    
    static testMethod void Does_CreateError_When_AccountOwnerDAXPersonnelNumberIsNULL() {
    	// ARRANGE
    	fakeProspectAccount.OwnerId = nonDAXSalesUser.Id;
    	System.runAs(dAXQuoteCreatorUser) {    	
	    	init(true);
	    	PageReference expectedResultPageReference = null;
	    	String expectedResultTextMessage1 = 'You cannot create an Opportunity for this Account as the Owner of the Account is not setup as a user in Dynamics AX.';
	    	String expectedResultOKButton = 'System.PageReference[/' + fakeProspectAccount.Id + ']';
	    	
	    	// ACT
	    	PageReference actualResultPageReference = onpe.redirect();
	    	String actualResultTextMessage1 = onpe.textMessage1;
	    	PageReference actualResultOKButton = onpe.okButtonLink();
	    	
	    	// ASSERT
	    	System.assertEquals(expectedResultPageReference, actualResultPageReference);
	    	System.assertEquals(expectedResultTextMessage1, actualResultTextMessage1);
	    	System.assertEquals(expectedResultOKButton, String.valueOf(actualResultOKButton));
    	}
    }
}