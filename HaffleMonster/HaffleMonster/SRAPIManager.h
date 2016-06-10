//
//  SRAPIManager.h
//  HaffleMonster
//
//  Created by Fermata on 2015. 7. 5..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

#import "SRAPIManager+V1API.h"

#define AFManager [AFHTTPRequestOperationManager manager]

typedef enum SRAPIStatus {
    SRAPIStatusUnknown,
    SRAPIStatusSuccess,
    SRAPIStatusFail,
    SRAPIStatusBusy
} SRAPIStatus;

typedef enum SRRequestMethod {
    SRRequestMethodUnknown,
    SRRequestMethodGET,
    SRRequestMethodPOST
} SRRequestMethod;

@interface SRAPIManager : NSObject

#pragma mark - Singleton Pattern

+ (SRAPIManager*)manager;

#pragma mark - Preparation

- (void)prepareForAPIRequest;

#pragma mark - Useful Methods

+ (SRAPIStatus)statusWithString:(NSString*)status;
- (NSDictionary*)synchronousRequest:(SRRequestMethod)requestMethod url:(NSString*)requestString header:(NSDictionary*)header;

@end


@interface NSString (NSStringSRAPIAdditions)

- (NSString*)SRURL;

@end