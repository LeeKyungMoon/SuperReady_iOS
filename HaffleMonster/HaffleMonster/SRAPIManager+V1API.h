//
//  SRAPIManager+V1API.h
//  HaffleMonster
//
//  Created by Fermata on 2015. 7. 11..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "SRAPIManager.h"

#import "SRDataModelLoads.h"
#import "SRDefaults.h"

#import "HMServiceUnderConstructionViewController.h"

@interface SRAPIManager (SRAPIV1)

- (void)marketsAtGeoLocation:(CLLocationCoordinate2D)coordinate action:(void(^)(NSArray *markets))action;
- (void)campaignsForMarket:(SRMarket*)market action:(void(^)(NSArray *campaigns))action;
- (void)goodsForCampaign:(SRCampaign*)campaign action:(void(^)(NSArray *goods))action;
- (void)marketWithMarketId:(NSUInteger)marketId action:(void(^)(SRMarket *market))action;
- (void)campaignWithCampaignId:(NSUInteger)campaignId action:(void(^)(SRCampaign *campaign))action;
- (void)goodWithGoodId:(NSUInteger)goodId action:(void(^)(SRGood *good))action;
- (void)submitUserInformationWithBirthYear:(NSUInteger)birthYear gender:(HMUserGender)gender completion:(void(^)(BOOL success))completion;
- (void)enterApp;
- (void)registerUser;
- (void)blockGlobalAppAccess:(NSString*)message;

@end
