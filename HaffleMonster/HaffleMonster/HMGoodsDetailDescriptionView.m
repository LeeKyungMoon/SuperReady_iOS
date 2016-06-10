//
//  HMGoodsDetailDescriptionView.m
//  HaffleMonster
//
//  Created by Fermata on 2015. 4. 16..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMGoodsDetailDescriptionView.h"

@implementation HMGoodsDetailDescriptionView

- (void)layoutSubviews{
    UIColor *borderColor = [UIColor colorWithRed:200/255.0f green:201/255.0f blue:202/255.0f alpha:1];
    [self drawBorder:HCUIBordersTop|HCUIBordersBottom withColor:borderColor width:1];
}

- (id)init{
    self = [[[NSBundle mainBundle] loadNibNamed:@"HMGoodsDetailDescriptionView" owner:nil options:nil] objectAtIndex:0];
    if(self != nil){
        
    }
    return self;
}

@end
