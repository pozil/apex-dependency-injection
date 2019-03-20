@isTest
public class DHLImplTest {
    @isTest static void generateTrackingNumber_works() {
        DHLImpl service = new DHLImpl();

        String trackingNumber = service.generateTrackingNumber();
        
        System.assert(trackingNumber.startsWith('DHL-'));
    }
}
