# BLEOperations
Block-based lib, which aims to ease working with BLE peripherals.

## Rationale

To read or write a characteristic of a BLE device, you have to do several operations (given that you've alreade scanned and found the device):
* Connect to a particular peripheral, if it's not already connected
* Find a particular service by uuid
* Find a particular characteristic by uuid
* Read or write to found characteristic

On each stage of this process, several annoying things can happen:
* An operation can take too long (connection attempts never time out, for instance)
* Some CBError can arise
* A connection could be dropped by either side
* Bluetooth can be turned off/disallowed

All the callbacks are sent back via delegate pattern, so you have a bunch CBCentralManagerDelegate and CBPeripheralDelegate methods and have to decide inside of them, what is the operation, which is currently going on and act accordingly.

## Main design idea 

To execute an read/write characteristic operation, you should be able to call one block-based method.
Inside that method, there is a series of BLE operations, all timeout and disconnect events are handled and are posted back via block.

## Example

So, you want to read some characteristic, you've found the peripheral, now

```objc
// Assuming you already have a proper CBCentralManager instance, otherwise, how would you scan
//
BLEOperationsManager * opsManager = [BLEOperationsManager alloc] initWithCentral: self.centralManager];

[opsManager readValueOfCharacteristicWithUuid: [CBUUID UUIDWithString: kChUuid]
                              serviceWithUuid: [CBUUID UUIDWithString: kServiceUuid]
                                 onPeripheral: self.selectedPeripheral
                                   completion: ^(NSData * value, NSError * error) {
                                       if (error)
                                       {
                                           [self handleBleError: error];
                                       }
                                       else if (!value)
                                       {
                                           [self finishBleOperation];
                                       }
                                       else
                                       {
                                           // do whatever we please
                                       }                                       
                                   }];

```



