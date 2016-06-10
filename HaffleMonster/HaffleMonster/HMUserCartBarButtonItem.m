//
//  HMUserCartBarButtonItem.m
//  HaffleMonster
//
//  Created by Fermata on 2015. 4. 22..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMUserCartBarButtonItem.h"

@implementation HMUserCartBarButtonItem
@synthesize badgeNumber = _badgeNumber;

- (id)initWithNib{
    UIView *initialView = [[[NSBundle mainBundle] loadNibNamed:@"HMUserCartBarButtonItemView" owner:nil options:nil] firstObject];
    self = [super initWithCustomView:initialView];
    return self;
}

- (id)initWithTarget:(id)target action:(SEL)action{
    self = [self initWithNib];
    if(self != nil){
        self.target = target;
        self.action = action;
        self.style = UIBarButtonItemStylePlain;
        UIView *view = [self valueForKey:@"view"];
        view.frame = CGRectMake(0, 0, 52, 28);
        numberBadgeLabel = [[view subviews] lastObject];
        numberBadgeLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        self.badgeNumber = 0;
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.target action:self.action];
        tapRecognizer.numberOfTapsRequired = 1;
        tapRecognizer.numberOfTouchesRequired = 1;
        [view addGestureRecognizer:tapRecognizer];
    }
    return self;
}

- (CGFloat)estimatedBadgeWidth:(NSUInteger)count{
    if(count < 10){
        return 20;
    }else if(count < 100){
        return 29;
    }else{
        return 38;
    }
}

- (void)setBadgeNumber:(NSUInteger)badgeNumber{
    _badgeNumber = badgeNumber;
    [self performSelectorOnMainThread:@selector(updateViews) withObject:nil waitUntilDone:NO];
}

- (void)updateViews{
    if(_badgeNumber > 0){
        NSString *countString = [NSString stringWithFormat:@"%ld", (unsigned long)_badgeNumber];
        CGFloat estimatedWidth = [self estimatedBadgeWidth:_badgeNumber];
        CGRect badgeFrame = CGRectMake(38 - estimatedWidth, 0, estimatedWidth, 20);
        [numberBadgeLabel setFrame:badgeFrame];
        [numberBadgeLabel setText:countString];
        [numberBadgeLabel setHidden:NO];
    }else{
        [numberBadgeLabel setHidden:YES];
    }
}

- (void)shake{
    CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [anim setToValue:[NSNumber numberWithFloat:-M_PI/16]];
    [anim setFromValue:[NSNumber numberWithDouble:M_PI/16]];
    [anim setDuration:0.05];
    [anim setRepeatCount:4];
    [anim setAutoreverses:YES];
    UIView *view = [self valueForKey:@"view"];
    view.layer.anchorPoint = CGPointMake(0.673,0.5);
    [view.layer addAnimation:anim forKey:@"iconShake"];
}
@end
