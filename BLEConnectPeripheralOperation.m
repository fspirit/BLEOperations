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
@property (assign) id<CBCentralManagerDelegate> centralManagerDelegate;

@end

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
        

        self.centralManagerDelegate = self.centralManager.delegate;
        self.centralManager.delegate = self;
        
    }
    
    return self;
}

//**************************************************************************************************
- (void) dealloc
{
    self.centralManager.delegate = self.centralManagerDelegate;
}


//**************************************************************************************************
- (void) execute
{
    if (self.peripheral.state == CBPeripheralStateConnected)
    {
        self.callback(nil);
    }
    else
    {
        [self startTimeoutHandler];
        if (self.peripheral.state == CBPeripheralStateDisconnected)
        {
            [self.centralManager connectPeripheral: self.peripheral
                                           options: nil];
        }
        
    }
}

//**************************************************************************************************
- (void) centralManager: (CBCentralManager *) central didConnectPeripheral: (CBPeripheral *) peripheral
{
    [self finishWithCompletion:^{
        self.callback(nil);
    }];
}

//**************************************************************************************************
- (void) centralManager: (CBCentralManager *) central didFailToConnectPeripheral: (CBPeripheral *) peripheral
                  error: (NSError *) error
{
    [self finishWithCompletion:^{
        self.callback(error);
    }];
}

//**************************************************************************************************
- (void) callbackWithError: (NSError *) error
{
    self.callback(error);
}

//**************************************************************************************************
- (BOOL) shouldTimeOut
{
    return (self.peripheral.state != CBPeripheralStateConnected);
}

//**************************************************************************************************
- (BOOL) shouldCancelConnectionOnTimeout
{
    return  YES;
}



@end
