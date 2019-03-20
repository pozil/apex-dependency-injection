public abstract class ShippingInjector {
    // Eagerly load implementations (this could also be done lazily when service is requested)
    private static final Map<String, Type> implementations = loadImplementations();

    /**
    * Retrieves the default service implementation (the first one configured in the custom settings)
    * @throws UnknownImplementationException if no implementation is configured
    */
    public static ShippingService getDefaultService() {
        if (implementations.size() == 0) {
            throw new UnknownImplementationException('Could not find Shipping default implementation: no implementations configured.');
        }
        Type defaultImp = implementations.values()[0];
        return (ShippingService) defaultImp.newInstance();
    }

    /**
    * Retrieves the specified service implementation
    * @param implName the implementation name without the 'Impl' suffix
    * @throws UnknownImplementationException if requested implementation is not found
    */
    public static ShippingService getService(String implName) {
        if (!implementations.containsKey(implName)) {
            throw new UnknownImplementationException('Unkown Shipping implementation: '+ implName);
        }
        return (ShippingService) implementations.get(implName).newInstance();
    }

    /**
    * Loads shipping service implemenations based on Service_Implementations__c custom settings
    * @returns map of implementation name to class
    * @throws UnknownImplementationException if an implementation is nof found
    * @throws InvalidImplementationException if an implementation class does not implement ShippingService
    */
    @TestVisible
    private static Map<String,Type> loadImplementations() {
        // Get implementation names (DHL, FedEx...)
        List<String> implNames = getImplementationNames();

        // Populate a map of implementation names to concrete implementations
        // using Type.forName for each implementation name
        Map<String,Type> implementations = new Map<String,Type>();
        for (String implName : implNames) {
            String className = implName +'Impl';
            // Attempt to load the implementation class
            Type serviceType = Type.forName(className);
            if (serviceType == null) {
                throw new UnknownImplementationException('Could not load '+ className +' class: class not found');
            }
            // Check that class implements the service interface
            else if (!(serviceType.newInstance() instanceof ShippingService)) {
                throw new InvalidImplementationException('Could not load '+ className +' class: class does not implement ShippingService');
            }
            else {
                // Save implementation
                implementations.put(implName, serviceType);
            }
        }
        return implementations;
    }

    /**
    * Parses Service_Implementations__c custom settings and returns a list of shipping service implemenation names
    * @return list of list of shipping service implemenation names (without Impl suffix)
    */
    @TestVisible
    private static List<String> getImplementationNames() {
        // Retrieve comma delimited list of implementations from a custom setting list
        Service_Implementations__c settings = Service_Implementations__c.getInstance('ShippingImplementations');
        // Parse and populate a list of implementation names (DHL, FedEx...)
        List<String> implNames = new List<String>();
        if (settings != null && settings.Value__c != null) {
            for (String name : settings.Value__c.split(',')) {
                name = name.trim();
                if (name.length() > 0) {
                    implNames.add(name);
                }
            }
        }
        return implNames;
    }

    public class UnknownImplementationException extends Exception {}
    public class InvalidImplementationException extends Exception {}    
}
