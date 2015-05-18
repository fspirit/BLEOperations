//
//  BLEConnectedOperation.m
//  SetUpTool
//
//  Created by Stanislav Olekhnovich on 05/05/15.
//  Copyright (c) 2015 Stanislav Olekhnovich. All rights reserved.
//

#import "BLEConnectedOperation.h"
#import "BLEOperationErrors.h"

@interface  BLEConnectedOperation () <CBPeripheralDelegate>

@end

@implementation BLEConnectedOperation

//**************************************************************************************************
- (instancetype) initWithCentralManager: (CBCentralManager *) centralManager
                             peripheral: (CBPeripheral *) peripheral
                                timeout: (NSTimeInterval) timeout
{
    if (centralManager == nil)
    {
        return nil;
    }
    if (peripheral == nil)
    {
        return nil;
    }
    
    if (timeout <= 0)
    {
        return nil;
    }
    
    self = [super initWithCentralManager: centralManager peripheral: peripheral timeout: timeout];
    
    if (self)
    {
        self.peripheral.delegate = self;
    }
    
    return self;
}

//**************************************************************************************************
- (BOOL) shouldCancelConnectionOnTimeout
{
    return NO;
}

@end
