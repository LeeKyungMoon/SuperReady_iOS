//
//  SRDatabase+SRFavoriteMarket.m
//  HaffleMonster
//
//  Created by Fermata on 2015. 7. 8..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "SRDatabase+SRFavoriteMarket.h"

@implementation SRDatabase (SRDBFavoriteMarketAddition)

#pragma mark - Favorite Market Methods

- (NSArray*)favoriteMarkets{
    return [self getAllDataModelsForDataModel:[SRFavoriteMarket class]];
}

- (void)addMarketToFavoriteMarket:(SRMarket*)market{
    SRFavoriteMarket *favoriteMarket = (SRFavoriteMarket*)market;
    [self insertDataModel:favoriteMarket];
}

- (void)removeFavoriteMarket:(SRFavoriteMarket*)market{
    [self removeFavoriteMarket:market];
}

@end
