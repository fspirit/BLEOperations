//
//  BLEOperationsManager.m
//  SetUpTool
//
//  Created by Stanislav Olekhnovich on 27/04/15.
//  Copyright (c) 2015 Stanislav Olekhnovich. All rights reserved.
//

#import "BLEOperationsManager.h"
#import "BLEOperationsConstants.h"

#import <CoreBluetooth/CoreBluetooth.h>

const NSTimeInterval kDefaultTimeout = 4.0;
const NSTimeInterval kDefaultConnectTimeout = 10.0;

@interface BLEOperationsManager ()

@property CBCentralManager * centralManager;
@property NSMutableSet * operations;

@end

@implementation BLEOperationsManager

#pragma mark - Lifecycle

//**************************************************************************************************
- (instancetype) initWithCentralManager: (CBCentralManager *) centralManager
{
    NSParameterAssert(centralManager != nil);
    
    self = [super init];
    
    if (self)
    {
        self.centralManager = centralManager;
    }
    
    return self;
}

#pragma mark - Public

//**************************************************************************************************
- (void) connectToPeripheral: (CBPeripheral *) peripheral
                  completion: (BLEConnectPeripheralOperationCallback) completion
{
    if (self.centralManager.state != CBCentralManagerStatePoweredOn)
    {
        return;
    }
    
    NSParameterAssert(peripheral != nil);
    
    __block BLEConnectPeripheralOperation * op = nil;
    op = [[BLEConnectPeripheralOperation alloc] initWithCentralManager: self.centralManager
                                                            peripheral: peripheral
                                                               timeout: kDefaultConnectTimeout
                                                            completion: ^(NSError * error) {
                                                                [self.operations removeObject: op];
                                                                if (completion)
                                                                {
                                                                    completion(error);
                                                                }
                                                            }];
    [self startOperation: op];
}

//**************************************************************************************************
- (void) findServiceWithUuid: (CBUUID *) serviceUuid
                onPeripheral: (CBPeripheral *) peripheral
                  completion: (BLEFindServiceOperationCallback) completion
{
    if (self.centralManager.state != CBCentralManagerStatePoweredOn)
    {
        return;
    }
    
    NSParameterAssert(serviceUuid != nil);
    NSParameterAssert(peripheral != nil);
    
    __block BLEFindServiceOperation * op = nil;
    op = [[BLEFindServiceOperation alloc] initWithCentralManager: self.centralManager
                                                      peripheral: peripheral
                                                         timeout: kDefaultTimeout
                                                     serviceUuid: serviceUuid
                                                      completion: ^(CBService * service, NSError * error) {
                                                            [self.operations removeObject: op];
                                                            if (completion)
                                                            {
                                                                completion(service, error);
                                                            }
                                                      }];
    
    [self startOperation: op];
}

//**************************************************************************************************
- (void) findCharacteristicWithUuid: (CBUUID *) serviceUuid
                          atService: (CBService *) service
                       onPeripheral: (CBPeripheral *) peripheral
                         completion: (BLEFindCharacteristicOperationCallback) completion
{
    if (self.centralManager.state != CBCentralManagerStatePoweredOn)
    {
        return;
    }
    
    NSParameterAssert(serviceUuid != nil);
    NSParameterAssert(service != nil);
    NSParameterAssert(peripheral != nil);
    
    __block BLEFindCharacteristicOperation * op = nil;
    op = [[BLEFindCharacteristicOperation alloc] initWithCentralManager: self.centralManager
                                                             peripheral: peripheral
                                                                timeout: kDefaultConnectTimeout
                                                                service: service
                                                     characteristicUuid: serviceUuid
                                                             completion: ^(CBCharacteristic * characteristic, NSError * error) {
                                                                 [self.operations removeObject: op];
                                                                 if (completion)
                                                                 {
                                                                     completion(characteristic, error);
                                                                 }

                                                             }];
    
    [self startOperation: op];
}

