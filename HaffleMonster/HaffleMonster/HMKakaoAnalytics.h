//
//  HMKakaoAnalytics.h
//  HaffleMonster
//
//  Created by Fermata on 2015. 5. 25..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "SRLoads.h"

#define kKakaoDistanceFiterSize 500
#define KA [HMKakaoAnalytics manager]
#define SET_KADATA NSDictionary *KAData
#define KADATA KAData
#define SEND_KA_ [[HMKinsightSession shared] addEvent:
#define _EVENT attributes:KAData]

@interface HMKakaoAnalytics : NSObject

@property (nonatomic) BOOL isMartNear;
@property (nonatomic) BOOL isMartFavorite;
@property (nonatomic) NSInteger year;

+ (HMKakaoAnalytics*)manager;
- (NSNumber*)appLaunchCount;
- (NSNumber*)distanceOfMarket:(SRMarket*)market;
- (NSNumber*)distanceOfLocation:(CLLocationCoordinate2D)coordinate1 location:(CLLocationCoordinate2D)coordinate2;
- (NSNumber*)distanceOfLocation:(CLLocationCoordinate2D)coordinate;
- (CLLocationCoordinate2D)userLocationCoordinate;
- (NSString*)userGenderString;
- (NSString*)userBirthYear;
- (NSString*)campaignTypeString:(SRCampaign*)campaign;
- (NSString*)userAddress;
- (NSString*)patternStringForNear:(BOOL)near favorite:(BOOL)favorite;
@end

@interface HMKinsightSession : KinsightSession

@end