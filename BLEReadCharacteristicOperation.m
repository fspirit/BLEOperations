//
//  BLEReadCharacteristicOperation.m
//  SetUpTool
//
//  Created by Stanislav Olekhnovich on 06/04/15.
//  Copyright (c) 2015 Stanislav Olekhnovich. All rights reserved.
//

#import "BLEReadCharacteristicOperation.h"
#import <CoreBluetooth/CoreBluetooth.h>


@interface BLEReadCharacteristicOperation () <CBPeripheralDelegate>

@property (copy) BLEReadCharacteristicOperationCallback callback;
@property CBCharacteristic * characteristic;


@end

@implementation BLEReadCharacteristicOperation

//**************************************************************************************************
- (instancetype) initWithCentralManager: (CBCentralManager *) centralManager
                             peripheral: (CBPeripheral *) peripheral
                                timeout: (NSTimeInterval) timeout
                         characteristic: (CBCharacteristic *) characteristic
                             completion: (BLEReadCharacteristicOperationCallback) completion
{
    if (peripheral == nil || peripheral.state != CBPeripheralStateConnected)
    {
        return nil;
    }
    
    if (completion == nil)
    {
        return nil;
    }
    
    if (characteristic == nil)
    {
        return nil;
    }
    
    self = [super initWithCentralManager: centralManager peripheral: peripheral timeout: timeout];
    
    if (self)
    {
        self.callback = completion;
        self.characteristic = characteristic;
        
        self.peripheral.delegate = self;
    }
    
    return self;

}

//**************************************************************************************************
- (void) dealloc
{
    self.peripheral.delegate = nil;
}

//**************************************************************************************************
- (void) callbackWithError: (NSError *) error
{
    self.callback(nil, error);
}

//**************************************************************************************************
- (void) execute
{
    [self startTimeoutHandler];
    [self.peripheral readValueForCharacteristic: self.characteristic];
}


//**************************************************************************************************
- (BOOL) shouldCancelConnectionOnTimeout
{
    return NO;
}

//**************************************************************************************************
- (void) peripheral: (CBPeripheral *) peripheral didUpdateValueForCharacteristic: (CBCharacteristic *) characteristic
              error: (NSError *) error
{
    [self finishWithCompletion:^{
        if (error != nil)
        {
            self.callback(nil, error);
        }
        else
        {
            self.callback(characteristic.value, nil);
        }
    }];
}

@end
