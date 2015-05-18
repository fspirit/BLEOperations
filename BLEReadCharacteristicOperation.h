//
//  BLEReadCharacteristicOperation.h
//  SetUpTool
//
//  Created by Stanislav Olekhnovich on 06/04/15.
//  Copyright (c) 2015 Stanislav Olekhnovich. All rights reserved.
//

#import "BLEConnectedOperation.h"

typedef void (^BLEReadCharacteristicOperationCallback)(NSData * value, NSError * error);

@interface BLEReadCharacteristicOperation : BLEConnectedOperation

- (instancetype) initWithCentralManager: (CBCentralManager *) centralManager
                             peripheral: (CBPeripheral *) peripheral
                                timeout: (NSTimeInterval) timeout
                         characteristic: (CBCharacteristic *) characteristic
                             completion: (BLEReadCharacteristicOperationCallback) completion;

@end
