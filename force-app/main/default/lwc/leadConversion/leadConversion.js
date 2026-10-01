import { LightningElement, api, track } from 'lwc';
import getLeadData from '@salesforce/apex/LeadConvertCls.getLeadData';
import convertLead from '@salesforce/apex/LeadConvertCls.convertLead';
import getAccount from '@salesforce/apex/LeadConvertCls.getAccount';
import getContact from '@salesforce/apex/LeadConvertCls.getContact';
// COMMENTED OUT - Sample/Quote methods not needed for now
// import getSampleRequest from '@salesforce/apex/LeadConvertCls.getSampleRequest';
// import getQuote from '@salesforce/apex/LeadConvertCls.getQuote';
import myResource from '@salesforce/resourceUrl/img';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { NavigationMixin } from 'lightning/navigation';

export default class LeadConversion extends NavigationMixin(LightningElement) {

    resourse = myResource;

    @api recordId;
    @track isConverted = false;
    @track salesPersonId;
    @track leadName;
    @track leadStatus;
    // COMMENTED OUT - Not creating Quote/Sample anymore
    // @track requirementType; // "Sample" or "Quotation"
    @track existingAccountId;
    @track isNewAccount = false;
    @track isConverting = false;
    @track isNewAccountCheckbox = false;
    @track companyName;

    // NEW - surfaces a failed initial load (e.g. Lead already converted)
    // instead of leaving the form silently blank/stuck.
    @track loadError;
    
