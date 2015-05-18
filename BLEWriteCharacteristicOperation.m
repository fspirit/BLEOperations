//
//  BLEWriteCharacteristicOperation.m
//  SetUpTool
//
//  Created by Stanislav Olekhnovich on 06/04/15.
//  Copyright (c) 2015 Stanislav Olekhnovich. All rights reserved.
//

#import "BLEWriteCharacteristicOperation.h"

#import <CoreBluetooth/CoreBluetooth.h>

@interface BLEWriteCharacteristicOperation () <CBPeripheralDelegate>

@property (copy, readwrite) BLEWriteCharacteristicOperationCallback callback;
@property NSData * dataToWrite;
@property CBCharacteristic * characteristic;

@end

@implementation BLEWriteCharacteristicOperation

//**************************************************************************************************
- (instancetype) initWithCentralManager: (CBCentralManager *) centralManager
                             peripheral: (CBPeripheral *) peripheral
                                timeout: (NSTimeInterval) timeout
                         characteristic: (CBCharacteristic *) characteristic
                                   data: (NSData *) data
                             completion: (BLEWriteCharacteristicOperationCallback) completion;
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
    
    if (data == nil)
    {
        return nil;
    }
    
    self = [super initWithCentralManager: centralManager peripheral: peripheral timeout: timeout];
    
    if (self)
    {
        self.callback = completion;
        self.characteristic = characteristic;
        self.dataToWrite = data;
        
        __weak BLEWriteCharacteristicOperation * weakSelf = self;
        self.errorCallback = ^(NSError * error) {
            [weakSelf callbackWithError: error];
        };
    }
    
    
    return self;
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
- (void) execute
{
    [self startTimeoutHandler];
    [self.peripheral writeValue: self.dataToWrite
              forCharacteristic: self.characteristic
                           type: CBCharacteristicWriteWithResponse];
}


//**************************************************************************************************
- (BOOL) shouldCancelConnectionOnTimeout
{
    return NO;
}

//**************************************************************************************************
- (void) peripheral: (CBPeripheral *) peripheral didWriteValueForCharacteristic: (CBCharacteristic *) characteristic
              error: (NSError *)error
{
    [self finishWithCompletion:^{
        [self callbackWithError: error];
    }];
}

@end
