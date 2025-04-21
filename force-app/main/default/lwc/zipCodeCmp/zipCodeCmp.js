import { LightningElement, track, wire } from 'lwc';
import getZipData from '@salesforce/apex/ZipCodeAddressController.zipCodeHandler';
import getCountries from '@salesforce/apex/ZipCodeAddressController.getCountries';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ZipeCodeCmp extends LightningElement {
    @track zipCode = '';
    @track country = 'US';
    @track countryOptions;
    @track sppiner = false;
    @track isShowModal = false;
    @track responseCountry;
    @track responseZipCode;
    @track places;
    @track isUS = false;
    

    @wire(getCountries)
    wiredCountries({ error, data }) {
        if (data) {
            this.countryOptions = data;
        } else if (error) {
            console.error('Error loading countries', error);
        }
    }

    handleZipChange(event) {
        this.zipCode = event.target.value;
    }

    handleCountryChange(event) {
        this.country = event.target.value;
    }

    handleLookup() {
        this.sppiner = true;
        getZipData({ country: this.country, zip: this.zipCode })
        .then(result => {
            this.country = 'US';
            this.zipCode = '';
            let response = JSON.parse(result);
            if('Success' in response){
                this.showToast('Success','Zip Data Founded Successfully!','success');
                this.sppiner = false;
                let addressValue = JSON.parse(response.Success);
                this.places = addressValue.places;
                this.fixPlaces();
                this.responseZipCode = addressValue['post code'];
                this.responseCountry = addressValue.country;
                if(addressValue.country != 'United States'){
                    this.isShowModal = true;
                }
                else{
                    this.isUS = true;
                }
            }
            else{
                this.showToast('Error','There is something wronge, Please share this issue to your Admin! Message: '+JSON.stringify(response.Error),'error');
                this.sppiner = false;
            }
        })
        .catch(error => {
            this.country = 'US';
            this.zipCode = '';
            this.showToast('Error','There is something wronge, Please share this issue to your Admin! Message: '+JSON.stringify(error),'error');
            this.sppiner = false;
        });
    }

    fixPlaces(){
        let places = this.places;
        for(let i=0;i<places.length;i++){
            places[i].placename =  places[i]['place name'];
            places[i].state =  places[i]['state'];
        }
        this.places = places;
    }

    closeModalBox(){
        this.isShowModal = false;
    }

    showToast(title,message,variant){
        const evt = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant,
        mode: 'dismissable'
    });
    this.dispatchEvent(evt);
    }

}