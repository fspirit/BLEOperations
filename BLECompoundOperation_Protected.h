//
//  BLECompoundOperation_Protected.h
//  SetUpTool
//
//  Created by Stanislav Olekhnovich on 15/04/15.
//  Copyright (c) 2015 Stanislav Olekhnovich. All rights reserved.
//

#import "BLECompoundOperation.h"

@class CBCentralManager, CBPeripheral, CBUUID, CBCharacteristic, BLEOperationsManager;

@interface BLECompoundOperation ()

- (instancetype) initWithOperationsManager: (BLEOperationsManager *) operationsManager
                                peripheral: (CBPeripheral *) peripheral
                               serviceUuid: (CBUUID *) serviceUuid
                        characteristicUuid: (CBUUID *) characteristicUuid;

@property CBCentralManager * centralManager;
@property CBPeripheral * peripheral;
@property CBUUID * serviceUuid;
@property CBUUID * characteristicUuid;
@property BLEOperationsManager * operationsManager;

- (void) failWithError: (NSError *) error;
- (void) handleCharacteristic: (CBCharacteristic *) characteristic;

@end
