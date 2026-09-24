import { LightningElement, wire, track } from 'lwc';
import getFullDashboard from '@salesforce/apex/RetailDashboardController.getFullDashboard';

export default class RetailDashboard extends LightningElement {
    @track error;
    isLoading = true;

    stores = [];
    recentVisits = [];
    recentRecommendations = [];

    @wire(getFullDashboard)
    wiredDashboard({ error, data }) {
        this.isLoading = false;
        if (data) {
            this.stores = data.stores || [];
            this.recentVisits = data.recentVisits || [];
            this.recentRecommendations = data.recentRecommendations || [];
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.stores = [];
            this.recentVisits = [];
            this.recentRecommendations = [];
        }
    }

    get hasStores() {
        return this.stores.length > 0;
    }

    get hasRecentVisits() {
        return this.recentVisits.length > 0;
    }

    get hasRecentRecommendations() {
        return this.recentRecommendations.length > 0;
    }

    get errorMessage() {
        return this.error?.body?.message || 'Error loading dashboard';
    }

    formattedCurrency(value) {
        if (value == null) return '—';
        return new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'USD'
        }).format(value);
    }
}
