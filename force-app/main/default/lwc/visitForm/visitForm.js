import { LightningElement, api, wire, track } from 'lwc';
import getVisit from '@salesforce/apex/CustomerVisitController.getVisit';
import searchStores from '@salesforce/apex/CustomerVisitController.searchStores';
import searchCustomers from '@salesforce/apex/CustomerVisitController.searchCustomers';
import saveVisit from '@salesforce/apex/CustomerVisitController.saveVisit';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class VisitForm extends LightningElement {
    @api recordId;

    error;
    isLoading = false;

    storeId = null;
    storeName = '';
    storeSearchTerm = '';
    storeOptions = [];
    showStoreOptions = false;

    customerId = null;
    customerName = '';
    customerSearchTerm = '';
    customerOptions = [];
    showCustomerOptions = false;

    checkIn = '';
    checkOut = '';
    duration = null;
    purchaseMade = false;
    visitStatus = 'IN_PROGRESS';

    visitStatusOptions = [
        { label: 'In Progress', value: 'IN_PROGRESS' },
        { label: 'Completed', value: 'COMPLETED' },
        { label: 'Cancelled', value: 'CANCELLED' }
    ];

    @wire(getVisit, { visitId: '$recordId' })
    wiredVisit({ error, data }) {
        if (data) {
            this.storeId = data.storeId || null;
            this.storeName = data.storeName || '';
            this.customerId = data.customerId || null;
            this.customerName = data.customerName || '';
            this.checkIn = data.checkIn || '';
            this.checkOut = data.checkOut || '';
            this.duration = data.duration || null;
            this.purchaseMade = data.purchaseMade || false;
            this.visitStatus = data.visitStatus || 'IN_PROGRESS';
            this.error = undefined;
        } else if (error) {
            this.error = error.body?.message || 'Error loading visit data';
            this.storeName = '';
            this.customerName = '';
        }
    }

    handleStoreChange(event) {
        this.storeSearchTerm = event.detail.value;
        this.showStoreOptions = this.storeSearchTerm.length >= 2;
        if (this.showStoreOptions) {
            searchStores({ searchTerm: this.storeSearchTerm })
                .then(result => {
                    this.storeOptions = result;
                })
                .catch(error => {
                    this.storeOptions = [];
                });
        }
    }

    handleStoreSelect(event) {
        this.storeId = event.currentTarget.dataset.id;
        this.storeName = event.currentTarget.dataset.name;
        this.storeSearchTerm = '';
        this.showStoreOptions = false;
        this.storeOptions = [];
    }

    handleCustomerChange(event) {
        this.customerSearchTerm = event.detail.value;
        this.showCustomerOptions = this.customerSearchTerm.length >= 2;
        if (this.showCustomerOptions) {
            searchCustomers({ searchTerm: this.customerSearchTerm })
                .then(result => {
                    this.customerOptions = result;
                })
                .catch(error => {
                    this.customerOptions = [];
                });
        }
    }

    handleCustomerSelect(event) {
        this.customerId = event.currentTarget.dataset.id;
        this.customerName = event.currentTarget.dataset.name;
        this.customerSearchTerm = '';
        this.showCustomerOptions = false;
        this.customerOptions = [];
    }

    handleCheckInChange(event) {
        this.checkIn = event.detail.value;
    }

    handleCheckOutChange(event) {
        this.checkOut = event.detail.value;
    }

    handleDurationChange(event) {
        this.duration = event.detail.value ? Number(event.detail.value) : null;
    }

    handlePurchaseMadeChange(event) {
        this.purchaseMade = event.detail.checked;
    }

    handleVisitStatusChange(event) {
        this.visitStatus = event.detail.value;
    }

    handleSave() {
        this.isLoading = true;
        this.error = undefined;

        saveVisit({
            visitId: this.recordId,
            storeId: this.storeId,
            customerId: this.customerId,
            checkIn: this.checkIn,
            checkOut: this.checkOut,
            duration: this.duration,
            purchaseMade: this.purchaseMade,
            visitStatus: this.visitStatus
        })
            .then(result => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Visit Recorded',
                        message: this.recordId
                            ? 'Visit updated successfully.'
                            : 'Visit saved successfully.',
                        variant: 'success'
                    })
                );

                this.dispatchEvent(
                    new CustomEvent('visitsaved', {
                        detail: { recordId: result }
                    })
                );
            })
            .catch(error => {
                this.error = error.body?.message || 'Error saving visit';
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: this.error,
                        variant: 'error'
                    })
                );
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    handleReset() {
        this.storeName = '';
        this.customerName = '';
        this.checkIn = '';
        this.checkOut = '';
        this.duration = null;
        this.purchaseMade = false;
        this.visitStatus = 'IN_PROGRESS';
        this.error = undefined;
    }
}
