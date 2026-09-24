import { LightningElement, api, wire, track } from 'lwc';
import getRecommendationsByCustomer from '@salesforce/apex/RecommendationController.getRecommendationsByCustomer';

export default class RecommendationPanel extends LightningElement {
    @api recordId;
    @api customerId;

    @track error;
    isLoading = false;

    recommendations = [];
    filterValue = '';

    statusOptions = [
        { label: 'All', value: '' },
        { label: 'Pending', value: 'PENDING' },
        { label: 'Accepted', value: 'ACCEPTED' },
        { label: 'Rejected', value: 'REJECTED' }
    ];

    @wire(getRecommendationsByCustomer, { customerId: '$effectiveCustomerId' })
    wiredRecommendations({ error, data }) {
        this.isLoading = false;
        if (data) {
            this.recommendations = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.recommendations = [];
        }
    }

    get effectiveCustomerId() {
        return this.customerId || this.recordId;
    }

    get hasRecommendations() {
        return this.recommendations.length > 0;
    }

    get errorMessage() {
        return this.error?.body?.message || 'Error loading recommendations';
    }

    get filteredRecommendations() {
        if (!this.filterValue) {
            return this.recommendations;
        }
        return this.recommendations.filter(rec => rec.Status__c === this.filterValue);
    }

    handleFilterChange(event) {
        this.filterValue = event.detail.value;
    }

    get statusClass() {
        return 'slds-theme_default';
    }
}
