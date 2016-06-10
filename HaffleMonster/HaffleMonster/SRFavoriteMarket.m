//
//  SRFavoriteMarket.m
//  HaffleMonster
//
//  Created by Fermata on 2015. 7. 6..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "SRFavoriteMarket.h"

@implementation SRFavoriteMarket

#pragma mark - SuperReady Data Model

SR_Name @"FavoriteMarket" SR_Set
SR_Unique @"marketId" SR_Set
SR_IOTargets @[
    @"marketId",
    @"name",
    @"marketDescription",
    @"phoneNumber",
    @"coordinateLongitde",
    @"panoramaURL",
    @"businessHours",
    @"logoURL",
    @"dataCreatedDate"
] SR_Set

@end
