# Apex Dependency Injection

This repository demonstrates Apex Dependency Injection with a sample shipping service that allows to generate tracking numbers.


## Configuration

The sample shipping service provides two mock implementations: FedEx and DHL.<br/>
The service implementations are configured in a `Service_Implementations__c` custom settings list. The `ShippingImplementations` key of the custom settings must map to a comma-delimited list of implementations such as `DHL,FedEx`.<br/>
The injector uses that list to load the service implementation classes with an `Impl` suffix (`DHLImpl` and `FedExImpl`).


## Usage

The service can be accessed via the `ShippingInjector` class in two ways:

**Option 1: Using the default implementation**

```apex
// Get the first implementation configured in Service_Implementations__c custom settings
ShippingService service = ShippingInjector.getDefaultService(); 
// Assuming that the default implementaiton is DHL
String trackingNumber = service.generateTrackingNumber(); // => DHL-XXXX
```

**Option 2: Using a specific implementation**

```apex
// Get the FedEx implementation
ShippingService service = ShippingInjector.getService('FedEx');
String trackingNumber = service.generateTrackingNumber(); // => FEX-XXXX
```

Check out the `ShippingTest` test class for more details on how to use the service.


## Installation

Create a scratch org:<br/>
`sfdx force:org:create -a pattern -s -f config/project-scratch-def.json`

Push source to scratch org:<br/>
`sfdx force:source:push`

Run Apex tests and get code coverage:<br/>
`sfdx force:apex:test:run -c -r human -w 10`
