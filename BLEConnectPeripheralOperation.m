//
//  BLEConnectPeripheralOperation.m
//  SetUpTool
//
//  Created by Stanislav Olekhnovich on 10/04/15.
//  Copyright (c) 2015 Stanislav Olekhnovich. All rights reserved.
//

#import "BLEConnectPeripheralOperation.h"
#import "BLEOperationErrors.h"

#import <CoreBluetooth/CoreBluetooth.h>

@interface BLEConnectPeripheralOperation () <CBCentralManagerDelegate>

@property (copy) BLEConnectPeripheralOperationCallback callback;

@end

#pragma GCC diagnostic ignored "-Wincomplete-implementation"

@implementation BLEConnectPeripheralOperation

//**************************************************************************************************
- (instancetype) initWithCentralManager: (CBCentralManager *) centralManager
                             peripheral: (CBPeripheral *) peripheral
                                timeout: (NSTimeInterval) timeout
                             completion: (BLEConnectPeripheralOperationCallback) completion
{
    if (completion == nil)
    {
        return nil;
    }
    
    self = [super initWithCentralManager: centralManager peripheral: peripheral timeout: timeout];
    
    if (self)
    {
        
        self.callback = completion;
        
        __weak BLEConnectPeripheralOperation * weakSelf = self;
        self.errorCallback = ^(NSError * error) {
            [weakSelf callbackWithError: error];
        };
    }
    
    return self;
}

//**************************************************************************************************
- (void) execute
{
    if (self.peripheral.state == CBPeripheralStateConnected ||
        self.peripheral.state == CBPeripheralStateConnecting)
    {
        [self callbackWithError: nil];
    }
    else
    {
        [self startTimeoutHandler];
        [self.centralManager connectPeripheral: self.peripheral
                                       options: nil];
    }
}

//**************************************************************************************************
- (void) callbackWithError: (NSError *) error
{
    if (self.callback)
    {
        self.callback(error);
    }
}

//**************************************************************************************************
- (void) centralManager: (CBCentralManager *) central didConnectPeripheral: (CBPeripheral *) peripheral
{
    [self finishWithCompletion:^{
        [self callbackWithError: nil];
    }];
}

//**************************************************************************************************
- (void) centralManager: (CBCentralManager *) central didFailToConnectPeripheral: (CBPeripheral *) peripheral
                  error: (NSError *) error
{
    [self finishWithCompletion:^{
        [self callbackWithError: error];
    }];
}


//**************************************************************************************************
- (BOOL) shouldTimeOut
{
    return (self.peripheral.state != CBPeripheralStateConnected);
}

//**************************************************************************************************
- (BOOL) shouldCancelConnectionOnTimeout
{
    return YES;
}



@end
