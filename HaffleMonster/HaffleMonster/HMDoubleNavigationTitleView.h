//
//  HMDoubleNavigationTitleView.h
//  HaffleMonster
//
//  Created by Fermata on 2015. 3. 17..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMDoubleNavigationTitleView : UIView

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *subtitleLabel;

- (void)setTitleText:(NSString*)text;
- (void)setSubtitleText:(NSString*)text;

@end
