@isTest
public class DHLImplTest {
    @isTest static void generateTrackingNumber_works() {
        DHLImpl service = new DHLImpl();

        String trackingNumber = service.generateTrackingNumber();
        
        Assert.isTrue(trackingNumber.startsWith('DHL-'));
    }
}
