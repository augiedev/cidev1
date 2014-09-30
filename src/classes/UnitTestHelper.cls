@isTest
public with sharing class UnitTestHelper {

	public Campaign createCampaign(String campaignName) {
		return new Campaign(Name = campaignName, isActive = true);
	}
	
	public Contact createContact(String firstName, String lastName, String email) {
		return (new Contact(firstName = firstName, lastName = lastName, email = email));
	}
	
	public CampaignMemberStatus createCampaignMemberStatus(String campaignId, String statusLabel, boolean isDefaultStatus, boolean isRespondedStatus, Integer sortOrder) {
		return (new CampaignMemberStatus(CampaignId = campaignId, Label = statusLabel, IsDefault = isDefaultStatus, HasResponded = isRespondedStatus, SortOrder = sortOrder));
	}
	
	public CampaignMember createCampaignMember(String campaignId, String contactId, String status) {
		return (new CampaignMember(CampaignId = campaignId, ContactId = contactId, Status = status));
	}
	
	public Account createAccount(String name, String ownerId, Id recordTypeId, String language, String phone, String street, String city, String state, String postalCode, String country) {
		return (new Account(Name = name, OwnerId = ownerId, RecordTypeId = recordTypeId, Language__c = language, Phone = phone, BillingStreet = street, BillingCity = city, BillingState = state, BillingPostalCode = postalCode, BillingCountry = country, ShippingStreet = street, ShippingCity = city, ShippingState = state, ShippingPostalCode = postalCode, ShippingCountry = country));	
	}
	
	public User createUser(String firstName, String lastName, String alias, String email, String userName, String daxPersonnelNumber, String daxCompanyNumber, boolean daxQuoteCreator, Id profileId, Id roleId) {
		return (new User(FirstName = firstName, LastName = lastName, Alias = alias, Email = email, UserName = userName, DAX_Personnel_Number__c = Decimal.valueOf(daxPersonnelNumber), Dax_Company_Number__c = daxCompanyNumber, DAX_Quote_Creator__c = daxQuoteCreator, ProfileId = profileId, UserRoleId = roleId, TimeZoneSidKey = 'GMT', EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = 'en_GB', LocaleSidKey = 'nl'));
	}
}