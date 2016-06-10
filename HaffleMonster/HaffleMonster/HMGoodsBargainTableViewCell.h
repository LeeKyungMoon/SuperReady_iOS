//
//  HMGoodsBargainTableViewCell.h
//  HaffleMonster
//
//  Created by 이경문 on 2015. 3. 31..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Goods.h"

@interface HMGoodsBargainTableViewCell : UITableViewCell {
    IBOutlet UIImageView *saleRateView;
    IBOutlet UILabel *originalPriceLabel;
}
@property (weak, nonatomic) IBOutlet UIImageView *image;
//@property (weak, nonatomic) IBOutlet UILabel *prePrice;
@property (weak, nonatomic) IBOutlet UILabel *postPrice;
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UILabel *itemDescription;
@property (weak, nonatomic) IBOutlet UIView *masterView;
@property (weak, nonatomic) IBOutlet UILabel *timeLeftLabel;
@property NSUInteger itemId;
@property (weak, nonatomic) IBOutlet UIButton *cartButton;
@property (weak, nonatomic) IBOutlet UILabel *priceDescription;
@property (weak, nonatomic) IBOutlet UILabel *eventDescription;
@property SRGood *item;
@property SRCampaign *campaign;


- (void)setSaleRate:(NSUInteger)saleRate;
- (void)setOriginalPrice:(NSUInteger)originalPrice;
- (void)setEventDescriptionText:(NSString*)eventDescriptionText;
@end