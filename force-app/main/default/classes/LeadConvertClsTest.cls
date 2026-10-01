@isTest
public class LeadConvertClsTest {

    @testSetup
    static void setupTestData() {
        /* COMMENTED OUT - Not using Pricebook2__c anymore since Quote/Sample not created
        Pricebook2__c pb1 = new Pricebook2__c(
            Applicable_For__c = 'Export'
        );
        insert pb1;
        
        Pricebook2__c pb2 = new Pricebook2__c(
            Applicable_For__c = 'Local WB'
        );
        insert pb2;
        */
        
        // Create "NEW" Account to trigger IsNew_Account__c formula = true
        Account newAccount = new Account(
            Name = 'NEW',
            Phone = '0000000000',
            Email__c = 'new@example.com',
            Status__c = 'Approved'
        );
        insert newAccount;
        
        // Create existing Account for testing existing account scenario
        Account existingAcc = new Account(
            Name = 'Existing Test Account',
            Phone = '1234567890',
            Email__c = 'existing@example.com',
            Website = 'www.existing.com',
            Type = 'B2B',
            Customer_Classification__c = 'B2B',
            Dealer_Assigned__c = 'Jai Balaji-Coimbatore',
            Designation__c = 'Manager',
            Division__c = 'NIPL',
            GST_Number__c = 'GSTIN1234',
            OEM__c = 'Bajaj Auto',
            PAN_Number__c = 'ABCDE1234F',
            CIN_Number__c = 'CIN123456',
            Industry__c = 'Electronics',
            Industry_Type__c = 'Trader',
            New_OEM__c = 'Bajaj Auto',
            Billing_Address__c = '123 Main St',
            Billing_City__c = 'Chennai',
            Billing_State__c = 'Tamil Nadu',
            Billing_Country__c = 'India',
            Billing_Zip_Postal_Code__c = '400001',
            Shipping_Address__c = '123 Main St',
            Shipping_City__c = 'Chennai',
            Shipping_State__c = 'Tamil Nadu',
            Shipping_Country__c = 'India',
            Shipping_Zip_Postal_Code__c = '400001',
            Status__c = 'Approved'
        );
        insert existingAcc;
        
        // Create Contact
        Contact existingCon = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'contact@example.com',
            Phone = '9876543210',
            MobilePhone = '9876543211',
            AccountId = existingAcc.Id,
            Title = 'Manager'
        );
        insert existingCon;
        
        // MODIFIED - Create Lead for New Account (IsNew_Account__c = true) - No Requirement__c needed
        Lead__c leadNew = new Lead__c(
            Lead_Name__c = 'Test Company New',
            Company__c = 'Test Company New',
            Phone__c = '9899123456',
            Mobile__c = '9899123457',
            Email__c = 'testnew@example.com',
            Website__c = 'www.testnew.com',
            Lead_Status__c = 'Open',
            First_Name__c = 'John',
            Last_Name__c = 'Doe',
            Title__c = 'Mr.',
            Type__c = 'Local WB',
            CIN_Number__c = 'CIN789012',
            Customer_Classification__c = 'B2C',
            Dealer_Assigned__c = 'Jai Balaji-Coimbatore',
            Designation__c = 'Director',
            Division__c = 'NIPL',
            GST_Number__c = 'GST9876',
            OEM__c = 'OEM ABC',
            New_OEM__c = 'Bajaj Auto',
            PAN_Number__c = 'PANAB1234C',
            /* COMMENTED OUT - Not using Requirement__c anymore
            Requirement__c = 'Sample',
            */
            Is_Converted__c = false,
            LeadSource__c = 'Website',
            Subject__c = 'Product Inquiry',
            Latest_Note__c = 'Test note',
            Note_Date__c = System.today(),
            Industry__c = 'Trading',
            Industry_Type__c = 'Trader',
            Address1__c = '456 Oak Ave',
            City__c = 'Chennai',
            State__c = 'Tamil Nadu',
            Country__c = 'India',
            Zip_Postal_Code__c = '110001',
            Remarks_for_Lead_Status__c = 'Initial lead creation',
            Existing_Account__c = newAccount.Id
        );
        insert leadNew;
        
        /* COMMENTED OUT - Not creating separate Quote lead anymore
        Lead__c leadQuoteNew = new Lead__c(
            Lead_Name__c = 'Quote Company New',
            Company__c = 'Quote Company New',
            Phone__c = '9899123458',
            Mobile__c = '9899123459',
            Email__c = 'quotenew@example.com',
            Website__c = 'www.quotenew.com',
            Lead_Status__c = 'Open',
            First_Name__c = 'Jane',
            Last_Name__c = 'Smith',
            Title__c = 'Ms.',
            Type__c = 'Local WB',
            Customer_Classification__c = 'B2B',
            New_OEM__c = 'Bajaj Auto',
            Requirement__c = 'Quotation',
            Is_Converted__c = false,
            Address1__c = '789 Pine Rd',
            City__c = 'Chennai',
            State__c = 'Tamil Nadu',
            Country__c = 'India',
            Zip_Postal_Code__c = '560001',
            Designation__c = 'Manager',
            Dealer_Assigned__c = 'Jai Balaji-Coimbatore',
            Remarks_for_Lead_Status__c = 'Initial lead creation',
            Existing_Account__c = newAccount.Id
        );
        insert leadQuoteNew;
        */
        
