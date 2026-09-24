import { LightningElement, api, wire, track } from 'lwc';
import getPerformancesBySalesRep from '@salesforce/apex/SalesPerformanceController.getPerformancesBySalesRep';
import getPerformancesByStore from '@salesforce/apex/SalesPerformanceController.getPerformancesByStore';

export default class SalesPerformance extends LightningElement {
    @api recordId;
    @api salesRepId;
    @api storeId;
    @api filterBy = 'salesRep';

    @track error;
    isLoading = false;

    performances = [];

    @wire(getPerformancesBySalesRep, { salesRepId: '$effectiveSalesRepId' })
    wiredBySalesRep({ error, data }) {
        if (this.filterBy === 'salesRep') {
            this.isLoading = false;
            if (data) {
                this.performances = data;
                this.error = undefined;
            } else if (error) {
                this.error = error;
                this.performances = [];
            }
        }
    }

    @wire(getPerformancesByStore, { storeId: '$storeId' })
    wiredByStore({ error, data }) {
        if (this.filterBy === 'store') {
            this.isLoading = false;
            if (data) {
                this.performances = data;
                this.error = undefined;
            } else if (error) {
                this.error = error;
                this.performances = [];
            }
        }
    }

    get effectiveSalesRepId() {
        return this.salesRepId || this.recordId;
    }

    get hasPerformances() {
        return this.performances.length > 0;
    }

    get errorMessage() {
        return this.error?.body?.message || 'Error loading performance data';
    }

    formattedCurrency(value) {
        if (value == null) return '—';
        return new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'USD'
        }).format(value);
    }
}
