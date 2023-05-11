@isTest
public class ShippingInjectorTest {

    private final static Set<String> IMPLEMENTATION_NAMES = new Set<String>{'DHLImpl','FedExImpl'};

    @isTest
    static void getDefaultService_works() {
        ShippingService service = ShippingInjector.getDefaultService();
        Assert.isInstanceOfType(service, DHLImpl.class, 'Expected DHLImpl');
    }

    @isTest
    static void getService_works() {
        String serviceName = IMPLEMENTATION_NAMES.iterator().next();
        ShippingService service = ShippingInjector.getService(serviceName);
    }

    @isTest
    static void getService_fails_when_invalid_serviceName() {
        try {
            ShippingInjector.getService('InvalidService');
            Assert.fail('Expected UnknownImplementationException');
        } catch (Exception e) {
            Assert.isInstanceOfType(e, ShippingInjector.UnknownImplementationException.class, 'Expected an UnknownImplementationException');
        }
    }

    @isTest
    static void getImplementationNames_works() {
        Set<String> shippingServicesNames = ShippingInjector.getImplementationNames();
        Assert.areEqual(IMPLEMENTATION_NAMES, shippingServicesNames);
    }
}
