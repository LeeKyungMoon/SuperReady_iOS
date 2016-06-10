//
//  UIView+BorderTools.h
//  HaffleMonster
//
//  Created by Fermata on 2015. 5. 27..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum HCUIBorders {
    HCUIBordersNone = 1 << 0,
    HCUIBordersTop = 1 << 1,
    HCUIBordersLeft = 1 << 2,
    HCUIBordersRight = 1 << 3,
    HCUIBordersBottom = 1 << 4
} HCUIBorders;

@interface UIView(HCUIBorderTools)

- (void)drawBorder:(HCUIBorders)borderOption withColor:(UIColor*)color width:(CGFloat)width;

@end