//
//  HMUILabel.m
//  HaffleMonster
//
//  Created by Fermata on 2015. 4. 23..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMUILabel.h"

@implementation HMUILabel

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = UIEdgeInsetsMake(2, 1, 0, 0);
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}


@end
