import { LightningElement, api, wire } from 'lwc';
import getVisit from '@salesforce/apex/CustomerVisitController.getVisit';
import saveVisit from '@salesforce/apex/CustomerVisitController.saveVisit';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class VisitForm extends LightningElement {
    @api recordId;

    error;
    isLoading = false;

    storeName = '';
    customerName = '';
    checkIn = '';
    checkOut = '';
    duration = null;
    purchaseMade = false;
    visitStatus = 'Scheduled';

    visitStatusOptions = [
        { label: 'Scheduled', value: 'Scheduled' },
        { label: 'In Progress', value: 'In Progress' },
        { label: 'Completed', value: 'Completed' },
        { label: 'Cancelled', value: 'Cancelled' }
    ];

    @wire(getVisit, { visitId: '$recordId' })
    wiredVisit({ error, data }) {
        if (data) {
            this.storeName = data.storeName || '';
            this.customerName = data.customerName || '';
            this.checkIn = data.checkIn || '';
            this.checkOut = data.checkOut || '';
            this.duration = data.duration || null;
            this.purchaseMade = data.purchaseMade || false;
            this.visitStatus = data.visitStatus || 'Scheduled';
            this.error = undefined;
        } else if (error) {
            this.error = error.body?.message || 'Error loading visit data';
            this.storeName = '';
            this.customerName = '';
        }
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
        this.checkIn = '';
        this.checkOut = '';
        this.duration = null;
        this.purchaseMade = false;
        this.visitStatus = 'Scheduled';
        this.error = undefined;
    }
}
