//
//  HMAPIRequestManager.h
//  HaffleMonster
//
//  Created by 이경문 on 2015. 3. 23..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "HMDataModel.h"
#import "HMServiceUnderConstructionViewController.h"

typedef enum HMAPIState{
    HMAPIStateUnknown,
    HMAPIStateSuccess,
    HMAPIStateEmpty
} HMAPIState;

@interface UIImageView (AFNetworkingAddtions)
- (void)setImageWithURLCached:(NSString *)urlString placeholderImage:(UIImage*)placeholderImage;
- (void)setImageWithURLCached:(NSString *)urlString completed:(void(^)(UIImage *image))completed;
@end

@interface NSString (NSStringHMAPIAdditions)
- (NSString*)HMURL;
- (NSDate*)DateFromISODate;
@end

@interface NSDate (NSDateHMAPIAdditions)
- (NSString*)ISODateRepresentation;
@end

@interface HMAPIRequestManager : NSObject

@property (nonatomic, strong)  NSNumber *launchCount;
+ (HMAPIRequestManager*)manager;
+ (HMAPIRequestManager*)managerWithURLString:(NSString*)urlString;
+ (BOOL)isConnectedWithURLString:(NSString*)urlString;
+ (BOOL)isConnected;
- (void)loadLocationMartsWithLocationCoorindate:(CLLocationCoordinate2D)locationCoordinate action:(void(^)(HMLocationMarts *marts, NSError *error))action;
- (void)loadCampaignsForMart:(HMMart*)mart action:(void(^)(NSError *error))action;
- (void)goodsForCampaign:(HMCampaign*)campaign action:(void(^)(void))action;
- (HMAPIState)stateWithString:(NSString*)state;
- (void)submitUserInformationWithBirthYear:(NSUInteger)birth gender:(HMUserGender)gender completion:(void(^)(BOOL success))completion;

- (void)martWithMartId:(NSUInteger)martId action:(void(^)(HMMart *mart))action;

+ (NSString*)deviceId;
+ (NSString*)userId;
+ (NSString*)userToken;
+ (void)generateAndRegisterDeviceId;
+ (void)generateUserTokenAndRegisterDeviceId;
+ (void)notifyEnterance;
+ (BOOL)shouldRequestUserInformation;
+ (BOOL)shouldAllowAppAccess;
@end
