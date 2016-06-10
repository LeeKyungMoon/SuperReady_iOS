//
//  SRDatabase+SRFavoriteMarket.h
//  HaffleMonster
//
//  Created by Fermata on 2015. 7. 8..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "SRDatabase.h"

@interface SRDatabase (SRDBFavoriteMarketAddition)

- (NSArray*)favoriteMarkets;
- (void)addMarketToFavoriteMarket:(SRMarket*)market;
- (void)removeFavoriteMarket:(SRFavoriteMarket*)market;

@end
