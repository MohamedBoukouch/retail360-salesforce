import { LightningElement, api, wire } from 'lwc';

import getCustomer360
    from '@salesforce/apex/Customer360Controller.getCustomer360';

export default class Customer360 extends LightningElement {

    @api recordId;

    customer;
    visits = [];
    opportunities = [];
    cases = [];
    recommendations = [];

    totalVisits = 0;
    purchases = 0;
    totalOpportunityAmount = 0;

    error;
    isLoading = true;


    @wire(getCustomer360, {
        customerId: '$recordId'
    })
    wiredCustomer360({ data, error }) {

        this.isLoading = false;

        if (data) {

            this.customer = data.customer;

            this.visits = data.visits || [];

            this.opportunities =
                data.opportunities || [];

            this.cases =
                data.cases || [];

            this.recommendations =
                data.recommendations || [];

            this.totalVisits =
                data.totalVisits || 0;

            this.purchases =
                data.purchases || 0;

            this.totalOpportunityAmount =
                data.totalOpportunityAmount || 0;

            this.error = undefined;

        } else if (error) {

            this.error = error;

            this.customer = undefined;

            this.visits = [];

            this.opportunities = [];

            this.cases = [];

            this.recommendations = [];
        }
    }


    get customerName() {

        if (!this.customer) {
            return '';
        }

        return this.customer.Name;
    }


    get customerEmail() {

        return this.customer?.Email || '—';
    }


    get customerPhone() {

        return this.customer?.Phone || '—';
    }


    get accountName() {

        return this.customer?.Account?.Name || '—';
    }


    get formattedOpportunityAmount() {

        return new Intl.NumberFormat(
            'en-US',
            {
                style: 'currency',
                currency: 'USD'
            }
        ).format(
            this.totalOpportunityAmount
        );
    }


    get hasVisits() {

        return this.visits.length > 0;
    }


    get hasOpportunities() {

        return this.opportunities.length > 0;
    }


    get hasRecommendations() {

        return this.recommendations.length > 0;
    }


    get hasCases() {

        return this.cases.length > 0;
    }


    get hasError() {

        return this.error != null;
    }
}