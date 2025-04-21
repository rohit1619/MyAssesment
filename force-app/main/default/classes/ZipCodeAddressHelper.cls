public class ZipCodeAddressHelper {

    public static Map<String,String> zippopotamusCallout(String country, String zip){
        Map<String,String> returnValue = new Map<String,String>();
        try{
            Http http = new Http();
            HttpRequest request = generateHttpRequest(country,zip);
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                returnValue.put('Success',response.getBody());
            } else {
                returnValue.put('Error',response.getBody());
            }
        }
        catch(Exception e){
            returnValue.put('Error',JSON.serialize(e));
        }
        return returnValue;
    }

    public static HttpRequest generateHttpRequest(String country, String zip){
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.zippopotam.us/' + country + '/' + zip);
        request.setMethod('GET');
        return request;
    }

    public static Map<String,String> updateAddress(String response){
        Map<String,String> returnValue = new Map<String,String>();
        try{
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response);
            Zippopotamus_Response_Address__c addAddress = new Zippopotamus_Response_Address__c();
            addAddress.Country__c = String.valueOf(responseMap.get('country'));
            addAddress.Zip_Code__c = String.valueOf(responseMap.get('post code'));
            List<object> placesJson = (List<object>) JSON.deserializeUntyped(JSON.serialize(responseMap.get('places')));
            List<String> placesList = new List<String>();
            for(object placeJson:placesJson){
                Map<String, Object> placesMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(placeJson));
                placesList.add(String.valueOf(placesMap.get('place name')));
            }
            String placesStr = string.join(placesList,',');
            addAddress.Places__c = placesStr;
            insert addAddress;
            returnValue.put('Success',response);
        }
        catch(Exception e){
            returnValue.put('Erro',JSON.serialize(e));
            }
            return returnValue;
    }
}