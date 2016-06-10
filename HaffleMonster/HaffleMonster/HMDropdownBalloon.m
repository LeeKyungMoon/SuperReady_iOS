//
//  HMDropdownBalloon.m
//  HaffleMonster
//
//  Created by Fermata on 2015. 5. 20..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMDropdownBalloon.h"


@implementation HMDropdownBalloon

- (id)init{
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    positions.background = backgroundImageView.frame;
    positions.divider = dividerImageView.frame;
    positions.location = changeLocationButton.frame;
    positions.support = supportButton.frame;
    positions.request = martRequestButton.frame;
    self.displayState = NO;
    return self;
}

- (id)initWithPoint:(CGPoint)point{
    self = [self init];
    if(self != nil){
        CGRect frame = CGRectMake(point.x - positions.background.size.width / 2, point.y, positions.background.size.width, positions.background.size.height);
        [self setFrame:frame];
    }
    return self;
}

- (void)prepareForAnimation{
    CGRect backgroundFrame = CGRectMake(positions.background.origin.x, positions.background.origin.y, positions.background.size.width, positions.background.size.height - 83);
    CGRect locationButtonFrame = CGRectMake(positions.location.origin.x + positions.location.size.width / 2, positions.location.origin.y + positions.location.size.height / 2, 1, 1);
    CGRect supportButtonFrame = CGRectMake(positions.support.origin.x + positions.support.size.width / 2, positions.support.origin.y + positions.support.size.height / 2, 1, 1);
    CGRect requestButtonFrame = CGRectMake(positions.request.origin.x + positions.request.size.width / 2, positions.request.origin.y + positions.request.size.height / 2, 1, 1);
    [backgroundImageView setFrame:backgroundFrame];
    [changeLocationButton setFrame:locationButtonFrame];
    [supportButton setFrame:supportButtonFrame];
    [martRequestButton setFrame:requestButtonFrame];
    [backgroundImageView setAlpha:0];
    [changeLocationButton setAlpha:0];
    [supportButton setAlpha:0];
    [martRequestButton setAlpha:0];
    [dividerImageView setAlpha:0];
}

- (void)showWithAnimation{
    if(self.delegate){
        if([self.delegate respondsToSelector:@selector(balloon:willDismiss:)]){
            [self.delegate balloon:self willShow:YES];
        }
    }
    [UIView animateWithDuration:0.15 animations:^{
        [backgroundImageView setFrame:positions.background];
        [backgroundImageView setAlpha:1];
    }];
    [UIView animateWithDuration:0.15 delay:0.15 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [changeLocationButton setFrame:positions.location];
        [supportButton setFrame:positions.support];
        [dividerImageView setAlpha:1];
        [changeLocationButton setAlpha:1];
        [supportButton setAlpha:1];
        [martRequestButton setFrame:positions.request];
        [martRequestButton setAlpha:1];
    } completion:^(BOOL finished){
        if(self.delegate){
            if([self.delegate respondsToSelector:@selector(balloon:didShow:)]){
                [self.delegate balloon:self didShow:YES];
            }
        }
    }];
    self.displayState = YES;
}

- (void)dismissWithAnimation{
    if(self.delegate){
        if([self.delegate respondsToSelector:@selector(balloon:willDismiss:)]){
            [self.delegate balloon:self willDismiss:YES];
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        [backgroundImageView setAlpha:0];
        [changeLocationButton setAlpha:0];
        [supportButton setAlpha:0];
        [dividerImageView setAlpha:0];
    } completion:^(BOOL finished) {
        if(finished){
            if(self.delegate){
                if([self.delegate respondsToSelector:@selector(balloon:didDismiss:)]){
                    [self.delegate balloon:self didDismiss:YES];
                }
            }
        }
    }];
    self.displayState = NO;
}

- (IBAction)touchedChangeLocationButton:(id)sender{
    if(self.delegate){
        if([self.delegate respondsToSelector:@selector(balloon:didTouchDropdownButtonWithAction:)]){
            [self.delegate balloon:self didTouchDropdownButtonWithAction:HMDropdownBalloonActionChangeLocation];
        }
    }
}

- (IBAction)touchedSupportButton:(id)sender{
    if(self.delegate){
        if([self.delegate respondsToSelector:@selector(balloon:didTouchDropdownButtonWithAction:)]){
            [self.delegate balloon:self didTouchDropdownButtonWithAction:HMDropdownBalloonActionSupport];
        }
    }
}
- (IBAction)touchedMartRequestButton:(id)sender {
    if(self.delegate){
        if([self.delegate respondsToSelector:@selector(balloon:didTouchDropdownButtonWithAction:)]){
            [self.delegate balloon:self didTouchDropdownButtonWithAction:HMDropdownBalloonActionMartRequest];
        }
    }
}

@end
