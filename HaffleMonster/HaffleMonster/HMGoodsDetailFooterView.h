//
//  HMGoodsDetailFooterView.h
//  HaffleMonster
//
//  Created by Fermata on 2015. 4. 20..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMDataModel.h"

@interface HMGoodsDetailFooterView : UIView
@property IBOutlet UILabel *impactDescriptionLabel;
@property IBOutlet UILabel *priceLabel;
@property IBOutlet UIButton *kakaoButton;
@property IBOutlet UIButton *userCartButton;
@property IBOutlet UILabel *priceDescriptionLabel;


@property (nonatomic, strong) SRGood *item;
@property NSTimer *timer;
- (void)reloadViewData;
- (NSString *)updateLabel:(id)sender :(NSDate*)endDate :(SRCampaignType)campaignType;
@end
