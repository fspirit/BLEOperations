//
//  BLEOperationsManager.h
//  SetUpTool
//
//  Created by Stanislav Olekhnovich on 27/04/15.
//  Copyright (c) 2015 Stanislav Olekhnovich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEConnectPeripheralOperation.h"
#import "BLEFindServiceOperation.h"
#import "BLEFindCharacteristicOperation.h"
#import "BLEReadCharacteristicOperation.h"
#import "BLEWriteCharacteristicOperation.h"
#import "BLECompoundReadOperation.h"
#import "BLECompoundWriteOperation.h"

@class  CBCentralManager, CBPeripheral;

@interface BLEOperationsManager : NSObject

- (instancetype) initWithCentralManager: (CBCentralManager *) centralManager;

// TODO: Add default timeout as prop;
//

@property (readonly) CBCentralManager * centralManager;

- (void) connectToPeripheral: (CBPeripheral *) peripheral
                  completion: (BLEConnectPeripheralOperationCallback) completion;

- (void) findServiceWithUuid: (CBUUID *) serviceUuid
                onPeripheral: (CBPeripheral *) peripheral
                  completion: (BLEFindServiceOperationCallback) completion;

- (void) findCharacteristicWithUuid: (CBUUID *) serviceUuid
                          atService: (CBService *) service
                       onPeripheral: (CBPeripheral *) peripheral
                         completion: (BLEFindCharacteristicOperationCallback) completion;

- (void) readValueOfCharacteristic: (CBCharacteristic *) characteristic
                      onPeripheral: (CBPeripheral *) peripheral
                        completion: (BLEReadCharacteristicOperationCallback) completion;

- (void) writeValue: (NSData *) data
   toCharacteristic: (CBCharacteristic *) characteristic
       onPeripheral: (CBPeripheral *) peripheral
         completion: (BLEWriteCharacteristicOperationCallback) completion;

- (void) readValueOfCharacteristicWithUuid: (CBUUID *) characteristicUuid
                           serviceWithUuid: (CBUUID *) serviceUuid
                              onPeripheral: (CBPeripheral *) peripheral
                                completion: (BLEReadCharacteristicOperationCallback) completion;

- (void) writeValue: (NSData *) data toCharacteristicWithUuid: (CBUUID *) characteristicUuid
  atServiceWithUuid: (CBUUID *) serviceUuid
       onPeripheral: (CBPeripheral *) peripheral
         completion: (BLEWriteCharacteristicOperationCallback) completion;

@end
