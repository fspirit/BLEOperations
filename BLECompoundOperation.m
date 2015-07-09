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

@interface BLECompoundOperation ()

@property (assign) id<CBCentralManagerDelegate> centralDelegate;

@end

#pragma GCC diagnostic ignored "-Wincomplete-implementation"

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
        self.centralManager = operationsManager.centralManager;
        self.peripheral = peripheral;
        self.serviceUuid = serviceUuid;
        self.characteristicUuid = characteristicUuid;
    }
    
    return self;
}



//**************************************************************************************************
- (void) start
{
    self.centralDelegate = self.centralManager.delegate;
    
    if (self.peripheral.state != CBPeripheralStateConnected)
    {
        [self.operationsManager connectToPeripheral: self.peripheral completion: ^(NSError *error) {
            if (error)
            {
                [self failWithError: error];
            }
            else
            {
                self.didConnectToPeripheral = YES;
                [self findService];
            }
        }];
    }
    else
    {
        self.didConnectToPeripheral = NO;
        [self findService];
    }
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

//**************************************************************************************************
- (void) finishOperation
{
    if (self.didConnectToPeripheral == YES)
    {
        [self.centralManager cancelPeripheralConnection: self.peripheral];
    }
    
    self.centralManager.delegate = self.centralDelegate;
}

@end
