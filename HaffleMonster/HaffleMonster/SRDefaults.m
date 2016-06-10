//
//  SRDefaults.m
//  HaffleMonster
//
//  Created by Fermata on 2015. 7. 15..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "SRDefaults.h"

@implementation SRDefaults

@synthesize userToken = _userToken;
@synthesize apnsDeviceToken = _apnsDeviceToken;
@synthesize appLaunches = _appLaunches ;
@synthesize noticeLastUpdate = _noticeLastUpdate;
@synthesize noticeHide = _noticeHide;
@synthesize userGender = _userGender;
@synthesize userBirthYear = _userBirthYear;
@synthesize didSubmitUserInformation = _didSubmitUserInformation;
@synthesize didSubmitApnsDeviceToken = _didSubmitApnsDeviceToken;
@synthesize didRegisterUser = _didRegisterUser;
@synthesize hasLaunchedOnce = _hasLaunchedOnce;
@synthesize isFirstLaunch = _isFirstLaunch;
@synthesize lastLatitude = _lastLatitude;
@synthesize lastLongitude = _lastLongitude;
@synthesize lastAddress = _lastAddress;

#pragma mark - Singleton Pattern

+ (SRDefaults*)standard{
    static SRDefaults *defaults = nil;
    @synchronized(self) {
        if(defaults == nil){
            defaults = [[self alloc] init];
        }
    }
    return defaults;
}

#pragma mark - Synthesized Methods

- (NSString*)userToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [defaults stringForKey:@"UserToken"];
    return value;
}

- (void)setUserToken:(NSString *)userToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:userToken forKey:@"UserToken"];
    [defaults synchronize];
}

- (NSString*)apnsDeviceToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [defaults stringForKey:@"APNSDeviceToken"];
    return value;
}

- (void)setApnsDeviceToken:(NSString *)apnsDeviceToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:apnsDeviceToken forKey:@"APNSDeviceToken"];
    [defaults synchronize];
}

- (NSUInteger)appLaunches{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSUInteger value = [defaults integerForKey:@"AppRunCounts"];
    return value;
}

- (void)setAppLaunches:(NSUInteger)appLaunches{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:appLaunches forKey:@"AppRunCounts"];
    [defaults synchronize];
}

- (NSDate*)noticeLastUpdate{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *value = [defaults objectForKey:@"NoticeLastUpdate"];
    return value;
}

- (void)setNoticeLastUpdate:(NSDate *)noticeLastUpdate{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:noticeLastUpdate forKey:@"NoticeLastUpdate"];
    [defaults synchronize];
}

- (BOOL)noticeHide{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL value = [defaults boolForKey:@"NoticeHide"];
    return value;
}

- (void)setNoticeHide:(BOOL)noticeHide{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:noticeHide forKey:@"NoticeHide"];
    [defaults synchronize];
}

- (HMUserGender)userGender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [defaults stringForKey:@"UserGender"];
    if([value isEqualToString:@"남자"]){
        return HMUserGenderMale;
    }else if([value isEqualToString:@"여자"]){
        return HMUserGenderFemale;
    }else{
        return HMUserGenderNotSelected;
    }
}

- (void)setUserGender:(HMUserGender)userGender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    switch(self.userGender){
        case HMUserGenderMale:{
            [defaults setObject:@"남자" forKey:@"UserGender"];
            break;
        }
        case HMUserGenderFemale:{
            [defaults setObject:@"여자" forKey:@"UserGender"];
            break;
        }
        default:{
            [defaults setObject:@"알수없음" forKey:@"UserGender"];
        }
    }
    [defaults synchronize];
}

- (NSUInteger)userBirthYear{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSUInteger value = [defaults integerForKey:@"UserBirthYear"];
    return value;
}

- (void)setUserBirthYear:(NSUInteger)userBirthYear{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:userBirthYear forKey:@"UserBirthYear"];
    [defaults synchronize];
}

- (BOOL)didSubmitUserInformation{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL value = [defaults boolForKey:@"DidSubmitUserInformation"];
    return value;
}

- (void)setDidSubmitUserInformation:(BOOL)didSubmitUserInformation{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:didSubmitUserInformation forKey:@"NoticeHide"];
    [defaults synchronize];
}

- (BOOL)didSubmitApnsDeviceToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL value = [defaults boolForKey:@"DidSubmitAPNSDeviceToken"];
    return value;
}

- (void)setDidSubmitApnsDeviceToken:(BOOL)didSubmitApnsDeviceToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:didSubmitApnsDeviceToken forKey:@"DidSubmitAPNSDeviceToken"];
    [defaults synchronize];
}

- (BOOL)didRegisterUser{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL value = [defaults boolForKey:@"DidRegisterUser"];
    return value;
}

- (void)setDidRegisterUser:(BOOL)didRegisterUser{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:didRegisterUser forKey:@"DidRegisterUser"];
    [defaults synchronize];
}

- (BOOL)hasLaunchedOnce{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL value = [defaults boolForKey:@"HasLaunchedOnce"];
    return value;
}

- (void)setHasLaunchedOnce:(BOOL)hasLaunchedOnce{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:hasLaunchedOnce forKey:@"HasLaunchedOnce"];
    [defaults synchronize];
}

- (BOOL)isFirstLaunch{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL value = [defaults boolForKey:@"IsFirstLaunched"];
    return value;
}

- (void)setIsFirstLaunch:(BOOL)isFirstLaunch{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isFirstLaunch forKey:@"IsFirstLaunched"];
    [defaults synchronize];
}

- (CGFloat)lastLatitude{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CGFloat value = [defaults floatForKey:@"LastLatitude"];
    return value;
}

- (void)setLastLatitude:(CGFloat)lastLatitude{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:lastLatitude forKey:@"LastLatitude"];
    [defaults synchronize];
}

- (CGFloat)lastLongitude{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CGFloat value = [defaults floatForKey:@"LastLongitude"];
    return value;
}

- (void)setLastLongitude:(CGFloat)lastLongitude{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:lastLongitude forKey:@"LastLongitude"];
    [defaults synchronize];
}

- (NSString*)lastAddress{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [defaults stringForKey:@"LastAddress"];
    return value;
}

- (void)setLastAddress:(NSString *)lastAddress{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:lastAddress forKey:@"LastAddress"];
    [defaults synchronize];
}

@end
