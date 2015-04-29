//
//  BLEOperationErrors.m
//  SetUpTool
//
//  Created by Stanislav Olekhnovich on 10/04/15.
//  Copyright (c) 2015 Stanislav Olekhnovich. All rights reserved.
//

#import "BLEOperationErrors.h"

NSString * const kBLEOperationErrorDomain = @"com.forcecube.BLEOperations.ErrorDomain";

const NSInteger kBLEOperationErrorTimedOut = 0;
const NSInteger kBLEOperationErrorBLEIsUnavailable = 3;
const NSInteger kBLEOperationErrorPeripheralDidDisconnect = 4;
const NSInteger kBLEOperationErrorUnableToStartFindServiceOp = 5;
const NSInteger kBLEOperationErrorUnableToStartFindCharacteristicOp = 6;
const NSInteger kBLEOperationErrorUnableToStartReadCharacteristicOp = 7;
const NSInteger kBLEOperationErrorUnableToStartWriteCharacteristicOp = 8;
const NSInteger kBLEOperationErrorServiceNotFound = 9;
const NSInteger kBLEOperationErrorCharacteristicNotFound = 10;

static NSDictionary * codeToMessageMap;

@implementation BLEOperationErrors

+ (void) initialize
{
    codeToMessageMap = @{ @(kBLEOperationErrorTimedOut) :
                              @"Operation did time out",
                          @(kBLEOperationErrorBLEIsUnavailable):
                              @"Bluetooth is unavailable",
                          @(kBLEOperationErrorPeripheralDidDisconnect):
                              @"Peropheral did disconnect during operation",
                          @(kBLEOperationErrorServiceNotFound):
                              @"Unable to find target service on peripheral",
                          @(kBLEOperationErrorCharacteristicNotFound):
                              @"Unable to find target characteristic within target service"};
}

//**************************************************************************************************
+ (NSError *) errorWithCode: (NSInteger) code
{
    return [NSError errorWithDomain: kBLEOperationErrorDomain
                               code: code
                           userInfo: @{ NSLocalizedDescriptionKey: codeToMessageMap[@(code)] } ];
}

//**************************************************************************************************
+ (NSError *) serviceNotFoundError
{
    return [self errorWithCode: kBLEOperationErrorServiceNotFound];
}

//**************************************************************************************************
+ (NSError *) characteristicNotFoundError
{
    return [self errorWithCode: kBLEOperationErrorCharacteristicNotFound];
}

//**************************************************************************************************
+ (NSError *) unableToStartFindServiceOpError
{
    return [self errorWithCode: kBLEOperationErrorUnableToStartFindServiceOp];
}

//**************************************************************************************************
+ (NSError *) unableToStartFindCharacteristicOpError
{
    return [self errorWithCode: kBLEOperationErrorUnableToStartFindCharacteristicOp];
}

//**************************************************************************************************
+ (NSError *) unableToStartReadCharacteristicOpError
{
    return [self errorWithCode: kBLEOperationErrorUnableToStartReadCharacteristicOp];
}

//**************************************************************************************************
+ (NSError *) unableToStartWriteCharacteristicOpError
{
    return [self errorWithCode: kBLEOperationErrorUnableToStartWriteCharacteristicOp];
}

//**************************************************************************************************
+ (NSError *) timeoutError
{
    return [self errorWithCode: kBLEOperationErrorTimedOut];
}

//**************************************************************************************************
+ (NSError *) bleIsUnavailableError
{
    return [self errorWithCode: kBLEOperationErrorBLEIsUnavailable];
}

//**************************************************************************************************
+ (NSError *) peripheralDidDisconnectError
{
    return [self errorWithCode: kBLEOperationErrorPeripheralDidDisconnect];
}

@end