//
//  BLEReadOperation.m
//  SetUpTool
//
//  Created by Stanislav Olekhnovich on 15/04/15.
//  Copyright (c) 2015 Stanislav Olekhnovich. All rights reserved.
//

#import "BLECompoundReadOperation.h"
#import "BLEOperationsManager.h"

@interface BLECompoundReadOperation ()

@property (copy) BLEReadCharacteristicOperationCallback callback;

@end

@implementation BLECompoundReadOperation

#pragma mark - Lifecycle

//**************************************************************************************************
- (instancetype) initWithCentralManager: (CBCentralManager *) centralManager
                             peripheral: (CBPeripheral *) peripheral
                            serviceUuid: (CBUUID *) serviceUuid
                     characteristicUuid: (CBUUID *) characteristicUuid
                             completion: (BLEReadCharacteristicOperationCallback) completion
{
    self = [super initWithCentralManager: centralManager
                              peripheral: peripheral
                             serviceUuid: serviceUuid
                      characteristicUuid: characteristicUuid];
    
    if (self)
    {
        self.callback = completion;
    }
    
    return self;
}

#pragma mark - Private

//**************************************************************************************************
- (void) failWithError: (NSError *) error
{
    if (self.callback)
    {
        self.callback(nil, error);
    }
}

//**************************************************************************************************
- (void) handleCharacteristic: (CBCharacteristic *) characteristic
{
    [self.operationsManager readValueOfCharacteristic: characteristic
                                         onPeripheral: self.peripheral
                                           completion: ^(NSData *value, NSError *error) {
                                               if(!self.callback)
                                               {
                                                   return;
                                               }
                                               if (error || !value)
                                               {
                                                   self.callback(nil, error);
                                               }
                                               else
                                               {
                                                   self.callback(value, nil);
                                               }
                                            }];
}

@end
