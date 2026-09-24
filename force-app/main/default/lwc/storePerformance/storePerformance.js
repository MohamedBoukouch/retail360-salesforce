import { LightningElement, wire } from 'lwc';
import getStores from '@salesforce/apex/StorePerformanceController.getStores';

export default class StorePerformance extends LightningElement {

    stores;
    error;

    @wire(getStores)
    wiredStores({ data, error }) {

        if (data) {
            this.stores = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.stores = undefined;
        }
    }

    get hasStores() {
        return this.stores && this.stores.length > 0;
    }

    get hasError() {
        return this.error;
    }
}