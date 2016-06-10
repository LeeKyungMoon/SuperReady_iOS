//
//  SRDefaults.h
//  HaffleMonster
//
//  Created by Fermata on 2015. 7. 15..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "SRDataModelLoads.h"

#define SRUserDefaults [SRDefaults standard]

@interface SRDefaults : NSObject

#pragma mark - Singleton Pattern

+ (SRDefaults*)standard;

#pragma mark - Data

@property (nonatomic) NSString *userToken;
@property (nonatomic) NSString *apnsDeviceToken;
@property (nonatomic) NSUInteger appLaunches;
@property (nonatomic) NSDate *noticeLastUpdate;
@property (nonatomic) BOOL noticeHide;
@property (nonatomic) HMUserGender userGender;
@property (nonatomic) NSUInteger userBirthYear;
@property (nonatomic) BOOL didSubmitUserInformation;
@property (nonatomic) BOOL didSubmitApnsDeviceToken;
@property (nonatomic) BOOL didRegisterUser;
@property (nonatomic) BOOL hasLaunchedOnce;
@property (nonatomic) BOOL isFirstLaunch;
@property (nonatomic) CGFloat lastLatitude;
@property (nonatomic) CGFloat lastLongitude;
@property (nonatomic) NSString *lastAddress;

@end
