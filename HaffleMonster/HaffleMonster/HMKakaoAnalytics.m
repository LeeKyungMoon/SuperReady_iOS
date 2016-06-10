//
//  HMKakaoAnalytics.m
//  HaffleMonster
//
//  Created by Fermata on 2015. 5. 25..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMKakaoAnalytics.h"


@implementation HMKakaoAnalytics

+ (HMKakaoAnalytics*)manager{
    static HMKakaoAnalytics *manager = nil;
    @synchronized(self) {
        if(manager == nil){
            manager = [[self alloc] init];
        }
    }
    return manager;
}

- (id)init{
    self = [super init];
    if(self != nil){
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
        self.year = [components year];
    }
    return self;
}

- (CLLocationCoordinate2D)userLocationCoordinate{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults floatForKey:@"LastLatitude"]){
        return CLLocationCoordinate2DMake([defaults floatForKey:@"LastLatitude"], [defaults floatForKey:@"LastLongitude"]);
    }else{
        return CLLocationCoordinate2DMake(0, 0);
    }
}

- (NSNumber*)appLaunchCount{
    return @(SRUserDefaults.appLaunches);
}

- (NSNumber*)distanceOfMarket:(SRMarket*)market{
    return [self distanceOfLocation:market.coordinate location:[self userLocationCoordinate]];
}

- (NSNumber*)distanceOfLocation:(CLLocationCoordinate2D)coordinate{
    return [self distanceOfLocation:coordinate location:[self userLocationCoordinate]];
}

- (NSNumber*)distanceOfLocation:(CLLocationCoordinate2D)coordinate1 location:(CLLocationCoordinate2D)coordinate2{
    CLLocation *myLocation = [[CLLocation alloc] initWithLatitude:coordinate1.latitude longitude:coordinate1.longitude];
    CLLocation *martLocation = [[CLLocation alloc] initWithLatitude:coordinate2.latitude longitude:coordinate2.longitude];
    CLLocationDistance distance = [myLocation distanceFromLocation:martLocation];
    
    int roundedValue = distance / kKakaoDistanceFiterSize;
    int distanceLost = (int)distance % kKakaoDistanceFiterSize;
    if(distanceLost >= (kKakaoDistanceFiterSize / 2)) {
        roundedValue++;
    }
    roundedValue = roundedValue * kKakaoDistanceFiterSize;
    return [NSNumber numberWithInt:roundedValue];
}

- (NSString*)userGenderString{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults stringForKey:@"UserGender"] != nil){
        return [defaults stringForKey:@"UserGender"];
    }else{
        return @"알수없음";
    }
}

- (NSString*)userBirthYear{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults integerForKey:@"UserBirthYear"]){
        NSInteger birthYear = [defaults integerForKey:@"UserBirthYear"];
        birthYear = self.year - birthYear + 1;
        if(birthYear < 10){
            return @"10대 미만";
        }
        if(birthYear >= 60){
            return @"10대 이상";
        }
        NSInteger birthYearLast = birthYear % 10;
        NSInteger birthYearFront = birthYear / 10;
        birthYearFront *= 10;
        NSString *suffix;
        if(birthYearLast < 3){
            suffix = @"초반";
        }else if(birthYearLast < 7){
            suffix = @"중반";
        }else{
            suffix = @"후반";
        }
        return [NSString stringWithFormat:@"%ld대 %@", birthYearFront, suffix];
    }else{
        return @"알수없음";
    }
}

- (NSString*)campaignTypeString:(SRCampaign*)campaign{
    if(campaign == nil) return @"알수없음";
    if(campaign.type == SRCampaignTypeBig){
        return @"큰카드";
    }else if(campaign.type == SRCampaignTypeSmall){
        return @"작은카드";
    }else{
        return @"일반";
    }
}

- (NSString*)userAddress{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults stringForKey:@"LastAddress"] != nil){
        return [defaults stringForKey:@"LastAddress"];
    }else{
        return @"현재 지역명을 알 수 없습니다";
    }
}

- (NSString*)patternStringForNear:(BOOL)near favorite:(BOOL)favorite{
    if(near && favorite) return @"관심-근처";
    if(near) return @"근처";
    if(favorite) return @"관심";
    return @"알수없음";
}

@end

@implementation HMKinsightSession : KinsightSession

+ (KinsightSession *)shared{
    if(kUseKakaoAnalytics){
        return [KinsightSession shared];
    }else{
        static HMKinsightSession *session = nil;
        @synchronized(self){
            if(session == nil){
                session = [[self alloc] init];
            }
        }
        return session;
    }
}

- (void)resume{

}
- (void)close{
    
}
- (void)addEvent:(NSString *)event{
    
}
- (void)addEvent:(NSString *)event attributes:(NSDictionary *)attributes{

}
- (void)tagScreen:(NSString *)screen{
    
}
- (void)initialize{
    
}

@end