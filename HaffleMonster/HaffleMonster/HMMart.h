//
//  HMMart.h
//  HaffleMonster
//
//  Created by 이경문 on 2015. 3. 23..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "HMBrand.h"
#import "HMCampaign.h"
#import "HMNormalCampaign.h"
#import "HMTimesaleCampaign.h"
@class  HMUserCartItem;
@class HMCampaign;
@interface HMMart : NSObject

typedef enum HMMartNameState{
    HMMartNameWithLogo,
    HMMartNameWithBrand,
    HMMartNameWithName
} HMMartNameState;

@property NSUInteger martId; //id
@property NSString *name; //name
@property NSString *phone; //phone
@property NSString *description; //description
@property CLLocationCoordinate2D coordinate; //latitude longitude
@property float latitude;
@property float longitude;
@property NSString *panorama; //panorama
@property NSString *businessHours; // business_hours
@property NSString *logo; //logo
@property HMBrand *brand;
@property NSDate *createdDate;
@property NSUInteger brandId; //id
@property NSString *rawFlyerURLString;

//캠페인 단의 프로퍼티들
@property NSArray *normalParameters;
@property NSArray *timesaleParameters;
@property HMCampaign *normalCampaign;
@property NSMutableArray *normalCampaigns;
@property HMCampaign *timesaleCampaign;
@property NSMutableArray *timesaleCampaigns;
@property NSMutableArray *rawFlyerCampaigns;
@property HMCampaign *rawFlayerCampaign;
@property NSInteger APIstate;

- (void)fillWithDictionary:(NSDictionary*)dictionary;
- (id)initWithDictionary:(NSDictionary*)dictionary;
- (HMMartNameState)stateWithMartName;
- (void)loadCampaignsWithRawDataDictionary:(NSDictionary*)dictionary;
- (id)initWithCartItem:(HMUserCartItem*)cartItem;

@end
