//
//  BLECompoundOperation.m
//  SetUpTool
//
//  Created by Stanislav Olekhnovich on 15/04/15.
//  Copyright (c) 2015 Stanislav Olekhnovich. All rights reserved.
//

#import "BLECompoundOperation_Protected.h"
#import "BLEOperationErrors.h"
#import "BLEOperationsManager.h"

#import <CoreBluetooth/CoreBluetooth.h>

@implementation BLECompoundOperation

//**************************************************************************************************
- (instancetype) initWithOperationsManager: (BLEOperationsManager *) operationsManager
                                peripheral: (CBPeripheral *) peripheral
                               serviceUuid: (CBUUID *) serviceUuid
                        characteristicUuid: (CBUUID *) characteristicUuid
{
    if (!operationsManager || !peripheral || !serviceUuid || !characteristicUuid)
    {
        return nil;
    }
    
    self = [super init];
    
    if (self)
    {
        self.operationsManager = operationsManager;
        self.peripheral = peripheral;
        self.serviceUuid = serviceUuid;
        self.characteristicUuid = characteristicUuid;
    }
    
    return self;
}



//**************************************************************************************************
- (void) start
{
    [self findService];
}

//**************************************************************************************************
- (void) findService
{
    [self.operationsManager findServiceWithUuid: self.serviceUuid
                                   onPeripheral: self.peripheral
                                     completion: ^(CBService *service, NSError *error) {
                                         if (error)
                                         {
                                             [self failWithError: error];
                                         }
                                         else if (!service)
                                         {
                                             [self failWithError: [BLEOperationErrors serviceNotFoundError]];
                                         }
                                         else
                                         {
                                             [self findCharacteristic: service];
                                         }
                                     }];
}

//**************************************************************************************************
- (void) findCharacteristic: (CBService *) service
{
    [self.operationsManager findCharacteristicWithUuid: self.characteristicUuid
                                             atService: service
                                          onPeripheral: self.peripheral
                                            completion:^(CBCharacteristic *characteristic, NSError *error) {
                                                if (error)
                                                {
                                                    [self failWithError: error];
                                                }
                                                else if (!characteristic)
                                                {
                                                    [self failWithError: [BLEOperationErrors characteristicNotFoundError]];
                                                }
                                                else
                                                {
                                                    [self handleCharacteristic: characteristic];
                                                }
                                            }];
}

@end
