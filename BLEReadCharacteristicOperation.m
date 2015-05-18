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
        
        __weak BLEReadCharacteristicOperation * weakSelf = self;
        self.errorCallback = ^(NSError * error) {
            
            [weakSelf callbackWithError: error result: nil];
        };
    }
    
    return self;

}

//**************************************************************************************************
- (void) callbackWithError: (NSError *) error result: (NSData *) result
{
    if (self.callback)
    {
        self.callback(result, error);
    }
}

//**************************************************************************************************
- (void) execute
{
    [self startTimeoutHandler];
    [self.peripheral readValueForCharacteristic: self.characteristic];
}


//**************************************************************************************************
- (void) peripheral: (CBPeripheral *) peripheral didUpdateValueForCharacteristic: (CBCharacteristic *) characteristic
              error: (NSError *) error
{
    [self finishWithCompletion:^{
        if (error)
        {
            [self callbackWithError: error result: nil];
        }
        else
        {
            [self callbackWithError: nil result: characteristic.value];
        }
    }];
}

@end
