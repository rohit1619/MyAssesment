import { LightningElement, api} from 'lwc';

export default class ZipCodeUsCmp extends LightningElement {
    @api responseCountry;
    @api responseZipCode;
    @api places;
}