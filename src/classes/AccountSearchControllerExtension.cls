public class AccountSearchControllerExtension
{    
    //If a lead is being converted we grab the leadId
    Id leadId = ApexPages.currentPage().getParameters().get(Properties.leadId);
    
    final static String emptyString = Properties.emptyString;
    final static String NAProfilesPrefix = Properties.NAProfilesPrefix;
    final static String isLeadBeingConvertedString = Properties.isLeadBeingConverted;
    final static String trueString = Properties.trueString;
    final static String retURLString = Properties.retURL;
    final static String standardLeadConvertURL = Properties.standardLeadConvertURL;
    final static String utf8 = Properties.utf8;
    final static String cannotFindAccountConfirmation = Properties.cannotFindAccountConfirmation;  
    final static String cannotFindAccountConfirmationLeadConvert = Properties.cannotFindAccountConfirmationLeadConvert;     
    
    //These are the field values the user will be searching on
    public String name{get; set;}
    public String street{get; set;}
    public String city{get; set;}
    public String state{get; set;}
    public String county{get; set;}
    public String zipCode{get; set;}
    public String country{get; set;}
    
    //This boolean determines if a lead is being converted
    public Boolean isLeadBeingConverted
    {
        get
        {
            if(isLeadBeingConverted == null)
            {
                isLeadBeingConverted = false;
                String value = ApexPages.currentPage().getParameters().get(isLeadBeingConvertedString);
                
                if(value != null && value.equals(trueString))
                    isLeadBeingConverted = true;
            }
            return isLeadBeingConverted; 
        }
        set;
    }
    
    //This list contains the search results
    public List<AccountWrapper> results
    {
        get
        {
            if(results == null) results = new List<AccountWrapper>();
            return results;
        }
        set;
    }
    
    //This boolean determines if the search has already been performed.
    public Boolean hasSearched
    {
        get
        {
            if(hasSearched == null) hasSearched = false;
            return hasSearched;
        }
        set;
    }
    
    //This boolean determines if any results have been found or not
    public Boolean resultsFound
    {
        get
        {
            if(results.size() == 0)
                return false;
            else
                return true;
        }
    }
    
    //This string determines the retURL
    public String retURL
    {
        get
        {
            if(retURL == null)
            {
                retURL = ApexPages.currentPage().getParameters().get(retURLString);
                
                if(retURL != null && retURL != '')
                    retURL = EncodingUtil.urlEncode(retURL, utf8);
            }
            return retURL; 
        }
        set;
    }
    
    //This the text that will be displayed to the user if they try to create a new Account or convert a lead
    public String confirmText
    {
        get
        {
            if(isLeadBeingConverted) 
                return 'return confirm("' + cannotFindAccountConfirmationLeadConvert + '")';
            
            return 'return confirm("' + cannotFindAccountConfirmation + '")';
        }
    }
        
    public AccountSearchControllerExtension(ApexPages.StandardController stdController)
    {}
    
    //This method gets called every time the page loads and check if the user should see this page or not.
    public PageReference checkIfUserNeedsToBeRedirected()
    {
        //First we grab the user's profile name
        String userProfileName = [SELECT Profile.Name FROM User WHERE Id =: UserInfo.getUserId()].Profile.Name;
        
        //If the user's profile does not start with NA - they do not need to see this page and we redirect them to create a new Account
        if(!userProfileName.startsWith(NAProfilesPrefix))
        {
            if(isLeadBeingConverted && leadId != null)
                return new PageReference(standardLeadConvertURL + '&id=' + leadId + '&' + retURLString + '=' + retURL);  

            return newAccount();   
        }
                    
        return null;
    }

    //Actions
    public PageReference searchAccounts()
    {
        //We trim out the results in case a user has added any spaces
        name = name.trim();
        street = street.trim();
        city = city.trim();
        state = state.trim();
        county = county.trim();
        zipCode = zipCode.trim();
        country = country.trim();
        
        //We clear the previous search results and set hasSearched to true
        results.clear();
        hasSearched = true;               
        
        //Now we start building our SOQL query
        String soqlQuery = 'SELECT Id, Name, AccountNumber, OwnerId, Owner.Name, BillingStreet, BillingCity, ' + 
                           'Billing_County__c, BillingState, BillingPostalCode, BillingCountry, ShippingStreet, ' +
                           'ShippingCity, Shipping_County__c, ShippingState, ShippingPostalCode, ShippingCountry ' +
                           'FROM Account WHERE Id != NULL ';
        
        //Depending on which fields are not empty we build our SOQL query
        if(name != '')
            soqlQuery += ' AND Name LIKE \'%' + String.escapeSingleQuotes(name) + '%\'';

        if(street != '')
            soqlQuery += ' AND ShippingStreet LIKE \'%' + String.escapeSingleQuotes(street) + '%\'';

        if(city != '')
            soqlQuery += ' AND ShippingCity LIKE \'%' + String.escapeSingleQuotes(city) + '%\'';

        if(state != '')
            soqlQuery += ' AND ShippingState LIKE \'%' + String.escapeSingleQuotes(state) + '%\'';

        if(county != '')
            soqlQuery += ' AND Shipping_County__c LIKE \'%' + String.escapeSingleQuotes(county) + '%\'';

        if(zipCode != '')
            soqlQuery += ' AND ShippingPostalCode LIKE \'%' + String.escapeSingleQuotes(zipCode) + '%\'';

        if(country != '')
            soqlQuery += ' AND ShippingCountry LIKE \'%' + String.escapeSingleQuotes(country) + '%\'';
            
        //Due to Apex limitations we make sure we get back only 1000 results and order the results ascending by Name
        soqlQuery += ' ORDER BY Name ASC LIMIT 1000';
        
        //Now we perform the query and put any results in our results list
        for(Account acc : Database.query(soqlQuery))
        {
            AccountWrapper accWrapper = new AccountWrapper();
            accWrapper.account = acc;
            results.add(accWrapper);
        }    
        
        //If we have 1000 results we display a message to the user telling them that only the first 1000 results are shown    
        if(results.size() == 1000)
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'There are more than 1000 accounts meeting your criteria. Only the first 1000 results are shown below.'));

        //If there are no results we display a message.
        else if(results.isEmpty())
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'No Accounts found. Please modify the search criteria and click Search again or click Create New.'));
        
        return null;
    }
    
    //Based on if a lead is being converted or a new account is being created we redirect the user to the aproppriate page
    public PageReference newAccount()
    {
        if(isLeadBeingConverted && leadId != null)
            return new PageReference(standardLeadConvertURL + '&id=' + leadId + '&' + retURLString + '=' + retURL);  

        String recordType = ApexPages.currentPage().getParameters().get('RecordType');
        String retURL = ApexPages.currentPage().getParameters().get('retURL');
        
        String url = '/001/e?nooverride=1';
        url += recordType == null? '' : '&RecordType=' + EncodingUtil.urlEncode(recordType, utf8);
        url += retURL == null? '' : '&retURL=' + EncodingUtil.urlEncode(retURL, utf8);
        
        if(name != null && name != '')
            url += name == '' ? '' : '&acc2=' + EncodingUtil.urlEncode(name, utf8);
        
        PageReference newAccountPage = new PageReference(url);
        newAccountPage.setRedirect(true);
        return newAccountPage;
    }
}