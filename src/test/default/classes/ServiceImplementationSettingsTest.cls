@isTest
public class ServiceImplementationSettingsTest {

    @isTest static void getInstance_fails_when_undefined() {
        try {
            ServiceImplementationSettings.getInstance();
            System.assert(false, 'ServiceImplementationSettings.getInstance() should fail when settings is not defined');
        } catch (ServiceImplementationSettings.ServiceMetadataException e) {
            System.assert(true);
        }
    }
}
