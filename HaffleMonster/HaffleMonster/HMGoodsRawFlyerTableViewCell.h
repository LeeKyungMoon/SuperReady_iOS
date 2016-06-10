//
//  HMGoodsRawFlyerTableViewCell.h
//  HaffleMonster
//
//  Created by LKM on 2015. 7. 9..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMGoodsRawFlyerTableViewCell : UITableViewCell
@property SRCampaign *campaign;
@property (weak, nonatomic) IBOutlet UIImageView *rawFlyerImageView;
@property SRGood *item;
@end
