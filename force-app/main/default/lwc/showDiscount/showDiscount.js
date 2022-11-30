import { LightningElement } from 'lwc';
import discount from '@salesforce/apex/Scontistica.getDiscountedOpps'
import allopps from '@salesforce/apex/Scontistica.getOpps'
export default class ShowDiscount extends LightningElement {
    columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Amount', fieldName: 'Amount'}
    ];
    columns2 = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Amount', fieldName: 'Amount'},
        { label: 'Description', fieldName: 'Description'}
    ];
    opps = [];
    todiscount = [];
    discounted = [];
    connectedCallback(){
        this.getOpportunity();
    }

    getOpportunity(){
        allopps().then((result)=>{
            this.opps = result
        });
        
    }

    applyDiscount(){
        var selectedRecords = this.template.querySelector("lightning-datatable").getSelectedRows();
        if(selectedRecords.length > 0){
            this.todiscount=[];
            this.discounted = [];
            selectedRecords.forEach(currentItem => {
                this.todiscount.push(currentItem);
            });
            }
        console.log(this.todiscount);
        discount({opps : this.todiscount}).then((result)=>{
            this.discounted = result
        });
    }
} 