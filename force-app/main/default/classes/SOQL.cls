/**
* The SOQL class serves as a primer into the Salesforce Object Query Language in Apex.
* It covers fundamental aspects such as SELECT statements, WHERE clauses, Relationship queries, and LIMIT keyword.
*
* This class introduces developers to the concept of retrieving data from Salesforce using SOQL. It provides
* a step-by-step guide on how to construct SOQL queries, filter results using WHERE clause, retrieve related
* records, and manage data volume using the LIMIT keyword.
* 
* Topics covered in this class include:
* - Understanding the structure of a SOQL query.
* - Crafting basic SELECT statements in SOQL.
* - Applying filters using the WHERE clause in SOQL.
* - Fetching related records using Relationship queries.
* - Controlling the amount of data retrieved using the LIMIT keyword.
* 
* Users of this class can expect to gain a solid understanding of SOQL in Apex and
* be prepared to handle data retrieval tasks in Salesforce development.
* 
* @author Ishan Sharma
*/

public with sharing class SOQL {
    
    /**
     * Question 1
     * Update/Uncomment the template code to create a method
     * Returns all leads from Salesforce Org
     * @return List of all leads with Id, LastName, Company, Phone, Email
     * Update the corresponding test class and testGetAllLeads method to cover this method
     */
    public static List<Lead> getLeads() {
        List<Lead> listOfAllLeads = [SELECT Id, LastName, Company, Phone, Email FROM Lead];
        return listOfAllLeads;
    }

    /**
     * Question 2
     * Update/Uncomment the template code to create a method
     * Returns all contacts with first name of John.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByFirstName method to cover this method
     */
    public static List<Contact> getContactByFirstName() {
        List<Contact> listOfContactWithFirstNameJohn = [SELECT Id, Name FROM Contact WHERE FirstName = 'John'];
        return listOfContactWithFirstNameJohn;
    }

    /**
     * Question 3
     * Update/Uncomment the template code to create a method
     * Returns the Contact Id for all contacts with last name of Smith or Jones
     * @return A list of Contact Ids.
     * Update the corresponding test class and testGetContactIdsByLastName method to cover this method
     */
    public static List<Id> getContactIds() {
        List<Contact> listOfContactIds = [SELECT Id FROM Contact WHERE LastName IN ('Smith' , 'Jones')];
        Set<Id> setOfContactIds = (new Map<Id,Contact>(listOfContactIds)).keySet();
        List<Id> idsFromSetToList = new List<Id>(setOfContactIds);
        return idsFromSetToList;
    }

    /**
     * Question 4
     * Update/Uncomment the template code to create a method
     * Returns List of closed won opportunities for a specific Account.
     * Example: yourMethodName('001XXXXXXXXXXXX') should return the list of closed won opportunities for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Opportunities with important opportunities fields
     * Update the corresponding test class and testGetClosedWonOpportunityCountByAccount method to cover this method
     */
    public static List<Opportunity> getClosedWonOpportunityCountByAccount(Id accountId) {
        List<Opportunity> oppsForAccount = [SELECT Id, Name, StageName, CloseDate, Amount, Account.Id FROM Opportunity WHERE StageName = 'Closed Won' AND Account.Id = :accountId];
        return oppsForAccount;
    }

    /**
     * Question 5
     * Update/Uncomment the template code to create a method
     * Returns the total count of Account records.
     * @return The Integer count of Account records.
     * Update the corresponding test class and testGetAccountCount method to cover this method
     */
    public static Integer getAccountCount() {
        Integer accountCount = [SELECT COUNT() FROM Account];
        return accountCount;
    }

    /**
     * Question 6
     * Update/Uncomment the template code to create a method
     * Return Key Value pair of Task Id and Task records for any tasks due date within the next 7 days.
     * @return A map of Task Ids to Task records.
     * Update the corresponding test class and testGetTasksDueNextWeek method to cover this method
     */
    public static Map<Id,Task> getTaskDue() {
        Map<Id,Task> mapOfTaskIdsAndRecords = new Map<Id,Task>([SELECT Id, Subject, ActivityDate FROM Task WHERE ActivityDate = NEXT_N_DAYS:7]);
        return mapOfTaskIdsAndRecords;
    }

    /**
     * Question 7
     * Update/Uncomment the template code to create a method
     * Retrieves all Contacts that have a example.com domain in their Email.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByEmailDomain method to cover this method
     */
    public static List<Contact> getContactsWithEmailDomain() {
        List<Contact> listofContactsWithEmailDomain = [SELECT Id, Name, Email FROM Contact WHERE Email LIKE '%example.com'];
        return listofContactsWithEmailDomain;
    }

    /**
     * Question 8
     * Retrieves all Opportunities that have a specific keyword in their Name.
     * Example: getOpportunitiesByNameKeyword('keyword') should return all Opportunities that have 'keyword' in their Name.
     * @param keyword The keyword to search for in the Opportunity Name.
     * @return A list of Opportunity records.
     */
    public static List<Opportunity> getOpportunitiesByNameKeyword(String keyword) {
        if(keyword != null) {
            String input = '%' + keyword + '%';
        List<Opportunity> oppsWithKeyword = [SELECT Id, Name FROM Opportunity WHERE Name LIKE :input];
        return oppsWithKeyword;
        }
        return new List<Opportunity>();
    }

    /**
     * Question 9
     * Retrieves all Cases that Case Origin is not Web or Email or Blank
     * @return A list of Case records.
     */
    public static List<Case> getFilterCaseOrigins() {
        List<Case> casesOrigin = [SELECT Id, Origin FROM Case WHERE Origin NOT IN ('Web', 'Email', '')];
        return casesOrigin;
    }

    /**
     * Question 10
     * Update/Uncomment the template code to create a method
     * Retrieves all Leads that have a specific Lead Source or contain a specific keyword in their Title.
     * Example: yourMethodName('Web', 'Engineer') should return all Leads that have 'Web' in their Lead Source or 'Engineer' in their Title.
     * @param leadSource The Lead Source to search for.
     * @param keyword The keyword to search for in the Lead Title.
     * @return A list of Lead records.
     * Update the corresponding test class and testGetLeadsBySourceOrTitle method to cover this method
     */
    public static List<Lead> getLeadsBySourceOrTitle(String leadSource, String keyword) {
        String input = '%' + keyword + '%';
        List<Lead> leadsBySourceOrTitle = [SELECT Id, LeadSource, Title, LastName, Company, Phone, Email FROM Lead WHERE LeadSource = :leadSource OR Title LIKE :input];
        return leadsBySourceOrTitle;
    }  

    /**
     * Question 11
     * Returns the names of all Contacts associated with an Account.
     * Example: getContactNamesByAccount('001XXXXXXXXXXXX') should return the list of Contact LastNames for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Contact LastName.
     */
    public static List<String> getContactNamesByAccount(Id accountId) {
        List<String> contactLastNamesByAccount = new List<String>();
        List<Contact> contactsOfAccount = [SELECT Id, LastName, Account.Id FROM Contact WHERE Account.Id = :accountId];
        for(Contact contactLastName: contactsOfAccount) {
            contactLastNamesByAccount.add(contactLastName.LastName);
        }
        return contactLastNamesByAccount;
    }

    /**
     * Question 12
     * Returns the total revenue for all Opportunities in a specific Stage or if the amount is greater than 10000.
     * Example: getTotalRevenueByStage('Closed Won') should return the total revenue for all Opportunities in the 'Closed Won' Stage.
     * @param stage The Stage value to filter Opportunities.
     * @return The total revenue.
     */
    public static Decimal getTotalRevenueByStage(String stage) {
        Decimal totalRevenue;
        AggregateResult[] oppsTotalRevenue = [SELECT SUM(Amount) Sum FROM Opportunity WHERE (StageName = :stage OR Amount > 10000)];
        for(AggregateResult oppsAmount: oppsTotalRevenue) {
            totalRevenue = (Decimal)oppsAmount.get('Sum');
        }
        return totalRevenue;
    }

    /**
     * Question 13
     * Retrieves the first 10 Accounts ordered by Name.
     * @return A list of the first 10 Accounts ordered by Name.
     */
    public static List<Account> getFirstTenAccounts() {
        List<Account> firstTenAccounts = [SELECT Id, Name FROM Account ORDER BY Name LIMIT 10];
        return firstTenAccounts;
    }
    
    /**
     * Question 14
     * Retrieves the Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     * @return A list of Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     */
    public static List<Opportunity> getHighValueOpportunities() {
        List<Opportunity> highValueOpps = [SELECT Id, Name, CloseDate, Amount FROM Opportunity WHERE Amount > 100000 ORDER BY CloseDate LIMIT 5];
        return highValueOpps;
    }
    
    /**
     * Question 15
     * Retrieves the Contacts with the most recent Birthdate, ordered by Birthdate, and limited to 3 records.
     * @return A list of Contacts
     */
    public static List<Contact> getBirthdateContacts() {
        List<Contact> contactsWithRecentBirthdate = [SELECT Birthdate FROM Contact WHERE Birthdate = LAST_N_DAYS:7 ORDER BY Birthdate DESC LIMIT 3];
        return contactsWithRecentBirthdate;
    }
    
    /**
     * Question 16
     * Retrieves the Cases in the Open Status, ordered by CreatedDate, and limited to 10 records with an offset of 5.
     * @return A list of Cases
     */
    public static List<Case> getCasesWithStatus() {
        List<Case> casesWithOpenStatus = [SELECT Id, Status, CreatedDate FROM Case WHERE Status NOT IN ('Closed') ORDER BY CreatedDate LIMIT 10 OFFSET 5];
        return casesWithOpenStatus;
    }

    /**
     * Question 17
     * Returns Set of Case Ids for a specific Account.
     * Example: getCaseIdsByAccount('001XXXXXXXXXXXX') should return the set of Case Ids for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A set of Case Ids.
     */
    public static Set<Id> getCaseIdsByAccount(Id accountId) {
        Set<Id> caseIds = new Set<Id>();
        List<Case> caseForAccountId = [SELECT Id, Account.Id FROM CASE WHERE Account.Id = :accountId];
        for(Case caseId: caseForAccountId) {
            caseIds.add(caseId.Id);
        }
        return caseIds;
    }

    /**
     * Question 18
     * Return Map of Account Ids to Account Names Not in a specific Country.
     * Example: getAccountIdsToNamesNotInCountry('United States') should return the map of Account Ids to Account Names for Accounts that are not in the United States.
     * @param country The country to filter Accounts.
     * @return A map of Account Ids to Account Names.
     */
    public static Map<Id, String> getAccountIdsToNamesNotInCountry(String country) {
        Map<Id, String> accountIdsToNames = new Map<Id, String>();
        List<Account> accountsNotInCountry = [SELECT Id, Name, BillingCountry FROM Account WHERE BillingCountry != :country];
        for(Account accountName: accountsNotInCountry) {
            accountIdsToNames.put(accountName.Id, accountName.Name);
        }
        return accountIdsToNames;
    }

    /**
     * Question 19
     * Retrieves the Account Name for a given Contact.
     * Example: getAccountNameForContact('003XXXXXXXXXXXX') should return the Account Name for the Contact with the Id
     * @param contactId The Id of the Contact.
     * @return The Account Name of the Contact.
     */
    public static String getAccountNameForContact(String contactId) {
        List<Contact> accountWithContactId = [SELECT Id, Name, Account.Name, Account.Id FROM Contact WHERE Id = :contactId];
        String accountNameForContact = accountWithContactId.get(0).Account.Name;
        return accountNameForContact;
    }    

    /**
     * Question 20
     * Returns single Account that has related opportunities in the same query
     * Example: getAccountAndOpportunitiesFromAccountId('001XXXXXXXXXXXX') should return the Account Name for the Account with the Id and all related Opportunities
     * @param accountId The ID of the Account.
     * @return An Account record with related Opportunities.
     */
    public static Account getAccountAndOpportunitiesFromAccountId(Id accountId) {
        List<Account> accountWithOpps = [SELECT Id, Name, (SELECT Id, Name FROM Opportunities) FROM Account WHERE Id = :accountId];
        Account accountNameAndRelatedOpps = accountWithOpps[0];
        return accountNameAndRelatedOpps;
    }

    /**
     * Question 21
     * Retrieves all contacts that have the Mailing State similar to the Account Billing State.
     * Example: getAccountsWithContactsByState('001XXXXXXXXXXXX') should return a list of Contacts that have the same Mailing State as the Account with the Id
     * @param Account Id
     * @return List of contacts with the same Mailing State as the Account Billing State
     */
    public static List<Contact> getAccountsWithContactsByState(Id accountId) {
        List<Account> accWithBillingState = [SELECT Id, Name, BillingState FROM Account WHERE Id = :accountId];
        String accBillingState = accWithBillingState[0].BillingState;
        List<Contact> contactWityMailingAddress = [SELECT Id, Name, MailingState FROM Contact WHERE MailingState = :accBillingState];
        return contactWityMailingAddress;
    }

    /**
     * Question 22
     * Extracts email domains from them leads, then finds Accounts with matching website domains
     * If Lead Email = test@test.com return account with website = www.test.com
     * Example: findAccountsByLeadEmailDomains([set of lead ids]) should return a list of Accounts with matching email domains
     * @param A set of Lead Ids.
     * @return A list of Accounts with matching email domains.
     */
    public static List<Account> findAccountsByLeadEmailDomains(Set<Id> leadIds) {
        List<Lead> leadList = [SELECT Id, LastName, Company, Email FROM Lead WHERE Id IN :leadIds];
        Set<String> emailDomains = new Set<String>();
        for(Lead leadEmail: leadList) {
            String email = leadEmail.Email;
            if(email != null) {
                String domain = email.substringAfter('@');
                emailDomains.add(domain);
            }
        }
        String query = 'SELECT Id, Name, Website FROM Account WHERE ';
        List<String> domainValue = new List<String>();
        for(String domain: emailDomains) {
            domainValue.add('Website LIKE \'%' + domain + '%\'');
        }
        query += String.join(domainValue, 'OR');
        List<Account> accountsWithDomain = Database.query(query);
        return accountsWithDomain;
    }

    /**
     * Question 23
     * Clones and Inserts Opportunity Line Items from an original Opportunity to a list of cloned Opportunities.
     * Adds a randomized number between 1 to 3 to the quantity of each line item.
     * Example: cloneLineItems('001XXXXXXXXXXXX', [list of opportunity ids]) should clone the line items from the Opportunity with the Id to each Opportunity in the list
     * @param Original Opportunity Id
     * @param List of cloned Opportunity Ids
     */
    public static void cloneLineItems(Id origOppId, List<Id> cloneOppIds) {
        List<OpportunityLineItem> origOppsLineItem = [SELECT Id, OpportunityId, Quantity, PricebookEntryId, UnitPrice FROM OpportunityLineItem WHERE OpportunityId = :origOppId];
        List<OpportunityLineItem> newClonedOppsLineItem = new List<OpportunityLineItem>();
        for(Id oppId: cloneOppIds) {
            for(OpportunityLineItem oli: origOppsLineItem) {
                OpportunityLineItem oliCopy = oli.clone(false, false, false, false);
                oliCopy.OpportunityId = oppId;
                oliCopy.Quantity = Integer.valueOf((Math.random() * 3) + 1);
                oliCopy.UnitPrice = oli.UnitPrice;
                newClonedOppsLineItem.add(oliCopy);
            }
        }
        insert newClonedOppsLineItem;
    }
    
    /**
     * Question 24
     * Retrieves the Opportunity Name, Account Name, and Owner Name for Opportunities that have a Stage of 'Closed Won'.
     * Example: getOpportunityDetailsForClosedWon()
     * @return A list of filtered Opportunity
     */
    public static List<Opportunity> getOpportunityDetailsForClosedWon() {
        List<Opportunity> oppsDetails = [SELECT Id, Name, Account.Name, Owner.Name FROM Opportunity WHERE StageName = 'Closed Won'];        
        return oppsDetails;
    }

    /**
     * Question 25
     * Sets the 'Primary_Contact__c' field for all Closed Won Opportunities to first Contact on the Account.
     * Example: setPrimaryContact() should set the 'Primary_Contact__c' field for every Opportunity in the org
     */
    public static void setPrimaryContact() {
        List<Opportunity> closedWonOpps = getOpportunityDetailsForClosedWon();
        Set<Id> accountId = new Set<Id>();
        Map<Id,Contact> contactWithAccountId = new Map<Id,Contact>();
        for(Opportunity opp: closedWonOpps) {
            accountId.add(opp.AccountId);
        }
        List<Contact> contactsForAccount = [SELECT Id, Name, AccountId FROM Contact WHERE AccountId IN :accountId];
        for(Contact con: contactsForAccount) {
            contactWithAccountId.put(con.AccountId, con);
        }
        for(opportunity opp: closedWonOpps) {
            opp.Primary_Contact__c = contactWithAccountId.get(opp.AccountId).Id;
        }
        update closedWonOpps;
    }
}