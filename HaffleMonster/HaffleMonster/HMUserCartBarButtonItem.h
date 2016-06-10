//
//  HMUserCartBarButtonItem.h
//  HaffleMonster
//
//  Created by Fermata on 2015. 4. 22..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMUILabel.h"

@interface HMUserCartBarButtonItem : UIBarButtonItem {
    HMUILabel *numberBadgeLabel;
}

@property (nonatomic) NSUInteger badgeNumber;

- (id)initWithTarget:(id)target action:(SEL)action;
- (void)updateViews;
- (void)shake;
@end
