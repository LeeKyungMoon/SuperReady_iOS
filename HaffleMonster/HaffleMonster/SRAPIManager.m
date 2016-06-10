//
//  SRAPIManager.m
//  HaffleMonster
//
//  Created by Fermata on 2015. 7. 5..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "SRAPIManager.h"
#import "SRDefaults.h"

@implementation SRAPIManager

#pragma mark - Singleton Pattern

+ (SRAPIManager*)manager{
    static SRAPIManager *manager = nil;
    @synchronized(self) {
        if(manager == nil){
            manager = [[self alloc] init];
            [manager prepareForAPIRequest];
        }
    }
    return manager;
}

#pragma mark - Preparation

- (void)prepareForAPIRequest{
    [AFManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [AFManager.requestSerializer setValue:SRUserDefaults.userToken forHTTPHeaderField:@"X-Auth-Token"];
    [AFManager.requestSerializer setValue:@"540" forHTTPHeaderField:@"X-Timezone-Offset"];
    [AFManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
}

#pragma mark - Useful Methods

+ (SRAPIStatus)statusWithString:(NSString*)status{
    if([status isEqualToString:@"success"]){
        return SRAPIStatusSuccess;
    }
    return SRAPIStatusUnknown;
}

- (NSDictionary*)synchronousRequest:(SRRequestMethod)requestMethod url:(NSString*)requestString header:(NSDictionary*)header{
    NSURL *requestURL = [NSURL URLWithString:requestString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:requestURL];
    NSString *method = nil;
    switch(requestMethod){
        case SRRequestMethodGET:{
            method = @"GET";
            break;
        }
        case SRRequestMethodPOST:{
            method = @"POST";
            break;
        }
        default:{
            return nil;
            break;
        }
    }
    [request setHTTPMethod:method];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    if(header != nil){
        NSEnumerator *enumerator = [header keyEnumerator];
        id key = nil;
        if(key = [enumerator nextObject]){
            [request setValue:[header objectForKey:key] forKey:key];
        }
    }
    NSError *error = nil;
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if(error) return nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    if(error) return nil;
    return json;
}

@end

@implementation NSString (NSStringSRAPIAdditions)

- (NSString*)SRURL{
    return [NSString stringWithFormat:@"%@%@", kHMAPIDefaultURL, self];
}

@end