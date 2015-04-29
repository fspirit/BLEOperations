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

@interface BLEOperation ()

@property (assign) BOOL didTimedOut;

@end

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
        
        self.peripheral = peripheral;
        self.centralManager = centralManager;
        self.timeout = timeout;
        
        
        [self.centralManager addObserver: self
                              forKeyPath: @"state"
                                 options: NSKeyValueObservingOptionNew
                                 context: NULL];
        
        [self.peripheral addObserver: self
                          forKeyPath: @"state"
                             options: NSKeyValueObservingOptionNew
                             context: NULL];
        
    }
    
    return self;
}

//**************************************************************************************************
- (void) dealloc
{
    [self.centralManager removeObserver: self forKeyPath: @"state"];
    [self.peripheral removeObserver: self forKeyPath: @"state"];
}

//**************************************************************************************************
- (void) observeValueForKeyPath: (NSString *) keyPath
                       ofObject: (id) object
                         change: (NSDictionary *) change
                        context: (void *) context
{
    if ([keyPath isEqualToString: @"state"])
    {
        if ([object isEqual: self.centralManager])
        {
            CBCentralManagerState state = [change[NSKeyValueChangeNewKey] integerValue];
            if (state != CBCentralManagerStatePoweredOn)
            {
               [self callbackWithError:  [BLEOperationErrors bleIsUnavailableError]];
            }
        }
        else if ([object isEqual: self.peripheral])
        {
            CBPeripheralState state = [change[NSKeyValueChangeNewKey] integerValue];
            if (state == CBPeripheralStateDisconnected)
            {
                [self callbackWithError: [BLEOperationErrors peripheralDidDisconnectError]];
            }
        }
    }
}

//**************************************************************************************************
- (void) startTimeoutHandler
{
    NSLog(@"Starting timeout handler %@", self);
    
    self.didTimedOut = NO;
    
    [self performSelector: @selector(timeoutHandlerDidFire)
               withObject: nil
               afterDelay: self.timeout];
}

//**************************************************************************************************
- (BOOL) stopTimeoutHandler
{
    NSLog(@"Stopping timeout handler %@", self);
    
    if (self.didTimedOut == YES)
    {
        return NO;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget: self
                                             selector: @selector(timeoutHandlerDidFire)
                                               object: nil];
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
        
        [self callbackWithError: [BLEOperationErrors timeoutError]];
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
    if (self.centralManager.state != CBCentralManagerStatePoweredOn)
    {
        [self callbackWithError: [BLEOperationErrors bleIsUnavailableError]];
    }
    
    [self execute];
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
- (void) centralManager: (CBCentralManager *) central didDisconnectPeripheral: (CBPeripheral *) peripheral
                  error: (NSError *) error
{
    if (error != nil)
    {
        [self callbackWithError: error];
    }
    else
    {
        [self callbackWithError: [BLEOperationErrors peripheralDidDisconnectError]];
    }
}


@end
