@isTest
public class FedExImplTest {
    @isTest static void generateTrackingNumber_works() {
        FedExImpl service = new FedExImpl();

        String trackingNumber = service.generateTrackingNumber();
        
        Assert.isTrue(trackingNumber.startsWith('FEX-'));
    }
}
