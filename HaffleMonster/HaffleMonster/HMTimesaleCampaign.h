//
//  HMTimesaleCampaign.h
//  HaffleMonster
//
//  Created by 이경문 on 2015. 4. 13..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMItem.h"

@interface HMTimesaleCampaign : NSObject
@property (nonatomic) NSUInteger campaignId;
@property (nonatomic) NSString *campaignName;
@property (nonatomic) NSString *campaignDescription;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;
@property (nonatomic) NSMutableArray *items;

- (id)initWithArray:(NSArray*)array;
@end