    connectedCallback(){
        console.log('Record ID:', this.recordId);

        getLeadData({ recId: this.recordId })
            .then((result) => {
                this.leadName = result.Name;
                this.userId = result.OwnerId;
                this.companyName = result.Company__c;
                this.accName = result.Company__c;
                // COMMENTED OUT - Not using Requirement__c anymore
                // this.requirementType = result.Requirement__c;
                this.existingAccountId = result.Existing_Account__c;
                this.isNewAccountCheckbox = result.IsNew_Account__c || false;
                this.leadStatus = result.Lead_Status__c;
                
                if (result.First_Name__c && result.Last_Name__c) {
                    this.conName = result.First_Name__c + ' ' + result.Last_Name__c;
                } else if (result.Last_Name__c) {
                    this.conName = result.Last_Name__c;
                } else {
                    this.conName = result.Name;
                }
                
                // COMMENTED OUT - Not creating Quote/Sample anymore
                // if (this.requirementType === 'Sample') {
                //     this.recordName = result.Company__c + ' - Sample Request';
                // } else if (this.requirementType === 'Quotation') {
                //     this.recordName = result.Company__c + ' - Quote';
                // } else {
                //     this.recordName = result.Company__c;
                // }
                
                console.log('Lead Data:', JSON.stringify(result));
                console.log('Company__c:', result.Company__c);
                console.log('Account Name (from Company__c):', this.accName);
                // COMMENTED OUT - Not using these anymore
                // console.log('Requirement Type:', this.requirementType);
                console.log('Existing Account ID:', this.existingAccountId);
                console.log('Is New Account Checkbox:', this.isNewAccountCheckbox);
                console.log('Lead Status:', this.leadStatus);
            }).catch((err) => {
                console.error('Error loading lead data:', err);

                // NEW - Surface the failure instead of leaving the form
                // silently stuck on its blank pre-conversion state.
                let message = 'This lead may have already been converted.';
                if (err && err.body && err.body.message) {
                    message = err.body.message;
                } else if (err && err.message) {
                    message = err.message;
                }
                this.loadError = message;

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Unable to Load Lead',
                        message: message,
                        variant: 'error'
                    })
                );
            });
    }

    handleAcc(event) {
        this.accName = event.target.value;
        console.log('Account Name:', this.accName);
    }
    
    accName;
    conName;
    // COMMENTED OUT - Not using recordName anymore
    // recordName;
    
    handleCon(event) {
        this.conName = event.target.value;
        console.log('Contact Name:', this.conName);
    }

    onclickGO() {
        // MODIFIED - Always navigate to Account page after conversion
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.conversionResult.accountId,
                objectApiName: 'Account',
                actionName: 'view'
            }
        });
        
        /* COMMENTED OUT - Old Quote/Sample navigation logic
        if (this.isAssignedToDealer) {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.conversionResult.accountId,
                    objectApiName: 'Account',
                    actionName: 'view'
                }
            });
        } else {
            let objectApiName = this.requirementType === 'Sample' ? 'Sample_Request__c' : 'Quote__c';
            let recordId = this.requirementType === 'Sample' 
                ? this.conversionResult.sampleRequestId 
                : this.conversionResult.quoteId;
                
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: recordId,
                    objectApiName: objectApiName,
                    actionName: 'view'
                }
            });
        }
        */
    }
    
    openAccount = true;
    openAcc() {
        this.openAccount = !this.openAccount
    }
    
    openContact = true;
    openCon() {
        this.openContact = !this.openContact;
    }
    
    // COMMENTED OUT - Not using record section anymore
    // openRecord = true;
    // openRec() {
    //     this.openRecord = !this.openRecord;
    // }
    
    @track userId;
    @track conversionResult;
    converted = false;
    accountData = [];
    contactData = [];
    // COMMENTED OUT - Not using recordData anymore
    // recordData = [];
    owner;
    
    // COMMENTED OUT - Not using these getters anymore
    // get recordTypeLabel() {
    //     return this.requirementType === 'Sample' ? 'Sample Request' : 'Quote';
    // }
    
    // get recordFieldLabel() {
    //     return this.requirementType === 'Sample' ? 'Sample Request No.' : 'Quote No.';
    // }
    
    // get recordIcon() {
    //     return this.requirementType === 'Sample' ? 'standard:case' : 'standard:quote';
    // }
    
    get shouldShowAccountSection() {
        return this.isNewAccountCheckbox === true;
    }

    // NEW - Convert button should never be usable if the initial load failed
    // (e.g. because the lead is already converted), since accName/conName/etc.
    // never get populated in that case.
    get isConvertDisabled() {
        return this.isConverting || !!this.loadError;
    }
    
    // COMMENTED OUT - Not using this check anymore since we're not creating Quote/Sample
    // get isAssignedToDealer() {
    //     return this.leadStatus === 'Assigned to Dealer';
    // }
    
    // COMMENTED OUT - Not using recordNameDisplay anymore
    // get recordNameDisplay() {
    //     if (this.isConverting) {
    //         return 'Generating...';
    //     }
    //     return 'Auto-generated after conversion';
    // }
    
    handleClick() {
        console.log('Converting lead...');
        console.log('Account Name:', this.accName);
        console.log('Contact Name:', this.conName);
        // COMMENTED OUT - Not using these anymore
        // console.log('Record Name:', this.recordName);
        // console.log('Requirement Type:', this.requirementType);
        console.log('Is New Account:', this.isNewAccountCheckbox);
        console.log('Existing Account:', this.existingAccountId);
        console.log('Lead Status:', this.leadStatus);

        // NEW - Guard against submitting when the initial load never
        // succeeded (loadError set) - avoids converting with blank/stale data.
        if (this.loadError) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Cannot Convert',
                    message: this.loadError,
                    variant: 'error'
                })
            );
            return;
        }
        
        if (this.isNewAccountCheckbox) {
            if (!this.accName || this.accName.trim() === '') {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Account Name is required when creating a new account.',
                        variant: 'error'
                    })
                );
                return;
            }
            if (!this.conName || this.conName.trim() === '') {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Contact Name is required when creating a new account.',
                        variant: 'error'
                    })
                );
                return;
            }
        } else {
            if (!this.existingAccountId) {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'An Existing Account must be selected on the Lead record.',
                        variant: 'error'
                    })
                );
                return;
            }
        }
        
        this.isConverting = true;
        
        convertLead({ 
            accName: this.accName, 
            conName: this.conName,
            leadId: this.recordId
        })
        .then(result => {
            console.log('Conversion successful:', JSON.stringify(result));
            
            if (result.errorMessage) {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Conversion Error',
                        message: result.errorMessage,
                        variant: 'error'
                    })
                );
                this.isConverting = false;
                return;
            }
            
            this.conversionResult = result;
            this.isConverted = true;
            this.converted = true;
            this.isNewAccount = result.isNewAccount;
            this.isConverting = false;
            
            if (result.accountData) {
                this.accountData = result.accountData;
                this.owner = result.ownerName;
                console.log('Account Data Set:', this.accountData.Name, this.accountData.Phone, this.accountData.Email__c);
            }
            
            if (result.contactData) {
                this.contactData = result.contactData;
                console.log('Contact Data Set:', this.contactData.Name, this.contactData.Phone, this.contactData.Email);
            }
            
            // COMMENTED OUT - Not creating Quote/Sample anymore
            // if (!this.isAssignedToDealer) {
            //     if (result.requirementType === 'Sample' && result.sampleRequestData) {
            //         this.recordData = result.sampleRequestData;
            //         console.log('Sample Request Data Set:', this.recordData.Name);
            //     } else if (result.requirementType === 'Quotation' && result.quoteData) {
            //         this.recordData = result.quoteData;
            //         console.log('Quote Data Set:', this.recordData.Name);
            //     }
            // } else {
            //     console.log('Assigned to Dealer - No Sample/Quote created');
            // }
            
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Lead converted successfully!',
                    variant: 'success'
                })
            );
        })
        .catch(error => {
            console.error('Error in conversion:', error);
            console.log('Error details:', JSON.stringify(error));
            this.isConverting = false;
            
            let errorMessage = 'An error occurred during conversion.';
            if (error.body && error.body.message) {
                errorMessage = error.body.message;
            } else if (error.message) {
                errorMessage = error.message;
            }
            
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Conversion Failed',
                    message: errorMessage,
                    variant: 'error'
                })
            );
        });
    }

    handleCloseClick() {
        try {
            console.log('Close button clicked');
            const closeEvent = new CustomEvent('closequickaction');
            this.dispatchEvent(closeEvent);
        } catch (error) {
            console.error('Error in handleCloseClick:', error);
        }
    }

    // COMMENTED OUT - Fallback method not needed anymore since we're not creating Quote/Sample
    // checkData() {
    //     console.log('Fallback checkData method called');
    //     console.log('Account ID:', this.conversionResult.accountId);
    //     console.log('Lead ID:', this.recordId);
    //     
    //     getAccount({ accId: this.conversionResult.accountId, leadId: this.recordId })
    //         .then((result) => {
    //             this.accountData = result;
    //             console.log('Account retrieved:', JSON.stringify(result));
    //             this.owner = result.Owner.Name;
    //         })
    //         .catch((error) => {
    //             console.error('Error getting account:', error);
    //         });
    //         
    //     if (this.conversionResult.contactId) {
    //         getContact({ contactId: this.conversionResult.contactId })
    //             .then((result) => {
    //                 this.contactData = result;
    //                 console.log('Contact retrieved:', JSON.stringify(result));
    //             })
    //             .catch((error) => {
    //                 console.error('Error getting contact:', error);
    //             });
    //     }
    //     
    //     if (!this.isAssignedToDealer) {
    //         if (this.requirementType === 'Sample') {
    //             getSampleRequest({ sampleId: this.conversionResult.sampleRequestId })
    //                 .then((result) => {
    //                     this.recordData = result;
    //                     console.log('Sample Request retrieved:', JSON.stringify(result));
    //                 })
    //                 .catch((error) => {
    //                     console.error('Error getting sample request:', error);
    //                 });
    //         } else if (this.requirementType === 'Quotation') {
    //             getQuote({ quoteId: this.conversionResult.quoteId })
    //                 .then((result) => {
    //                     this.recordData = result;
    //                     console.log('Quote retrieved:', JSON.stringify(result));
    //                 })
    //                 .catch((error) => {
    //                     console.error('Error getting quote:', error);
    //                 });
    //         }
    //     }
    // }

    handleCloseOppClick() {
        try {
            console.log('Close record button clicked');
            const closeEvent = new CustomEvent('closequickaction');
            this.dispatchEvent(closeEvent);
            window.location.reload();
        } catch (error) {
            console.error('Error in handleCloseOppClick:', error);
        }
    }
}