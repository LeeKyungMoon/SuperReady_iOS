//
//  HMHomeTableViewCell.h
//  HaffleMonster
//
//  Created by Fermata on 2015. 7. 15..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SRLoads.h"

@protocol HMHomeTableViewCellDelegate <NSObject>

- (void)didPressRemoveFromFavoriteMarketButton:(SRFavoriteMarket*)market;
- (void)didPressAddToFavoriteMarketButton:(SRMarket*)market;

@end

@interface HMHomeTableViewCell : UITableViewCell {
    IBOutlet UIImageView *martImageView;
    IBOutlet UILabel *nameLabel;
    IBOutlet UIView *masterView;
    IBOutlet UIButton *favoriteButton;
}

@property (nonatomic, retain) id<HMHomeTableViewCellDelegate> delegate;
@property (nonatomic) SRMarket *market;

@end
