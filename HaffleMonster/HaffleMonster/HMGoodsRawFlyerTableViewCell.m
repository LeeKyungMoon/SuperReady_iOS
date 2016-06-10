//
//  HMGoodsRawFlyerTableViewCell.m
//  HaffleMonster
//
//  Created by LKM on 2015. 7. 9..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMGoodsRawFlyerTableViewCell.h"

@implementation HMGoodsRawFlyerTableViewCell

- (void)awakeFromNib {
    // Initialization code
    UIColor *borderColor = [UIColor colorWithRed:200/255.0f green:201/255.0f blue:202/255.0f alpha:1];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [borderColor CGColor];
    self.rawFlyerImageView.layer.borderWidth = 0.5;
    self.rawFlyerImageView.layer.borderColor = [borderColor CGColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
