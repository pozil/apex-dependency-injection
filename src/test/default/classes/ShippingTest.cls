@isTest
public class ShippingTest {

    private final static String SETTINGS_VALID_IMPLEMENTATIONS = 'DHL,FedEx';


    private static void setShippingImplementationSetting(String implementations) {
        ServiceImplementationSettings.Metadata settings = new ServiceImplementationSettings.Metadata();
        settings.shipping = implementations;
        ServiceImplementationSettings.settings = settings;
    }

    @isTest static void loadImplementations_works() {
        setShippingImplementationSetting(SETTINGS_VALID_IMPLEMENTATIONS);
        
        Map<String, Type> implMap = ShippingInjector.loadImplementations();

        System.assertEquals(2, implMap.size());
        List<Type> implementations = implMap.values();
        System.assert(implementations[0].newInstance() instanceof DHLImpl);
        System.assert(implementations[1].newInstance() instanceof FedExImpl);
    }

    @isTest static void loadImplementations_fails_with_missing_implementation() {
        setShippingImplementationSetting('Missing');
        
        try {
            ShippingInjector.loadImplementations();
            System.assert(false, 'ShippingInjector.loadImplementations() should fail when implementation is missing');
        } catch (ShippingInjector.UnknownImplementationException e) {
            System.assert(true);
        }
    }

    @isTest static void loadImplementations_fails_with_invalid_implementation() {
        setShippingImplementationSetting('InvalidShipping');
        
        try {
            ShippingInjector.loadImplementations();
            System.assert(false, 'ShippingInjector.loadImplementations() should fail when implementation is invalid');
        } catch (ShippingInjector.InvalidImplementationException e) {
            System.assert(true);
        }
    }

    @isTest static void getDefaultService_works() {
        setShippingImplementationSetting(SETTINGS_VALID_IMPLEMENTATIONS);
        
        ShippingService service = ShippingInjector.getDefaultService();

        System.assert(service instanceof DHLImpl);
    }

    @isTest static void getDefaultService_fails_when_no_implementation_defined() {       
        setShippingImplementationSetting('');

        try {
            ShippingService service = ShippingInjector.getDefaultService();
            System.assert(false, 'ShippingInjector.getDefaultService() should fail when no implementation is defined');
        }
        catch (ShippingInjector.UnknownImplementationException e) {
            System.assert(true);
        }
    }

    @isTest static void getService_works() {
        setShippingImplementationSetting(SETTINGS_VALID_IMPLEMENTATIONS);
        
        ShippingService service = ShippingInjector.getService('FedEx');

        System.assert(service instanceof FedExImpl);
    }

    @isTest static void getService_fails_with_unknown_implementation() {
        setShippingImplementationSetting(SETTINGS_VALID_IMPLEMENTATIONS);

        try {
            ShippingInjector.getService('SomeUnknownImplementation');
            System.assert(false, 'ShippingInjector.getService() should fail with unknonw implementation');
        }
        catch (ShippingInjector.UnknownImplementationException e) {
            System.assert(true);
        }
    }
}
