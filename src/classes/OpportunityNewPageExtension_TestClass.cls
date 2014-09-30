@isTest(SeeAllData=true)

private class OpportunityNewPageExtension_TestClass {

    private static UnitTestHelper helper = new UnitTestHelper();
    private static Account fakeProspectAccount;
    private static List<Opportunity> fakeOpportunityList;
    private static List<User> salesUserList;
    private static User busAdminUser;
    private static User dAXSalesUser;
    private static User dAXQuoteCreatorUser;
    private static Map<String, Id> recordTypesMap = new Map<String, Id>();
    private static Map<String, Id> profilesMap = new Map<String, Id>();
    private static ApexPages.StandardController sc;
    private static OpportunityNewPageExtension onpe;
    private static PageReference pageRef = Page.OpportunityNewPage;
    
    static {
        setRecordTypesMap();
		salesUserList = [SELECT Id, FirstName, LastName,  Profile.Name FROM User WHERE Profile.Name = 'BLX Sales User' AND IsActive = TRUE LIMIT 10];
		busAdminUser = [SELECT Id, FirstName, LastName,  Profile.Name FROM User WHERE Profile.Name = 'BLX Business Administrator' AND IsActive = TRUE LIMIT 1];
		Id profileId = [SELECT Id FROM Profile WHERE Name = 'BLX Sales User' LIMIT 1].Id;
		Id roleId = [SELECT Id FROM UserRole WHERE Name LIKE 'NL%' AND Name LIKE '%Sales%' LIMIT 1].Id;
		dAXSalesUser = helper.createUser('UserFN', 'UserLN', 'userDAX', 'userDAX@userDAX.com', 'userDAX@userDAX.com', '90024', '505', false, profileId, roleId);
		dAXQuoteCreatorUser = helper.createUser('UserQC', 'UserQc', 'userDAXQC', 'userDAXQC@userDAX.com', 'userDAXQC@userDAXQC.com', '90025', '505', true, profileId, roleId);
		insert(daxSalesUser);
		fakeProspectAccount = helper.createAccount('Fake Prospect Account', dAXSalesUser.Id, recordTypesMap.get('BLX Account Record Type - Prospect'), 'English', '123-456-789', 'TestStreet', 'TestCity', 'TestState', '11111', 'Holland');
    }

    private static void setRecordTypesMap() {
    	for (RecordType r : [SELECT Id, Name FROM RecordType WHERE SObjectType = 'Account' OR SObjectType = 'Opportunity']) {
    		recordTypesMap.put(r.Name, r.Id);
    	}    	
    }
    
    private static void setDAXPersonnelNumber() {
    	for (Integer i = 0; i < salesUserList.size(); i++) {
    		if (salesUserList[i].DAX_Personnel_Number__c == NULL) {
    			salesUserList[i].DAX_Personnel_Number__c = Decimal.valueOf('900' + (i+1));
    		}
    	}
    	update(salesUserList);
    }    
    
    private static void init(boolean accIdNeeded) {
    	insert(fakeProspectAccount);
    	if (accIdNeeded) {
			ApexPages.CurrentPage().getParameters().put('accId', fakeProspectAccount.Id);
    	}
	    sc = new ApexPages.standardController(new Opportunity());
	    onpe = new OpportunityNewPageExtension(sc);
    }
    
    // WORKING ON THE fieldsNotFilledIn OPTION
    static testMethod void Does_CreateError_When_AccountIsProspectWithInvalidData() {
    	System.runAs(dAXSalesUser) {
	    	// ARRANGE
	    	fakeProspectAccount.Language__c = NULL;
	    	init(true);
	    	String expectedResultTextMessage = 'You cannot create an Opportunity for this Account as the following fields are not filled in: ';
	    	String expectedResultFieldsNotFilledIn = '';
	    	
	    	// ACT
	    	PageReference actualResultURL = onpe.redirect();
	    	String actualResultTextMessage = onpe.textMessage1;
	    	List<String> actualResultFieldsNotFilledIn = onpe.fieldsNotFilledIn;
	    	for (String s : actualResultFieldsNotFilledIn) {
	    		System.debug('\r\n\r\n\r\nRESULT: ' + s);
	    	}
	    	
	    	// ASSERT
	    	System.assertEquals(expectedResultTextMessage, actualResultTextMessage);
//	    	System.assertEquals(expectedResultFieldsNotFilledIn, actualResultFieldsNotFilledIn);
 	  	}
    } 
    
    /*
    static testMethod void Does_CreateOpportunity_When_AccountIsProspectWithValidData() {
    	System.runAs(daxSalesUser) {
	    	// ARRANGE
	    	init(true);
	    	String expectedResultURL = 'System.PageReference[/006/e?accid=' + fakeProspectAccount.Id + '&ent=Opportunity&nooverride=1&RecordType=012300000001j0CAAQ&retURL=%2F00Q%2Fo]';
	    	String expectedResultTextMessage = NULL;
	    	
	    	// ACT
	    	PageReference actualResultURL = onpe.redirect();
	    	String actualResultTextMessage = onpe.textMessage1;
	    	
	    	// ASSERT
	    	System.assertEquals(expectedResultURL, String.valueOf(actualResultURL));
	    	System.assertEquals(expectedResultTextMessage, String.valueOf(actualResultTextMessage));
 	  	}
    }
    
    static testMethod void Does_CreateError_When_AccountIdIsNULL() {
    	System.runAs(salesUserList[0]) {
	    	// ARRANGE
	    	init(false);
	    	PageReference expectedResultPageReference = null;
	    	String expectedResultTextMessage1 = 'You are trying to create an Opportunity without an Account.';
	    	
	    	// ACT
	    	PageReference actualResultPageReference = onpe.redirect();
	    	String actualResultTextMessage1 = onpe.textMessage1;
	    	
	    	// ASSERT
	    	System.assertEquals(expectedResultPageReference, actualResultPageReference);
	    	System.assertEquals(expectedResultTextMessage1, actualResultTextMessage1);
 	  	}
    }
    
    static testMethod void Does_CreateError_When_AccountOwnerIsNotCurrentUser() {
    	System.runAs(busAdminUser) {    	
	    	// ARRANGE
	    	init(true);
	    	PageReference expectedResultPageReference = null;
	    	String expectedResultTextMessage1 = 'You must be the Owner of the Account in order to create an Opportunity.';
	    	
	    	// ACT
	    	PageReference actualResultPageReference = onpe.redirect();
	    	String actualResultTextMessage1 = onpe.textMessage1;
	    	
	    	// ASSERT
	    	System.assertEquals(expectedResultPageReference, actualResultPageReference);
	    	System.assertEquals(expectedResultTextMessage1, actualResultTextMessage1);
    	}
    }
    */
}