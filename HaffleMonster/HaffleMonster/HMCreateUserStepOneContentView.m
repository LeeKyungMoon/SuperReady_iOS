//
//  HMCreateUserStepOneContentView.m
//  HaffleMonster
//
//  Created by 이경문 on 2015. 5. 15..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMCreateUserStepOneContentView.h"

@implementation HMCreateUserStepOneContentView

- (id)init{
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] objectAtIndex:0];
    self.inputView.layer.shadowColor = (__bridge CGColorRef)([UIColor blackColor]);
    self.inputView.layer.shadowOffset = CGSizeMake(0, 2);
    self.inputView.layer.shadowOpacity = 1;
    self.inputView.layer.shadowRadius = 5;
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