        // MODIFIED - Create Lead for existing Account - No Requirement__c needed.
        // Added First_Name__c/Last_Name__c: the existing-account conversion path
        // now inserts a Contact using these fields, and Contact.LastName is a
        // required standard field, so this Lead must supply one.
        Lead__c leadExisting = new Lead__c(
            Lead_Name__c = 'Test Company Existing',
            Company__c = 'Test Company Existing',
            Phone__c = '9899123460',
            Mobile__c = '9899123470',
            Email__c = 'testexisting@example.com',
            Lead_Status__c = 'Open',
            New_OEM__c = 'Bajaj Auto',
            /* COMMENTED OUT - Not using Requirement__c anymore
            Requirement__c = 'Sample',
            */
            First_Name__c = 'Priya',
            Last_Name__c = 'Existing',
            Title__c = 'Ms.',
            Designation__c = 'Procurement Head',
            Existing_Account__c = existingAcc.Id,
            Is_Converted__c = false,
            Address1__c = '321 Elm St',
            City__c = 'Chennai',
            State__c = 'Tamil Nadu',
            Country__c = 'India',
            Zip_Postal_Code__c = '600001',
            Dealer_Assigned__c = 'Jai Balaji-Coimbatore',
            Remarks_for_Lead_Status__c = 'Initial lead creation'
        );
        insert leadExisting;
        
        /* COMMENTED OUT - Not creating separate Quote existing lead
        Lead__c leadQuoteExisting = new Lead__c(
            Lead_Name__c = 'Quote Company Existing',
            Company__c = 'Quote Company Existing',
            Phone__c = '9899123461',
            Mobile__c = '9899123471',
            Email__c = 'quoteexisting@example.com',
            Lead_Status__c = 'Open',
            New_OEM__c = 'Bajaj Auto',
            Requirement__c = 'Quotation',
            Existing_Account__c = existingAcc.Id,
            Is_Converted__c = false,
            Address1__c = '654 Maple Dr',
            City__c = 'Chennai',
            State__c = 'Tamil Nadu',
            Country__c = 'India',
            Zip_Postal_Code__c = '411001',
            Dealer_Assigned__c = 'Jai Balaji-Coimbatore',
            Remarks_for_Lead_Status__c = 'Initial lead creation'
        );
        insert leadQuoteExisting;
        */
        
