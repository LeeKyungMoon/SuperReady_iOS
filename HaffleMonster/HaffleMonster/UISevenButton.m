//
// UISevenButton.m
//
// Created by Fermata on 2013. 10. 27..
// Copyright (c) 2013년 Fermata. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSevenButtonBorderWidth 1
#define kSevenButtonCornerRadius 2.5
#define kSevenButtonAnimationDuration 0.2

@interface UISevenButton : UIButton {
    BOOL isFutureDraw;
}
@end

@implementation UISevenButton

-(void)drawRect:(CGRect)rect{
    if(!isFutureDraw){
        self.layer.borderColor = [self.titleLabel.textColor CGColor];
        self.layer.borderWidth = kSevenButtonBorderWidth;
        self.layer.cornerRadius = kSevenButtonCornerRadius;
        self.layer.masksToBounds = YES;
        CGColorRef colorCopy = CGColorCreateCopyWithAlpha([self.titleLabel.textColor CGColor], 0);
        self.layer.backgroundColor = colorCopy;
        CGColorRelease(colorCopy);
        isFutureDraw = true;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [UIView beginAnimations:@"TouchAnimation" context:nil];
    [UIView setAnimationDuration:kSevenButtonAnimationDuration];
    {
        [UIView setAnimationBeginsFromCurrentState:YES];
        CGColorRef colorCopy = CGColorCreateCopyWithAlpha([self.titleLabel.textColor CGColor], 1);
        self.layer.backgroundColor = colorCopy;
        CGColorRelease(colorCopy);
        [self.titleLabel setTextColor:[UIColor whiteColor]];
    }
    [UIView commitAnimations];
}

-(void)endColoring{
    [UIView beginAnimations:@"TouchAnimation" context:nil];
    [UIView setAnimationDuration:kSevenButtonAnimationDuration];
    {
        [UIView setAnimationBeginsFromCurrentState:YES];
        CGColorRef colorCopy = CGColorCreateCopyWithAlpha([self.titleLabel.textColor CGColor], 0);
        self.layer.backgroundColor = colorCopy;
        CGColorRelease(colorCopy);
        [self.titleLabel setTextColor:[UIColor colorWithCGColor:self.layer.borderColor]];
    }
    [UIView commitAnimations];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self endColoring];
    [super touchesEnded:touches withEvent:event];
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self endColoring];
}
@end