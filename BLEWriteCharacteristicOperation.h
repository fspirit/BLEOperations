//
//  BLEWriteCharacteristicOperation.h
//  SetUpTool
//
//  Created by Stanislav Olekhnovich on 06/04/15.
//  Copyright (c) 2015 Stanislav Olekhnovich. All rights reserved.
//

#import "BLEOperation_Protected.h"

typedef void (^BLEWriteCharacteristicOperationCallback)(NSError * error);

@interface BLEWriteCharacteristicOperation : BLEOperation

- (instancetype) initWithCentralManager: (CBCentralManager *) centralManager
                             peripheral: (CBPeripheral *) peripheral
                                timeout: (NSTimeInterval) timeout
                         characteristic: (CBCharacteristic *) characteristic
                                   data: (NSData *) data
                             completion: (BLEWriteCharacteristicOperationCallback) completion;

@end