//**************************************************************************************************
- (void) readValueOfCharacteristic: (CBCharacteristic *) characteristic
                      onPeripheral: (CBPeripheral *) peripheral
                        completion: (BLEReadCharacteristicOperationCallback) completion
{
    if (self.centralManager.state != CBCentralManagerStatePoweredOn)
    {
        return;
    }
    
    NSParameterAssert(characteristic != nil);
    NSParameterAssert(peripheral != nil);
    
    __block BLEReadCharacteristicOperation * op = nil;
    op = [[BLEReadCharacteristicOperation alloc] initWithCentralManager: self.centralManager
                                                             peripheral: peripheral
                                                                timeout: kDefaultTimeout
                                                         characteristic: characteristic
                                                             completion: ^(NSData * value, NSError * error) {
                                                                 [self.operations removeObject: op];
                                                                 if (completion)
                                                                 {
                                                                     completion(value, error);
                                                                 }

                                                             }];
    [self startOperation: op];
}

//**************************************************************************************************
- (void) writeValue: (NSData *) data
   toCharacteristic: (CBCharacteristic *) characteristic
       onPeripheral: (CBPeripheral *) peripheral
         completion: (BLEWriteCharacteristicOperationCallback) completion
{
    if (self.centralManager.state != CBCentralManagerStatePoweredOn)
    {
        return;
    }
    
    NSParameterAssert(data != nil);
    NSParameterAssert(characteristic != nil);
    NSParameterAssert(peripheral != nil);
    
    __block BLEWriteCharacteristicOperation * op = nil;
    op = [[BLEWriteCharacteristicOperation alloc] initWithCentralManager: self.centralManager
                                                              peripheral: peripheral
                                                                 timeout: kDefaultTimeout
                                                          characteristic: characteristic
                                                                    data: data
                                                              completion: ^(NSError * error) {
                                                                  [self.operations removeObject: op];
                                                                  if (completion)
                                                                  {
                                                                    completion(error);
                                                                  }
                                                                  
                                                              }];
    [self startOperation: op];
}

//**************************************************************************************************
- (void) readValueOfCharacteristicWithUuid: (CBUUID *) characteristicUuid
                           serviceWithUuid: (CBUUID *) serviceUuid
                              onPeripheral: (CBPeripheral *) peripheral
                                completion: (BLEReadCharacteristicOperationCallback) completion
{
    if (self.centralManager.state != CBCentralManagerStatePoweredOn)
    {
        return;
    }
    
    NSParameterAssert(characteristicUuid != nil);
    NSParameterAssert(serviceUuid != nil);
    NSParameterAssert(peripheral != nil);
    
    __block BLECompoundReadOperation * op = nil;
    op = [[BLECompoundReadOperation alloc] initWithOperationsManager: self
                                                          peripheral: peripheral
                                                         serviceUuid: serviceUuid
                                                  characteristicUuid: characteristicUuid
                                                          completion: ^(NSData *value, NSError *error) {
                                                              [self.operations removeObject: op];
                                                              if (completion)
                                                              {
                                                                  completion(value, error);
                                                              }
                                                              
                                                          }];
    [self startOperation: op];
}

//**************************************************************************************************
- (void) writeValue: (NSData *) data toCharacteristicWithUuid: (CBUUID *) characteristicUuid
  atServiceWithUuid: (CBUUID *) serviceUuid
       onPeripheral: (CBPeripheral *) peripheral
         completion: (BLEWriteCharacteristicOperationCallback) completion
{
    if (self.centralManager.state != CBCentralManagerStatePoweredOn)
    {
        return;
    }
    
    NSParameterAssert(data != nil);
    NSParameterAssert(characteristicUuid != nil);
    NSParameterAssert(serviceUuid != nil);
    NSParameterAssert(peripheral != nil);
    
    __block BLECompoundWriteOperation * op = nil;
    op = [[BLECompoundWriteOperation alloc] initWithOperationsManager: self
                                                           peripheral: peripheral
                                                          serviceUuid: serviceUuid
                                                   characteristicUuid: characteristicUuid
                                                                 data: data
                                                           completion: ^(NSError *error) {
                                                               [self.operations removeObject: op];
                                                               if (completion)
                                                               {
                                                                    completion(error);
                                                               }                                                               
                                                           }];
    [self startOperation: op];
}

#pragma mark - Private


//**************************************************************************************************
- (void) startOperation: (id<BLEOperationProtocol>) op
{
    [self.operations addObject: op];
    
    [op start];
}

@end
