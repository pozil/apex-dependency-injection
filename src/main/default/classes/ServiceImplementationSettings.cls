public with sharing class ServiceImplementationSettings
{
    @TestVisible
    private static Metadata settings = null;
 
    public static Metadata getInstance()
    {
        if (settings == null)
        {
            List<Service_Implementation__mdt> implementationSettings = [SELECT Shipping__c FROM Service_Implementation__mdt LIMIT 1];
            if (implementationSettings.size() == 0) {
                throw new ServiceMetadataException('Could not find Service_Implementation__mdt');
            }
            settings = new Metadata(implementationSettings.get(0));
        }
        return settings;
    }
 
    public class Metadata
    {
        public String shipping {get; set;}
 
        // Constructor used when creating test values
        public Metadata()
        {
        }
 
        // Construct from a concrete metadata instance
        private Metadata(Service_Implementation__mdt metadata)
        {
            this.shipping = metadata.Shipping__c;
        }
    }
 
    public class ServiceMetadataException extends Exception {}
}