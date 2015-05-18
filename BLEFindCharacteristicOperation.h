//
//  BLEFindCharacteristicOperation.h
//  SetUpTool
//
//  Created by Stanislav Olekhnovich on 13/04/15.
//  Copyright (c) 2015 Stanislav Olekhnovich. All rights reserved.
//

#import "BLEConnectedOperation.h"

typedef void(^BLEFindCharacteristicOperationCallback)(CBCharacteristic * characteristic, NSError * error);

@interface BLEFindCharacteristicOperation : BLEConnectedOperation

- (instancetype) initWithCentralManager: (CBCentralManager *) centralManager
                             peripheral: (CBPeripheral *) peripheral
                                timeout: (NSTimeInterval) timeout
                                service: (CBService *) service
                     characteristicUuid: (CBUUID *) characteristicUuid
                             completion: (BLEFindCharacteristicOperationCallback) completion;

@end
