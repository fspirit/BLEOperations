//
//  BLEFindServiceOperation.h
//  SetUpTool
//
//  Created by Stanislav Olekhnovich on 13/04/15.
//  Copyright (c) 2015 Stanislav Olekhnovich. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BLEConnectedOperation.h"

typedef void(^BLEFindServiceOperationCallback)(CBService * service, NSError * error);

@interface BLEFindServiceOperation : BLEConnectedOperation

- (instancetype) initWithCentralManager: (CBCentralManager *) centralManager
                             peripheral: (CBPeripheral *) peripheral
                                timeout: (NSTimeInterval) timeout
                            serviceUuid: (CBUUID *) serviceUuid
                             completion: (BLEFindServiceOperationCallback) completion;

@end
