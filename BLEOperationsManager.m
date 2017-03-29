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
@property NSMutableDictionary * operationsMap;

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
        self.operationsMap = [NSMutableDictionary new];
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
    
    NSString * simpleKey = [NSUUID new].UUIDString;
    BLEConnectPeripheralOperation * op =
        [[BLEConnectPeripheralOperation alloc] initWithCentralManager: self.centralManager
                                                            peripheral: peripheral
                                                               timeout: kDefaultConnectTimeout
                                                            completion: ^(NSError * error) {                                                                
                                                                if (completion)
                                                                    completion(error);
                                                                self.operationsMap[simpleKey] = nil;
                                                            }];
    self.operationsMap[simpleKey] = op;
    [op start];
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
    
    NSString * simpleKey = [NSUUID new].UUIDString;
    BLEFindServiceOperation * op =
        [[BLEFindServiceOperation alloc] initWithCentralManager: self.centralManager
                                                     peripheral: peripheral
                                                        timeout: kDefaultTimeout
                                                    serviceUuid: serviceUuid
                                                     completion: ^(CBService * service, NSError * error) {
                                                            if (completion)
                                                                completion(service, error);
                                                            self.operationsMap[simpleKey] = nil;
                                                      }];
    self.operationsMap[simpleKey] = op;
    [op start];
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
    
    NSString * simpleKey = [NSUUID new].UUIDString;
    BLEFindCharacteristicOperation * op =
        [[BLEFindCharacteristicOperation alloc] initWithCentralManager: self.centralManager
                                                             peripheral: peripheral
                                                                timeout: kDefaultConnectTimeout
                                                                service: service
                                                     characteristicUuid: serviceUuid
                                                             completion: ^(CBCharacteristic * characteristic, NSError * error) {
                                                                 if (completion)
                                                                     completion(characteristic, error);
                                                                 self.operationsMap[simpleKey] = nil;
                                                             }];
    
    self.operationsMap[simpleKey] = op;
    [op start];
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
    
    NSString * simpleKey = [NSUUID new].UUIDString;
    BLEReadCharacteristicOperation * op =
        [[BLEReadCharacteristicOperation alloc] initWithCentralManager: self.centralManager
                                                             peripheral: peripheral
                                                                timeout: kDefaultTimeout
                                                         characteristic: characteristic
                                                             completion: ^(NSData * value, NSError * error) {
                                                                 if (completion)
                                                                     completion(value, error);
                                                                 self.operationsMap[simpleKey] = nil;
                                                             }];
    self.operationsMap[simpleKey] = op;
    [op start];
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
    
    NSString * simpleKey = [NSUUID new].UUIDString;
    BLEWriteCharacteristicOperation * op =
        [[BLEWriteCharacteristicOperation alloc] initWithCentralManager: self.centralManager
                                                              peripheral: peripheral
                                                                 timeout: kDefaultTimeout
                                                          characteristic: characteristic
                                                                    data: data
                                                              completion: ^(NSError * error) {
                                                                  if (completion)
                                                                    completion(error);
                                                                  self.operationsMap[simpleKey] = nil;
                                                              }];
    self.operationsMap[simpleKey] = op;
    [op start];

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
    
    NSString * simpleKey = [NSUUID new].UUIDString;
    BLECompoundReadOperation * op =
        [[BLECompoundReadOperation alloc] initWithOperationsManager: self
                                                          peripheral: peripheral
                                                         serviceUuid: serviceUuid
                                                  characteristicUuid: characteristicUuid
                                                          completion: ^(NSData *value, NSError *error) {
                                                              if (completion)
                                                                  completion(value, error);
                                                              self.operationsMap[simpleKey] = nil;
                                                          }];
    self.operationsMap[simpleKey] = op;
    [op start];
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
    
    NSString * simpleKey = [NSUUID new].UUIDString;
    BLECompoundWriteOperation * op =
        [[BLECompoundWriteOperation alloc] initWithOperationsManager: self
                                                           peripheral: peripheral
                                                          serviceUuid: serviceUuid
                                                   characteristicUuid: characteristicUuid
                                                                 data: data
                                                           completion: ^(NSError *error) {
                                                               if (completion)
                                                                    completion(error);
                                                               self.operationsMap[simpleKey] = nil;
                                                           }];
    self.operationsMap[simpleKey] = op;
    [op start];
}

//**************************************************************************************************
- (void) disconnectFromPeripheral: (CBPeripheral *) peripheral
{
    if (peripheral)
        [self.centralManager cancelPeripheralConnection: peripheral];
}

@end
