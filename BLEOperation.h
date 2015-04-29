//
//  BLEOperation.h
//  SetUpTool
//
//  Created by Stanislav Olekhnovich on 13/04/15.
//  Copyright (c) 2015 Stanislav Olekhnovich. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBCentralManager, CBPeripheral;

@protocol BLEOperationProtocol <NSObject>

- (void) start;

@end

@interface BLEOperation : NSObject<BLEOperationProtocol>

- (void) start;

@end
