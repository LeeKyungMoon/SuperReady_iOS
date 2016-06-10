//
//  HMDoubleNavigationTitleView.m
//  HaffleMonster
//
//  Created by Fermata on 2015. 3. 17..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import "HMDoubleNavigationTitleView.h"

@implementation HMDoubleNavigationTitleView

- (id)init{
    self = [super init];
    if(self != nil){
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] objectAtIndex:0];
    }
    return self;
}

- (void)setTitleText:(NSString*)text{
    self.titleLabel.text = text;
}

- (void)setSubtitleText:(NSString*)text{
    self.subtitleLabel.text = text;
}

@end
