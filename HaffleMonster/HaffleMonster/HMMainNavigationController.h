//
//  HMMainNavigationController.h
//  HaffleMonster
//
//  Created by Fermata on 2015. 4. 23..
//  Copyright (c) 2015년 Haffle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMUserCartBarButtonItem.h"
#import "SRDatabase.h"

#define kMainNavigation (HMMainNavigationController*)(self.navigationController)

@interface HMMainNavigationController : UINavigationController <UINavigationControllerDelegate> {
    NSArray *rightButtonItems;
}

@property (nonatomic, strong) HMUserCartBarButtonItem *userCartButton;
- (void)touchedUserCartButton;
- (void)updateCartButton;
@end
