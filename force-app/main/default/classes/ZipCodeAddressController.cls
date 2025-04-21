public class ZipCodeAddressController {
    
    @auraEnabled
    public static String zipCodeHandler(String country, String zip){
        Map<String,String> response = ZipCodeAddressHelper.zippopotamusCallout(country,zip);
        if(response.containsKey('Success')){
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.get('Success'));
                if(responseMap.get('country') != 'United States'){
                     response = ZipCodeAddressHelper.updateAddress(response.get('Success'));
                }
        }
        return JSON.serialize(response);
        }
    
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getCountries() {
        List<Map<String, String>> options = new List<Map<String, String>>();
        for (Country__mdt c : [SELECT MasterLabel, Country_Code__c FROM Country__mdt  ORDER BY MasterLabel]) {
            options.add(new Map<String, String>{
                'label' => c.MasterLabel,
                'value' => c.Country_Code__c
            });
        }
        return options;
    }
}