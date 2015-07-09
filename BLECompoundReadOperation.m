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

#pragma GCC diagnostic ignored "-Wincomplete-implementation"

@implementation BLECompoundReadOperation

#pragma mark - Lifecycle

//**************************************************************************************************
- (instancetype) initWithOperationsManager: (BLEOperationsManager *) operationsManager
                                peripheral: (CBPeripheral *) peripheral
                               serviceUuid: (CBUUID *) serviceUuid
                        characteristicUuid: (CBUUID *) characteristicUuid
                                completion: (BLEReadCharacteristicOperationCallback) completion
{
    self = [super initWithOperationsManager: operationsManager
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
    [self finishOperation];
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
                                               [self finishOperation];
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
