# Apex Dependency Injection

This repository demonstrates [Apex Dependency Injection](https://developer.salesforce.com/blogs/2019/07/breaking-runtime-dependencies-with-dependency-injection) with a sample shipping service (`ShippingService`) that allows to generate tracking numbers.


## Configuration

This sample provides two shipping service mock implementations: `FedExImpl` and `DHLImpl`.

## Usage

The service can be accessed via the `ShippingInjector` class in two ways:

**Option 1: Using the default implementation**

This requires that you set the default service implementation as a `Service_Implementations__mdt` custom metadata record. The `Shipping__c` field of the custom metadata record must map to one of the `ShippingService` implementation class names.

```apex
// Get the implementation of the service configured in Service_Implementations__mdt.Shipping__c custom metadata
ShippingService service = ShippingInjector.getDefaultService(); 
String trackingNumber = service.generateTrackingNumber();
System.debug(trackingNumber); // => DHL-XXXX if DHLImpl is the default
```

**Option 2: Using a specific implementation**

```apex
// Get the FedEx implementation
ShippingService service = ShippingInjector.getService('FedExImpl');
String trackingNumber = service.generateTrackingNumber();
System.debug(trackingNumber); // => FEX-XXXX
```

## Installation

1. Create a scratch org:
    ```sh
    sfdx force:org:create -a apex-di -s -f config/project-scratch-def.json
    ```

1. Push source to scratch org:
    ```sh
    sfdx force:source:push
    ```
