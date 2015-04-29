//
//  BLEFindCharacteristicOperation.m
//  SetUpTool
//
//  Created by Stanislav Olekhnovich on 13/04/15.
//  Copyright (c) 2015 Stanislav Olekhnovich. All rights reserved.
//

#import "BLEFindCharacteristicOperation.h"

@interface BLEFindCharacteristicOperation () <CBPeripheralDelegate>

@property (copy) BLEFindCharacteristicOperationCallback callback;
@property CBUUID * characteristicUuid;
@property CBService * service;

@end

@implementation BLEFindCharacteristicOperation

//**************************************************************************************************
- (instancetype) initWithCentralManager: (CBCentralManager *) centralManager
                             peripheral: (CBPeripheral *) peripheral
                                timeout: (NSTimeInterval) timeout
                                service: (CBService *) service
                     characteristicUuid: (CBUUID *) characteristicUuid
                             completion: (BLEFindCharacteristicOperationCallback) completion
{
    if (peripheral == nil || peripheral.state != CBPeripheralStateConnected)
    {
        return nil;
    }
    
    if (completion == nil)
    {
        return nil;
    }
    
    if (service == nil)
    {
        return nil;
    }
    
    if (characteristicUuid == nil)
    {
        return nil;
    }
    
    self = [super initWithCentralManager: centralManager peripheral: peripheral timeout: timeout];
    
    if (self)
    {
        self.callback = completion;
        self.characteristicUuid = characteristicUuid;
        self.service = service;
        
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
    CBCharacteristic * ch = [self characteristicWithUuid: self.characteristicUuid
                                             fromService: self.service];
    if (ch != nil)
    {
        self.callback(ch, nil);
        return;
    }
    
    [self startTimeoutHandler];
    [self.peripheral discoverCharacteristics: @[ self.characteristicUuid ] forService: self.service];
}

//**************************************************************************************************
- (CBCharacteristic *) characteristicWithUuid: (CBUUID *) serviceUuid fromService: (CBService *) service
{
    NSUInteger index = [service.characteristics indexOfObjectPassingTest: ^BOOL(CBCharacteristic * obj,
                                                                                __unused NSUInteger idx,
                                                                                __unused BOOL *stop) {
        return [obj.UUID isEqual: self.characteristicUuid];
    }];
    
    if (index == NSNotFound)
    {
        return nil;
    }
    return service.characteristics[index];
}

//**************************************************************************************************
- (void) peripheral: (CBPeripheral *) peripheral didDiscoverCharacteristicsForService: (CBService *) service
              error: (NSError *) error
{
    [self finishWithCompletion:^{
        if (error != nil)
        {
            self.callback(nil, error);
        }
        else
        {
            CBCharacteristic * ch = [self characteristicWithUuid: self.characteristicUuid
                                                    fromService: service];
            self.callback(ch, nil);
        }
    }];
}

//**************************************************************************************************
- (BOOL) shouldCancelConnectionOnTimeout
{
    return NO;
}


@end
