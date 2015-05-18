//
//  BLEWriteCharacteristicOperation.h
//  SetUpTool
//
//  Created by Stanislav Olekhnovich on 06/04/15.
//  Copyright (c) 2015 Stanislav Olekhnovich. All rights reserved.
//

#import "BLEConnectedOperation.h"

typedef void (^BLEWriteCharacteristicOperationCallback)(NSError * error);

@interface BLEWriteCharacteristicOperation : BLEConnectedOperation

- (instancetype) initWithCentralManager: (CBCentralManager *) centralManager
                             peripheral: (CBPeripheral *) peripheral
                                timeout: (NSTimeInterval) timeout
                         characteristic: (CBCharacteristic *) characteristic
                                   data: (NSData *) data
                             completion: (BLEWriteCharacteristicOperationCallback) completion;

@end
