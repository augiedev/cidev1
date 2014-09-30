/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Account_Address_Update_TestClass {

    static testMethod void myUnitTest() {

		List<RecordType> naAcc = [SELECT Id FROM RecordType WHERE Name LIKE 'NA%' AND SobjectType = 'Account' LIMIT 2];
		List<RecordType> emeaAcc = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND Name NOT IN ('NA%') AND IsActive = TRUE LIMIT 5];
		List<Account> naUpdateAccs = [SELECT Id, Name FROM Account WHERE RecordTypeId IN :naAcc LIMIT 50];
		List<Account> emeaUpdateAccs = [SELECT Id, Name FROM Account WHERE RecordTypeId IN :emeaAcc LIMIT 50];
		List<Account> naAccs = new List<Account>();
		List<Account> emeaAccs = new List<Account>();

		// Create NA Accounts
		Integer j = 0;
		for (Integer i = 0; i < 50; i++) {
			Account a = new Account();
			a.Name = 'Test Account ' + i;
			a.RecordTypeId = naAcc[0].Id;
			a.Billing_County__c = 'BCounty';
			a.Billing_Region__c = 'BRegion';
			a.BillingCity = 'BCity';
			a.BillingCountry = 'BCountry';
			a.BillingPostalCode = '1B';
			a.BillingState = 'BState';
			a.BillingStreet = 'BStreet';
			if (j == 0) {
				a.Originated_as_a_lead__c = true;
				j = 1;
			}
			else {
				j = 0;		
				a.Shipping_County__c = 'SCounty';
				a.Shipping_Region__c = 'SRegion';
				a.ShippingCity = 'SCity';
				a.ShippingCountry = 'SCountry';
				a.ShippingPostalCode = '1S';
				a.ShippingState = 'SState';
				a.ShippingStreet = 'SStreet';
			}

			naAccs.add(a);
		}
		insert(naAccs);
		
		for (Account a : [SELECT Id, Street__c, City__c, State_County__c, Zip_Postal_Code__c, Originated_as_a_Lead__c FROM Account WHERE Id IN :naAccs]) {
			if (a.Originated_as_a_lead__c == true) {
				System.assertEquals('BCity', a.City__c);
				System.assertEquals('BStreet', a.Street__c);
				System.assertEquals('BState, BCounty', a.State_County__c);
				System.assertEquals('1B', a.Zip_Postal_Code__c);							
			}
			else {
				System.assertEquals('SCity', a.City__c);
				System.assertEquals('SStreet', a.Street__c);
				System.assertEquals('SState, SCounty', a.State_County__c);
				System.assertEquals('1S', a.Zip_Postal_Code__c);					
			}
		}

		// Create EMEA Accounts
		for (Integer i = 0; i < 50; i++) {
			Account a = new Account();
			a.Name = 'Test Account ' + i;
			a.RecordTypeId = emeaAcc[0].Id;
			a.BillingCity = 'BCity';
			a.BillingCountry = 'BCountry';
			a.BillingPostalCode = '1B';
			a.BillingState = 'BState';
			a.BillingStreet = 'BStreet';	
			a.ShippingCity = 'SCity';
			a.ShippingCountry = 'SCountry';
			a.ShippingPostalCode = '1S';
			a.ShippingState = 'SState';
			a.ShippingStreet = 'SStreet';
			a.Exact_Debtor_Number__c = '987650';
			emeaAccs.add(a);
		}
		insert(emeaAccs);
		for (Account a : [SELECT Id, Street__c, City__c, State_County__c, Zip_Postal_Code__c FROM Account WHERE Id IN :emeaAccs]) {
			System.assertEquals('BCity', a.City__c);
			System.assertEquals('BStreet', a.Street__c);
			System.assertEquals('BState', a.State_County__c);
			System.assertEquals('1B', a.Zip_Postal_Code__c);
		}
    }
}