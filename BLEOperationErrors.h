//
//  BLEOperationErrors.h
//  SetUpTool
//
//  Created by Stanislav Olekhnovich on 10/04/15.
//  Copyright (c) 2015 Stanislav Olekhnovich. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kBLEOperationErrorDomain;

extern const NSInteger kBLEOperationErrorTimedOut;
extern const NSInteger kBLEOperationErrorBLEIsUnavailable;
extern const NSInteger kBLEOperationErrorPeripheralDidDisconnect;
extern const NSInteger kBLEOperationErrorUnableToStartFindServiceOp;
extern const NSInteger kBLEOperationErrorUnableToStartFindCharacteristicOp;
extern const NSInteger kBLEOperationErrorUnableToStartReadCharacteristicOp;
extern const NSInteger kBLEOperationErrorUnableToStartWriteCharacteristicOp;
extern const NSInteger kBLEOperationErrorServiceNotFound;
extern const NSInteger kBLEOperationErrorCharacteristicNotFound;

@interface BLEOperationErrors : NSObject

+ (NSError *) timeoutError;
+ (NSError *) bleIsUnavailableError;
+ (NSError *) peripheralDidDisconnectError;
+ (NSError *) serviceNotFoundError;
+ (NSError *) characteristicNotFoundError;

@end