        // Create an already converted lead for testing
        Lead__c leadConverted = new Lead__c(
            Lead_Name__c = 'Already Converted',
            Company__c = 'Already Converted',
            Phone__c = '9899123462',
            Mobile__c = '9899123472',
            Email__c = 'converted@example.com',
            Lead_Status__c = 'Intro Sent',
            /* COMMENTED OUT - Not using Requirement__c anymore
            Requirement__c = 'Sample',
            */
            Is_Converted__c = true,
            Dealer_Assigned__c = 'Jai Balaji-Coimbatore',
            Address1__c = '100 Test St',
            City__c = 'Chennai',
            State__c = 'Tamil Nadu',
            Country__c = 'India',
            Zip_Postal_Code__c = '400001',
            Remarks_for_Lead_Status__c = 'Already converted lead',
            Existing_Account__c = existingAcc.Id
        );
        insert leadConverted;
    }

    @isTest
    static void testGetLeadData_Success() {
        Lead__c lead = [SELECT Id FROM Lead__c WHERE Company__c = 'Test Company New' LIMIT 1];
        
        Test.startTest();
        Lead__c result = LeadConvertCls.getLeadData(lead.Id);
        Test.stopTest();
        
        System.assertNotEquals(null, result, 'Lead should be returned');
        System.assertEquals('Test Company New', result.Company__c, 'Company name should match');
        System.assertEquals(false, result.Is_Converted__c, 'Lead should not be converted');
        System.assertEquals(true, result.IsNew_Account__c, 'IsNew_Account__c should be true');
    }
    
    @isTest
    static void testGetLeadData_AlreadyConverted() {
        Lead__c lead = [SELECT Id FROM Lead__c WHERE Company__c = 'Already Converted' LIMIT 1];
        
        Test.startTest();
        Boolean exceptionThrown = false;
        String exceptionMessage = '';
        try {
            Lead__c result = LeadConvertCls.getLeadData(lead.Id);
        } catch (AuraHandledException e) {
            exceptionThrown = true;
            exceptionMessage = e.getMessage();
        }
        Test.stopTest();
        
        System.assert(exceptionThrown, 'Exception should have been thrown');
    }

    @isTest
    static void testGetAccount() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Existing Test Account' LIMIT 1];
        Lead__c lead = [SELECT Id FROM Lead__c WHERE Company__c = 'Test Company New' LIMIT 1];
        
        Test.startTest();
        Account result = LeadConvertCls.getAccount(acc.Id, lead.Id);
        Test.stopTest();
        
        System.assertNotEquals(null, result, 'Account should be returned');
        System.assertEquals('Existing Test Account', result.Name, 'Account name should match');
    }

    @isTest
    static void testGetContact() {
        Contact con = [SELECT Id FROM Contact LIMIT 1];
        
        Test.startTest();
        Contact result = LeadConvertCls.getContact(con.Id);
        Test.stopTest();
        
        System.assertNotEquals(null, result, 'Contact should be returned');
        System.assertNotEquals(null, result.FirstName, 'Contact first name should not be null');
    }

    /* COMMENTED OUT - Not creating Sample Requests anymore
    @isTest
    static void testGetSampleRequest() {
        Lead__c lead = [SELECT Id FROM Lead__c WHERE Company__c = 'Sample Company New' LIMIT 1];
        
        Test.startTest();
        LeadConvertCls.ConversionResult convResult = LeadConvertCls.convertLead(
            'Test Account Sample',
            'John Doe',
            lead.Id
        );
        Test.stopTest();
        
        if (convResult.errorMessage != null) {
            System.debug('Conversion error: ' + convResult.errorMessage);
        }
        
        System.assertNotEquals(null, convResult.sampleRequestId, 
                              'Sample Request ID should be returned. Error: ' + convResult.errorMessage);
        
        Sample_Request__c result = LeadConvertCls.getSampleRequest(convResult.sampleRequestId);
        
        System.assertNotEquals(null, result, 'Sample Request should be returned');
        System.assertNotEquals(null, result.Account__c, 'Sample Request should have an Account');
        System.assertEquals(lead.Id, result.LeadName__c, 'Sample Request should be linked to Lead');
    }
    */

    /* COMMENTED OUT - Not creating Quotes anymore
    @isTest
    static void testGetQuote() {
        Lead__c lead = [SELECT Id FROM Lead__c WHERE Company__c = 'Quote Company New' LIMIT 1];
        
        Test.startTest();
        LeadConvertCls.ConversionResult convResult = LeadConvertCls.convertLead(
            'Test Account Quote',
            'Jane Smith',
            lead.Id
        );
        Test.stopTest();
        
        if (convResult.errorMessage != null) {
            System.debug('Conversion error: ' + convResult.errorMessage);
        }
        
        System.assertNotEquals(null, convResult.quoteId, 
                              'Quote ID should be returned. Error: ' + convResult.errorMessage);
        
        Quote__c result = LeadConvertCls.getQuote(convResult.quoteId);
        
        System.assertNotEquals(null, result, 'Quote should be returned');
        System.assertNotEquals(null, result.Account_Name__c, 'Quote should have an Account');
    }
    */

    @isTest
    static void testConvertLead_NewAccount() {
        Lead__c lead = [SELECT Id, IsNew_Account__c FROM Lead__c WHERE Company__c = 'Test Company New' LIMIT 1];
        System.assertEquals(true, lead.IsNew_Account__c, 'IsNew_Account__c should be true for setup');
        
        Test.startTest();
        LeadConvertCls.ConversionResult result = LeadConvertCls.convertLead(
            'Converted Test Account',
            'John Doe',
            lead.Id
        );
        Test.stopTest();
        
        System.assertEquals(null, result.errorMessage, 'Should not have error message: ' + result.errorMessage);
        System.assertNotEquals(null, result.accountId, 'Account should be created');
        System.assertNotEquals(null, result.contactId, 'Contact should be created');
        
        /* COMMENTED OUT - Not creating Quote/Sample anymore
        System.assertNotEquals(null, result.sampleRequestId, 'Sample Request should be created');
        System.assertEquals(null, result.quoteId, 'Quote should not be created');
        System.assertEquals('Sample', result.requirementType, 'Requirement type should be Sample');
        */
        
        System.assertEquals(true, result.isNewAccount, 'Should be new account');
        
        // Verify Lead is marked as converted
        Lead__c updatedLead = [SELECT Is_Converted__c, Lead_Status__c 
                               FROM Lead__c WHERE Id = :lead.Id];
        System.assertEquals(true, updatedLead.Is_Converted__c, 'Lead should be marked as converted');
        
        /* COMMENTED OUT - Not updating Lead Status to "Converted to Sample/Quote" anymore
        System.assertEquals('Converted to Sample', updatedLead.Lead_Status__c, 'Lead status should be Converted to Sample');
        System.assertEquals(System.today(), updatedLead.Last_Status_Change_Date__c, 'Status change date should be today');
        */
        
        /* COMMENTED OUT - Not assigning pricebook anymore
        Account acc = [SELECT Applicable_Pricebook__c FROM Account WHERE Id = :result.accountId];
        System.assertNotEquals(null, acc.Applicable_Pricebook__c, 'Account should have pricebook assigned');
        */
        
        // Verify address mapping on Account
        System.assertEquals('456 Oak Ave', result.accountData.Billing_Address__c, 'Account billing address should match lead');
        System.assertEquals('Chennai', result.accountData.Billing_City__c, 'Account billing city should match lead');
        
        /* COMMENTED OUT - Not creating Sample Request anymore
        System.assertEquals('456 Oak Ave', result.sampleRequestData.Sample_Address__c, 'Sample address should match lead');
        System.assertEquals('Chennai', result.sampleRequestData.Sample_City__c, 'Sample city should match lead');
        */
    }

    /* COMMENTED OUT - Not testing Quote conversion separately anymore
    @isTest
    static void testConvertLead_NewAccount_Quote() {
        Lead__c lead = [SELECT Id, IsNew_Account__c FROM Lead__c WHERE Company__c = 'Quote Company New' LIMIT 1];
        System.assertEquals(true, lead.IsNew_Account__c, 'IsNew_Account__c should be true for setup');
        
        Test.startTest();
        LeadConvertCls.ConversionResult result = LeadConvertCls.convertLead(
            'Converted Quote Account',
            'Jane Smith',
            lead.Id
        );
        Test.stopTest();
        
        System.assertEquals(null, result.errorMessage, 'Should not have error message: ' + result.errorMessage);
        System.assertNotEquals(null, result.accountId, 'Account should be created');
        System.assertNotEquals(null, result.contactId, 'Contact should be created');
        System.assertEquals(null, result.sampleRequestId, 'Sample Request should not be created');
        System.assertNotEquals(null, result.quoteId, 'Quote should be created');
        System.assertEquals('Quotation', result.requirementType, 'Requirement type should be Quotation');
        System.assertEquals(true, result.isNewAccount, 'Should be new account');
        
        Lead__c updatedLead = [SELECT Is_Converted__c, Lead_Status__c, Last_Status_Change_Date__c 
                               FROM Lead__c WHERE Id = :lead.Id];
        System.assertEquals(true, updatedLead.Is_Converted__c, 'Lead should be marked as converted');
        System.assertEquals('Converted to Quote', updatedLead.Lead_Status__c, 'Lead status should be Converted to Quote');
        System.assertEquals(System.today(), updatedLead.Last_Status_Change_Date__c, 'Status change date should be today');
        
        System.assertEquals('789 Pine Rd', result.quoteData.Quote_Address__c, 'Quote address should match lead');
        System.assertEquals('Chennai', result.quoteData.Quote_City__c, 'Quote city should match lead');
    }
    */

    @isTest
    static void testConvertLead_ExistingAccount() {
        Lead__c lead = [SELECT Id, Existing_Account__c, IsNew_Account__c 
                        FROM Lead__c WHERE Company__c = 'Test Company Existing' LIMIT 1];
        System.assertEquals(false, lead.IsNew_Account__c, 'IsNew_Account__c should be false for existing account');
        
        Test.startTest();
        LeadConvertCls.ConversionResult result = LeadConvertCls.convertLead(
            null,
            null,
            lead.Id
        );
        Test.stopTest();
        
        System.assertEquals(null, result.errorMessage, 'Should not have error message: ' + result.errorMessage);
        System.assertEquals(lead.Existing_Account__c, result.accountId, 'Should use existing account');

        // MODIFIED - Conversion now creates a Contact against the existing
        // Account too (previously asserted contactId should be null).
        System.assertNotEquals(null, result.contactId, 'Contact should be created against the existing account');
        System.assertNotEquals(null, result.contactData, 'contactData should be populated');
        System.assertEquals(result.accountId, result.contactData.AccountId, 
                            'New Contact should be linked to the existing Account');
        System.assertEquals('Priya', result.contactData.FirstName, 'Contact FirstName should come from the Lead');
        System.assertEquals('Existing', result.contactData.LastName, 'Contact LastName should come from the Lead');
        
        System.assertEquals(false, result.isNewAccount, 'Should not be new account');
    }

    /* COMMENTED OUT - Not testing existing account with Quote
    @isTest
    static void testConvertLead_ExistingAccount_Quote() {
        Lead__c lead = [SELECT Id, Existing_Account__c, IsNew_Account__c 
                        FROM Lead__c WHERE Company__c = 'Quote Company Existing' LIMIT 1];
        System.assertEquals(false, lead.IsNew_Account__c, 'IsNew_Account__c should be false for existing account');
        
        Test.startTest();
        LeadConvertCls.ConversionResult result = LeadConvertCls.convertLead(
            null,
            null,
            lead.Id
        );
        Test.stopTest();
        
        System.assertEquals(null, result.errorMessage, 'Should not have error message: ' + result.errorMessage);
        System.assertEquals(lead.Existing_Account__c, result.accountId, 'Should use existing account');
        System.assertEquals(null, result.contactId, 'Contact should not be created');
        System.assertNotEquals(null, result.quoteId, 'Quote should be created');
        System.assertEquals('Quotation', result.requirementType, 'Requirement type should be Quotation');
        System.assertEquals(false, result.isNewAccount, 'Should not be new account');
        
        System.assertEquals('654 Maple Dr', result.quoteData.Quote_Address__c, 'Quote address should use lead address');
    }
    */

    @isTest
    static void testConvertLead_AlreadyConverted() {
        Lead__c lead = [SELECT Id FROM Lead__c WHERE Company__c = 'Already Converted' LIMIT 1];
        
        Test.startTest();
        LeadConvertCls.ConversionResult result = LeadConvertCls.convertLead(
            'Should Fail Account',
            'Should Fail Contact',
            lead.Id
        );
        Test.stopTest();
        
        System.assertNotEquals(null, result.errorMessage, 'Should have error message');
    }

    /* COMMENTED OUT - Not testing pricebook assignment anymore
    @isTest
    static void testConvertLead_ExistingAccountWithoutPricebook() {
        Account accNoPricebook = new Account(
            Name = 'No Pricebook Account',
            Type = 'Export',
            Phone = '8888888888',
            Email__c = 'nopricebook@example.com'
        );
        insert accNoPricebook;
        
        Lead__c leadNoPB = new Lead__c(
            Lead_Name__c = 'No Pricebook Lead',
            Company__c = 'No Pricebook Company',
            Phone__c = '9999999999',
            Email__c = 'nopb@example.com',
            Lead_Status__c = 'Open',
            Requirement__c = 'Sample',
            Existing_Account__c = accNoPricebook.Id,
            Is_Converted__c = false,
            Address1__c = 'Test Address',
            City__c = 'Chennai',
            State__c = 'Tamil Nadu',
            Country__c = 'India',
            Zip_Postal_Code__c = '123456',
            Dealer_Assigned__c = 'Jai Balaji-Coimbatore',
            New_OEM__c = 'Bajaj Auto',
            Remarks_for_Lead_Status__c = 'Test'
        );
        insert leadNoPB;
        
        Test.startTest();
        LeadConvertCls.ConversionResult result = LeadConvertCls.convertLead(null, null, leadNoPB.Id);
        Test.stopTest();
        
        System.assertEquals(null, result.errorMessage, 'Should not have error');
        
        Account updatedAcc = [SELECT Applicable_Pricebook__c FROM Account WHERE Id = :accNoPricebook.Id];
        System.assertNotEquals(null, updatedAcc.Applicable_Pricebook__c, 'Pricebook should be assigned to existing account');
    }
    */

    @isTest
    static void testConvertLead_NoType() {
        Account newAcc2 = [SELECT Id FROM Account WHERE Name = 'NEW' LIMIT 1];
        
        Lead__c leadNoType = new Lead__c(
            Lead_Name__c = 'No Type Lead',
            Company__c = 'No Type Company',
            Phone__c = '9899888888',
            Mobile__c = '9899888889',
            Email__c = 'notype@example.com',
            Lead_Status__c = 'Open',
            First_Name__c = 'Test',
            Last_Name__c = 'NoType',
            /* COMMENTED OUT - Not using Requirement__c
            Requirement__c = 'Sample',
            */
            Is_Converted__c = false,
            Address1__c = 'Test Address',
            City__c = 'Chennai',
            State__c = 'Tamil Nadu',
            Country__c = 'India',
            Zip_Postal_Code__c = '123456',
            Designation__c = 'Manager',
            Dealer_Assigned__c = 'Jai Balaji-Coimbatore',
            Remarks_for_Lead_Status__c = 'Initial lead creation',
            Existing_Account__c = newAcc2.Id,
            New_OEM__c = 'Bajaj Auto'
        );
        insert leadNoType;
        
        Test.startTest();
        LeadConvertCls.ConversionResult result = LeadConvertCls.convertLead(
            'Account No Type',
            'Contact No Type',
            leadNoType.Id
        );
        Test.stopTest();
        
        System.assertEquals(null, result.errorMessage, 'Should not have error message: ' + result.errorMessage);
        System.assertNotEquals(null, result.accountId, 'Account should be created');
        System.assertNotEquals(null, result.contactId, 'Contact should be created');
    }
    
    /* COMMENTED OUT - Not testing pricebook by type anymore
    @isTest
    static void testConvertLead_ExportType() {
        Account newAcc3 = [SELECT Id FROM Account WHERE Name = 'NEW' LIMIT 1];
        
        Lead__c leadExport = new Lead__c(
            Lead_Name__c = 'Export Lead',
            Company__c = 'Export Company',
            Phone__c = '9899777777',
            Mobile__c = '9899777778',
            Email__c = 'export@example.com',
            Lead_Status__c = 'Open',
            First_Name__c = 'Export',
            Last_Name__c = 'User',
            Type__c = 'Export',
            Requirement__c = 'Quotation',
            Is_Converted__c = false,
            Address1__c = 'Export Address',
            City__c = 'Chennai',
            State__c = 'Tamil Nadu',
            Country__c = 'India',
            Zip_Postal_Code__c = '400001',
            Designation__c = 'Director',
            Dealer_Assigned__c = 'Jai Balaji-Coimbatore',
            New_OEM__c = 'Bajaj Auto',
            Remarks_for_Lead_Status__c = 'Initial lead creation',
            Existing_Account__c = newAcc3.Id
        );
        insert leadExport;
        
        Test.startTest();
        LeadConvertCls.ConversionResult result = LeadConvertCls.convertLead(
            'Export Account',
            'Export Contact',
            leadExport.Id
        );
        Test.stopTest();
        
        System.assertEquals(null, result.errorMessage, 'Should not have error message: ' + result.errorMessage);
        
        Account acc = [SELECT Applicable_Pricebook__c, Applicable_Pricebook__r.Applicable_For__c 
                       FROM Account WHERE Id = :result.accountId];
        System.assertNotEquals(null, acc.Applicable_Pricebook__c, 'Account should have pricebook assigned');
        System.assertEquals('Export', acc.Applicable_Pricebook__r.Applicable_For__c, 'Should have Export pricebook');
    }
    */
    
    @isTest
    static void testConvertLead_GeneralException() {
        Test.startTest();
        LeadConvertCls.ConversionResult result = LeadConvertCls.convertLead(
            'Bad Account',
            'Bad Contact',
            null
        );
        Test.stopTest();
        
        System.assertNotEquals(null, result.errorMessage, 'Should have error message');
    }
    
    @isTest
    static void testConvertLead_AddressMapping() {
        Account newAcc4 = [SELECT Id FROM Account WHERE Name = 'NEW' LIMIT 1];
        
        Lead__c leadAddress = new Lead__c(
            Lead_Name__c = 'Address Test Lead',
            Company__c = 'Address Test Company',
            Phone__c = '9899555555',
            Mobile__c = '9899555556',
            Email__c = 'address@example.com',
            Lead_Status__c = 'Open',
            First_Name__c = 'Address',
            Last_Name__c = 'Test',
            Type__c = 'Local WB',
            /* COMMENTED OUT - Not using Requirement__c
            Requirement__c = 'Sample',
            */
            Is_Converted__c = false,
            Address1__c = '123 Specific Street',
            City__c = 'Chennai',
            State__c = 'Tamil Nadu',
            Country__c = 'India',
            Zip_Postal_Code__c = '700001',
            Designation__c = 'Manager',
            Dealer_Assigned__c = 'Jai Balaji-Coimbatore',
            New_OEM__c = 'Bajaj Auto',
            Remarks_for_Lead_Status__c = 'Initial lead creation',
            Existing_Account__c = newAcc4.Id
        );
        insert leadAddress;
        
        Test.startTest();
        LeadConvertCls.ConversionResult result = LeadConvertCls.convertLead(
            'Address Test Account',
            'Address Test Contact',
            leadAddress.Id
        );
        Test.stopTest();
        
        System.assertEquals(null, result.errorMessage, 'Should not have error message: ' + result.errorMessage);
        
        // Verify address mapping on new account
        System.assertEquals('123 Specific Street', result.accountData.Billing_Address__c, 'Billing address should match');
        System.assertEquals('Chennai', result.accountData.Billing_City__c, 'Billing city should match');
        System.assertEquals('Tamil Nadu', result.accountData.Billing_State__c, 'Billing state should match');
        
        /* COMMENTED OUT - Not creating Sample Request anymore
        System.assertEquals('123 Specific Street', result.sampleRequestData.Sample_Address__c, 'Sample address should match');
        System.assertEquals('Chennai', result.sampleRequestData.Sample_City__c, 'Sample city should match');
        System.assertEquals('Tamil Nadu', result.sampleRequestData.Sample_State__c, 'Sample state should match');
        */
        
        // Verify shipping address mapping
        System.assertEquals('123 Specific Street', result.accountData.Shipping_Address__c, 'Shipping address should match');
        System.assertEquals('Chennai', result.accountData.Shipping_City__c, 'Shipping city should match');
    }
    
    @isTest
    static void testConvertLead_MissingExistingAccount() {
        Account regularAcc = new Account(
            Name = 'Regular Account',
            Phone = '7777777777',
            Email__c = 'regular@example.com',
            Status__c = 'Approved'
        );
        insert regularAcc;
        
        Lead__c leadNoExisting = new Lead__c(
            Lead_Name__c = 'No Existing Account Lead',
            Company__c = 'No Existing Account Company',
            Phone__c = '9899444444',
            Email__c = 'noexisting@example.com',
            Lead_Status__c = 'Open',
            /* COMMENTED OUT - Not using Requirement__c
            Requirement__c = 'Sample',
            */
            Is_Converted__c = false,
            Address1__c = 'Test Address',
            City__c = 'Chennai',
            State__c = 'Tamil Nadu',
            Country__c = 'India',
            Zip_Postal_Code__c = '123456',
            Dealer_Assigned__c = 'Jai Balaji-Coimbatore',
            Remarks_for_Lead_Status__c = 'Test',
            Existing_Account__c = regularAcc.Id
        );
        insert leadNoExisting;
        
        leadNoExisting.Existing_Account__c = null;
        update leadNoExisting;
        
        Test.startTest();
        LeadConvertCls.ConversionResult result = LeadConvertCls.convertLead(null, null, leadNoExisting.Id);
        Test.stopTest();
        
        System.assertNotEquals(null, result.errorMessage, 'Should have error message');
    }
    
    @isTest
    static void testConversionResult_DataVerification() {
        Lead__c lead = [SELECT Id FROM Lead__c WHERE Company__c = 'Test Company New' LIMIT 1];
        
        Test.startTest();
        LeadConvertCls.ConversionResult result = LeadConvertCls.convertLead(
            'Verification Account',
            'Verification Contact',
            lead.Id
        );
        Test.stopTest();
        
        if (result.errorMessage != null) {
            System.debug('Conversion error: ' + result.errorMessage);
        }
        
        // Verify all result fields are populated correctly
        System.assertNotEquals(null, result.accountId, 'accountId should be populated. Error: ' + result.errorMessage);
        System.assertNotEquals(null, result.contactId, 'contactId should be populated');
        
        /* COMMENTED OUT - Not creating Quote/Sample anymore
        System.assertNotEquals(null, result.sampleRequestId, 'sampleRequestId should be populated');
        System.assertEquals(null, result.quoteId, 'quoteId should be null for Sample');
        System.assertEquals('Sample', result.requirementType, 'requirementType should be Sample');
        System.assertNotEquals(null, result.sampleRequestData, 'sampleRequestData should be populated');
        System.assertEquals(null, result.quoteData, 'quoteData should be null');
        */
        
        System.assertEquals(null, result.errorMessage, 'errorMessage should be null');
        System.assertEquals(true, result.isNewAccount, 'isNewAccount should be true');
        System.assertNotEquals(null, result.accountData, 'accountData should be populated');
        System.assertNotEquals(null, result.contactData, 'contactData should be populated');
        System.assertNotEquals(null, result.ownerName, 'ownerName should be populated');
        
        // Verify accountData fields
        System.assertNotEquals(null, result.accountData.Name, 'Account Name should be populated');
        System.assertNotEquals(null, result.accountData.Phone, 'Account Phone should be populated');
        System.assertNotEquals(null, result.accountData.Email__c, 'Account Email should be populated');
        
        // Verify contactData fields
        System.assertNotEquals(null, result.contactData.Name, 'Contact Name should be populated');
        System.assertNotEquals(null, result.contactData.Email, 'Contact Email should be populated');
        
        /* COMMENTED OUT - Not creating Sample Request anymore
        System.assertNotEquals(null, result.sampleRequestData.Name, 'Sample Request Name should be populated');
        System.assertNotEquals(null, result.sampleRequestData.Account__c, 'Sample Request Account should be populated');
        System.assertEquals(lead.Id, result.sampleRequestData.LeadName__c, 'Sample Request should link to Lead');
        */
    }
    
    /* COMMENTED OUT - Not testing Quote address mapping anymore
    @isTest
    static void testConvertLead_QuoteAddressMapping() {
        Lead__c lead = [SELECT Id FROM Lead__c WHERE Company__c = 'Quote Company New' LIMIT 1];
        
        Test.startTest();
        LeadConvertCls.ConversionResult result = LeadConvertCls.convertLead(
            'Quote Address Account',
            'Quote Address Contact',
            lead.Id
        );
        Test.stopTest();
        
        System.assertEquals(null, result.errorMessage, 'Should not have error: ' + result.errorMessage);
        
        System.assertEquals('789 Pine Rd', result.quoteData.Quote_Address__c, 'Quote address should match');
        System.assertEquals('Chennai', result.quoteData.Quote_City__c, 'Quote city should match');
        System.assertEquals('Tamil Nadu', result.quoteData.Quote_State__c, 'Quote state should match');
        System.assertEquals('India', result.quoteData.Quote_Country__c, 'Quote country should match');
        System.assertEquals('560001', result.quoteData.Quote_Zip_Postal_Code__c, 'Quote zip should match');
        
        System.assertEquals('789 Pine Rd', result.quoteData.Billing_Address__c, 'Billing address should match');
        System.assertEquals('Chennai', result.quoteData.Billing_City__c, 'Billing city should match');
        
        System.assertEquals('789 Pine Rd', result.quoteData.Shipping_Address__c, 'Shipping address should match');
        System.assertEquals('Chennai', result.quoteData.Shipping_City__c, 'Shipping city should match');
    }
    */
    
    /* COMMENTED OUT - Not testing Sample address mapping anymore
    @isTest
    static void testConvertLead_SampleAddressMapping() {
        Lead__c lead = [SELECT Id FROM Lead__c WHERE Company__c = 'Sample Company New' LIMIT 1];
        
        Test.startTest();
        LeadConvertCls.ConversionResult result = LeadConvertCls.convertLead(
            'Sample Address Account',
            'Sample Address Contact',
            lead.Id
        );
        Test.stopTest();
        
        System.assertEquals(null, result.errorMessage, 'Should not have error: ' + result.errorMessage);
        
        System.assertEquals('456 Oak Ave', result.sampleRequestData.Sample_Address__c, 'Sample address should match');
        System.assertEquals('Chennai', result.sampleRequestData.Sample_City__c, 'Sample city should match');
        System.assertEquals('Tamil Nadu', result.sampleRequestData.Sample_State__c, 'Sample state should match');
        System.assertEquals('India', result.sampleRequestData.Sample_Country__c, 'Sample country should match');
        System.assertEquals('110001', result.sampleRequestData.Sample_Zip_Postal_Code__c, 'Sample zip should match');
        
        System.assertEquals('456 Oak Ave', result.sampleRequestData.Billing_Address__c, 'Billing address should match');
        System.assertEquals('Chennai', result.sampleRequestData.Billing_City__c, 'Billing city should match');
        
        System.assertEquals('456 Oak Ave', result.sampleRequestData.Shipping_Address__c, 'Shipping address should match');
        System.assertEquals('Chennai', result.sampleRequestData.Shippin__c, 'Shipping city should match');
    }
    */
    
    /* COMMENTED OUT - Not testing pricebook logic anymore
    @isTest
    static void testGetApplicablePricebook_InvalidType() {
        Account newAcc5 = [SELECT Id FROM Account WHERE Name = 'NEW' LIMIT 1];
        
        Lead__c leadInvalidType = new Lead__c(
            Lead_Name__c = 'Invalid Type Lead',
            Company__c = 'Invalid Type Company',
            Phone__c = '9899333333',
            Email__c = 'invalidtype@example.com',
            Lead_Status__c = 'Open',
            First_Name__c = 'Invalid',
            Last_Name__c = 'Type',
            Requirement__c = 'Sample',
            Is_Converted__c = false,
            Address1__c = 'Test Address',
            City__c = 'Chennai',
            State__c = 'Tamil Nadu',
            Country__c = 'India',
            Zip_Postal_Code__c = '123456',
            Designation__c = 'Manager',
            Dealer_Assigned__c = 'Jai Balaji-Coimbatore',
            Remarks_for_Lead_Status__c = 'Test',
            Existing_Account__c = newAcc5.Id,
            New_OEM__c = 'Bajaj Auto'
        );
        insert leadInvalidType;
        
        Test.startTest();
        LeadConvertCls.ConversionResult result = LeadConvertCls.convertLead(
            'Invalid Type Account',
            'Invalid Type Contact',
            leadInvalidType.Id
        );
        Test.stopTest();
        
        System.assertEquals(null, result.errorMessage, 'Should not error even with invalid type: ' + result.errorMessage);
        
        Account acc = [SELECT Applicable_Pricebook__c FROM Account WHERE Id = :result.accountId];
        System.assertEquals(null, acc.Applicable_Pricebook__c, 'No pricebook should be assigned for invalid type');
    }
    */
    
    @isTest
    static void testConvertLead_LeadFieldMapping() {
        Lead__c lead = [SELECT Id FROM Lead__c WHERE Company__c = 'Test Company New' LIMIT 1];
        
        Test.startTest();
        LeadConvertCls.ConversionResult result = LeadConvertCls.convertLead(
            'Field Mapping Account',
            'Field Mapping Contact',
            lead.Id
        );
        Test.stopTest();
        
        System.assertEquals(null, result.errorMessage, 'Should not have error: ' + result.errorMessage);
        
        // Verify specific field mappings from Lead to Account
        Account acc = result.accountData;
        System.assertEquals('Website', acc.Lead_Source__c, 'Lead_Source__c should be mapped');
        System.assertEquals('Product Inquiry', acc.Lead_Subject__c, 'Lead_Subject__c should be mapped');
        System.assertEquals('Test note', acc.Latest_Note__c, 'Latest_Note__c should be mapped');
        System.assertEquals(System.today(), acc.Note_Date__c, 'Note_Date__c should be mapped');
        //System.assertEquals('Trading', acc.Industry__c, 'Industry should be mapped');
        //System.assertEquals('Trader', acc.Industry_Type__c, 'Industry_Type__c should be mapped');
        System.assertEquals('Bajaj Auto', acc.New_OEM__c, 'New_OEM__c should be mapped');
        System.assertEquals('Local WB', acc.Type, 'Type should be mapped');
        System.assertEquals('B2C', acc.Customer_Classification__c, 'Customer_Classification__c should be mapped');
        
        // Verify Contact field mapping
        Contact con = result.contactData;
        System.assertEquals('Mr.', con.Salutation, 'Salutation should be mapped');
        System.assertEquals('John', con.FirstName, 'FirstName should be mapped');
        System.assertEquals('Doe', con.LastName, 'LastName should be mapped');
        System.assertEquals('Director', con.Title, 'Title should be mapped from Designation__c');
    }
    
    /* COMMENTED OUT - Not testing pricebook assignment anymore
    @isTest
    static void testConvertLead_PricebookAssignment() {
        Lead__c lead = [SELECT Id FROM Lead__c WHERE Company__c = 'Sample Company New' LIMIT 1];
        
        Test.startTest();
        LeadConvertCls.ConversionResult result = LeadConvertCls.convertLead(
            'Pricebook Account',
            'Pricebook Contact',
            lead.Id
        );
        Test.stopTest();
        
        System.assertEquals(null, result.errorMessage, 'Should not have error: ' + result.errorMessage);
        
        System.assertNotEquals(null, result.sampleRequestData.Applicable_Pricebook__c, 
                               'Sample Request should have pricebook assigned');
        
        Pricebook2__c pb = [SELECT Name FROM Pricebook2__c 
                            WHERE Id = :result.sampleRequestData.Applicable_Pricebook__c LIMIT 1];
        System.assertNotEquals(null, pb, 'Pricebook should exist');
    }
    */
    
    /* COMMENTED OUT - Not testing OEM mapping to Sample Request anymore (only Account)
    @isTest
    static void testConvertLead_OEMMapping() {
        Lead__c lead = [SELECT Id FROM Lead__c WHERE Company__c = 'Sample Company New' LIMIT 1];
        
        Test.startTest();
        LeadConvertCls.ConversionResult result = LeadConvertCls.convertLead(
            'OEM Test Account',
            'OEM Test Contact',
            lead.Id
        );
        Test.stopTest();
        
        System.assertEquals(null, result.errorMessage, 'Should not have error: ' + result.errorMessage);
        
        System.assertEquals('Bajaj Auto', result.sampleRequestData.OEM__c, 'OEM should be mapped to Sample Request');
        
        System.assertEquals('Bajaj Auto', result.accountData.New_OEM__c, 'New_OEM should be mapped to Account');
    }
    */
    
    @isTest
    static void testConvertLead_ContactFields() {
        Lead__c lead = [SELECT Id FROM Lead__c WHERE Company__c = 'Test Company New' LIMIT 1];
        
        Test.startTest();
        LeadConvertCls.ConversionResult result = LeadConvertCls.convertLead(
            'Contact Test Account',
            'Contact Test Name',
            lead.Id
        );
        Test.stopTest();
        
        System.assertEquals(null, result.errorMessage, 'Should not have error: ' + result.errorMessage);
        
        // Verify Contact fields are properly populated
        Contact con = result.contactData;
        System.assertNotEquals(null, con.AccountId, 'Contact should be linked to Account');
        System.assertEquals(result.accountId, con.AccountId, 'Contact AccountId should match created Account');
        System.assertNotEquals(null, con.Email, 'Contact Email should be populated');
        System.assertNotEquals(null, con.Phone, 'Contact Phone should be populated');
    }

    // NEW - Mirrors testConvertLead_ContactFields above, but for the
    // existing-account path, to lock in the new Contact-creation behavior.
    @isTest
    static void testConvertLead_ExistingAccount_ContactFields() {
        Lead__c lead = [SELECT Id, Existing_Account__c 
                        FROM Lead__c WHERE Company__c = 'Test Company Existing' LIMIT 1];
        
        Test.startTest();
        LeadConvertCls.ConversionResult result = LeadConvertCls.convertLead(
            null,
            null,
            lead.Id
        );
        Test.stopTest();
        
        System.assertEquals(null, result.errorMessage, 'Should not have error: ' + result.errorMessage);
        
        Contact con = result.contactData;
        System.assertNotEquals(null, con, 'Contact should be created for the existing-account path');
        System.assertEquals(lead.Existing_Account__c, con.AccountId, 'Contact should be linked to the existing Account');
        System.assertEquals('Priya', con.FirstName, 'FirstName should be mapped from the Lead');
        System.assertEquals('Existing', con.LastName, 'LastName should be mapped from the Lead');
        System.assertEquals('Ms.', con.Salutation, 'Salutation should be mapped from the Lead');
        System.assertEquals('Procurement Head', con.Title, 'Title should be mapped from Designation__c');
    }
    
    /* COMMENTED OUT - Not testing status updates to "Converted to Sample/Quote" anymore
    @isTest
    static void testConvertLead_StatusUpdates() {
        Lead__c leadSample = [SELECT Id FROM Lead__c WHERE Company__c = 'Sample Company New' LIMIT 1];
        Lead__c leadQuote = [SELECT Id FROM Lead__c WHERE Company__c = 'Quote Company New' LIMIT 1];
        
        Test.startTest();
        LeadConvertCls.ConversionResult resultSample = LeadConvertCls.convertLead(
            'Status Test Account Sample',
            'Status Test Contact',
            leadSample.Id
        );
        
        LeadConvertCls.ConversionResult resultQuote = LeadConvertCls.convertLead(
            'Status Test Account Quote',
            'Status Test Contact',
            leadQuote.Id
        );
        Test.stopTest();
        
        Lead__c updatedLeadSample = [SELECT Lead_Status__c, Is_Converted__c 
                                     FROM Lead__c WHERE Id = :leadSample.Id];
        System.assertEquals('Converted to Sample', updatedLeadSample.Lead_Status__c, 'Sample lead status should be updated');
        System.assertEquals(true, updatedLeadSample.Is_Converted__c, 'Sample lead should be marked converted');
        
        Lead__c updatedLeadQuote = [SELECT Lead_Status__c, Is_Converted__c 
                                    FROM Lead__c WHERE Id = :leadQuote.Id];
        System.assertEquals('Converted to Quote', updatedLeadQuote.Lead_Status__c, 'Quote lead status should be updated');
        System.assertEquals(true, updatedLeadQuote.Is_Converted__c, 'Quote lead should be marked converted');
    }
    */
    
    @isTest
    static void testConvertLead_BulkScenario() {
        Account newAcc = [SELECT Id FROM Account WHERE Name = 'NEW' LIMIT 1];
        
        List<Lead__c> leadsToInsert = new List<Lead__c>();
        for (Integer i = 0; i < 5; i++) {
            leadsToInsert.add(new Lead__c(
                Lead_Name__c = 'Bulk Lead ' + i,
                Company__c = 'Bulk Company ' + i,
                Phone__c = '989912300' + i,
                Email__c = 'bulk' + i + '@example.com',
                Lead_Status__c = 'Open',
                First_Name__c = 'Bulk',
                Last_Name__c = 'User' + i,
                Type__c = 'Local WB',
                /* COMMENTED OUT - Not using Requirement__c anymore
                Requirement__c = (Math.mod(i, 2) == 0 ? 'Sample' : 'Quotation'),
                */
                Is_Converted__c = false,
                Address1__c = 'Bulk Address ' + i,
                City__c = 'Chennai',
                State__c = 'Tamil Nadu',
                Country__c = 'India',
                Zip_Postal_Code__c = '60000' + i,
                Designation__c = 'Manager',
                Dealer_Assigned__c = 'Jai Balaji-Coimbatore',
                New_OEM__c = 'Bajaj Auto',
                Remarks_for_Lead_Status__c = 'Bulk test',
                Existing_Account__c = newAcc.Id
            ));
        }
        insert leadsToInsert;
        
        Test.startTest();
        List<LeadConvertCls.ConversionResult> results = new List<LeadConvertCls.ConversionResult>();
        // MODIFIED - Use a unique Account Name per iteration. The old code
        // passed the literal string 'Bulk Account' for every lead, which
        // creates 5 Accounts with the identical Name and trips the org's
        // Account duplicate-detection rule from the 2nd insert onward.
        for (Integer i = 0; i < leadsToInsert.size(); i++) {
            LeadConvertCls.ConversionResult result = LeadConvertCls.convertLead(
                'Bulk Account ' + i,
                'Bulk Contact ' + i,
                leadsToInsert[i].Id
            );
            results.add(result);
        }
        Test.stopTest();
        
        // Verify all conversions succeeded
        for (LeadConvertCls.ConversionResult result : results) {
            System.assertEquals(null, result.errorMessage, 'Bulk conversion should succeed: ' + result.errorMessage);
            System.assertNotEquals(null, result.accountId, 'Account should be created in bulk scenario');
        }
    }
}