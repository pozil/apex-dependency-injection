public abstract class ShippingInjector {
    /**
    * Retrieves the default service implementation as configured in
    * the Service_Implementation__mdt custom metadata type
    * @throws ServiceMetadataException if custom metadata is not correctly set
    * @throws UnknownImplementationException if configured service name is not found
    */
    public static ShippingService getDefaultService() {
        String defaultServiceName = getDefaultServiceName();
        return getService(defaultServiceName);
    }

    /**
    * Retrieves the specified service implementation
    * @param serviceName the service implementation class name
    * @throws UnknownImplementationException if requested implementation is not found
    * @return an instance of the service
    */
    public static ShippingService getService(String serviceName) {
        Set<String> shippingServicesNames = getImplementationNames();
        if (!shippingServicesNames.contains(serviceName)) {
            throw new UnknownImplementationException('Could not find shipping service implementation: '+ serviceName +'.');
        }
        Type serviceType = Type.forName(serviceName);
        return (ShippingService) serviceType.newInstance();
    }

    /**
    * Retrieve the names of all classes that implement the ShippingService interface
    * @return set of class names that implement ShippingService
    */
    public static Set<String> getImplementationNames() {
        Set<String> implNames = new Set<String>();
        for (ApexTypeImplementor implementor : [
                SELECT ClassName
                FROM ApexTypeImplementor 
                WHERE InterfaceName = 'ShippingService' AND IsConcrete=true
                ]) {
            implNames.add(implementor.ClassName);
        }
        return implNames;
    }

    private static String getDefaultServiceName() {
        List<Service_Implementation__mdt> implementationSettings = Service_Implementation__mdt.getAll().values();
        if (implementationSettings.size() == 0) {
            throw new ServiceMetadataException('Could not find a Service_Implementation__mdt record');
        }
        if (implementationSettings.size() > 1) {
            throw new ServiceMetadataException('Found more than one Service_Implementation__mdt record');
        }
        return implementationSettings.get(0).Shipping__c;
    }

    public class UnknownImplementationException extends Exception {}
    public class ServiceMetadataException extends Exception {}
}
