//
//  BLECompoundWriteOperation.h
//  SetUpTool
//
//  Created by Stanislav Olekhnovich on 15/04/15.
//  Copyright (c) 2015 Stanislav Olekhnovich. All rights reserved.
//

#import "BLECompoundOperation_Protected.h"
#import "BLEWriteCharacteristicOperation.h"

@interface BLECompoundWriteOperation : BLECompoundOperation

- (instancetype) initWithOperationsManager: (BLEOperationsManager *) operationsManager
                                peripheral: (CBPeripheral *) peripheral
                               serviceUuid: (CBUUID *) serviceUuid
                        characteristicUuid: (CBUUID *) characteristicUuid
                                      data: (NSData *) data
                                completion: (BLEWriteCharacteristicOperationCallback) completion;

@end
