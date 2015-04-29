//
//  BLEConnectPeripheralOperation.h
//  SetUpTool
//
//  Created by Stanislav Olekhnovich on 10/04/15.
//  Copyright (c) 2015 Stanislav Olekhnovich. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BLEOperation_Protected.h"

typedef void(^BLEConnectPeripheralOperationCallback)(NSError * error);

@class CBCentralManager, CBPeripheral;

@interface BLEConnectPeripheralOperation : BLEOperation

- (instancetype) initWithCentralManager: (CBCentralManager *) centralManager
                             peripheral: (CBPeripheral *) peripheral
                                timeout: (NSTimeInterval) timeout
                             completion: (BLEConnectPeripheralOperationCallback) completion;

- (void) start;

@end
