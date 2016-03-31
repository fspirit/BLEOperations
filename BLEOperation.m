//
//  BLEOperation.m
//  SetUpTool
//
//  Created by Stanislav Olekhnovich on 13/04/15.
//  Copyright (c) 2015 Stanislav Olekhnovich. All rights reserved.
//

#import "BLEOperation_Protected.h"
#import "BLEOperationErrors.h"
#import "BLEOperationsConstants.h"

@interface BLEOperation () <CBCentralManagerDelegate>

@property (assign) BOOL didTimedOut;
@property NSTimer * timeoutTimer;

@end

#pragma GCC diagnostic ignored "-Wincomplete-implementation"
@implementation BLEOperation

//**************************************************************************************************
- (instancetype) initWithCentralManager: (CBCentralManager *) centralManager
                             peripheral: (CBPeripheral *) peripheral
                                timeout: (NSTimeInterval) timeout
{
    if (centralManager == nil)
    {
        return nil;
    }
    if (peripheral == nil)
    {
        return nil;
    }
    if (timeout <= 0)
    {
        return nil;
    }
    
    self = [super init];
    
    if (self)
    {
        self.didTimedOut = NO;

        self.centralManager = centralManager;
        self.centralManager.delegate = self;
        
        self.peripheral = peripheral;
        self.timeout = timeout;
    }
    
    return self;
}

//**************************************************************************************************
- (void) startTimeoutHandler
{
    self.didTimedOut = NO;
    
    self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval: self.timeout
                                                         target: self
                                                       selector: @selector(timeoutHandlerDidFire)
                                                       userInfo: nil
                                                        repeats: NO];
}

//**************************************************************************************************
- (BOOL) stopTimeoutHandler
{
    if (self.didTimedOut == YES)
    {
        return NO;
    }
    
    [self.timeoutTimer invalidate];
    self.timeoutTimer = nil;

    self.didTimedOut = YES;
    
    return YES;
}

//**************************************************************************************************
- (void) timeoutHandlerDidFire
{
    if ([self shouldTimeOut])
    {
        if ([self shouldCancelConnectionOnTimeout])
        {
            [self.centralManager cancelPeripheralConnection: self.peripheral];
        }
        
        self.didTimedOut = YES;
        
        [self failWithError: [BLEOperationErrors timeoutError]];
    }
}

//**************************************************************************************************
- (BOOL) shouldTimeOut
{
    return YES;
}

//**************************************************************************************************
- (void) start
{
    if (self.centralManager.state == CBCentralManagerStatePoweredOn)
    {
        [self execute];
    }
    else
    {
        [self failWithError: [BLEOperationErrors bleIsUnavailableError]];
    }
}

//**************************************************************************************************
- (void) finishWithCompletion: (BLEOperationCompletion) completion
{
    if ([self stopTimeoutHandler])
    {
        completion();
    }    
}

//**************************************************************************************************
- (void) failWithError: (NSError *) error
{
    if (self.errorCallback != nil)
    {
        BLEOperationErrorCallback callback = self.errorCallback;
        self.errorCallback = nil;
        
        callback(error);        
    }
}

//**************************************************************************************************
- (void) centralManagerDidUpdateState: (CBCentralManager *) central
{
    if (central.state != CBCentralManagerStatePoweredOn)
    {
        [self failWithError: [BLEOperationErrors bleIsUnavailableError]];
    }
}

//**************************************************************************************************
- (void) centralManager: (CBCentralManager *) central
didDisconnectPeripheral: (CBPeripheral *) peripheral
                  error: (NSError *) error
{
    [self failWithError: error];
}

//**************************************************************************************************
- (void) centralManager: (CBCentralManager *) central
  didDiscoverPeripheral: (CBPeripheral *) peripheral
      advertisementData: (NSDictionary *) advertisementData
                   RSSI: (NSNumber *) RSSI
{}


@end
