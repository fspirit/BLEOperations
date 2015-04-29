//
//  BLEReadOperation.h
//  SetUpTool
//
//  Created by Stanislav Olekhnovich on 15/04/15.
//  Copyright (c) 2015 Stanislav Olekhnovich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEReadCharacteristicOperation.h"
#import "BLECompoundOperation_Protected.h"

@interface BLECompoundReadOperation : BLECompoundOperation

- (instancetype) initWithCentralManager: (CBCentralManager *) centralManager
                             peripheral: (CBPeripheral *) peripheral
                            serviceUuid: (CBUUID *) serviceUuid
                     characteristicUuid: (CBUUID *) characteristicUuid
                             completion: (BLEReadCharacteristicOperationCallback) completion;

- (instancetype) initWithOperationsManager: (BLEOperationsManager *) operationsManager
                                peripheral: (CBPeripheral *) peripheral
                               serviceUuid: (CBUUID *) serviceUuid
                        characteristicUuid: (CBUUID *) characteristicUuid
                                completion: (BLEReadCharacteristicOperationCallback) completion;

- (void) start;

@end
