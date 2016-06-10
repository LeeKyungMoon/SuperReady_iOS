//
//  UIView+BorderTools.m
//  HaffleMonster
//
//  Created by Fermata on 2015. 5. 27..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "UIView+BorderTools.h"

@implementation UIView(HCUIBorderTools)

- (void)drawBorder:(HCUIBorders)borderOption withColor:(UIColor*)color width:(CGFloat)width{
    if(borderOption & HCUIBordersTop){
        CALayer *border = [CALayer layer];
        border.backgroundColor = color.CGColor;
        
        border.frame = CGRectMake(0, 0, self.frame.size.width, width);
        [self.layer insertSublayer:border atIndex:(unsigned int)[self.layer.sublayers count]];
    }
    if(borderOption & HCUIBordersLeft){
        CALayer *border = [CALayer layer];
        border.backgroundColor = color.CGColor;
        
        border.frame = CGRectMake(0, 0, width, self.frame.size.height);
        [self.layer insertSublayer:border atIndex:(unsigned int)[self.layer.sublayers count]];

    }
    if(borderOption & HCUIBordersRight){
        CALayer *border = [CALayer layer];
        border.backgroundColor = color.CGColor;
        
        border.frame = CGRectMake(self.frame.size.width - width, 0, width, self.frame.size.height);
        [self.layer insertSublayer:border atIndex:(unsigned int)[self.layer.sublayers count]];
    }
    if(borderOption & HCUIBordersBottom){
        CALayer *border = [CALayer layer];
        border.backgroundColor = color.CGColor;
        
        border.frame = CGRectMake(0, self.frame.size.height - width, self.frame.size.width, width);
        [self.layer insertSublayer:border atIndex:(unsigned int)[self.layer.sublayers count]];
    }
}



@end
