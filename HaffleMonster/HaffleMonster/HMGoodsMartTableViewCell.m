//
//  HMGoodsMartTableViewCell.m
//  HaffleMonster
//
//  Created by 이경문 on 2015. 3. 31..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMGoodsMartTableViewCell.h"

@implementation HMGoodsMartTableViewCell

- (void)layoutSubviews {
    // Initialization code
    UIColor *borderColor = [UIColor colorWithRed:200/255.0f green:201/255.0f blue:202/255.0f alpha:1];
    [self.masterView drawBorder:HCUIBordersTop withColor:borderColor width:0.5];
    [self.masterView drawBorder:HCUIBordersBottom withColor:borderColor width:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
