//
//  BLECompoundWriteOperation.m
//  SetUpTool
//
//  Created by Stanislav Olekhnovich on 15/04/15.
//  Copyright (c) 2015 Stanislav Olekhnovich. All rights reserved.
//

#import "BLECompoundWriteOperation.h"
#import "BLEOperationsManager.h"

@interface BLECompoundWriteOperation ()

@property (copy) BLEWriteCharacteristicOperationCallback callback;
@property NSData * data;

@end

@implementation BLECompoundWriteOperation

- (instancetype) initWithOperationsManager: (BLEOperationsManager *) operationsManager
                                peripheral: (CBPeripheral *) peripheral
                               serviceUuid: (CBUUID *) serviceUuid
                        characteristicUuid: (CBUUID *) characteristicUuid
                                      data: (NSData *) data
                                completion: (BLEWriteCharacteristicOperationCallback) completion
{
    if (!data)
    {
        return nil;
    }
    
    self = [super initWithOperationsManager: operationsManager
                                 peripheral: peripheral
                                serviceUuid: serviceUuid
                         characteristicUuid: characteristicUuid];
    
    if (self)
    {
        self.callback = completion;
        self.data = data;
    }
    
    return self;
}

//**************************************************************************************************
- (void) failWithError: (NSError *) error
{
    self.callback(error);
}

//**************************************************************************************************
- (void) handleCharacteristic: (CBCharacteristic *) characteristic
{
    [self.operationsManager writeValue: self.data
                      toCharacteristic: characteristic
                          onPeripheral: self.peripheral
                            completion: self.callback];
}

@end
