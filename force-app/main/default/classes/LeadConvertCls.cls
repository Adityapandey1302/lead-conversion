public class LeadConvertCls {
 
    @AuraEnabled
    public static lead__c getLeadData(String recId){
        Lead__c lead = [
            SELECT Name__c, Name, OwnerId, Company__c, Lead_Status__c, Phone__c, Mobile__c, 
                   Email__c, website__c, First_Name__c, Last_Name__c, Title__c, 
                   /* COMMENTED OUT - Not using Requirement__c anymore
                   Requirement__c,
                   */
                   Existing_Account__c, IsNew_Account__c, Is_Converted__c,
                   Address1__c, City__c, State__c, Country__c, Zip_Postal_Code__c, Other_City__c, 
            	   New_OEM__c, Lead_Name__c, No_of_Employees__c, Project__c 
            FROM Lead__c 
            WHERE Id = :recId 
            LIMIT 1
        ];
        
        // Check if Lead is already converted
        if (lead.Is_Converted__c == true) {
            throw new AuraHandledException('This Lead has already been converted and cannot be converted again.');
        }
        
        system.debug('Lead Status: ' + lead.Lead_Status__c);
        // COMMENTED OUT - Not using Requirement__c anymore
        // system.debug('Requirement: ' + lead.Requirement__c);
        system.debug('Existing Account: ' + lead.Existing_Account__c);
        system.debug('Is New Account: ' + lead.IsNew_Account__c);
        system.debug('Company__c: ' + lead.Company__c);
        system.debug('Lead Address1: ' + lead.Address1__c);
        system.debug('Lead City: ' + lead.City__c);
        system.debug('Lead State: ' + lead.State__c);
        system.debug('Lead Country: ' + lead.Country__c);
        system.debug('Lead Zip: ' + lead.Zip_Postal_Code__c);
        system.debug('Lead Other City: ' + lead.Other_City__c);
        system.debug('Lead New OEM: ' + lead.New_OEM__c);
        
        return lead;
    }
    
    @AuraEnabled
    public static Account getAccount(String accId, String leadId){
        system.debug('account Id: ' + accId);
        system.debug('lead Id: ' + leadId);
        
        Account acc = [
            SELECT Id, Name, Phone, Email__c, Website, 
                   Customer_Classification__c, Dealer_Assigned__c, 
                   Designation__c, Division__c, GST_Number__c, Shipping_GST_Number__c,
                   OEM__c, PAN_Number__c, Owner.Name, Shipping_PAN_Number__c, 
                   Lead_Name__c, Lead_Source__c, Lead_Subject__c,
                   Latest_Note__c, Note_Date__c, Lead_Created_By__c,
                   Lead_Creation_Date__c, Industry__c, Industry_Sub_Type__c, Industry_Type__c, IndustryMulti__c, Industry_SubType__c,
                   Type, CIN_Number__c, New_OEM__c,
                   BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, Other_Billing_City__c,
                   ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry, Other_Shipping_City__c,
                   Applicable_Pricebook__c, Applicable_Pricebook__r.Name, NumberOfEmployees 
            FROM Account 
            WHERE Id = :accId 
            LIMIT 1
        ];
        
        return acc;
    }

    @AuraEnabled
    public static Contact getContact(String contactId){
        system.debug('contactID: ' + contactId);
        
        Contact contact = [
            SELECT Id, Name, FirstName, LastName, Salutation, Phone, MobilePhone, Email, AccountId, Account.Name, Title 
            FROM Contact 
            WHERE Id = :contactId 
            LIMIT 1
        ];
        
        return contact;
    }

    /* COMMENTED OUT - Not creating Sample Requests anymore
    @AuraEnabled
    public static Sample_Request__c getSampleRequest(String sampleId){
        system.debug('sampleId: ' + sampleId);
        
        Sample_Request__c sample = [
            SELECT Id, Name, Account__c, Account__r.Name, Owner.Name, Status__c,
                   LeadName__c,
                   Bill_To_Name__c, Billing_Address__c, Billing_City__c, Billing_State__c,
                   Billing_Country__c, Billing_Zip_Postal_Code__c, Other_Billing_City__c,
                   Ship_To_Name__c, Shipping_Address__c, Shippin__c, Shipping_State__c,
                   Shipping_Country__c, Shipping_Zip_Postal_Code__c, Other_Shipping_City__c,
                   Sample_To_Name__c, Sample_Address__c, Sample_City__c, Sample_State__c,
                   Sample_Country__c, Sample_Zip_Postal_Code__c,
                   Applicable_Pricebook__c, Contact__c, OEM__c, Project__c 
            FROM Sample_Request__c 
            WHERE Id = :sampleId 
            LIMIT 1
        ];
        
        return sample;
    }
    */

    /* COMMENTED OUT - Not creating Quotes anymore
    @AuraEnabled
    public static Quote__c getQuote(String quoteId){
        system.debug('quoteId: ' + quoteId);
        
        Quote__c quote = [
            SELECT Id, Name, Account_Name__c, Owner.Name, Status__c,
                   LeadName__c,
                   Bill_To_Name__c, Billing_Address__c, Billing_City__c, Billing_State__c,
                   Billing_Country__c, Billing_Zip_Postal_Code__c,Other_Billing_City__c,
                   Ship_To_Name__c, Shipping_Address__c, Shipping_City__c, Shipping_State__c,
                   Shipping_Country__c, Shipping_Zip_Postal_Code__c, Other_Shipping_City__c,
                   Quote_To_Name__c, Quote_Address__c, Quote_City__c, Quote_State__c,
                   Quote_Country__c, Quote_Zip_Postal_Code__c,
                   Applicable_Pricebook__c, Contact_Name__c, Project__c 
            FROM Quote__c 
            WHERE Id = :quoteId 
            LIMIT 1
        ];
        
        return quote;
    }
    */

    public class ConversionResult {
        @AuraEnabled
        public Id accountId;
        @AuraEnabled
        public Id contactId;
        /* COMMENTED OUT - Not creating Quote/Sample anymore
        @AuraEnabled
        public Id sampleRequestId;
        @AuraEnabled
        public Id quoteId;
        @AuraEnabled
        public String requirementType;
        @AuraEnabled
        public Sample_Request__c sampleRequestData;
        @AuraEnabled
        public Quote__c quoteData;
        */
        @AuraEnabled
        public String errorMessage;
        @AuraEnabled
        public Boolean isNewAccount;
        @AuraEnabled
        public Account accountData;
        @AuraEnabled
        public Contact contactData;
        @AuraEnabled
        public String ownerName;
    }
    
    /* COMMENTED OUT - Not using pricebook logic anymore since we're not creating Quote/Sample
    private static Id getApplicablePricebook(String accountType) {
        if (String.isBlank(accountType)) {
            system.debug('Account Type is blank, no pricebook will be assigned');
            return null;
        }
        
        try {
            List<Pricebook2__c> pricebooks = [
                SELECT Id, Name, Applicable_For__c
                FROM Pricebook2__c
                WHERE Applicable_For__c = :accountType
                LIMIT 1
            ];
            
            if (!pricebooks.isEmpty()) {
                system.debug('Found Pricebook: ' + pricebooks[0].Name + ' for Account Type: ' + accountType);
                return pricebooks[0].Id;
            } else {
                system.debug('No Pricebook found for Account Type: ' + accountType);
                return null;
            }
        } catch (Exception e) {
            system.debug('Error finding pricebook: ' + e.getMessage());
            return null;
        }
    }
    */
    
    // NEW - This programmatic Lead conversion should not be blocked by
    // Account/Contact duplicate rules (e.g. fuzzy Account-Name matching on
    // bulk conversions). optAllOrNone stays true so every other DML failure
    // (required fields, validation rules, etc.) still throws normally and is
    // still caught by the try/catch below - only duplicate-rule blocks are
    // bypassed, mirroring how native Lead Convert can be configured.
    private static Database.DMLOptions getDuplicateBypassDmlOptions() {
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.OptAllOrNone = true;
        dmlOpts.DuplicateRuleHeader.AllowSave = true;
        dmlOpts.DuplicateRuleHeader.RunAsCurrentUser = true;
        return dmlOpts;
    }

    @AuraEnabled
    public static ConversionResult convertLead(String accName, String conName, Id leadId) {
        system.debug('=== CONVERSION START ===');
        system.debug('accName (User Input): ' + accName);
        system.debug('conName: ' + conName);
        system.debug('leadId: ' + leadId);
        
        Savepoint sp = Database.setSavepoint();
        
        try {
            lead__c lead = [
                SELECT Id, Name, Email__c, Phone__c, Website__c, Customer_Classification__c,
                       Dealer_Assigned__c, Designation__c, Division__c, GST_Number__c, 
                       OEM__c, PAN_Number__c, Type__c, CIN_Number__c, New_OEM__c,
                       /* COMMENTED OUT - Not using Requirement__c anymore
                       Requirement__c, 
                       */
                       Existing_Account__c, IsNew_Account__c, Is_Converted__c,
                       LeadSource__c, Subject__c, Latest_Note__c, Note_Date__c, 
                       CreatedById, CreatedDate, Industry__c, Industry_Type__c, Industry_Sub_Type__c, IndustryMulti__c, Industry_SubType__c,
                       First_Name__c, Last_Name__c, Title__c, Mobile__c, Company__c,
                       Address1__c, City__c, State__c, Country__c, Zip_Postal_Code__c, Other_City__c,
                       Last_Status_Change_Date__c, Lead_Name__c, No_of_Employees__c, Project__c,
                       Lead_Status__c, Department__c  
            FROM lead__c 
            WHERE Id = :leadId 
            LIMIT 1
        ];
        
        system.debug('Lead Status: ' + lead.Lead_Status__c);
        
        // CRITICAL DEBUG: Log address fields from Lead
        system.debug('=== LEAD ADDRESS FIELDS ===');
        system.debug('Company__c: ' + lead.Company__c);
        system.debug('Address1__c: ' + lead.Address1__c);
        system.debug('City__c: ' + lead.City__c);
        system.debug('State__c: ' + lead.State__c);
        system.debug('Country__c: ' + lead.Country__c);
        system.debug('Zip_Postal_Code__c: ' + lead.Zip_Postal_Code__c);
        system.debug('New_OEM__c: ' + lead.New_OEM__c);
        
        if (lead.Is_Converted__c == true) {
            throw new AuraHandledException('This Lead has already been converted and cannot be converted again.');
        }
        
        ConversionResult result = new ConversionResult();
        // COMMENTED OUT - Not using requirementType anymore
        // result.requirementType = lead.Requirement__c;
        
        /* COMMENTED OUT - Not checking for "Assigned to Dealer" anymore since we're not creating Quote/Sample
        Boolean isAssignedToDealer = lead.Lead_Status__c == 'Assigned to Dealer';
        system.debug('Is Assigned to Dealer: ' + isAssignedToDealer);
        */
        
        Account account;
        Contact contact;
        Id accountIdToUse;
        Id contactIdToUse;
        
        if (lead.IsNew_Account__c == true) {
            result.isNewAccount = true;
            
            account = new Account();
            account.Name = accName;
            system.debug('Account.Name set to user input: ' + accName);
            
            account.Phone = lead.Phone__c;
            account.Email__c = lead.Email__c;
            account.Website = lead.Website__c;
            account.Customer_Classification__c = lead.Customer_Classification__c;
            account.Dealer_Assigned__c = lead.Dealer_Assigned__c;
            account.Division__c = lead.Division__c;
            account.GST_Number__c = lead.GST_Number__c;
            account.Shipping_GST_Number__c = lead.GST_Number__c;
            account.OEM__c = lead.OEM__c;
            account.PAN_Number__c = lead.PAN_Number__c;
            account.Shipping_PAN_Number__c = lead.PAN_Number__c;
            account.Type = lead.Type__c;
            account.CIN_Number__c = lead.CIN_Number__c;
            account.New_OEM__c = lead.New_OEM__c;
            account.Lead_Name__c = lead.Id;
            account.LeadName__c = lead.Id; 
            account.Lead_Source__c = lead.LeadSource__c;
            account.Lead_Subject__c = lead.Subject__c;
            account.Latest_Note__c = lead.Latest_Note__c;
            account.Note_Date__c = lead.Note_Date__c;
            account.Lead_Created_By__c = lead.CreatedById;
            account.Lead_Creation_Date__c = lead.CreatedDate.date();
            //account.Industry__c = lead.Industry__c;
            account.Industry_Type__c = lead.Industry_Type__c;
            //account.Industry_Sub_Type__c = lead.Industry_Sub_Type__c;
            account.IndustryMulti__c = lead.IndustryMulti__c;
            account.Industry_SubType__c = lead.Industry_SubType__c;
            account.NumberOfEmployees = lead.No_of_Employees__c != null ? Integer.valueOf(lead.No_of_Employees__c) : null;
            
            // Map Lead address fields to Account
            account.Billing_Address__c = lead.Address1__c;
            account.Billing_City__c = lead.City__c;
            account.Billing_State__c = lead.State__c;
            account.Billing_Country__c = lead.Country__c;
            account.Billing_Zip_Postal_Code__c = lead.Zip_Postal_Code__c;
            account.Other_Billing_City__c = lead.Other_City__c;
            
            account.Shipping_Address__c = lead.Address1__c;
            account.Shipping_City__c = lead.City__c;
            account.Shipping_State__c = lead.State__c;
            account.Shipping_Country__c = lead.Country__c;
            account.Shipping_Zip_Postal_Code__c = lead.Zip_Postal_Code__c;
            account.Other_Shipping_City__c = lead.Other_City__c;
            
            system.debug('=== ACCOUNT BEFORE INSERT ===');
            system.debug('Account.Name: ' + account.Name);
            system.debug('Billing_Address__c: ' + account.Billing_Address__c);
            system.debug('Billing_City__c: ' + account.Billing_City__c);
            system.debug('Billing_State__c: ' + account.Billing_State__c);
            system.debug('Billing_Country__c: ' + account.Billing_Country__c);
            system.debug('Billing_Zip_Postal_Code__c: ' + account.Billing_Zip_Postal_Code__c);
            system.debug('New_OEM__c: ' + account.New_OEM__c);
            
            Database.insert(account, getDuplicateBypassDmlOptions());
            system.debug('Account created with ID: ' + account.Id);
            
            /* COMMENTED OUT - Not setting pricebook anymore since we're not creating Quote/Sample
            if (!isAssignedToDealer) {
                Id applicablePricebookId = getApplicablePricebook(account.Type);
                if (applicablePricebookId != null) {
                    account.Applicable_Pricebook__c = applicablePricebookId;
                    update account;
                    system.debug('Account updated with Applicable Pricebook: ' + applicablePricebookId);
                }
            }
            */
            
            accountIdToUse = account.Id;
            
            account = [
                SELECT Id, Name, Phone, Email__c, Website, Owner.Name, Type,
                       Customer_Classification__c, Dealer_Assigned__c, 
                       Designation__c, Division__c, GST_Number__c, Shipping_PAN_Number__c, Shipping_GST_Number__c,
                       OEM__c, PAN_Number__c, CIN_Number__c, New_OEM__c,
                       Lead_Name__c, LeadName__c, Lead_Source__c, Lead_Subject__c,
                       Latest_Note__c, Note_Date__c, Lead_Created_By__c,
                       Lead_Creation_Date__c, Industry__c, Industry_Type__c,Industry_Sub_Type__c, IndustryMulti__c, Industry_SubType__c, 
                       Billing_Address__c, Billing_City__c, Billing_State__c, Billing_Zip_Postal_Code__c, Billing_Country__c, Other_Billing_City__c,
                       Shipping_Address__c, Shipping_City__c, Shipping_State__c, Shipping_Zip_Postal_Code__c, Shipping_Country__c, Other_Shipping_City__c,
                       Applicable_Pricebook__c, Applicable_Pricebook__r.Name, NumberOfEmployees 
                FROM Account 
                WHERE Id = :account.Id 
                LIMIT 1
            ];
            
            system.debug('=== ACCOUNT AFTER QUERY ===');
            system.debug('Account.Name: ' + account.Name);
            system.debug('Billing_Address__c: ' + account.Billing_Address__c);
            system.debug('Billing_City__c: ' + account.Billing_City__c);
            system.debug('New_OEM__c: ' + account.New_OEM__c);
            
            result.accountId = account.Id;
            result.accountData = account;
            result.ownerName = account.Owner.Name;

            contact = new Contact(
                Salutation = lead.Title__c,
                FirstName = lead.First_Name__c,
                lastName = lead.Last_Name__c,
                Title = lead.Designation__c, 
                Email = lead.Email__c,
                Phone = lead.Phone__c,
                MobilePhone = lead.Mobile__c,
                AccountId = account.Id,
                Department__c = lead.Department__c
            );
            Database.insert(contact, getDuplicateBypassDmlOptions());
            system.debug('Contact created with ID: ' + contact.Id);
            contactIdToUse = contact.Id;
            
            contact = [
                SELECT Id, Name, Salutation, FirstName, LastName, Phone, MobilePhone, Email, AccountId, Account.Name, Title, Department
                FROM Contact 
                WHERE Id = :contact.Id 
                LIMIT 1
            ];
            
            result.contactId = contact.Id;
            result.contactData = contact;
            
        } else {
            result.isNewAccount = false;
            
            if (lead.Existing_Account__c == null) {
                throw new AuraHandledException('Existing Account must be selected when IsNew_Account__c is unchecked.');
            }
            
            accountIdToUse = lead.Existing_Account__c;
            
            account = [
                SELECT Id, Name, Phone, Email__c, Website, Owner.Name, Type,
                       Customer_Classification__c, Dealer_Assigned__c, 
                       Designation__c, Division__c, GST_Number__c, Shipping_PAN_Number__c, Shipping_GST_Number__c,
                       OEM__c, PAN_Number__c, CIN_Number__c, New_OEM__c,
                       Lead_Name__c, LeadName__c, Lead_Source__c, Lead_Subject__c,
                       Latest_Note__c, Note_Date__c, Lead_Created_By__c,
                       Lead_Creation_Date__c, Industry__c, Industry_Sub_Type__c, Industry_Type__c,Industry_SubType__c, IndustryMulti__c,
                       BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry,Other_Billing_City__c,
                       ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry,Other_Shipping_City__c,
                       Applicable_Pricebook__c, Applicable_Pricebook__r.Name, NumberOfEmployees 
                FROM Account 
                WHERE Id = :accountIdToUse 
                LIMIT 1
            ];
            
            /* COMMENTED OUT - Not setting pricebook anymore since we're not creating Quote/Sample
            if (!isAssignedToDealer) {
                Id applicablePricebookId = getApplicablePricebook(account.Type);
                if (applicablePricebookId != null && account.Applicable_Pricebook__c == null) {
                    account.Applicable_Pricebook__c = applicablePricebookId;
                    update account;
                    system.debug('Existing Account updated with Applicable Pricebook: ' + applicablePricebookId);
                    
                    account = [
                        SELECT Id, Name, Phone, Email__c, Website, Owner.Name, Type,
                               Customer_Classification__c, Dealer_Assigned__c, 
                               Designation__c, Division__c, GST_Number__c, Shipping_PAN_Number__c, Shipping_GST_Number__c,
                               OEM__c, PAN_Number__c, CIN_Number__c, New_OEM__c,
                               Lead_Name__c, LeadName__c, Lead_Source__c, Lead_Subject__c,
                               Latest_Note__c, Note_Date__c, Lead_Created_By__c,
                               Lead_Creation_Date__c, Industry__c, Industry_Sub_Type__c, Industry_Type__c,
                               BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, Other_Billing_City__c,
                               ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry, Other_Shipping_City__c,
                               Applicable_Pricebook__c, Applicable_Pricebook__r.Name, NumberOfEmployees 
                        FROM Account 
                        WHERE Id = :accountIdToUse 
                        LIMIT 1
                    ];
                }
            }
            */
            
            result.accountId = account.Id;
            result.accountData = account;
            result.ownerName = account.Owner.Name;
            
            system.debug('Using existing Account with ID: ' + accountIdToUse);

            // NEW - Create a Contact against the existing Account too,
            // mirroring the Contact created in the new-account branch above.
            contact = new Contact(
                Salutation = lead.Title__c,
                FirstName = lead.First_Name__c,
                lastName = lead.Last_Name__c,
                Title = lead.Designation__c, 
                Email = lead.Email__c,
                Phone = lead.Phone__c,
                MobilePhone = lead.Mobile__c,
                AccountId = accountIdToUse,
                Department__c = lead.Department__c
            );
            Database.insert(contact, getDuplicateBypassDmlOptions());
            system.debug('Contact created against existing Account with ID: ' + contact.Id);
            contactIdToUse = contact.Id;

            contact = [
                SELECT Id, Name, Salutation, FirstName, LastName, Phone, MobilePhone, Email, AccountId, Account.Name, Title, Department
                FROM Contact 
                WHERE Id = :contact.Id 
                LIMIT 1
            ];

            result.contactId = contact.Id;
            result.contactData = contact;
        }

        /* COMMENTED OUT - Not creating Sample Request or Quote anymore - Only Account and Contact are created
        if (!isAssignedToDealer) {
            Id applicablePricebookId = account.Applicable_Pricebook__c;
            system.debug('Applicable Pricebook ID for Quote/Sample: ' + applicablePricebookId);

            if (lead.Requirement__c == 'Sample') {
                Sample_Request__c sampleRequest = new Sample_Request__c(
                    Account__c = accountIdToUse,
                    Contact__c = contactIdToUse,
                    Status__c = 'New',
                    LeadName__c = lead.Id,
                    Applicable_Pricebook__c = applicablePricebookId,
                    OEM__c = lead.New_OEM__c,
                    Project__c = lead.Project__c,
                    
                    Sample_To_Name__c = account.Name,
                    Sample_Address__c = lead.Address1__c,
                    Sample_City__c = lead.City__c,
                    Sample_Country__c = lead.Country__c,
                    Sample_State__c = lead.State__c,
                    Sample_Zip_Postal_Code__c = lead.Zip_Postal_Code__c,
                    
                    Bill_To_Name__c = account.Name,
                    Billing_Address__c = lead.Address1__c,
                    Billing_City__c = lead.City__c,
                    Billing_State__c = lead.State__c,
                    Billing_Country__c = lead.Country__c,
                    Billing_Zip_Postal_Code__c = lead.Zip_Postal_Code__c,
                    Other_Billing_City__c = lead.Other_City__c,
                    
                    Ship_To_Name__c = account.Name,
                    Shipping_Address__c = lead.Address1__c,
                    Shippin__c = lead.City__c,
                    Shipping_State__c = lead.State__c,
                    Shipping_Country__c = lead.Country__c,
                    Shipping_Zip_Postal_Code__c = lead.Zip_Postal_Code__c,
                    Other_Shipping_City__c = lead.Other_City__c
                );
                
                system.debug('=== SAMPLE REQUEST ADDRESS BEFORE INSERT ===');
                system.debug('Sample_Address__c: ' + sampleRequest.Sample_Address__c);
                system.debug('Sample_City__c: ' + sampleRequest.Sample_City__c);
                system.debug('Billing_Address__c: ' + sampleRequest.Billing_Address__c);
                system.debug('Shipping_Address__c: ' + sampleRequest.Shipping_Address__c);
                
                insert sampleRequest;
                system.debug('Sample Request created with ID: ' + sampleRequest.Id);
                
                sampleRequest = [
                    SELECT Id, Name, Account__c, Account__r.Name, Owner.Name, Status__c,
                           LeadName__c,
                           Bill_To_Name__c, Billing_Address__c, Billing_City__c, Billing_State__c,
                           Billing_Country__c, Billing_Zip_Postal_Code__c, Other_Billing_City__c,
                           Ship_To_Name__c, Shipping_Address__c, Shippin__c, Shipping_State__c,
                           Shipping_Country__c, Shipping_Zip_Postal_Code__c, Other_Shipping_City__c,
                           Sample_To_Name__c, Sample_Address__c, Sample_City__c, Sample_State__c,
                           Sample_Country__c, Sample_Zip_Postal_Code__c,
                           Applicable_Pricebook__c, Applicable_Pricebook__r.Name, 
                           Contact__c, OEM__c, Project__c 
                    FROM Sample_Request__c 
                    WHERE Id = :sampleRequest.Id 
                    LIMIT 1
                ];
                
                system.debug('=== SAMPLE REQUEST AFTER QUERY ===');
                system.debug('Sample Request Name: ' + sampleRequest.Name);
                system.debug('Sample_Address__c: ' + sampleRequest.Sample_Address__c);
                system.debug('Billing_Address__c: ' + sampleRequest.Billing_Address__c);
                
                result.sampleRequestId = sampleRequest.Id;
                result.sampleRequestData = sampleRequest;
                lead.Lead_Status__c = 'Converted to Sample';
                lead.Last_Status_Change_Date__c = System.today();
                
            } else if (lead.Requirement__c == 'Quotation') {
                Quote__c quote = new Quote__c(
                    Account_Name__c = accountIdToUse,
                    Contact_Name__c = contactIdToUse,
                    Status__c = 'Draft',
                    LeadName__c = lead.Id,
                    Applicable_Pricebook__c = applicablePricebookId,
                    Project__c = lead.Project__c,
                    
                    Quote_To_Name__c = account.Name,
                    Quote_Address__c = lead.Address1__c,
                    Quote_City__c = lead.City__c,
                    Quote_State__c = lead.State__c,
                    Quote_Country__c = lead.Country__c,
                    Quote_Zip_Postal_Code__c = lead.Zip_Postal_Code__c,
                    
                    Bill_To_Name__c = account.Name,
                    Billing_Address__c = lead.Address1__c,
                    Billing_City__c = lead.City__c,
                    Billing_State__c = lead.State__c,
                    Billing_Country__c = lead.Country__c,
                    Billing_Zip_Postal_Code__c = lead.Zip_Postal_Code__c,
                    Other_Billing_City__c = lead.Other_City__c,
                    
                    Ship_To_Name__c = account.Name,
                    Shipping_Address__c = lead.Address1__c,
                    Shipping_City__c = lead.City__c,
                    Shipping_State__c = lead.State__c,
                    Shipping_Country__c = lead.Country__c,
                    Shipping_Zip_Postal_Code__c = lead.Zip_Postal_Code__c,
                    Other_Shipping_City__c = lead.Other_City__c
                );
                
                system.debug('=== QUOTE ADDRESS BEFORE INSERT ===');
                system.debug('Quote_Address__c: ' + quote.Quote_Address__c);
                system.debug('Quote_City__c: ' + quote.Quote_City__c);
                system.debug('Billing_Address__c: ' + quote.Billing_Address__c);
                system.debug('Shipping_Address__c: ' + quote.Shipping_Address__c);
                
                insert quote;
                system.debug('Quote created with ID: ' + quote.Id);
                
                quote = [
                    SELECT Id, Name, Account_Name__c, Owner.Name, Status__c,
                           LeadName__c,
                           Bill_To_Name__c, Billing_Address__c, Billing_City__c, Billing_State__c,
                           Billing_Country__c, Billing_Zip_Postal_Code__c,
                           Ship_To_Name__c, Shipping_Address__c, Shipping_City__c, Shipping_State__c,
                           Shipping_Country__c, Shipping_Zip_Postal_Code__c,
                           Quote_To_Name__c, Quote_Address__c, Quote_City__c, Quote_State__c,
                           Quote_Country__c, Quote_Zip_Postal_Code__c,
                           Applicable_Pricebook__c, Applicable_Pricebook__r.Name, 
                           Contact_Name__c, Project__c 
                    FROM Quote__c 
                    WHERE Id = :quote.Id 
                    LIMIT 1
                ];
                
                system.debug('=== QUOTE AFTER QUERY ===');
                system.debug('Quote Name: ' + quote.Name);
                system.debug('Quote_Address__c: ' + quote.Quote_Address__c);
                system.debug('Billing_Address__c: ' + quote.Billing_Address__c);
                
                result.quoteId = quote.Id;
                result.quoteData = quote;
                lead.Lead_Status__c = 'Converted to Quote';
                lead.Last_Status_Change_Date__c = System.today();
            }
        } else {
            system.debug('Lead Status is "Assigned to Dealer" - Skipping Sample/Quote creation');
        }
        */

        // MODIFIED - Simply mark lead as converted without changing status based on Quote/Sample
        lead.Is_Converted__c = true;
        // OPTIONAL: Update Lead_Status__c to a generic "Converted" status if needed
        // lead.Lead_Status__c = 'Converted';
        // lead.Last_Status_Change_Date__c = System.today();
        
        update lead;
        system.debug('Lead updated: Is_Converted__c = true');
        system.debug('=== CONVERSION COMPLETE ===');
        
        return result;
    }
    catch(DmlException dmlEx) {
        Database.rollback(sp);
        ConversionResult result = new ConversionResult();
        result.errorMessage = dmlEx.getMessage();
        system.debug('DML Exception - Rolling back all changes: ' + dmlEx.getMessage());
        return result;
    }
    catch(Exception ex) {
        Database.rollback(sp);
        ConversionResult result = new ConversionResult();
        result.errorMessage = ex.getMessage();
        system.debug('General Exception - Rolling back all changes: ' + ex.getMessage());
        return result;
    }
}
}