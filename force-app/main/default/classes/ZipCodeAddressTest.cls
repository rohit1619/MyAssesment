@isTest
public class ZipCodeAddressTest {

    // Mock response for successful Zippopotamus API call
    public class ZippopotamusSuccessMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody(
                '{' +
                '   "post code": "823001",' +
                '   "country": "India",' +
                '   "places": [{' +
                '       "place name": "Gaya"' +
                '   }]' +
                '}'
            );
            return res;
        }
    }

    // Mock response for error scenario (e.g., zip not found)
    public class ZippopotamusErrorMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(404);
            res.setBody('Not Found');
            return res;
        }
    }

    @isTest
    static void testZipCodeHandler_NonUS_Success() {
        // Register success mock
        Test.setMock(HttpCalloutMock.class, new ZippopotamusSuccessMock());

        Test.startTest();
        String result = ZipCodeAddressController.zipCodeHandler('IN', '823001');
        Test.stopTest();

        System.assertNotEquals(null, result, 'Response should not be null');
        System.assert(result.contains('India'), 'Should contain country name');

        List<Zippopotamus_Response_Address__c> insertedRecords = [
            SELECT Id, Country__c, Zip_Code__c, Places__c FROM Zippopotamus_Response_Address__c
        ];
        System.assertEquals(1, insertedRecords.size(), 'One address record should be inserted');
        System.assertEquals('India', insertedRecords[0].Country__c);
        System.assertEquals('823001', insertedRecords[0].Zip_Code__c);
        System.assertEquals('Gaya', insertedRecords[0].Places__c);
    }

    @isTest
    static void testZipCodeHandler_Error() {
        // Register error mock
        Test.setMock(HttpCalloutMock.class, new ZippopotamusErrorMock());

        Test.startTest();
        String result = ZipCodeAddressController.zipCodeHandler('XX', '000000');
        Test.stopTest();

        System.assert(result.contains('Error'), 'Should contain error message');
    }


    @isTest
    static void testGetCountries() {
        Test.startTest();
        List<Map<String, String>> countries = ZipCodeAddressController.getCountries();
        Test.stopTest();

        System.assert(countries.size() > 0, 'Country list should not be empty');
    }
}