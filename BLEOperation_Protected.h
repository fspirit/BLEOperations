//
//  BLEOperation_Protected.h
//  SetUpTool
//
//  Created by Stanislav Olekhnovich on 13/04/15.
//  Copyright (c) 2015 Stanislav Olekhnovich. All rights reserved.
//

#import "BLEOperation.h"

#import <CoreBluetooth/CoreBluetooth.h>

typedef void(^BLEOperationCompletion)(void);
typedef void(^BLEOperationErrorCallback)(NSError * error);

@interface BLEOperation () <CBCentralManagerDelegate>

- (instancetype) initWithCentralManager: (CBCentralManager *) centralManager
                             peripheral: (CBPeripheral *) peripheral
                                timeout: (NSTimeInterval) timeout;

@property CBCentralManager * centralManager;
@property CBPeripheral * peripheral;
@property (assign) NSTimeInterval timeout;

@property (copy) BLEOperationErrorCallback errorCallback;

- (void) failWithError: (NSError *) error;

- (void) startTimeoutHandler;
- (BOOL) stopTimeoutHandler;

- (void) finishWithCompletion: (BLEOperationCompletion) completion;

- (void) execute;

- (BOOL) shouldTimeOut;
- (BOOL) shouldCancelConnectionOnTimeout;



@end
