//
//  HMHomeGPSTableViewCell.m
//  HaffleMonster
//
//  Created by LKM on 2015. 3. 16..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMHomeGPSTableViewCell.h"

@implementation HMHomeGPSTableViewCell

- (void)layoutSubviews{
    UIColor *borderColor = [UIColor colorWithRed:200/255.0f green:201/255.0f blue:202/255.0f alpha:1];
    [self.contentView drawBorder:HCUIBordersTop|HCUIBordersBottom withColor:borderColor width:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
