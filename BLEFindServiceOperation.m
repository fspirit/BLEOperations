//
//  BLEFindServiceOperation.m
//  SetUpTool
//
//  Created by Stanislav Olekhnovich on 13/04/15.
//  Copyright (c) 2015 Stanislav Olekhnovich. All rights reserved.
//

#import "BLEFindServiceOperation.h"
#import "BLEOperationErrors.h"

@interface BLEFindServiceOperation () <CBPeripheralDelegate>

@property (copy) BLEFindServiceOperationCallback callback;
@property CBUUID * serviceUuid;

@end

@implementation BLEFindServiceOperation

//**************************************************************************************************
- (instancetype) initWithCentralManager: (CBCentralManager *) centralManager
                             peripheral: (CBPeripheral *) peripheral
                                timeout: (NSTimeInterval) timeout
                            serviceUuid: (CBUUID *) serviceUuid
                             completion: (BLEFindServiceOperationCallback) completion
{
    if (peripheral == nil || peripheral.state != CBPeripheralStateConnected)
    {
        return nil;
    }
    
    if (completion == nil)
    {
        return nil;
    }
    
    if (serviceUuid == nil)
    {
        return nil;
    }
    
    self = [super initWithCentralManager: centralManager peripheral: peripheral timeout: timeout];
    
    if (self)
    {
        self.callback = completion;
        self.serviceUuid = serviceUuid;
        
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
    CBService * sv = [self serviceWithUuid: self.serviceUuid fromPeripheral: self.peripheral];

    if (sv != nil)
    {
        self.callback(sv, nil);
        return;
    }
    
    [self startTimeoutHandler];
    [self.peripheral discoverServices: @[ self.serviceUuid]];
}

//**************************************************************************************************
- (CBService *) serviceWithUuid: (CBUUID *) serviceUuid fromPeripheral: (CBPeripheral *) peripheral
{
    if (peripheral.services == nil)
    {
        return nil;
    }
    
    NSUInteger index = [peripheral.services indexOfObjectPassingTest: ^BOOL(CBService * obj,
                                                                            __unused NSUInteger idx,
                                                                            __unused BOOL *stop)
                        {
                            return [obj.UUID isEqual: serviceUuid];
                        }];
    
    if (index == NSNotFound)
    {
        return nil;
    }
    else
    {
        return peripheral.services[index];
    }
}
//**************************************************************************************************
- (void) peripheral: (CBPeripheral *) peripheral didDiscoverServices: (NSError *) error
{
    [self finishWithCompletion:^{
        if (error != nil)
        {
            self.callback(nil, error);
        }
        else
        {
            CBService * service = [self serviceWithUuid: self.serviceUuid
                                         fromPeripheral: self.peripheral];
            self.callback(service, nil);
        }
    }];
}


//**************************************************************************************************
- (BOOL) shouldCancelConnectionOnTimeout
{
    return NO;
}

@end
